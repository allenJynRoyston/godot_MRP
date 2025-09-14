extends SubscribeWrapper
var UTILITY:Script = preload("res://_DLC/Base/ROOMS/utility.gd")

var DEBUG_DEPARTMENT:Dictionary = {
	"ref": ROOM.REF.DEBUG_DEPARTMENT,
	"link_categories": ROOM.CATEGORY.DEPARTMENT,
	"categories": [ROOM.CATEGORY.DEPARTMENT],
	"name": "DEBUG DEPARTMENT",
	"img_src": "res://Media/rooms/admin_section.png",
	"shortname": "DEBUG DEPT", 	
	"description": "Central hub for DEBUG facilities.",
	"quote": "This should NOT normally be available.",

	"costs": {
		"build": 10,
		"unlock": 0,
		"purchase": 10,
	},
	
	"requires_unlock": false, 	
	"required_staffing": [],
	"required_energy": 1,

	"department_props": {
		"operator": ROOM.OPERATOR.ADD,
		"currency": [],
		"metric": [],
		"level": 1,
		"bonus": 0,
		"effects": [],
		"metric_blacklist": [],
		"currency_blacklist": [],
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.PROCUREMENT_PASSIVE_1, 0),
			ABL_P.get_ability(ABL_P.REF.PROCUREMENT_PASSIVE_2, 0),
			
			ABL_P.get_ability(ABL_P.REF.LOGISTICS_PASSIVE_1, 0),
			ABL_P.get_ability(ABL_P.REF.ENGINEERING_PASSIVE_1, 0),
			ABL_P.get_ability(ABL_P.REF.TEMPORAL_PASSIVE_1, 0),
			ABL_P.get_ability(ABL_P.REF.SCIENCE_PASSIVE_1, 0),

			ABL_P.get_ability(ABL_P.REF.ADMIN_PASSIVE_1, 0),
			ABL_P.get_ability(ABL_P.REF.SECURITY_PASSIVE_1, 0),
			ABL_P.get_ability(ABL_P.REF.THEOLOGY_PASSIVE_1, 0),
			ABL_P.get_ability(ABL_P.REF.ANTIMEMETICS_PASSIVE_1, 0),
			ABL_P.get_ability(ABL_P.REF.MISCOMMUNICATION_PASSIVE_1, 0),
		],
					
	
	"influence": {
		"description": "FACILITIES built here will influence the ADMIN DEPT."
	},
}


#region ADMIN
var PROCUREMENT_DEPARTMENT:Dictionary = {
	"ref": ROOM.REF.PROCUREMENT_DEPARTMENT,
	"link_categories": ROOM.CATEGORY.PROCUREMENT,
	"categories": [ROOM.CATEGORY.DEPARTMENT],
	"name": "PROCUREMENT DEPARTMENT",
	"img_src": "res://Media/rooms/admin_section.png",
	"shortname": "PROC DEPT", 	
	"description": "Central hub for PROOCUREMENT facilities.",
	"quote": "The heart of the Site beats in paperwork and protocols.",

	"costs": {
		"build": 10,
		"unlock": 0,
		"purchase": 10,
	},
	"requires_unlock": false, 	
	"required_staffing": [],
	"required_energy": 1,

	"department_props": {
		"operator": ROOM.OPERATOR.ADD,
		"currency": [RESOURCE.CURRENCY.MONEY],
		"metric": [],
		"level": 1,
		"bonus": 0,
		"effects": [],
		"metric_blacklist": [],
		"currency_blacklist": [],
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.PROCUREMENT_PASSIVE_1, 0),
			ABL_P.get_ability(ABL_P.REF.PROCUREMENT_PASSIVE_2, 4)
		],
					
	
	"influence": {
		"description": "FACILITIES built here will influence the ADMIN DEPT."
	},
}

var LOGISTICS_DEPARTMENT:Dictionary =  {
	"ref": ROOM.REF.LOGISTICS_DEPARTMENT,
	"link_categories": ROOM.CATEGORY.LOGISTICS,
	"categories": [ROOM.CATEGORY.DEPARTMENT],
	"name": "LOGISTICS DEPARTMENT",
	"img_src": "res://Media/rooms/logistic_section.png",
	"shortname": "LOG DEPT", 	
	"description": "Central hub for LOGISTICS facilities.",
	"quote": "...",
	

	"costs": {
		"build": 10,
		"unlock": 10,
		"purchase": 10,
	},	
	"required_staffing": [],
	"required_energy": 1,
	
	"department_props": {
		"operator": ROOM.OPERATOR.ADD,
		"currency": [RESOURCE.CURRENCY.MATERIAL],
		"metric": [],
		"level": 1,
		"bonus": 0,
		"effects": [],
		"metric_blacklist": [],
		"currency_blacklist": [],		
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.LOGISTICS_PASSIVE_1, 0)
		],
					
	
	"influence": {
		"range": 1,
		"description": "FACILITIES built here will influence the LOGISTICS DEPT."
	},
}

