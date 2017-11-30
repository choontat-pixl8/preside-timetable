<cfscript>
	venueFormArgs = {
		  savedData = args.savedData?:{}
		, context   = "website"
		, formName  = args.formName?:"timetable.resource.venue"
	};

	if ( isDefined( "args.validationResult" ) ) {
		venueFormArgs.validationResult = args.validationResult;
	}
</cfscript>
<cfoutput>
	<form id="venueForm" action="#event.buildLink()#" method="POST" class="form form-horizontal">
		#renderForm( argumentCollection = venueFormArgs )#

		<button class="btn btn-success">Create</button>
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/venue" )#">Back</a>
	</form>
</cfoutput>