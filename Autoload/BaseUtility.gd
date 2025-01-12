extends Node


var UNLOCK_FLOOR_2:Dictionary = {
	"ref": BASE.TYPE.UNLOCK_FLOOR_2,
	"name": "UNLOCK FLOOR 2",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "Research item goes here...",
	"get_build_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.ENERGY: 1,
			RESOURCE.TYPE.MONEY: 1
		},
	"get_build_time": func() -> int:
		return 3,		
}


var UNLOCK_FLOOR_3:Dictionary = {
	"ref": BASE.TYPE.UNLOCK_FLOOR_3,
	"name": "UNLOCK FLOOR 3",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "Research item goes here...",
	"get_build_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.ENERGY: 1,
			RESOURCE.TYPE.MONEY: 1
		},
	"get_build_time": func() -> int:
		return 3,		
}


var tier_data:Dictionary = {
	TIER.VAL.ZERO: {
		"id": TIER.VAL.ZERO,
		"name": "BASE ZERO",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 0,
			},
	},
	TIER.VAL.ONE: {
		"id": TIER.VAL.ONE,
		"name": "BASE ONE",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 5,
			},
	},
	TIER.VAL.TWO: {
		"id": TIER.VAL.TWO,
		"name": "BASE TWO",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 100,
			},
	},
	TIER.VAL.THREE: {
		"id": TIER.VAL.THREE,
		"name": "BASE THREE",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 250,
			},
	},
	TIER.VAL.FOUR: {
		"id": TIER.VAL.FOUR,
		"name": "BASE FOUR",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 500,
			},
	},
}

var reference_data:Dictionary = {
	BASE.TYPE.UNLOCK_FLOOR_2: UNLOCK_FLOOR_2,
	BASE.TYPE.UNLOCK_FLOOR_3: UNLOCK_FLOOR_3
}

# ------------------------------------------------------------------------------
func get_tier_item(id:TIER.VAL) -> Dictionary:
	return tier_data[id]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_count(id:BASE.TYPE, arr:Array) -> int:
	return arr.filter(func(i):return i.data.id == id).size()
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func get_tier_data() -> Dictionary:
	var list:Array = []
	for id in tier_data:
		list.push_back({
			"id": id, 
			"details": tier_data[id]
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
	
	return {
		"list": paginated_array, 
		"size": list.size(), 
		"has_more": list.size() > (paginated_array.size() + start_at)
	}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_data(key:int) -> Dictionary:
	return reference_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_unavailable_placement(id:int, room_config:Dictionary) -> Array: 
	var unavailable_list:Array = []
	var room_data:Dictionary = return_data(id)

	for floor_index in room_config.floor.size():
		for ring_index in room_config.floor[floor_index].ring.size():
			for room_index in room_config.floor[floor_index].ring[ring_index].room.size():
				var designation:String = "%s%s%s" % [floor_index, ring_index, room_index]
				var config_data:Dictionary = room_config.floor[floor_index].ring[ring_index].room[room_index]				
				if ring_index not in room_data.placement or !config_data.room_data.is_empty() or !config_data.build_data.is_empty():
					unavailable_list.push_back(designation)
	
	return unavailable_list
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
	var rd_data:Dictionary = return_data(id)
	var resources_data_duplicate:Dictionary = resources_data.duplicate(true)
	if "get_build_cost" in rd_data:
		var dict:Dictionary = rd_data.get_build_cost.call()		
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
