extends Node

var DEBUG_ROOM:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.DEBUG_ROOM,
	"name": "DEBUG_ROOM",
	"shortname": "DEBUG_ROOM",
	"categories": [ROOM.CATEGORY.UTILITY],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Debug room.",
	"requires_unlock": false,	
	# ------------------------------------------

	# ------------------------------------------
	"can_contain": false,
	"can_assign_researchers": true,
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],
	# ------------------------------------------

	# ------------------------------------------	
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 1,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.SCIENCE: 1,
		RESOURCE.CURRENCY.CORE: 0,
	},
	"metrics": {
		RESOURCE.METRICS.MORALE: 1,
		RESOURCE.METRICS.SAFETY: 0,
		RESOURCE.METRICS.READINESS: 1
	},	
	"environmental":{
		"temp": 1,
		"pollution": 1
	},	
	# ------------------------------------------
	
	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# --------------------------------------
	#"requires_specialization": RESEARCHER.SPECIALIZATION.ADMINISTRATION,
	# ------------------------------------------	
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.HAPPY_HOUR, 0),
			ABL.get_ability(ABL.REF.UNHAPPY_HOUR, 1),
			#ABL.get_ability(ABL.REF.UPGRADE_FACILITY),
			#ABL.get_ability(ABL.REF.SET_WARNING_MODE),
			#ABL.get_ability(ABL.REF.SET_DANGER_MODE, 1),
			
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
			ABL_P.get_ability(ABL_P.REF.GENERATE_CORE_LVL_1, 0),
			ABL_P.get_ability(ABL_P.REF.GENERATE_SCIENCE_LVL_1, 1),
			#ABL_P.get_ability(ABL_P.REF.GENERATE_MATERIAL_LVL_1, 0),
			#ABL_P.get_ability(ABL_P.REF.GENERATE_CORE_LVL_1, 0),
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

#region SPECIALS
# ------------------------------------------------------------------------------ SPECIALS
var DIRECTORS_OFFICE:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.DIRECTORS_OFFICE,	
	"name": "DIRECTORS OFFICE",
	"shortname": "D.OFFICE",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "The site directors office.",
	"event_trigger": {
		"ref": EVT.TYPE.DIRECTORS_OFFICE,
		"day": 2
	},
	# ------------------------------------------

	# ------------------------------------------
	"own_limit": 1,	
	"can_destroy": false,
	"requires_unlock": false,		
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.ADMIN
	],
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 1,
		RESOURCE.CURRENCY.SCIENCE: 1,
		RESOURCE.CURRENCY.MATERIAL: 1,
		RESOURCE.CURRENCY.CORE: 1,
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
			ABL.get_ability(ABL.REF.TRIGGER_ONSITE_NUKE, 0)
		],	
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [

			
		],	
	# ------------------------------------------		
}

var HQ:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.HQ,		
	"name": "HEADQUARTERS",
	"shortname": "HQ",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Base headquarters.",
		
	# ------------------------------------------
	"own_limit": 1,	
	"can_destroy": false,
	"requires_unlock": false,		
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.ADMIN
	],
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------	
	"metrics": {
		RESOURCE.METRICS.MORALE: 1,
		RESOURCE.METRICS.SAFETY: 1,
		RESOURCE.METRICS.READINESS: 1
	},	
	# ------------------------------------------		
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.UNLOCK_FACILITIES),
			#ABL.get_ability(ABL.REF.HIRE_RESEARCHERS, 1),
			#ABL.get_ability(ABL.REF.PROMOTE_RESEARCHER, 2),
		],	
	# ------------------------------------------
	
	# ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_SECURITY, 0),
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_STAFF, 0),
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_TECHNICIANS, 0),
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_DCLASS, 0)
			#
		#],	
	# ------------------------------------------				
}