var ENGINEERING_DEPARTMENT:Dictionary = {
	"ref": ROOM.REF.ENGINEERING_DEPARTMENT,
	"link_categories": ROOM.CATEGORY.ENGINEERING,
	"categories": [ROOM.CATEGORY.DEPARTMENT],
	"name": "ENGINEERING DEPARTMENT",
	"img_src": "res://Media/rooms/engineering_section.png",
	"shortname": "ENG DEPT", 	
	"description": "Central hub for ENGINEERING facilities.",
	"quote": "...",

	"costs": {
		"build": 10,
		"unlock": 10,
		"purchase": 10,
	},	
	"required_staffing": [],
	"required_energy": 1,
	
	"department_props": {
		"operator": ROOM.OPERATOR.ADD,
		"currency": [RESOURCE.CURRENCY.CORE],
		"metric": [],
		"level": 1,
		"bonus": 0,
		"effects": [],
		"metric_blacklist": [],
		"currency_blacklist": [],		
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.ENGINEERING_PASSIVE_1, 0)
		],
					
	
	"influence": {
		"range": 1,
		"description": "FACILITIES built here will influence the ENGINEERING DEPT."
	},
}

var SCIENCE_DEPARTMENT:Dictionary = {
	"ref": ROOM.REF.SCIENCE_DEPARTMENT,
	"link_categories": ROOM.CATEGORY.SCIENCE,
	"categories": [ROOM.CATEGORY.DEPARTMENT],
	"name": "SCIENCE DEPARTMENT",
	"img_src": "res://Media/rooms/engineering_section.png",
	"shortname": "SCI DEPT", 	
	"description": "Central hub for SCIENCE facilities.",
	"quote": "...",

	"costs": {
		"build": 10,
		"unlock": 10,
		"purchase": 10,
	},	
	"required_staffing": [],
	"required_energy": 1,
	
	"department_props": {
		"operator": ROOM.OPERATOR.ADD,
		"currency": [RESOURCE.CURRENCY.SCIENCE],
		"metric": [],
		"level": 1,
		"bonus": 0,
		"effects": [],
		"metric_blacklist": [],
		"currency_blacklist": [],		
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.SCIENCE_PASSIVE_1, 0)
		],
					
	
	"influence": {
		"range": 1,
		"description": "FACILITIES built here will influence the ENGINEERING DEPT."
	},
}

var ADMIN_DEPARTMENT:Dictionary = {
	"ref": ROOM.REF.ADMIN_DEPARTMENT,
	"link_categories": ROOM.CATEGORY.ADMIN,
	"categories": [ROOM.CATEGORY.DEPARTMENT],
	"name": "ADMINISTRATION DEPARTMENT",
	"img_src": "res://Media/rooms/admin_section.png",
	"shortname": "ADM DEPT", 	
	"description": "Central hub for ADMIN facilities.",
	"quote": "The heart of the Site beats in paperwork and protocols.",

	"costs": {
		"build": 10,
		"unlock": 0,
		"purchase": 10,
	},
	"requires_unlock": false, 	
	"required_staffing": [],
	"required_energy": 1,

	
	"department_props": {
		"operator": ROOM.OPERATOR.ADD,
		"currency": [],
		"metric": [RESOURCE.METRICS.MORALE],
		"level": 1,
		"bonus": 0,
		"effects": [],
		"metric_blacklist": [],
		"currency_blacklist": [],		
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.ADMIN_PASSIVE_1, 0)
		],
					
	
	"influence": {
		"description": "FACILITIES built here will influence the ADMIN DEPT."
	},
}

