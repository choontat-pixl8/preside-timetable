<cfscript>
	moduleFormArgs = {
		  savedData = args.savedData?:{}
		, context   = "website"
		, formName  = args.formName?:"timetable.resource.module"
	};

	if ( isDefined( "args.validationResult" ) ) {
		moduleFormArgs.validationResult = args.validationResult;
	}
</cfscript>
<cfoutput>
	<form id="moduleForm" action="#event.buildLink()#" method="POST" class="form form-horizontal">
		#renderForm( argumentCollection = moduleFormArgs )#

		<button class="btn btn-success">Create</button>
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/module" )#">Back</a>
	</form>
</cfoutput>