component {
	public WarningAlert function init( string message="", string type="info" ){
		setMessage( arguments.message );
		setType   ( arguments.type    );

		return this;
	}

	public boolean function hasMesasge(){
		return len( trim( variables._message ) ) > 0;
	}

	public void function setMessage( required string message ){
		variables._message = arguments.message;
	}

	public string function getMessage(){
		return variables._message;
	}

	public string function getType(){
		return variables._type;
	}

	public void function setType( required string type ){
		variables._type = arguments.type;
	}

	public string function getMessageOnce(){
		var message = getMessage();

		variables._message = "";

		return message;
	}
}