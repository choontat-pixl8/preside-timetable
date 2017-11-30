/**
 * @isSystemPageType true
 * @nolabel true
**/
component {
	property name="assign_time_range_start" dbtype="time" required="true";
	property name="assign_time_range_end"   dbtype="time" required="true";

	property
		name            = "time_overlap_rules"
		relatedTo       = "time_overlap_rule"
		relationship    = "one-to-many"
		relationshipKey = "module_class_type";
	property 
		name            = "class_merging_rules"
		relatedTo       = "class_merging_rule"
		relationship    = "one-to-many"
		relationshipKey = "module_class_type";
	property
		name            = "module_class_type_lecturers"
		relatedTo       = "module_class_type_lecturer"
		relationship    = "one-to-many"
		relationshipKey = "module_class_type";

	property name="module"     relatedTo="module" relationship="many-to-one";
	property name="class_type" relatedTo="class_type" relationship="many-to-one";

	public query function findById( required string moduleClassTypeId, required array selectFields ){
		var filter = { "module_class_type.id"=moduleClassTypeId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByModuleId( required string moduleId, required array selectFields ){
		var filter = { "module"=moduleId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByClassTypeId( required string classTypeId, required array selectFields ){
		var filter = { "class_type"=classTypeId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByNamesOrAbbreviations(
		  required string searchQuery
		, required string userId
		, required array  selectFields
	){
		var filter = "
			    module.website_user     = :module.website_user
			AND class_type.website_user = :class_type.website_user
			AND (
				   module.label            LIKE :module.label
				OR module.abbreviation     LIKE :module.abbreviation
				OR class_type.label        LIKE :class_type.label
				OR class_type.abbreviation LIKE :class_type.abbreviation
			)
		";
		var filterParams = {
			  "module.website_user"     = userId
			, "class_type.website_user" = userId
			, "module.label"            = "%#searchQuery#%"
			, "module.abbreviation"     = "%#searchQuery#%"
			, "class_type.label"        = "%#searchQuery#%"
			, "class_type.abbreviation" = "%#searchQuery#%"
		};

		return this.selectData( selectFields=selectFields, filter=filter, filterParams=filterParams );
	}
}