component {
	property name="venueService" inject="VenueService";
	property name="siteTreeService" inject="SiteTreeService";

	private function index( event, rc, prc, args={} ){
		args.venueArray = venueService.getVenueArray();

		return renderView(
			  view = "page-types/timetable/resource/venue/index"
			, args = args
			, presideObject = "venue_list"
		);
	}

	public function add( event, rc, prc, args={} ){
		if ( event.getHTTPMethod() == "POST" ) {
			var formName = "timetable.resource.venue";
			var formData = event.getCollectionForForm( formName );
			var validationResult = validateForm( formName=formName, formData=formData );
			var hasError = validationResult.listErrorFields().len() > 0;

			if ( hasError ) {
				args.validationResult = validationResult;
				args.savedData = formData;
			} else {
				var linkTo = "resource/venue";
				var venueId = venueService.createVenue( formData );

				if ( ( formData.addRelatedClassTypes?:"0" )=="1" ) {
					linkTo &= "/#venueId#/view"
				}

				setNextEvent( url=event.buildLink( linkTo=linkTo ) );
				
				return;
			}
		}

		event.initializeDummyPresideSiteTreePage(
			  title = "Add Venue"
			, parentPage = siteTreeService.getPage( systemPage="venue_list" )
		);

		event.setView( view="page-types/timetable/resource/venue/add", args=args );
	}

	public function addRelatedClassType( event, rc, prc, args={} ){
		var venueId            = trim ( rc.venueId?:"" );
		var classTypeId        = trim ( rc.classTypeId?:"" );

		if ( venueId.len()>0 && classTypeId.len()>0 ) {
			var classTypeVenueStruct = {
				classTypeId = classTypeId
			};

			var classTypeVenueId = venueService.addRelatedClassType( classTypeVenueStruct, venueId );
			var classTypeVenueStruct = venueService.getRelatedClassTypeByClassTypeVenueId( classTypeVenueId );
			var message = "Related class type added.";

			return _buildResponseMessageAsJson( message=message, messageType="success", success=true, data=classTypeVenueStruct );
		}

		var message = "Invalid data given.";

		return _buildResponseMessageAsJson( message=message, messageType="danger" );
	}

	public function view( event, rc, prc, args={} ){
		var venueId = prc.venueId ?: "";

		if ( !venueService.isVenueBelongsToCurrentUser( venueId ) ) {
			event.accessDenied( reason="INSUFFICIENT_PRIVILEGES" );
			return;
		}

		args.venueDataStruct = venueService.getVenueById( venueId=venueId );
		args.venueDataStruct.id = venueId;
		args.relatedClassTypes = venueService.getRelatedClassTypesById( venueId );

		event.initializeDummyPresideSiteTreePage(
			  title = "View Venue"
			, parentPage = siteTreeService.getPage( systemPage="venue_list" )
		);

		event.include( "css-resource" );
		event.include( "js-venue" );
		event.includeData( {
			"addRelatedClassTypeURL" = event.buildLink( linkTo="page-types.venue_list.addRelatedClassType" )
		} );

		event.setView( view="page-types/timetable/resource/venue/view", args=args );
	}

	public function edit( event, rc, prc, args={} ){
		var venueDetailsStruct = {
			  "id" = rc.venueId?:""
			, "name" = rc.name?:""
			, "abbreviation" = rc.abbreviation?:""
			, "capacity" = rc.capacity?:"0"
			, "available" = rc.available?:"0"
		};

		var updated = venueService.updateVenue( venueDetailsStruct );

		setNextEvent( url=event.buildLink( linkTo="resource/venue" ) );
	}

	public function delete( event, rc, prc, args={} ){
		venueService.deleteVenue( rc.venueId?:"" );

		setNextEvent( url=event.buildLink( linkTo="resource/venue" ) );
	}

	public function search( event, rc, prc, args={} ){
		var searchQuery = trim( rc.searchQuery ?: "" );
		var searchResultArray = venueService.getVenueByNameOrAbbreviation( searchQuery );

		return serializeJSON( searchResultArray );
	}

	private string function _buildResponseMessageAsJson(
		  required string  message
		,          string  messageType="info"
		,          boolean success=false
		,          struct  data={}
	){
		return serializeJSON( { "message"=message, "messageType"=messageType, "success"=success, "data"=data } );
	}
}