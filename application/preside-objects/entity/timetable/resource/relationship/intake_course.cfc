/**
 * @isSystemPageType true
 * @nolabel true
**/
component {
	property name="student_count"       dbtype="int"       required="true";
	property name="effective_timestamp" dbtype="timestamp" required="true";
	property name="idle_timestamp"      dbtype="timestamp";

	property name="merge_class_rules" relatedTo="class_merging_rule" relationship="one-to-many" relationshipKey="intake_course";
	property name="intake"            relatedTo="intake"             relationship="many-to-one";
	property name="course"            relatedTo="course"             relationship="many-to-one";

	public query function findByIntakeAndCourse( required string intakeId, required string courseId, required array selectFields ){
		var filter = {
			  "intake" = intakeId
			, "course" = courseId
		};

		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByIntakeId( required string intakeId, required array selectFields ){
		var filter = { "intake"=intakeId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByCourseId( required string courseId, required array selectFields ){
		var filter = { "course"=courseId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findById( required string intakeCourseId, required array selectFields ){
		var filter = { "intake_course.id"=intakeCourseId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}
}