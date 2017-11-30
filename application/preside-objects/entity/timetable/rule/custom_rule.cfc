/**
 * @isSystemPageType true
**/
component {
	property name="day_in_week" enum="dayInWeek";
	
	property name="rule_text" dbtype="text" required="true";

	property name="intake"       relatedTo="intake"       relationship="many-to-one";
	property name="course"       relatedTo="course"       relationship="many-to-one";
	property name="module"       relatedTo="module"       relationship="many-to-one";
	property name="lecturer"     relatedTo="lecturer"     relationship="many-to-one";
	property name="class_type"   relatedTo="class_type"   relationship="many-to-one";
	property name="venue"        relatedTo="venue"        relationship="many-to-one";
	property name="timeslot"     relatedTo="timeslot"     relationship="many-to-one";
	property name="website_user" relatedTo="website_user" relationship="many-to-one";
}