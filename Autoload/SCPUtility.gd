extends Node


var THE_DOOR:Dictionary = {
	"item_id": "001-P",
	"name": "THE DOOR",
	"image_src": "res://Media/scps/the_door.png",
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
	"containment_requirements": func() -> Array:
		return [
			ROOM.TYPE.STANDARD_LOCKER
		],	
	"containment_time": func() -> int:
		return 1,
}


var reference_data:Dictionary = {
	SCP.TYPE.THE_DOOR: THE_DOOR,
}

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
