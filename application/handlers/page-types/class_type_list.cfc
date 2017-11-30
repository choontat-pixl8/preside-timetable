component {
	property name="classTypeService" inject="ClassTypeService";
	property name="siteTreeService"  inject="SiteTreeService";

	private function index( event, rc, prc, args={} ){
		args.classTypeArray = classTypeService.getClassTypeArray();

		return renderView(
			  view          = "page-types/timetable/resource/class_type/index"
			, args          = args
			, presideObject = "class_type_list"
		);
	}

	public function add( event, rc, prc, args={} ){
		if ( event.getHTTPMethod() == "POST" ) {
			var formName         = "timetable.resource.classType";
			var formData         = event.getCollectionForForm( formName );
			var validationResult = validateForm( formName=formName, formData=formData );
			var hasError         = validationResult.listErrorFields().len() > 0;

			if ( hasError ) {
				args.validationResult = validationResult;
				args.savedData        = formData;
			} else {
				var linkTo      = "resource/class-type";
				var classTypeId = classTypeService.createClassType( formData );

				if ( formData.addRelatedModulesOrVenues?:"0"=="1" ) {
					linkTo &= "/#classTypeId#/view"
				}

				setNextEvent( url=event.buildLink( linkTo=linkTo ) );
				
				return;
			}
		}

		event.initializeDummyPresideSiteTreePage(
			  title      = "Add ClassType"
			, parentPage = siteTreeService.getPage( systemPage="class_type_list" )
		);

		event.setView( view="page-types/timetable/resource/class_type/add", args=args );
	}

	public function addRelatedModule( event, rc, prc, args={} ){
		var classTypeId          = trim ( rc.classTypeId          ?: "" );
		var moduleId             = trim ( rc.moduleId             ?: "" );
		var assignTimeRangeStart = trim ( rc.assignTimeRangeStart ?: "" );
		var assignTimeRangeEnd   = trim ( rc.assignTimeRangeEnd   ?: "" );

		if (
			   classTypeId.len()          > 0
			&& moduleId.len()             > 0
			&& assignTimeRangeStart.len() > 0
			&& assignTimeRangeEnd.len()   > 0
		) {
			var moduleClassTypeStruct = {
				  moduleId             = moduleId
				, assignTimeRangeStart = assignTimeRangeStart
				, assignTimeRangeEnd   = assignTimeRangeEnd
			}

			var moduleClassTypeId     = classTypeService.addRelatedModule( moduleClassTypeStruct, classTypeId );
			var moduleClassTypeStruct = classTypeService.getRelatedModuleByModuleClassTypeId( moduleClassTypeId );
			var message               = "Related module added.";

			moduleClassTypeStruct.assignTimeRangeStart = timeFormat( moduleClassTypeStruct.assignTimeRangeStart, "HH:mm" );
			moduleClassTypeStruct.assignTimeRangeEnd   = timeFormat( moduleClassTypeStruct.assignTimeRangeEnd  , "HH:mm" );

			return _buildResponseMessageAsJson( message=message, messageType="success", success=true, data=moduleClassTypeStruct );
		}

		var message = "Invalid data given.";

		return _buildResponseMessageAsJson( message=message, messageType="danger" );
	}

	public function addRelatedVenue( event, rc, prc, args={} ){
		var venueId     = trim( rc.venueId     ?: "" );
		var classTypeId = trim( rc.classTypeId ?: "" );

		if ( venueId.len() > 0 && classTypeId.len() > 0 ) {
			var relatedVenueId     = classTypeService.addRelatedVenue( venueId=venueId, classTypeId=classTypeId );
			var relatedVenueStruct = classTypeService.getRelatedVenueByClassTypeVenueId( relatedVenueId );
			var message            = "Related venue added.";

			return _buildResponseMessageAsJson( message=message, messageType="success", success=true, data=relatedVenueStruct );
		}

		var message = "Invalid data given.";

		return _buildResponseMessageAsJson( message=message, messageType="danger" );
	}

	public function view( event, rc, prc, args={} ){
		var classTypeId = prc.classTypeId ?: "";
		
		if ( !classTypeService.isClassTypeBelongsToCurrentUser( classTypeId ) ) {
			event.accessDenied( reason="INSUFFICIENT_PRIVILEGES" );

			return;
		}

		args.classTypeDataStruct    = classTypeService.getClassTypeById( classTypeId=classTypeId );
		args.classTypeDataStruct.id = classTypeId;
		args.relatedModules         = classTypeService.getRelatedModulesById( classTypeId );
		args.relatedVenues          = classTypeService.getRelatedVenuesById( classTypeId );

		event.initializeDummyPresideSiteTreePage(
			  title      = "View ClassType"
			, parentPage = siteTreeService.getPage( systemPage="class_type_list" )
		);

		event.include( "css-resource" );
		event.include( "js-classType" );

		event.includeData( {
			  "addRelatedModuleURL" = event.buildLink( linkTo="page-types.class_type_list.addRelatedModule" )
			, "addRelatedVenueURL"  = event.buildLink( linkTo="page-types.class_type_list.addRelatedVenue" )
		} );

		event.setView( view="page-types/timetable/resource/class_type/view", args=args );
	}

	public function edit( event, rc, prc, args={} ){
		var moduleDetailsStruct = {
			  "id"                    = rc.classTypeId           ?: ""
			, "name"                  = rc.name                  ?: ""
			, "description"           = rc.description           ?: ""
			, "abbreviation"          = rc.abbreviation          ?: ""
			, "durationInMinutes"     = rc.durationInMinutes     ?: "0"
			, "applicableToSunday"    = rc.applicableToSunday    ?: "0"
			, "applicableToMonday"    = rc.applicableToMonday    ?: "0"
			, "applicableToTuesday"   = rc.applicableToTuesday   ?: "0"
			, "applicableToWednesday" = rc.applicableToWednesday ?: "0"
			, "applicableToThursday"  = rc.applicableToThursday  ?: "0"
			, "applicableToFriday"    = rc.applicableToFriday    ?: "0"
			, "applicableToSaturday"  = rc.applicableToSaturday  ?: "0"
		};

		var updated = classTypeService.updateClassType( moduleDetailsStruct );

		setNextEvent( url=event.buildLink( linkTo="resource/class-type" ) );
	}

	public function delete( event, rc, prc, args={} ){
		classTypeService.deleteClassType( rc.classTypeId?:"" );
		
		setNextEvent( url=event.buildLink( linkTo="resource/class-type" ) );
	}

	public function search( event, rc, prc, args={} ){
		var searchQuery       = trim( rc.searchQuery ?: "" );
		var searchResultArray = classTypeService.getClassTypeByNameOrAbbreviation( searchQuery );

		return serializeJSON( searchResultArray );
	}

	private string function _buildResponseMessageAsJson(
		  required string  message
		,          string  messageType = "info"
		,          boolean success     = false
		,          struct  data        = {}
	){
		return serializeJSON( { "message"=message, "messageType"=messageType, "success"=success, "data"=data } );
	}
}