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
	"required_staffing": [RESEARCHER.SPECIALIZATION.ANY],
	# ------------------------------------------

	# ------------------------------------------	
	"currencies": {
		RESOURCE.CURRENCY.MONEY: -10,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.CORE: 0,
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
		"purchase": 500,
	},
	# ------------------------------------------
	
	# --------------------------------------
	#"requires_specialization": RESEARCHER.SPECIALIZATION.ADMINISTRATION,
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
			ABL_P.get_ability(ABL_P.REF.GENERATE_MONEY, 0),
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_STAFF, 1),
			#ABL_P.get_ability(ABL_P.REF.ADDITIONAL_STORE_UNLOCKS, 2),			
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
	"required_staffing": [RESEARCHER.SPECIALIZATION.ADMIN],
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 0,
		"purchase": 0,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 100,
		RESOURCE.CURRENCY.SCIENCE: 50,
		RESOURCE.CURRENCY.MATERIAL: 25,
		RESOURCE.CURRENCY.CORE: 0,
	},
	# ------------------------------------------
	
	# ------------------------------------------	
	"metrics": {
		RESOURCE.METRICS.MORALE: 0,
		RESOURCE.METRICS.SAFETY: 0,
		RESOURCE.METRICS.READINESS: 0
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
			ABL_P.get_ability(ABL_P.REF.OBJECTIVE_ASSIST),
			
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
	"required_staffing": [RESEARCHER.SPECIALIZATION.ADMIN],
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
			#ABL.get_ability(ABL.REF.UNLOCK_FACILITIES),
			ABL.get_ability(ABL.REF.HIRE_RESEARCHER, 1),
			#ABL.get_ability(ABL.REF.PROMOTE_RESEARCHER, 2),
		],	
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.SUPPLY_SECURITY, 0),
			ABL_P.get_ability(ABL_P.REF.SUPPLY_STAFF, 0),
			ABL_P.get_ability(ABL_P.REF.SUPPLY_TECHNICIANS, 0),
			ABL_P.get_ability(ABL_P.REF.SUPPLY_DCLASS, 0)
			
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
	"requires_unlock": false,	
	"containment_properties": [
		SCP.CONTAINMENT_TYPES.PHYSICAL
	],
	"required_staffing": [RESEARCHER.SPECIALIZATION.RESEARCHER, RESEARCHER.SPECIALIZATION.SECURITY],	
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 400,
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

var DARK_MONEY:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.DARK_MONEY,	
	"name": "APPLIED ECONOMIC RECLIMATION DIVISION",
	"shortname": "AERD",
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "A covert unit used to sustain Foundation operations through unofficial financial channels.",
	# ------------------------------------------

	# ------------------------------------------
	"required_staffing": [RESEARCHER.SPECIALIZATION.SECURITY],	
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
			ABL.get_ability(ABL.REF.MONEY_HACK, 0),
		],	
			
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.GENERATE_MONEY),
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
	"required_staffing": [RESEARCHER.SPECIALIZATION.SECURITY],	
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
	"requires_unlock": false,	
	"required_staffing": [RESEARCHER.SPECIALIZATION.ADMIN],	
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
	"required_staffing": [RESEARCHER.SPECIALIZATION.RESEARCHER, RESEARCHER.SPECIALIZATION.RESEARCHER],	
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
	"required_staffing": [RESEARCHER.SPECIALIZATION.SECURITY, RESEARCHER.SPECIALIZATION.SECURITY],	
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
	"required_staffing": [RESEARCHER.SPECIALIZATION.SECURITY],	
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
	"required_staffing": [RESEARCHER.SPECIALIZATION.RESEARCHER],	
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
	"required_staffing": [RESEARCHER.SPECIALIZATION.RESEARCHER],	
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
	"name": "TEST 1",
	"shortname": "ENG.BAY",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",

	# ------------------------------------------
}

var TEST2:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.TEST2,	
	"name": "TEST 2",
	"shortname": "ENG.BAY",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
}

var TEST3:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.TEST3,		
	"name": "TEST 3",
	"shortname": "ENG.BAY",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
	
	# ------------------------------------------
	"own_limit": 1,	
	# ------------------------------------------
}

var TEST4:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.TEST4,		
	"name": "TEST 4",
	"shortname": "ENG.BAY",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
	
	# ------------------------------------------
	"own_limit": 1,	
	# ------------------------------------------
}

var TEST5:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.TEST5,		
	"name": "TEST 5",
	"shortname": "ENG.BAY",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
	
	# ------------------------------------------
	"own_limit": 1,	
	# ------------------------------------------
}


var TEST6:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.TEST6,		
	"name": "TEST 6",
	"shortname": "ENG.BAY",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
	
	# ------------------------------------------
	"own_limit": 1,	
	# ------------------------------------------
}

# -----------------------------------	
var list:Array[Dictionary] = [
	#DEBUG_ROOM,
	# ---------------
	DIRECTORS_OFFICE, HQ, 
	# ---------------
	STANDARD_CONTAINMENT_CELL, 
	# ---------------
	DARK_MONEY,
	PRISONER_BLOCK, HR_DEPARTMENT, OPERATIONS_SUPPORT, SECURITY_DEPARTMENT,
	# ---------------
	WEAPONS_RANGE, ENGINEERING_BAY, ENERGY_STORAGE,
	# TEST1, TEST2, TEST3, TEST4, TEST5, TEST6
]
# -----------------------------------	