var SECURITY_DEPARTMENT:Dictionary = {
	"ref": ROOM.REF.SECURITY_DEPARTMENT,
	"link_categories": ROOM.CATEGORY.SECURITY,
	"categories": [ROOM.CATEGORY.DEPARTMENT],
	"name": "SECURITY DEPARTMENT",
	"img_src": "res://Media/rooms/admin_section.png",
	"shortname": "SEC DEPT", 	
	"description": "Central hub for ADMIN facilities.",
	"quote": "The heart of the Site beats in paperwork and protocols.",

	"costs": {
		"build": 10,
		"unlock": 0,
		"purchase": 10,
	},
	"requires_unlock": false, 	
	"required_staffing": [],
	"required_energy": 1,

	
	"department_props": {
		"operator": ROOM.OPERATOR.ADD,
		"currency": [],
		"metric": [RESOURCE.METRICS.SAFETY],
		"level": 1,
		"bonus": 0,
		"effects": [],
		"metric_blacklist": [],
		"currency_blacklist": [],		
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.SECURITY_PASSIVE_1, 0)
		],
					
	
	"influence": {
		"description": "FACILITIES built here will influence the ADMIN DEPT."
	},
}

var TEMPORAL_DEPARMENT:Dictionary = {
	"ref": ROOM.REF.TEMPORAL_DEPARTMENT,
	"link_categories": ROOM.CATEGORY.TEMPORAL,
	"categories": [ROOM.CATEGORY.DEPARTMENT],
	"name": "TEMPORAL DEPARTMENT",
	"img_src": "res://Media/rooms/engineering_section.png",
	"shortname": "TEMP DEPT", 	
	"description": "Central hub for TEMPORAL facilities.",
	"quote": "This should have been done yesterday, literally.",

	"costs": {
		"build": 10,
		"unlock": 25,
		"purchase": 15,
	},	
	"required_staffing": [],
	"required_energy": 1,
	
	"department_props": {
		"operator": ROOM.OPERATOR.ADD,
		"currency": [],
		"metric": [RESOURCE.METRICS.READINESS],
		"level": 1,
		"bonus": 0,
		"effects": [],
		"metric_blacklist": [],
		"currency_blacklist": [],		
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.TEMPORAL_PASSIVE_1, 0)
		],
					
	
	"influence": {
		"range": 1,
		"description": "FACILITIES built here will influence the ENGINEERING DEPT."
	},
}

var ANTIMEMETICS_DEPARTMENT:Dictionary = {
	"ref": ROOM.REF.ANTIMEMETICS_DEPARTMENT,
	"link_categories": ROOM.CATEGORY.ANTIMEMETICS,
	"categories": [ROOM.CATEGORY.DEPARTMENT],
	"name": "ANTIMEMETICS DEPARTMENT",
	"img_src": "res://Media/rooms/engineering_section.png",
	"shortname": "ANTIM DEPT", 	
	"description": "Central hub for ANTIMEMETICS facilities.",
	"quote": "There is no Antimemetics Department.",

	"costs": {
		"build": 10,
		"unlock": 25,
		"purchase": 15,
	},	
	"required_staffing": [],
	"required_energy": 1,
	
	"department_props": {
		"operator": ROOM.OPERATOR.SUBTRACT,
		"currency": [],
		"metric": [],
		"level": 1,
		"bonus": 0,
		"effects": [],
		"metric_blacklist": [],
		"currency_blacklist": [],		
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.ANTIMEMETICS_PASSIVE_1, 0)
		],
					
	
	"influence": {
		"range": 1,
		"description": "FACILITIES built here will influence the ENGINEERING DEPT."
	},
}

# -----------
var THEOLOGY_DEPARTMENT:Dictionary = {
	"ref": ROOM.REF.THEOLOGY_DEPARTMENT,
	"link_categories": ROOM.CATEGORY.THEOLOGY,
	"categories": [ROOM.CATEGORY.DEPARTMENT],
	"name": "THEOLOGY DEPARTMENT",
	"img_src": "res://Media/rooms/engineering_section.png",
	"shortname": "THEO DEPT", 	
	"description": "Central hub for THEOLOGY facilities.",
	"quote": "More gods, more problems.",

	"costs": {
		"build": 10,
		"unlock": 25,
		"purchase": 15,
	},	
	"required_staffing": [],
	"required_energy": 1,
	
	"department_props": {
		"operator": ROOM.OPERATOR.SUBTRACT,
		"currency": [],
		"metric": [],
		"level": 1,
		"bonus": 0,
		"effects": [],
		"metric_blacklist": [],
		"currency_blacklist": [],		
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.THEOLOGY_PASSIVE_1, 0)
		],
					
	
	"influence": {
		"range": 1,
		"description": "FACILITIES built here will influence the ENGINEERING DEPT."
	},
}

