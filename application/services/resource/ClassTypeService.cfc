component {
	/**
	 * @classTypeObject.inject       presidecms:object:class_type
	 * @moduleClassTypeObject.inject presidecms:object:module_class_type
	 * @classTypeVenueObject.inject  presidecms:object:class_type_venue
	 * @websiteLoginService.inject   WebsiteLoginService
	**/
	public any function init(
		  required class_type          classTypeObject
		, required module_class_type   moduleClassTypeObject
		, required class_type_venue    classTypeVenueObject
		, required WebsiteLoginService websiteLoginService
	){
		_setClassTypeObject( classTypeObject );
		_setModuleClassTypeObject( moduleClassTypeObject );
		_setClassTypeVenueObject( classTypeVenueObject );
		_setWebsiteLoginService( websiteLoginService );
	}

	public array function getClassTypeArray(){
		var classTypeArray = [];
		var selectFields   = [
			  "class_type.id"
			, "class_type.label                   AS name"
			, "class_type.description"
			, "class_type.abbreviation"
			, "class_type.duration_min            AS durationInMinutes"
			, "class_type.applicable_to_sunday    AS applicableToSunday"
			, "class_type.applicable_to_monday    AS applicableToMonday"
			, "class_type.applicable_to_tuesday   AS applicableToTuesday"
			, "class_type.applicable_to_wednesday AS applicableToWednesday"
			, "class_type.applicable_to_thursday  AS applicableToThursday"
			, "class_type.applicable_to_friday    AS applicableToFriday"
			, "class_type.applicable_to_saturday  AS applicableToSaturday"
		];

		var loggedInUserId = _getWebsiteLoginService().getLoggedInUserId();
		var classTypeQuery = _getClassTypeObject().findByUserId( userId=loggedInUserId, selectFields=selectFields );

		classTypeQuery.each( function( classType ){
			var classTypeStruct = {
				  "id"             = classType.id
				, "name"           = classType.name
				, "description"    = classType.description
				, "abbreviation"   = classType.abbreviation
				, "applicableDays" = {
					  "sunday"    = classType.applicableToSunday    == "1" ?: "0"
					, "monday"    = classType.applicableToMonday    == "1" ?: "0"
					, "tuesday"   = classType.applicableToTuesday   == "1" ?: "0"
					, "wednesday" = classType.applicableToWednesday == "1" ?: "0"
					, "thursday"  = classType.applicableToThursday  == "1" ?: "0"
					, "friday"    = classType.applicableToFriday    == "1" ?: "0"
					, "saturday"  = classType.applicableToSaturday  == "1" ?: "0"
				}
			};

			classTypeArray.append( classTypeStruct );
		} );

		return classTypeArray;
	}

	public struct function getRelatedModuleByModuleClassTypeId( required string moduleClassTypeId ){
		var selectFields = [
			  "module.label                              AS name"
			, "module_class_type.assign_time_range_start AS assignTimeRangeStart"
			, "module_class_type.assign_time_range_end   AS assignTimeRangeEnd"
		];

		var relatedModulesQuery = _getModuleClassTypeObject().findById(
			  moduleClassTypeId = moduleClassTypeId
			, selectFields      = selectFields
		);

		return _getSingleResult( relatedModulesQuery );
	}

	public array function getRelatedModulesById( required string classTypeId ){
		var selectFields = [
			  "module.label                              AS moduleName"
			, "module_class_type.assign_time_range_start AS assignTimeRangeStart"
			, "module_class_type.assign_time_range_end   AS assignTimeRangeEnd"
		];

		var relatedModulesQuery = _getModuleClassTypeObject().findByClassTypeId( classTypeId=classTypeId, selectFields=selectFields );
		var relatedModules      = [];

		relatedModulesQuery.each( function( relatedModule ){
			relatedModules.append( relatedModule );
		} );

		return relatedModules;
	}

	public boolean function isClassTypeBelongsToCurrentUser( required string classTypeId ){
		var moduleQueryArgs = {
			  selectFields = [ "class_type.id" ]
			, classTypeId  = arguments.classTypeId
			, userId       = _getLogggedInUserId()
		};
		var moduleQuery = _getClassTypeObject().findByIdAndUserId( argumentCollection=moduleQueryArgs );

		return moduleQuery.recordCount > 0;
	}

	public struct function getClassTypeById( required string classTypeId){
		var selectFields = [
			  "class_type.label                   AS name"
			, "class_type.description"
			, "class_type.abbreviation"
			, "class_type.duration_min            AS durationInMinutes"
			, "class_type.applicable_to_sunday    AS applicableToSunday"
			, "class_type.applicable_to_monday    AS applicableToMonday"
			, "class_type.applicable_to_tuesday   AS applicableToTuesday"
			, "class_type.applicable_to_wednesday AS applicableToWednesday"
			, "class_type.applicable_to_thursday  AS applicableToThursday"
			, "class_type.applicable_to_friday    AS applicableToFriday"
			, "class_type.applicable_to_saturday  AS applicableToSaturday"
		];
		var moduleQuery = _getClassTypeObject().findByIdAndUserId(
			  classTypeId  = classTypeId
			, userId       = _getLogggedInUserId()
			, selectFields = selectFields
		);

		return _getSingleResult( moduleQuery );
	}

	public string function createClassType( required struct moduleStruct ){
		var data = _processClassTypeStruct( moduleStruct );

		return _getClassTypeObject().insertData( data=data );
	}

	public struct function getRelatedVenueByClassTypeVenueId( required string classTypeVenueId ){
		var selectFields        = [ "venue.label AS name" ];
		var classTypeVenueQuery = _getClassTypeVenueObject().findById(
			  selectFields     = selectFields
			, classTypeVenueId = classTypeVenueId
		);

		return _getSingleResult( classTypeVenueQuery );
	}

	public array function getRelatedVenuesById( required string classTypeId ){
		var selectFields   = [ "venue.label AS name" ];
		var classTypeQuery = _getClassTypeVenueObject().findByClassTypeId(
			  classTypeId  = classTypeId
			, selectFields = selectFields
		);
		var classTypes = [];

		classTypeQuery.each( function( classType ){
			classTypes.append( classType );
		} );

		return classTypes;
	}

	public string function addRelatedModule( required struct moduleClassType, required string classTypeId ){
		var moduleClassTypeStruct = {
			  "class_type"              = classTypeId
			, "module"                  = moduleClassType.moduleId
			, "assign_time_range_start" = moduleClassType.assignTimeRangeStart
			, "assign_time_range_end"   = moduleClassType.assignTimeRangeEnd
		};

		return _getModuleClassTypeObject().insertData( data=moduleClassTypeStruct );
	}

	public string function addRelatedVenue( required string venueId, required string classTypeId ){
		var classTypeVenueStruct = {
			  "venue"      = venueId
			, "class_type" = classTypeId
		};

		return _getClassTypeVenueObject().insertData( data=classTypeVenueStruct );
	}

	private boolean function _relatedModuleExists( required string classTypeId, required string moduleId ){
		var moduleClassTypeQuery = _getModuleClassTypeObject().findByClassTypeAndmodule(
			  selectFields = [ "id" ]
			, classTypeId  = classTypeId
			, moduleId     = moduleId
		);

		return moduleClassTypeQuery.recordCount > 0;
	}

	public boolean function updateClassType( required struct moduleStruct ){
		var data = _processClassTypeStruct( moduleStruct );

		var updatedRowCount = _getClassTypeObject().updateData(
			  data = data
			, id   = moduleStruct.id?:""
		);

		return updatedRowCount == 1;
	}

	public boolean function deleteClassType( required string classTypeId ){
		if ( !isClassTypeBelongsToCurrentUser( classTypeId ) ) {
			return false;
		}

		var filter = { "class_type"=classTypeId };

		_getModuleClassTypeObject().deleteData( filter=filter );
		_getClassTypeVenueObject().deleteData(  filter=filter );
		
		var deletedRowCount = _getClassTypeObject().deleteData( id=classTypeId );

		return deletedRowCount == 1;
	}

	public array function getClassTypeByNameOrAbbreviation( required string nameOrAbbreviation ){
		var selectFields = [
			  "class_type.id"
			, "class_type.label AS name"
			, "class_type.abbreviation"
		];
		var classTypeQuery = _getClassTypeObject().findByNameOrAbbreviation(
			  selectFields       = selectFields
			, nameOrAbbreviation = nameOrAbbreviation
			, userId             = _getWebsiteLoginService().getLoggedInUserId()
		);
		var classTypeArray = [];

		classTypeQuery.each( function( classType ){
			classTypeArray.append( classType );
		} );

		return classTypeArray;
	}

	private struct function _processClassTypeStruct( required struct moduleStruct ){
		var processedClassTypeStruct = {
			  "label"                   = moduleStruct.name         ?: ""
			, "description"             = moduleStruct.description  ?: ""
			, "abbreviation"            = moduleStruct.abbreviation ?: ""
			, "duration_min"            = val( moduleStruct.durationInMinutes ?: "0" )
			, "applicable_to_sunday"    = moduleStruct.applicableToSunday    == "1" ?: "0"
			, "applicable_to_monday"    = moduleStruct.applicableToMonday    == "1" ?: "0"
			, "applicable_to_tuesday"   = moduleStruct.applicableToTuesday   == "1" ?: "0"
			, "applicable_to_wednesday" = moduleStruct.applicableToWednesday == "1" ?: "0"
			, "applicable_to_thursday"  = moduleStruct.applicableToThursday  == "1" ?: "0"
			, "applicable_to_friday"    = moduleStruct.applicableToFriday    == "1" ?: "0"
			, "applicable_to_saturday"  = moduleStruct.applicableToSaturday  == "1" ?: "0"
			, "website_user"            = _getLogggedInUserId()
		};

		return processedClassTypeStruct;
	}

	private struct function _getSingleResult( required query queryObject ){
		if ( queryObject.recordCount == 0 ) {
			return {};
		}

		return queryGetRow( queryObject, 1 );
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

	private void function _setModuleClassTypeObject( required module_class_type moduleClassTypeObject ){
		variables._moduleClassTypeObject = moduleClassTypeObject;
	}

	private module_class_type function _getModuleClassTypeObject(){
		return variables._moduleClassTypeObject;
	}

	private void function _setClassTypeVenueObject( required class_type_venue classTypeVenueObject ){
		variables._classTypeVenueObject = classTypeVenueObject;
	}

	private class_type_venue function _getClassTypeVenueObject(){
		return variables._classTypeVenueObject;
	}

	private void function _setClassTypeObject( required class_type classTypeObject ){
		variables._classTypeObject = classTypeObject;
	}

	private class_type function _getClassTypeObject(){
		return variables._classTypeObject;
	}
}