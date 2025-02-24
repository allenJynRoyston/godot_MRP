@tool
extends UtilityWrapper

var DIRECTORS_OFFICE:Dictionary = {
	"name": "DIRECTORS OFFICE",
	"shortname": "D.OFFICE",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "The site directors office.",
	"can_contain": true,
	
	"prerequisites": [

	],		
	"placement_restrictions": {

	},
	"own_limit": func() -> int:
		return 1,
	"get_build_time": func() -> int:
		return 1,
	

	# ------------------------------------------
	"wing_effect": func(extract_data:Dictionary) -> Dictionary:				
		return {
			RESOURCE.BASE_METRICS.SAFETY: -1
		},
	# ------------------------------------------

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					
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
	
	#"activation_effect": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
#
				#},
			#"capacity": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.STAFF: 10,
					#RESOURCE.TYPE.SECURITY: 10,
					#RESOURCE.TYPE.DCLASS: 10
				#},			
		#}	
	#},	
	
	"operating_costs": {
		"resources": {
			"metrics": func() -> Dictionary:
				return {
					RESOURCE.BASE_METRICS.SAFETY: -1
			},			
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	}	
	# ------------------------------------------
}

var HQ:Dictionary = {
	"name": "HEADQUARTERS",
	"shortname": "HQ",
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
	"name": "R&D LAB",
	"shortname": "R&D LAB",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Enables research and development.",
	"can_contain": false,
	
	"prerequisites": [
		ROOM.TYPE.HQ
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
	"shortname": "C.YARD",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/construction_yard.jpg",
	"description": "Enables base development.",
	"can_contain": false,
	
	"prerequisites": [
		ROOM.TYPE.HQ
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
	"shortname": "BARRICKS",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/barricks.jpg",
	"description": "Houses security forces.",
	"can_contain": false,
	
	"prerequisites": [
		ROOM.TYPE.HQ
	],	
		
	"placement_restrictions": {

	},
	"own_limit": func() -> int:
		return 10,	
	"get_build_time": func() -> int:
		return 3,

	# ------------------------------------------
	"wing_effect": func(extract_data:Dictionary) -> Dictionary:				
		return {
			RESOURCE.BASE_METRICS.SAFETY: 3 if extract_data.room.is_activated else 0
		},
	# ------------------------------------------

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
			"metrics": func() -> Dictionary:
				return {
					RESOURCE.BASE_METRICS.SAFETY: 3
				},			
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
	"shortname": "DORM",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/images/redacted.png",
	"description": "Houses facility staff.",
	"can_contain": false,
	
	"prerequisites": [
		ROOM.TYPE.HQ
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
	"shortname": "H CELLS",
	"tier": TIER.VAL.TWO,
	"img_src": "res://Media/images/redacted.png",
	"description": "Houses D-class personel.",
	"can_contain": false,
	
	"prerequisites": [
		ROOM.TYPE.HQ
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
	"shortname": "HR DEPT",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/images/redacted.png",
	"description": "Enables recruitment of key staff.",
	"can_contain": false,
	
	"prerequisites": [
		ROOM.TYPE.HQ
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
	"shortname": "HUME DET",
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
	"shortname": "S.LOCKER",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/images/redacted.png",
	"description": "A basic room with a high security lock.",
	"can_contain": true,
	
	"prerequisites": [
		ROOM.TYPE.HQ
	],		
	"placement_restrictions": {
		"floor": [
			ROOM.PLACEMENT.SURFACE
		],
	},
	"own_limit": func() -> int:
		return 10,	
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
			"metrics": func() -> Dictionary:
				return {
					RESOURCE.BASE_METRICS.SAFETY: 2
			},
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	},
	# ------------------------------------------	
	"specilization_bonus": func(specilizations:Array) -> Dictionary:
		if RESEARCHER.SPECIALIZATION.BIOLOGIST in specilizations:
			return {
				"resource":{
					RESOURCE.TYPE.ENERGY: 2
				},
			}
		if RESEARCHER.SPECIALIZATION.PSYCHOLOGY in specilizations:
			return {
				"metrics":{
					RESOURCE.BASE_METRICS.MORALE: 1
				}
			}
		return {},
	# ------------------------------------------
}

var reference_data:Dictionary = {
	ROOM.TYPE.DIRECTORS_OFFICE: DIRECTORS_OFFICE,
	ROOM.TYPE.HQ: HQ,
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
	return SHARED_UTIL.return_unavailable_rooms(return_data(ref))
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
func return_specilization_bonus(ref:ROOM.TYPE, specilizations:Array) -> Array:
	var data:Dictionary = return_data(ref)	
	var list:Array = []
	
	if "specilization_bonus" in data:
		var spec_bonus:Dictionary = data.specilization_bonus.call(specilizations)
		if "resource" in spec_bonus:
			for key in spec_bonus.resource:
				list.push_back({"type": "amount", "amount": spec_bonus.resource[key], "resource": RESOURCE_UTIL.return_data(key)})	
		if "metrics" in spec_bonus:
			for key in spec_bonus.metrics:
				list.push_back({"type": "metrics", "amount": spec_bonus.metrics[key], "resource": RESOURCE_UTIL.return_metric_data(key)})	
	return list
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
func return_wing_effects_list(room_extract:Dictionary) -> Array:
	return SHARED_UTIL.return_wing_effects_list(return_data(room_extract.room.details.ref), room_extract, "activation_effect")
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------		
func return_wing_effect(extract_data:Dictionary) -> Dictionary:
	var room_data:Dictionary = return_data(extract_data.room.details.ref)
	if "wing_effect" in room_data:
		return room_data.wing_effect.call(extract_data)
	
	return {}
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------
func has_prerequisites(ref:ROOM.TYPE, arr:Array) -> bool:
	var room_data:Dictionary = return_data(ref)
	return	false
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func at_own_limit(ref:ROOM.TYPE) -> bool:
	var room_data:Dictionary = return_data(ref)
	var owned_count:int = purchased_facility_arr.filter(func(i): return i.ref == ref).size()
	var in_progress_count:int = timeline_array.filter(func(i): return i.ref == ref and i.action == ACTION.PURCHASE.FACILITY_ITEM).size()
	var total_count:int = owned_count + in_progress_count
	
	if "own_limit" not in room_data or room_data.own_limit.call() == -1:
		return false
		
	return total_count >= room_data.own_limit.call()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func extract_room_details(current_location:Dictionary, use_config:Dictionary = room_config) -> Dictionary:
	var designation:String = U.location_to_designation(current_location)
	var floor:int = current_location.floor
	var ring:int = current_location.ring
	var room:int = current_location.room

	var floor_data:Dictionary = use_config.floor[floor]
	var wing_data:Dictionary = use_config.floor[floor].ring[ring]
	var room_config_data:Dictionary = use_config.floor[floor].ring[ring].room[room]
	
	var can_purchase:bool = room_config_data.build_data.is_empty() and room_config_data.room_data.is_empty()
	var is_room_under_construction:bool  = !room_config_data.build_data.is_empty()
	var is_room_empty:bool = room_config_data.room_data.is_empty()
	
	var room_details:Dictionary = room_config_data.room_data.get_room_details.call() if !is_room_empty else {}
	var is_activated:bool = room_config_data.room_data.get_is_activated.call() if !is_room_empty else false
	var can_activate:bool = (RESOURCE_UTIL.check_if_have_enough(ROOM_UTIL.return_activation_cost(room_config_data.room_data.ref), resources_data) if !is_activated else false) if !is_room_empty else false
	var can_contain:bool = room_details.can_contain if !room_details.is_empty() else false

	var scp_data:Dictionary = room_config_data.scp_data 
	var is_scp_empty:bool = scp_data.is_empty()
	var scp_details:Dictionary = room_config_data.scp_data.get_scp_details.call() if !scp_data.is_empty() else {}
	var is_transfer:bool = false if is_scp_empty else room_config_data.scp_data.is_transfer
	var is_contained:bool = false if is_scp_empty else room_config_data.scp_data.is_contained
	
	var researchers:Array = hired_lead_researchers_arr.filter(func(x):
		var details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(x[0])
		if (!details.props.assigned_to_room.is_empty() and U.location_to_designation(details.props.assigned_to_room) == designation):
			return true
		return false	
	).map(func(x):return RESEARCHER_UTIL.return_data_with_uid(x[0]))
	
	# tracks 
	var resource_details:Dictionary = {
		# captures just for room
		"room": {},
		# all resources for scp
		"scp": {},
		# 
		"researchers": {},
		# combines room, scp and researchers 
		"facility": {},
		#
		"traits": {},
		"synergy_traits": {},
		"total": {},
	}
	var metric_details:Dictionary = {
		# captures just for room
		"room": {},
		# all resources for scp
		"scp": {},
		# 
		"researchers": {},
		# combines room, scp and researchers 
		"facility": {},
		#
		"traits": {},
		"synergy_traits": {},
		"total": {},
	}
	

	# get resources spent/added by rooms
	if !is_room_empty:
		for item in return_operating_cost(room_details.ref):
			# -----------------------
			if item.type == "amount":
				if item.resource.ref not in resource_details.room:
					resource_details.room[item.resource.ref] = 0
				if item.resource.ref not in resource_details.facility:
					resource_details.facility[item.resource.ref] = 0
				if item.resource.ref not in resource_details.total:
					resource_details.total[item.resource.ref] = 0
				resource_details.room[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
				resource_details.facility[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
				resource_details.total[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
			# -----------------------
			if item.type == "metrics":
				if item.resource.ref not in metric_details.room:
					metric_details.room[item.resource.ref] = 0
				if item.resource.ref not in metric_details.facility:
					metric_details.facility[item.resource.ref] = 0
				if item.resource.ref not in metric_details.total:
					metric_details.total[item.resource.ref] = 0

				metric_details.room[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
				metric_details.facility[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
				metric_details.total[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
				
	
	# get resources spent/added by scp
	if !is_scp_empty:
		for item in SCP_UTIL.return_ongoing_containment_rewards(scp_details.ref):
			# -----------------------
			if item.type == "amount":
				if item.resource.ref not in resource_details.scp:
					resource_details.scp[item.resource.ref] = 0
				if item.resource.ref not in resource_details.facility:
					resource_details.facility[item.resource.ref] = 0
				if item.resource.ref not in resource_details.total:
					resource_details.total[item.resource.ref] = 0
					
				resource_details.facility[item.resource.ref] += item.amount if is_contained else 0
				resource_details.scp[item.resource.ref] += item.amount if is_contained else 0
				resource_details.total[item.resource.ref] += item.amount if is_contained else 0
			# -----------------------
			if item.type == "metrics":
				if item.resource.ref not in metric_details.scp:
					metric_details.scp[item.resource.ref] = 0
				if item.resource.ref not in metric_details.facility:
					metric_details.facility[item.resource.ref] = 0
				if item.resource.ref not in metric_details.total:
					metric_details.total[item.resource.ref] = 0

				metric_details.scp[item.resource.ref] += item.amount if is_contained else 0
				metric_details.facility[item.resource.ref] += item.amount if is_contained else 0
				metric_details.total[item.resource.ref] += item.amount if is_contained else 0
	

	var total_traits_list := []
	var synergy_traits := []
	var dup_list := []		
	var trait_list := []
	var synergy_trait_list := []

	for researcher in researchers:
		# records researcher profession bonus (I.E. ECONOMIST, PSYCHOLOGIST, etc)
		if !is_room_empty:
			var spec_bonus:Array = ROOM_UTIL.return_specilization_bonus(room_details.ref, researcher.specializations)
			for item in spec_bonus:
				# -----------------------
				if item.type == "resource":
					if item.resource.ref not in resource_details.researchers:
						resource_details.researchers[item.resource.ref] = 0
					if item.resource.ref not in resource_details.facility:
						resource_details.facility[item.resource.ref] = 0					
					if item.resource.ref not in resource_details.total:
						resource_details.total[item.resource.ref] = 0
						
					resource_details.researchers[item.resource.ref] += item.amount
					resource_details.facility[item.resource.ref] += item.amount
					resource_details.total[item.resource.ref] += item.amount
				# -----------------------
				if item.type == "metrics":
					if item.resource.ref not in metric_details.researchers:
						metric_details.researchers[item.resource.ref] = 0
					if item.resource.ref not in metric_details.facility:
						metric_details.facility[item.resource.ref] = 0					
					if item.resource.ref not in metric_details.total:
						metric_details.total[item.resource.ref] = 0
						
					metric_details.researchers[item.resource.ref] += item.amount
					metric_details.facility[item.resource.ref] += item.amount
					metric_details.total[item.resource.ref] += item.amount					

		# add selected to selected list	
		total_traits_list.push_back(researcher.traits)

	# records bonus from traits
	for traits in total_traits_list:
		for t in traits:
			if t not in dup_list:
				var traits_detail:Dictionary = RESEARCHER_UTIL.return_trait_data(t)
				var effect:Dictionary = traits_detail.get_effect.call({"room_details": room_details, "scp_details": scp_details, "resource_details": resource_details})
				var resource_list:Array = []
				var metric_list:Array = []
				# -------------------
				if "resource" in effect:
					for key in effect.resource:
						var amount:int = effect.resource[key]
						
						if key not in resource_details.traits:
							resource_details.traits[key] = 0
						if key not in resource_details.total:
							resource_details.total[key] = 0
						resource_details.traits[key] += amount
						resource_details.total[key] += amount
						
						resource_list.push_back({"resource": RESOURCE_UTIL.return_data(key), "amount": amount})
				# -------------------
				if "metrics" in effect:
					for key in effect.metrics:
						var amount:int = effect.metrics[key]
						
						if key not in metric_details.traits:
							metric_details.traits[key] = 0
						if key not in metric_details.total:
							metric_details.total[key] = 0
						metric_details.traits[key] += amount
						metric_details.total[key] += amount
						
						metric_list.push_back({"resource": RESOURCE_UTIL.return_metric_data(key), "amount": amount})						
							
				trait_list.push_back({"details": traits_detail, "effect": {"resource_list": resource_list, "metric_list": metric_list}} )
	
	# records bonus from synergy traits
	if total_traits_list.size() == 2:
		var list:Array = RESEARCHER_UTIL.return_trait_synergy(total_traits_list[0], total_traits_list[1])
		for details in list:
			var effect:Dictionary = details.get_effect.call({"room_details": room_details, "scp_details": scp_details, "resource_details": resource_details})
			var resource_list:Array = []
			var metric_list:Array = []
			# -------------------
			if "resource" in effect:
				for key in effect.resource:
					var amount:int = effect.resource[key]
					
					if key not in resource_details.synergy_traits:
						resource_details.synergy_traits[key] = 0
					if key not in resource_details.total:
						resource_details.total[key] = 0
					resource_details.synergy_traits[key] += amount
					resource_details.total[key] += amount
					
					resource_list.push_back({"resource": RESOURCE_UTIL.return_data(key), "amount": amount})
			# -------------------
			if "metrics" in effect:
				for key in effect.metrics:
					var amount:int = effect.metrics[key]

					if key not in metric_details.traits:
						metric_details.traits[key] = 0
					if key not in metric_details.total:
						metric_details.total[key] = 0
					metric_details.traits[key] += amount
					metric_details.total[key] += amount					
					
					metric_list.push_back({"resource": RESOURCE_UTIL.return_metric_data(key), "amount": amount})		
						
			synergy_trait_list.push_back({"details": details, "effect": {"resource_list": resource_list, "metric_list": metric_list}} )
			#
	
	return {
		"floor": floor_data,
		"wing": wing_data,
		# -----
		"is_directors_office": room_details.ref == ROOM.TYPE.DIRECTORS_OFFICE if !room_details.is_empty() else false,
		"is_hq": room_details.ref == ROOM.TYPE.HQ if !room_details.is_empty() else false,
		"is_room_empty": room_details.is_empty(),
		"is_room_under_construction": is_room_under_construction,
		"is_room_active": is_activated,
		"room_category": ROOM.CATEGORY.CONTAINMENT_CELL if (!room_details.is_empty() and room_details.can_contain) else ROOM.CATEGORY.FACILITY,
		# ------		
		"is_scp_empty": is_scp_empty,
		"is_scp_transfering": is_transfer,
		"is_scp_contained": is_contained,
		"is_scp_testing": !is_transfer and is_contained and researchers.size() > 0,
		# ------
		"researchers_count": researchers.size(),
		# -----
		"room": {						
			"details": room_details if !is_room_under_construction else ROOM_UTIL.return_data(room_config_data.build_data.ref),
			"can_contain": can_contain,		
			"is_activated": is_activated,
			"can_activate": can_activate,
		} if !is_room_empty or is_room_under_construction else {},
		"scp": {
			"details": scp_details,
			"is_transfer": is_transfer,
			"is_contained": is_contained,
		} if !is_scp_empty else {},
		"trait_list": trait_list,
		"synergy_trait_list": synergy_trait_list,
		"resource_details": resource_details,
		"metric_details": metric_details,
		"researchers": researchers
	}
# ------------------------------------------------------------------------------	
