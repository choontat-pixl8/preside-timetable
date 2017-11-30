component {
	/**
	 * @holidayObject.inject       presidecms:object:holiday
	 * @websiteLoginService.inject WebsiteLoginService
	 * @lecturerService.inject     delayedInjector:lecturerService
	**/
	public HolidayService function init(
		  required holiday             holidayObject
		, required WebsiteLoginService websiteLoginService
		, required any                 lecturerService
	){
		_setWebsiteLoginService( websiteLoginService );
		_setHolidayObject( holidayObject );
		_setLecturerService( lecturerService );

		return this;
	}

	public array function getHolidayArray(){
		var selectFields = [
			  "holiday.id"
			, "holiday.label           AS name"
			, "holiday.begin_timestamp AS beginTimestamp"
			, "holiday.end_timestamp   AS endTimestamp"
			, "lecturer.label          AS lecturerName"
			, "lecturer.abbreviation   AS lecturerAbbreviation"
		];
		var userId       = _getLoggedInUserId();
		var holidayQuery = _getHolidayObject().findByUserId( userId=userId, selectFields=selectFields );
		var holidays     = [];

		holidayQuery.each( function( holiday ){
			if ( holiday.lecturerName.len()>0 ) {
				holiday.lecturerName = "#holiday.lecturerName# (#holiday.lecturerAbbreviation#)";
			} else {
				holiday.lecturerName = "ALL";
			}

			structDelete( holiday, "lecturerAbbreviation" );

			holidays.append( holiday );
		} );

		return holidays;
	}

	public string function addHoliday( required struct holidayStruct ){
		var holidayDataStruct = _processHolidayStruct( holidayStruct );

		return _getHolidayObject().insertData( data=holidayDataStruct );
	}

	public boolean function updateHoliday( required struct holidayStruct, required string holidayId ){
		var holidayDataStruct = _processHolidayStruct( holidayStruct );

		var updatedRowCount   = _getHolidayObject().updateData( data=holidayDataStruct, id=holidayId );

		return updatedRowCount==1;
	}

	public boolean function isHolidayBelongsToCurrentUser( required string holidayId ){
		var selectFields = [ "holiday.id" ];
		var holidayQuery = _getHolidayObject().findByIdAndUserId(
			  holidayId    = holidayId
			, userId       = _getLoggedInUserId()
			, selectFields = selectFields
		);

		return holidayQuery.recordCount > 0;
	}

	public boolean function deleteHoliday( required string holidayId ){
		if ( !isHolidayBelongsToCurrentUser( holidayId ) ) {
			return false;
		}

		var affectedRecordCount = _getHolidayObject().deleteData( id=holidayId );

		return affectedRecordCount > 1;
	}

	public boolean function isHolidayDataValid( required struct holidayDataStruct ){
		if ( REmatch( "^[a-zA-Z0-9 \-'""]+$", holidayDataStruct.name?:"" ).len() == 0 ) {
			return false;
		}

		if ( !isDate( holidayDataStruct.beginTimestamp?:"" ) || !isDate( holidayDataStruct.endTimestamp?:"" ) ) {
			return false;
		}

		if (
			   holidayDataStruct.lecturerId != ""
			&& !_getLecturerService().isLecturerBelongsToCurrentUser( holidayDataStruct.lecturerId )
		) {
			return false;
		}

		return true;
	}

	private struct function _processHolidayStruct( required struct holidayStruct ){
		return {
			  "label"           = holidayStruct.name           ?: ""
			, "begin_timestamp" = holidayStruct.beginTimestamp ?: ""
			, "end_timestamp"   = holidayStruct.endTimestamp   ?: ""
			, "lecturer"        = holidayStruct.lecturerId     ?: ""
			, "website_user"    = _getLoggedInUserId()
		};
	}

	private string function _getLoggedInUserId(){
		return _getWebsiteLoginService().getLoggedInUserId();
	}

	private void function _setWebsiteLoginService( required WebsiteLoginService websiteLoginService ){
		variables._websiteLoginService = websiteLoginService;
	}

	private WebsiteLoginService function _getWebsiteLoginService(){
		return variables._websiteLoginService;
	}

	private void function _setHolidayObject( required holiday holidayObject ){
		variables._holidayObject = holidayObject;
	}

	private holiday function _getHolidayObject(){
		return variables._holidayObject;
	}

	private void function _setLecturerService( required any lecturerService ){
		variables._lectureService = lecturerService;
	}

	private any function _getLecturerService(){
		return variables._lectureService;
	}
}