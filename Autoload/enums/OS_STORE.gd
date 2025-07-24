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
	"diff": {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.CORE: 0
	},
	"resources": {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.CORE: 0
	},
	"personnel": {
		RESEARCHER.SPECIALIZATION.ADMIN: 0,
		RESEARCHER.SPECIALIZATION.RESEARCHER: 0,
		RESEARCHER.SPECIALIZATION.SECURITY: 0,
		RESEARCHER.SPECIALIZATION.DCLASS: 0,
	}
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
					"name": "MONEY +100",
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.resources[RESOURCE.CURRENCY.MONEY] += 100
					return starting_data,
			},
			# ---------------------------
			{
				"details": {
					"name": "RESEARCH +50",
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.resources[RESOURCE.CURRENCY.SCIENCE] += 50
					return starting_data,
			},
			# ---------------------------
			{
				"details": {
					"name": "MATERIAL +25",
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.resources[RESOURCE.CURRENCY.MATERIAL] += 25
					return starting_data,
			},
			# ---------------------------
			{
				"details": {
					"name": "CORE +5",
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.resources[RESOURCE.CURRENCY.CORE] += 5
					return starting_data,
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
					"name": "MONEY +50",
				},
				"cost": 25,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.diff[RESOURCE.CURRENCY.MONEY] += 50
					return starting_data,
			},
			# ---------------------------
			{
				"details": {
					"name": "RESEARCH +25",
				},
				"cost": 25,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.diff[RESOURCE.CURRENCY.SCIENCE] += 25
					return starting_data,
			},
			# ---------------------------
			{
				"details": {
					"name": "MATERIAL +10",
				},
				"cost": 25,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.diff[RESOURCE.CURRENCY.MATERIAL] += 10
					return starting_data,
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
				"cost": 25,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.personnel[RESEARCHER.SPECIALIZATION.ADMIN] += 5
					return starting_data,
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
					starting_data.personnel[RESEARCHER.SPECIALIZATION.RESEARCHER] += 5
					return starting_data,
			},
			# ---------------------------
			{
				"details": {
					"name": "ADDITIONAL SECURITY",
				},
				"cost": 25,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.personnel[RESEARCHER.SPECIALIZATION.SECURITY] += 5
					return starting_data,
			},
			# ---------------------------
			{
				"details": {
					"name": "ADDITIONAL DCLASS",
				},
				"cost": 25,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"effect": func(starting_data:Dictionary) -> Dictionary:
					starting_data.personnel[RESEARCHER.SPECIALIZATION.DCLASS] += 5
					return starting_data,
			}
			# ---------------------------
		]
	}		
]
# ------------------------------------------------------------------------------
