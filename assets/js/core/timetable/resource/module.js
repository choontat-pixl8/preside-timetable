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
				var course = JSON.parse( course );
				var dropdown = $( "#courseDropdown" );

				course.forEach( function( courseObject ){
					var listItem = document.createElement( "li" );
					var anchor = document.createElement( "a" );

					anchor.innerText = ( courseObject.name ) + " (" + ( courseObject.abbreviation ) + ")";

					listItem.value = courseObject.id;
					listItem.addEventListener( "click", function(){
						$( "#selectedCourseId" ).val( courseObject.id );
						$( "#txtSearchCourse" ).blur();
						$( "#txtSearchCourse" ).val( courseObject.name );
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
		var moduleId = $( "#moduleId" ).val() || "";
		var courseId = $( "#selectedCourseId" ).val() || "";
		var studentCount = $( "#studentCount" ).val() || 0;
		var effectiveTimestamp = $( "#effectiveTimestamp" ).val() || "";
		var idleTimestamp = $( "#idleTimestamp" ).val() || "";

		$.ajax( {
			  url : cfrequest.addRelatedCourseURL || ''
			, data : {
				  moduleId : moduleId
				, courseId : courseId
				, studentCount : studentCount
				, effectiveTimestamp : effectiveTimestamp
				, idleTimestamp : idleTimestamp
			}
			, success : function( response ){
				var responseObject = JSON.parse( response );
				var message = responseObject.message || "";
				var messageType = responseObject.messageType || '';
				var success = responseObject.success || false;
				var courseModuleObject = responseObject.data || {};

				$( '#relatedCourseMessage' ).text( message );
				$( '#relatedCourseMessage' ).attr( "class", "alert alert-"+messageType );

				if ( success ) {
					var relatedCoursesTableBody = $( "#relatedCoursesTable tbody" );
					var relatedCourseRow = document.createElement( "tr" );
					var recordNumberColumn = document.createElement( "td" );
					var nameColumn = document.createElement( "td" );
					var effectiveDatetimeColumn = document.createElement( "td" );
					var idleDatetimeColumn = document.createElement( "td" );
					var currentRecordNumber = relatedCoursesTableBody.children().length;

					recordNumberColumn.innerText = currentRecordNumber;
					nameColumn.innerText = courseModuleObject.name || "";
					effectiveDatetimeColumn.innerText = courseModuleObject.effectiveTimestamp || "";
					idleDatetimeColumn.innerText = courseModuleObject.idleTimestamp || "";

					relatedCourseRow.appendChild( recordNumberColumn );
					relatedCourseRow.appendChild( nameColumn );
					relatedCourseRow.appendChild( effectiveDatetimeColumn );
					relatedCourseRow.appendChild( idleDatetimeColumn );

					relatedCoursesTableBody.append( relatedCourseRow );

					relatedCoursesTableBody.find( ".placeholder" ).remove();
				}

				if ( !$( "input[type=checkbox].add-another:checked").length ) {
					$( "#addRelatedModulesModal" ).modal( "hide" );
				}

				$( "#addRelatedModulesModal input:not([type=checkbox])" ).val(null);
			}
			, error : function(){
				alert( "Connection Error" );
			}
		} );
	} );

	$( "#txtSearchClassType" ).blur( function(){
		$( "#classTypeDropdown" ).children().remove();
		$( "#classTypeDropdown" ).text( "" );
	} );

	$( "#btnSearchClassType" ).click( function(){
		var searchQuery = $( "#txtSearchClassType" ).val().trim();
		if ( !searchQuery ) {
			return;
		}

		$.ajax( {
			url: "/resource/class-type/search.html"
			, data : { searchQuery : searchQuery }
			, success : function( classType ){
				var classType = JSON.parse( classType );
				var dropdown = $( "#classTypeDropdown" );

				classType.forEach( function( classTypeObject ){
					var listItem = document.createElement( "li" );
					var anchor = document.createElement( "a" );

					anchor.innerText = ( classTypeObject.name ) + " (" + ( classTypeObject.abbreviation ) + ")";

					listItem.value = classTypeObject.id;
					listItem.addEventListener( "click", function(){
						$( "#selectedClassTypeId" ).val( classTypeObject.id );
						$( "#txtSearchClassType" ).blur();
						$( "#txtSearchClassType" ).val( classTypeObject.name );
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

	$( "#btnAddRelatedClassType" ).click( function(){
		var moduleId = $( "#moduleId" ).val() || "";
		var classTypeId = $( "#selectedClassTypeId" ).val() || "";
		var assignTimeRangeStart = $( "#classTypeAssignTimeRangeStart" ).val() || "";
		var assignTimeRangeEnd = $( "#classTypeAssignTimeRangeEnd" ).val() || "";

		$.ajax( {
			  url : cfrequest.addRelatedClassTypeURL || ''
			, data : {
				  moduleId : moduleId
				, classTypeId : classTypeId
				, assignTimeRangeStart : assignTimeRangeStart
				, assignTimeRangeEnd : assignTimeRangeEnd
			}
			, success : function( response ){
				var responseObject = JSON.parse( response );
				var message = responseObject.message || "";
				var messageType = responseObject.messageType || '';
				var success = responseObject.success || false;
				var moduleClassTypeObject = responseObject.data || {};

				$( '#relatedClassTypeMessage' ).text( message );
				$( '#relatedClassTypeMessage' ).attr( "class", "alert alert-"+messageType );

				if ( success ) {
					var relatedClassTypesTableBody = $( "#relatedClassTypesTable tbody" );
					var relatedClassTypeRow = document.createElement( "tr" );
					var recordNumberColumn = document.createElement( "td" );
					var nameColumn = document.createElement( "td" );
					var assignTimeRangeStartColumn = document.createElement( "td" );
					var assignTimeRangeEndColumn = document.createElement( "td" );
					var currentRecordNumber = relatedClassTypesTableBody.children().length;

					recordNumberColumn.innerText = currentRecordNumber;
					nameColumn.innerText = moduleClassTypeObject.name || "";
					assignTimeRangeStartColumn.innerText = moduleClassTypeObject.assignTimeRangeStart || "";
					assignTimeRangeEndColumn.innerText = moduleClassTypeObject.assignTimeRangeEnd || "";

					relatedClassTypeRow.appendChild( recordNumberColumn );
					relatedClassTypeRow.appendChild( nameColumn );
					relatedClassTypeRow.appendChild( assignTimeRangeStartColumn );
					relatedClassTypeRow.appendChild( assignTimeRangeEndColumn );

					relatedClassTypesTableBody.append( relatedClassTypeRow );

					relatedClassTypesTableBody.find( ".placeholder" ).remove();
				}

				if ( !$( "input[type=checkbox].add-another:checked").length ) {
					$( "#addRelatedClassTypesModal" ).modal( "hide" );
				}

				$( "#addRelatedClassTypesModal input:not([type=checkbox])" ).val(null);
			}
			, error : function(){
				alert( "Connection Error" );
			}
		} );
	} );
} );