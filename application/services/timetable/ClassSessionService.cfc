component {
	/**
	 * @intakeObject.inject        presidecms:object:intake
	 * @courseObject.inject        presidecms:object:course
	 * @moduleObject.inject        presidecms:object:module
	 * @classTypeObject.inject     presidecms:object:class_type
	 * @venueObject.inject         presidecms:object:venue
	 * @classSessionObject.inject  presidecms:object:class_session
	 * @websiteLoginService.inject WebsiteLoginService
	**/
	public ClassSessionService function init(
		  required intake              intakeObject
		, required course              courseObject
		, required module              moduleObject
		, required class_type          classTypeObject
		, required venue               venueObject
		, required class_session       classSessionObject
		, required WebsiteLoginService websiteLoginService
	){
		_setIntakeObject( intakeObject );
		_setCourseObject( courseObject );
		_setModuleObject( moduleObject );
		_setClassTypeObject( classTypeObject );
		_setVenueObject( venueObject );
		_setClassSessionObject( classSessionObject );
		_setWebsiteLoginService( websiteLoginService );

		return this;
	}

	public string function addClassSession( required struct classSessionStruct, required string generationRequestId ){
		var classSessionData = _processClassSessionData( classSessionStruct, generationRequestId );

		return _getClassSessionObject().insertData( data=classSessionData );
	}

	private struct function _processClassSessionData( required struct classSession, required string generationRequestId ){
		return {
			  "session_date"       = classSession.date        ?: ""
			, "intake"             = classSession.intakeId    ?: ""
			, "course"             = classSession.courseId    ?: ""
			, "module"             = classSession.moduleId    ?: ""
			, "class_type"         = classSession.classTypeId ?: ""
			, "lecturer"           = classSession.lecturerId  ?: ""
			, "timeslot"           = classSession.timeslot.id ?: ""
			, "venue"              = classSession.venueId     ?: ""
			, "generation_request" = generationRequestId      ?: ""
			, "is_published"       = "0"
		};
	}

	public struct function getClassSessionById( required string classSessionId ){
		var selectFields      = [
			  "session_date                                                             AS date"
			, "intake.label                                                             AS intakeName"
			, "course.label                                                             AS courseName"
			, "module.label                                                             AS moduleName"
			, "class_type.label                                                         AS classTypeName"
			, "lecturer.label                                                           AS lecturerName"
			, "timeslot.start_time                                                      AS startTime"
			, "DATE_ADD( timeslot.start_time, INTERVAL class_type.duration_min MINUTE ) AS endTime"
			, "venue.label                                                              AS venueName"
		];
		var classSessionQuery = _getClassSessionObject().findById( selectFields=selectFields, classSessionId=classSessionId );

		return _getSingleResult( classSessionQuery );
	}

	private struct function _getSingleResult( required query queryObject ){
		if ( queryObject.recordCount == 0 ) {
			return {};
		}

		return queryGetRow( queryObject, 1 );
	}

	public array function getAssignableClassSessionArray( required date startDatetime, required date endDatetime ){
		var loggedInUserId    = _getWebsiteLoginService().getLoggedInUserId();
		var classSessionArray = [];
		var intakeArray       = _getAvailableIntakes( loggedInUserId, startDatetime, endDatetime );

		for ( var intake in intakeArray ){
			var coursesArray = _getAvailableCourses( intake.id, startDatetime, endDatetime );

			for ( var course in coursesArray ) {
				var modulesArray = _getAvailableModules( course.id, startDatetime, endDatetime );

				for ( var module in modulesArray ) {
					var classTypesArray = _getAvailableClassTypes( module.id );

					for ( var classType in classTypesArray ) {
						var classSessionStruct = {};

						classSessionStruct.intakeId              = intake.id;
						classSessionStruct.courseId              = course.id;
						classSessionStruct.studentCount          = course.studentCount;
						classSessionStruct.moduleId              = module.id;
						classSessionStruct.assignSameLecturer    = ( module.assignSameLecturer       == 1 );
						classSessionStruct.classTypeId           = classType.id;
						classSessionStruct.durationInMinutes     = classType.durationInMinutes;
						classSessionStruct.applicableToSunday    = ( classType.applicableToSunday    == 1 );
						classSessionStruct.applicableToMonday    = ( classType.applicableToMonday    == 1 );
						classSessionStruct.applicableToTuesday   = ( classType.applicableToTuesday   == 1 );
						classSessionStruct.applicableToWednesday = ( classType.applicableToWednesday == 1 );
						classSessionStruct.applicableToThursday  = ( classType.applicableToThursday  == 1 );
						classSessionStruct.applicableToFriday    = ( classType.applicableToFriday    == 1 );
						classSessionStruct.applicableToSaturday  = ( classType.applicableToSaturday  == 1 );
						classSessionStruct.assignTimeRangeStart  = classType.assignTimeRangeStart;
						classSessionStruct.assignTimeRangeEnd    = classType.assignTimeRangeEnd;
						classSessionStruct.applicableVenues      = _getAvailableVenues(
							  classType.id
							, classSessionStruct.studentCount?:0
						);

						classSessionArray.append( classSessionStruct );
					}
				}
			}
		}

		return classSessionArray;
	}

	public boolean function isSameGroupOfStudent( required struct classSessionA, required struct classSessionB ){
		if ( classSessionA.intakeId!=classSessionB.intakeId ) {
			return false;
		}

		if ( classSessionA.courseId!=classSessionB.courseId ) {
			return false;
		}

		if ( classSessionA.moduleId!=classSessionB.moduleId ) {
			return false;
		}

		return true;
	}

	private array function _getAvailableIntakes( required string userId, required date startDatetime, required date endDatetime ){
		var intakeArray = [];
		var intakeQuery = _getIntakeObject().findAvailableByUserId(
			  userId        = userId
			, selectFields  = [ "intake.id" ]
			, startDatetime = startDatetime
			, endDatetime   = endDatetime
		);

		intakeQuery.each( function( intake ){
			intakeArray.append( intake );
		} );

		return intakeArray;
	}

	private array function _getAvailableCourses( required string intakeId, required date startDatetime, required date endDatetime ){
		var courseArray = [];
		var courseQuery = _getCourseObject().findAvailableByIntakeId(
			  intakeId      = intakeId
			, selectFields  = [ "course.id", "intake_course.student_count AS studentCount" ]
			, startDatetime = startDatetime
			, endDatetime   = endDatetime
		);

		courseQuery.each( function( course ){
			courseArray.append( course );
		} );

		return courseArray;
	}

	private array function _getAvailableModules( required string courseId, required date startDatetime, required date endDatetime ){
		var moduleArray = [];
		var moduleQuery = _getModuleObject().findAvailableByCourseId(
			  courseId      = courseId
			, selectFields  = [ "module.id", "module.assign_same_lecturer AS assignSameLecturer" ]
			, startDatetime = startDatetime
			, endDatetime   = endDatetime
		);

		moduleQuery.each( function( module ){
			moduleArray.append( module );
		} );

		return moduleArray;
	}

	private array function _getAvailableClassTypes( required string moduleId ){
		var classTypeArray = [];
		var classTypeQuery = _getClassTypeObject().findByModuleId(
			  moduleId     = moduleId
			, selectFields = [
				  "class_type.id"
				, "class_type.duration_min                   AS durationInMinutes"
				, "class_type.applicable_to_sunday           AS applicableToSunday"
				, "class_type.applicable_to_monday           AS applicableToMonday"
				, "class_type.applicable_to_tuesday          AS applicableToTuesday"
				, "class_type.applicable_to_wednesday        AS applicableToWednesday"
				, "class_type.applicable_to_thursday         AS applicableToThursday"
				, "class_type.applicable_to_friday           AS applicableToFriday"
				, "class_type.applicable_to_saturday         AS applicableToSaturday"
				, "module_class_type.assign_time_range_start AS assignTimeRangeStart"
				, "module_class_type.assign_time_range_end   AS assignTimeRangeEnd"
			]
		);

		classTypeQuery.each( function( classType ){
			classTypeArray.append( classType );
		} );

		return classTypeArray;
	}

	private array function _getAvailableVenues( required string classTypeId, numeric studentCount=0 ){
		var venueArray = [];
		var venueQuery = _getVenueObject().findAvailableByClassTypeId(
			  classTypeId  = classTypeId
			, studentCount = studentCount
			, selectFields = [
				  "venue.id"
				, "venue.capacity"
			]
		);

		venueQuery.each( function( venue ){
			venueArray.append( venue );
		} );

		return venueArray;
	}

	private void function _setIntakeObject( required intake intakeObject ){
		variables._intakeObject = intakeObject;
	}

	private intake function _getIntakeObject(){
		return variables._intakeObject;
	}

	private void function _setCourseObject( required course courseObject ){
		variables._courseObject = courseObject;
	}

	private course function _getCourseObject(){
		return variables._courseObject;
	}

	private void function _setModuleObject( required module moduleObject ){
		variables._moduleObject = moduleObject;
	}

	private module function _getModuleObject(){
		return variables._moduleObject;
	}

	private void function _setClassTypeObject( required class_type classTypeObject ){
		variables._classTypeObject = classTypeObject;
	}

	private class_type function _getClassTypeObject(){
		return variables._classTypeObject;
	}

	private void function _setVenueObject( required venue venueObject ){
		variables._venueObject = venueObject;
	}

	private venue function _getVenueObject(){
		return variables._venueObject;
	}

	private void function _setClassSessionObject( required class_session classSessionObject ){
		variables._classSessionObject = classSessionObject;
	}

	private class_session function _getClassSessionObject(){
		return variables._classSessionObject;
	}

	private void function _setWebsiteLoginService( required WebsiteLoginService websiteLoginService ){
		variables._websiteLoginService = websiteLoginService;
	}

	private WebsiteLoginService function _getWebsiteLoginService(){
		return variables._websiteLoginService;
	}
}