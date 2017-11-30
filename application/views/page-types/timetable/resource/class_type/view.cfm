<cfscript>
	id                    = args.classTypeDataStruct.id                    ?: "";
	name                  = args.classTypeDataStruct.name                  ?: "";
	description           = args.classTypeDataStruct.description           ?: "";
	abbreviation          = args.classTypeDataStruct.abbreviation          ?: "";
	modules               = args.relatedModules                            ?: [];
	venues                = args.relatedVenues                             ?: [];
	durationInMinutes     = args.classTypeDataStruct.durationInMinutes     ?: 0;
	applicableToSunday    = args.classTypeDataStruct.applicableToSunday    ?: "0";
	applicableToMonday    = args.classTypeDataStruct.applicableToMonday    ?: "0";
	applicableToTuesday   = args.classTypeDataStruct.applicableToTuesday   ?: "0";
	applicableToWednesday = args.classTypeDataStruct.applicableToWednesday ?: "0";
	applicableToThursday  = args.classTypeDataStruct.applicableToThursday  ?: "0";
	applicableToFriday    = args.classTypeDataStruct.applicableToFriday    ?: "0";
	applicableToSaturday  = args.classTypeDataStruct.applicableToSaturday  ?: "0";
</cfscript>
<cfoutput>
	<h2>Modify ClassType Detail</h2>
	<form id="moduleDetails" action="edit.html" method="POST">
		<div class="input-group">
			<span class="input-group-addon">Name</span>
			<input class="form-control" type="text" name="name" value="#name#" />
		</div>
		<div class="input-group">
			<span class="input-group-addon">Description</span>
			<input class="form-control" type="text" name="description" value="#description#" />
		</div>
		<div class="input-group">
			<span class="input-group-addon">Abbreviation</span>
			<input class="form-control" type="text" name="abbreviation" value="#abbreviation#" />
		</div>
		<div class="input-group">
			<span class="input-group-addon">Duration (In Minutes)</span>
			<input class="form-control" type="number" name="durationInMinutes" value="#durationInMinutes#" />
		</div>
		<label>Applicable Days In Week</label>
		<div class="input-group">
			<span class="input-group-addon">Sunday</span>
			<select class="form-control" name="applicableToSunday">
				<option value="1" #applicableToSunday EQ "1"?"selected":""#>Yes</option>
				<option value="0" #applicableToSunday EQ "0"?"selected":""#>No</option>
			</select>
		</div>
		<div class="input-group">
			<span class="input-group-addon">Monday</span>
			<select class="form-control" name="applicableToMonday">
				<option value="1" #applicableToMonday EQ "1"?"selected":""#>Yes</option>
				<option value="0" #applicableToMonday EQ "0"?"selected":""#>No</option>
			</select>
		</div>
		<div class="input-group">
			<span class="input-group-addon">Tuesday</span>
			<select class="form-control" name="applicableToTuesday">
				<option value="1" #applicableToTuesday EQ "1"?"selected":""#>Yes</option>
				<option value="0" #applicableToTuesday EQ "0"?"selected":""#>No</option>
			</select>
		</div>
		<div class="input-group">
			<span class="input-group-addon">Wednesday</span>
			<select class="form-control" name="applicableToWednesday">
				<option value="1" #applicableToWednesday EQ "1"?"selected":""#>Yes</option>
				<option value="0" #applicableToWednesday EQ "0"?"selected":""#>No</option>
			</select>
		</div>
		<div class="input-group">
			<span class="input-group-addon">Thursday</span>
			<select class="form-control" name="applicableToThursday">
				<option value="1" #applicableToThursday EQ "1"?"selected":""#>Yes</option>
				<option value="0" #applicableToThursday EQ "0"?"selected":""#>No</option>
			</select>
		</div>
		<div class="input-group">
			<span class="input-group-addon">Friday</span>
			<select class="form-control" name="applicableToFriday">
				<option value="1" #applicableToFriday EQ "1"?"selected":""#>Yes</option>
				<option value="0" #applicableToFriday EQ "0"?"selected":""#>No</option>
			</select>
		</div>
		<div class="input-group">
			<span class="input-group-addon">Saturday</span>
			<select class="form-control" name="applicableToSaturday">
				<option value="1" #applicableToSaturday EQ "1"?"selected":""#>Yes</option>
				<option value="0" #applicableToSaturday EQ "0"?"selected":""#>No</option>
			</select>
		</div>
		<input type="hidden" name="classTypeId" id="classTypeId" value="#id#" />

		<button class="btn btn-success">Update</button>
		<button class="btn btn-danger" formaction="delete.html">Delete</button>
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/class-type" )#">Back</a>

		<div>
			<h3>
				Related Modules
				<span
					class="glyphicon glyphicon-plus btn btn-success"
					data-toggle="modal"
					data-target="##addRelatedModulesModal">
					Add
				</span>
			</h3>

			<table class="table" id="relatedModulesTable">
				<thead>
					<tr>
						<th rowspan="2">No.</th>
						<th rowspan="2">Name</th>
						<th colspan="2">Class Session Assignment Time Ranges</th>
						<th rowspan="2"></th>
					</tr>
					<tr>
						<th>Start</th>
						<th>End</th>
					</tr>
				</thead>
				<tbody>
					<cfif modules.len() GT 0>
						<cfloop array="#modules#" index="index" item="module">
							<tr>
								<td>#index#</td>
								<td>#module.moduleName#</td>
								<td>#timeFormat( module.assignTimeRangeStart, "HH:mm" )#</td>
								<td>#timeFormat( module.assignTimeRangeEnd, "HH:mm" )#</td>
								<td></td>
							</tr>
						</cfloop>
					<cfelse>
						<tr class="placeholder">
							<td colspan="100%">No Related Modules Available</td>
						</tr>
					</cfif>
				</tbody>
			</table>
		</div>

		<div>
			<h3>
				Related Venues
				<span
					class="glyphicon glyphicon-plus btn btn-success"
					data-toggle="modal"
					data-target="##addRelatedVenuesModal">
					Add
				</span>
			</h3>

			<table class="table" id="relatedVenuesTable">
				<thead>
					<tr>
						<th>No.</th>
						<th>Name</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfif venues.len() GT 0>
						<cfloop array="#venues#" index="index" item="venue">
							<tr>
								<td>#index#</td>
								<td>#venue.name#</td>
								<td></td>
							</tr>
						</cfloop>
					<cfelse>
						<tr class="placeholder">
							<td colspan="100%">No Related Venues Available</td>
						</tr>
					</cfif>
				</tbody>
			</table>
		</div>
	</form>
