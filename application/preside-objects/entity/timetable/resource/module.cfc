/**
 * @isSystemPageType true
**/
component dataManagerGroup="resource"{
	property name="description"          required="true" maxLength="100";
	property name="abbreviation"         required="true" maxLength="20"   uniqueIndexes="abbreviation";
	property name="assign_same_lecturer" required="true" dbtype="tinyint" default="1";

	property name="website_user" relatedTo="website_user" relationship="many-to-one";
	property name="course"       relatedTo="course"       relationship="many-to-many" relatedVia="course_module";
	property name="class_type"   relatedTo="class_type"   relationship="many-to-many" relatedVia="module_class_type";
	property name="custom_rule"  relatedTo="custom_rule"  relationship="one-to-many"  relationshipKey="module";

	public query function findByUserId( required string userId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "website_user.id"=userId } );
	}

	public query function findByIdAndUserId( required string moduleId, required string userId, required array selectFields ){
		var filter = {
			  "module.id"       = moduleId
			, "website_user.id" = userId
		}
		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findAvailableByCourseId(
		  required string courseId
		, required array  selectFields
		, required date   startDatetime
		, required date   endDatetime 
	){
		return this.selectData(
			  selectFields = selectFields
			, filter       = "
				    course.id                          = :course.id
				AND course_module.effective_timestamp <= :course_module.effective_timestamp
				AND (
				       course_module.idle_timestamp IS NULL
				    OR course_module.idle_timestamp >= :course_module.idle_timestamp
				)
			"
			, filterParams = {
				  "course.id"                         = courseId
				, "course_module.effective_timestamp" = startDatetime
				, "course_module.idle_timestamp"      = endDatetime
			}
		);
	}

	public query function findByNameOrAbbreviation(
		  required string nameOrAbbreviation
		, required array  selectFields
		, required string userId
	){
		return this.selectData(
			  selectFields = selectFields
			, filter       = "
				    website_user.id = :website_user.id
				AND (
				       module.label        LIKE :module.label
				    OR module.abbreviation LIKE :module.abbreviation
				)
			"
			, filterParams = {
				  "website_user.id"     = userId
				, "module.label"        = "%#nameOrAbbreviation#%"
				, "module.abbreviation" = "%#nameOrAbbreviation#%"
			}
		);
	}
}