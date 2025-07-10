extends Node


var DEBUG_ROOM:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.DEBUG_ROOM,
	"name": "DEBUG_ROOM",
	"shortname": "DEBUG_ROOM",
	"categories": [ROOM.CATEGORY.UTILITY],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Debug room.",
	"requires_unlock": false,	
	# ------------------------------------------

	# ------------------------------------------
	"can_contain": false,
	"can_assign_researchers": true,
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.ANY
	],
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
		"purchase": 100,
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


#region SPECIALS
# ------------------------------------------------------------------------------ SPECIALS
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
	"own_limit": 1,	
	"can_destroy": false,
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
	"img_src": "res://Media/rooms/research_lab.jpg",
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
		"unlock": 0,
		"purchase": 0,
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
	"img_src": "res://Media/rooms/research_lab.jpg",
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
		"unlock": 0,
		"purchase": 0,
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
	"img_src": "res://Media/rooms/research_lab.jpg",
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
		"unlock": 0,
		"purchase": 0,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.SUPPLY_STAFF),
			ABL_P.get_ability(ABL_P.REF.SUPPLY_SECURITY),
			ABL_P.get_ability(ABL_P.REF.SUPPLY_TECHNICIANS),
			ABL_P.get_ability(ABL_P.REF.SUPPLY_DCLASS),
		],	
	# ------------------------------------------	
}

var GENERATOR_SUBSTATION:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.GENERATOR_SUBSTATION,
	"name": "GENERATOR_SUBSTATION",
	"shortname": "GEN.SUBSTAITON",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.jpg",
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
		"unlock": 0,
		"purchase": 0,
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

#region RECRUITMENT
# ------------------------------------------------------------------------------ RECRUITMENT
var PRISONER_BLOCK:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.PRISONER_BLOCK,	
	"name": "PRISONER BLOCK",
	"shortname": "P.BLOCK",
	"categories": [ROOM.CATEGORY.RECRUITMENT],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "A prisoner block designed specifically to house D-Class personel.",
	# ------------------------------------------

	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.SECURITY, 
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
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
	"img_src": "res://Media/rooms/research_lab.jpg",
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
		"unlock": 50,
		"purchase": 100,
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
	"img_src": "res://Media/rooms/research_lab.jpg",
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
		"unlock": 50,
		"purchase": 100,
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
	"img_src": "res://Media/rooms/research_lab.jpg",
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
		"unlock": 50,
		"purchase": 100,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.HIRE_RESEARCHERS),
		],		
	# ------------------------------------------
}

var MINIERAL_MINING:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.MINIERAL_MINING,
	"name": "MINERAL MINING",
	"shortname": "MIN.MINING",
	"categories": [ROOM.CATEGORY.SPECIAL],
	"img_src": "res://Media/rooms/research_lab.jpg",
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
		"unlock": 0,
		"purchase": 0,
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
	"img_src": "res://Media/rooms/research_lab.jpg",
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
		"unlock": 0,
		"purchase": 0,
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
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Containment cell used to house anamolous objects.",
		
	# ------------------------------------------
	"requires_unlock": false,
	"can_contain": true,
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
# ------------------------------------------------------------------------------ 
#endregion

#region RESOURCES
# ------------------------------------------------------------------------------ RESOURCES
var AERD:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.AERD,	
	"name": "ECONOMIC RECLIMATION DIVISION",
	"shortname": "ECO DIV",
	"categories": [ROOM.CATEGORY.RESOURCES],	
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "A covert unit used to sustain Foundation operations through unofficial financial channels.",
	# ------------------------------------------

	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.ADMIN
	],	
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 100,
		"purchase": 200,
	},
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 50,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.CORE: 0,
	},	
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.MONEY_HACK, 1),
		],	
			
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.GENERATE_MONEY),
		],	
	# ------------------------------------------		
}

var RESEARCH_LAB:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.RESEARCH_LAB,	
	"name": "RESEARCH LAB",
	"shortname": "R.LAB",
	"categories": [ROOM.CATEGORY.RESOURCES],	
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "A covert unit used to sustain Foundation operations through unofficial financial channels.",
	# ------------------------------------------

	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER, 
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 100,
		"purchase": 200,
	},
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			#ABL.get_ability(ABL.REF.SCIENCE_HACK, 1),
		],	
			
	"passive_abilities": func() -> Array: 
		return [
			#ABL_P.get_ability(ABL_P.REF.GENERATE_SCIENCE),
		],	
	# ------------------------------------------		
}

var ENGINEERING_BAY:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.ENGINEERING_BAY,
	"name": "ENGINEERING BAY",
	"shortname": "ENG.BAY",
	"categories": [ROOM.CATEGORY.RESOURCES],
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	# ------------------------------------------
		
	# ------------------------------------------
	"costs": {
		"unlock": 100,
		"purchase": 200,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	#"required_personnel": [
		#RESOURCE.PERSONNEL.TECHNICIANS
	#],
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			#ABL_P.get_ability(ABL_P.REF.TECH_SUPPORT),
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
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	# ------------------------------------------	
	
	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	#"required_personnel": [
		#RESOURCE.PERSONNEL.TECHNICIANS
	#],
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
	"img_src": "res://Media/rooms/research_lab.jpg",
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
		"unlock": 0,
		"purchase": 50,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	#"required_personnel": [
		#RESOURCE.PERSONNEL.TECHNICIANS
	#],
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
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Utilize technicians to increase safety and readiness.",
	# ------------------------------------------
	
	# ------------------------------------------
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	# ------------------------------------------
		
	# ------------------------------------------
	"costs": {
		"unlock": 100,
		"purchase": 200,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"metrics": {
		RESOURCE.METRICS.MORALE: 2,
	},	
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.HAPPY_HOUR),
		],	
	# ------------------------------------------	
}

var WEAPONS_RANGE:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.WEAPONS_RANGE,
	"name": "WEAPONS RANGE",
	"shortname": "W.RANGE",
	"categories": [ROOM.CATEGORY.UTILITY],
	"img_src": "res://Media/rooms/research_lab.jpg",
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
		"unlock": 50,
		"purchase": 100,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	#"required_personnel": [
		#RESOURCE.PERSONNEL.TECHNICIANS
	#],
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
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Containment breaches are less likely to occur, however...",	
	# ------------------------------------------

	# ------------------------------------------
	"unlock_level": 1,		
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],	
	# ------------------------------------------	

	# ------------------------------------------
	"costs": {
		"unlock": 100,
		"purchase": 300,
	},
	# ------------------------------------------
	
	# ------------------------------------------
	#"required_personnel": [
		#RESOURCE.PERSONNEL.TECHNICIANS
	#],
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
	
	# --------------- RECRUIT
	PRISONER_BLOCK,
	ADMIN_OFFICE,
	SECURITY_DEPARTMENT,
	ACADEMIC_OUTREACH,
	
	# --------------- CONTAINMENT
	STANDARD_CONTAINMENT_CELL, 
	
	# --------------- RESOURCES
	AERD,
	RESEARCH_LAB,
	ENGINEERING_BAY,
	
	# --------------- RECRUITMENT
	PRISONER_BLOCK, 
	OPERATIONS_SUPPORT, 
	SECURITY_DEPARTMENT,
	
	# --------------- ENERGY
	ENERGY_STORAGE,
	
	# --------------- UTILITY
	UI_ASSIST,
	WEAPONS_RANGE, 
	SCRANTON_REALITY_ANCHOR,
]
# -----------------------------------	
