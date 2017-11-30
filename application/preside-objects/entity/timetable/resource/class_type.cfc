/**
 * @isSystemPageType true
**/
component {
	property name="description"             required="true" maxLength="100";
	property name="abbreviation"            required="true" maxLength="20" uniqueIndexes="abbreviation";

	property name="duration_min"            required="true" dbtype="int";
	property name="applicable_to_sunday"    required="true" dbtype="tinyint" default="0";
	property name="applicable_to_monday"    required="true" dbtype="tinyint" default="0";
	property name="applicable_to_tuesday"   required="true" dbtype="tinyint" default="0";
	property name="applicable_to_wednesday" required="true" dbtype="tinyint" default="0";
	property name="applicable_to_thursday"  required="true" dbtype="tinyint" default="0";
	property name="applicable_to_friday"    required="true" dbtype="tinyint" default="0";
	property name="applicable_to_saturday"  required="true" dbtype="tinyint" default="0";

	property name="website_user" relatedTo="website_user" relationship="many-to-one";
	property name="module"       relatedTo="module"       relationship="many-to-many" relatedVia="module_class_type";
	property name="venue"        reletedTo="venue"        relationship="many-to-many" relatedVia="class_type_venue";

	public query function findByIdAndUserId( required string classTypeId, required string userId, required array selectFields ){
		var filter = {
			  "class_type.id" = classTypeId
			, "website_user.id" = userId
		}
		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByUserId( required string userId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "website_user.id"=userId } );
	}

	public query function findByModuleId( required string moduleId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "module.id"=moduleId } );
	}

	public query function findByVenueId( required string venue, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "venue.id"=venue } );
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
				       class_type.label        LIKE :class_type.label
				    OR class_type.abbreviation LIKE :class_type.abbreviation
				)
			"
			, filterParams = {
				  "website_user.id"         = userId
				, "class_type.label"        = "%#nameOrAbbreviation#%"
				, "class_type.abbreviation" = "%#nameOrAbbreviation#%"
			}
		);
	}
}