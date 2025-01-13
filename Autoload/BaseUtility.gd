extends Node


var UNLOCK_FLOOR_2:Dictionary = {
	"ref": BASE.TYPE.UNLOCK_FLOOR_2,
	"name": "UNLOCK FLOOR 2",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "Research item goes here...",

	"get_build_time": func() -> int:
		return 3,		

	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: 25
				},
		}	
	},
	
	"build_complete": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					
				},
			"capacity": func() -> Dictionary:
				return {
					
				},			
		}	
	},		
}


var UNLOCK_FLOOR_3:Dictionary = {
	"ref": BASE.TYPE.UNLOCK_FLOOR_3,
	"name": "UNLOCK FLOOR 3",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "Research item goes here...",

	"get_build_time": func() -> int:
		return 3,		
		
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: 50
				},
		}	
	},
	
	"build_complete": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					
				},
			"capacity": func() -> Dictionary:
				return {
					
				},			
		}	
	},		
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
func return_purchase_cost(id:int) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(id), "purchase_costs")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_build_complete(id:int) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(id), "build_complete")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_purchase_cost(ref:int, resources_data:Dictionary, add:bool = true) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "purchase_costs", resources_data, add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_build_complete(ref:int, resources_data:Dictionary, add:bool = true) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "build_complete", resources_data, add)
# ------------------------------------------------------------------------------
