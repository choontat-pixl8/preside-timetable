<cf_presideparam name="args.title" field="page.title" />
<cfscript>
	timetableArray = args.timetableArray ?: [];
</cfscript>
<cfoutput>
	<form action="#event.buildLink( linkTo="page-types/timetable/generate" )#" method="POST">
		<div class="input-group">
			<span  class="input-group-addon">Name</span>
			<input class="form-control" type="text" name="name" />
			<div   class="input-group-btn">
				<input class="btn btn-success" type="submit" value="Generate" />
			</div>
		</div>
	</form>

	<h2>#args.title#</h2>

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