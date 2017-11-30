/**
 * @isSystemPageType true
**/
component {
	property
		name            = "time_overlap_rules"
		relatedTo       = "time_overlap_rule"
		relationship    = "one-to-many"
		relationshipKey = "time_overlap_rule_group";

	property name="website_user" relatedTo="website_user" relationship="many-to-one";
}