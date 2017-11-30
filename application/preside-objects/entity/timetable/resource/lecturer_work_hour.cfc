/**
 * @isSystemPageType true
 * @noLabel true
**/
component {
	property name="start_time" dbtype="time" required="true";
	property name="end_time"   dbtype="time" required="true";

	property name="day_of_week" required="true" enum="dayInWeek";

	property name="lecturer" relatedTo="lecturer" relationship="many-to-one";

	public query function findByIdAndUserId( required string lecturerWorkHourId, required string userId, required array selectFields ){
		var filter = {
			  "lecturer_work_hour.id" = lecturerWorkHourId
			, "website_user.id"       = userId
		}
		return this.selectData( selectFields=selectFields, filter=filter );
	}

	public query function findByLecturerId( required string lecturerId, required string userId, required array selectFields ){
		var filter = {
			  "lecturer.id"     = lecturerId
			, "website_user.id" = userId
		}
		return this.selectData( selectFields=selectFields, filter=filter );
	}
}