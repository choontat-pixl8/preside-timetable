<cfscript>
	classTypeFormArgs = {
		  savedData = args.savedData?:{}
		, context   = "website"
		, formName  = args.formName?:"timetable.resource.classType"
	};

	if ( isDefined( "args.validationResult" ) ) {
		classTypeFormArgs.validationResult = args.validationResult;
	}
</cfscript>
<cfoutput>
	<form id="classTypeForm" action="#event.buildLink()#" method="POST" class="form form-horizontal">
		#renderForm( argumentCollection = classTypeFormArgs )#

		<button class="btn btn-success">Create</button>
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/class-type" )#">Back</a>
	</form>
</cfoutput>