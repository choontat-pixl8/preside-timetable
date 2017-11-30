/**
 * @isSystemPageType true
**/
component {
	property name="completion_timestamp" dbtype="timestamp" default="NULL";
	property name="date_of_week" dbtype="date" required="true";
	property name="status" default="Pending";

	property name="website_user" relatedTo="website_user" relationship="many-to-one";
	property name="class_sessions" relatedTo="class_session" relationship="one-to-many" relationshipKey="generation_request";

	public query function findByUserId( required string userId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "website_user.id"=userId } );
	}
}