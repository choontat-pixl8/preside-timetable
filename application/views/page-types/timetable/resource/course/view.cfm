<cfscript>
	id = args.courseDataStruct.id ?:"";
	name = args.courseDataStruct.name ?:"";
	description = args.courseDataStruct.description ?: "";
	abbreviation = args.courseDataStruct.abbreviation ?: "";
	intakes = args.relatedIntakes ?: [];
	modules = args.relatedModules ?: [];
</cfscript>
<cfoutput>
	<h2>Modify Course Detail</h2>
	<form action="edit.html" method="POST">
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
		<input type="hidden" name="courseId" id="courseId" value="#id#" />

		<button class="btn btn-success">Update</button>
		<button class="btn btn-danger" formaction="delete.html">Delete</button>
		<a class="btn btn-info" href="#event.buildLink( linkTo="resource/course" )#">Back</a>

		<div>
			<h3>
				Related Intakes
				<span
					class="glyphicon glyphicon-plus btn btn-success"
					data-toggle="modal"
					data-target="##addRelatedIntakesModal">
					Add
				</span>
			</h3>

			<table class="table" id="relatedIntakesTable">
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
					<cfif intakes.len() GT 0>
						<cfloop array="#intakes#" index="index" item="intake">
							<tr>
								<td>#index#</td>
								<td>#intake.name#</td>
								<td>#intake.studentCount#</td>
								<td>#dateTimeFormat( intake.effectiveTimestamp, "yyyy-mm-dd HH:nn" )#</td>
								<td>#dateTimeFormat( intake.idleTimestamp, "yyyy-mm-dd HH:nn" )#</td>
								<td></td>
							</tr>
						</cfloop>
					<cfelse>
						<tr class="placeholder">
							<td colspan="100%">No Related Intakes Available</td>
						</tr>
					</cfif>
				</tbody>
			</table>
		</div>

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
						<th>No.</th>
						<th>Name</th>
						<th>Effective Datetime</th>
						<th>Idle Datetime</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfif modules.len() GT 0>
						<cfloop array="#modules#" index="index" item="module">
							<tr>
								<td>#index#</td>
								<td>#module.name#</td>
								<td>#dateTimeFormat( module.effectiveTimestamp, "yyyy-mm-dd HH:nn" )#</td>
								<td>#dateTimeFormat( module.idleTimestamp, "yyyy-mm-dd HH:nn" )#</td>
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
	</form>
</cfoutput>

<div class="modal fade" id="addRelatedIntakesModal">
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

				<h4 class="modal-title">Add Related Intake</h4>
			</div>

			<div class="modal-body">
				<div class="alert" id="relatedIntakeMessage"></div>
				<div class="input-group">
					<span class="input-group-addon">Name</span>
					<input type="text" class="form-control" id="txtSearchIntake" required/>
					<ul class="dropdown-menu" id="intakeDropdown"></ul>
					<span class="input-group-btn">
						<button class="btn btn-default" id="btnSearchIntake">
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
				<input type="hidden" id="selectedIntakeId" />
			</div>

			<div class="modal-footer">
				Add Another Related Intake
				<input type="checkbox" value="Add another" class="add-another" />
				<button type="button" class="btn btn-success" id="btnAddRelatedIntake">
					Add
				</button>
			</div>
		</div>
	</div>
</div>

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

				<h4 class="modal-title">Add Related Module</h4>
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
				<div class="input-group">
					<span class="input-group-addon">Effective Datetime</span>
					<input type="text" class="form-control datetimepicker" id="courseModuleEffectiveTimestamp" required/>
				</div>
				<div class="input-group">
					<span class="input-group-addon">Idle Datetime</span>
					<input type="text" class="form-control datetimepicker" id="courseModuleIdleTimestamp"/>
				</div>
				<input type="hidden" id="selectedModuleId" />
			</div>

			<div class="modal-footer">
				Add Another Related Module
				<input type="checkbox" value="Add another" class="add-another" />
				<button type="button" class="btn btn-success" id="btnAddRelatedModule">
					Add
				</button>
			</div>
		</div>
	</div>
</div>