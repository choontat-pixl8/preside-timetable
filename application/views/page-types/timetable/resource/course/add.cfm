<cfscript>
	courseFormArgs = {
		  savedData = args.savedData?:{}
		, context   = "website"
		, formName  = args.formName?:"timetable.resource.course"
	};

	if ( isDefined( "args.validationResult" ) ) {
		courseFormArgs.validationResult = args.validationResult;
	}
</cfscript>
<cfoutput>
	<form id="courseForm" action="#event.buildLink()#" method="POST" class="form form-horizontal">
		#renderForm( argumentCollection = courseFormArgs )#

		<button class="btn btn-success">Create</button>
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/course" )#">Back</a>
	</form>
</cfoutput>