component {
	/**
	 * @venueObject.inject          presidecms:object:venue
	 * @classTypeVenueObject.inject presidecms:object:class_type_venue
	 * @websiteLoginService.inject  WebsiteLoginService
	**/
	public any function init(
		  required venue               venueObject
		, required class_type_venue    classTypeVenueObject
		, required WebsiteLoginService websiteLoginService
	){
		_setVenueObject( venueObject );
		_setClassTypeVenueObject( classTypeVenueObject );
		_setWebsiteLoginService( websiteLoginService );
	}

	public array function getVenueArray(){
		var venueArray    = [];
		var selectFields   = [
			  "venue.id"
			, "venue.label AS name"
			, "venue.abbreviation"
			, "venue.capacity"
			, "venue.available"
		];
		var loggedInUserId = _getWebsiteLoginService().getLoggedInUserId();
		var venueQuery    = _getVenueObject().findByUserId( userId=loggedInUserId, selectFields=selectFields );

		venueQuery.each( function( venue ){
			venueArray.append( venue );
		} );

		return venueArray;
	}

	public struct function getRelatedClassTypeByClassTypeVenueId( required string classTypeVenueId ){
		var selectFields = [ "class_type.label AS name" ];

		var relatedVenuesQuery = _getClassTypeVenueObject().findById( classTypeVenueId=classTypeVenueId, selectFields=selectFields );

		if ( relatedVenuesQuery.recordCount == 0) {
			return {};
		}

		return queryGetRow( relatedVenuesQuery, 1 );
	}

	public array function getRelatedClassTypesById( required string venueId ){
		var selectFields       = [ "class_type.label AS name" ];
		var relatedVenuesQuery = _getClassTypeVenueObject().findByVenueId( venueId=venueId, selectFields=selectFields );
		var relatedVenues      = [];

		relatedVenuesQuery.each( function( relatedVenue ){
			relatedVenues.append( relatedVenue );
		} );

		return relatedVenues;
	}

	public boolean function isVenueBelongsToCurrentUser( required string venueId ){
		var venueQueryArgs = {
			  selectFields = [ "venue.id" ]
			, venueId      = arguments.venueId
			, userId       = _getLogggedInUserId()
		};
		var venueQuery = _getVenueObject().findByIdAndUserId( argumentCollection=venueQueryArgs );

		return venueQuery.recordCount > 0;
	}

	public struct function getVenueById( required string venueId ){
		var selectFields = [
			  "venue.label AS name"
			, "venue.abbreviation"
			, "venue.capacity"
			, "venue.available"
		];
		var venueQuery = _getVenueObject().findByIdAndUserId(
			  venueId      = venueId
			, userId       = _getLogggedInUserId()
			, selectFields = selectFields
		);

		if ( venueQuery.recordCount==0 ) {
			return {};
		}

		return queryGetRow( venueQuery, 1 );
	}

	public string function createVenue( required struct venueStruct ){
		var data = _processVenueStruct( venueStruct );

		return _getVenueObject().insertData( data=data );
	}

	public string function addRelatedClassType( required struct classTypeVenue, required string venueId ){
		var classTypeVenueStruct = {
			  "venue"      = venueId
			, "class_type" = classTypeVenue.classTypeId
		};

		return _getClassTypeVenueObject().insertData( data=classTypeVenueStruct );
	}

	public boolean function updateVenue( required struct venueStruct ){
		if ( !isVenueBelongsToCurrentUser( venueId ) ) {
			return false;
		}

		var data            = _processVenueStruct( venueStruct );
		var updatedRowCount = _getVenueObject().updateData(
			  data = data
			, id   = venueStruct.id?:""
		);

		return updatedRowCount == 1;
	}

	public boolean function deleteVenue( required string venueId ){
		if ( !isVenueBelongsToCurrentUser( venueId ) ) {
			return false;
		}

		_getClassTypeVenueObject().deleteData( filter={ "venue"=venueId } );

		var deletedRowCount = _getVenueObject().deleteData( id=venueId );

		return deletedRowCount == 1;
	}

	public array function getVenueByNameOrAbbreviation( required string nameOrAbbreviation ){
		var selectFields = [
			  "venue.id"
			, "venue.label AS name"
			, "venue.abbreviation"
		];
		var venueQuery = _getVenueObject().findByNameOrAbbreviation(
			  selectFields       = selectFields
			, nameOrAbbreviation = nameOrAbbreviation
			, userId             = _getWebsiteLoginService().getLoggedInUserId()
		);
		var venueArray = [];

		venueQuery.each( function( venue ){
			venueArray.append( venue );
		} );

		return venueArray;
	}

	private struct function _processVenueStruct( required struct venueStruct ){
		var processedVenueStruct = {
			  "label"        = venueStruct.name         ?: ""
			, "abbreviation" = venueStruct.abbreviation ?: ""
			, "capacity"     = venueStruct.capacity     ?: 0
			, "available"    = venueStruct.available    ?: "0"
			, "website_user" = _getLogggedInUserId()
		};

		return processedVenueStruct;
	}

	private string function _getLogggedInUserId(){
		return _getWebsiteLoginService().getLoggedInUserId();
	}

	private void function _setWebsiteLoginService( required WebsiteLoginService websiteLoginService ){
		variables._websiteLoginService = websiteLoginService;
	}

	private WebsiteLoginService function _getWebsiteLoginService(){
		return variables._websiteLoginService;
	}

	private void function _setclassTypeVenueObject( required class_type_venue classTypeVenueObject ){
		variables._classTypeVenueObject = classTypeVenueObject;
	}

	private class_type_venue function _getClassTypeVenueObject(){
		return variables._classTypeVenueObject;
	}

	private void function _setVenueObject( required venue venueObject ){
		variables._venueObject = venueObject;
	}

	private venue function _getVenueObject(){
		return variables._venueObject;
	}
}