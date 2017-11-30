<cf_presideparam name="args.title" field="page.title" />

<cfscript>
	holidayArray = args.holidayArray ?: [];
</cfscript>
<cfoutput>
	<h1>
		#args.title#
		<a class="btn btn-success" href="#event.buildLink( linkTo="resource/holiday/add" )#">
			<span class="glyphicon glyphicon-plus"></span>
		</a>
	</h1>
	
	<table class="table table-striped">
		<thead>
			<tr>
				<th>No.</th>
				<th>Name</th>
				<th>Start Datetime</th>
				<th>End Datetime</th>
				<th>Lecturer</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<cfif holidayArray.len() GT 0>
				<cfloop array="#holidayArray#" index="index" item="holiday">
					<tr>
						<td>#index#</td>
						<td>#holiday.name#</td>
						<td>#dateTimeFormat( holiday.beginTimestamp, "yyyy-mm-dd HH:nn" )#</td>
						<td>#dateTimeFormat( holiday.endTimestamp, "yyyy-mm-dd HH:nn" )#</td>
						<td>#holiday.lecturerName#</td>
						<td>
							<a href="#event.buildLink( linkTo="resource/holiday/"&holiday.id&"/delete" )#">
								<span class="glyphicon glyphicon-trash"></span>
							</a>
						</td>
					</tr>
				</cfloop>
			<cfelse>
				<tr>
					<td colspan="100%">No holiday available</td>
				</tr>
			</cfif>
		</tbody>
	</table>
</cfoutput>