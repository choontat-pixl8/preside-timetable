/**
 * @isSystemPageType true
 * @noLabel true
**/
component {
	property name="start_time" dbtype="time" required="true";
	property name="end_time"   dbtype="time" required="true";

	property name="website_user"   relatedTo="website_user"  relationship="many-to-one";
	property name="custom_rules"   relatedTo="custom_rule"   relationship="one-to-many" relationshipKey="timeslot";
	property name="class_sessions" relatedTo="class_session" relationship="one-to-many" relationshipKey="timeslot";

	public query function findByUserId( required string userId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "website_user.id"=userId } );
	}

	public query function findByIdAndUserId( required string userId, required string timeslotId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "timeslot.id"=timeslotId, "website_user.id"=userId } );
	}
}