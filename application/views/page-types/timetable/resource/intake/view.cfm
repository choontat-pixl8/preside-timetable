<cfscript>
	id = args.intakeDataStruct.id ?:"";
	name = args.intakeDataStruct.name ?:"";
	description = args.intakeDataStruct.description ?: "";
	abbreviation = args.intakeDataStruct.abbreviation ?: "";
	courses = args.relatedCourses ?: [];
</cfscript>
<cfoutput>
	<h2>Modify Intake Detail</h2>
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
		<input type="hidden" name="intakeId" id="intakeId" value="#id#" />

		<button class="btn btn-success">Update</button>
		<button class="btn btn-danger" formaction="delete.html">Delete</button>
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/intake" )#">Back</a>

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
						<th>Student Count</th>
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
								<td>#course.studentCount#</td>
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
					<span class="input-group-addon">Student Count</span>
					<input type="number" class="form-control" id="studentCount" required/>
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