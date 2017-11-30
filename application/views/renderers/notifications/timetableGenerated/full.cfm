<cfscript>
	timetableDetail = args.timetableDetail ?: {};
	schedulerName = timetableDetail.schedulerName?:"";
	requestDatetime = dateTimeFormat( timetableDetail.requestDatetime?:"", "yyyy-mm-dd HH:nn" );
	completionDatetime = dateTimeFormat( timetableDetail.completionDatetime?:"", "yyyy-mm-dd HH:nn" );
	status = timetableDetail.status?:"";
</cfscript>
<cfoutput>
	<div class="input-group">
		<span class="input-group-addon">Scheduler Name</span>
		<input type="text" class="form-control" value="#schedulerName#" readonly />
	</div>
	<div class="input-group">
		<span class="input-group-addon">Request Datetime</span>
		<input type="text" class="form-control" value="#requestDatetime#" readonly />
	</div>
	<div class="input-group">
		<span class="input-group-addon">Completion Datetime</span>
		<input type="text" class="form-control" value="#completionDatetime#" readonly />
	</div>
	<div class="input-group">
		<span class="input-group-addon">Status</span>
		<input type="text" class="form-control" value="#status#" readonly />
	</div>
</cfoutput>