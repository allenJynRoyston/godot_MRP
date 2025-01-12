extends Node


var RESEARCH_ONE:Dictionary = {
	"name": "RESEARCH ONE",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "Research item goes here...",
	"get_build_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 10
		},
	"get_build_time": func() -> int:
		return 3,		
}


var RESEARCH_TWO:Dictionary = {
	"name": "RESEARCH TWO",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "Research item goes here...",
	"get_build_cost": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 10
		},
	"get_build_time": func() -> int:
		return 3,		
}


var tier_data:Dictionary = {
	TIER.VAL.ZERO: {
		"id": TIER.VAL.ZERO,
		"name": "RD ZERO",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 0,
			},
	},
	TIER.VAL.ONE: {
		"id": TIER.VAL.ONE,
		"name": "RD ONE",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 5,
			},
	},
	TIER.VAL.TWO: {
		"id": TIER.VAL.TWO,
		"name": "RD TWO",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 100,
			},
	},
	TIER.VAL.THREE: {
		"id": TIER.VAL.THREE,
		"name": "RD THREE",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 250,
			},
	},
	TIER.VAL.FOUR: {
		"id": TIER.VAL.FOUR,
		"name": "RD FOUR",
		"get_unlock_cost": func() -> Dictionary:
			return {
				RESOURCE.TYPE.MONEY: 500,
			},
	},
}

var reference_data:Dictionary = {
	RD.TYPE.RD_ONE: RESEARCH_ONE,
	RD.TYPE.RD_TWO: RESEARCH_TWO
}

# ------------------------------------------------------------------------------
func get_tier_item(id:TIER.VAL) -> Dictionary:
	return tier_data[id]
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
func return_build_cost(id:int) -> Array:
	var rd_data:Dictionary = return_data(id)
	var list:Array = []
	if "get_build_cost" in rd_data:
		var dict:Dictionary = rd_data.get_build_cost.call()
		for key in dict:	
			var amount:int = dict[key]
			list.push_back({
				"amount": amount, 
				"resource": RESOURCE_UTIL.return_data(key)
			})
			
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
