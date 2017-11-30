component {
	property name="lecturerService" inject="LecturerService";
	property name="siteTreeService" inject="SiteTreeService";

	private function index( event, rc, prc, args={} ){
		args.lecturerArray = lecturerService.getLecturerArray();

		return renderView(
			  view          = "page-types/timetable/resource/lecturer/index"
			, args          = args
			, presideObject = "lecturer_list"
		);
	}

	public function add( event, rc, prc, args={} ){
		if ( event.getHTTPMethod() == "POST" ) {
			var formName         = "timetable.resource.lecturer";
			var formData         = event.getCollectionForForm( formName );
			var validationResult = validateForm( formName=formName, formData=formData );
			var hasError         = validationResult.listErrorFields().len() > 0;

			if ( hasError ) {
				args.validationResult = validationResult;
				args.savedData        = formData;
			} else {
				var linkTo     = "resource/lecturer";
				var lecturerId = lecturerService.createLecturer( formData );

				if ( formData.addRelatedModuleClassTypesOrWorkHours?:"0"=="1" ) {
					linkTo &= "/#lecturerId#/view"
				}

				setNextEvent( url=event.buildLink( linkTo=linkTo ) );
				
				return;
			}
		}

		event.initializeDummyPresideSiteTreePage(
			  title      = "Add Lecturer"
			, parentPage = siteTreeService.getPage( systemPage="lecturer_list" )
		);

		event.setView( view="page-types/timetable/resource/lecturer/add", args=args );
		
	}

	public function addLecturerWorkHour( event, rc, prc, args={} ){
		var lecturerWorkHourDataStruct = {
			  lecturerId = trim( rc.lecturerId ?: "" )
			, startTime  = trim( rc.startTime  ?: "" )
			, endTime    = trim( rc.endTime    ?: "" )
			, dayOfWeek  = trim( rc.dayOfWeek  ?: "" )
		};
		

		if ( lecturerService.isLecturerWorkHourDataValid( lecturerWorkHourDataStruct ) ) {
			var lecturerWorkHourId     = lecturerService.addLecturerWorkHour( lecturerWorkHourDataStruct );
			var lecturerWorkHourStruct = lecturerService.getLecturerWorkHourByLecturerWorkHourId( lecturerWorkHourId );
			var message                = "Lecturer work hour added.";

			lecturerWorkHourStruct.startTime = timeFormat( lecturerWorkHourStruct.startTime, "HH:mm" );
			lecturerWorkHourStruct.endTime   = timeFormat( lecturerWorkHourStruct.endTime  , "HH:mm" );

			return _buildResponseMessageAsJson( message=message, messageType="success", success=true, data=lecturerWorkHourStruct );
		}

		var message = "Invalid data given.";

		return _buildResponseMessageAsJson( message=message, messageType="danger" );
	}

	public function addRelatedModuleClassTypes( event, rc, prc, args={} ){
		var lecturerId         = trim ( rc.lecturerId         ?: "" );
		var moduleClassTypeId  = trim ( rc.moduleClassTypeId  ?: "" );
		var effectiveTimestamp = trim ( rc.effectiveTimestamp ?: "" );
		var idleTimestamp      = trim ( rc.idleTimestamp      ?: "" );

		if (
			   lecturerId.len()         > 0
			&& moduleClassTypeId.len()  > 0
			&& effectiveTimestamp.len() > 0
		) {
			var moduleClassTypeLecturerStruct = {
				  id                 = moduleClassTypeId
				, effectiveTimestamp = effectiveTimestamp
			}

			if ( idleTimestamp.len() > 0 ){
				moduleClassTypeLecturerStruct.idleTimestamp = idleTimestamp;
			}

			var moduleClassTypeLecturerId     = lecturerService.addRelatedModuleClassType(
				  moduleClassTypeLecturerStruct
				, lecturerId
			);
			var moduleClassTypeLecturerStruct = lecturerService.getRelatedModuleClassTypeByModuleClassTypeLecturerId(
				moduleClassTypeLecturerId
			);
			var message                       = "Related module and class type added.";

			moduleClassTypeLecturerStruct.effectiveTimestamp = dateTimeFormat(
				  moduleClassTypeLecturerStruct.effectiveTimestamp
				, "yyyy-mm-dd HH:nn"
			);
			moduleClassTypeLecturerStruct.idleTimestamp      = dateTimeFormat(
				  moduleClassTypeLecturerStruct.idleTimestamp
				, "yyyy-mm-dd HH:nn"
			);

			return _buildResponseMessageAsJson( 
				  message     = message
				, messageType = "success"
				, success     = true
				, data        = moduleClassTypeLecturerStruct
			);
		}

		var message = "Invalid data given.";

		return buildResponseMessageAsJson( message=message, messageType="danger" );
	}

	public function view( event, rc, prc, args={} ){
		var lecturerId = prc.lecturerId ?: "";

		if ( !lecturerService.isLecturerBelongsToCurrentUser( lecturerId ) ) {
			event.accessDenied( reason="INSUFFICIENT_PRIVILEGES" );
			return;
		}

		args.lecturerDataStruct      = lecturerService.getLecturerById( lecturerId=lecturerId );
		args.lecturerDataStruct.id   = lecturerId;
		args.relatedModuleClassTypes = lecturerService.getRelatedModuleClassTypesById( lecturerId );
		args.lecturerWorkHours       = lecturerService.getLecturerWorkHoursById( lecturerId );

		event.initializeDummyPresideSiteTreePage(
			  title      = "View Lecturer"
			, parentPage = siteTreeService.getPage( systemPage="lecturer_list" )
		);

		event.include( "css-resource" );
		event.include( "js-lecturer" );

		event.includeData( {
			  "addRelatedModuleClassTypeURL" = event.buildLink( linkTo="page-types.lecturer_list.addRelatedModuleClassTypes" )
			, "addLecturerWorkHourURL"       = event.buildLink( linkTo="page-types.lecturer_list.addLecturerWorkHour"        )
			, "searchModuleClassTypeURL"     = event.buildLink( linkTo="page-types.module_class_type_list.search"            )
		} );

		event.setView( view="page-types/timetable/resource/lecturer/view", args=args );
	}

	public function edit( event, rc, prc, args={} ){
		var lecturerDetailsStruct = {
			  "id"           = rc.lecturerId   ?: ""
			, "name"         = rc.name         ?: ""
			, "description"  = rc.description  ?: ""
			, "abbreviation" = rc.abbreviation ?: ""
		};

		var updated = lecturerService.updateLecturer( lecturerDetailsStruct );

		setNextEvent( url=event.buildLink( linkTo="resource/lecturer" ) );
	}

	public function delete( event, rc, prc, args={} ){
		lecturerService.deleteLecturer( rc.lecturerId?:"" );

		setNextEvent( url=event.buildLink( linkTo="resource/lecturer" ) );
	}

	public function search( event, rc, prc, args={} ){
		var searchQuery       = trim( rc.searchQuery ?: "" );
		var searchResultArray = lecturerService.getLecturerByNameOrAbbreviation( searchQuery );

		return serializeJSON( searchResultArray );
	}

	private string function _buildResponseMessageAsJson(
		  required string  message
		,          string  messageType = "info"
		,          boolean success     = false
		,          struct  data        = {}
	){
		return serializeJSON( { "message"=message, "messageType"=messageType, "success"=success, "data"=data } );
	}
}