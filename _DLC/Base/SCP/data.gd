extends SubscribeWrapper

var effect_list:Dictionary

#
	#"effect": {
		#"description": "All levels set to 1.",
		##"apply_all": {
			##"level": 0,
			##"metric": [],
			##"currency": [],
			##"currency_blacklist": [],
			##"metric_blacklist": [],
			##"effects": []
		##}
	#}		

# ------------------------------------------------------------------------------
var SCP0:Dictionary = {
	"nickname": "SCP0",
	"img_src": "res://Media/scps/mirror_frame.png",	
	"description": func(_scp_details:Dictionary) -> String:	
		return "%s description." % _scp_details.name,
	"quote": func(_scp_details:Dictionary) -> String: 
		return "Add short quote...",
	"containment_requirements": [],

	"influence": {
		"description": "FACILITIES built here will be influence BY an SCP."
	},

	"effect": {
		"description": ROOM.return_effect(ROOM.EFFECTS.SET_LEVEL_TO_1).description.call(),
		"apply_all": {
			"effects": [ROOM.EFFECTS.SET_LEVEL_TO_1]
		}
	}		
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var SCP1:Dictionary = {
	"nickname": "SCP1",
	"img_src": "res://Media/scps/mirror_frame.png",	
	"description": func(_scp_details:Dictionary) -> String:	
		return "%s description." % _scp_details.name,
	"quote": func(_scp_details:Dictionary) -> String: 
		return "Add short quote...",

	"containment_requirements": [],

	"influence": {
		"description": "FACILITIES built here will be influence BY an SCP."
	},

	"effect": {
		"description": ROOM.return_effect(ROOM.EFFECTS.TELEPORTS).description.call(),
		"apply_all": {
			"effects": [ROOM.EFFECTS.TELEPORTS]
		}
	}		
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var SCP2:Dictionary = {
	"nickname": "SCP2",
	"img_src": "res://Media/scps/mirror_frame.png",	
	"description": func(_scp_details:Dictionary) -> String:	
		return "%s description." % _scp_details.name,
	"quote": func(_scp_details:Dictionary) -> String: 
		return "Add short quote...",

	"containment_requirements": [],

	"influence": {
		"description": "FACILITIES built here will be influence BY an SCP."
	},

	"effect": {
		"description": "Builds a random room if space is available.",
		"apply_all": {
			"effects": [ROOM.EFFECTS.BUILD_RANDOM_ROOM]
		}		
	}		
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var SCP3:Dictionary = {
	"nickname": "SCP3",
	"img_src": "res://Media/scps/mirror_frame.png",	
	"description": func(_scp_details:Dictionary) -> String:	
		return "%s description." % _scp_details.name,
	"quote": func(_scp_details:Dictionary) -> String: 
		return "Add short quote...",

	"containment_requirements": [],

	"influence": {
		"description": "FACILITIES built here will be influence BY an SCP."
	},

	"effect": {
		"description": "Disable MONEY collection.",
		"conditional": CONDITIONALS.TYPE.DISABLE_MONEY_COLLECTION
	}		
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var SCP4:Dictionary = {
	"nickname": "SCP4",
	"img_src": "res://Media/scps/mirror_frame.png",	
	"description": func(_scp_details:Dictionary) -> String:	
		return "%s description." % _scp_details.name,
	"quote": func(_scp_details:Dictionary) -> String: 
		return "Add short quote...",

	"containment_requirements": [],

	"influence": {
		"description": "FACILITIES built here will be influence BY an SCP."
	},

	"effect": {
		"description": "Disable SCIENCE collection.",
		"conditional": CONDITIONALS.TYPE.DISABLE_SCIENCE_COLLECTION
	}		
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var SCP5:Dictionary = {
	"nickname": "SCP5",
	"img_src": "res://Media/scps/mirror_frame.png",	
	"description": func(_scp_details:Dictionary) -> String:	
		return "%s description." % _scp_details.name,
	"quote": func(_scp_details:Dictionary) -> String: 
		return "Add short quote...",

	"containment_requirements": [],

	"influence": {
		"description": "FACILITIES built here will be influence BY an SCP."
	},

	"effect": {
		"description": "Disable MATERIAL collection.",
		"conditional": CONDITIONALS.TYPE.DISABLE_MATERIAL_COLLECTION
	}		
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var SCP6:Dictionary = {
	"nickname": "SCP6",
	"img_src": "res://Media/scps/mirror_frame.png",	
	"description": func(_scp_details:Dictionary) -> String:	
		return "%s description." % _scp_details.name,
	"quote": func(_scp_details:Dictionary) -> String: 
		return "Add short quote...",

	"containment_requirements": [],

	"influence": {
		"description": "FACILITIES built here will be influence BY an SCP."
	},

	"effect": {
		"description": "Disable CORE collection.",
		"conditional": CONDITIONALS.TYPE.DISABLE_CORE_COLLECTION
	}		
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var SCP7:Dictionary = {
	"nickname": "SCP7",
	"img_src": "res://Media/scps/mirror_frame.png",	
	"description": func(_scp_details:Dictionary) -> String:	
		return "%s description." % _scp_details.name,
	"quote": func(_scp_details:Dictionary) -> String: 
		return "Add short quote...",

	"containment_requirements": [],

	"influence": {
		"description": "FACILITIES built here will be influence BY an SCP."
	},

	"effect": {
		"description": "Influence range is set to 2.",
		"conditional": CONDITIONALS.TYPE.INFLUENCE_RANGE_IS_TWO,
	}		
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var SCP8:Dictionary = {
	"nickname": "SCP8",
	"img_src": "res://Media/scps/mirror_frame.png",	
	"description": func(_scp_details:Dictionary) -> String:	
		return "%s description." % _scp_details.name,
	"quote": func(_scp_details:Dictionary) -> String: 
		return "Add short quote...",

	"containment_requirements": [],

	"influence": {
		"description": "FACILITIES built here will be influence BY an SCP."
	},

	"effect": {
		"description": "MORALE always set to 0.",
		"conditional": CONDITIONALS.TYPE.SET_MORALE_TO_ZERO,
	}		
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var SCP9:Dictionary = {
	"nickname": "SCP9",
	"img_src": "res://Media/scps/mirror_frame.png",	
	"description": func(_scp_details:Dictionary) -> String:	
		return "%s description." % _scp_details.name,
	"quote": func(_scp_details:Dictionary) -> String: 
		return "Add short quote...",

	"containment_requirements": [],

	"influence": {
		"description": "FACILITIES built here will be influence BY an SCP."
	},

	"effect": {
		"description": "SAFETY always set to 0.",
		"conditional": CONDITIONALS.TYPE.SET_SAFETY_TO_ZERO,
	}
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var SCP10:Dictionary = {
	"nickname": "SCP10",
	"img_src": "res://Media/scps/mirror_frame.png",	
	"description": func(_scp_details:Dictionary) -> String:	
		return "%s description." % _scp_details.name,
	"quote": func(_scp_details:Dictionary) -> String: 
		return "Add short quote...",

	"containment_requirements": [],

	"influence": {
		"description": "FACILITIES built here will be influence BY an SCP."
	},

	"effect": {
		"description": "READINESS always set to 0.",
		"conditional": CONDITIONALS.TYPE.SET_READINESS_TO_ZERO,
	}
}
# ------------------------------------------------------------------------------

# -----------------------------------------------------------
var list:Array[Dictionary] = [
	SCP0, SCP1, SCP2, SCP3, SCP4, SCP5, SCP6, SCP7, SCP8, SCP9, SCP10,
	#SCP10, SCP11, SCP12, SCP13, SCP14, SCP15, SCP16, SCP17, SCP18, SCP19,
]
# -----------------------------------------------------------
