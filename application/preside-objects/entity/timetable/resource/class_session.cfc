/**
 * @isSystemPageType true
 * @noLabel true
**/
component {
	property name="session_date" dbtype="date";
	property name="is_published" dbtype="tinyint" default="0";

	property name="generation_request" relatedTo="generation_request" relationship="many-to-one";
	property name="intake"             relatedTo="intake"             relationship="many-to-one";
	property name="course"             relatedTo="course"             relationship="many-to-one";
	property name="module"             relatedTo="module"             relationship="many-to-one";
	property name="class_type"         relatedTo="class_type"         relationship="many-to-one";
	property name="lecturer"           relatedTo="lecturer"           relationship="many-to-one";
	property name="timeslot"           relatedTo="timeslot"           relationship="many-to-one";
	property name="venue"              relatedTo="venue"              relationship="many-to-one";

	public query function findById( required string classSessionId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "class_session.id"=classSessionId } );
	}
}