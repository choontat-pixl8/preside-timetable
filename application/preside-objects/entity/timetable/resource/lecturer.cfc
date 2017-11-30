/**
 * @isSystemPageType true
**/
component {
	property name="abbreviation" required="true" maxLength="20" uniqueIndexes="abbreviation";

	property name="website_user" relatedTo="website_user" relationship="many-to-one";
	property name="lecturer_work_hours" relatedTo="lecturer_work_hour" relationship="one-to-many" relationshipKey="lecturer";
	property name="holidays" relatedTo="holiday" relationship="one-to-many" relationshipKey="lecturer";
	property name="custom_rules" relatedTo="custom_rule" relationship="many-to-many" relationshipKey="lecturer";
	property name="class_session" relatedTo="class_session" relationship="many-to-many" relationshipKey="lecturer";
	property name="module_class_type_lecturer" relatedTo="module_class_type_lecturer" relationship="many-to-many" relationshipKey="lecturer";

	public query function findByUserId( required string userId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "website_user.id"=userId } );
	}

	public query function findByIdAndUserId( required string lecturerId, required string userId, required array selectFields ){
		var filter = {
			  "lecturer.id" = lecturerId
			, "website_user.id" = userId
		}
		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByNameOrAbbreviation(
		  required string nameOrAbbreviation
		, required array  selectFields
		, required string userId
	){
		return this.selectData(
			selectFields   = selectFields
			, filter       = "
				    website_user.id = :website_user.id
				AND (
				       lecturer.label        LIKE :lecturer.label
				    OR lecturer.abbreviation LIKE :lecturer.abbreviation
				)
			"
			, filterParams = {
				  "website_user.id"     = userId
				, "lecturer.label"        = "%#nameOrAbbreviation#%"
				, "lecturer.abbreviation" = "%#nameOrAbbreviation#%"
			}
		);
	}
}