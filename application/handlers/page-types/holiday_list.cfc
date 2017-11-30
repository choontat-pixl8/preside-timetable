component {
	property name="holidayService"  inject="HolidayService";
	property name="siteTreeService" inject="SiteTreeService";
	
	private function index( event, rc, prc, args={} ){
		args.holidayArray = holidayService.getHolidayArray();

		return renderView(
			  view          = "page-types/timetable/rule/holiday/index"
			, args          = args
			, presideObject = "holiday_list"
		);
	}

	public function add( event, rc, prc, args={} ){
		event.include( "css-rule" );
		event.include( "js-holiday" );
		event.includeData( {
			"searchLecturerURL" = event.buildLink( linkTo="page-types.lecturer_list.search" )
		} );
		if ( event.getHTTPMethod() == "POST" ) {
			var holidayDataStruct = {
				  name           = rc.name               ?: ""
				, beginTimestamp = rc.beginTimestamp     ?: ""
				, endTimestamp   = rc.endTimestamp       ?: ""
				, lecturerId     = rc.selectedLecturerId ?: ""
			};

			if ( holidayService.isHolidayDataValid( holidayDataStruct ) ) {
				var linkTo = "rule/holiday";

				holidayService.addHoliday( holidayDataStruct );

				setNextEvent( url=event.buildLink( linkTo=linkTo ) );

				return;
			}
		}

		event.initializeDummyPresideSiteTreePage(
			  title      = "Add Holiday"
			, parentPage = siteTreeService.getPage( systemPage="holiday_list" )
		);

		event.setView( view="page-types/timetable/rule/holiday/add", args=args );
	}

	public function delete( event, rc, prc, args={} ){
		var holidayId = prc.holidayId?:"";

		if ( holidayService.isHolidayBelongsToCurrentUser( holidayId ) ) {
			holidayService.deleteHoliday( holidayId );
		}

		setNextEvent( url=event.buildLink( linkTo="rule/holiday" ) );
	}
}