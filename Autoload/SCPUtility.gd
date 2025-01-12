extends Node


var THE_DOOR:Dictionary = {
	"item_id": "001",
	"name": "THE DOOR",
	"img_src": "res://Media/scps/the_door.png",
	"offered_on_day": func() -> int:
		return 1,
	"description": [
		{
			SCP.RESEARCH_LVL.INITIAL: "A basic wooden door that remains locked until a human being gets within 3 feet of the door.  Door then opens up to an unknown location.  If a person goes through the door, it then shuts.  That person is never seen again."
		}
	],
	"placement_restrictions": {
		"floor_blacklist": [
			ROOM.PLACEMENT.SURFACE,
		],
		"ring": [
			ROOM.PLACEMENT.RING_A, 
		]
	},
	
	"initial_containment": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: 50,
					RESOURCE.TYPE.STAFF: 5	
				},
			"capacity": func() -> Dictionary:
				return {
					RESOURCE.TYPE.STAFF: 5
				},
		}	
	},
	
	"ongoing_containment": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: 15
				},
			"capacity": func() -> Dictionary:
				return {
					
				},
		}	
	},
	#"on_initial_containment_reward": func() -> Dictionary:
		#return {
			#RESOURCE.TYPE.MONEY: 50,
			#RESOURCE.TYPE.STAFF: 5
		#},
	"ongoing_containment_reward": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 10
		},
	"containment_requirements": func() -> Array:
		return [
			ROOM.TYPE.STANDARD_LOCKER
		],	
	"containment_time": func() -> int:
		return 3,
}

var THE_BOOK:Dictionary = {
	"item_id": "002",
	"name": "THE BOOK",
	"img_src": "res://Media/scps/the_door.png",
	"offered_on_day": func() -> int:
		return 1,
	"description": [
		{
			SCP.RESEARCH_LVL.INITIAL: "A book that reads out the events the reader in real time."
		}
	],
	"placement_restrictions": {
		"floor_blacklist": [
			ROOM.PLACEMENT.SURFACE,
		],
		"ring": [
			ROOM.PLACEMENT.RING_A, 
		]
	},
	
	"initial_containment": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: 20
				},
			"capacity": func() -> Dictionary:
				return {
					
				},
		}	
	},
	
	"ongoing_containment": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: 8
				},
			"capacity": func() -> Dictionary:
				return {
					
				},
		}	
	},
	#"on_initial_containment_reward": func() -> Dictionary:
		#return {
			#RESOURCE.TYPE.MONEY: 50,
			#RESOURCE.TYPE.STAFF: 5
		#},
	"ongoing_containment_reward": func() -> Dictionary:
		return {
			RESOURCE.TYPE.MONEY: 10
		},
	"containment_requirements": func() -> Array:
		return [
			ROOM.TYPE.STANDARD_LOCKER
		],	
	"containment_time": func() -> int:
		return 3,
}


var reference_data:Dictionary = {
	SCP.TYPE.THE_DOOR: THE_DOOR,
	SCP.TYPE.THE_BOOK: THE_BOOK
}

# ------------------------------------------------------------------------------
func return_data(key:int) -> Dictionary:
	reference_data[key].ref = key
	return reference_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_initial_containment_amount(id:int) -> Array:
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
func return_initial_containment_rewards(id:int) -> Array:
	var details:Dictionary = return_data(id)
	var list:Array = []
	
	if "initial_containment" in details and "resources" in details.initial_containment:
		if "amount" in details.initial_containment.resources:
			var dict:Dictionary = details.initial_containment.resources.amount.call()
			for key in dict:	
				var amount:int = dict[key]
				list.push_back({
					"type": "amount",
					"amount": amount, 
					"resource": RESOURCE_UTIL.return_data(key)
				})
		if "capacity" in details.initial_containment.resources:
			var dict:Dictionary = details.initial_containment.resources.capacity.call()
			for key in dict:	
				var amount:int = dict[key]
				list.push_back({
					"type": "capacity",
					"amount": amount, 
					"resource": RESOURCE_UTIL.return_data(key)
				})
				
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_ongoing_containment_rewards(id:int) -> Array:
	var details:Dictionary = return_data(id)
	var list:Array = []
	
	if "ongoing_containment" in details and "resources" in details.ongoing_containment:
		if "amount" in details.ongoing_containment.resources:
			var dict:Dictionary = details.ongoing_containment.resources.amount.call()
			for key in dict:	
				var amount:int = dict[key]
				list.push_back({
					"type": "amount",
					"amount": amount, 
					"resource": RESOURCE_UTIL.return_data(key)
				})
		if "capacity" in details.ongoing_containment.resources:
			var dict:Dictionary = details.ongoing_containment.resources.capacity.call()
			for key in dict:	
				var amount:int = dict[key]
				list.push_back({
					"type": "capacity",
					"amount": amount, 
					"resource": RESOURCE_UTIL.return_data(key)
				})
				
	return list
# ------------------------------------------------------------------------------
