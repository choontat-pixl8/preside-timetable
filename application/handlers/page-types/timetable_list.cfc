component {
	property name="timetableService" inject="TimetableService";
	property name="notificationService" inject="notificationService";

	private function index( event, rc, prc, args={} ){
		args.timetableArray = timetableService.getTimetableArray();

		return renderView(
			  view = "page-types/timetable/index"
			, args = args
			, presideObject = "timetable_list"
		);
	}

	private function _generate( event, rc, prc, args={} ){
		var generatedTimetableInfo = timetableService.generateTimetable( { name="Sample", dateOfWeek="2017-11-29" } );
		args.generatedTimetable = generatedTimetableInfo.classSessionArray;

		notificationService.createNotification(
              topic = "timetableGenerated"
            , type  = "ALERT"
            , data  = { requestId=generatedTimetableInfo.requestId }
        );

		return renderView(
			  view = "page-types/timetable/_generated_timetable"
			, args = args
		);
	}
}