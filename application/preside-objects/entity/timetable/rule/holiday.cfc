/**
 * @isSystemPageType true
**/
component {
	property name="begin_timestamp" dbtype="timestamp" required="true";
	property name="end_timestamp"   dbtype="timestamp" required="true";

	property name="lecturer" relatedTo="lecturer" relationship="many-to-one";
	property name="website_user"     relatedTo="website_user"     relationship="many-to-one";

	public query function findByUserId( required string userId, required array selectFields ){
		return this.selectData( selectFields=selectFields, filter={ "website_user.id"=userId } );
	}

	public query function findByIdAndUserId( required string userId, required string holidayId, required array selectFields ){
		var filter = { "website_user.id"=userId, "holiday.id"=holidayId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}
}