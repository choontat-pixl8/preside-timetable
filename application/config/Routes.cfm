<cfscript>
	addRouteHandler( getModel( dsl="delayedInjector:resourceDetailRouteHandler" ) );
	addRouteHandler( getModel( dsl="delayedInjector:ruleDetailRouteHandler"     ) );
</cfscript>