extends Node

var DEBUG_ROOM:Dictionary = {
	# ------------------------------------------
	"name": "DEBUG ROOM",
	"shortname": "DEBUG",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Debug room.",
	# ------------------------------------------

	# ------------------------------------------
	"can_contain": true,
	"can_destroy": true,
	"can_assign_researchers": true,
	"requires_unlock": false,	
	"own_limit": 99,
	"build_time": 1,
	# ------------------------------------------
	
	# ------------------------------------------
	"costs": {
		"unlock": 0,
		"purchase": 0,
		"operating": 10
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.TRIGGER_ONSITE_NUKE, 0),
			ABL.get_ability(ABL.REF.CONTAIN_SCP, 0),
			ABL.get_ability(ABL.REF.UNLOCK_FACILITIES, 0),
			ABL.get_ability(ABL.REF.HIRE_RESEARCHER, 0),
			ABL.get_ability(ABL.REF.PROMOTE_RESEARCHER, 0),
			#ABL.get_ability(ABL.REF.ADD_TRAIT, 0),
			#ABL.get_ability(ABL.REF.REMOVE_TRAIT, 0),
			#
			#ABL.get_ability(ABL.REF.MONEY_HACK, 0),
			#ABL.get_ability(ABL.REF.SCIENCE_HACK, 0),
			#ABL.get_ability(ABL.REF.CONVERT_TO_SCIENCE, 0),
			#ABL.get_ability(ABL.REF.CONVERT_TO_MONEY, 0),
		],	
	# ------------------------------------------

	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.UPGRADE_ABL_LVL),
			ABL_P.get_ability(ABL_P.REF.SUPPLY_SECURITY, 1),
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_STAFF),
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_TECHNICIANS),
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_DCLASS),
			ABL_P.get_ability(ABL_P.REF.FIREARM_TRAINING, 1),
			ABL_P.get_ability(ABL_P.REF.HEAVY_WEAPONS_TRAINING, 2),
			#ABL_P.get_ability(ABL_P.REF.TECH_SUPPORT),
			#ABL_P.get_ability(ABL_P.REF.MEMETIC_SHILEDING),
		],	
	# ------------------------------------------		
	
	# ------------------------------------------
	"metrics": {
		RESOURCE.BASE_METRICS.MORALE: 0,
		RESOURCE.BASE_METRICS.SAFETY: 0,
		RESOURCE.BASE_METRICS.READINESS: 0,
	},	
	# ------------------------------------------
}

var DIRECTORS_OFFICE:Dictionary = {
	# ------------------------------------------
	"type_ref": ROOM.TYPE.DIRECTORS_OFFICE,
	"name": "DIRECTORS OFFICE",
	"shortname": "D.OFFICE",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "The site directors office.",
	# ------------------------------------------

	# ------------------------------------------
	"can_contain": true,
	"can_destroy": false,
	"can_assign_researchers": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------
	
	# ------------------------------------------
	"costs": {
		"unlock": 0,
		"purchase": 0,
		"operating": 10
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.TRIGGER_ONSITE_NUKE, 0)
		],	
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.SUPPLY_DCLASS),
		],	
	# ------------------------------------------		
	
	# ------------------------------------------
	"metrics": {
		RESOURCE.BASE_METRICS.MORALE: 1,
		RESOURCE.BASE_METRICS.SAFETY: 1,
		RESOURCE.BASE_METRICS.READINESS: 1,
	},	
	# ------------------------------------------
}

var HQ:Dictionary = {
	# ------------------------------------------
	"type_ref": ROOM.TYPE.HQ,
	"name": "HEADQUARTERS",
	"shortname": "HQ",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Base headquarters.",
		
	# ------------------------------------------
	"can_contain": false,
	"can_destroy": true,
	"can_assign_researchers": true,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
		"operating": 10
	},
	# ------------------------------------------

	# --------------------------------------
	"pairs_with": [
		RESEARCHER.SPECIALIZATION.ADMINISTRATION
	],
	# ------------------------------------------
	
	# ------------------------------------------
	"metrics": {
		RESOURCE.BASE_METRICS.MORALE: 1,
		RESOURCE.BASE_METRICS.SAFETY: 1,
		RESOURCE.BASE_METRICS.READINESS: 1,
	},
	# --------------------------------------	
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.UNLOCK_FACILITIES),
			#ABL.get_ability(ABL.REF.HIRE_RESEARCHER),
			#ABL.get_ability(ABL.REF.PROMOTE_RESEARCHER, 1),
		],	
	# ------------------------------------------
}

