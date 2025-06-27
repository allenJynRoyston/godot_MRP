@tool
extends Node

#enum TRAIT_TYPE {
	#POSITIVE, NEGATIVE, NEUTRAL
#}

enum TRAITS {
	# ----------------------------
	AVERAGE,				# Average in every way
	NARCISSIST,			# Fear of mirrors
	INTROVERT,			# Social battery lasts 3 minutes
	EXTROVERT,			# Needs an audience to think
	PARANOID,			# Thinks the toaster is spying
	OPTIMIST,			# Sees rain as sky hydration
	PESSIMIST,			# Expects rain indoors
	WORKAHOLIC,			# Vacations cause anxiety
	LAZY,				# Would teleport to the fridge
	SARCASTIC,			# Totally takes everything seriously
	# ----------------------------
};


enum MOODS { 
	# -----------
	NORMAL,
	WEIRD,
	DEPRESSED, 
	UNEASY,	
	#WEIRD,
	#ANXIOUS,
	# -----------
}

enum SPECIALIZATION { 
	ANY,
	ADMINISTRATION,
	# ---------
	ENGINEERING,
	COMPUTER_SCIENCE,
	#MATHEMATICS,
	#PHYSICS,
	#CHEMISTRY,
	#BIOLOGIST,

  	# ---------
	#PSYCHOLOGY,
	#MEDICINE,
	#PHARMACOLOGY,
	#NEUROSCIENCE,
#
   ## ---------
	#SOCIOLOGY,
	#ANTHROPOLOGY,
	#PHILOSOPHY,
	#ADMINISTRATION,
#
	## ---------
	#PARAZOOLOGIST,
	#THAUMATURGIC_ANALYST,
	#XENOBIOLOGIST,
}
