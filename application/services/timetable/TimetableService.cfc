component {
	/**
	 * @classSessionService.inject ClassSessionService
	 * @dateConversionService.inject DateConversionService
	 * @websiteLoginService.inject WebsiteLoginService
	 * @timeslotService.inject TimeslotService
	 * @lecturerService.inject LecturerService
	 * @generationRequestObject.inject presidecms:object:generation_request
	**/
	public any function init(
		  required ClassSessionService   classSessionService
		, required DateConversionService dateConversionService
		, required WebsiteLoginService   websiteLoginService
		, required TimeslotService       timeslotService
		, required LecturerService       lecturerService
		, required generation_request    generationRequestObject
	){
		_setClassSessionService( classSessionService );
		_setDateConversionService( dateConversionService );
		_setWebsiteLoginService( websiteLoginService );
		_setTimeslotService( timeslotService );
		_setLecturerService( lecturerService );
		_setGenerationRequestObject( generationRequestObject );

		return this;
	}

	public array function getTimetableArray(){
		var userId = _getLogggedInUserId();
		var selectFields = [
			"generation_request.id"
			, "generation_request.label AS name"
			, "generation_request.datecreated AS requestDatetime"
			, "generation_request.completion_timestamp AS completionDatetime"
			, "generation_request.status"
		];
		var timetableQuery = _getGenerationRequestObject().findByUserId( selectFields=selectFields, userId=userId );
		var timetableArray = [];

		for ( var timetable in timetableQuery ) {
			timetableArray.append( timetable );
		}

		return timetableArray;
	}

	public array function generateTimetable( required struct generationRequest ){
		if ( !isGenerationRequestDataValid( generationRequest ) ) {
			return;
		}

		var generationRequestId       = _createGenerationRequest( generationRequest );
		var dateOfWeek                = parseDateTime( generationRequest.dateOfWeek );
		var startDate                 = _getDateConversionService().getFirstDayOfWeek( dateOfWeek );
		var endDate                   = _getDateConversionService().getLastDayOfWeek( dateOfWeek );
		var classSessionArray         = _getClassSessionService().getAssignableClassSessionArray( startDate, endDate );
		var timeslotArray             = _getTimeslotService().getTimeslotArray();
		var assignedClassSessionArray = [];

		for ( var classSession in classSessionArray ){
			var assignedClassSession = {};

			for ( var i=1; i<=7; i++ ) {
				if ( !_isDayApplicable( classSession, i ) ) {
					continue;
				}

				var classSessionDate = startDate.add( "d", i );
				var classSessionDetailsComplete = false;

				writeDump(classSessionDate);
				for ( var timeslot in _getAvailbleTimeslots( timeslotArray, classSession ) ) {
					if ( !_isTimeslotAvailable( assignedClassSessionArray, classSession, timeslot, classSessionDate ) ) {
						continue;
					}

					assignedClassSession.timeslot = timeslot;
					assignedClassSession.venueId = _getAvailableVenueId( 
						  classSession
						, timeslot
						, classSessionDate
						, assignedClassSessionArray
					);
					assignedClassSession.lecturerId = _getAvailableLecturerId(
						classSession
						, timeslot
						, assignedClassSessionArray
						, classSessionDate
					);


					if ( assignedClassSession.venueId.len()==0 || assignedClassSession.lecturerId.len()==0 ) {
						structDelete( assignedClassSession, "timeslot" );
						structDelete( assignedClassSession, "venueId" );
						structDelete( assignedClassSession, "lecturerId" );
					} else {
						classSessionDetailsComplete = true;
						break;
					}
				}

				if ( classSessionDetailsComplete ) {
					assignedClassSession.intakeId = classSession.intakeId;
					assignedClassSession.courseId = classSession.courseId;
					assignedClassSession.moduleId = classSession.moduleId;
					assignedClassSession.classTypeId = classSession.classTypeId;
					assignedClassSession.date = classSessionDate;
					assignedClassSessionArray.append( assignedClassSession );
					break;
				}
			}
		}

		var processedClassSessionArray = [];

		for ( assignedClassSession in assignedClassSessionArray ) {
			var classSessionId = _getClassSessionService().addClassSession( assignedClassSession, generationRequestId );
			var processedClassSession = _getClassSessionService().getClassSessionById( classSessionId );

			processedClassSessionArray.append( processedClassSession );
		}

		_getGenerationRequestObject().updateData(
			  data = { "status"="Completed", "completion_timestamp"=now() }
			, id   = generationRequestId
		);

		return processedClassSessionArray;
	}

	public boolean function isGenerationRequestDataValid( required struct generationRequest ){
		if ( trim ( generationRequest.name?:"" ).len()==0 ) {
			return false;
		}

		if ( !isDate( generationRequest.dateOfWeek?:"" ) ) {
			return false;
		}

		if ( _getLogggedInUserId().len()==0 ) {
			return false;
		}

		return true;
	}

	private boolean function _isTimeslotAvailable(
		  required array assignedClassSessionArray
		, required struct classSession
		, required struct timeslot
		, required date classSessionDate
	){
		for ( var assignedClassSession in assignedClassSessionArray ) {
			if ( assignedClassSession.date!=classSessionDate ) {
				continue;
			}

			if ( !_getClassSessionService().isSameGroupOfStudent( classSession, assignedClassSession ) ) {
				continue;
			}

			if ( _getTimeslotService().isTimeslotsOverlapped( timeslot, assignedClassSession.timeslot ) ) {
				return false;
			}
		}

		return true;
	}

	private string function _getAvailableLecturerId(
		  required struct classSession
		, required struct timeslot
		, required array assignedClassSessionArray
		, required date classSessionDate
	){
		var lecturerIdArray = _getLecturerService().getLecturersByCourseIdAndModuleId(
			  moduleId    = classSession.moduleId
			, classTypeId = classSession.classTypeId
		);

		for ( var lecturerId in lecturerIdArray ) {
			var validLecturer = true;

			for ( var assignedClassSession in assignedClassSessionArray ) {
				if (
					   assignedClassSession.date==classSessionDate
					&& assignedClassSession.lecturerId==lecturerId
					&& _getTimeslotService().isTimeslotsOverlapped( assignedClassSession.timeslot, timeslot )
				) {
					validLecturer = false;
					break;
				}
			}

			if ( validLecturer ) {
				return lecturerId;
			}
		}
		writeDump("no valid lecturer found");
		return "";
	}

	private string function _getAvailableVenueId(
		  required struct classSession
		, required struct timeslot
		, required date classSessionDate
		, required array assignedClassSessionArray
	){
		for ( var venue in classSession.applicableVenues ) {
			if ( !_isVenueOccupied( classSessionDate, timeslot, venue.id, assignedClassSessionArray ) ) {
				return venue.id;
			}
		}

		return "";
	}

	private boolean function _isVenueOccupied(
		  required date classSessionDate
		, required struct timeslot
		, required string venueId
		, required array assignedClassSessionArray
	){
		for ( var classSession in assignedClassSessionArray ) {
			if (
				   classSessionDate == classSession.date
				&& venueId          == classSession.venueId
				&& _getTimeslotService().isTimeslotsOverlapped( timeslot, classSession.timeslot )
			) {
				return true;
			}
		}

		return false;
	}

	private array function _getAvailbleTimeslots( required array timeslotArray, required struct classSession ){
		var availableTimeslots = [];

		for ( var timeslot in timeslotArray ) {
			var dateDifferenceInMinutes = _getDateConversionService().getDateDifferenceInMinutes(
				  timeslot.startTime
				, timeslot.endTime
			);

			if (
				   timeslot.startTime      >= classSession.assignTimeRangeStart
				&& timeslot.endTime        <= classSession.assignTimeRangeEnd
				&& dateDifferenceInMinutes >= classSession.durationInMinutes
			) {
				availableTimeslots.append( timeslot );
			}
		}

		return availableTimeslots;
	}

	private boolean function _isDayApplicable( required struct classSession, required numeric dayNumber ){
		switch ( dayNumber ) {
			case 1:
				return classSession.applicableToSunday    ?: false;
			case 2:
				return classSession.applicableToMonday    ?: false;
			case 3:
				return classSession.applicableToTuesday   ?: false;
			case 4:
				return classSession.applicableToWednesday ?: false;
			case 5:
				return classSession.applicableToThursday  ?: false;
			case 6:
				return classSession.applicableToFriday    ?: false;
			case 7:
				return classSession.applicableToSaturday  ?: false;
			default:
				return false;
		}
	}

	private string function _createGenerationRequest( required struct generationRequest ){
		var generationRequestData = {
			  "label"        = generationRequest.name
			, "date_of_week" = generationRequest.dateOfWeek
			, "status"       = "Generating"
			, "website_user" = _getLogggedInUserId()
		}

		return _getGenerationRequestObject().insertData( data=generationRequestData );
	}

	private void function _setClassSessionService( required ClassSessionService classSessionService ){
		variables._classSessionService = classSessionService;
	}

	private ClassSessionService function _getClassSessionService(){
		return variables._classSessionService;
	}

	private void function _setDateConversionService( required DateConversionService dateConversionService ){
		variables._dateConversionService = dateConversionService;
	}

	private DateConversionService function _getDateConversionService(){
		return variables._dateConversionService;
	}

	private void function _setTimeslotService( required TimeslotService timeslotService ){
		variables._timeslotService = timeslotService;
	}

	private TimeslotService function _getTimeslotService(){
		return variables._timeslotService;
	}

	private void function _setLecturerService( required LecturerService lecturerService ){
		variables._lecturerService = lecturerService;
	}

	private LecturerService function _getLecturerService(){
		return variables._lecturerService;
	}

	private void function _setGenerationRequestObject( required generation_request generationRequestObject ){
		variables._generationRequestObject = generationRequestObject;
	}

	private generation_request function _getGenerationRequestObject(){
		return variables._generationRequestObject;
	}

	private string function _getLogggedInUserId(){
		return _getWebsiteLoginService().getLoggedInUserId();
	}

	private void function _setWebsiteLoginService( required WebsiteLoginService websiteLoginService ){
		variables._websiteLoginService = websiteLoginService;
	}

	private WebsiteLoginService function _getWebsiteLoginService(){
		return variables._websiteLoginService;
	}
}