var MISCOMMUNICATION_DEPARTMENT:Dictionary = {
	"ref": ROOM.REF.MISCOMMUNICATION_DEPARTMENT,
	"link_categories": ROOM.CATEGORY.MISCOMMUNICATION,
	"categories": [ROOM.CATEGORY.DEPARTMENT],
	"name": "MISCOMMUNICATION DEPARTMENT",
	"img_src": "res://Media/rooms/engineering_section.png",
	"shortname": "MISC DEPT", 	
	"description": "Central hub for MISCOMMUNICATION facilities.",
	"quote": "Did you unironically get that thing I sent you?",

	"costs": {
		"build": 10,
		"unlock": 25,
		"purchase": 15,
	},	
	"required_staffing": [],
	"required_energy": 1,
	
	"department_props": {
		"operator": ROOM.OPERATOR.SUBTRACT,
		"currency": [],
		"metric": [],
		"level": 1,
		"bonus": 0,
		"effects": [],
		"metric_blacklist": [],
		"currency_blacklist": [],		
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.MISCOMMUNICATION_PASSIVE_1, 0)
		],
					
	
	"influence": {
		"range": 1,
		"description": "FACILITIES built here will influence the ENGINEERING DEPT."
	},
}

var PATAPHYSICS_DEPARTMENT:Dictionary = {
	"ref": ROOM.REF.PATAPHYSICS_DEPARTMENT,
	"link_categories": ROOM.CATEGORY.PATAPHYSICS,
	"categories": [ROOM.CATEGORY.DEPARTMENT],
	"name": "PATAPHYSICS DEPARTMENT",
	"img_src": "res://Media/rooms/engineering_section.png",
	"shortname": "PATA DEPT", 	
	"description": "A department that studies (and questions) the basis for reality.",
	"quote": "Existence is merely the preferred option.",

	"costs": {
		"build": 10,
		"unlock": 25,
		"purchase": 15,
	},	
	"required_staffing": [],
	"required_energy": 1,
	
	"department_props": {
		"operator": ROOM.OPERATOR.ADD,
		"currency": [],
		"metric": [],
		"level": 1,
		"bonus": 0,
		"effects": [],
		"metric_blacklist": [],
		"currency_blacklist": [],
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.PATAPHYSICS_PASSIVE_1, 0)
		],
					
	
	"influence": {
		"range": 1,
		"description": "FACILITIES built here will influence the PATAPHYSICS DEPT."
	},
}
#endregion

var CONTAINMENT_CELL_A:Dictionary = {
	"ref": ROOM.REF.CONTAINMENT_CELL,
	"link_categories": ROOM.CATEGORY.CONTAINMENT,
	"categories": [ROOM.CATEGORY.CONTAINMENT],
	"name": "CONTAINMENT CELL",
	"img_src": "res://Media/rooms/engineering_section.png",
	"shortname": "C.CELL", 	
	"description": "Basic containment cell.",
	"quote": "...",
	"can_contain": true,

	"costs": {
		"build": 10,
		"unlock": 25,
		"purchase": 15,
	},	
	"required_staffing": [],
	"required_energy": 1,
	
	"department_props": {
		"operator": ROOM.OPERATOR.SUBTRACT,
		"level": 1,
		"bonus": 0,
		"currency": [],
		"metric": [],				
		"metric_blacklist": [],
		"currency_blacklist": [],
		"effects": [],
	},
	
	"passive_abilities": func() -> Array: 
		return [
		],
	
	"influence": {
		"range": 1,
		"description": "FACILITIES built here will influence the PATAPHYSICS DEPT."
	},
}


#region UTILITY (DRAW) ROOMS
var UTIL_LEVEL_UP_1:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_LEVEL_UP_1)
var UTIL_LEVEL_UP_2:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_LEVEL_UP_2)
var UTIL_LEVEL_UP_3:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_LEVEL_UP_3)

var UTIL_LEVEL_DOWN_1:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_LEVEL_DOWN_1)
var UTIL_LEVEL_DOWN_2:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_LEVEL_DOWN_2)
var UTIL_LEVEL_DOWN_3:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_LEVEL_DOWN_3)

