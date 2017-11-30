/**
 * @isSystemPageType true
 * @nolabel true
**/
component {
	property name="effective_timestamp" dbtype="timestamp" required="true" dbDefault="CURRENT_TIMESTAMP";
	property name="idle_timestamp"      dbtype="timestamp";

	property name="module_class_type" relatedTo="module_class_type" relationship="many-to-one";
	property name="lecturer"          relatedTo="lecturer"          relationship="many-to-one";

	public query function findById( required string moduleClassTypeLecturerId, required array selectFields ){
		var filter = { "module_class_type_lecturer.id"=moduleClassTypeLecturerId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByModuleClassTypeId( required string moduleClassTypeId, required array selectFields ){
		var filter = { "module_class_type"=moduleClassTypeId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByModuleIdAndClassTypeId(
		  required string moduleId
		, required string classTypeId
		, required array  selectFields
	){
		var filter = { "module_class_type.module"=moduleId, "module_class_type.class_type"=classTypeId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByLecturerId( required string lecturerId, required array selectFields ){
		var filter = { "lecturer"=lecturerId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}
}