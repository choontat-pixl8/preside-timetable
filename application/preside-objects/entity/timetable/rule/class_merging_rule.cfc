/**
 * @isSystemPageType true
**/
component {
	property name="class_merging_rule_group" relatedTo="class_merging_rule_group" relationship="many-to-one";
	property name="intake_course" relatedTo="intake_course" relationship="many-to-one";
	property name="module_class_type" relatedTo="module_class_type" relationship="many-to-one";
}