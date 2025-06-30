@tool
extends Node

enum SPECIALIZATION { 
	ANY,
	STAFF,
	DCLASS,
	SECURITY,
}

enum TRAITS {
	# ----------------------------
	AVERAGE,				# shows if if there's something good or bad
	
	ANALYTICAL,			# shows likely odds as a hint
	RESOURCEFUL,			# sometimes adds an additional choice
	
	OPTIMIST,			# Viewable POSITIVE CONSEQUENCES during choices
	PESSIMIST,			# Viewable NEGATIVE CONSEQUENCES during choices
	
	DYSLEXIC,			# Events options are SCRAMBLED
	PARANOID,			# Choices always render as "[PARANOID] they're all out ot get you..."
	# ----------------------------
};


enum MOODS { 
	# -----------
	STABLE,
	
	FRIGHTENED,			# makes SAFETY choices unavailable
	DEPRESSED, 			# makes MORALE choices unavailable
	RELUCTANT,			# makes READINESS choices unavailable
	# -----------
}
