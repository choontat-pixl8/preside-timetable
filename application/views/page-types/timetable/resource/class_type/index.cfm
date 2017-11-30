<cf_presideparam name="args.title" field="page.title" />

<cfscript>
	classTypeArray = args.classTypeArray ?: [];
</cfscript>
<cfoutput>
	<h1>
		#args.title#
		<a class="btn btn-success" href="#event.buildLink( linkTo="resource/class-type/add" )#">
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
			<cfloop array="#classTypeArray#" index="index" item="classType">
				<tr>
					<td>#index#</td>
					<td>#classType.name#</td>
					<td>#classType.abbreviation#</td>
					<td>
						<a href="#event.buildLink( linkTo="resource/class-type/"&classType.id&"/view" )#">
							<span class="glyphicon glyphicon-pencil"></span>
						</a>
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>