extends Node

static func get_room_data(ref:ROOM.REF) -> Dictionary:
	var room_data:Dictionary = {}
	match ref:
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_LEVEL_DOWN_1:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "DOWN LVL",
				"shortname": "D.LEVEL",
				"utility_props": {
					"level": -1,
				}
			}				
		ROOM.REF.UTIL_LEVEL_DOWN_2:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "DOWN LVL",
				"shortname": "D.LEVEL",
				"utility_props": {
					"level": -2,
				}
			}							
		ROOM.REF.UTIL_LEVEL_DOWN_3:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "DOWN LVL",
				"shortname": "D.LEVEL",
				"utility_props": {
					"level": -3,
				}
			}										
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_LEVEL_UP_1:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ADD LVL",
				"shortname": "A.LEVEL",
				"utility_props": {
					"level": 1,
				}
			}		
		ROOM.REF.UTIL_LEVEL_UP_2:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ADD LVL",
				"shortname": "A.LEVEL",
				"utility_props": {
					"level": 2,
				}
			}
		ROOM.REF.UTIL_LEVEL_UP_3:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ADD LVL",
				"shortname": "A.LEVEL",
				"utility_props": {
					"level": 3,
				}
			}								
			

		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_ADD_CURRENCY_MONEY:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ADD MONEY",
				"shortname": "MONEY",
				"utility_props": {
					"currency": RESOURCE.CURRENCY.MONEY,
				}
			}
		ROOM.REF.UTIL_ADD_CURRENCY_SCIENCE:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ADD SCIENCE",
				"shortname": "SCIENCE",
				"utility_props": {
					"currency": RESOURCE.CURRENCY.SCIENCE,
				}				
			}			
		ROOM.REF.UTIL_ADD_CURRENCY_MATERIAL:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ADD MATERIAL",
				"shortname": "MATERIAL",
				"utility_props": {
					"currency": RESOURCE.CURRENCY.MATERIAL,
				}				
			}
		ROOM.REF.UTIL_ADD_CURRENCY_CORE:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ADD CURRENCY",
				"shortname": "CURRENCY",
				"utility_props": {
					"currency": RESOURCE.CURRENCY.CORE,
				}				
			}
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_RMV_CURRENCY_MONEY:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "REMOVE MONEY",
				"shortname": "MONEY",
				"utility_props": {
					"remove_currency": RESOURCE.CURRENCY.MONEY,
				}
			}
		ROOM.REF.UTIL_RMV_CURRENCY_SCIENCE:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "REMOVE SCIENCE",
				"shortname": "SCIENCE",
				"utility_props": {
					"remove_currency": RESOURCE.CURRENCY.SCIENCE,
				}				
			}			
		ROOM.REF.UTIL_RMV_CURRENCY_MATERIAL:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ADD MATERIAL",
				"shortname": "MATERIAL",
				"utility_props": {
					"remove_currency": RESOURCE.CURRENCY.MATERIAL,
				}				
			}
		ROOM.REF.UTIL_RMV_CURRENCY_CORE:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "REMOVE CURRENCY",
				"shortname": "CURRENCY",
				"utility_props": {
					"remove_currency": RESOURCE.CURRENCY.CORE,
				}				
			}
			

		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_ADD_METRIC_MORALE:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ADD MORALE",
				"shortname": "MORALE",
				"utility_props": {
					"metric": RESOURCE.METRICS.MORALE,
				}
			}
		ROOM.REF.UTIL_ADD_METRIC_SAFETY:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ADD SAFETY",
				"shortname": "SAFETY",
				"utility_props": {
					"metric": RESOURCE.METRICS.SAFETY,
				}				
			}			
		ROOM.REF.UTIL_ADD_METRIC_READINESS:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ADD READINESS",
				"shortname": "READINESS",
				"utility_props": {
					"metric": RESOURCE.METRICS.READINESS,
				}				
			}
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_RMV_METRIC_MORALE:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "REMOVE MORALE",
				"shortname": "MORALE",
				"utility_props": {
					"remove_metric": RESOURCE.METRICS.MORALE,
				}
			}
		ROOM.REF.UTIL_RMV_METRIC_SAFETY:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "REMOVE SAFETY",
				"shortname": "SAFETY",
				"utility_props": {
					"remove_metric": RESOURCE.METRICS.SAFETY,
				}
			}
		ROOM.REF.UTIL_RMV_METRIC_READINESS:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "REMOVE READINESS",
				"shortname": "READINESS",
				"utility_props": {
					"remove_metric": RESOURCE.METRICS.READINESS,
				}
			}

			
			
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_BUFF_EFFECT_1:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "BUFF1",
				"shortname": "FX1",
				"utility_props": {
					"effect": ROOM.EFFECTS.EFFECT_1
				}				
			}
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_BUFF_EFFECT_2:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "BUFF2",
				"shortname": "FX2",
				"utility_props": {
					"effect": ROOM.EFFECTS.EFFECT_2
				}				
			}					
			
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_DEBUFF_EFFECT_1:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "DEBUFF1",
				"shortname": "FX1",
				"utility_props": {
					"effect": ROOM.EFFECTS.EFFECT_1
				}				
			}
			
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_DEBUFF_EFFECT_2:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "DEBUFF2",
				"shortname": "FX2",
				"utility_props": {
					"effect": ROOM.EFFECTS.EFFECT_2
				}				
			}						

	room_data.requires_unlock = false
	room_data.own_limit = 20
	room_data.required_staffing = []
	room_data.required_energy = 0
	room_data.img_src = "res://Media/rooms/admin_section.png"
	room_data.ref = ref
	return room_data
