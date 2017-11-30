$( document ).ready( function(){
	$( "input[type=checkbox].add-another" ).change( function(){
		$( this ).find( "+button" ).text( this.checked ? "Continue" : "Add" );
	} );
	$( "#txtSearchCourse" ).blur( function(){
		$( "#courseDropdown" ).children().remove();
		$( "#courseDropdown" ).text( "" );
	} );

	$( "#btnSearchCourse" ).click( function(){
		var searchQuery = $( "#txtSearchCourse" ).val().trim();
		if ( !searchQuery ) {
			return;
		}

		$.ajax( {
			url: "/resource/course/search.html"
			, data : { searchQuery : searchQuery }
			, success : function( course ){
				var courseArr = JSON.parse( course );
				var dropdown = $( "#courseDropdown" );

				courseArr.forEach( function( courseObj ){
					var listItem = document.createElement( "li" );
					var anchor = document.createElement( "a" );

					anchor.innerText = ( courseObj.name ) + " (" + ( courseObj.abbreviation ) + ")";

					listItem.value = courseObj.id;
					listItem.addEventListener( "click", function(){
						$( "#selectedCourseId" ).val( courseObj.id );
						$( "#txtSearchCourse" ).blur();
						$( "#txtSearchCourse" ).val( courseObj.name );
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

	$( "#btnAddRelatedCourse" ).click( function(){
		var intakeId = $( "#intakeId" ).val() || "";
		var courseId = $( "#selectedCourseId" ).val() || "";
		var studentCount = $( "#studentCount" ).val() || 0;
		var effectiveTimestamp = $( "#effectiveTimestamp" ).val() || "";
		var idleTimestamp = $( "#idleTimestamp" ).val() || "";

		$.ajax( {
			url : cfrequest.addRelatedCourseURL || ''
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

				$( '#relatedCourseMessage' ).text( message );
				$( '#relatedCourseMessage' ).attr( "class", "alert alert-"+messageType );

				if ( success ) {
					var relatedCoursesTableBody = $( "#relatedCoursesTable tbody" );
					var relatedCourseRow = document.createElement( "tr" );
					var recordNumberColumn = document.createElement( "td" );
					var nameColumn = document.createElement( "td" );
					var studentCountColumn = document.createElement( "td" );
					var effectiveDatetimeColumn = document.createElement( "td" );
					var idleDatetimeColumn = document.createElement( "td" );
					var currentRecordNumber = relatedCoursesTableBody.children().length;

					recordNumberColumn.innerText = currentRecordNumber;
					nameColumn.innerText = intakeCourseObject.name || "";
					studentCountColumn.innerText = intakeCourseObject.studentCount || "";
					effectiveDatetimeColumn.innerText = intakeCourseObject.effectiveTimestamp || "";
					idleDatetimeColumn.innerText = intakeCourseObject.idleTimestamp || "";

					relatedCourseRow.appendChild( recordNumberColumn );
					relatedCourseRow.appendChild( nameColumn );
					relatedCourseRow.appendChild( studentCountColumn );
					relatedCourseRow.appendChild( effectiveDatetimeColumn );
					relatedCourseRow.appendChild( idleDatetimeColumn );

					relatedCoursesTableBody.append( relatedCourseRow );

					relatedCoursesTableBody.find( ".placeholder" ).remove();
				}

				if ( !$( "input[type=checkbox].add-another:checked").length ) {
					$( "#addRelatedIntakesModal" ).modal( "hide" );
				}

				$( "#addRelatedIntakesModal input:not([type=checkbox])" ).val(null);
			}
			, error : function(){
				alert( "Connection Error" );
			}
		} );
	} );
} );