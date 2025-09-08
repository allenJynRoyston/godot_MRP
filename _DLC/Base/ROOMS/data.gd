extends SubscribeWrapper
var UTILITY:Script = preload("res://_DLC/Base/ROOMS/utility.gd")

var DEBUG_ROOM:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.DEBUG_ROOM,
	"categories": [ROOM.CATEGORY.UTILITY],
	
	"name": "DEBUG_ROOM",
	"shortname": "DEBUG_ROOM",
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Debug room.",
	"requires_unlock": false,	
	"required_energy": 0,
	"own_limit": 10,
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
		RESOURCE.CURRENCY.MONEY: 5,
		RESOURCE.CURRENCY.MATERIAL: 4,
		RESOURCE.CURRENCY.SCIENCE: 3,
		RESOURCE.CURRENCY.CORE: 2,
	},
	"metrics": {
		RESOURCE.METRICS.MORALE: 0,
		RESOURCE.METRICS.SAFETY: 0,
		RESOURCE.METRICS.READINESS: 0
	},	
	"environmental":{
		"hazard": 0,
		"temp": 0,
		"pollution": 0
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
		],	
	# ------------------------------------------
		
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [

		],	
	# ------------------------------------------		
}

#region ADMIN
var ADMIN_DEPARTMENT:Dictionary = {
	"ref": ROOM.REF.ADMIN_DEPARTMENT,
	"link_categories": ROOM.CATEGORY.ADMIN,
	"categories": [ROOM.CATEGORY.DEPARTMENT],
	"name": "ADMINISTRATION DEPARTMENT",
	"img_src": "res://Media/rooms/admin_section.png",
	"shortname": "ADMIN DEPT", 	
	"description": "Central hub for ADMIN facilities.",
	"quote": "The heart of the Site beats in paperwork and protocols.",

	"requires_unlock": false, 	
	"required_staffing": [],
	"required_energy": 1,
	
	"department_properties": {
		"operator": ROOM.OPERATOR.ADD,
		"currency": [],
		"metric": [RESOURCE.METRICS.MORALE],
		"level": 1,
		"effects": [ROOM.EFFECTS.ADMIN_DEFAULT],
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.ADD_MONEY_TO_ALL_IN_RING, 0)
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
	

	"requires_unlock": false, 	
	"required_staffing": [],
	"required_energy": 1,
	
	"department_properties": {
		"operator": ROOM.OPERATOR.ADD,
		"currency": [RESOURCE.CURRENCY.MATERIAL],
		"metric": [],
		"level": 1,
		"effects": [ROOM.EFFECTS.LOGISTICS_DEFAULT],
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.ADD_SCIENCE_TO_ALL_IN_RING, 0)
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

	"requires_unlock": false, 	
	"required_staffing": [],
	"required_energy": 1,
	
	"department_properties": {
		"operator": ROOM.OPERATOR.SUBTRACT,
		"currency": [RESOURCE.CURRENCY.MONEY],
		"metric": [],
		"level": 1,
		"effects": [ROOM.EFFECTS.ENGINEERING_DEFAULT],
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.ADD_MATERIAL_TO_ALL_IN_RING, 0)
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
	"shortname": "ANTIM.DEPT", 	
	"description": "Central hub for ANTIMEMETICS facilities.",
	"quote": "There is no Antimemetics Department.",

	"requires_unlock": false, 	
	"required_staffing": [],
	"required_energy": 1,
	
	"department_properties": {
		"operator": ROOM.OPERATOR.SUBTRACT,
		"currency": [],
		"metric": [RESOURCE.METRICS.SAFETY],
		"level": 1,
		"effects": [ROOM.EFFECTS.ANTIMEMETICS_DEFAULT],
	},
	
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.ADD_MATERIAL_TO_ALL_IN_RING, 0)
		],
					
	
	"influence": {
		"range": 1,
		"description": "FACILITIES built here will influence the ENGINEERING DEPT."
	},
}
#endregion


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

var UTIL_BUFF_EFFECT_1:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_BUFF_EFFECT_1)
var UTIL_BUFF_EFFECT_2:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_BUFF_EFFECT_2)

var UTIL_DEBUFF_EFFECT_1:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_DEBUFF_EFFECT_1)
var UTIL_DEBUFF_EFFECT_2:Dictionary = UTILITY.get_room_data(ROOM.REF.UTIL_DEBUFF_EFFECT_2)
#endregion




# -----------------------------------	
var list:Array[Dictionary] = [
	# ADMIN ROOMS
	ADMIN_DEPARTMENT, 
	LOGISTICS_DEPARTMENT, 
	ENGINEERING_DEPARTMENT, 
	ANTIMEMETICS_DEPARTMENT,
	
	# UTILITY:
	UTIL_LEVEL_UP_1, UTIL_LEVEL_UP_2, UTIL_LEVEL_UP_3,
	UTIL_LEVEL_DOWN_1, UTIL_LEVEL_DOWN_2, UTIL_LEVEL_DOWN_3,
	
	UTIL_ADD_CURRENCY_MONEY, UTIL_ADD_CURRENCY_SCIENCE, UTIL_ADD_CURRENCY_MATERIAL, UTIL_ADD_CURRENCY_CORE,
	UTIL_RMV_CURRENCY_MONEY, UTIL_RMV_CURRENCY_SCIENCE, UTIL_RMV_CURRENCY_MATERIAL, UTIL_RMV_CURRENCY_CORE,
	
	UTIL_ADD_METRIC_MORALE, UTIL_ADD_METRIC_SAFETY, UTIL_ADD_METRIC_READINESS,
	UTIL_RMV_METRIC_MORALE, UTIL_RMV_METRIC_SAFETY, UTIL_RMV_METRIC_READINESS,
		
	UTIL_BUFF_EFFECT_1, UTIL_BUFF_EFFECT_2,
	UTIL_DEBUFF_EFFECT_1, UTIL_DEBUFF_EFFECT_2,

]
# -----------------------------------	
