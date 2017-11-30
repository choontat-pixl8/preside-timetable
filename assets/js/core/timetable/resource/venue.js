$( document ).ready( function(){
	$( "input[type=checkbox].add-another" ).change( function(){
		$( this ).find( "+button" ).text( this.checked ? "Continue" : "Add" );
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
				var classTypeArr = JSON.parse( classType );
				var dropdown = $( "#classTypeDropdown" );

				classTypeArr.forEach( function( classTypeObj ){
					var listItem = document.createElement( "li" );
					var anchor = document.createElement( "a" );

					anchor.innerText = ( classTypeObj.name ) + " (" + ( classTypeObj.abbreviation ) + ")";

					listItem.value = classTypeObj.id;
					listItem.addEventListener( "click", function(){
						$( "#selectedClassTypeId" ).val( classTypeObj.id );
						$( "#txtSearchClassType" ).blur();
						$( "#txtSearchClassType" ).val( classTypeObj.name );
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
		var venueId = $( "#venueId" ).val() || "";
		var classTypeId = $( "#selectedClassTypeId" ).val() || "";
		var studentCount = $( "#studentCount" ).val() || 0;
		var effectiveTimestamp = $( "#effectiveTimestamp" ).val() || "";
		var idleTimestamp = $( "#idleTimestamp" ).val() || "";

		$.ajax( {
			  url : cfrequest.addRelatedClassTypeURL || ''
			, data : {
				  classTypeId : classTypeId
				, venueId : venueId
			}
			, success : function( response ){
				var responseObject = JSON.parse( response );
				var message = responseObject.message || "";
				var messageType = responseObject.messageType || '';
				var success = responseObject.success || false;
				var venueClassTypeObject = responseObject.data || {};

				$( '#relatedClassTypeMessage' ).text( message );
				$( '#relatedClassTypeMessage' ).attr( "class", "alert alert-"+messageType );

				if ( success ) {
					var relatedClassTypesTableBody = $( "#relatedClassTypesTable tbody" );
					var relatedClassTypeRow = document.createElement( "tr" );
					var recordNumberColumn = document.createElement( "td" );
					var nameColumn = document.createElement( "td" );
					var currentRecordNumber = relatedClassTypesTableBody.children().length + 1;

					recordNumberColumn.innerText = currentRecordNumber;
					nameColumn.innerText = venueClassTypeObject.name || "";

					relatedClassTypeRow.appendChild( recordNumberColumn );
					relatedClassTypeRow.appendChild( nameColumn );

					relatedClassTypesTableBody.append( relatedClassTypeRow );

					relatedClassTypesTableBody.find( ".placeholder" ).remove();
				}

				if ( !$( "input[type=checkbox].add-another:checked").length && success ) {
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