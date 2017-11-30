/**
 * @isSystemPageType true
**/
component dataManagerGroup="resource"{
	property name="description"  required="true" maxLength="100";
	property name="abbreviation" required="true" maxLength="50" uniqueIndexes="abbreviation";

	property name="courses"        relatedTo="course"        relationship="many-to-many" relatedVia="intake_course";

	property name="intake_courses" relatedTo="intake_course" relationship="one-to-many"  relationshipKey="intake";
	property name="custom_rules"   relatedTo="custom_rule"   relationship="one-to-many"  relationshipKey="intake";

	property name="website_user"   relatedTo="website_user"  relationship="many-to-one";

	public query function findByAbbreviation(
		  required string  abbreviation
		, required array   selectFields
		,          boolean caseSensitive=false
	){
		var filter       = "intake.abbreviation = #caseSensitive?"BINARY":""# :intake.abbreviation";
		var filterParams = { "intake.abbreviation"=abbreviation };

		return this.selectData( selectFields=selectFields, filter=filter, filterParams=filterParams );
	}

	public query function findByIdAndUserId( required string intakeId, required string userId, required array selectFields ){
		var filter = {
			  "intake.id"       = intakeId
			, "website_user.id" = userId
		}
		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByUserId( required string userId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "website_user.id"=userId } );
	}

	public query function findByCourseId( required string courseId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "course.id"=courseId } );
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
				       intake.label        LIKE :intake.label
				    OR intake.abbreviation LIKE :intake.abbreviation
				)
			"
			, filterParams = {
				  "website_user.id"     = userId
				, "intake.label"        = "%#nameOrAbbreviation#%"
				, "intake.abbreviation" = "%#nameOrAbbreviation#%"
			}
		);
	}

	public query function findAvailableByUserId(
		  required string userId
		, required array  selectFields
		, required date   startDatetime
		, required date   endDatetime
	){
		return this.selectData(
			  selectFields = selectFields
			, filter       = "
				    website_user.id                   =  :website_user.id
				AND intake_course.effective_timestamp <= :intake_course.effective_timestamp
				AND (
				       intake_course.idle_timestamp   IS NULL
				    OR intake_course.idle_timestamp   >= :intake_course.idle_timestamp
				)
			"
			, filterParams  = {
				  "website_user.id"                   = userId
				, "intake_course.effective_timestamp" = startDatetime
				, "intake_course.idle_timestamp"      = endDatetime
			}
		);
	}
}