<cf_presideparam name="args.title" field="page.title" />

<cfscript>
	moduleArray = args.moduleArray ?: [];
</cfscript>
<cfoutput>
	<h1>
		#args.title#
		<a class="btn btn-success" href="#event.buildLink( linkTo="resource/module/add" )#">
			<span class="glyphicon glyphicon-plus"></span>
		</a>
	</h1>
	
	<table class="table table-striped">
		<thead>
			<tr>
				<th>No.</th>
				<th>Name</th>
				<th>Abbreviation</th>
				<th>Assign Same Lecturer</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#moduleArray#" index="index" item="module">
				<tr>
					<td>#index#</td>
					<td>#module.name#</td>
					<td>#module.abbreviation#</td>
					<td>#module.assignSameLecturer?"Yes":"No"#</td>
					<td>
						<a href="#event.buildLink( linkTo="resource/module/"&module.id&"/view" )#">
							<span class="glyphicon glyphicon-pencil"></span>
						</a>
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>