component {
	property name="moduleClassTypeService" inject="ModuleClassTypeService";

	private function index( event, rc, prc, args={} ){
		return event.buildLink( linkTo="page-types.module_class_type_list.search" );
	}

	public function search( event, rc, prc, args={} ){
		var searchQuery      = trim( rc.searchQuery?:"" );
		var moduleClassTypes = moduleClassTypeService.getModuleClassTypesByNameOrAbbreviation( searchQuery );

		return serializeJSON( moduleClassTypes );
	}
}