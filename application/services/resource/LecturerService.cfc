component {
	/**
	 * @lecturerObject.inject presidecms:object:lecturer
	 * @lecturerWorkHourObject.inject presidecms:object:lecturer_work_hour
	 * @moduleClassTypeLecturerObject.inject presidecms:object:module_class_type_lecturer
	 * @websiteLoginService.inject WebsiteLoginService
	**/
	public any function init(
		  required lecturer                   lecturerObject
		, required lecturer_work_hour         lecturerWorkHourObject
		, required module_class_type_lecturer moduleClassTypeLecturerObject
		, required WebsiteLoginService        websiteLoginService
	){
		_setLecturerObject( lecturerObject );
		_setLecturerWorkHourObject( lecturerWorkHourObject );
		_setModuleClassTypeLecturerObject( moduleClassTypeLecturerObject );
		_setWebsiteLoginService( websiteLoginService );
	}

	public array function getLecturerArray(){
		var lecturerArray = [];
		var selectFields  = [
			  "lecturer.id"
			, "lecturer.label AS name"
			, "lecturer.abbreviation"
		];
		var loggedInUserId = _getWebsiteLoginService().getLoggedInUserId();
		var lecturerQuery    = _getLecturerObject().findByUserId( userId=loggedInUserId, selectFields=selectFields );

		lecturerQuery.each( function( lecturer ){
			lecturerArray.append( lecturer );
		} );

		return lecturerArray;
	}

	public array function getLecturersByCourseIdAndModuleId( required string moduleId, required string classTypeId ){
		var selectFields = [ "lecturer.id AS lecturerId" ];
		var moduleClassTypeLecturerQuery = _getModuleClassTypeLecturerObject().findByModuleIdAndClassTypeId(
			  moduleId = moduleId
			, classTypeId = classTypeId
			, selectFields = selectFields
		);
		var lecturersArray = [];

		for ( var moduleClassTypeLecturer in moduleClassTypeLecturerQuery ) {
			lecturersArray.append( moduleClassTypeLecturer.lecturerId );
		}

		return lecturersArray;
	}

	public struct function getLecturerWorkHourByLecturerWorkHourId( required string lecturerWorkHourId ){
		var selectFields = [
			  "lecturer_work_hour.start_time  AS startTime"
			, "lecturer_work_hour.end_time    AS endTime"
			, "lecturer_work_hour.day_of_week AS dayOfWeek"
		];

		var lecturerWorkHourQuery = _getlecturerWorkHourObject().findByIdAndUserId(
			  lecturerWorkHourId = lecturerWorkHourId
			, userId = _getWebsiteLoginService().getLoggedInUserId()
			, selectFields       = selectFields
		);

		if ( lecturerWorkHourQuery.recordCount == 0) {
			return {};
		}

		return queryGetRow( lecturerWorkHourQuery, 1 );
	}

	public array function getLecturerWorkHoursById( required string lecturerId ){
		var selectFields = [
			  "lecturer_work_hour.start_time  AS startTime"
			, "lecturer_work_hour.end_time    AS endTime"
			, "lecturer_work_hour.day_of_week AS dayOfWeek"
		];

		var lecturerWorkHourQuery = _getlecturerWorkHourObject().findByLecturerId(
			  lecturerId=lecturerId
			, selectFields=selectFields
			, userId = _getWebsiteLoginService().getLoggedInUserId()
		);
		var lecturerWorkHours = [];

		lecturerWorkHourQuery.each( function( lecturerWorkHour ){
			lecturerWorkHours.append( lecturerWorkHour );
		} );

		return lecturerWorkHours;
	}

	public boolean function isLecturerBelongsToCurrentUser( required string lecturerId ){
		var lecturerQueryArgs = {
			  selectFields = [ "lecturer.id" ]
			, lecturerId = arguments.lecturerId
			, userId = _getLogggedInUserId()
		};
		var lecturerQuery = _getLecturerObject().findByIdAndUserId( argumentCollection=lecturerQueryArgs );

		return lecturerQuery.recordCount > 0;
	}

	public struct function getLecturerById( required string lecturerId ){
		var selectFields = [ "lecturer.label AS name", "lecturer.abbreviation" ];
		var lecturerQuery = _getLecturerObject().findByIdAndUserId(
			  lecturerId = lecturerId
			, userId = _getLogggedInUserId()
			, selectFields = selectFields
		);

		if ( lecturerQuery.recordCount == 0 ) {
			return {};
		}

		return queryGetRow( lecturerQuery, 1 );
	}

	public string function createLecturer( required struct lecturerStruct ){
		var data = _processLecturerStruct( lecturerStruct );

		return _getLecturerObject().insertData( data=data );
	}

	public string function addLecturerWorkHour( required struct lecturerWorkHour ){
		var lecturerWorkHourStruct = {
			  "lecturer" = lecturerWorkHour.lecturerId
			, "start_time" = lecturerWorkHour.startTime
			, "end_time" = lecturerWorkHour.endTime
			, "day_of_week" = lecturerWorkHour.dayOfWeek
		};

		return _getLecturerWorkHourObject().insertData( data=lecturerWorkHourStruct );
	}

	public boolean function updateLecturer( required struct lecturerStruct ){
		if ( !isLecturerBelongsToCurrentUser( lecturerId ) ) {
			return false;
		}

		var data = _processLecturerStruct( lecturerStruct );

		var updatedRowCount = _getLecturerObject().updateData(
			  data = data
			, id   = lecturerStruct.id?:""
		);

		return updatedRowCount == 1;
	}

	public boolean function deleteLecturer( required string lecturerId ){
		if ( !isLecturerBelongsToCurrentUser( lecturerId ) ) {
			return false;
		}

		var filter = { "lecturer"=lecturerId };

		_getlecturerWorkHourObject().deleteData( filter=filter );
		_getModuleClassTypeLecturerObject().deleteData( filter=filter );

		var deletedRowCount = _getLecturerObject().deleteData( id=lecturerId );

		return deletedRowCount == 1;
	}

	public array function getLecturerByNameOrAbbreviation( required string nameOrAbbreviation ){
		var selectFields = [
			  "lecturer.id"
			, "lecturer.label as name"
			, "lecturer.abbreviation"
		];
		var lecturerQuery = _getLecturerObject().findByNameOrAbbreviation(
			  selectFields       = selectFields
			, nameOrAbbreviation = nameOrAbbreviation
			, userId             = _getWebsiteLoginService().getLoggedInUserId()
		);
		var lecturerArray = [];

		lecturerQuery.each( function( lecturer ){
			lecturerArray.append( lecturer );
		} );

		return lecturerArray;
	}

	public boolean function isLecturerWorkHourDataValid( required struct lecturerWorkHourStruct ){
		var dayInWeek = [
			  "Sunday"
			, "Monday"
			, "Tuesday"
			, "Wednesday"
			, "Thursday"
			, "Friday"
			, "Saturday"
		];

		if ( REMatch( "^([0-1][0-9]|[2][0-4]):[0-5][0-9]$", lecturerWorkHourStruct.startTime?:"" ).len() == 0 ) {
			return false;
		}

		if ( REMatch( "^([0-1][0-9]|[2][0-4]):[0-5][0-9]$", lecturerWorkHourStruct.endTime?:"" ).len() == 0 ) {
			return false;
		}

		if ( !arrayContainsNoCase( dayInWeek, trim( lecturerWorkHourStruct.dayOfWeek?:"" ) ) ) {
			return false;
		}

		return true;
	}

	public string function addRelatedModuleClassType( required struct moduleClassTypeLecturer, required string lecturerId ){
		var moduleClassTypeLecturerStruct = {
			"effective_timestamp" = moduleClassTypeLecturer.effectiveTimestamp
			, "idle_timestamp" = moduleClassTypeLecturer.idleTimestamp?:""
			, "module_class_type" = moduleClassTypeLecturer.id
			, "lecturer" = lecturerId
		}
		return _getModuleClassTypeLecturerObject().insertData( data=moduleClassTypeLecturerStruct );
	}

	public array function getRelatedModuleClassTypesById( required string lecturerId ){
		var selectFields = [
			  "module_class_type_lecturer.effective_timestamp AS effectiveTimestamp"
			, "module_class_type_lecturer.idle_timestamp AS idleTimestamp"
			, "module.label AS moduleName"
			, "class_type.label AS classTypeName"
		];

		var moduleClassTypeLecturerQuery = _getModuleClassTypeLecturerObject().findByLecturerId(
			  selectFields = selectFields
			, lecturerId   = lecturerId
		);
		var relatedModuleClassTypes = [];

		moduleClassTypeLecturerQuery.each( function( moduleClassTypeLecturer ){
			relatedModuleClassTypes.append( moduleClassTypeLecturer );
		} );

		return relatedModuleClassTypes;
	}

	public struct function getRelatedModuleClassTypeByModuleClassTypeLecturerId( required string moduleClassTypeLecturerId ){
		var selectFields = [
			  "module_class_type_lecturer.effective_timestamp AS effectiveTimestamp"
			, "module_class_type_lecturer.idle_timestamp AS idleTimestamp"
			, "module.label AS moduleName"
			, "class_type.label AS classTypeName"
		];

		var moduleClassTypeLecturerQuery = _getModuleClassTypeLecturerObject().selectData(
			selectFields = selectFields
			, filter={ "id"=moduleClassTypeLecturerId }
		);

		if ( moduleClassTypeLecturerQuery.recordCount == 0 ) {
			return {};
		}

		return queryGetRow( moduleClassTypeLecturerQuery, 1 );
	}

	private struct function _processLecturerStruct( required struct lecturerStruct ){
		var processedLecturerStruct = {
			  "label"        = lecturerStruct.name         ?: ""
			, "abbreviation" = lecturerStruct.abbreviation ?: ""
			, "website_user" = _getLogggedInUserId()
		};

		return processedLecturerStruct;
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

	private void function _setlecturerWorkHourObject( required lecturer_work_hour lecturerWorkHourObject ){
		variables._lecturerWorkHourObject = lecturerWorkHourObject;
	}

	private lecturer_work_hour function _getlecturerWorkHourObject(){
		return variables._lecturerWorkHourObject;
	}

	private void function _setLecturerObject( required lecturer lecturerObject ){
		variables._lecturerObject = lecturerObject;
	}

	private lecturer function _getLecturerObject(){
		return variables._lecturerObject;
	}

	private void function _setModuleClassTypeLecturerObject( required module_class_type_lecturer moduleClassTypeLecturerObject ){
		variables._moduleClassTypeLecturerObject = moduleClassTypeLecturerObject;
	}

	private module_class_type_lecturer function _getModuleClassTypeLecturerObject(){
		return variables._moduleClassTypeLecturerObject;
	}
}