extends Node

var DEBUG_ROOM:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.DEBUG_ROOM,
	"name": "Debug Room",
	"shortname": "Debug",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Debug room.",
	# ------------------------------------------

	# ------------------------------------------
	"can_contain": false,
	"can_destroy": true,
	"can_assign_researchers": true,
	"requires_unlock": false,	
	# ------------------------------------------

	# ------------------------------------------	
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 5,
		RESOURCE.CURRENCY.MATERIAL: 10,
		RESOURCE.CURRENCY.SCIENCE: 20,
		RESOURCE.CURRENCY.CORE: 1,
	},
	"metrics": {
		RESOURCE.METRICS.MORALE: 1,
		RESOURCE.METRICS.SAFETY: 1,
		RESOURCE.METRICS.READINESS: 1
	},	
	# ------------------------------------------
	
	# ------------------------------------------
	"costs": {
		"unlock": 0,
		"purchase": 0,
	},
	# ------------------------------------------
	
	# --------------------------------------
	"requires_specialization": RESEARCHER.SPECIALIZATION.ADMINISTRATION,
	# ------------------------------------------	
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			#ABL.get_ability(ABL.REF.HAPPY_HOUR, 0),	
			#ABL.get_ability(ABL.REF.UNHAPPY_HOUR, 0),		
			ABL.get_ability(ABL.REF.UPGRADE_FACILITY),
			ABL.get_ability(ABL.REF.SET_WARNING_MODE),
			ABL.get_ability(ABL.REF.SET_DANGER_MODE, 1),
			
			#ABL.get_ability(ABL.REF.UNLOCK_FACILITIES, 0),
			#ABL.get_ability(ABL.REF.HIRE_RESEARCHER, 0),
			#ABL.get_ability(ABL.REF.PROMOTE_RESEARCHER, 0),
			#ABL.get_ability(ABL.REF.CLONE_RESEARCHER, 0),
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
			ABL_P.get_ability(ABL_P.REF.SUPPLY_SECURITY, 0),
			ABL_P.get_ability(ABL_P.REF.SUPPLY_STAFF, 1),
			ABL_P.get_ability(ABL_P.REF.ADDITIONAL_STORE_UNLOCKS, 2),			
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_TECHNICIANS, 2),
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_DCLASS),
			#ABL_P.get_ability(ABL_P.REF.FIREARM_TRAINING, 1),
			#ABL_P.get_ability(ABL_P.REF.HEAVY_WEAPONS_TRAINING, 2),
			#ABL_P.get_ability(ABL_P.REF.TECH_SUPPORT),
			#ABL_P.get_ability(ABL_P.REF.MEMETIC_SHILEDING),
		],	
	# ------------------------------------------		
}

var DIRECTORS_OFFICE:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.DIRECTORS_OFFICE,	
	"name": "DIRECTORS OFFICE",
	"shortname": "D.OFFICE",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "The site directors office.",
	# ------------------------------------------

	# ------------------------------------------
	"can_contain": false,
	"can_destroy": false,
	"can_assign_researchers": false,
	"requires_unlock": false,	
	"own_limit": 1,	
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 0,
		"purchase": 0,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			#ABL.get_ability(ABL.REF.EVAL_SCP, 0),
			ABL.get_ability(ABL.REF.TRIGGER_ONSITE_NUKE, 0)
		],	
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.PREDICTIVE_TIMELINE),
			ABL_P.get_ability(ABL_P.REF.ENABLE_OBJECTIVES),
			
		],	
	# ------------------------------------------		
}

var HQ:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.HQ,		
	"name": "HEADQUARTERS",
	"shortname": "HQ",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Base headquarters.",
		
	# ------------------------------------------
	"can_contain": false,
	"can_destroy": true,
	"can_assign_researchers": true,
	"requires_unlock": false,	
	"own_limit": 1,	
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 1,
	},
	# ------------------------------------------

	# --------------------------------------
	"requires_specialization": RESEARCHER.SPECIALIZATION.ADMINISTRATION,
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.UNLOCK_FACILITIES),
			ABL.get_ability(ABL.REF.HIRE_RESEARCHER, 1),
			ABL.get_ability(ABL.REF.PROMOTE_RESEARCHER, 2),
		],	
	# ------------------------------------------
}

