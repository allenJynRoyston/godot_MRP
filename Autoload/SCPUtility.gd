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
	
	"containment_time": func() -> int:
		return 3,	
	
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
	}
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
	
	"containment_time": func() -> int:
		return 3,
			
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
}


var reference_data:Dictionary = {
	SCP.TYPE.THE_DOOR: THE_DOOR,
	SCP.TYPE.THE_BOOK: THE_BOOK
}

# ------------------------------------------------------------------------------
func return_data(ref:int) -> Dictionary:
	reference_data[ref].ref = ref
	return reference_data[ref]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_initial_containment_rewards(ref:int) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "initial_containment")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_ongoing_containment_rewards(ref:int) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "ongoing_containment")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_initial_containment_bonus(ref:int, resources_data:Dictionary, add:bool = true) -> Dictionary:
	return SHARED_UTIL.calculate_resources(return_data(ref), "initial_containment", resources_data, add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_ongoing_containment(ref:int, resources_data:Dictionary, add:bool = true) -> Dictionary:
	return SHARED_UTIL.calculate_resources(return_data(ref), "ongoing_containment", resources_data, add)
# ------------------------------------------------------------------------------
