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
	
	# ------------------------------------------
	"metrics": {
		"wing": {
			RESOURCE.BASE_METRICS.MORALE: 2,
			RESOURCE.BASE_METRICS.READINESS: 2,
			RESOURCE.BASE_METRICS.SAFETY: 2,
		}
	},
	# ------------------------------------------	

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -2
				},
		}	
	},
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
		"resources": {
			"amount": func() -> Dictionary:
				return {

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
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	}	
	# ------------------------------------------
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
		return 1,

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
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
	# ------------------------------------------
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

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
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
	# ------------------------------------------
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

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					
				},
			"capacity": func() -> Dictionary:
				return {
					RESOURCE.TYPE.SECURITY: 10
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
	# ------------------------------------------
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

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
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
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	}	
	# ------------------------------------------
	

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

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					
				},
			"capacity": func() -> Dictionary:
				return {
					RESOURCE.TYPE.DCLASS: 10
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
	# ------------------------------------------
}

var HR_DEPARTMENT:Dictionary = {
	"name": "HUMAN RESOURCES DEPARTMENT",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/images/redacted.png",
	"description": "Enables recruitment of key staff.",
	"can_contain": false,
	
	"prerequisites": [
		ROOM.TYPE.STARTING_BASE
	],		
	
	"placement_restrictions": {

	},
	"own_limit": func() -> int:
		return 1,	
	"get_build_time": func() -> int:
		return 5,

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
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
	# ------------------------------------------
}

var HUME_DETECTOR:Dictionary = {
	"name": "HUME DETECTOR",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/images/redacted.png",
	"description": "Makes hume levels visible.",
	"can_contain": false,
	
	"prerequisites": [
		
	],		
	
	"placement_restrictions": {

	},
	"own_limit": func() -> int:
		return 4,	
	"get_build_time": func() -> int:
		return 3,

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -5,
				},
		}	
	},		
	
	"activation_effect": {
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
	# ------------------------------------------
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
	

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
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
	# ------------------------------------------

}

var reference_data:Dictionary = {
	ROOM.TYPE.STARTING_BASE: STARTING_BASE,
	ROOM.TYPE.R_AND_D_LAB: R_AND_D_LAB,
	ROOM.TYPE.CONSTRUCTION_YARD: CONSTRUCTION_YARD,
	ROOM.TYPE.BARRICKS: BARRICKS,
	ROOM.TYPE.DORMITORY: DORMITORY,
	ROOM.TYPE.HR_DEPARTMENT: HR_DEPARTMENT,
	ROOM.TYPE.HOLDING_CELLS: HOLDING_CELLS,
	ROOM.TYPE.STANDARD_LOCKER: STANDARD_LOCKER,
	
	ROOM.TYPE.HUME_DETECTOR: HUME_DETECTOR,
	
}

var tier_data:Dictionary = {
	TIER.VAL.ZERO: {
		"name": "ADMIN",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 0,
			},
	},
	TIER.VAL.ONE: {
		"name": "CONTAINMENT",
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
func return_data(ref:ROOM.TYPE) -> Dictionary:
	reference_data[ref].ref = ref
	return reference_data[ref]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_placement_instructions(ref:ROOM.TYPE) -> Array:
	return SHARED_UTIL.return_placement_instructions(return_data(ref))
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_unavailable_rooms(ref:ROOM.TYPE, room_config:Dictionary) -> Array: 
	return SHARED_UTIL.return_unavailable_rooms(return_data(ref), room_config)
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func return_purchase_cost(ref:ROOM.TYPE) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "purchase_costs")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_activation_effect(ref:ROOM.TYPE) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "activation_effect")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_operating_cost(ref:ROOM.TYPE) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "operating_costs")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_activation_cost(ref:ROOM.TYPE) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "activation_cost")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_purchase_cost(ref:ROOM.TYPE, resources_data:Dictionary, add:bool = false) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "purchase_costs", resources_data, add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_activation_effect(ref:ROOM.TYPE, resources_data:Dictionary, add:bool = true) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "activation_effect", resources_data, !add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_operating_costs(ref:ROOM.TYPE, resources_data:Dictionary, add:bool = true) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "operating_costs", resources_data, add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_activation_cost(ref:ROOM.TYPE, resources_data:Dictionary, refund:bool = false) -> Dictionary:	
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
func return_effects(ref:ROOM.TYPE) -> Array:
	return SHARED_UTIL.return_effects(return_data(ref))
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

# ------------------------------------------------------------------------------
func extract_room_details(floor:int, ring:int, room:int, room_config:Dictionary, resources_data:Dictionary) -> Dictionary:
	var room_config_data:Dictionary = room_config.floor[floor].ring[ring].room[room]
	var can_purchase:bool = room_config_data.build_data.is_empty() and room_config_data.room_data.is_empty()
	var room_under_construction:bool  = !room_config_data.build_data.is_empty()
	var has_room:bool = !room_config_data.room_data.is_empty()
	
	var room_details:Dictionary = room_config_data.room_data.get_room_details.call() if has_room else {}
	var is_activated:bool = room_config_data.room_data.get_is_activated.call() if has_room else false
	var is_disabled:bool = (!RESOURCE_UTIL.check_if_have_enough(ROOM_UTIL.return_activation_cost(room_config_data.room_data.ref), resources_data) if !is_activated else false) if has_room else false
	var scp_data:Dictionary = room_config_data.scp_data if has_room else {}	
	var can_store_scp:bool = room_details.can_contain if has_room else false
	var scp_details:Dictionary = (room_config_data.scp_data.get_scp_details.call() if !scp_data.is_empty() else {}) if has_room else {}

	var no_scp_data:bool = scp_data.is_empty() if can_store_scp else true
	var is_transfer:bool = (false if no_scp_data else room_config_data.scp_data.is_transfer) if can_store_scp else false
	var is_contained:bool = (false if no_scp_data else room_config_data.scp_data.is_contained) if can_store_scp else false	
	var testing_details:Dictionary = ({} if no_scp_data else room_config_data.scp_data.get_testing_details.call()) if can_store_scp else {}
	var is_testing:bool = !testing_details.is_empty()
	var testing_ref:int =  -1 if !is_testing else testing_details.testing_ref
	var is_accessing:bool = false if !is_testing else testing_details.testing_ref == -1
	var testing_progress:int = -1 if !is_testing else testing_details.progress
	
	var researcher_details:Dictionary = {} if scp_data.is_empty() else scp_data.get_researcher_details.call()
	var has_researcher:bool = !researcher_details.is_empty()
	 
	return {
		"room": {
			"has_room": has_room,
			"room_under_construction": room_under_construction,
			"room_details": room_details if !room_under_construction else ROOM_UTIL.return_data(room_config_data.build_data.ref),
			"is_activated": is_activated,
			"is_disabled": is_disabled,
			},
		"scp": {
			"can_store_scp": can_store_scp,
			"scp_details": scp_details,
			"is_transfer": is_transfer,
			"is_contained": is_contained,
			"testing": {
				"is_accessing": is_accessing,
				"testing_ref": testing_ref,
				"progress": testing_progress
			} if is_testing else {}
		} if !no_scp_data else {},
		"researcher": {
			"details": researcher_details
		} if has_researcher else {}
	}
# ------------------------------------------------------------------------------	
