/**
 * @isSystemPageType true
 * @nolabel true
**/
component {
	property name="class_type" relatedTo="class_type" relationship="many-to-one";
	property name="venue"      relatedTo="venue"      relationship="many-to-one";

	public query function findById( required string classTypeVenueId, required array selectFields ){
		var filter = { "class_type_venue.id"=classTypeVenueId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByClassTypeId( required string classTypeId, required array selectFields ){
		var filter = { "class_type"=classTypeId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByVenueId( required string venueId, required array selectFields ){
		var filter = { "venue"=venueId };

		return this.selectData( selectFields=selectFields, filter=filter );
	}
}