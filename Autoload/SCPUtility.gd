extends Node

enum THE_DOOR_IR_ONE {IGNORE_KNOCK, SEND_MTF, SEND_STAFF, SEND_DCLASS}

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
	"incident_reports": {
		THE_DOOR_IR_ONE.IGNORE_KNOCK: {
			"text": [
				"You ignore the knocking."
			]
		},
		THE_DOOR_IR_ONE.SEND_MTF: {
			"text": [
				"You send an MTF squad."
			]
		},
		THE_DOOR_IR_ONE.SEND_STAFF: {
			"text": [
				"You send a staff member to open the door."
			]
		},
		THE_DOOR_IR_ONE.SEND_DCLASS: {
			"text": [
				"You a D-Class to open the door."
			]
		}						
	},
	
	"containment_time": func() -> int:
		return 3,	

	"containment_requirements": [
		ROOM.TYPE.STANDARD_LOCKER
	],	
	
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
	
	"events": {
		"after_inital_containment": [
			{
				"trigger_check": func(get_snapshot:Callable, self_ref:Callable) -> Array:
					var img_src:String = self_ref.call().details.img_src
					var option_selected:Dictionary = {
						"val": null
					}
					var onSelected = func(val:int) -> void:
						option_selected.val = val
					
					return [
						func() -> Dictionary:
							return {
								"img_src": img_src,
								"text": [
									"Upon containment, a knock at the door can audiable be heard."
								]
							},
						func() -> Dictionary:
							return {
								"text": [
									"What action should we take."
								],
								"options": [
									{
										"show": true,
										"title": "Ignore it, but monitor for activity from outside the containment cell.",
										"val": THE_DOOR_IR_ONE.IGNORE_KNOCK,
										"onSelected": onSelected
									},
									{
										"show": true,
										"title": "Send an MTF to cautiously open the door.",
										"val": THE_DOOR_IR_ONE.SEND_MTF,
										"onSelected": onSelected
									},
									{
										"show": true,
										"title": "Have a staff member open the door.",
										"val": THE_DOOR_IR_ONE.SEND_STAFF,
										"onSelected": onSelected
									},
									{
										"show": true,
										"title": "Instruct a D-Class to open the door.",
										"val": THE_DOOR_IR_ONE.SEND_DCLASS,
										"onSelected": onSelected
									}
								]
							},
						func() -> Dictionary:
							return {
								"text": self_ref.call().details.incident_reports[option_selected.val].text
							}
					],
			}
		]
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
			
	"containment_requirements": [
		ROOM.TYPE.STANDARD_LOCKER
	],
	
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

# ------------------------------------------------------------------------------
func return_unavailable_rooms(ref:int, room_config:Dictionary, scp_data:Dictionary) -> Array: 
	return SHARED_UTIL.return_unavailable_rooms(return_data(ref), room_config, scp_data)
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func check_for_events(ref:int, get_data_snapshot:Callable, get_self_ref:Callable, event_property:String) -> Dictionary:
	var data:Dictionary = return_data(ref)
	var event_instructions:Array = []
	if "events" in data and event_property in data.events:
		var events:Array = data.events[event_property]
		for event in events:
			event_instructions = event.trigger_check.call(get_data_snapshot, get_self_ref)
			if !event_instructions.is_empty():
				break
				
	# default responses
	if event_instructions.is_empty():
		match event_property:
			"after_inital_containment":
				event_instructions = [
					func() -> Dictionary:
						return {
							"text": [
								"SCP-%s was successfully contained without incident." % [data.item_id]
							]
						},
					func() -> Dictionary:
						return {
							"text": [
								"Nice."
							]
						},
					func() -> Dictionary:
						return {
							"text": [
								"Close and continue."
							]
						}	
				]
	
	return {
		"event_instructions": event_instructions
	}
# ------------------------------------------------------------------------------	
	
