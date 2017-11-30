component {
	/**
	 * @moduleObject.inject          presidecms:object:module
	 * @courseModuleObject.inject    presidecms:object:course_module
	 * @moduleClassTypeObject.inject presidecms:object:module_class_type
	 * @websiteLoginService.inject   WebsiteLoginService
	**/
	public any function init(
		  required module              moduleObject
		, required course_module       courseModuleObject
		, required module_class_type   moduleClassTypeObject
		, required WebsiteLoginService websiteLoginService
	){
		_setModuleObject( moduleObject );
		_setCourseModuleObject( courseModuleObject );
		_setModuleClassTypeObject( moduleClassTypeObject );
		_setWebsiteLoginService( websiteLoginService );
	}

	public array function getModuleArray(){
		var moduleArray    = [];
		var selectFields   = [
			  "module.id"
			, "module.label AS name"
			, "module.description"
			, "module.abbreviation"
			, "module.assign_same_lecturer AS assignSameLecturer"
		];
		var loggedInUserId = _getWebsiteLoginService().getLoggedInUserId();
		var moduleQuery    = _getModuleObject().findByUserId( userId=loggedInUserId, selectFields=selectFields );

		moduleQuery.each( function( module ){
			var moduleStruct = {
				  "id"                 = module.id
				, "name"               = module.name
				, "description"        = module.description
				, "abbreviation"       = module.abbreviation
				, "assignSameLecturer" = module.assignSameLecturer
			};

			moduleArray.append( moduleStruct );
		} );

		return moduleArray;
	}

	public struct function getRelatedCourseByCourseModuleId( required string courseModuleId ){
		var selectFields = [
			  "course.label                      AS name"
			, "course_module.effective_timestamp AS effectiveTimestamp"
			, "course_module.idle_timestamp      AS idleTimestamp"
		];

		var relatedmodulesQuery = _getCourseModuleObject().findById( courseModuleId=courseModuleId, selectFields=selectFields );

		if ( relatedmodulesQuery.recordCount == 0) {
			return {};
		}

		return queryGetRow( relatedmodulesQuery, 1 );
	}

	public struct function getRelatedClassTypeByModuleClassTypeId( required string moduleClassTypeId ){
		var selectFields = [
			  "class_type.label                          AS name"
			, "module_class_type.assign_time_range_start AS assignTimeRangeStart"
			, "module_class_type.assign_time_range_end   AS assignTimeRangeEnd"
		];

		var relatedmodulesQuery = _getModuleClassTypeObject().findById( moduleClassTypeId=moduleClassTypeId, selectFields=selectFields );

		if ( relatedmodulesQuery.recordCount == 0) {
			return {};
		}

		return queryGetRow( relatedmodulesQuery, 1 );
	}

	public array function getRelatedCoursesById( required string moduleId ){
		var selectFields = [
			  "course.label                      AS name"
			, "course_module.effective_timestamp AS effectiveTimestamp"
			, "course_module.idle_timestamp      AS idleTimestamp"
		];

		var relatedModulesQuery = _getCourseModuleObject().findByModuleId( moduleId=moduleId, selectFields=selectFields );
		var relatedModules = [];

		relatedModulesQuery.each( function( relatedModule ){
			relatedModules.append( relatedModule );
		} );

		return relatedModules;
	}

	public array function getRelatedClassTypesById( required string moduleId ){
		var selectFields = [
			  "class_type.label                          AS name"
			, "module_class_type.assign_time_range_start AS assignTimeRangeStart"
			, "module_class_type.assign_time_range_end   AS assignTimeRangeEnd"
		];

		var relatedClassTypesQuery = _getModuleClassTypeObject().findByModuleId( moduleId=moduleId, selectFields=selectFields );
		var relatedClassTypes      = [];

		relatedClassTypesQuery.each( function( relatedClassType ){
			relatedClassTypes.append( relatedClassType );
		} );

		return relatedClassTypes;
	}

	public boolean function isModuleBelongsToCurrentUser( required string moduleId ){
		var moduleQueryArgs = {
			  selectFields = [ "module.id" ]
			, moduleId     = arguments.moduleId
			, userId       = _getLogggedInUserId()
		};
		var moduleQuery = _getModuleObject().findByIdAndUserId( argumentCollection=moduleQueryArgs );

		return moduleQuery.recordCount > 0;
	}

	public struct function getModuleById( required string moduleId){
		var selectFields = [
			  "module.label                AS name"
			, "module.description"
			, "module.abbreviation"
			, "module.assign_same_lecturer AS assignSameLecturer"
		];
		var moduleQuery = _getModuleObject().findByIdAndUserId(
			  moduleId     = moduleId
			, userId       = _getLogggedInUserId()
			, selectFields = selectFields
		);
		var moduleStruct = {
			  "name"               = moduleQuery.name
			, "description"        = moduleQuery.description
			, "abbreviation"       = moduleQuery.abbreviation
			, "assignSameLecturer" = moduleQuery.assignSameLecturer
		};

		return moduleStruct;
	}

	public string function createModule( required struct moduleStruct ){
		var data = _processModuleStruct( moduleStruct );

		return _getModuleObject().insertData( data=data );
	}

	public string function addRelatedCourse( required struct courseModule, required string moduleId ){
		var courseModuleStruct = {
			  "module"              = moduleId
			, "course"              = courseModule.courseId
			, "effective_timestamp" = courseModule.effectiveTimestamp
			, "idle_timestamp"      = courseModule.idleTimestamp?:""
		};

		return _getCourseModuleObject().insertData( data=courseModuleStruct );
	}

	public string function addRelatedClassType( required struct moduleClassType, required string moduleId ){
		var moduleClassTypeStruct = {
			  "module"                  = moduleId
			, "class_type"              = moduleClassType.classTypeId
			, "assign_time_range_start" = moduleClassType.assignTimeRangeStart
			, "assign_time_range_end"   = moduleClassType.assignTimeRangeEnd?:""
		};

		return _getModuleClassTypeObject().insertData( data=moduleClassTypeStruct );
	}

	public boolean function updateModule( required struct moduleStruct ){
		var data = _processModuleStruct( moduleStruct );

		var updatedRowCount = _getModuleObject().updateData(
			  data = data
			, id   = moduleStruct.id?:""
		);

		return updatedRowCount == 1;
	}

	public boolean function deleteModule( required string moduleId ){
		if ( !isModuleBelongsToCurrentUser( moduleId ) ) {
			return false;
		}

		var filter = { "module"=moduleId };
		
		_getCourseModuleObject().deleteData( filter=filter );
		_getModuleClassTypeObject().deleteData( filter=filter );

		var deletedRowCount = _getModuleObject().deleteData( id=moduleId );

		return deletedRowCount == 1;
	}

	public array function getModuleByNameOrAbbreviation( required string nameOrAbbreviation ){
		var selectFields = [
			  "module.id"
			, "module.label AS name"
			, "module.abbreviation"
		];
		var moduleQuery = _getModuleObject().findByNameOrAbbreviation(
			  selectFields       = selectFields
			, nameOrAbbreviation = nameOrAbbreviation
			, userId             = _getWebsiteLoginService().getLoggedInUserId()
		);
		var moduleArray = [];

		moduleQuery.each( function( module ){
			moduleArray.append( module );
		} );

		return moduleArray;
	}

	private struct function _processModuleStruct( required struct moduleStruct ){
		var processedModuleStruct = {
			  "label"                = moduleStruct.name         ?: ""
			, "description"          = moduleStruct.description  ?: ""
			, "abbreviation"         = moduleStruct.abbreviation ?: ""
			, "assign_same_lecturer" = moduleStruct.assignSameLecturer == "1" ?: "0"
			, "website_user"         = _getLogggedInUserId()
		};

		return processedModuleStruct;
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

	private void function _setCourseModuleObject( required course_module courseModuleObject ){
		variables._courseModuleObject = courseModuleObject;
	}

	private course_module function _getCourseModuleObject(){
		return variables._courseModuleObject;
	}

	private void function _setModuleClassTypeObject( required module_class_type moduleClassTypeObject ){
		variables._moduleClassType = moduleClassTypeObject;
	}

	private module_class_type function _getModuleClassTypeObject(){
		return variables._moduleClassType;
	}

	private void function _setModuleObject( required module moduleObject ){
		variables._moduleObject = moduleObject;
	}

	private module function _getModuleObject(){
		return variables._moduleObject;
	}
}