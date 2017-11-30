<cfscript>
	id = args.moduleDataStruct.id ?:"";
	name = args.moduleDataStruct.name ?:"";
	description = args.moduleDataStruct.description ?: "";
	abbreviation = args.moduleDataStruct.abbreviation ?: "";
	assignSameLecturer = args.moduleDataStruct.assignSameLecturer ?: "0";
	courses = args.relatedCourses ?: [];
	classTypes = args.relatedClassTypes ?: [];
</cfscript>
<cfoutput>
	<h2>Modify Module Detail</h2>
	<form action="edit.html" method="POST">
		<div class="input-group">
			<span class="input-group-addon">Name</span>
			<input class="form-control" type="text" name="name" value="#name?:""#" />
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
			<span class="input-group-addon">Assign Same Lecturer</span>
			<select class="form-control" name="assignSameLecturer">
				<option value="1" #assignSameLecturer?"selected":""#>Yes</option>
				<option value="0" #assignSameLecturer?"":"selected"#>No</option>
			</select>
		</div>
		<input type="hidden" name="moduleId" id="moduleId" value="#id#" />

		<button class="btn btn-success">Update</button>
		<button class="btn btn-danger" formaction="delete.html">Delete</button>
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/module" )#">Back</a>

		<div>
			<h3>
				Related Courses
				<span
					class="glyphicon glyphicon-plus btn btn-success"
					data-toggle="modal"
					data-target="##addRelatedCoursesModal">
					Add
				</span>
			</h3>

			<table class="table" id="relatedCoursesTable">
				<thead>
					<tr>
						<th>No.</th>
						<th>Name</th>
						<th>Effective Datetime</th>
						<th>Idle Datetime</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfif courses.len() GT 0>
						<cfloop array="#courses#" index="index" item="course">
							<tr>
								<td>#index#</td>
								<td>#course.name#</td>
								<td>#dateTimeFormat( course.effectiveTimestamp, "yyyy-mm-dd HH:nn" )#</td>
								<td>#dateTimeFormat( course.idleTimestamp, "yyyy-mm-dd HH:nn" )#</td>
								<td></td>
							</tr>
						</cfloop>
					<cfelse>
						<tr class="placeholder">
							<td colspan="100%">No Related Courses Available</td>
						</tr>
					</cfif>
				</tbody>
			</table>
		</div>

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
						<th rowspan="2">No.</th>
						<th rowspan="2">Name</th>
						<th colspan="2">Assign Time Ranges</th>
						<th rowspan="2"></th>
					</tr>
					<tr>
						<th>Start</th>
						<th>End</th>
					</tr>
				</thead>
				<tbody>
					<cfif classTypes.len() GT 0>
						<cfloop array="#classTypes#" index="index" item="classType">
							<tr>
								<td>#index#</td>
								<td>#classType.name#</td>
								<td>#timeFormat( classType.assignTimeRangeStart, "HH:mm" )#</td>
								<td>#timeFormat( classType.assignTimeRangeEnd, "HH:mm" )#</td>
								<td>
									<span class="glyphicon glyphicon-trash"></span>
								</td>
							</tr>
						</cfloop>
					<cfelse>
						<tr class="placeholder">
							<td colspan="100%">No Related ClassTypes Available</td>
						</tr>
					</cfif>
				</tbody>
			</table>
		</div>
	</form>
</cfoutput>

<div class="modal fade" id="addRelatedCoursesModal">
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

				<h4 class="modal-title">Add Related Courses</h4>
			</div>

			<div class="modal-body">
				<div class="alert" id="relatedCourseMessage"></div>
				<div class="input-group">
					<span class="input-group-addon">Name</span>
					<input type="text" class="form-control" id="txtSearchCourse" required/>
					<ul class="dropdown-menu" id="courseDropdown"></ul>
					<span class="input-group-btn">
						<button class="btn btn-default" id="btnSearchCourse">
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
				<input type="hidden" id="selectedCourseId" />
			</div>

			<div class="modal-footer">
				Add Another Related Courses
				<input type="checkbox" value="Add another" class="add-another" />
				<button type="button" class="btn btn-success" id="btnAddRelatedCourse">
					Add
				</button>
			</div>
		</div>
	</div>
</div>

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

				<h4 class="modal-title">Add Related ClassTypes</h4>
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
				<label>Class Session Assignment Time Ranges</label>
				<div class="input-group">
					<span class="input-group-addon">Start</span>
					<input type="text" class="form-control timepicker" id="classTypeAssignTimeRangeStart" required/>
				</div>
				<div class="input-group">
					<span class="input-group-addon">End</span>
					<input type="text" class="form-control timepicker" id="classTypeAssignTimeRangeEnd"/>
				</div>
				<input type="hidden" id="selectedClassTypeId" />
			</div>

			<div class="modal-footer">
				Add Another Related ClassTypes
				<input type="checkbox" value="Add another" class="add-another" />
				<button type="button" class="btn btn-success" id="btnAddRelatedClassType">
					Add
				</button>
			</div>
		</div>
	</div>
</div>