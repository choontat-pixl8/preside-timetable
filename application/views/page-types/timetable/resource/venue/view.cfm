<cfscript>
	id = args.venueDataStruct.id ?:"";
	name = args.venueDataStruct.name ?:"";
	abbreviation = args.venueDataStruct.abbreviation ?: "";
	capacity = args.venueDataStruct.capacity ?: "0";
	available = args.venueDataStruct.available ?: "0";
	classTypes = args.relatedClassTypes ?: [];
</cfscript>
<cfoutput>
	<h2>Modify Venue Detail</h2>
	<form action="edit.html" method="POST">
		<div class="input-group">
			<span class="input-group-addon">Name</span>
			<input class="form-control" type="text" name="name" value="#name?:""#" />
		</div>
		<div class="input-group">
			<span class="input-group-addon">Abbreviation</span>
			<input class="form-control" type="text" name="abbreviation" value="#abbreviation#" />
		</div>
		<div class="input-group">
			<span class="input-group-addon">Capacity</span>
			<input class="form-control" type="text" name="capacity" value="#capacity#" />
		</div>
		<div class="input-group">
			<span class="input-group-addon">Available</span>
			<select class="form-control" name="available">
				<option value="1" #available EQ "1"?"selected":""#>Yes</option>
				<option value="0" #available EQ "0"?"selected":""#>No</option>
			</select>
		</div>
		<input type="hidden" name="venueId" id="venueId" value="#id#" />

		<button class="btn btn-success">Update</button>
		<button class="btn btn-danger" formaction="delete.html">Delete</button>
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/venue" )#">Back</a>

		<div>
			<h3>
				Related Class Types
				<span
					class="glyphicon glyphicon-plus btn btn-success"
					data-toggle="modal"
					data-target="##addRelatedClassTypesModal">
					Add
				</span>
			</h3>

			<table class="table" id="relatedClassTypesTable">
				<thead>
					<tr>
						<th>No.</th>
						<th>Name</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfif classTypes.len() GT 0>
						<cfloop array="#classTypes#" index="index" item="classType">
							<tr>
								<td>#index#</td>
								<td>#classType.name#</td>
								<td></td>
							</tr>
						</cfloop>
					<cfelse>
						<tr class="placeholder">
							<td colspan="100%">No Related Class Types Available</td>
						</tr>
					</cfif>
				</tbody>
			</table>
		</div>
	</form>
</cfoutput>

<div class="modal fade" id="addRelatedClassTypesModal">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button
					type         = "button" 
					class        = "close"
					data-dismiss = "modal"
					aria-label   = "Close">
					<span aria-hidden="true">&times;</span>
				</button>

				<h4 class="modal-title">Add Related Class Types</h4>
			</div>

			<div class="modal-body">
				<div class="alert" id="relatedClassTypeMessage"></div>
				<div class="input-group">
					<span class="input-group-addon">Name</span>
					<input type="text" class="form-control" id="txtSearchClassType" required/>
					<ul class="dropdown-menu" id="classTypeDropdown"></ul>
					<span class="input-group-btn">
						<button class="btn btn-default" id="btnSearchClassType">
							Search
						</button>
					</span>
				</div>
				<input type="hidden" id="selectedClassTypeId" />
			</div>

			<div class="modal-footer">
				Add Another Related Class Types
				<input type="checkbox" value="Add another" class="add-another" />
				<button type="button" class="btn btn-success" id="btnAddRelatedClassType">
					Add
				</button>
			</div>
		</div>
	</div>
</div>