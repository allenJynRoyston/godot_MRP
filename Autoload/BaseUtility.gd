extends SubscribeWrapper

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

#
#var tier_data:Dictionary = {
	#TIER.VAL.ZERO: {
		#"name": "BASE ZERO",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 0,
			#},
	#},
	#TIER.VAL.ONE: {
		#"name": "BASE ONE",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 5,
			#},
	#},
	#TIER.VAL.TWO: {
		#"name": "BASE TWO",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 100,
			#},
	#},
	#TIER.VAL.THREE: {
		#"name": "BASE THREE",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 250,
			#},
	#},
	#TIER.VAL.FOUR: {
		#"name": "BASE FOUR",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 500,
			#},
	#},
#}

var reference_data:Dictionary = {
	BASE.TYPE.UNLOCK_FLOOR_2: UNLOCK_FLOOR_2,
	BASE.TYPE.UNLOCK_FLOOR_3: UNLOCK_FLOOR_3
}

## ------------------------------------------------------------------------------
#func return_tier_data(key:TIER.VAL) -> Dictionary:
	#tier_data[key].ref = key
	#return tier_data[key]
## ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_count(ref:BASE.TYPE, arr:Array) -> int:
	return arr.filter(func(i):return i.data.ref == ref).size()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_data(key:int) -> Dictionary:
	return reference_data[key]
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
func calculate_purchase_cost(ref:int, add:bool = false) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "purchase_costs", resources_data, add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_build_complete(ref:int, add:bool = true) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "build_complete", resources_data, add)
# ------------------------------------------------------------------------------
#
## ------------------------------------------------------------------------------
#func get_tier_dict() -> Dictionary:
	#return SHARED_UTIL.return_tier_dict(tier_data)
## ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_paginated_list(tier:TIER.VAL = TIER.VAL.ZERO, start_at:int = 0, limit:int = 10) -> Dictionary:
	var filter:Callable = func(list) -> void:
		return list.filter(func(i): return i.details.tier == tier)		
	return SHARED_UTIL.return_tier_paginated(reference_data, filter, start_at, limit)
# ------------------------------------------------------------------------------
