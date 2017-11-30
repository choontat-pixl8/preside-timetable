component singleton="true" {
	public function init(){
		thread action="terminate" name="KeyGenerator"{};

		var valuesArray = [];

		for ( var i=chr( 'a' ); i <=chr( 'z' ); i++ ) {
			valuesArray.append( asc( i ) );
		}

		for ( var i=chr( 'A' ); i <=chr( 'A' ); i++ ) {
			valuesArray.append( asc( i ) );
		}

		for ( var i=chr( '0' ); i <=chr( '9' ); i++ ) {
			valuesArray.append( asc( i ) );
		}

		_setValues( valuesArray );

		variables._currentIndex = 1;

		_start();
	}

	public string function getValue(){
		_nextValue();
		return _getValues()[ _getCurrentIndex() ];
	}

	public string function getValues( required numeric length ){
		if ( length <= 0 ){
			return "";
		}

		var values = "";

		for ( var i = 0; i < length; i++ ) {
			values &= getValue();
		}

		return values;
	}

	private void function _setValues( required array valuesArray ){
		variables._valuesArray = valuesArray;
	}

	private array function _getValues(){
		return variables._valuesArray;
	}

	private void function _setCurrentIndex( required numeric index ){
		if ( arguments.index<=0 ){
			arguments.index = 1;
		}

		variables._currentIndex = arguments.index;
	}

	private numeric function _getCurrentIndex(){
		return variables._currentIndex;
	}

	private numeric function _getNumberOfValues(){
		return ( variables._valuesArray?:[] ).length();
	}

	private void function _start(){
		thread action="run" name="KeyGenerator" {
			while ( true ) {
				_nextValue();
			}
		};
	}

	private void function _nextValue(){
		var currentIndex = _getCurrentIndex();

		if ( currentIndex >= _getNumberOfValues() ){
			currentIndex = 1;
		} else {
			currentIndex++;
		}

		_setCurrentIndex( currentIndex );

		sleep( 50 );
	}
}