var HR_DEPARTMENT:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.HR_DEPARTMENT,
	"name": "HR DEPARTMENT",
	"shortname": "HR",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "A one-stop shop for recruitment.",
	# ------------------------------------------

	# ------------------------------------------
	"own_limit": 1,	
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.ADMIN
	],
	# ------------------------------------------
	
	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.HIRE_RESEARCHERS),
			ABL.get_ability(ABL.REF.HIRE_ADMIN),
			ABL.get_ability(ABL.REF.HIRE_SECURITY),
			ABL.get_ability(ABL.REF.HIRE_DCLASS),
		],		
}

var OPERATIONS_SUPPORT:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.OPERATIONS_SUPPORT,
	"name": "OPERATIONS_SUPPORT",
	"shortname": "OP.SUPPORT",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Can recruit additional specilized personnel.",
	# ------------------------------------------

	# ------------------------------------------
	"own_limit": 1,	
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.SECURITY, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [

		],	
	# ------------------------------------------	
}

var GENERATOR_SUBSTATION:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.GENERATOR_SUBSTATION,
	"name": "GENERATOR_SUBSTATION",
	"shortname": "GEN.SUBSTAITON",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Can make adjustments to the power generator.",
	# ------------------------------------------

	# ------------------------------------------
	"own_limit": 1,	
	"requires_unlock": false,
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.SECURITY, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [

		],	
	# ------------------------------------------	
}

var	PROBABILITY_ROOM:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.PROBABILITY_ROOM,
	"name": "PROBABILITY_ROOM",
	"shortname": "PROBABILITY_ROOM",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "PROBABILITY_ROOM description",
	# ------------------------------------------

	# ------------------------------------------
	"own_limit": 1,	
	"requires_unlock": false,
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.SECURITY, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [

		],	
	# ------------------------------------------	
}

var CHRONO_ROOM:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.CHRONO_ROOM,
	"name": "CHRONO_ROOM",
	"shortname": "CHRONO_ROOM",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "CHRONO_ROOM description.",
	# ------------------------------------------

	# ------------------------------------------
	"own_limit": 1,	
	"requires_unlock": false,
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.SECURITY, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [

		],	
	# ------------------------------------------	
}

var NUCLEAR_FAILSAFE:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.GENERATOR_SUBSTATION,
	"name": "NUCLEAR_FAILSAFE",
	"shortname": "NUKEFAILSAFE",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "NUCLEAR_FAILSAFE description",
	# ------------------------------------------

	# ------------------------------------------
	"own_limit": 1,	
	"requires_unlock": false,
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.ADMIN
	],
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
			ABL.get_ability(ABL.REF.CANCEL_NUCLEAR_DETONATION)
		],	
	# ------------------------------------------	
}
# ------------------------------------------------------------------------------ 
#endregion

#region RECRUITMENT
# ------------------------------------------------------------------------------ RECRUITMENT
var PRISONER_BLOCK:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.PRISONER_BLOCK,	
	"name": "PRISONER BLOCK",
	"shortname": "P.BLOCK",
	"categories": [ROOM.CATEGORY.RECRUITMENT],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "A prisoner block designed specifically to house D-Class personel.",
	# ------------------------------------------

	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.SECURITY, 
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	# ------------------------------------------
	
	# ------------------------------------------
	"personnel_capacity": {
		RESEARCHER.SPECIALIZATION.DCLASS: 5, 
	},	
	# ------------------------------------------	

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.HIRE_DCLASS),
		],		
	# ------------------------------------------
}

var ADMIN_OFFICE:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.ADMIN_OFFICE,	
	"name": "ADMIN OFFICE",
	"shortname": "A.OFFICE",
	"categories": [ROOM.CATEGORY.RECRUITMENT],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "A prisoner block designed specifically to house D-Class personel.",
	# ------------------------------------------

	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.ADMIN, 
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.HIRE_ADMIN),
		],		
	# ------------------------------------------
}