var UTIL_ADD_CURRENCY_MONEY:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_ADD_CURRENCY_MONEY)
var UTIL_ADD_CURRENCY_SCIENCE:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_ADD_CURRENCY_SCIENCE)
var UTIL_ADD_CURRENCY_MATERIAL:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_ADD_CURRENCY_MATERIAL)
var UTIL_ADD_CURRENCY_CORE:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_ADD_CURRENCY_CORE)

var UTIL_RMV_CURRENCY_MONEY:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_RMV_CURRENCY_MONEY)
var UTIL_RMV_CURRENCY_SCIENCE:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_RMV_CURRENCY_SCIENCE)
var UTIL_RMV_CURRENCY_MATERIAL:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_RMV_CURRENCY_MATERIAL)
var UTIL_RMV_CURRENCY_CORE:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_RMV_CURRENCY_CORE)

var UTIL_ADD_METRIC_MORALE:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_ADD_METRIC_MORALE)
var UTIL_ADD_METRIC_SAFETY:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_ADD_METRIC_SAFETY)
var UTIL_ADD_METRIC_READINESS:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_ADD_METRIC_READINESS)

var UTIL_RMV_METRIC_MORALE:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_RMV_METRIC_MORALE)
var UTIL_RMV_METRIC_SAFETY:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_RMV_METRIC_SAFETY)
var UTIL_RMV_METRIC_READINESS:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_RMV_METRIC_READINESS)

var UTIL_DOUBLE_ECON_OUTPUT:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_DOUBLE_ECON_OUTPUT)
var UTIL_TRIPLE_ECON_OUTPUT:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_TRIPLE_ECON_OUTPUT)

var UTIL_HALF_ECON_OUTPUT:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_HALF_ECON_OUTPUT)
var UTIL_ZERO_ECON_OUTPUT:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_ZERO_ECON_OUTPUT)

var UTIL_ADD_ENERGY_1:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_ADD_ENERGY_1)
var UTIL_ADD_ENERGY_2:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_ADD_ENERGY_2)
var UTIL_ADD_ENERGY_3:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_ADD_ENERGY_3)
#var UTIL_ZERO_ECON_OUTPUT:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_ZERO_ECON_OUTPUT)
#endregion

# -----------------------------------	
var list:Array[Dictionary] = [
	# DEPARTMENTS
	DEBUG_DEPARTMENT,
	PROCUREMENT_DEPARTMENT,
	ADMIN_DEPARTMENT, 
	LOGISTICS_DEPARTMENT, 
	ENGINEERING_DEPARTMENT, 
	ANTIMEMETICS_DEPARTMENT,
	THEOLOGY_DEPARTMENT,
	TEMPORAL_DEPARMENT,
	MISCOMMUNICATION_DEPARTMENT,
	PATAPHYSICS_DEPARTMENT,
	SECURITY_DEPARTMENT,
	SCIENCE_DEPARTMENT,
	
	# CONTAINMENT
	CONTAINMENT_CELL_A,
	
	# UTILITY:
	UTIL_LEVEL_UP_1, UTIL_LEVEL_UP_2, UTIL_LEVEL_UP_3,
	UTIL_LEVEL_DOWN_1, UTIL_LEVEL_DOWN_2, UTIL_LEVEL_DOWN_3,
	UTIL_ADD_ENERGY_1, UTIL_ADD_ENERGY_2, UTIL_ADD_ENERGY_3,

	UTIL_ADD_CURRENCY_MONEY, UTIL_ADD_CURRENCY_SCIENCE, UTIL_ADD_CURRENCY_MATERIAL, UTIL_ADD_CURRENCY_CORE,
	UTIL_RMV_CURRENCY_MONEY, UTIL_RMV_CURRENCY_SCIENCE, UTIL_RMV_CURRENCY_MATERIAL, UTIL_RMV_CURRENCY_CORE,
	
	UTIL_ADD_METRIC_MORALE, UTIL_ADD_METRIC_SAFETY, UTIL_ADD_METRIC_READINESS,
	UTIL_RMV_METRIC_MORALE, UTIL_RMV_METRIC_SAFETY, UTIL_RMV_METRIC_READINESS,
		
	UTIL_DOUBLE_ECON_OUTPUT, UTIL_TRIPLE_ECON_OUTPUT,
	UTIL_HALF_ECON_OUTPUT, UTIL_ZERO_ECON_OUTPUT,
	
	UTIL_HALF_ECON_OUTPUT, UTIL_ZERO_ECON_OUTPUT,
]
# -----------------------------------	
