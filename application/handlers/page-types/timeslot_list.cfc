component {
	property name="timeslotService" inject="TimeslotService";
	property name="siteTreeService" inject="SiteTreeService";

	private function index( event, rc, prc, args={} ){
		args.timeslotArray = timeslotService.getTimeslotArray();

		return renderView(
			  view = "page-types/timetable/resource/timeslot/index"
			, args = args
			, presideObject = "timeslot_list"
		);
	}

	public function add( event, rc, prc, args={} ){
		if ( event.getHTTPMethod() == "POST" ) {
			var formName = "timetable.resource.timeslot";
			var formData = event.getCollectionForForm( formName );
			var validationResult = validateForm( formName=formName, formData=formData );
			var hasError = validationResult.listErrorFields().len() > 0;

			if ( hasError ) {
				args.validationResult = validationResult;
				args.savedData = formData;
			} else {
				var linkTo = "resource/timeslot";
				var timeslotId = timeslotService.createTimeslot( formData );

				if ( formData.addRelatedClassTypes?:"0"=="1" ) {
					linkTo &= "/#timeslotId#/view"
				}

				setNextEvent( url=event.buildLink( linkTo=linkTo ) );
				
				return;
			}
		}

		event.initializeDummyPresideSiteTreePage(
			  title = "Add Timeslot"
			, parentPage = siteTreeService.getPage( systemPage="timeslot_list" )
		);

		event.setView( view="page-types/timetable/resource/timeslot/add", args=args );
	}

	public function view( event, rc, prc, args={} ){
		var timeslotId = prc.timeslotId ?: "";

		if ( !timeslotService.isTimeslotBelongsToCurrentUser( timeslotId ) ) {
			event.accessDenied( reason="INSUFFICIENT_PRIVILEGES" );
			return;
		}

		args.timeslotDataStruct = timeslotService.getTimeslotById( timeslotId=timeslotId );
		args.timeslotDataStruct.id = timeslotId;

		event.initializeDummyPresideSiteTreePage(
			  title = "View Timeslot"
			, parentPage = siteTreeService.getPage( systemPage="timeslot_list" )
		);

		event.include( "css-resource" );

		event.setView( view="page-types/timetable/resource/timeslot/view", args=args );
	}

	public function edit( event, rc, prc, args={} ){
		var timeslotDetailsStruct = {
			  "id" = rc.timeslotId?:""
			, "startTime" = rc.startTime?:""
			, "endTime" = rc.endTime?:""
		};

		var updated = timeslotService.updateTimeslot( timeslotDetailsStruct );

		setNextEvent( url=event.buildLink( linkTo="resource/timeslot" ) );
	}

	public function delete( event, rc, prc, args={} ){
		timeslotService.deleteTimeslot( rc.timeslotId?:"" );

		setNextEvent( url=event.buildLink( linkTo="resource/timeslot" ) );
	}
}