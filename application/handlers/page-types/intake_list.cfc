component {
	property name="intakeService"   inject="IntakeService";
	property name="siteTreeService" inject="SiteTreeService";

	private function index( event, rc, prc, args={} ){
		args.intakeArray = intakeService.getIntakeArray();

		return renderView(
			  view          = "page-types/timetable/resource/intake/index"
			, args          = args
			, presideObject = "intake_list"
		);
	}

	public function add( event, rc, prc, args={} ){
		if ( event.getHTTPMethod() == "POST" ) {
			var formName         = "timetable.resource.intake";
			var formData         = event.getCollectionForForm( formName );
			var validationResult = validateForm( formName=formName, formData=formData );

			if ( intakeService.isIntakeExists( intakeAbbreviation=formData.abbreviation ) ) {
				validationResult.addError(
					  fieldName = "abbreviation"
					, message   = "Existing ""#formData.abbreviation#"" found."
				);
			}

			var hasError         = validationResult.listErrorFields().len() > 0;

			if ( hasError ) {
				args.validationResult = validationResult;
				args.savedData        = formData;
			} else {
				var linkTo   = "resource/intake";
				var intakeId = intakeService.createIntake( formData );

				if ( ( formData.addRelatedCourses?:"0" )=="1" ) {
					linkTo &= "/#intakeId#/view"
				}

				setNextEvent( url=event.buildLink( linkTo=linkTo ) );
				
				return;
			}
		}

		event.initializeDummyPresideSiteTreePage(
			  title = "Add Intake"
			, parentPage = siteTreeService.getPage( systemPage="intake_list" )
		);

		event.setView( view="page-types/timetable/resource/intake/add", args=args );
		
	}

	public function addRelatedCourse( event, rc, prc, args={} ){
		var intakeId           = trim ( rc.intakeId           ?: "" );
		var courseId           = trim ( rc.courseId           ?: "" );
		var studentCount       = trim ( rc.studentCount       ?: "" );
		var effectiveTimestamp = trim ( rc.effectiveTimestamp ?: "" );
		var idleTimestamp      = trim ( rc.idleTimestamp      ?: "" );
		var intakeCourseStruct = {
			  courseId           = courseId
			, studentCount       = studentCount
			, effectiveTimestamp = effectiveTimestamp
		}

		if ( idleTimestamp.len() > 0 ){
			intakeCourseStruct.idleTimestamp = idleTimestamp;
		}

		if ( intakeService.isRelatedCourseDataValid( intakeCourseStruct ) ) {
			var intakeCourseId     = intakeService.addRelatedCourse( intakeCourseStruct, intakeId );
			var intakeCourseStruct = intakeService.getRelatedCourseByIntakeCourseId( intakeCourseId );
			var message            = "Related course added.";

			intakeCourseStruct.effectiveTimestamp = dateTimeFormat( intakeCourseStruct.effectiveTimestamp, "yyyy-mm-dd HH:nn" );
			intakeCourseStruct.idleTimestamp      = dateTimeFormat( intakeCourseStruct.idleTimestamp,      "yyyy-mm-dd HH:nn" );

			return _buildResponseMessageAsJson( message=message, messageType="success", success=true, data=intakeCourseStruct );
		}

		var message = "Invalid data given.";

		return _buildResponseMessageAsJson( message=message, messageType="danger" );
	}

	public function view( event, rc, prc, args={} ){
		var intakeId = prc.intakeId ?: "";

		if ( !intakeService.isIntakeBelongsToCurrentUser( intakeId ) ) {
			event.accessDenied( reason="INSUFFICIENT_PRIVILEGES" );
			return;
		}

		args.intakeDataStruct    = intakeService.getIntakeById( intakeId=intakeId );
		args.intakeDataStruct.id = intakeId;
		args.relatedCourses      = intakeService.getRelatedCoursesById( intakeId );

		event.initializeDummyPresideSiteTreePage(
			  title      = "View Intake"
			, parentPage = siteTreeService.getPage( systemPage="intake_list" )
		);

		event.include( "css-resource" );
		event.include( "js-intake" );
		event.includeData( {
			"addRelatedCourseURL" = event.buildLink( linkTo="page-types.intake_list.addRelatedCourse" )
		} );

		event.setView( view="page-types/timetable/resource/intake/view", args=args );
	}

	public function edit( event, rc, prc, args={} ){
		var intakeDetailsStruct = {
			  "id"           = rc.intakeId?:""
			, "name"         = rc.name?:""
			, "description"  = rc.description?:""
			, "abbreviation" = rc.abbreviation?:""
		};
		var validationResult = validateForm( formName="timetable.resource.intake", formData=intakeDetailsStruct );
		var hasError         = validationResult.listErrorFields().len() > 0;

		if ( !hasError ) {
			var updated = intakeService.updateIntake( intakeDetailsStruct );
		}

		setNextEvent( url=event.buildLink( linkTo="resource/intake" ) );
	}

	public function delete( event, rc, prc, args={} ){
		intakeService.deleteIntake( rc.intakeId?:"" );
		
		setNextEvent( url=event.buildLink( linkTo="resource/intake" ) );
	}

	public function search( event, rc, prc, args={} ){
		var searchQuery = trim( rc.searchQuery ?: "" );
		var searchResultArray = intakeService.getIntakeByNameOrAbbreviation( searchQuery );

		return serializeJSON( searchResultArray );
	}

	private string function _buildResponseMessageAsJson(
		  required string  message
		,          string  messageType="info"
		,          boolean success=false
		,          struct  data={}
	){
		return serializeJSON( { "message"=message, "messageType"=messageType, "success"=success, "data"=data } );
	}
}