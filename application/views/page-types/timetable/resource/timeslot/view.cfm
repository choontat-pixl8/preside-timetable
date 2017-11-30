<cfscript>
	id        = args.timeslotDataStruct.id ?:"";
	startTime = timeFormat( args.timeslotDataStruct.startTime ?:"", "HH:mm" );
	endTime   = timeFormat( args.timeslotDataStruct.endTime   ?: "", "HH:mm" );
</cfscript>
<cfoutput>
	<h2>Modify Timeslot Detail</h2>
	<form action="edit.html" method="POST">
		<div class="input-group">
			<span class="input-group-addon">Name</span>
			<input class="form-control timepicker" type="time" name="startTIme" value="#startTime#" />
		</div>
		<div class="input-group">
			<span class="input-group-addon">Abbreviation</span>
			<input class="form-control timepicker" type="time" name="endTime" value="#endTime#" />
		</div>
		<input type="hidden" name="timeslotId" id="timeslotId" value="#id#" />

		<button class="btn btn-success">Update</button>
		<button class="btn btn-danger" formaction="delete.html">Delete</button>
		
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/timeslot" )#">Back</a>
	</form>
</cfoutput>