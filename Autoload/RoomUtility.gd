@tool
extends Node

var BARRICKS:Dictionary = {
	"name": "BARRICKS",
	"image_src": "res://Media/rooms/barricks.jpg",
	"description": "Houses security forces.",
	"size_allowed": [1, 2, 3],
	"categories": [
		ROOM.CATEGORIES.SECURITY
	],
	"can_contain": false,
	"get_build_time": func() -> int:
		return 3,
	"get_resource_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 2
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
	"description": "Description",
	"size_allowed": [1, 2, 3],
	"categories": [
		ROOM.CATEGORIES.CAN_CONTAIN
	],	
	"can_contain": true,
	"get_build_time": func() -> int:
		return 3,	
}

var DORMITORY:Dictionary = {
	"name": "DORMITORY",
	"description": "Houses foundation staff.",
	"size_allowed": [1, 2, 3],
	"categories": [
		ROOM.CATEGORIES.STAFF
	],		
	"get_build_time": func() -> int:
		return 3,
}

var HOLDING_CELLS:Dictionary = {
	"name": "HOLDING CELLS",
	"description": "Houses D-Class personel.",
	"size_allowed": [1, 2, 3],
	"categories": [
		ROOM.CATEGORIES.DCLASS
	],			
	"get_build_time": func() -> int:
		return 3,
}


var reference_data:Dictionary = {
	ROOM.TYPE.BARRICKS: BARRICKS,
	ROOM.TYPE.DORMITORY: DORMITORY,
	ROOM.TYPE.HOLDING_CELLS: HOLDING_CELLS,
	ROOM.TYPE.STEEL_CONTAINMENT_CELL: STEEL_CONTAINMENT_CELL,
}

var category_data:Dictionary = {
	ROOM.CATEGORIES.CAN_CONTAIN: {
		"name": "Containable",
	},
	ROOM.CATEGORIES.SECURITY: {
		"name": "Security"
	},
	ROOM.CATEGORIES.STAFF: {
		"name": "Staff"
	},	
	ROOM.CATEGORIES.DCLASS: {
		"name": "DClass"
	}
}

# ------------------------------------------------------------------------------
func get_categories() -> Dictionary:
	var list:Array = []
	for id in category_data:
		list.push_back({
			"id": id, "details": category_data[id] 
		})
		
	return {"list": list}
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func get_rooms(active_filters:Array = [], start_at:int = 0, limit:int = 10) -> Dictionary:
	var list:Array = []
	for id in reference_data:
		var details:Dictionary = reference_data[id] 
		if active_filters.is_empty():
			list.push_back({
				"id": id, 
				"details": details
			})			
		else:
			for category in details.categories:
				if category in active_filters:
					list.push_back({
						"id": id, 
						"details": details
					})
	
	var paginated_array:Array = U.paginate_array(list, start_at, limit)
	
	return {"list": paginated_array, "size": list.size(), "has_more": list.size() > (paginated_array.size() + start_at)}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_data(key:int) -> Dictionary:
	return reference_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_requirements(id:int) -> Array:
	var room_data:Dictionary = return_data(id)
	return room_data.get_requirements.call() if "get_requirements" in room_data else []	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_resource_cost(id:int) -> Array:
	var room_data:Dictionary = return_data(id)
	var list:Array = []
	if "get_resource_cost" in room_data:
		var dict:Dictionary = room_data.get_resource_cost.call()
		for key in dict:	
			var amount:int = dict[key]
			list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
			
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_resource_capacity(id:int) -> Array:
	var room_data:Dictionary = return_data(id)
	var list:Array = []
	if "get_resource_capacity" in room_data:
		var dict:Dictionary = room_data.get_resource_capacity.call()
		for key in dict:	
			var amount:int = dict[key]
			list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
			
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_resource_amount(id:int) -> Array:
	var room_data:Dictionary = return_data(id)
	var list:Array = []
	if "get_resource_amount" in room_data:
		var dict:Dictionary = room_data.get_resource_amount.call()
		for key in dict:	
			var amount:int = dict[key]
			list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
			
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calc_resource_cost(id:int, resources_data:Dictionary, refund:bool = false) -> Dictionary:		
	var room_data:Dictionary = return_data(id)
	var resources_data_duplicate:Dictionary = resources_data.duplicate(true)
	if "get_resource_cost" in room_data:
		var dict:Dictionary = room_data.get_resource_cost.call()		
		for key in dict:
			var amount:int = dict[key]
			if refund:
				resources_data_duplicate[key].amount += amount	
			else:
				resources_data_duplicate[key].amount -= amount	

	return resources_data_duplicate
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calc_resource_capacity(id:int, resources_data:Dictionary, refund:bool = false) -> Dictionary:	
	var room_data:Dictionary = return_data(id)
	var resources_data_duplicate:Dictionary = resources_data.duplicate(true)
	if "get_resource_capacity" in room_data:
		var dict:Dictionary = room_data.get_resource_capacity.call()
		for key in dict:
			var amount:int = dict[key]
			if refund:
				resources_data_duplicate[key].capacity -= amount	
			else:
				resources_data_duplicate[key].capacity += amount	
	return resources_data_duplicate
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calc_resource_amount(id:int, resources_data:Dictionary, refund:bool = false) -> Dictionary:	
	var room_data:Dictionary = return_data(id)
	var resources_data_duplicate:Dictionary = resources_data.duplicate(true)
	if "get_resource_amount" in room_data:
		var dict:Dictionary = room_data.get_resource_amount.call()
		for key in dict:
			var amount:int = dict[key]
			if refund:
				resources_data_duplicate[key].amount -= amount	
				if resources_data_duplicate[key].amount < 0:
					resources_data_duplicate[key].amount = 0
			else:
				resources_data_duplicate[key].amount += amount	
				if resources_data_duplicate[key].amount > resources_data_duplicate[key].capacity:
					resources_data_duplicate[key].amount = resources_data_duplicate[key].capacity
			
	return resources_data_duplicate
# ------------------------------------------------------------------------------
	
