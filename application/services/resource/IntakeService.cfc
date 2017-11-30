component {
	/**
	 * @intakeObject.inject        presidecms:object:intake
	 * @intakeCourseObject.inject  presidecms:object:intake_course
	 * @websiteLoginService.inject WebsiteLoginService
	 * @courseService.inject       delayedInjector:CourseService
	**/
	public any function init(
		  required intake              intakeObject
		, required intake_course       intakeCourseObject
		, required WebsiteLoginService websiteLoginService
		, required any                 courseService
	){
		_setIntakeObject( intakeObject );
		_setIntakeCourseObject( intakeCourseObject );
		_setWebsiteLoginService( websiteLoginService );
		_setCourseService( courseService );
	}

	public array function getIntakeArray(){
		var intakeArray    = [];
		var selectFields   = _getIntakeSelectFields();
		var loggedInUserId = _getLogggedInUserId();
		var intakeQuery    = _getIntakeObject().findByUserId( userId=loggedInUserId, selectFields=selectFields );

		intakeQuery.each( function( intake ){
			intakeArray.append( intake );
		} );

		return intakeArray;
	}

	public struct function getRelatedCourseByIntakeCourseId( required string intakeCourseId ){
		var selectFields = _getIntakeCourseSelectFields();

		var relatedIntakesQuery = _getIntakeCourseObject().findById( intakeCourseId=intakeCourseId, selectFields=selectFields );

		return _getSingleRecord( relatedIntakesQuery );
	}

	public array function getRelatedCoursesById( required string intakeId ){
		var selectFields        = _getIntakeCourseSelectFields();
		var relatedCoursesQuery = _getIntakeCourseObject().findByIntakeId( intakeId=intakeId, selectFields=selectFields );
		var relatedCourses      = [];

		relatedCoursesQuery.each( function( relatedCourse ){
			relatedCourses.append( relatedCourse );
		} );

		return relatedCourses;
	}

	public boolean function isIntakeBelongsToCurrentUser( required string intakeId ){
		var intakeQueryArgs = {
			  selectFields = [ "intake.id" ]
			, intakeId     = intakeId
			, userId       = _getLogggedInUserId()
		};
		var intakeQuery     = _getIntakeObject().findByIdAndUserId( argumentCollection=intakeQueryArgs );

		return intakeQuery.recordCount > 0;
	}

	public struct function getIntakeById( required string intakeId ){
		var selectFields = _getIntakeSelectFields();
		var intakeQuery  = _getIntakeObject().findByIdAndUserId(
			  intakeId     = intakeId
			, userId       = _getLogggedInUserId()
			, selectFields = selectFields
		);

		return _getSingleRecord( intakeQuery );
	}

	public string function createIntake( required struct intakeStruct ){
		var data = _processIntakeStruct( intakeStruct );

		if ( isIntakeExists( data.abbreviation ) ) {
			return "";
		}

		return _getIntakeObject().insertData( data=data );
	}

	public string function addRelatedCourse( required struct intakeCourse, required string intakeId ){
		if ( isRelatedCourseExists( intakeId, intakeCourse.courseId ) ) {
			return "";
		}

		var intakeCourseStruct = {
			  "intake"              = intakeId
			, "course"              = intakeCourse.courseId
			, "student_count"       = val( intakeCourse.studentCount )
			, "effective_timestamp" = intakeCourse.effectiveTimestamp
			, "idle_timestamp"      = intakeCourse.idleTimestamp?:""
		};

		return _getIntakeCourseObject().insertData( data=intakeCourseStruct );
	}

	public boolean function isIntakeExists( required string intakeAbbreviation ){
		var intakeQuery = _getIntakeObject().findByAbbreviation(
			  selectFields  = [ "intake.id" ]
			, abbreviation  = intakeAbbreviation
			, caseSensitive = true
		);

		return intakeQuery.recordCount > 0;
	}

	public boolean function isRelatedCourseExists( required string intakeId, required string courseId ){
		var intakeCourseQuery = _getIntakeCourseObject().findByIntakeAndCourse(
			  selectFields = [ "intake_course.id" ]
			, intakeId = intakeId
			, courseId = courseId
		);

		return intakeCourseQuery.recordCount > 0;
	}

	public boolean function isRelatedCourseDataValid( required struct relatedCourse ){
		if ( val( relatedCourse.studentCount?:"" )<0 ){
			return false;
		}

		if ( !_getCourseService().isCourseBelongsToCurrentUser( relatedCourse.courseId ) ) {
			return false;
		}

		if ( !isDate( relatedCourse.effectiveTimestamp?:"" ) ) {
			return false;
		}

		if ( ( relatedCourse.idleTimestamp?:"" )!="" && !isDate( relatedCourse.idleTimestamp ) ) {
			return false;
		}

		return true;
	}

	public boolean function updateIntake( required struct intakeStruct ){
		if ( !isIntakeBelongsToCurrentUser( intakeId ) ) {
			return false;
		}

		var data = _processIntakeStruct( intakeStruct );

		var updatedRowCount = _getIntakeObject().updateData(
			  data = data
			, id   = intakeStruct.id?:""
		);

		return updatedRowCount == 1;
	}

	public boolean function deleteIntake( required string intakeId ){
		if ( !isIntakeBelongsToCurrentUser( intakeId ) ) {
			return false;
		}

		_getIntakeCourseObject().deleteData( filter={ "intake"=intakeId } );

		var deletedRowCount = _getIntakeObject().deleteData( id=intakeId );

		return deletedRowCount == 1;
	}

	public array function getIntakeByNameOrAbbreviation( required string nameOrAbbreviation ){
		var selectFields = [
			  "intake.id"
			, "intake.label AS name"
			, "intake.abbreviation"
		];
		var intakeQuery = _getIntakeObject().findByNameOrAbbreviation(
			  selectFields       = selectFields
			, nameOrAbbreviation = nameOrAbbreviation
			, userId             = _getWebsiteLoginService().getLoggedInUserId()
		);
		var intakeArray = [];

		intakeQuery.each( function( intake ){
			intakeArray.append( intake );
		} );

		return intakeArray;
	}

	private struct function _processIntakeStruct( required struct intakeStruct ){
		var processedIntakeStruct = {
			  "label"        = intakeStruct.name         ?: ""
			, "description"  = intakeStruct.description  ?: ""
			, "abbreviation" = intakeStruct.abbreviation ?: ""
			, "website_user" = _getLogggedInUserId()
		};

		return processedIntakeStruct;
	}

	private array function _getIntakeSelectFields(){
		return [
			  "intake.id"
			, "intake.label AS name"
			, "intake.description"
			, "intake.abbreviation"
		];
	}

	private array function _getIntakeCourseSelectFields(){
		return [
			  "intake_course.student_count       AS studentCount"
			, "course.label                      AS name"
			, "intake_course.effective_timestamp AS effectiveTimestamp"
			, "intake_course.idle_timestamp      AS idleTimestamp"
		];
	}

	private struct function _getSingleRecord( required query queryObject ){
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

	private void function _setCourseService( required any courseService ){
		variables._courseService = courseService;
	}

	private any function _getCourseService(){
		return variables._courseService;
	}

	private void function _setIntakeCourseObject( required intake_course intakeCourseObject ){
		variables._intakeCourseObject = intakeCourseObject;
	}

	private intake_course function _getIntakeCourseObject(){
		return variables._intakeCourseObject;
	}

	private void function _setIntakeObject( required intake intakeObject ){
		variables._intakeObject = intakeObject;
	}

	private intake function _getIntakeObject(){
		return variables._intakeObject;
	}
}