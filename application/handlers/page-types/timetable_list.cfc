component {
	property name="timetableService" inject="TimetableService";

	private function index( event, rc, prc, args={} ){
		args.timetableArray = timetableService.getTimetableArray();

		return renderView(
			  view = "page-types/timetable/index"
			, args = args
			, presideObject = "timetable_list"
		);
	}

	private function _generate( event, rc, prc, args={} ){
		args.generatedTimetable = timetableService.generateTimetable( { name="Sample", dateOfWeek="2017-11-29" } );

		return renderView(
			  view = "page-types/timetable/_generated_timetable"
			, args = args
		);
	}
}