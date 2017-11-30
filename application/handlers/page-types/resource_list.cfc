component {
	property name="intakeService" inject="IntakeService";

	private function index( event, rc, prc, args={} ){
		return renderView(
			  view = "page-types/timetable/resource/index"
			, args = args
		);
	}
}