</cfoutput>

<div class="modal fade" id="addRelatedModulesModal">
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

				<h4 class="modal-title">Add Related Modules</h4>
			</div>

			<div class="modal-body">
				<div class="alert" id="relatedModuleMessage"></div>
				<div class="input-group">
					<span class="input-group-addon">Name</span>
					<input type="text" class="form-control" id="txtSearchModule" required/>
					<ul class="dropdown-menu" id="moduleDropdown"></ul>
					<span class="input-group-btn">
						<button class="btn btn-default" id="btnSearchModule">
							Search
						</button>
					</span>
				</div>
				<label>Class Session Assignment Time Ranges</label>
				<div class="input-group">
					<span class="input-group-addon">Start</span>
					<input type="time" class="form-control timepicker" id="assignTimeRangeStart" required/>
				</div>
				<div class="input-group">
					<span class="input-group-addon">End</span>
					<input type="time" class="form-control timepicker" id="assignTimeRangeEnd"/>
				</div>
				<input type="hidden" id="selectedModuleId" />
			</div>

			<div class="modal-footer">
				Add Another Related Modules
				<input type="checkbox" value="Add another" class="add-another" />
				<button type="button" class="btn btn-success" id="btnAddRelatedModule">
					Add
				</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="addRelatedVenuesModal">
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

				<h4 class="modal-title">Add Related Venues</h4>
			</div>

			<div class="modal-body">
				<div class="alert" id="relatedVenueMessage"></div>
				<div class="input-group">
					<span class="input-group-addon">Name</span>
					<input type="text" class="form-control" id="txtSearchVenue" required/>
					<ul class="dropdown-menu" id="venueDropdown"></ul>
					<span class="input-group-btn">
						<button class="btn btn-default" id="btnSearchVenue">
							Search
						</button>
					</span>
				</div>
				<input type="hidden" id="selectedVenueId" />
			</div>

			<div class="modal-footer">
				Add Another Related Venues
				<input type="checkbox" value="Add another" class="add-another" />
				<button type="button" class="btn btn-success" id="btnAddRelatedVenue">
					Add
				</button>
			</div>
		</div>
	</div>
</div>