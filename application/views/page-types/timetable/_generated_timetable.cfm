<cfscript>
generatedTimetable = args.generatedTimetable ?: [];
</cfscript>
<cfoutput>
	<table class="table">
		<thead>
			<tr>
				<th>No.</th>
				<th>Date</th>
				<th>Intake</th>
				<th>Course</th>
				<th>Module</th>
				<th>Class Type</th>
				<th>Time</th>
				<th>Lecturer</th>
				<th>Venue</th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#generatedTimetable#" index="index" item="classSession">
				<tr>
					<td>#index#</td>
					<td>#dateFormat( classSession.date, "yyyy-mm-dd" )#</td>
					<td>#classSession.intakeName#</td>
					<td>#classSession.courseName#</td>
					<td>#classSession.moduleName#</td>
					<td>#classSession.classTypeName#</td>
					<td>#timeFormat( classSession.startTime, "HH:mm" )# - #timeFormat( classSession.endTime, "HH:mm" )#</td>
					<td>#classSession.lecturerName#</td>
					<td>#classSession.venueName#</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>