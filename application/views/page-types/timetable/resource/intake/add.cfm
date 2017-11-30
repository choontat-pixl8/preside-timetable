<cfscript>
	intakeFormArgs = {
		  savedData = args.savedData?:{}
		, context   = "website"
		, formName  = args.formName?:"timetable.resource.intake"
	};

	if ( isDefined( "args.validationResult" ) ) {
		intakeFormArgs.validationResult = args.validationResult;
	}
</cfscript>
<cfoutput>
	<form id="intakeForm" action="#event.buildLink()#" method="POST" class="form form-horizontal">
		#renderForm( argumentCollection = intakeFormArgs )#

		<button class="btn btn-success">Create</button>
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/intake" )#">Back</a>
	</form>
</cfoutput>