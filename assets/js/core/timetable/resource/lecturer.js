$( document ).ready( function(){
	$( "input[type=checkbox].add-another" ).change( function(){
		$( this ).find( "+button" ).text( this.checked ? "Continue" : "Add" );
	} );
	$( "#txtSearchModuleClassType" ).blur( function(){
		$( "#moduleClassTypeDropdown" ).children().remove();
		$( "#moduleClassTypeDropdown" ).text( "" );
	} );

	$( "#btnSearchModuleClassType" ).click( function(){
		var searchQuery = $( "#txtSearchModuleClassType" ).val().trim();
		if ( !searchQuery ) {
			return;
		}

		$.ajax( {
			  url: "/resource/module-class-type/search.html"
			, data : { searchQuery : searchQuery }
			, success : function( moduleClassType ){
				var moduleClassTypeArr = JSON.parse( moduleClassType );
				var dropdown = $( "#moduleClassTypeDropdown" );

				moduleClassTypeArr.forEach( function( moduleClassTypeObj ){
					var listItem = document.createElement( "li" );
					var anchor = document.createElement( "a" );

					anchor.innerText = "Module: " + ( moduleClassTypeObj.module ) 
						             + "\nClass Type: " + ( moduleClassTypeObj.classType );

					listItem.value = moduleClassTypeObj.id;
					listItem.addEventListener( "click", function(){
						var name = moduleClassTypeObj.module + " - " + moduleClassTypeObj.classType;

						$( "#selectedModuleClassTypeId" ).val( moduleClassTypeObj.id );
						$( "#txtSearchModuleClassType" ).blur();
						$( "#txtSearchModuleClassType" ).val( name );
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

	$( "#btnAddRelatedModuleClassType" ).click( function(){
		var lecturerId = $( "#lecturerId" ).val() || "";
		var moduleClassTypeId = $( "#selectedModuleClassTypeId" ).val() || "";
		var effectiveTimestamp = $( "#effectiveTimestamp" ).val() || "";
		var idleTimestamp = $( "#idleTimestamp" ).val() || "";

		$.ajax( {
			url : cfrequest.addRelatedModuleClassTypeURL || ''
			, data : {
				  moduleClassTypeId : moduleClassTypeId
				, lecturerId : lecturerId
				, effectiveTimestamp : effectiveTimestamp
				, idleTimestamp : idleTimestamp
			}
			, success : function( response ){
				var responseObject = JSON.parse( response );
				var message = responseObject.message || "";
				var messageType = responseObject.messageType || '';
				var success = responseObject.success || false;
				var moduleClassTypeLecturerObject = responseObject.data || {};

				$( '#relatedModuleClassTypeMessage' ).text( message );
				$( '#relatedModuleClassTypeMessage' ).attr( "class", "alert alert-"+messageType );

				if ( success ) {
					var relatedModuleClassTypesTableBody = $( "#relatedModuleClassTypesTable tbody" );

					relatedModuleClassTypesTableBody.find( ".placeholder" ).remove();

					var relatedModuleClassTypeRow = document.createElement( "tr" );
					var recordNumberColumn = document.createElement( "td" );
					var moduleColumn = document.createElement( "td" );
					var classTypeColumn = document.createElement( "td" );
					var effectiveDatetimeColumn = document.createElement( "td" );
					var idleDatetimeColumn = document.createElement( "td" );
					var currentRecordNumber = relatedModuleClassTypesTableBody.children().length + 1;

					recordNumberColumn.innerText = currentRecordNumber;
					moduleColumn.innerText = moduleClassTypeLecturerObject.moduleName || "";
					classTypeColumn.innerText = moduleClassTypeLecturerObject.classTypeName || "";
					effectiveDatetimeColumn.innerText = moduleClassTypeLecturerObject.effectiveTimestamp || "";
					idleDatetimeColumn.innerText = moduleClassTypeLecturerObject.idleTimestamp || "";

					relatedModuleClassTypeRow.appendChild( recordNumberColumn );
					relatedModuleClassTypeRow.appendChild( moduleColumn );
					relatedModuleClassTypeRow.appendChild( classTypeColumn );
					relatedModuleClassTypeRow.appendChild( effectiveDatetimeColumn );
					relatedModuleClassTypeRow.appendChild( idleDatetimeColumn );

					relatedModuleClassTypesTableBody.append( relatedModuleClassTypeRow );
				}

				if ( !$( "#addRelatedModuleClassTypesModal input[type=checkbox].add-another:checked").length ) {
					$( "#addRelatedModuleClassTypesModal" ).modal( "hide" );
				}

				$( "#addRelatedModuleClassTypesModal input:not([type=checkbox])" ).val(null);
			}
			, error : function(){
				alert( "Connection Error" );
			}
		} );
	} );

	$( "#btnAddLecturerWorkHour" ).click( function(){
		var lecturerId = $( "#lecturerId" ).val() || "";
		var startTime = $( "#lecturerWorkHourStartTime" ).val() || "";
		var endTime = $( "#lecturerWorkHourEndTime" ).val() || "";
		var dayOfWeek = $( "#lecturerWorkHourDayOfWeek" ).val() || "";

		$.ajax( {
			  url : cfrequest.addLecturerWorkHourURL || ''
			, data : {
				  lecturerId : lecturerId
				, startTime : startTime
				, endTime : endTime
				, dayOfWeek : dayOfWeek
			}
			, success : function( response ){
				var responseObject = JSON.parse( response );
				var message = responseObject.message || "";
				var messageType = responseObject.messageType || '';
				var success = responseObject.success || false;
				var lecturerWorkHourObject = responseObject.data || {};

				$( '#lecturerWorkHourMessage' ).text( message );
				$( '#lecturerWorkHourMessage' ).attr( "class", "alert alert-"+messageType );

				if ( success ) {
					var lecturerWorkHoursTableBody = $( "#lecturerWorkHoursTable tbody" );

					lecturerWorkHoursTableBody.find( ".placeholder" ).remove();

					var lecturerWorkHourRow = document.createElement( "tr" );
					var recordNumberColumn = document.createElement( "td" );
					var startTimeColumn = document.createElement( "td" );
					var endTimeColumn = document.createElement( "td" );
					var dayOfWeekColumn = document.createElement( "td" );
					var currentRecordNumber = lecturerWorkHoursTableBody.children().length + 1;

					recordNumberColumn.innerText = currentRecordNumber;
					startTimeColumn.innerText = lecturerWorkHourObject.startTime || "";
					endTimeColumn.innerText = lecturerWorkHourObject.endTime || "";
					dayOfWeekColumn.innerText = lecturerWorkHourObject.dayOfWeek || "";

					lecturerWorkHourRow.appendChild( recordNumberColumn );
					lecturerWorkHourRow.appendChild( startTimeColumn );
					lecturerWorkHourRow.appendChild( endTimeColumn );
					lecturerWorkHourRow.appendChild( dayOfWeekColumn );

					lecturerWorkHoursTableBody.append( lecturerWorkHourRow );
				}

				if ( !$( "#addLecturerWorkHoursModal input[type=checkbox].add-another:checked").length && success) {
					$( "#addLecturerWorkHoursModal" ).modal( "hide" );
				}

				$( "#addLecturerWorkHoursModal input:not([type=checkbox])" ).val(null);
			}
			, error : function(){
				alert( "Connection Error" );
			}
		} );
	} );
} );