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
	var list:Array = []
	
	if "floor_blacklist" in room_data.placement_restrictions:
		var title:String = "Can NOT be built on %s " % ["the " if room_data.placement_restrictions.floor_blacklist.size() == 1 else "floors"] 
		for index in room_data.placement_restrictions.floor_blacklist.size():
			var key:int = room_data.placement_restrictions.floor_blacklist[index]
			var last_in_list:bool = index == room_data.placement_restrictions.floor_blacklist.size() - 1
			var key_str:String = ""
			match key:
				ROOM.PLACEMENT.SURFACE:
					key_str = "SURFACE"
				ROOM.PLACEMENT.B1:
					key_str = "B1"
				ROOM.PLACEMENT.B2:
					key_str = "B2"	
				ROOM.PLACEMENT.B3:
					key_str = "B3"
				ROOM.PLACEMENT.B4:
					key_str = "B4"
				ROOM.PLACEMENT.B5:
					key_str = "B5"
			title += "%s" % [str("[", key_str, "]", '.') if last_in_list else str("[", key_str, "] ")]
		list.push_back({
			"title": title, "is_checked": func(current_location:Dictionary) -> bool:
				return current_location.floor not in room_data.placement_restrictions.floor_blacklist
		})	
		
	if "ring_blacklist" in room_data.placement_restrictions:
		var title:String = "Can NOT be built in %s " % ["the " if room_data.placement_restrictions.ring_blacklist.size() == 1 else "rings"] 
		for index in room_data.placement_restrictions.ring_blacklist.size():
			var key:int = room_data.placement_restrictions.ring_blacklist[index]
			var last_in_list:bool = index == room_data.placement_restrictions.ring_blacklist.size() - 1
			var key_str:String = ""
			match key:
				ROOM.PLACEMENT.RING_A:
					key_str = "RING A"
				ROOM.PLACEMENT.RING_B:
					key_str = "RING B"
				ROOM.PLACEMENT.RING_A:
					key_str = "RING C"	
			title += "%s" % [str("[", key_str, "]", '.') if last_in_list else str("[", key_str, "] ")]
		list.push_back({
			"title": title, "is_checked": func(current_location:Dictionary) -> bool:
				return current_location.floor not in room_data.placement_restrictions.ring_blacklist
		})			
	
	if "floor" in room_data.placement_restrictions:
		var title:String = "Can be built on %s " % ["the " if room_data.placement_restrictions.floor.size() == 1 else "floors"] 
		for index in room_data.placement_restrictions.floor.size():
			var key:int = room_data.placement_restrictions.floor[index]
			var last_in_list:bool = index == room_data.placement_restrictions.floor.size() - 1
			var key_str:String = ""
			match key:
				ROOM.PLACEMENT.SURFACE:
					key_str = "SURFACE"
				ROOM.PLACEMENT.B1:
					key_str = "B1"
				ROOM.PLACEMENT.B2:
					key_str = "B2"	
				ROOM.PLACEMENT.B3:
					key_str = "B3"
				ROOM.PLACEMENT.B4:
					key_str = "B4"
				ROOM.PLACEMENT.B5:
					key_str = "B5"
			title += "%s" % [str("[", key_str, "]", '.') if last_in_list else str("[", key_str, "] ")]
		list.push_back({
			"title": title, "is_checked": func(current_location:Dictionary) -> bool:
				return current_location.floor in room_data.placement_restrictions.floor
		})
		
	if "ring" in room_data.placement_restrictions:
		var title:String = "Can be built in %s " % ["ring" if room_data.placement_restrictions.ring.size() == 1 else "rings"] 
		for index in room_data.placement_restrictions.ring.size():
			var key:int = room_data.placement_restrictions.ring[index]
			var last_in_list:bool = index == room_data.placement_restrictions.ring.size() - 1
			var key_str:String = ""
			match key:
				ROOM.PLACEMENT.RING_A:
					key_str = "RING A"
				ROOM.PLACEMENT.RING_B:
					key_str = "RING B"
				ROOM.PLACEMENT.RING_A:
					key_str = "RING C"	
			title += "%s" % [str("[", key_str, "]", '.') if last_in_list else str("[", key_str, "] ")]
		list.push_back({
			"title": title, "is_checked": func(current_location:Dictionary) -> bool:
				return current_location.ring in room_data.placement_restrictions.ring
		})		
		
	if "room" in room_data.placement_restrictions:
		var title:String = "Can be built in %s " % ["room" if room_data.placement_restrictions.room.size() == 1 else "rooms"] 
		for index in room_data.placement_restrictions.room.size():
			var key:int = room_data.placement_restrictions.room[index]
			var last_in_list:bool = index == room_data.placement_restrictions.room.size() - 1
			var key_str:String = ""
			match key:
				ROOM.PLACEMENT.R1:
					key_str = "ROOM 1"
				ROOM.PLACEMENT.R2:
					key_str = "ROOM 2"
				ROOM.PLACEMENT.R3:
					key_str = "ROOM 3"
				ROOM.PLACEMENT.R4:
					key_str = "ROOM 4"
				ROOM.PLACEMENT.R5:
					key_str = "ROOM 5"
			title += "%s" % [str("[", key_str, "]", '.') if last_in_list else str("[", key_str, "] ")]
		list.push_back({
			"title": title, "is_checked": func(current_location:Dictionary) -> bool:
				return current_location.room in room_data.placement_restrictions.room
		})	
	return list
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
				var placement_restrictions:Dictionary = room_data.placement_restrictions
				
				# check for blacklists
				if "floor_blacklist" in room_data.placement_restrictions:
					if floor_index in room_data.placement_restrictions.floor_blacklist:
						if designation not in unavailable_list:
							unavailable_list.push_back(designation)
				if "ring_blacklist" in room_data.placement_restrictions:
					if ring_index in room_data.placement_restrictions.ring_blacklist:
						if designation not in unavailable_list:
							unavailable_list.push_back(designation)
				if "room_blacklist" in room_data.placement_restrictions:
					if room_index in room_data.placement_restrictions.room_blacklist:
						if designation not in unavailable_list:
							unavailable_list.push_back(designation)				
							
				# check for individual f/r/ro			
				if "floor" in room_data.placement_restrictions:
					if floor_index not in room_data.placement_restrictions.floor:
						if designation not in unavailable_list:
							unavailable_list.push_back(designation)
				if "ring" in room_data.placement_restrictions:
					if ring_index not in room_data.placement_restrictions.ring:
						if designation not in unavailable_list:
							unavailable_list.push_back(designation)
				if "room" in room_data.placement_restrictions:
					if room_index not in room_data.placement_restrictions.room:
						if designation not in unavailable_list:
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
	
