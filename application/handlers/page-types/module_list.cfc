component {
	property name="moduleService" inject="ModuleService";
	property name="siteTreeService" inject="SiteTreeService";

	private function index( event, rc, prc, args={} ){
		args.moduleArray = moduleService.getModuleArray();

		return renderView(
			  view = "page-types/timetable/resource/module/index"
			, args = args
			, presideObject = "module_list"
		);
	}

	public function add( event, rc, prc, args={} ){
		if ( event.getHTTPMethod() == "POST" ) {
			var formName = "timetable.resource.module";
			var formData = event.getCollectionForForm( formName );
			var validationResult = validateForm( formName=formName, formData=formData );
			var hasError = validationResult.listErrorFields().len() > 0;

			if ( hasError ) {
				args.validationResult = validationResult;
				args.savedData = formData;
			} else {
				var linkTo = "resource/module";
				var moduleId = moduleService.createModule( formData );

				if ( ( formData.addRelatedCoursesOrClassTypes?:"0" )=="1" ) {
					linkTo &= "/#moduleId#/view"
				}

				setNextEvent( url=event.buildLink( linkTo=linkTo ) );
				
				return;
			}
		}

		event.initializeDummyPresideSiteTreePage(
			  title = "Add Module"
			, parentPage = siteTreeService.getPage( systemPage="module_list" )
		);

		event.setView( view="page-types/timetable/resource/module/add", args=args );
		
	}

	public function addRelatedCourse( event, rc, prc, args={} ){
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
				  courseId = courseId
				, effectiveTimestamp = effectiveTimestamp
			}

			if ( idleTimestamp.len() > 0 ){
				courseModuleStruct.idleTimestamp = idleTimestamp;
			}

			var courseModuleId = moduleService.addRelatedCourse( courseModuleStruct, moduleId );
			var courseModuleStruct = moduleService.getRelatedCourseByCourseModuleId( courseModuleId );
			var message = "Related course added.";

			courseModuleStruct.effectiveTimestamp = dateTimeFormat( courseModuleStruct.effectiveTimestamp, "yyyy-mm-dd HH:nn" );
			courseModuleStruct.idleTimestamp = dateTimeFormat( courseModuleStruct.idleTimestamp, "yyyy-mm-dd HH:nn" );

			return _buildResponseMessageAsJson( message=message, messageType="success", success=true, data=courseModuleStruct );
		}

		var message = "Invalid data given.";

		return _buildResponseMessageAsJson( message=message, messageType="danger" );
	}

	public function addRelatedClassType( event, rc, prc, args={} ){
		var moduleId           = trim ( rc.moduleId?:"" );
		var classTypeId        = trim ( rc.classTypeId?:"" );
		var assignTimeRangeStart = trim ( rc.assignTimeRangeStart?:"" );
		var assignTimeRangeEnd      = trim ( rc.assignTimeRangeEnd?:"" );

		if (
			   moduleId.len()           > 0
			&& classTypeId.len()           > 0
			&& assignTimeRangeStart.len() > 0
		) {
			var moduleClassTypeStruct = {
				  classTypeId = classTypeId
				, assignTimeRangeStart = assignTimeRangeStart
				, assignTimeRangeEnd = assignTimeRangeEnd
			}

			var moduleClassTypeId = moduleService.addRelatedClassType( moduleClassTypeStruct, moduleId );
			var moduleClassTypeStruct = moduleService.getRelatedClassTypeByModuleClassTypeId( moduleClassTypeId );
			var message = "Related class type added.";

			moduleClassTypeStruct.assignTimeRangeStart = timeFormat( moduleClassTypeStruct.assignTimeRangeStart, "HH:mm" );
			moduleClassTypeStruct.assignTimeRangeEnd = timeFormat( moduleClassTypeStruct.assignTimeRangeEnd, "HH:mm" );

			return _buildResponseMessageAsJson( message=message, messageType="success", success=true, data=moduleClassTypeStruct );
		}

		var message = "Invalid data given.";

		return _buildResponseMessageAsJson( message=message, messageType="danger" );
	}

	public function view( event, rc, prc, args={} ){
		var moduleId = prc.moduleId ?: "";

		if ( !moduleService.isModuleBelongsToCurrentUser( moduleId ) ) {
			event.accessDenied( reason="INSUFFICIENT_PRIVILEGES" );
			return;
		}

		args.moduleDataStruct = moduleService.getModuleById( moduleId=moduleId );
		args.moduleDataStruct.id = moduleId;
		args.relatedCourses = moduleService.getRelatedCoursesById( moduleId );
		args.relatedClassTypes = moduleService.getRelatedClassTypesById( moduleId );

		event.initializeDummyPresideSiteTreePage(
			  title = "View Module"
			, parentPage = siteTreeService.getPage( systemPage="module_list" )
		);

		event.include( "css-resource" );
		event.include( "js-module" );
		event.includeData( {
			"addRelatedCourseURL" = event.buildLink( linkTo="page-types.module_list.addRelatedCourse" )
			, "addRelatedClassTypeURL" = event.buildLink( linkTo="page-types.module_list.addRelatedClassType" )
		} );

		event.setView( view="page-types/timetable/resource/module/view", args=args );
	}

	public function edit( event, rc, prc, args={} ){
		var moduleDetailsStruct = {
			  "id" = rc.moduleId?:""
			, "name" = rc.name?:""
			, "description" = rc.description?:""
			, "abbreviation" = rc.abbreviation
		};

		var updated = moduleService.updateModule( moduleDetailsStruct );

		setNextEvent( url=event.buildLink( linkTo="resource/module" ) );
	}

	public function delete( event, rc, prc, args={} ){
		moduleService.deleteModule( rc.moduleId?:"" );
		setNextEvent( url=event.buildLink( linkTo="resource/module" ) );
	}

	public function search( event, rc, prc, args={} ){
		var searchQuery = trim( rc.searchQuery ?: "" );
		var searchResultArray = moduleService.getModuleByNameOrAbbreviation( searchQuery );

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