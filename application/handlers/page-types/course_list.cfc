component {
	property name="courseService" inject="CourseService";
	property name="siteTreeService" inject="SiteTreeService";

	private function index( event, rc, prc, args={} ){
		args.courseArray = courseService.getCourseArray();

		return renderView(
			  view = "page-types/timetable/resource/course/index"
			, args = args
			, presideObject = "course_list"
		);
	}

	public function search( event, rc, prc, args={} ){
		var searchQuery = trim( rc.searchQuery ?: "" );
		var searchResultArray = courseService.getCourseByNameOrAbbreviation( searchQuery );

		return serializeJSON( searchResultArray );
	}

	public function add( event, rc, prc, args={} ){
		if ( event.getHTTPMethod() == "POST" ) {
			var formName = "timetable.resource.course";
			var formData = event.getCollectionForForm( formName );
			var validationResult = validateForm( formName=formName, formData=formData );
			var hasError = validationResult.listErrorFields().len() > 0;

			if ( hasError ) {
				args.validationResult = validationResult;
				args.savedData = formData;
			} else {
				var linkTo = "resource/course";
				var courseId = courseService.createCourse( formData );

				if ( formData.addRelatedIntakesOrModules?:"0"=="1" ) {
					linkTo &= "/#courseId#/view"
				}

				setNextEvent( url=event.buildLink( linkTo=linkTo ) );

				return;
			}
		}

		event.initializeDummyPresideSiteTreePage(
			  title = "Add Course"
			, parentPage = siteTreeService.getPage( systemPage="course_list" )
		);

		event.setView( view="page-types/timetable/resource/course/add", args=args );
	}

	public function addRelatedIntake( event, rc, prc, args={} ){
		var intakeId           = trim ( rc.intakeId?:"" );
		var courseId           = trim ( rc.courseId?:"" );
		var studentCount       = trim ( rc.studentCount?:"" );
		var effectiveTimestamp = trim ( rc.effectiveTimestamp?:"" );
		var idleTimestamp      = trim ( rc.idleTimestamp?:"" );

		if (
			   intakeId.len()           > 0
			&& courseId.len()           > 0
			&& studentCount.len()       > 0
			&& effectiveTimestamp.len() > 0
		) {
			var intakeCourseStruct = {
				  intakeId = intakeId
				, studentCount = studentCount
				, effectiveTimestamp = effectiveTimestamp
			}

			if ( idleTimestamp.len() > 0 ){
				intakeCourseStruct.idleTimestamp = idleTimestamp;
			}

			var intakeCourseId = courseService.addRelatedIntake( intakeCourseStruct, courseId );
			var intakeCourseStruct = courseService.getRelatedIntakeByIntakeCourseId( intakeCourseId );
			var message = "Related intake added.";

			intakeCourseStruct.effectiveTimestamp = dateTimeFormat( intakeCourseStruct.effectiveTimestamp, "yyyy-mm-dd HH:nn" );
			intakeCourseStruct.idleTimestamp = dateTimeFormat( intakeCourseStruct.idleTimestamp, "yyyy-mm-dd HH:nn" );

			return _buildResponseMessageAsJson( message=message, messageType="success", success=true, data=intakeCourseStruct );
		}

		var message = "Invalid data given.";

		return _buildResponseMessageAsJson( message=message, messageType="danger" );
	}

	public function addRelatedModule( event, rc, prc, args={} ){
		var moduleId           = trim ( rc.moduleId?:"" );
		var courseId           = trim ( rc.courseId?:"" );
		var effectiveTimestamp = trim ( rc.effectiveTimestamp?:"" );
		var idleTimestamp      = trim ( rc.idleTimestamp?:"" );

		if (
			   moduleId.len()           > 0
			&& courseId.len()           > 0
			&& effectiveTimestamp.len() > 0
		) {
			var courseModuleStruct = {
				  moduleId = moduleId
				, effectiveTimestamp = effectiveTimestamp
			}

			if ( idleTimestamp.len() > 0 ){
				courseModuleStruct.idleTimestamp = idleTimestamp;
			}

			var courseModuleId = courseService.addRelatedModule( courseModuleStruct, courseId );
			var courseModuleStruct = courseService.getRelatedModuleByCourseModuleId( courseModuleId );
			var message = "Related module added.";

			courseModuleStruct.effectiveTimestamp = dateTimeFormat( courseModuleStruct.effectiveTimestamp, "yyyy-mm-dd HH:nn" );
			courseModuleStruct.idleTimestamp = dateTimeFormat( courseModuleStruct.idleTimestamp, "yyyy-mm-dd HH:nn" );

			return _buildResponseMessageAsJson( message=message, messageType="success", success=true, data=courseModuleStruct );
		}

		var message = "Invalid data given.";

		return _buildResponseMessageAsJson( message=message, messageType="danger" );
	}

	public function view( event, rc, prc, args={} ){
		var courseId = prc.courseId ?: "";

		if ( !courseService.isCourseBelongsToCurrentUser( courseId ) ) {
			event.accessDenied( reason="INSUFFICIENT_PRIVILEGES" );
			return;
		}

		args.courseDataStruct = courseService.getCourseById( courseId=courseId );
		args.courseDataStruct.id = courseId;
		args.relatedIntakes = courseService.getRelatedIntakesById( courseId );
		args.relatedModules = courseService.getRelatedModulesById( courseId );

		event.initializeDummyPresideSiteTreePage(
			  title = "View Course"
			, parentPage = siteTreeService.getPage( systemPage="course_list" )
		);

		event.include( "css-resource" );
		event.include( "js-course" );
		event.includeData( {
			  "addRelatedIntakeURL" = event.buildLink( linkTo="page-types.course_list.addRelatedIntake" )
			, "addRelatedModuleURL" = event.buildLink( linkTo="page-types.course_list.addRelatedModule" )
		} );

		event.setView( view="page-types/timetable/resource/course/view", args=args );
	}

	public function edit( event, rc, prc, args={} ){
		var courseDetailsStruct = {
			  "id" = rc.courseId?:""
			, "name" = rc.name?:""
			, "description" = rc.description?:""
			, "abbreviation" = rc.abbreviation
		};

		var updated = courseService.updateCourse( courseDetailsStruct );

		setNextEvent( url=event.buildLink( linkTo="resource/course" ) );
	}

	public function delete( event, rc, prc, args={} ){
		courseService.deleteCourse( rc.courseId?:"" );
		setNextEvent( url=event.buildLink( linkTo="resource/course" ) );
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