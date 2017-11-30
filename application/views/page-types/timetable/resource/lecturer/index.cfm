<cf_presideparam name="args.title" field="page.title" />

<cfscript>
	lecturerArray = args.lecturerArray ?: [];
</cfscript>
<cfoutput>
	<h1>
		#args.title#
		<a class="btn btn-success" href="#event.buildLink( linkTo="resource/lecturer/add" )#">
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
			<cfloop array="#lecturerArray#" index="index" item="lecturer">
				<tr>
					<td>#index#</td>
					<td>#lecturer.name#</td>
					<td>#lecturer.abbreviation#</td>
					<td>
						<a href="#event.buildLink( linkTo="resource/lecturer/"&lecturer.id&"/view" )#">
							<span class="glyphicon glyphicon-pencil"></span>
						</a>
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>