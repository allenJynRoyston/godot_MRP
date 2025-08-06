extends Node

# ------------------------------------------------------------------------------
func calc_starting_data() -> Dictionary:
	var store_data:Array = OS_STORE.data
	var os_setting:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].os_setting	
	var starting_data_copy:Dictionary = starting_data.duplicate(true)
	
	# add any purchases to the starting data
	for list_index in store_data.size():
		var list_item:Dictionary = store_data[list_index]
		for index in list_item.list.size():
			var uid:String = str(list_index, index)
			var item:Dictionary = list_item.list[index]
			var is_unlocked:bool = item.is_unlocked.call(os_setting)
			if is_unlocked and uid in os_setting.store_purchases:
				starting_data_copy = item.effect.call(starting_data_copy)
	
	return starting_data_copy
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var starting_data:Dictionary = {	
	"starting_resources": {
		RESOURCE.CURRENCY.MONEY: 5,
		RESOURCE.CURRENCY.SCIENCE: 3,
		RESOURCE.CURRENCY.MATERIAL: 3,
		RESOURCE.CURRENCY.CORE: 3
	},		
	"resources": {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.CORE: 0
	},	
	"diff": {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.CORE: 0
	},
	"starting_personnel": {
		RESEARCHER.SPECIALIZATION.ADMIN: 3,
		RESEARCHER.SPECIALIZATION.RESEARCHER: 2,
		RESEARCHER.SPECIALIZATION.SECURITY: 1,
		RESEARCHER.SPECIALIZATION.DCLASS: 0,
	},		
	"personnel": {
		RESEARCHER.SPECIALIZATION.ADMIN: 0,
		RESEARCHER.SPECIALIZATION.RESEARCHER: 0,
		RESEARCHER.SPECIALIZATION.SECURITY: 0,
		RESEARCHER.SPECIALIZATION.DCLASS: 0,
	},
	"starting_personnel_capacity": {
		RESEARCHER.SPECIALIZATION.ADMIN: 5,
		RESEARCHER.SPECIALIZATION.RESEARCHER: 5,
		RESEARCHER.SPECIALIZATION.SECURITY: 5,
		RESEARCHER.SPECIALIZATION.DCLASS: 5,
	},
	"personnel_capacity": {
		RESEARCHER.SPECIALIZATION.ADMIN: 0,
		RESEARCHER.SPECIALIZATION.RESEARCHER: 0,
		RESEARCHER.SPECIALIZATION.SECURITY: 0,
		RESEARCHER.SPECIALIZATION.DCLASS: 0,
	},	
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var data:Array[Dictionary] = [
	{
		"category": "ECONOMY",
		"list": [
			# ---------------------------
			{
				"details": {
					"name": "MONEY +1",
				},
				"cost": 1,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.resources[RESOURCE.CURRENCY.MONEY] += 1
					return starting_data,
				"hint": {
					"description": "Start with extra MONEY.",
					"icon": SVGS.TYPE.MONEY
				}
			},
			# ---------------------------
			{
				"details": {
					"name": "RESEARCH +1",
				},
				"cost": 1,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.resources[RESOURCE.CURRENCY.SCIENCE] += 1
					return starting_data,
				"hint": {
					"description": "Start with extra RESEARCH.",
					"icon": SVGS.TYPE.RESEARCH
				}
			},
			# ---------------------------
			{
				"details": {
					"name": "MATERIAL +1",
				},
				"cost": 1,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.resources[RESOURCE.CURRENCY.MATERIAL] += 1
					return starting_data,
				"hint": {
					"description": "Start with extra MATERIAL.",
					"icon": SVGS.TYPE.RING
				}
			},
			# ---------------------------
			{
				"details": {
					"name": "CORE +1",
				},
				"cost": 1,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.resources[RESOURCE.CURRENCY.CORE] += 1
					return starting_data,
				"hint": {
					"description": "start with extra CORE.",
					"icon": SVGS.TYPE.GLOBAL
				}					
			}
			# ---------------------------
		]
	},
	# --------------------------------------------------------------------------
	{
		"category": "INCOME",
		"list": [
			# ---------------------------
			{
				"details": {
					"name": "MONEY +1",
				},
				"cost": 1,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.diff[RESOURCE.CURRENCY.MONEY] += 1
					return starting_data,
				"hint": {
					"description": "Earn extra MONEY.",
					"icon": SVGS.TYPE.MONEY
				}
			},
			# ---------------------------
			{
				"details": {
					"name": "RESEARCH +1",
				},
				"cost": 1,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.diff[RESOURCE.CURRENCY.SCIENCE] += 1
					return starting_data,
				"hint": {
					"description": "Earn extra RESEARCH.",
					"icon": SVGS.TYPE.RESEARCH
				}
			},
			# ---------------------------
			{
				"details": {
					"name": "MATERIAL +1",
				},
				"cost": 1,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.diff[RESOURCE.CURRENCY.MATERIAL] += 1
					return starting_data,
				"hint": {
					"description": "Earn extra MATERIAL.",
					"icon": SVGS.TYPE.RING
				}
			},
			# ---------------------------
			{
				"details": {
					"name": "CORE +1",
				},
				"cost": 25,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.diff[RESOURCE.CURRENCY.CORE] += 1
					return starting_data,
				"hint": {
					"description": "Earn extra CORE.",
					"icon": SVGS.TYPE.GLOBAL
				}
			}
			# ---------------------------
		]
	},
	# --------------------------------------------------------------------------
	{
		"category": "PERSONNEL",
		"list": [
			# ---------------------------
			{
				"details": {
					"name": "ADDITIONAL ADMIN",
				},
				"cost": 5,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.personnel[RESEARCHER.SPECIALIZATION.ADMIN] += 1
					return starting_data,
				"hint": {
					"description": "Add an extra +1 to ADMIN personnel.",
					"icon": SVGS.TYPE.STAFF
				}
			},
			# ---------------------------
			{
				"details": {
					"name": "ADDITIONAL RESEARCHER",
				},
				"cost": 5,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.personnel[RESEARCHER.SPECIALIZATION.RESEARCHER] += 1
					return starting_data,
				"hint": {
					"description": "Add an extra +1 to RESEARCHER personnel.",
					"icon": SVGS.TYPE.STAFF
				}
			},
			# ---------------------------
			{
				"details": {
					"name": "ADDITIONAL SECURITY",
				},
				"cost": 5,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.personnel[RESEARCHER.SPECIALIZATION.SECURITY] += 1
					return starting_data,
				"hint": {
					"description": "Add an extra +1 to SECURITY personnel.",
					"icon": SVGS.TYPE.STAFF
				}
			},
			# ---------------------------
			{
				"details": {
					"name": "ADDITIONAL DCLASS",
				},
				"cost": 5,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.personnel[RESEARCHER.SPECIALIZATION.DCLASS] += 1
					return starting_data,
				"hint": {
					"description": "Add an extra +1 to DCLASS personnel.",
					"icon": SVGS.TYPE.STAFF
				}
			}
			# ---------------------------
		]
	},
	# --------------------------------------------------------------------------
	{
		"category": "P. CAPACITY",
		"list": [
			# ---------------------------
			{
				"details": {
					"name": "ADDITIONAL ADMIN",
				},
				"cost": 5,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.personnel_capacity[RESEARCHER.SPECIALIZATION.ADMIN] += 1
					return starting_data,
				"hint": {
					"description": "Start with an extra +1 to ADMIN personnel capacity.",
					"icon": SVGS.TYPE.STAFF
				}
			},
			# ---------------------------
			{
				"details": {
					"name": "ADDITIONAL RESEARCHER",
				},
				"cost": 25,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.personnel_capacity[RESEARCHER.SPECIALIZATION.RESEARCHER] += 1
					return starting_data,
				"hint": {
					"description": "Start with an extra +1 to RESEARCHER personnel capacity.",
					"icon": SVGS.TYPE.STAFF
				}
			},
			# ---------------------------
			{
				"details": {
					"name": "ADDITIONAL SECURITY",
				},
				"cost": 5,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.personnel_capacity[RESEARCHER.SPECIALIZATION.SECURITY] += 1
					return starting_data,
				"hint": {
					"description": "Start with an extra +1 to SECURITY personnel capacity.",
					"icon": SVGS.TYPE.STAFF
				}
			},
			# ---------------------------
			{
				"details": {
					"name": "ADDITIONAL DCLASS",
				},
				"cost": 5,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.personnel_capacity[RESEARCHER.SPECIALIZATION.DCLASS] += 1
					return starting_data,
				"hint": {
					"description": "Start with an extra +1 to DCLASS personnel capacity.",
					"icon": SVGS.TYPE.STAFF
				}
			}
			# ---------------------------
		]
	}			
]
# ------------------------------------------------------------------------------
