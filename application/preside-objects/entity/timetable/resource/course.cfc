/**
 * @isSystemPageType true
**/
component dataManagerGroup="resource"{
	property name="description"  required="true" maxLength="100";
	property name="abbreviation" required="true" maxLength="20" uniqueIndexes="abbreviation";

	property name="website_user"   relatedTo="website_user"   relationship="many-to-one";
	property name="intakes" relatedTo="intake" relationship="many-to-many" relatedVia="intake_course";
	property name="modules" relatedTo="module" relationship="many-to-many" relatedVia="course_module";
	property name="custom_rules" relatedTo="custom_rule" relationship="one-to-many" relationshipKey="course";

	public query function findByIdAndUserId( required string courseId, required string userId, required array selectFields ){
		var filter = {
			  "course.id" = courseId
			, "website_user.id" = userId
		}
		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByUserId( required string userId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "website_user.id"=userId } );
	}

	public query function findByIntakeId( required string intakeId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "intake.id"=intakeId } );
	}

	public query function findByModuleId( required string moduleId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "module.id"=moduleId } );
	}

	public query function findByNameOrAbbreviation(
		  required string nameOrAbbreviation
		, required array selectFields
		, required string userId
	){
		return this.selectData(
			selectFields = selectFields
			, filter = "
				    website_user.id = :website_user.id
				AND (
				       course.label        LIKE :course.label
				    OR course.abbreviation LIKE :course.abbreviation
				)
			"
			, filterParams = {
				  "website_user.id" = userId
				, "course.label" = "%#nameOrAbbreviation#%"
				, "course.abbreviation" = "%#nameOrAbbreviation#%"
			}
		);
	}

	public query function findAvailableByIntakeId(
		  required string intakeId
		, required array selectFields
		, required date startDatetime
		, required date endDatetime 
	){
		return this.selectData(
			selectFields = selectFields
			, filter = "
				    intakes.id = :intakes.id
				AND intake_course.effective_timestamp <= :intake_course.effective_timestamp
				AND (
				       intake_course.idle_timestamp IS NULL
				    OR intake_course.idle_timestamp >= :intake_course.idle_timestamp
				)
			"
			, filterParams = {
				  "intakes.id" = intakeId
				, "intake_course.effective_timestamp" = startDatetime
				, "intake_course.idle_timestamp" = endDatetime
			}
		);
	}
}