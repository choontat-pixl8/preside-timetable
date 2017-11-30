/**
 * @isSystemPageType true
**/
component {
	property name="label"                       required="false";
	property name="public_key" dbtype="varchar" required="true"  generator="UUID" uniqueIndexes="publicApiKey";
	property name="active"     dbtype="tinyint" required="true"                   default="1";

	property name="user_role"    relatedTo="user_role"    relationship="many-to-one";
	property name="website_user" relatedTo="website_user" relationship="many-to-one";
	property name="api_requests" relatedTo="api_request"  relationship="one-to-many" relationshipKey="api_profile";

	public array function getApiRequestArray( required string apiKey ){
		var apiRequestArray = [];
		var apiRequestQuery = this.selectData(
			selectFields = [
				  "api_request.datecreated          AS requestTimestamp"
				, "api_request.completion_timestamp AS completionTimestamp"
				, "api_request.status               AS status"
			]
			, filter = { "public_key"=apiKey }
		);

		apiRequestQuery.each( function( apiRequest ){
			var apiRequestStruct = {
				  "requestTimestamp"    = requestTimestamp
				, "completionTimestamp" = completionTimestamp
				, "status"              = status
			};

			apiRequestArray.append( apiRequestStruct );
		} );

		return apiRequestArray;
	}
}