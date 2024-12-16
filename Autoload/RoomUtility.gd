@tool
extends Node

var BARRICKS:Dictionary = {
	"name": "BARRICKS",
	"size_allowed": [1, 2, 3],
	"can_contain": false,
	"get_build_time": func() -> int:
		return 3,
	"get_resource_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 2,
		},
	"get_resource_capacity": func() -> Dictionary:
		return {
			RESOURCE.TYPE.SECURITY: 10,
		},
	"get_resource_amount": func() -> Dictionary:
		return {
			RESOURCE.TYPE.ENERGY: 5
		},		
}

# can this work?
var STEEL_CONTAINMENT_CELL:Dictionary = {
	"name": "STEEL LINED",
	"size_allowed": [1, 2, 3],
	"can_contain": true,
}

var DORMITORY:Dictionary = {
	"name": "DORMITORY",
	"build_time": 2,

}

var HOLDING_CELLS:Dictionary = {
	"name": "HOLDING CELLS",
	"build_time": 2,
}


var reference_data:Dictionary = {
	ROOM.TYPE.BARRICKS: BARRICKS,
	ROOM.TYPE.HOLDING_CELLS: HOLDING_CELLS,
	ROOM.TYPE.DORMITORY: DORMITORY,
}

# ------------------------------------------------------------------------------
func return_data(key:int) -> Dictionary:
	return reference_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_requirements(room_id:int) -> Array:
	var room_data:Dictionary = return_data(room_id)
	return room_data.get_requirements.call() if "get_requirements" in room_data else []	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_resource_capacity(room_id:int) -> Array:
	var room_data:Dictionary = return_data(room_id)
	var list:Array = []
	if "get_resource_capacity" in room_data:
		var dict:Dictionary = room_data.get_resource_capacity.call()
		for key in dict:	
			var amount:int = dict[key]
			list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
			
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_resource_amount(room_id:int) -> Array:
	var room_data:Dictionary = return_data(room_id)
	var list:Array = []
	if "get_resource_amount" in room_data:
		var dict:Dictionary = room_data.get_resource_amount.call()
		for key in dict:	
			var amount:int = dict[key]
			list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
			
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calc_resource_cost(room_id:int, resources_data:Dictionary) -> Dictionary:		
	var room_data:Dictionary = return_data(room_id)
	var resources_data_duplicate:Dictionary = resources_data.duplicate(true)
	if "get_resource_cost" in room_data:
		var dict:Dictionary = room_data.get_resource_cost.call()		
		for key in dict:
			var amount:int = dict[key]
			resources_data_duplicate[key].amount -= amount	

	return resources_data_duplicate
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calc_resource_capacity(room_id:int, resources_data:Dictionary) -> Dictionary:	
	var room_data:Dictionary = return_data(room_id)
	var resources_data_duplicate:Dictionary = resources_data.duplicate(true)
	if "get_resource_capacity" in room_data:
		var dict:Dictionary = room_data.get_resource_capacity.call()
		for key in dict:
			var amount:int = dict[key]
			resources_data_duplicate[key].capacity += amount	
	return resources_data_duplicate
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calc_resource_amount(room_id:int, resources_data:Dictionary) -> Dictionary:	
	var room_data:Dictionary = return_data(room_id)
	var resources_data_duplicate:Dictionary = resources_data.duplicate(true)
	if "get_resource_amount" in room_data:
		var dict:Dictionary = room_data.get_resource_amount.call()
		for key in dict:
			var amount:int = dict[key]
			resources_data_duplicate[key].amount += amount	
			if resources_data_duplicate[key].amount > resources_data_duplicate[key].capacity:
				resources_data_duplicate[key].amount = resources_data_duplicate[key].capacity
			
	return resources_data_duplicate
# ------------------------------------------------------------------------------
	
