/**
 * @isSystemPageType true
**/
component {
	property name="class_merging_rules" relatedTo="class_merging_rule" relationship="one-to-many" relationshipKey="class_merging_rule_group";
	property name="website_user" relatedTo="website_user" relationship="many-to-one";
}