/**
 * @isSystemPageType true
 * @nolabel true
**/
component {
	property name="effective_timestamp" dbtype="timestamp" dbDefault="CURRENT_TIMESTAMP" required="true";
	property name="idle_timestamp"      dbtype="timestamp" default="NULL";

	property name="course" relatedTo="course" relationship="many-to-one";
	property name="module" relatedTo="module" relationship="many-to-one";

	public query function findById( required string courseModuleId, required array selectFields ){
		var filter = { "course_module.id"=courseModuleId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByCourseId( required string courseId, required array selectFields ){
		var filter = { "course"=courseId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByModuleId( required string moduleId, required array selectFields ){
		var filter = { "module"=moduleId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}
}