var SECURITY_DEPARTMENT:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.SECURITY_DEPARTMENT,
	"name": "SECURITY DEPARTMENT",
	"shortname": "SEC.DPT",
	"categories": [ROOM.CATEGORY.RECRUITMENT],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Supplies security.",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.SECURITY, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],	
	# ------------------------------------------	

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.HIRE_SECURITY),
		],		
	# ------------------------------------------
}

var ACADEMIC_OUTREACH:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.ACADEMIC_OUTREACH,
	"name": "ACADEMIC OUTREACH",
	"shortname": "ACA OUTREACH",
	"categories": [ROOM.CATEGORY.RECRUITMENT],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Supplies security.",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],	
	# ------------------------------------------	

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.HIRE_RESEARCHERS),
		],		
	# ------------------------------------------
}

var MTF_BARRICKS:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.MTF_BARRICKS,
	"name": "MTF_BARRICKS",
	"shortname": "MTF_BARRICKS",
	"categories": [ROOM.CATEGORY.RECRUITMENT],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Trains and houses specialized Mobile Taskforce Teams (MTF).",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.ADMIN,		
		RESEARCHER.SPECIALIZATION.SECURITY, 
		RESEARCHER.SPECIALIZATION.SECURITY, 
	],	
	# ------------------------------------------	

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.MTF_A),
			ABL_P.get_ability(ABL_P.REF.MTF_B),			
			ABL_P.get_ability(ABL_P.REF.MTF_C),			
			ABL_P.get_ability(ABL_P.REF.MTF_D),			
		],		
	# ------------------------------------------
}


var MINIERAL_MINING:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.MINIERAL_MINING,
	"name": "MINERAL MINING",
	"shortname": "MIN.MINING",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Mines minerals which can be converted to other resources, can only be placed on the bottom floor.",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],	
	# ------------------------------------------	

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			
		],		
	# ------------------------------------------
}

var GEOTHERMAL_POWER:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.GEOTHERMAL_POWER,
	"name": "GEOTHERMAL POWER",
	"shortname": "GEO.POWER",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Mines minerals which can be converted to other resources, can only be placed on the bottom floor.",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],	
	# ------------------------------------------	

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			
		],		
	# ------------------------------------------
}
# ------------------------------------------------------------------------------ 
#endregion

#region CONTAINMENT
# ------------------------------------------------------------------------------ CONTAINMENTS
var STANDARD_CONTAINMENT_CELL:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.STANDARD_CONTAINMENT_CELL,		
	"name": "STANDARD CONTAINMENT",
	"shortname": "S.CONTAINMENT",
	"categories": [ROOM.CATEGORY.CONTAINMENT],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Containment cell used to house anamolous objects.",
		
	# ------------------------------------------
	"requires_unlock": false,
	"can_contain": true,
	"can_destroy": false,
	"containment_properties": [
		SCP.CONTAINMENT_TYPES.PHYSICAL
	],
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.SECURITY
	],	
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
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
# ------------------------------------------------------------------------------ 
#endregion

#region RESOURCES
# ------------------------------------------------------------------------------ RESOURCES
var MONEY_GEN_1:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.MONEY_GEN_1,	
	"name": "ECONOMIC RECLIMATION DIVISION",
	"shortname": "ECO DIV",
	"categories": [ROOM.CATEGORY.RESOURCES],	
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "A covert unit used to sustain Foundation operations through unofficial financial channels.",
	# ------------------------------------------

	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],	
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 1,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.CORE: 0,
	},	
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.INSTANT_MONEY_LVL_1),
			ABL.get_ability(ABL.REF.INSTANT_SCIENCE_LVL_1, 1),
		],	
			
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.GENERATE_MONEY_LVL_1, 0),
		],	
	# ------------------------------------------		
}

