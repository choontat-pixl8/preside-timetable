$( document ).ready( function(){
	$( "input[type=checkbox].add-another" ).change( function(){
		$( this ).find( "+button" ).text( this.checked ? "Continue" : "Add" );
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
		var classTypeId = $( "#classTypeId" ).val() || "";
		var moduleId = $( "#selectedModuleId" ).val() || "";
		var studentCount = $( "#studentCount" ).val() || 0;
		var assignTimeRangeStart = $( "#assignTimeRangeStart" ).val() || "";
		var assignTimeRangeEnd = $( "#assignTimeRangeEnd" ).val() || "";

		$.ajax( {
			  url : cfrequest.addRelatedModuleURL || ''
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
				var classTypeModuleObject = responseObject.data || {};

				$( '#relatedModuleMessage' ).text( message );
				$( '#relatedModuleMessage' ).attr( "class", "alert alert-"+messageType );

				if ( success ) {
					var relatedModulesTableBody = $( "#relatedModulesTable tbody" );
					var relatedModuleRow = document.createElement( "tr" );
					var recordNumberColumn = document.createElement( "td" );
					var nameColumn = document.createElement( "td" );
					var startTimeColumn = document.createElement( "td" );
					var endTimeColumn = document.createElement( "td" );
					var currentRecordNumber = relatedModulesTableBody.children().length;

					recordNumberColumn.innerText = currentRecordNumber;
					nameColumn.innerText = classTypeModuleObject.name || "";
					startTimeColumn.innerText = classTypeModuleObject.assignTimeRangeStart || "";
					endTimeColumn.innerText = classTypeModuleObject.assignTimeRangeEnd || "";

					relatedModuleRow.appendChild( recordNumberColumn );
					relatedModuleRow.appendChild( nameColumn );
					relatedModuleRow.appendChild( startTimeColumn );
					relatedModuleRow.appendChild( endTimeColumn );

					relatedModulesTableBody.append( relatedModuleRow );

					relatedModulesTableBody.find( ".placeholder" ).remove();
				}

				if ( !$( "#addRelatedModulesModal input[type=checkbox].add-another:checked").length && success ) {
					$( "#addRelatedModulesModal" ).modal( "hide" );
				}

				$( "#addRelatedModulesModal input:not([type=checkbox])" ).val(null);
			}
			, error : function(){
				alert( "Connection Error" );
			}
		} );
	} );

	$( "#txtSearchVenue" ).blur( function(){
		$( "#venueDropdown" ).children().remove();
		$( "#venueDropdown" ).text( "" );
	} );

	$( "#btnSearchVenue" ).click( function(){
		var searchQuery = $( "#txtSearchVenue" ).val().trim();
		if ( !searchQuery ) {
			return;
		}

		$.ajax( {
			url: "/resource/venue/search.html"
			, data : { searchQuery : searchQuery }
			, success : function( venue ){
				var venue = JSON.parse( venue );
				var dropdown = $( "#venueDropdown" );

				venue.forEach( function( venueObject ){
					var listItem = document.createElement( "li" );
					var anchor = document.createElement( "a" );

					anchor.innerText = ( venueObject.name ) + " (" + ( venueObject.abbreviation ) + ")";

					listItem.value = venueObject.id;
					listItem.addEventListener( "click", function(){
						$( "#selectedVenueId" ).val( venueObject.id );
						$( "#txtSearchVenue" ).blur();
						$( "#txtSearchVenue" ).val( venueObject.name );
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

	$( "#btnAddRelatedVenue" ).click( function(){
		var classTypeId = $( "#classTypeId" ).val() || "";
		var venueId = $( "#selectedVenueId" ).val() || "";

		$.ajax( {
			  url : cfrequest.addRelatedVenueURL || ''
			, data : {
				  classTypeId : classTypeId
				, venueId : venueId
			}
			, success : function( response ){
				var responseObject = JSON.parse( response );
				var message = responseObject.message || "";
				var messageType = responseObject.messageType || '';
				var success = responseObject.success || false;
				var classTypeVenueObject = responseObject.data || {};

				$( '#relatedVenueMessage' ).text( message );
				$( '#relatedVenueMessage' ).attr( "class", "alert alert-"+messageType );

				if ( success ) {
					var relatedVenuesTableBody = $( "#relatedVenuesTable tbody" );
					var relatedVenueRow = document.createElement( "tr" );
					var recordNumberColumn = document.createElement( "td" );
					var nameColumn = document.createElement( "td" );
					var currentRecordNumber = relatedVenuesTableBody.children().length;

					recordNumberColumn.innerText = currentRecordNumber;
					nameColumn.innerText = classTypeVenueObject.name || "";

					relatedVenueRow.appendChild( recordNumberColumn );
					relatedVenueRow.appendChild( nameColumn );

					relatedVenuesTableBody.append( relatedVenueRow );

					relatedVenuesTableBody.find( ".placeholder" ).remove();
				}

				if ( !$( "#addRelatedVenuesModal input[type=checkbox].add-another:checked").length ) {
					$( "#addRelatedVenuesModal" ).modal( "hide" );
				}

				$( "#addRelatedVenuesModal input:not([type=checkbox])" ).val(null);
			}
			, error : function(){
				alert( "Connection Error" );
			}
		} );
	} );
} );