extends Node

enum UNLOCKABLE {ONE, TWO, THREE, FOUR, FIVE}

var SCP_001:Dictionary = {
	"item_id": "001",
	"name": "THE DOOR",
	"img_src": "res://Media/scps/the_door.png",
	
	# -----------------------------------
	"offered_on_day": func() -> int:
		return 1,
	"containment_time": func() -> int:
		return 3,
	"containment_requirements": [
		ROOM.TYPE.STANDARD_LOCKER
	],	
	# -----------------------------------
	
	# -----------------------------------	
	"containment_procedures": func(self_ref:Dictionary) -> Array:
		return [
			"SCP-%s is to be contained in a locked containment cell." % [self_ref.item_id],
		],
	"description": func(self_ref:Dictionary) -> Array:
		return [
			"SCP-%s is a basic wooden door that remains locked until a human being gets within 3 feet of the door. Door then opens up to an unknown location.  If a person goes through the door, it then shuts." % [self_ref.item_id],
			"That person is never seen again."
		],
	# -----------------------------------
	
	# -----------------------------------
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
	# -----------------------------------
	
	# -----------------------------------
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
	# -----------------------------------
	
	# -----------------------------------	
	"unlockables": {
		UNLOCKABLE.ONE: {
			"add_to": {
				"containment_procedures": func(self_ref:Dictionary) -> Array: 
					return [
						"ADDENUMDUM:",
						"Containment of SCP-%s requires the use of 2 guards stationed outside the door." % [self_ref.item_id]
					],
				"description": func(self_ref:Dictionary) -> Array:
					return [
						"SCP-%s should show up now that I've been added." % [self_ref.item_id]
					],
			},
			
			"event_text": func(self_ref:Dictionary) -> Array:
				return [
					"You ignore the knocking."
				],
		}
	},
	# -----------------------------------

	# -----------------------------------
	"events": {
		
		# -------------------------
		"after_inital_containment": [
			{
				"trigger_threshold": 100,
				"trigger_check": func(get_snapshot:Callable, self_ref:Callable) -> Array:
					#var details:Dictionary = self_ref.call().details
					#var img_src:String = details.img_src
					#var option_selected:Dictionary = {
						#"val": null
					#}
					#var onSelected = func(val:int) -> void:
						#option_selected.val = val
					#
					return [
						#func() -> Dictionary:
							#return {
								#"header": "SCP-%s INITIAL CONTAINMENT REPORT" % [details.item_id],
								#"img_src": img_src,
								#"text": [
									#"Upon containment, a knock at the door can audiable be heard.",
									#"The noise grows in intensity."
								#]
							#},
						#func() -> Dictionary:
							#return {
								#"text": [
									#"What action should we take."
								#],
								#"options": [
									#{
										#"show": true,
										#"title": "Ignore it, but monitor for activity from outside the containment cell.",
										#"val": UNLOCKABLE.ONE,
										#"onSelected": onSelected
									#},
									#{
										#"show": true,
										#"title": "Send an MTF to cautiously open the door.",
										#"val": UNLOCKABLE.ONE,
										#"onSelected": onSelected
									#},
									#{
										#"show": true,
										#"title": "Have a staff member open the door.",
										#"val": UNLOCKABLE.ONE,
										#"onSelected": onSelected
									#},
									#{
										#"show": true,
										#"title": "Instruct a D-Class to open the door.",
										#"val": UNLOCKABLE.ONE,
										#"onSelected": onSelected
									#}
								#]
							#},
						#func() -> Dictionary:
							#var unlockables:Dictionary = details.unlockables[option_selected.val]
							#self_ref.call().add_unlockable.call(option_selected.val)
							#if "event_text" in unlockables:
								#return {
									#"text": unlockables.event_text.call(details)
								#}	
							#return {}
							#
					],
			}
		],
		# -------------------------
		
		# -------------------------
		"random_events": [
			{
				"trigger_threshold": 100,
				"trigger_check": func(get_snapshot:Callable, self_ref:Callable) -> Array:
					var details:Dictionary = self_ref.call().details
					var img_src:String = details.img_src					
					return [
						func() -> Dictionary:
							return {
								"header": "SCP-%s: RANDOM EVENT 1" % [details.item_id],
								"img_src": img_src,
								"text": [
									"TRIGGER EVENT 1."
								]
							},
					],
			},
			{
				"trigger_threshold": 100,
				"trigger_check": func(get_snapshot:Callable, self_ref:Callable) -> Array:
					var details:Dictionary = self_ref.call().details
					var img_src:String = details.img_src					
					return [
						func() -> Dictionary:
							return {
								"header": "SCP-%s: RANDOM EVENT 2" % [details.item_id],
								"img_src": img_src,
								"text": [
									"TRIGGER EVENT 2."
								]
							},
					],
			},
			{
				"trigger_threshold": 100,
				"trigger_check": func(get_snapshot:Callable, self_ref:Callable) -> Array:
					var details:Dictionary = self_ref.call().details
					var img_src:String = details.img_src					
					return [
						func() -> Dictionary:
							return {
								"header": "SCP-%s: RANDOM EVENT 3" % [details.item_id],
								"img_src": img_src,
								"text": [
									"TRIGGER EVENT 3."
								]
							},
					],
			}						
		]
		# -------------------------
		
	}
	# -----------------------------------
}

