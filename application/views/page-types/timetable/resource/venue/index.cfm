<cf_presideparam name="args.title" field="page.title" />

<cfscript>
	venueArray = args.venueArray ?: [];
</cfscript>
<cfoutput>
	<h1>
		#args.title#
		<a class="btn btn-success" href="#event.buildLink( linkTo="resource/venue/add" )#">
			<span class="glyphicon glyphicon-plus"></span>
		</a>
	</h1>
	
	<table class="table table-striped">
		<thead>
			<tr>
				<th>No.</th>
				<th>Name</th>
				<th>Abbreviation</th>
				<th>Capacity</th>
				<th>Available</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#venueArray#" index="index" item="venue">
				<tr>
					<td>#index#</td>
					<td>#venue.name#</td>
					<td>#venue.abbreviation#</td>
					<td>#venue.capacity#</td>
					<td>#venue.available EQ "1"?"Yes":"No"#</td>
					<td>
						<a href="#event.buildLink( linkTo="resource/venue/"&venue.id&"/view" )#">
							<span class="glyphicon glyphicon-pencil"></span>
						</a>
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>