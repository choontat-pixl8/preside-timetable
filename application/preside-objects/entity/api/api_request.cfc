/**
 * @isSystemPageType true
**/
component {
	property name="status"               required="true" dbtype="varchar"   default="Started" maxLength="50";
	property name="completion_timestamp"                 dbtype="timestamp";

	property name="api_profile" required="true" relatedTo="api_profile" relationship="many-to-one";
}