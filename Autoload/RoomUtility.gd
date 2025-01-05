@tool
extends Node

var R_AND_D_LAB:Dictionary = {
	"name": "R & D LAB",
	"tier": TIER.VAL.ZERO,
	"image_src": "res://Media/rooms/barricks.jpg",
	"description": "Enables research and development.",
	"placement_restrictions": {
		"floor": [
			ROOM.PLACEMENT.SURFACE,
			ROOM.PLACEMENT.B1
		],
		"ring": [
			ROOM.PLACEMENT.RING_A, 
			ROOM.PLACEMENT.RING_B
		]
	},
	"own_limit": func() -> int:
		return 3,
	"get_build_time": func() -> int:
		return 2,
	"get_build_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 2
		},
	"get_operating_income": func() -> Dictionary:
		return {

		},				
	"get_operating_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 1,
		},		
	"get_resource_capacity": func() -> Dictionary:
		return {
			
		},
	"get_resource_amount": func() -> Dictionary:
		return {

		},		
}

var CONSTRUCTION_YARD:Dictionary = {
	"name": "CONSTRUCTION YARD",
	"tier": TIER.VAL.ZERO,
	"image_src": "res://Media/rooms/barricks.jpg",
	"description": "Enables base development.",
	"placement_restrictions": {
		"floor": [
			ROOM.PLACEMENT.SURFACE
		],
		"ring": [
			ROOM.PLACEMENT.RING_C
		]
	},
	"own_limit": func() -> int:
		return 1,	
	"get_build_time": func() -> int:
		return 5,
	"get_build_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 2
		},
	"get_operating_income": func() -> Dictionary:
		return {

		},				
	"get_operating_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 1,
		},		
	"get_resource_capacity": func() -> Dictionary:
		return {
			
		},
	"get_resource_amount": func() -> Dictionary:
		return {

		},		
}

var BARRICKS:Dictionary = {
	"name": "BARRICKS",
	"tier": TIER.VAL.ZERO,
	"image_src": "res://Media/rooms/barricks.jpg",
	"description": "Houses security forces.",
	"placement_restrictions": {
		"floor": [
			ROOM.PLACEMENT.SURFACE
		],
		"ring": [
			ROOM.PLACEMENT.RING_A
		]
	},
	"own_limit": func() -> int:
		return 10,	
	"get_build_time": func() -> int:
		return 3,
	"get_build_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 2
		},
	"get_operating_income": func() -> Dictionary:
		return {

		},				
	"get_operating_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 1,
		},		
	"get_resource_capacity": func() -> Dictionary:
		return {
			RESOURCE.TYPE.SECURITY: 10,
		},
	"get_resource_amount": func() -> Dictionary:
		return {

		},		
}


var DORMITORY:Dictionary = {
	"name": "DORMITORY",
	"tier": TIER.VAL.ONE,
	"image_src": "res://Media/images/redacted.png",
	"description": "Houses facility staff.",
	"placement_restrictions": {
		"floor": [
			ROOM.PLACEMENT.SURFACE
		],
		"ring": [
			ROOM.PLACEMENT.RING_B
		]
	},
	"own_limit": func() -> int:
		return 10,	
	"get_build_time": func() -> int:
		return 3,
	"get_build_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 2
		},
	"get_operating_income": func() -> Dictionary:
		return {

		},				
	"get_operating_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 1,
		},		
	"get_resource_capacity": func() -> Dictionary:
		return {
			RESOURCE.TYPE.STAFF: 10,
		},
	"get_resource_amount": func() -> Dictionary:
		return {

		},
}

var HOLDING_CELLS:Dictionary = {
	"name": "HOLDING CELLS",
	"tier": TIER.VAL.TWO,
	"image_src": "res://Media/images/redacted.png",
	"description": "Houses D-class personel.",
	"placement_restrictions": {
		"floor": [
			ROOM.PLACEMENT.SURFACE
		],
		"ring": [
			ROOM.PLACEMENT.RING_A
		]
	},
	"own_limit": func() -> int:
		return 10,	
	"get_build_time": func() -> int:
		return 3,
	"get_build_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 2
		},
	"get_operating_income": func() -> Dictionary:
		return {

		},				
	"get_operating_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 1,
		},		
	"get_resource_capacity": func() -> Dictionary:
		return {
			RESOURCE.TYPE.DCLASS: 10,
		},
	"get_resource_amount": func() -> Dictionary:
		return {
			
		},
}


var STANDARD_LOCKER:Dictionary = {
	"name": "STANDARD_LOCKER",
	"tier": TIER.VAL.ONE,
	"image_src": "res://Media/images/redacted.png",
	"description": "A basic room with a high security lock.",
	"placement_restrictions": {
		"floor_blacklist": [
			ROOM.PLACEMENT.SURFACE
		],
		"ring_blacklist": [
			ROOM.PLACEMENT.RING_A
		]
	},
	"own_limit": func() -> int:
		return 10,	
	"get_build_time": func() -> int:
		return 3,
	"get_build_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 2
		},
	"get_operating_income": func() -> Dictionary:
		return {

		},				
	"get_operating_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 1,
		},		
	"get_resource_capacity": func() -> Dictionary:
		return {
			RESOURCE.TYPE.DCLASS: 10,
		},
	"get_resource_amount": func() -> Dictionary:
		return {
			
		},
}



