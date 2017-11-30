<cf_presideparam name="args.title" field="page.title" />

<cfscript>
	courseArray = args.courseArray ?: [];
</cfscript>
<cfoutput>
	<h1>
		#args.title#
		<a class="btn btn-success" href="#event.buildLink( linkTo="resource/course/add" )#">
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
			<cfloop array="#courseArray#" index="index" item="course">
				<tr>
					<td>#index#</td>
					<td>#course.name#</td>
					<td>#course.abbreviation#</td>
					<td>
						<a href="#event.buildLink( linkTo="resource/course/"&course.id&"/view" )#">
							<span class="glyphicon glyphicon-pencil"></span>
						</a>
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>