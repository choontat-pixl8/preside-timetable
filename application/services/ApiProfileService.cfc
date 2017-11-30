component {
	/**
	 * @apiProfile.inject presidecms:object:api_profile
	 * @userRole.inject presidecms:object:user_role
	 * @websiteLoginService.inject WebsiteLoginService
	**/
	public any function init(
		  required api_profile         apiProfile
		, required WebsiteLoginService websiteLoginService
		, required user_role           userRole
	){
		_setApiProfileObject   ( apiProfile          );
		_setWebsiteLoginService( websiteLoginService );
		_setUserRoleObject     ( userRole            );
	}

	public string function createNewProfile( required string userRoleName, boolean active=false ){
		var userRoleId     = _getUserRoleId( userRoleName );
		var loggedInUserId = _getWebsiteLoginService().getLoggedInUserId();
		var apiProfileId   = _getApiProfileObject().insertData(
			data = {
				  "user_role"    = userRoleId
				, "website_user" = loggedInUserId
				, "active"       = active
			}
		);

		return _getApiProfileObject().selectData(
			  selectFields = [ "public_key" ]
			, filter       = { "id"=apiProfileId }
		).public_key;
	}

	public array function getRequestHistoryByApiKey( required string apiKey ){
		return _getApiProfileObject().getApiRequestArray();
	}

	private string function _getUserRoleId( required string userRoleName ){
		var userRoleQuery = _getUserRoleObject().selectData(
			  selectFields = [ "id" ]
			, filter       = { "label", userRoleName }
		);

		return userRoleQuery.id?:"";
	}

	private void function _setApiProfileObject( required api_profile apiProfileObject ){
		variables._apiProfileObject = apiProfileObject;
	}

	private api_profile function _getApiProfileObject(){
		return variables._apiProfileObject;
	}

	private void function _setWebsiteLoginService( required WebsiteLoginService websiteLoginService ){
		variables._websiteLoginService = websiteLoginService;
	}

	private WebsiteLoginService function _getWebsiteLoginService(){
		return variables._websiteLoginService;
	}

	private void function _setUserRoleObject( required user_role userRoleObject ){
		variables._userRoleObject = userRoleObject;
	}

	private user_role function _getUserRoleObject(){
		return vairables._userRoleObject;
	}
}