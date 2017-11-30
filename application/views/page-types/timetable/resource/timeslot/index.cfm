<cf_presideparam name="args.title" field="page.title" />

<cfscript>
	timeslotArray = args.timeslotArray ?: [];
</cfscript>
<cfoutput>
	<h1>
		#args.title#
		<a class="btn btn-success" href="#event.buildLink( linkTo="resource/timeslot/add" )#">
			<span class="glyphicon glyphicon-plus"></span>
		</a>
	</h1>
	
	<table class="table table-striped">
		<thead>
			<tr>
				<th>No.</th>
				<th>Start Time</th>
				<th>End Time</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<cfif timeslotArray.len() GT 0>
				<cfloop array="#timeslotArray#" index="index" item="timeslot">
					<tr>
						<td>#index#</td>
						<td>#timeFormat( timeslot.startTime, "HH:mm" )#</td>
						<td>#timeFormat( timeslot.endTime, "HH:mm" )#</td>
						<td>
							<a href="#event.buildLink( linkTo="resource/timeslot/"&timeslot.id&"/view" )#">
								<span class="glyphicon glyphicon-pencil"></span>
							</a>
						</td>
					</tr>
				</cfloop>
			<cfelse>
				<tr>
					<td colspan="100%">No timeslot available</td>
				</tr>
			</cfif>
		</tbody>
	</table>
</cfoutput>