var reference_data:Dictionary = {
	ROOM.TYPE.R_AND_D_LAB: R_AND_D_LAB,
	ROOM.TYPE.CONSTRUCTION_YARD: CONSTRUCTION_YARD,
	ROOM.TYPE.BARRICKS: BARRICKS,
	ROOM.TYPE.DORMITORY: DORMITORY,
	ROOM.TYPE.HOLDING_CELLS: HOLDING_CELLS,
	ROOM.TYPE.STANDARD_LOCKER: STANDARD_LOCKER
}

var tier_data:Dictionary = {
	TIER.VAL.ZERO: {
		"id": TIER.VAL.ZERO,
		"name": "SURFACE",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 0,
			},
	},
	TIER.VAL.ONE: {
		"id": TIER.VAL.ONE,
		"name": "BASIC",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 5,
			},
	},
	TIER.VAL.TWO: {
		"id": TIER.VAL.TWO,
		"name": "ADVANCED",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 50,
			},
	},
	TIER.VAL.THREE: {
		"id": TIER.VAL.THREE,
		"name": "METAPHYSICAL",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 250,
			},
	},
	TIER.VAL.FOUR: {
		"id": TIER.VAL.FOUR,
		"name": "TECHNOLOGICAL",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 500,
			},
	},
}

# ------------------------------------------------------------------------------
func at_own_limit(id:ROOM.TYPE, arr:Array, action_queue_data:Array) -> bool:
	var room_data:Dictionary = return_data(id)
	var owned_count:int = arr.filter(func(i): return i.data.id == id).size()
	var in_progress_count:int = action_queue_data.filter(func(i): return i.data.id == id and i.action == ACTION.BUILD_ITEM).size()
	
	if room_data.own_limit.call() == -1:
		return false
	else: 
		return (owned_count + in_progress_count) >= room_data.own_limit.call()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_count(id:ROOM.TYPE, arr:Array) -> int:
	return arr.filter(func(i):return i.data.id == id).size()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_tier_item(id:TIER.VAL) -> Dictionary:
	return tier_data[id]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_tier_data() -> Dictionary:
	var list:Array = []
	for id in tier_data:
		list.push_back({
			"id": id, "details": tier_data[id] 
		})
	return {"list": list}	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_list(tier:TIER.VAL = TIER.VAL.ZERO, start_at:int = 0, limit:int = 10) -> Dictionary:
	var list:Array = []
	
	for id in reference_data:
		list.push_back({
			"id": id, 
			"details": reference_data[id] 
		})

	# filter for tier
	list = list.filter(func(i): return i.details.tier == tier)
	
	var paginated_array:Array = U.paginate_array(list, start_at, limit)
	
	return {"list": paginated_array, "size": list.size(), "has_more": list.size() > (paginated_array.size() + start_at)}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_data(key:int) -> Dictionary:
	return reference_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_placement_instructions(id:int) -> Array:
	var room_data:Dictionary = return_data(id)
	return SHARED_UTIL.return_placement_instructions(room_data)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_unavailable_placement(id:int, room_config:Dictionary) -> Array: 
	var room_data:Dictionary = return_data(id)
	return SHARED_UTIL.return_unavailable_placement(room_data, room_config)
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func return_build_cost(id:int) -> Array:
	var details:Dictionary = return_data(id)
	var list:Array = []
	if "get_build_cost" in details:
		var dict:Dictionary = details.get_build_cost.call()
		for key in dict:	
			var amount:int = dict[key]
			list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
			
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_operating_income(id:int) -> Array:
	var details:Dictionary = return_data(id)
	var list:Array = []
	if "get_operating_income" in details:
		var dict:Dictionary = details.get_operating_income.call()
		for key in dict:	
			var amount:int = dict[key]
			list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
			
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_operating_cost(id:int) -> Array:
	var details:Dictionary = return_data(id)
	var list:Array = []
	if "get_operating_cost" in details:
		var dict:Dictionary = details.get_operating_cost.call()
		for key in dict:	
			var amount:int = dict[key]
			list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
			
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_resource_capacity(id:int) -> Array:
	var details:Dictionary = return_data(id)
	var list:Array = []
	if "get_resource_capacity" in details:
		var dict:Dictionary = details.get_resource_capacity.call()
		for key in dict:	
			var amount:int = dict[key]
			list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
			
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_resource_amount(id:int) -> Array:
	var details:Dictionary = return_data(id)
	var list:Array = []
	if "get_resource_amount" in details:
		var dict:Dictionary = details.get_resource_amount.call()
		for key in dict:	
			var amount:int = dict[key]
			list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
			
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calc_build_cost(id:int, resources_data:Dictionary, refund:bool = false) -> Dictionary:		
	var details:Dictionary = return_data(id)
	var resources_data_duplicate:Dictionary = resources_data.duplicate(true)
	if "get_build_cost" in details:
		var dict:Dictionary = details.get_build_cost.call()		
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
	var details:Dictionary = return_data(id)
	var resources_data_duplicate:Dictionary = resources_data.duplicate(true)
	if "get_resource_capacity" in details:
		var dict:Dictionary = details.get_resource_capacity.call()
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
	var details:Dictionary = return_data(id)
	var resources_data_duplicate:Dictionary = resources_data.duplicate(true)
	if "get_resource_amount" in details:
		var dict:Dictionary = details.get_resource_amount.call()
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
	