var MONEY_GEN_2:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.MONEY_GEN_2,	
	"name": "MONEY_GEN_2",
	"shortname": "MONEY_GEN_2",
	"categories": [ROOM.CATEGORY.RESOURCES],	
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "+50 MONEY when placed adjacent to other MONEY_GEN_2.",
	# ------------------------------------------

	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],	
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 2,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.CORE: 0,
	},		
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.INSTANT_MONEY_LVL_1, 1),
		],	
			
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.GENERATE_MONEY_LVL_1),
		],	
	# ------------------------------------------		
}

var RESEARCH_GEN_1:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.RESEARCH_GEN_1,	
	"name": "RESEARCH LAB",
	"shortname": "R.LAB",
	"categories": [ROOM.CATEGORY.RESOURCES],	
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "A covert unit used to sustain Foundation operations through unofficial financial channels.",
	# ------------------------------------------

	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.SCIENCE: 1,
		RESOURCE.CURRENCY.CORE: 0,
	},	
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.INSTANT_SCIENCE_LVL_1, 1),
		],	
			
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.GENERATE_SCIENCE_LVL_1),
		],	
	# ------------------------------------------		
}

var RESEARCH_GEN_2:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.RESEARCH_GEN_2,	
	"name": "RESEARCH_GEN_2",
	"shortname": "RESEARCH_GEN_2",
	"categories": [ROOM.CATEGORY.RESOURCES],	
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "+25 RESEARCH when placed adjacent to other RESEARCH_GEN_2.",
	# ------------------------------------------

	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],	
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.SCIENCE: 1,
		RESOURCE.CURRENCY.CORE: 0,
	},		
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			
		],	
			
	"passive_abilities": func() -> Array: 
		return [
			
		],	
	# ------------------------------------------		
}

var MATERIAL_GEN_1:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.MATERIAL_GEN_1,
	"name": "ENGINEERING BAY",
	"shortname": "ENG.BAY",
	"categories": [ROOM.CATEGORY.RESOURCES],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.MATERIAL: 1,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.CORE: 0,
	},	
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.INSTANT_MATERIAL_LVL_1, 1),
		],	
			
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.GENERATE_MATERIAL_LVL_1),
		],	
	# ------------------------------------------		
}

var MATERIAL_GEN_2:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.MATERIAL_GEN_2,	
	"name": "MATERIAL_GEN_2",
	"shortname": "MATERIAL_GEN_2",
	"categories": [ROOM.CATEGORY.RESOURCES],	
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "+10 MATERIAL when placed adjacent to other MATERIAL_GEN_2.",
	# ------------------------------------------

	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],	
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.MATERIAL: 2,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.CORE: 0,
	},		
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			
		],	
			
	"passive_abilities": func() -> Array: 
		return [
			
		],	
	# ------------------------------------------		
}


var CORE_GEN_1:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.CORE_GEN_1,
	"name": "CORE_ROOM",
	"shortname": "CORE_ROOM",
	"categories": [ROOM.CATEGORY.RESOURCES],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "CORE_ROOM description.",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.CORE: 1,
	},	
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.INSTANT_CORE_LVL_1, 1),
		],	
			
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.GENERATE_CORE_LVL_1),
		],	
	# ------------------------------------------		
}

var CORE_GEN_2:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.CORE_GEN_2,	
	"name": "CORE_GEN_2",
	"shortname": "CORE_GEN_2",
	"categories": [ROOM.CATEGORY.RESOURCES],	
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "+1 CORE when placed adjacent to other CORE_GEN_2.",
	# ------------------------------------------

	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],	
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.CORE: 2,
	},		
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			
		],	
			
	"passive_abilities": func() -> Array: 
		return [
			
		],	
	# ------------------------------------------		
}

var MONEY_CONVERTER:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.MONEY_CONVERTER,	
	"name": "MONEY_CONVERTER",
	"shortname": "MONEY_CONVERTER",
	"categories": [ROOM.CATEGORY.RESOURCES],	
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Convert MONEY into other resources.",
	# ------------------------------------------

	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],	
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.CONVERT_MONEY_INTO_SCIENCE),
			ABL.get_ability(ABL.REF.CONVERT_MONEY_INTO_MATERIAL),
			ABL.get_ability(ABL.REF.CONVERT_MONEY_INTO_CORE),
		],	
	# ------------------------------------------		
}
# ------------------------------------------------------------------------------ 
#endregion

