extends UtilityWrapper


var RESEARCH_ONE:Dictionary = {
	"name": "RESEARCH ONE",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "Research item goes here...",

	"get_build_time": func() -> int:
		return 3,		
		
	"purchase_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -10
				},
		}	
	},		
}


var RESEARCH_TWO:Dictionary = {
	"name": "RESEARCH TWO",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "Research item goes here...",
	"get_build_time": func() -> int:
		return 3,		
		
	"purchase_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -100
				},
		}	
	},				
}

#
#var tier_data:Dictionary = {
	#TIER.VAL.ZERO: {
		#"name": "RD ZERO",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 0,
			#},
	#},
	#TIER.VAL.ONE: {
		#"name": "RD ONE",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 5,
			#},
	#},
	#TIER.VAL.TWO: {
		#"name": "RD TWO",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 100,
			#},
	#},
	#TIER.VAL.THREE: {
		#"name": "RD THREE",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 250,
			#},
	#},
	#TIER.VAL.FOUR: {
		#"name": "RD FOUR",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 500,
			#},
	#},
#}

var reference_data:Dictionary = {
	RD.TYPE.RD_ONE: RESEARCH_ONE,
	RD.TYPE.RD_TWO: RESEARCH_TWO
}

#
## ------------------------------------------------------------------------------
#func return_tier_data(key:TIER.VAL) -> Dictionary:
	#tier_data[key].ref = key
	#return tier_data[key]
## ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_data(key:int) -> Dictionary:
	reference_data[key].ref = key
	return reference_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_purchase_cost(id:int) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(id), "purchase_cost")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_purchase_cost(ref:int, add:bool = false) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "purchase_cost", resources_data, add)
# ------------------------------------------------------------------------------

## ------------------------------------------------------------------------------
#func get_tier_dict() -> Dictionary:
	#return SHARED_UTIL.return_tier_dict(tier_data)
## ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_paginated_list(tier:TIER.VAL = TIER.VAL.ZERO, start_at:int = 0, limit:int = 10) -> Dictionary:
	return SHARED_UTIL.return_tier_paginated(reference_data, tier, start_at, limit)
# ------------------------------------------------------------------------------
