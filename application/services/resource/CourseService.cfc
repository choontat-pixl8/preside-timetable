component {
	/**
	 * @courseObject.inject presidecms:object:course
	 * @intakeCourseObject.inject presidecms:object:intake_course
	 * @courseModuleObject.inject presidecms:object:course_module
	 * @websiteLoginService.inject WebsiteLoginService
	 * @intakeService.inject delayedInjector:IntakeService
	**/
	public CourseService function init( 
		  required any courseObject
		, required intake_course intakeCourseObject
		, required course_module courseModuleObject
		, required WebsiteLoginService websiteLoginService
		, required any intakeService
	){
		_setCourseObject( courseObject );
		_setIntakeCourseObject( intakeCourseObject );
		_setCourseModuleObject( courseModuleObject );
		_setWebsiteLoginService( websiteLoginService );
		_setIntakeService( intakeService );

		return this;
	}

	public array function getCourseArray(){
		var courseArray    = [];
		var selectFields   = [
			  "course.id"
			, "course.label AS name"
			, "course.description"
			, "course.abbreviation"
		];
		var loggedInUserId = _getWebsiteLoginService().getLoggedInUserId();
		var courseQuery    = _getCourseObject().findByUserId( userId=loggedInUserId, selectFields=selectFields );

		courseQuery.each( function( course ){
			var courseStruct = {
				  "id"           = course.id
				, "name"         = course.name
				, "description"  = course.description
				, "abbreviation" = course.abbreviation
			};

			courseArray.append( courseStruct );
		} );

		return courseArray;
	}

	public array function getRelatedIntakesById( required string courseId ){
		var selectFields = [
			  "intake_course.student_count AS studentCount"
			, "intake.label AS name"
			, "intake_course.effective_timestamp AS effectiveTimestamp"
			, "intake_course.idle_timestamp AS idleTimestamp"
		];

		var relatedIntakesQuery = _getIntakeCourseObject().findByCourseId( courseId=courseId, selectFields=selectFields );
		var relatedIntakes = [];

		relatedIntakesQuery.each( function( relatedIntake ){
			relatedIntakes.append( {
				"name" = relatedIntake.name
				, "studentCount" = relatedIntake.studentCount
				, "effectiveTimestamp" = relatedIntake.effectiveTimestamp
				, "idleTimestamp" = relatedIntake.idleTimestamp
			} );
		} );

		return relatedIntakes;
	}

	public array function getRelatedModulesById( required string courseId ){
		var selectFields = [
			  "module.label AS name"
			, "course_module.effective_timestamp AS effectiveTimestamp"
			, "course_module.idle_timestamp AS idleTimestamp"
		];

		var relatedModulesQuery = _getCourseModuleObject().findByCourseId( courseId=courseId, selectFields=selectFields );
		var relatedModules = [];

		relatedModulesQuery.each( function( relatedModule ){
			relatedModules.append( {
				  "name" = relatedModule.name
				, "effectiveTimestamp" = relatedModule.effectiveTimestamp
				, "idleTimestamp" = relatedModule.idleTimestamp
			} );
		} );

		return relatedModules;
	}

	public struct function getCourseById( required string courseId ){
		var selectFields = [ "course.label AS name", "course.description", "course.abbreviation" ];
		var courseQuery = _getCourseObject().findByIdAndUserId(
			  courseId = courseId
			, userId = _getLogggedInUserId()
			, selectFields = selectFields
		);
		var courseStruct = {
			  "name" = courseQuery.name
			, "description" = courseQuery.description
			, "abbreviation" = courseQuery.abbreviation
		};

		return courseStruct;
	}

	public array function getCourseByNameOrAbbreviation( required string nameOrAbbreviation ){
		var selectFields = [
			  "course.id"
			, "course.label as name"
			, "course.abbreviation"
		];
		var courseQuery = _getCourseObject().findByNameOrAbbreviation(
			  selectFields       = selectFields
			, nameOrAbbreviation = nameOrAbbreviation
			, userId             = _getWebsiteLoginService().getLoggedInUserId()
		);
		var courseArray = [];

		courseQuery.each( function( course ){
			courseArray.append( {
				  "id" = course.id
				, "name" = course.name
				, "abbreviation" = course.abbreviation
			} );
		} );

		return courseArray;
	}

	public boolean function isCourseBelongsToCurrentUser( required string courseId ){
		var courseQueryArgs = {
			  selectFields = [ "course.id" ]
			, courseId = arguments.courseId
			, userId = _getLogggedInUserId()
		};
		var courseQuery = _getCourseObject().findByIdAndUserId( argumentCollection=courseQueryArgs );

		return courseQuery.recordCount > 0;
	}

	public string function addRelatedIntake( required struct intakeCourse, required string courseId ){
		var intakeCourseStruct = {
			  "course" = courseId
			, "intake" = intakeCourse.intakeId
			, "student_count" = val( intakeCourse.studentCount )
			, "effective_timestamp" = intakeCourse.effectiveTimestamp
			, "idle_timestamp" = intakeCourse.idleTimestamp?:""
		};

		return _getIntakeCourseObject().insertData( data=intakeCourseStruct );
	}

	public string function addRelatedModule( required struct courseModule, required string courseId ){
		var courseModuleStruct = {
			  "course" = courseId
			, "module" = courseModule.moduleId
			, "effective_timestamp" = courseModule.effectiveTimestamp
			, "idle_timestamp" = courseModule.idleTimestamp?:""
		};

		return _getCourseModuleObject().insertData( data=courseModuleStruct );
	}

	public boolean function deleteCourse( required string courseId ){
		if ( !isCourseBelongsToCurrentUser( courseId ) ) {
			return false;
		}

		var filter = { "course"=courseId };

		_getIntakeCourseObject().deleteData( filter=filter );
		_getCourseModuleObject().deleteData( filter=filter );
		
		var deletedRowCount = _getCourseObject().deleteData( id=courseId );

		return deletedRowCount == 1;
	}

	public struct function getRelatedIntakeByIntakeCourseId( required string intakeCourseId ){
		var selectFields = [
			  "intake_course.student_count       AS studentCount"
			, "intake.label                      AS name"
			, "intake_course.effective_timestamp AS effectiveTimestamp"
			, "intake_course.idle_timestamp      AS idleTimestamp"
		];

		var relatedintakesQuery = _getIntakeCourseObject().findById( intakeCourseId=intakeCourseId, selectFields=selectFields );

		if ( relatedintakesQuery.recordCount == 0) {
			return {};
		}

		return queryGetRow( relatedintakesQuery, 1 );
	}

	public struct function getRelatedModuleByCourseModuleId( required string courseModuleId ){
		var selectFields = [
			  "module.label                      AS name"
			, "course_module.effective_timestamp AS effectiveTimestamp"
			, "course_module.idle_timestamp      AS idleTimestamp"
		];

		var relatedintakesQuery = _getCourseModuleObject().findById( courseModuleId=courseModuleId, selectFields=selectFields );

		if ( relatedintakesQuery.recordCount == 0) {
			return {};
		}

		return queryGetRow( relatedintakesQuery, 1 );
	}

	public string function createCourse( required struct courseStruct ){
		var data = _processCourseStruct( courseStruct );

		return _getCourseObject().insertData( data=data );
	}

	private struct function _processCourseStruct( required struct courseStruct ){
		var processedCourseStruct = {
			  "label"        = courseStruct.name         ?: ""
			, "description"  = courseStruct.description  ?: ""
			, "abbreviation" = courseStruct.abbreviation ?: ""
			, "website_user" = _getLogggedInUserId()
		};

		return processedCourseStruct;
	}

	public boolean function updateCourse( required struct courseStruct ){
		if ( !isCourseBelongsToCurrentUser( courseStruct.id?:"" ) ) {
			return false;
		}

		var data = _processCourseStruct( courseStruct );
		var updatedRowCount = _getCourseObject().updateData(
			  data = data
			, id   = courseStruct.id?:""
		);

		return updatedRowCount == 1;
	}

	private void function _setCourseObject( required any courseObject ){
		variables._courseObject = courseObject;
	}

	private any function _getCourseObject(){
		return variables._courseObject;
	}

	private void function _setWebsiteLoginService( required WebsiteLoginService websiteLoginService ){
		variables._websiteLoginService = websiteLoginService;
	}

	private WebsiteLoginService function _getWebsiteLoginService(){
		return variables._websiteLoginService;
	}

	private void function _setIntakeService( required any intakeService ){
		variables._intakeService = intakeService;
	}

	private any function _getIntakeService(){
		return variables._intakeService;
	}

	private string function _getLogggedInUserId(){
		return _getWebsiteLoginService().getLoggedInUserId();
	}

	private void function _setintakeCourseObject( required intake_course intakeCourseObject ){
		variables._intakeCourseObject = intakeCourseObject;
	}

	private intake_course function _getIntakeCourseObject(){
		return variables._intakeCourseObject;
	}

	private void function _setcourseModuleObject( required course_module courseModuleObject ){
		variables._courseModuleObject = courseModuleObject;
	}

	private course_module function _getCourseModuleObject(){
		return variables._courseModuleObject;
	}
}