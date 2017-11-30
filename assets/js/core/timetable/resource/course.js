$( document ).ready( function(){
	$( "input[type=checkbox].add-another" ).change( function(){
		$( this ).find( "+button" ).text( this.checked ? "Continue" : "Add" );
	} );

	$( "#txtSearchIntake" ).blur( function(){
		$( "#intakeDropdown" ).children().remove();
		$( "#intakeDropdown" ).text( "" );
	} );

	$( "#btnSearchIntake" ).click( function(){
		var searchQuery = $( "#txtSearchIntake" ).val().trim();
		if ( !searchQuery ) {
			return;
		}

		$.ajax( {
			url: "/resource/intake/search.html"
			, data : { searchQuery : searchQuery }
			, success : function( intake ){
				var intake = JSON.parse( intake );
				var dropdown = $( "#intakeDropdown" );

				intake.forEach( function( intakeObject ){
					var listItem = document.createElement( "li" );
					var anchor = document.createElement( "a" );

					anchor.innerText = ( intakeObject.name ) + " (" + ( intakeObject.abbreviation ) + ")";

					listItem.value = intakeObject.id;
					listItem.addEventListener( "click", function(){
						$( "#selectedIntakeId" ).val( intakeObject.id );
						$( "#txtSearchIntake" ).blur();
						$( "#txtSearchIntake" ).val( intakeObject.name );
					} );

					listItem.append( anchor );
					dropdown.append( listItem );
				} );
			}
			, error : function(){
				alert( "Connection error." );
			}
		} );
	} );

	$( "#btnAddRelatedIntake" ).click( function(){
		var courseId = $( "#courseId" ).val() || "";
		var intakeId = $( "#selectedIntakeId" ).val() || "";
		var studentCount = $( "#studentCount" ).val() || 0;
		var effectiveTimestamp = $( "#effectiveTimestamp" ).val() || "";
		var idleTimestamp = $( "#idleTimestamp" ).val() || "";

		$.ajax( {
			  url : cfrequest.addRelatedIntakeURL || ''
			, data : {
				  courseId : courseId
				, intakeId : intakeId
				, studentCount : studentCount
				, effectiveTimestamp : effectiveTimestamp
				, idleTimestamp : idleTimestamp
			}
			, success : function( response ){
				var responseObject = JSON.parse( response );
				var message = responseObject.message || "";
				var messageType = responseObject.messageType || '';
				var success = responseObject.success || false;
				var intakeCourseObject = responseObject.data || {};

				$( '#relatedIntakeMessage' ).text( message );
				$( '#relatedIntakeMessage' ).attr( "class", "alert alert-"+messageType );

				if ( success ) {
					var relatedIntakesTableBody = $( "#relatedIntakesTable tbody" );
					var relatedIntakeRow = document.createElement( "tr" );
					var recordNumberColumn = document.createElement( "td" );
					var nameColumn = document.createElement( "td" );
					var studentCountColumn = document.createElement( "td" );
					var effectiveDatetimeColumn = document.createElement( "td" );
					var idleDatetimeColumn = document.createElement( "td" );
					var currentRecordNumber = relatedIntakesTableBody.children().length;

					recordNumberColumn.innerText = currentRecordNumber;
					nameColumn.innerText = intakeCourseObject.name || "";
					studentCountColumn.innerText = intakeCourseObject.studentCount || "";
					effectiveDatetimeColumn.innerText = intakeCourseObject.effectiveTimestamp || "";
					idleDatetimeColumn.innerText = intakeCourseObject.idleTimestamp || "";

					relatedIntakeRow.appendChild( recordNumberColumn );
					relatedIntakeRow.appendChild( nameColumn );
					relatedIntakeRow.appendChild( studentCountColumn );
					relatedIntakeRow.appendChild( effectiveDatetimeColumn );
					relatedIntakeRow.appendChild( idleDatetimeColumn );

					relatedIntakesTableBody.append( relatedIntakeRow );

					relatedIntakesTableBody.find( ".placeholder" ).remove();
				}

				if ( !$( "#addRelatedCoursesModal input[type=checkbox].add-another:checked").length ) {
					$( "#addRelatedCoursesModal" ).modal( "hide" );
				}

				$( "#addRelatedCoursesModal input:not([type=checkbox])" ).val(null);
			}
			, error : function(){
				alert( "Connection Error" );
			}
		} );
	} );

	$( "#txtSearchModule" ).blur( function(){
		$( "#moduleDropdown" ).children().remove();
		$( "#moduleDropdown" ).text( "" );
	} );

	$( "#btnSearchModule" ).click( function(){
		var searchQuery = $( "#txtSearchModule" ).val().trim();
		if ( !searchQuery ) {
			return;
		}

		$.ajax( {
			url: "/resource/module/search.html"
			, data : { searchQuery : searchQuery }
			, success : function( module ){
				var module = JSON.parse( module );
				var dropdown = $( "#moduleDropdown" );

				module.forEach( function( moduleObject ){
					var listItem = document.createElement( "li" );
					var anchor = document.createElement( "a" );

					anchor.innerText = ( moduleObject.name ) + " (" + ( moduleObject.abbreviation ) + ")";

					listItem.value = moduleObject.id;
					listItem.addEventListener( "click", function(){
						$( "#selectedModuleId" ).val( moduleObject.id );
						$( "#txtSearchModule" ).blur();
						$( "#txtSearchModule" ).val( moduleObject.name );
					} );

					listItem.append( anchor );
					dropdown.append( listItem );
				} );
			}
			, error : function(){
				alert( "Connection error." );
			}
		} );
	} );

	$( "#btnAddRelatedModule" ).click( function(){
		var courseId = $( "#courseId" ).val() || "";
		var moduleId = $( "#selectedModuleId" ).val() || "";
		var effectiveTimestamp = $( "#courseModuleEffectiveTimestamp" ).val() || "";
		var idleTimestamp = $( "#courseModuleIdleTimestamp" ).val() || "";

		$.ajax( {
			  url : cfrequest.addRelatedModuleURL || ''
			, data : {
				  courseId : courseId
				, moduleId : moduleId
				, effectiveTimestamp : effectiveTimestamp
				, idleTimestamp : idleTimestamp
			}
			, success : function( response ){
				var responseObject = JSON.parse( response );
				var message = responseObject.message || "";
				var messageType = responseObject.messageType || '';
				var success = responseObject.success || false;
				var moduleCourseObject = responseObject.data || {};

				$( '#relatedModuleMessage' ).text( message );
				$( '#relatedModuleMessage' ).attr( "class", "alert alert-"+messageType );

				if ( success ) {
					var relatedModulesTableBody = $( "#relatedModulesTable tbody" );
					var relatedModuleRow = document.createElement( "tr" );
					var recordNumberColumn = document.createElement( "td" );
					var nameColumn = document.createElement( "td" );
					var effectiveDatetimeColumn = document.createElement( "td" );
					var idleDatetimeColumn = document.createElement( "td" );
					var currentRecordNumber = relatedModulesTableBody.children().length;

					recordNumberColumn.innerText = currentRecordNumber;
					nameColumn.innerText = moduleCourseObject.name || "";
					effectiveDatetimeColumn.innerText = moduleCourseObject.effectiveTimestamp || "";
					idleDatetimeColumn.innerText = moduleCourseObject.idleTimestamp || "";

					relatedModuleRow.appendChild( recordNumberColumn );
					relatedModuleRow.appendChild( nameColumn );
					relatedModuleRow.appendChild( effectiveDatetimeColumn );
					relatedModuleRow.appendChild( idleDatetimeColumn );

					relatedModulesTableBody.append( relatedModuleRow );

					relatedModulesTableBody.find( ".placeholder" ).remove();
				}

				if ( !$( "#addRelatedModulesModal input[type=checkbox].add-another:checked").length ) {
					$( "#addRelatedModulesModal" ).modal( "hide" );
				}

				$( "#addRelatedModulesModal input:not([type=checkbox])" ).val(null);
			}
			, error : function(){
				alert( "Connection Error" );
			}
		} );
	} );
} );