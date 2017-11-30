component {
	/**
	 * @timeslotObject.inject presidecms:object:timeslot
	 * @websiteLoginService.inject WebsiteLoginService
	**/
	public any function init(
		  required timeslot            timeslotObject
		, required WebsiteLoginService websiteLoginService
	){
		_setTimeslotObject( timeslotObject );
		_setWebsiteLoginService( websiteLoginService );
	}

	public array function getTimeslotArray(){
		var timeslotArray    = [];
		var selectFields   = [
			  "timeslot.id"
			, "timeslot.start_time AS startTime"
			, "timeslot.end_time   AS endTime"
		];
		var loggedInUserId = _getLogggedInUserId();
		var timeslotQuery    = _getTimeslotObject().findByUserId( userId=loggedInUserId, selectFields=selectFields );

		timeslotQuery.each( function( timeslot ){
			timeslotArray.append( timeslot );
		} );

		return timeslotArray;
	}

	public boolean function isTimeslotsOverlapped( required struct timeslotA, required struct timeslotB ){
		if ( timeslotA.startTime>=timeslotB.startTime && timeslotA.startTime<=timeslotB.endTime ) {
			return true;
		}
		
		if ( timeslotA.endTime>=timeslotB.startTime && timeslotA.endTime<=timeslotB.endTime ){
			return true;
		}

		if ( timeslotB.startTime>=timeslotA.startTime && timeslotB.startTime<=timeslotA.endTime ) {
			return true;
		}
		
		if ( timeslotB.endTime>=timeslotA.startTime && timeslotB.endTime<=timeslotA.endTime ){
			return true;
		}

		return false;
	}

	public boolean function isTimeslotBelongsToCurrentUser( required string timeslotId ){
		var timeslotQueryArgs = {
			  selectFields = [ "timeslot.id" ]
			, timeslotId = arguments.timeslotId
			, userId = _getLogggedInUserId()
		};
		var timeslotQuery = _getTimeslotObject().findByIdAndUserId( argumentCollection=timeslotQueryArgs );

		return timeslotQuery.recordCount > 0;
	}

	public struct function getTimeslotById( required string timeslotId ){
		var selectFields   = [
			  "timeslot.id"
			, "timeslot.start_time AS startTime"
			, "timeslot.end_time   AS endTime"
		];
		var timeslotQuery = _getTimeslotObject().findByIdAndUserId(
			  timeslotId = timeslotId
			, userId = _getLogggedInUserId()
			, selectFields = selectFields
		);

		if ( timeslotQuery.recordCount == 0 ) {
			return {};
		}

		return queryGetRow( timeslotQuery, 1 );
	}

	public string function createTimeslot( required struct timeslotStruct ){
		var data = _processTimeslotStruct( timeslotStruct );

		return _getTimeslotObject().insertData( data=data );
	}

	public boolean function updateTimeslot( required struct timeslotStruct ){
		if ( !isTimeslotBelongsToCurrentUser( timeslotId ) ) {
			return false;
		}

		var data = _processTimeslotStruct( timeslotStruct );
		var updatedRowCount = _getTimeslotObject().updateData(
			  data = data
			, id   = timeslotStruct.id?:""
		);

		return updatedRowCount == 1;
	}

	public boolean function deleteTimeslot( required string timeslotId ){
		if ( !isTimeslotBelongsToCurrentUser( timeslotId ) ) {
			return false;
		}

		var deletedRowCount = _getTimeslotObject().deleteData( id=timeslotId );

		return deletedRowCount == 1;
	}

	private struct function _processTimeslotStruct( required struct timeslotStruct ){
		var processedTimeslotStruct = {
			  "start_time"   = timeslotStruct.startTime ?: "00:00"
			, "end_time"     = timeslotStruct.endTime   ?: "00:00"
			, "website_user" = _getLogggedInUserId()
		};

		return processedTimeslotStruct;
	}

	private string function _getLogggedInUserId(){
		return _getWebsiteLoginService().getLoggedInUserId();
	}

	private void function _setWebsiteLoginService( required WebsiteLoginService websiteLoginService ){
		variables._websiteLoginService = websiteLoginService;
	}

	private WebsiteLoginService function _getWebsiteLoginService(){
		return variables._websiteLoginService;
	}

	private void function _setTimeslotObject( required timeslot timeslotObject ){
		variables._timeslotObject = timeslotObject;
	}

	private timeslot function _getTimeslotObject(){
		return variables._timeslotObject;
	}
}