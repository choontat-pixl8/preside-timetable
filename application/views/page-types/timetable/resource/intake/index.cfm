<cf_presideparam name="args.title" field="page.title" />

<cfscript>
	intakeArray = args.intakeArray ?: [];
</cfscript>
<cfoutput>
	<h1>
		#args.title#
		<a class="btn btn-success" href="#event.buildLink( linkTo="resource/intake/add" )#">
			<span class="glyphicon glyphicon-plus"></span>
		</a>
	</h1>
	
	<table class="table table-striped">
		<thead>
			<tr>
				<th>No.</th>
				<th>Name</th>
				<th>Abbreviation</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#intakeArray#" index="index" item="intake">
				<tr>
					<td>#index#</td>
					<td>#intake.name#</td>
					<td>#intake.abbreviation#</td>
					<td>
						<a href="#event.buildLink( linkTo="resource/intake/"&intake.id&"/view" )#">
							<span class="glyphicon glyphicon-pencil"></span>
						</a>
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>