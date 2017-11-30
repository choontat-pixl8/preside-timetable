component extends="preside.system.config.Config" {

	public void function configure() {
		super.configure();

		settings.preside_admin_path  = "preside_admin";
		settings.system_users        = "sysadmin";
		settings.default_locale      = "en";
		settings.default_log_name    = "practice-timetable";
		settings.default_log_level   = "information";
		
		settings.sql_log_name        = "practice-timetable";
		settings.sql_log_level       = "information";

		settings.ckeditor.defaults.stylesheets.append( "css-bootstrap" );
		settings.ckeditor.defaults.stylesheets.append( "css-layout" );

		settings.features.websiteUsers.enabled = true;

		settings.notificationTopics.append( "timetableGenerated" );

		settings.enum.dayInWeek = [
			  "Sunday"
			, "Monday"
			, "Tuesday"
			, "Wednesday"
			, "Thursday"
			, "Friday"
			, "Saturday"
		];
	}
}