var STANDARD_CONTAINMENT_CELL:Dictionary = {
	# ------------------------------------------
	"type_ref": ROOM.TYPE.CONTAINMENT_CELL,
	"name": "STANDARD CONTAINMENT CELL",
	"shortname": "S.CONTAINMENT",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Containment cell used to house anamolous objects.  Can be upgraded with additional security measures.",
		
	# ------------------------------------------
	"can_contain": true,
	"requires_unlock": false,	
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
		"operating": 10
	},
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.CONTAIN_SCP),
		],	
	# ------------------------------------------	
}

var PRISONER_BLOCK:Dictionary = {
	# ------------------------------------------
	"name": "PRISONER BLOCK",
	"shortname": "P.BLOCK",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "A prisoner block designed specifically to house D-Class personel.",
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
		"operating": 10
	},
	# ------------------------------------------
		
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.SUPPLY_DCLASS),
		],	
	# ------------------------------------------	
}

var HR_DEPARTMENT:Dictionary = {
	# ------------------------------------------
	"type_ref": ROOM.TYPE.HR_DEPARTMENT,
	"name": "HR DEPARTMENT",
	"shortname": "HR",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Supplies staff.",
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
		"operating": 10
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.SUPPLY_STAFF),
		],	
	# ------------------------------------------	
}

var OPERATIONS_SUPPORT:Dictionary = {
	# ------------------------------------------
	"name": "OPERATIONS_SUPPORT",
	"shortname": "OP.SUPPORT",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Supplies technicians.",
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
		"operating": 10
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.SUPPLY_TECHNICIANS),
		],	
	# ------------------------------------------	
}

var SECURITY_DEPARTMENT:Dictionary = {
	# ------------------------------------------
	"name": "SECURITY DEPARTMENT",
	"shortname": "SEC.DPT",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Supplies security.",
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
		"operating": 10
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.SUPPLY_SECURITY),
		],	
	# ------------------------------------------	
}

var WEAPONS_RANGE:Dictionary = {
	# ------------------------------------------
	"name": "WEAPONS RANGE",
	"shortname": "W.RANGE",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Increases security and provides training.",
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
		"operating": 10
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"resource_requirements": [
		RESOURCE.TYPE.SECURITY
	],
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.FIREARM_TRAINING),
			ABL_P.get_ability(ABL_P.REF.HEAVY_WEAPONS_TRAINING)
		],	
	# ------------------------------------------	
	
	# ------------------------------------------
	"metrics": {
		RESOURCE.BASE_METRICS.SAFETY: 1,
	},	
	# ------------------------------------------	
}

var ENGINEERING_BAY:Dictionary = {
	# ------------------------------------------
	"name": "ENGINEERING BAY",
	"shortname": "ENG.BAY",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
		"operating": 10
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"resource_requirements": [
		RESOURCE.TYPE.TECHNICIANS
	],
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.TECH_SUPPORT),
		],	
	# ------------------------------------------	
	
	# ------------------------------------------
	"metrics": {
		RESOURCE.BASE_METRICS.READINESS: 1,
	},	
	# ------------------------------------------	
}


# -----------------------------------	
var list:Array[Dictionary] = [
	DIRECTORS_OFFICE, HQ, DEBUG_ROOM,
	# ---------------
	STANDARD_CONTAINMENT_CELL, 
	# ---------------
	PRISONER_BLOCK, HR_DEPARTMENT, OPERATIONS_SUPPORT, SECURITY_DEPARTMENT,
	# ---------------
	WEAPONS_RANGE, ENGINEERING_BAY, 
]
# -----------------------------------	
