<cfscript>
	timeslotFormArgs = {
		  savedData = args.savedData?:{}
		, context   = "website"
		, formName  = args.formName?:"timetable.resource.timeslot"
	};

	if ( isDefined( "args.validationResult" ) ) {
		timeslotFormArgs.validationResult = args.validationResult;
	}
</cfscript>
<cfoutput>
	<form id="timeslotForm" action="#event.buildLink()#" method="POST" class="form form-horizontal">
		#renderForm( argumentCollection = timeslotFormArgs )#

		<button class="btn btn-success">Create</button>
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/timeslot" )#">Back</a>
	</form>
</cfoutput>