var STANDARD_CONTAINMENT_CELL:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.STANDARD_CONTAINMENT_CELL,		
	"name": "STANDARD CONTAINMENT",
	"shortname": "S.CONTAINMENT",
	"categories": [ROOM.CATEGORY.CONTAINMENT],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Containment cell used to house anamolous objects.",
		
	# ------------------------------------------
	"can_contain": true,
	"can_destroy": true,
	"can_assign_researchers": true,
	"requires_unlock": false,	
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
	},
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [

		],	
	# ------------------------------------------	
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.GENERATE_RESEARCH_FROM_SCP, 0),
			ABL_P.get_ability(ABL_P.REF.GENERATE_MONEY_FROM_SCP, 1)
		],	
	# ------------------------------------------			
}

var PRISONER_BLOCK:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.PRISONER_BLOCK,	
	"name": "PRISONER BLOCK",
	"shortname": "P.BLOCK",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "A prisoner block designed specifically to house D-Class personel.",
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
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
	"ref": ROOM.REF.HR_DEPARTMENT,
	"name": "HR DEPARTMENT",
	"shortname": "HR",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Supplies staff.",
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
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
	"ref": ROOM.REF.OPERATIONS_SUPPORT,
	"name": "OPERATIONS_SUPPORT",
	"shortname": "OP.SUPPORT",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Supplies technicians.",
	"unlock_level": 1,	
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
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
	"ref": ROOM.REF.SECURITY_DEPARTMENT,
	"name": "SECURITY DEPARTMENT",
	"shortname": "SEC.DPT",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Supplies security.",
	"unlock_level": 1,		
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
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
	"ref": ROOM.REF.WEAPONS_RANGE,
	"name": "WEAPONS RANGE",
	"shortname": "W.RANGE",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Increases security and provides training.",
	"unlock_level": 1,		
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"required_personnel": [
		RESOURCE.PERSONNEL.TECHNICIANS
	],
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.FIREARM_TRAINING),
			ABL_P.get_ability(ABL_P.REF.HEAVY_WEAPONS_TRAINING, 1)
		],	
	# ------------------------------------------	
}

var ENGINEERING_BAY:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.ENGINEERING_BAY,
	"name": "ENGINEERING BAY",
	"shortname": "ENG.BAY",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
	
	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"required_personnel": [
		RESOURCE.PERSONNEL.TECHNICIANS
	],
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.TECH_SUPPORT),
		],	
	# ------------------------------------------	
}


var ENERGY_STORAGE:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.ENERGY_STORAGE,
	"name": "ENERGY STORAGE",
	"shortname": "E.STORAGE",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
	
	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"required_personnel": [
		RESOURCE.PERSONNEL.TECHNICIANS
	],
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			
		],	
	# ------------------------------------------	
}


var TEST1:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.TEST1,
	"name": "TEST (STANDARD)",
	"shortname": "ENG.BAY",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
}

var TEST2:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.TEST2,	
	"name": "TEST (CONTAINMENT)",
	"shortname": "ENG.BAY",
	"categories": [ROOM.CATEGORY.CONTAINMENT],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
}

var TEST3:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.TEST3,		
	"name": "TEST (SPECIAL)",
	"shortname": "ENG.BAY",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
	
	# ------------------------------------------
	"own_limit": 1,	
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
	WEAPONS_RANGE, ENGINEERING_BAY, ENERGY_STORAGE,
	TEST1, TEST2, TEST3,
	TEST1, TEST2, TEST3,
	TEST1, TEST2, TEST3
]
# -----------------------------------	
