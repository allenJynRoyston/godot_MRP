@tool
extends Node

var STARTING_BASE:Dictionary = {
	"name": "BASE HQ",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Base headquarters.",
	"can_contain": false,
	
	"prerequisites": [

	],		
	"placement_restrictions": {

	},
	"own_limit": func() -> int:
		return 1,
	"get_build_time": func() -> int:
		return 1,

	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: 0
				},
		}	
	},
	
	"build_complete": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.STAFF: 10,
					RESOURCE.TYPE.SECURITY: 10,
					RESOURCE.TYPE.DCLASS: 10
				},
			"capacity": func() -> Dictionary:
				return {
					RESOURCE.TYPE.STAFF: 10,
					RESOURCE.TYPE.SECURITY: 10,
					RESOURCE.TYPE.DCLASS: 10
				},			
		}	
	},	
	
	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -5,
					RESOURCE.TYPE.MONEY: -5
				},
			
		}	
	}
}

var R_AND_D_LAB:Dictionary = {
	"name": "R & D LAB",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Enables research and development.",
	"can_contain": false,
	
	"prerequisites": [
		ROOM.TYPE.STARTING_BASE
	],	
		
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

	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
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
					RESOURCE.TYPE.STAFF: 20
				},			
		}	
	},	
	
	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -5,
					RESOURCE.TYPE.MONEY: -5
				},
			
		}	
	}
}

var CONSTRUCTION_YARD:Dictionary = {
	"name": "CONSTRUCTION YARD",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/construction_yard.jpg",
	"description": "Enables base development.",
	"can_contain": false,
	
	"prerequisites": [
		ROOM.TYPE.STARTING_BASE
	],	
		
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

	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -30
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
	
	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -5
				},
		}	
	}

}

var BARRICKS:Dictionary = {
	"name": "BARRICKS",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/barricks.jpg",
	"description": "Houses security forces.",
	"can_contain": false,
	
	"prerequisites": [
		ROOM.TYPE.STARTING_BASE
	],	
		
	"placement_restrictions": {

	},
	"own_limit": func() -> int:
		return 10,	
	"get_build_time": func() -> int:
		return 3,

	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -40
				},
		}	
	},
	
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.DCLASS: -1,
					RESOURCE.TYPE.STAFF: -1,
					RESOURCE.TYPE.SECURITY: -5
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
					RESOURCE.TYPE.SECURITY: 20
				},			
		}	
	},	
	
	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -10
				},
		}	
	}

}


var DORMITORY:Dictionary = {
	"name": "DORMITORY",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/images/redacted.png",
	"description": "Houses facility staff.",
	"can_contain": false,
	
	"prerequisites": [
		ROOM.TYPE.STARTING_BASE
	],	
		
	"placement_restrictions": {

	},
	"own_limit": func() -> int:
		return 10,	
	"get_build_time": func() -> int:
		return 3,

	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
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
					RESOURCE.TYPE.STAFF: 20
				},			
		}	
	},	
	
	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -10
				},
		}	
	}

}

var HOLDING_CELLS:Dictionary = {
	"name": "HOLDING CELLS",
	"tier": TIER.VAL.TWO,
	"img_src": "res://Media/images/redacted.png",
	"description": "Houses D-class personel.",
	"can_contain": false,
	
	"prerequisites": [
		ROOM.TYPE.STARTING_BASE
	],		
	
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

	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
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
					RESOURCE.TYPE.DCLASS: 20
				},			
		}	
	},	
	
	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -5
				},
		}	
	}

}


var STANDARD_LOCKER:Dictionary = {
	"name": "STANDARD_LOCKER",
	"tier": TIER.VAL.ONE,
	"img_src": "res://Media/images/redacted.png",
	"description": "A basic room with a high security lock.",
	"can_contain": true,
	
	"prerequisites": [
		ROOM.TYPE.STARTING_BASE
	],		
	"placement_restrictions": {
		"floor": [
			ROOM.PLACEMENT.SURFACE
		],
	},
	"own_limit": func() -> int:
		return 10,	
	"get_build_time": func() -> int:
		return 3,
	

	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -5
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
	
	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	}

}

