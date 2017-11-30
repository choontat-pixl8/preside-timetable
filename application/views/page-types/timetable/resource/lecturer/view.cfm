<cfscript>
	id = args.lecturerDataStruct.id ?:"";
	name = args.lecturerDataStruct.name ?:"";
	abbreviation = args.lecturerDataStruct.abbreviation ?: "";
	moduleClassTypes = args.relatedModuleClassTypes ?: [];
	lecturerWorkHours = args.lecturerWorkHours ?: [];
</cfscript>
<cfoutput>
	<h2>Modify Lecturer Detail</h2>
	<form action="edit.html" method="POST">
		<div class="input-group">
			<span class="input-group-addon">Name</span>
			<input class="form-control" type="text" name="name" value="#name?:""#" />
		</div>
		<div class="input-group">
			<span class="input-group-addon">Abbreviation</span>
			<input class="form-control" type="text" name="abbreviation" value="#abbreviation#" />
		</div>
		<input type="hidden" name="lecturerId" id="lecturerId" value="#id#" />

		<button class="btn btn-success">Update</button>
		<button class="btn btn-danger" formaction="delete.html">Delete</button>
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/lecturer" )#">Back</a>

		<div>
			<h3>
				Related Module And Class Type
				<span
					class="glyphicon glyphicon-plus btn btn-success"
					data-toggle="modal"
					data-target="##addRelatedModuleClassTypesModal">
					Add
				</span>
			</h3>

			<table class="table" id="relatedModuleClassTypesTable">
				<thead>
					<tr>
						<th>No.</th>
						<th>Module</th>
						<th>Class Type</th>
						<th>Effective Datetime</th>
						<th>Idle Datetime</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfif moduleClassTypes.len() GT 0>
						<cfloop array="#moduleClassTypes#" index="index" item="moduleClassType">
							<tr>
								<td>#index#</td>
								<td>#moduleClassType.moduleName#</td>
								<td>#moduleClassType.classTypeName#</td>
								<td>#dateTimeFormat( moduleClassType.effectiveTimestamp, "yyyy-mm-dd HH:nn" )#</td>
								<td>#dateTimeFormat( moduleClassType.idleTimestamp, "yyyy-mm-dd HH:nn" )#</td>
								<td></td>
							</tr>
						</cfloop>
					<cfelse>
						<tr class="placeholder">
							<td colspan="100%">No Related Module Class Types Available</td>
						</tr>
					</cfif>
				</tbody>
			</table>
		</div>

		<div>
			<h3>
				Work Hours
				<span
					class="glyphicon glyphicon-plus btn btn-success"
					data-toggle="modal"
					data-target="##addLecturerWorkHoursModal">
					Add
				</span>
			</h3>

			<table class="table" id="lecturerWorkHoursTable">
				<thead>
					<tr>
						<th>No.</th>
						<th>Start Time</th>
						<th>End Time</th>
						<th>Day Of Week</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfif lecturerWorkHours.len() GT 0>
						<cfloop array="#lecturerWorkHours#" index="index" item="lecturerWorkHour">
							<tr>
								<td>#index#</td>
								<td>#timeFormat( lecturerWorkHour.startTime, "HH:mm" )#</td>
								<td>#timeFormat( lecturerWorkHour.endTime, "HH:mm" )#</td>
								<td>#lecturerWorkHour.dayOfWeek#</td>
								<td></td>
							</tr>
						</cfloop>
					<cfelse>
						<tr class="placeholder">
							<td colspan="100%">No Related ModuleClassTypes Available</td>
						</tr>
					</cfif>
				</tbody>
			</table>
		</div>
	</form>
</cfoutput>

<div class="modal fade" id="addRelatedModuleClassTypesModal">
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

				<h4 class="modal-title">Add Related Module And Class Type</h4>
			</div>

			<div class="modal-body">
				<div class="alert" id="relatedModuleClassTypeMessage"></div>
				<div class="input-group">
					<span class="input-group-addon">Name</span>
					<input type="text" class="form-control" id="txtSearchModuleClassType" required/>
					<ul class="dropdown-menu" id="moduleClassTypeDropdown"></ul>
					<span class="input-group-btn">
						<button class="btn btn-default" id="btnSearchModuleClassType">
							Search
						</button>
					</span>
				</div>
				<div class="input-group">
					<span class="input-group-addon">Effective Datetime</span>
					<input type="text" class="form-control datetimepicker" id="effectiveTimestamp" required/>
				</div>
				<div class="input-group">
					<span class="input-group-addon">Idle Datetime</span>
					<input type="text" class="form-control datetimepicker" id="idleTimestamp"/>
				</div>
				<input type="hidden" id="selectedModuleClassTypeId" />
			</div>

			<div class="modal-footer">
				Add Another Related ModuleClassTypes
				<input type="checkbox" value="Add another" class="add-another" />
				<button type="button" class="btn btn-success" id="btnAddRelatedModuleClassType">
					Add
				</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="addLecturerWorkHoursModal">
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

				<h4 class="modal-title">Add Related LecturerWorkHours</h4>
			</div>

			<div class="modal-body">
				<div class="alert" id="lecturerWorkHourMessage"></div>
				<div class="input-group">
					<span class="input-group-addon">Start</span>
					<input type="time" class="form-control timepicker" id="lecturerWorkHourStartTime" required/>
				</div>
				<div class="input-group">
					<span class="input-group-addon">End</span>
					<input type="time" class="form-control timepicker" id="lecturerWorkHourEndTime"/>
				</div>
				<div class="input-group">
					<span class="input-group-addon">Day Of Week</span>
					<select class="form-control" id="lecturerWorkHourDayOfWeek">
						<option value="Sunday">Sunday</option>
						<option value="Monday">Monday</option>
						<option value="Tuesday">Tuesday</option>
						<option value="Wednesday">Wednesday</option>
						<option value="Thursday">Thursday</option>
						<option value="Friday">Friday</option>
						<option value="Saturday">Saturday</option>
					</select>
				</div>
			</div>

			<div class="modal-footer">
				Add Another Lecturer Work Hour
				<input type="checkbox" value="Add another" class="add-another" />
				<button type="button" class="btn btn-success" id="btnAddLecturerWorkHour">
					Add
				</button>
			</div>
		</div>
	</div>
</div>