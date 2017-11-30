<cf_presideparam name="args.title" field="page.title" />
<cfscript>
	timetableArray = args.timetableArray ?: [];
</cfscript>
<cfoutput>
	<h2>
		#args.title#
		<a href="#event.buildLink( linkTo="page-types/timetable/generate" )#">
			<span class="glyphicon glyphicon-plus btn btn-success">
				Generate
			</span>
		</a>
	</h2>
	<table class="table">
		<thead>
			<tr>
				<th>No.</th>
				<th>Name</th>
				<th>Request Datetime</th>
				<th>Completion Datetime</th>
				<th>Status</th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#timetableArray#" index="index" item="timetable">
				<tr>
					<td>#index#</td>
					<td>#timetable.name#</td>
					<td>#dateTimeFormat( timetable.requestDatetime, "yyyy-mm-dd HH:nn" )#</td>
					<td>#dateTimeFormat( timetable.completionDatetime, "yyyy-mm-dd HH:nn" )#</td>
					<td>#timetable.status#</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>