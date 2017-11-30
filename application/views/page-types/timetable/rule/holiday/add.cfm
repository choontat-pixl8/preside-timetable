<cfoutput>
	<h2>Add New Holiday</h2>
	<form id="holidayForm" action="#event.buildLink()#" method="POST" class="form form-horizontal">
		<div class="input-group">
			<span class="input-group-addon">Name</span>
			<input class="form-control" type="text" name="name" />
		</div>
		<label>Duration</label>
		<div class="input-group">
			<span class="input-group-addon">Begin</span>
			<input type="text" class="datetimepicker form-control" name="beginTimestamp" />
		</div>
		<div class="input-group">
			<span class="input-group-addon">End</span>
			<input type="text" class="datetimepicker form-control" name="endTimestamp" />
		</div>
		<br />
		<div class="input-group">
			<span class="input-group-addon">Lecturer</span>
			<input type="text" class="form-control" id="txtSearchLecturer" />

			<input type="hidden" name="selectedLecturerId" id="selectedLecturerId" />

			<ul class="dropdown-menu" id="lecturerDropdown"></ul>

			<span class="input-group-btn">
				<a class="btn btn-default" id="btnSearchLecturer">
					Search
				</a>
				<a class="btn btn-default" id="btnClearSelectedLecturer">
					<span class="glyphicon glyphicon-remove"></span>
				</a>
			</span>
		</div>
		<div class="input-group">
			<button class="btn btn-success">Create</button>
			<a class="btn btn-info" href="#event.buildLink( linkTo="resource/holiday" )#">Back</a>
		</div>
	</form>
</cfoutput>