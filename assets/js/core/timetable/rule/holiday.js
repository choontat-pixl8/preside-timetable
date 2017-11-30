$( document ).ready( function(){
	$( '#txtSearchLecturer' ).blur( function(){
		$( '#lecturerDropdown' ).children().remove();
		$( '#lecturerDropdown' ).text( "" );
	} );

	$( '#btnClearSelectedLecturer' ).click( function(){
		$( '#txtSearchLecturer' ).val( null );
		$( '#selectedLecturerId' ).val( null );
	} );

	$( '#btnSearchLecturer' ).click( function(){
		var searchQuery = $( '#txtSearchLecturer' ).val().trim();

		if ( !searchQuery ) {
			return;
		}

		$.ajax( {
			  url: cfrequest.searchLecturerURL
			, data: { searchQuery : searchQuery }
			, success: function( response ){
				var lecturers = JSON.parse( response );
				var dropdown = $( '#lecturerDropdown' );

				lecturers.forEach( function( lecturer ){
					var anchor = document.createElement( 'a' );
					var listItem = document.createElement( 'li' );
					var lecturerNameAndAbbreviation = lecturer.name + ' (' + lecturer.abbreviation + ')';

					anchor.innerText = lecturerNameAndAbbreviation;

					listItem.addEventListener( 'click', function(){
						$( '#selectedLecturerId' ).val( lecturer.id );
						$( '#txtSearchLecturer' ).blur();
						$( '#txtSearchLecturer' ).val( lecturerNameAndAbbreviation || 'asd' );
					} );

					listItem.appendChild( anchor );
					dropdown.append( listItem );
				} );
			}
			, error: function(){
				alert( "Connection Error." );
			}
		} );
	} );
} );