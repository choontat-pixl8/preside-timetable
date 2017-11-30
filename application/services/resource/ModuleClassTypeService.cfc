component {
	/**
	 * @moduleClassTypeObject.inject presidecms:object:module_class_type
	 * @websiteLoginService.inject WebsiteLoginService
	**/
	public any function init(
		  required module_class_type   moduleClassTypeObject
		, required WebsiteLoginService websiteLoginService
	){
		_setModuleClassTypeObject( moduleClassTypeObject );
		_setWebsiteLoginService( websiteLoginService );
	}

	public array function getModuleClassTypesByNameOrAbbreviation( required string searchQuery ){
		var moduleClassTypeArray = [];
		var selectFields = [
			  "module_class_type.id"
			, "module.label            AS moduleName"
			, "module.abbreviation     AS moduleAbbreviation"
			, "class_type.label        AS classTypeName"
			, "class_type.abbreviation AS classTypeAbbreviation"
		];
		var loggedInUserId       = _getWebsiteLoginService().getLoggedInUserId();
		var moduleClassTypeQuery = _getModuleClassTypeObject().findByNamesOrAbbreviations(
			  selectFields = selectFields
			, userId       = loggedInUserId
			, searchQuery  = searchQuery
		);

		moduleClassTypeQuery.each( function( moduleClassType ){
			var moduleClassTypeStruct = {
				  "module"    = moduleClassType.moduleName    & " (#moduleClassType.moduleAbbreviation#)"
				, "classType" = moduleClassType.classTypeName & " (#moduleClassType.classTypeAbbreviation#)"
				, "id"        = moduleClassType.id
			};

			moduleClassTypeArray.append( moduleClassTypeStruct );
		} );

		return moduleClassTypeArray;
	}

	private void function _setWebsiteLoginService( required WebsiteLoginService websiteLoginService ){
		variables._websiteLoginService = websiteLoginService;
	}

	private WebsiteLoginService function _getWebsiteLoginService(){
		return variables._websiteLoginService;
	}

	private void function _setModuleClassTypeObject( required module_class_type moduleClassTypeObject ){
		variables._moduleClassTypeObject = moduleClassTypeObject;
	}

	private module_class_type function _getModuleClassTypeObject(){
		return variables._moduleClassTypeObject;
	}
}