#region ENERGY
var ENERGY_STORAGE:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.ENERGY_STORAGE,
	"name": "ENERGY STORAGE",
	"shortname": "E.STORAGE",
	"categories": [ROOM.CATEGORY.ENERGY],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_energy": 0,
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	# ------------------------------------------	
	
	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"effect": {
		"description": "Adds +5 available energy to the wing.",
		"func": func(_new_room_config:Dictionary, _item:Dictionary) -> Dictionary:
			var floor:int = _item.location.floor
			var ring:int = _item.location.ring
			var room:int = _item.location.room
			var ring_config_data:Dictionary = _new_room_config.floor[floor].ring[ring]
			_new_room_config.floor[floor].ring[ring].energy.available += 5
			return _new_room_config,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			
		],	
	# ------------------------------------------	
}

var ENERGY_SYPHON:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.ENERGY_SYPHON,
	"name": "ENERGY_SYPHON",
	"shortname": "E.SYPHON",
	"categories": [ROOM.CATEGORY.ENERGY],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Any unused energy from the corresponding wing is available for this wing.  (0 <- 1, 1 <- 2, etc)",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	# ------------------------------------------	
	
	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"effect": {
		"description": "Syphons unused energy from neighboring wings.",
		"after_func": func(_new_room_config:Dictionary, _item:Dictionary) -> Dictionary:
			var floor:int = _item.location.floor
			var ring:int = _item.location.ring
			var room:int = _item.location.room
			var ring_config_data:Dictionary = _new_room_config.floor[floor].ring[ring]
			var adjacent_ring:int = U.min_max(ring + 1, 0, 3, true)
			var adjacent_energy:Dictionary = _new_room_config.floor[floor].ring[adjacent_ring].energy
			var syphon_amount:int = adjacent_energy.available - adjacent_energy.used

			_new_room_config.floor[floor].ring[adjacent_ring].energy.available = adjacent_energy.used
			_new_room_config.floor[floor].ring[ring].energy.available += syphon_amount
			return _new_room_config,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			
		],	
	# ------------------------------------------	
}
# ------------------------------------------------------------------------------ 
#endregion

#region UTILITY
# ------------------------------------------------------------------------------ UTILITY
var UI_ASSIST:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.UI_ASSIST,
	"name": "UI_ASSIST",
	"shortname": "UI.ASSIST",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Containment breaches are less likely to occur, however...",	
	# ------------------------------------------

	# ------------------------------------------
	"own_limit": 1,	
	"requires_unlock": false,
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.ADMIN
	],	
	# ------------------------------------------	

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.PREDICTIVE_TIMELINE),
			ABL_P.get_ability(ABL_P.REF.OBJECTIVE_ASSIST),
		],	
	# ------------------------------------------	
}

var STAFF_ROOM:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.STAFF_ROOM,
	"name": "STAFF ROOM",
	"shortname": "STF ROOM",
	"categories": [ROOM.CATEGORY.UTILITY],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Increases MORALE while offering optional team-bonding experiences.",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	# ------------------------------------------
		
	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"metrics": {
		RESOURCE.METRICS.MORALE: 1,
	},	
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.HAPPY_HOUR),
			ABL.get_ability(ABL.REF.UNHAPPY_HOUR),
		],	
	# ------------------------------------------	
}

var CAFETERIA:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.CAFETERIA,
	"name": "CAFETERIA",
	"shortname": "CAFETERIA",
	"categories": [ROOM.CATEGORY.UTILITY],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Increases READINESS and...",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	# ------------------------------------------
		
	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"metrics": {
		RESOURCE.METRICS.READINESS: 1,
	},	
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			
		],	
	# ------------------------------------------	
}

