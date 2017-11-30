/**
 * @isSystemPageType true
**/
component {
	property name="abbreviation" maxLength="20" uniqueIndexes="abbreviation";
	property name="capacity" dbtype="int" required="true" default="0";
	property name="available" dbtype="tinyint" required="true" default="1";

	property name="website_user" relatedTo="website_user" relationship="many-to-one";
	property name="custom_rules" relatedTo="custom_rule" relationship="one-to-many" relationshipKey="venue";
	property name="class_sessions" relatedTo="class_session" relationship="one-to-many" relationshipKey="venue";
	property name="class_type" relatedTo="class_type" relationship="many-to-many" relatedVia="class_type_venue";

	public query function findByUserId( required string userId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "website_user.id"=userId } );
	}

	public query function findByIdAndUserId( required string userId, required string venueId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "venue.id"=venueId, "website_user.id"=userId } );
	}

	public query function findByNameOrAbbreviation(
		  required string nameOrAbbreviation
		, required array  selectFields
		, required string userId
	){
		return this.selectData(
			  selectFields = selectFields
			, filter = "
				    website_user.id = :website_user.id
				AND (
				       venue.label        LIKE :venue.label
				    OR venue.abbreviation LIKE :venue.abbreviation
				)
			"
			, filterParams = {
				  "website_user.id" = userId
				, "venue.label" = "%#nameOrAbbreviation#%"
				, "venue.abbreviation" = "%#nameOrAbbreviation#%"
			}
		);
	}

	public query function findAvailableByClassTypeId(
		  required string  classTypeId
		, required array   selectFields
		,          numeric studentCount=0
	){
		return this.selectData(
			  selectFields = selectFields
			, filter       = "
				    class_type.id    = :class_type.id
				AND venue.available  = TRUE
				AND venue.capacity  >= :venue.capacity
			"
			, filterParams = {
				  "class_type.id"  = classTypeId
				, "venue.capacity" = studentCount
			}
		);
	}
}