var SCP_002:Dictionary = {
	"item_id": "002",
	"name": "LSD PAINT",
	"img_src": "res://Media/scps/lsd_paint.png",
	
	# -----------------------------------
	"offered_on_day": func() -> int:
		return 1,
	"containment_time": func() -> int:
		return 3,
	"containment_requirements": [
		ROOM.TYPE.STANDARD_LOCKER
	],	
	# -----------------------------------
	
	# -----------------------------------	
	"containment_procedures": func(self_ref:Dictionary) -> Array:
		return [
			"SCP-%s is to be contained in a locked containment cell." % [self_ref.item_id],
		],
	"description": func(self_ref:Dictionary) -> Array:
		return [
			"SCP-%s is a basic wooden door that remains locked until a human being gets within 3 feet of the door. Door then opens up to an unknown location.  If a person goes through the door, it then shuts." % [self_ref.item_id],
			"That person is never seen again."
		],
	# -----------------------------------
	
	# -----------------------------------
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
	# -----------------------------------
	
	# -----------------------------------
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
	# -----------------------------------
	
	# -----------------------------------	
	"unlockables": {
		UNLOCKABLE.ONE: {
			"add_to": {
				"containment_procedures": func(self_ref:Dictionary) -> Array: 
					return [
						"ADDENUMDUM:",
						"Containment of SCP-%s requires the use of 2 guards stationed outside the door." % [self_ref.item_id]
					],
				"description": func(self_ref:Dictionary) -> Array:
					return [
						"SCP-%s should show up now that I've been added." % [self_ref.item_id]
					],
			},
			
			"event_text": func(self_ref:Dictionary) -> Array:
				return [
					"You ignore the knocking."
				],
		}
	},
	# -----------------------------------

	# -----------------------------------
	"events": {
		
		# -------------------------
		"after_inital_containment": [
			{
				"trigger_check": func(get_snapshot:Callable, self_ref:Callable) -> Array:
					var details:Dictionary = self_ref.call().details
					var img_src:String = details.img_src
					var option_selected:Dictionary = {
						"val": null
					}
					var onSelected = func(val:int) -> void:
						option_selected.val = val
					
					return [
						func() -> Dictionary:
							return {
								"header": "SCP-%s INITIAL CONTAINMENT REPORT" % [details.item_id],
								"img_src": img_src,
								"text": [
									"Upon containment, a knock at the door can audiable be heard.",
									"The noise grows in intensity."
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
										"val": UNLOCKABLE.ONE,
										"onSelected": onSelected
									},
									{
										"show": true,
										"title": "Send an MTF to cautiously open the door.",
										"val": UNLOCKABLE.ONE,
										"onSelected": onSelected
									},
									{
										"show": true,
										"title": "Have a staff member open the door.",
										"val": UNLOCKABLE.ONE,
										"onSelected": onSelected
									},
									{
										"show": true,
										"title": "Instruct a D-Class to open the door.",
										"val": UNLOCKABLE.ONE,
										"onSelected": onSelected
									}
								]
							},
						func() -> Dictionary:
							var unlockables:Dictionary = details.unlockables[option_selected.val]
							self_ref.call().add_unlockable.call(option_selected.val)
							if "event_text" in unlockables:
								return {
									"text": unlockables.event_text.call(details)
								}	
							return {}
					],
			}
		]
		# -------------------------
	}
	# -----------------------------------
}


var reference_data:Dictionary = {
	SCP.TYPE.SCP_001: SCP_001,
	SCP.TYPE.SCP_002: SCP_002
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
	var event_arr:Array = []
	if "events" in data and event_property in data.events:
		var events:Array = data.events[event_property]
		for event in events:
			var rand_int:int = U.generate_rand(0, 100)
			if rand_int <= event.trigger_threshold:
				event_arr.push_back(event) 
	
	# if multiple events are available, will pick one in the array at random
	var random_event_int:int = U.generate_rand(0, event_arr.size() - 1)
	var event_instructions:Array = event_arr[random_event_int].trigger_check.call(get_data_snapshot, get_self_ref)

				
	# if event_instructions are empty, then check if there's a default available
	if event_instructions.is_empty():
		match event_property:
			"after_inital_containment":
				event_instructions = [
					func() -> Dictionary:
						return {
							"header": "SCP-%s INITIAL CONTAINMENT REPORT" % [data.item_id],
							"img_src": data.img_src,
							"text": [
								"SCP-%s was successfully contained without incident." % [data.item_id]
							]
						}
				]

	return {
		"random_event_int": random_event_int,
		"event_instructions": event_instructions
	}
# ------------------------------------------------------------------------------	
	