var reference_data:Dictionary = {
	ROOM.TYPE.STARTING_BASE: STARTING_BASE,
	ROOM.TYPE.R_AND_D_LAB: R_AND_D_LAB,
	ROOM.TYPE.CONSTRUCTION_YARD: CONSTRUCTION_YARD,
	ROOM.TYPE.BARRICKS: BARRICKS,
	ROOM.TYPE.DORMITORY: DORMITORY,
	ROOM.TYPE.HOLDING_CELLS: HOLDING_CELLS,
	ROOM.TYPE.STANDARD_LOCKER: STANDARD_LOCKER
}

var tier_data:Dictionary = {
	TIER.VAL.ZERO: {
		"name": "SURFACE",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 0,
			},
	},
	TIER.VAL.ONE: {
		"name": "BASIC",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 5,
			},
	},
	TIER.VAL.TWO: {
		"name": "ADVANCED",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 50,
			},
	},
	TIER.VAL.THREE: {
		"name": "METAPHYSICAL",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 250,
			},
	},
	TIER.VAL.FOUR: {
		"name": "TECHNOLOGICAL",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 500,
			},
	},
}



# ------------------------------------------------------------------------------
func return_tier_data(key:TIER.VAL) -> Dictionary:
	tier_data[key].ref = key
	return tier_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_data(key:int) -> Dictionary:
	reference_data[key].ref = key
	return reference_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_placement_instructions(id:int) -> Array:
	return SHARED_UTIL.return_placement_instructions(return_data(id))
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_unavailable_rooms(id:int, room_config:Dictionary) -> Array: 
	return SHARED_UTIL.return_unavailable_rooms(return_data(id), room_config)
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
func return_operating_cost(id:int) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(id), "operating_costs")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_activation_cost(id:int) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(id), "activation_cost")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_purchase_cost(ref:int, resources_data:Dictionary, add:bool = false) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "purchase_costs", resources_data, add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_build_complete(ref:int, resources_data:Dictionary, add:bool = true) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "build_complete", resources_data, !add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_operating_costs(ref:int, resources_data:Dictionary, add:bool = true) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "operating_costs", resources_data, add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_activation_cost(ref:int, resources_data:Dictionary, refund:bool = false) -> Dictionary:	
	var room_data:Dictionary = return_data(ref)
	var resource_data_copy:Dictionary = resources_data.duplicate(true)

	if "activation_cost" in room_data:
		var activation_costs:Dictionary = room_data.activation_cost.resources.amount.call()
		for key in activation_costs:
			var val:int = activation_costs[key]
			if refund:
				resource_data_copy[key].utilized -= val
				resource_data_copy[key].amount += val
				if resource_data_copy[key].amount > resources_data[key].capacity:
					resource_data_copy[key].amount = resources_data[key].capacity
			else:
				resource_data_copy[key].utilized += val
				resource_data_copy[key].amount -= val
				if resource_data_copy[key].amount < 0:
					resource_data_copy[key].amount = 0
	
	return resource_data_copy
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
func get_count(ref:ROOM.TYPE, arr:Array) -> int:
	return arr.filter(func(i):return i.ref == ref).size()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_tier_dict() -> Dictionary:
	return SHARED_UTIL.return_tier_dict(tier_data)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_paginated_list(tier:TIER.VAL, start_at:int, limit:int, purchased_facility_arr:Array) -> Dictionary:
	var facility_refs:Array = U.array_find_uniques(purchased_facility_arr.map(func(i): return i.ref))
	var res:Dictionary = SHARED_UTIL.return_tier_paginated(reference_data, tier, start_at, limit)
	#res.list = res.list.filter(func(i):
		#return true if i.details.prerequisites.is_empty() else U.array_has_overlap(i.details.prerequisites, facility_refs)
	#)
	
	return res
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func has_prerequisites(ref:ROOM.TYPE, arr:Array) -> bool:
	var room_data:Dictionary = return_data(ref)
	return	false
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func at_own_limit(ref:ROOM.TYPE, arr:Array, action_queue_data:Array) -> bool:
	var room_data:Dictionary = return_data(ref)
	var owned_count:int = arr.filter(func(i): return i.ref == ref).size()
	var in_progress_count:int = action_queue_data.filter(func(i): return i.ref == ref and i.action == ACTION.PURCHASE.FACILITY_ITEM).size()
	
	if room_data.own_limit.call() == -1:
		return false
	else: 
		return (owned_count + in_progress_count) >= room_data.own_limit.call()
# ------------------------------------------------------------------------------
