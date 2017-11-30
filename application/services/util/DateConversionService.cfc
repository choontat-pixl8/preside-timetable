component singleton="true"{
	public DateConversionService function init(){
		return this;
	}

	public date function getFirstDayOfWeek( required date givenDate ){
		var firstDayOfWeek = givenDate;

		while ( firstDayOfWeek.dayOfWeek() != 1 ){
			firstDayOfWeek = firstDayOfWeek.add( "d", -1 );
		}

		return firstDayOfWeek;
	}

	public date function getLastDayOfWeek( required date givenDate ){
		var lastDayOfWeek = givenDate;

		while ( lastDayOfWeek.dayOfWeek() != 7 ){
			lastDayOfWeek = lastDayOfWeek.add( "d", 1 );
		}

		return lastDayOfWeek;
	}

	public numeric function getDateDifferenceInMinutes( required date a, required date b ){
		var dateDifferenceInMinutes = dateDiff( "n", a, b );

		if ( dateDifferenceInMinutes < 0 ) {
			dateDifferenceInMinutes *= -1;
		}

		return dateDifferenceInMinutes;
	}
}