var WEAPONS_RANGE:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.WEAPONS_RANGE,
	"name": "WEAPONS RANGE",
	"shortname": "W.RANGE",
	"categories": [ROOM.CATEGORY.UTILITY],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Increases security and provides training.",	
	# ------------------------------------------

	# ------------------------------------------
	"unlock_level": 1,		
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.SECURITY
	],	
	# ------------------------------------------	

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------

	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.FIREARM_TRAINING),
			ABL_P.get_ability(ABL_P.REF.HEAVY_WEAPONS_TRAINING, 1)
		],	
	# ------------------------------------------	
}

var SCRANTON_REALITY_ANCHOR:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.SCRANTON_REALITY_ANCHOR,
	"name": "SCRANTON REALITY ANCHOR",
	"shortname": "SRA",
	"categories": [ROOM.CATEGORY.UTILITY],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Containment breaches are less likely to occur, but are expensive and fault prone.",	
	# ------------------------------------------

	# ------------------------------------------
	"unlock_level": 1,		
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER,
		RESEARCHER.SPECIALIZATION.SECURITY
	],	
	# ------------------------------------------	

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------

	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [

		],	
	# ------------------------------------------	
}

var HP_CLINIC:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.HP_CLINIC,
	"name": "HP_CLINIC",
	"shortname": "HP_CLINIC",
	"categories": [ROOM.CATEGORY.UTILITY],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "HP_CLINIC description",	
	# ------------------------------------------

	# ------------------------------------------
	"unlock_level": 1,		
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	# ------------------------------------------	

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [

		],	
	# ------------------------------------------	
}

var SP_CLINIC:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.SP_CLINIC,
	"name": "SP_CLINIC",
	"shortname": "SRA",
	"categories": [ROOM.CATEGORY.UTILITY],
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "SP_CLINIC description",	
	# ------------------------------------------

	# ------------------------------------------
	"unlock_level": 1,		
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	# ------------------------------------------	

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [

		],	
	# ------------------------------------------	
}


# ------------------------------------------------------------------------------ 
#endregion




# -----------------------------------	
var list:Array[Dictionary] = [
	DEBUG_ROOM,
	
	# --------------- SPECIALS
	DIRECTORS_OFFICE, 
	HQ, 
	HR_DEPARTMENT, OPERATIONS_SUPPORT, #--- S1
	MINIERAL_MINING, GEOTHERMAL_POWER, #--- S2
	GENERATOR_SUBSTATION, 
	
	PROBABILITY_ROOM,
	CHRONO_ROOM,
	NUCLEAR_FAILSAFE,
	
	# --------------- RECRUIT
	ADMIN_OFFICE, ACADEMIC_OUTREACH, SECURITY_DEPARTMENT, PRISONER_BLOCK,
	
	# --------------- CONTAINMENT
	STANDARD_CONTAINMENT_CELL, 
	
	# --------------- RESOURCES
	MONEY_GEN_1,			
	RESEARCH_GEN_1,
	MATERIAL_GEN_1,	
	CORE_GEN_1,
	
	MONEY_GEN_2,
	RESEARCH_GEN_2,
	MATERIAL_GEN_2,
	CORE_GEN_2,
	
	MONEY_CONVERTER,
	
	# --------------- RECRUITMENT
	PRISONER_BLOCK, OPERATIONS_SUPPORT, SECURITY_DEPARTMENT,
	MTF_BARRICKS,
	
	# --------------- ENERGY
	ENERGY_STORAGE, ENERGY_SYPHON,
	
	# --------------- UTILITY
	UI_ASSIST, WEAPONS_RANGE, SCRANTON_REALITY_ANCHOR,
	HP_CLINIC, SP_CLINIC,
	STAFF_ROOM, CAFETERIA
	
	
]
# -----------------------------------	
