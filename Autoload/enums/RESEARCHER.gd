@tool
extends Node

#enum TRAIT_TYPE {
	#POSITIVE, NEGATIVE, NEUTRAL
#}

enum TRAITS {
	# -----------
	NORMAL,
	ACROPHOBIA,			# Fear of heights
	THALASSOPHOBIA,		# Fear of deep bodies of water
	NYCTOPHOBIA,		# Fear of the dark
	ATYCHIPHOBIA,		# Fear of failure
	ATHAZAGORAPHOBIA, # Fear of being forgotten or ignored
	# -----------
}

enum MOODS { 
	# -----------
	NORMAL,
	WEIRD,
	DEPRESSED, 
	PARA
	#WEIRD,
	#UNEASY,
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
