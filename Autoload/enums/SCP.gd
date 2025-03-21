extends Node

enum TYPE { 
	SCP_001, 
	SCP_002
}

enum EVENT_TYPE {
	AFTER_CONTAINMENT,
	DURING_TRANSFER,
	AFTER_TRANSFER,
	RANDOM_EVENTS,
	BEFORE_DESTROY,
	AFTER_DESTROY,
	# -----------
	START_TESTING,
	DURING_TESTING,
	# -----------
	ON_COMPLETE,
	DAY_SPECIFIC
}

enum UNLOCKABLE {
	ONE, TWO, THREE, FOUR, FIVE
}

enum TESTING {
	ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, ELEVEN, TWELVE, THIRTEEN, FOURTEEN, FIVETEEN
}
