component {
	property name="websiteLoginService" inject="WebsiteLoginService";

	public any function init(){
		return this;
	}

	public boolean function match( required string path, required any event ){
		return REFindNoCase( "^\/resource\/[^\/]+(\/[^\/]+){1,2}\.html", arguments.path );
	}

	public void function translate( required string path, required any event ){
		if ( !websiteLoginService.isLoggedIn() ) {
			event.accessDenied( reason="LOGIN_REQUIRED" );
			return;
		}

		var rc = event.getCollection();
		var prc = event.getCollection( private=true );
		var pathParts = REReplace( path, "(^\/?resource\/)|(\.html$)", "", "ALL" ).split( "/" );

		pathParts[ 1 ] = REReplace( pathParts[ 1 ], "-", "_", "ALL" );

		switch ( len ( pathParts ) ) {
			case 2:
				rc.event = "page-types.#pathParts[ 1 ]#_list.#pathParts[ 2 ]#";
				break;

			case 3:
				rc.event = "page-types.#pathParts[ 1 ]#_list.#pathParts[ 3 ]#";
				prc[ _toCamelCase( pathParts[ 1 ] )&"Id" ] = pathParts[ 2 ];
				break;

			default:
				event.notFound();
				break;
		}
	}

	public boolean function reverseMatch( required struct buildArgs, required any event ){
		return REFind( "^\/?resource\/", buildArgs.linkTo?:"" ) == 1;
	}

	public string function build( required struct buildArgs, required any event ){
		return "/#buildArgs.linkTo?:""#.html";
	}

	private string function _toCamelCase( required string name ){
		var nameArr = name.split("[^a-zA-Z0-9]");
        var camelCaseName = nameArr[ 1 ];

        for ( var i=2; i<=len( nameArr ); i++ ) {
        	camelCaseName &= REReplace( nameArr[ i ], "^.", ucase( nameArr[ i ].charAt( 0 ) ) );
        }

        return camelCaseName;
	}
}