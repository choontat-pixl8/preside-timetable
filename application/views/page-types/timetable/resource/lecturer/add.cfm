<cfscript>
	lecturerFormArgs = {
		  savedData = args.savedData?:{}
		, context   = "website"
		, formName  = args.formName?:"timetable.resource.lecturer"
	};

	if ( isDefined( "args.validationResult" ) ) {
		lecturerFormArgs.validationResult = args.validationResult;
	}
</cfscript>
<cfoutput>
	<form id="lecturerForm" action="#event.buildLink()#" method="POST" class="form form-horizontal">
		#renderForm( argumentCollection = lecturerFormArgs )#

		<button class="btn btn-success">Create</button>
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/lecturer" )#">Back</a>
	</form>
</cfoutput>