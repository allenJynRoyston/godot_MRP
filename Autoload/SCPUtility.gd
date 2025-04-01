extends SubscribeWrapper

const prefered_greeting:String = "Sir"

var SCP_001:Dictionary = {
	"name": "SCP-XX1",
	"nickname": "THE DOOR",
	"img_src": "res://Media/scps/the_door.png",
	"quote": "Quote goes here.",
	# -----------------------------------
	
	# -----------------------------------	
	"item_class": func() -> String:
		return "SAFE",			
	"containment_procedures": func(self_ref:Dictionary) -> Array:
		return [
			"%s is to be contained in a locked containment cell." % [self_ref.name],
		],
	"description": func(self_ref:Dictionary) -> Array:
		return [
			"%s is a basic wooden door that remains locked until a human being gets within 3 feet of the door. Door then opens up to an unknown location.  If a person goes through the door, it then shuts." % [self_ref.name],
			"That person is never seen again."
		],
	# -----------------------------------
	
	# -----------------------------------
	"effects": {
		"metrics":{
			RESOURCE.BASE_METRICS.MORALE: 4,
			RESOURCE.BASE_METRICS.SAFETY: 3,
			RESOURCE.BASE_METRICS.READINESS: 2
		},
		"contained": {
			"description": "Supplies all resources.", 
			"effect": func() -> void:
				pass,
		},
		"uncontained": {
			"description": "Removes all resources.",
			"effect": func() -> void:
				pass,			
		}
		#"containment_requirements": {
			#"metrics":{
				#RESOURCE.BASE_METRICS.MORALE: 1,
				#RESOURCE.BASE_METRICS.SAFETY: 1,
				#RESOURCE.BASE_METRICS.READINESS: 1
			#}
		#},
		#"description": {
			#"contained": "SUPPLIES ALL RESOURCES",
			#"uncontained": "SUPPLIES DO NOT WORK"
		#},
		#"floor": func() -> Dictionary:
			#return {
				#
			#},
		#"ring": func() -> Dictionary: 
			#return {
				#"provides": [
					#RESOURCE.TYPE.SECURITY,
					#RESOURCE.TYPE.STAFF,
					#RESOURCE.TYPE.TECHNICIANS,
					#RESOURCE.TYPE.DCLASS
				#]
			#},
	},
	# -----------------------------------
	
	# -----------------------------------
	"initial_containment": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: 50,
				},
		}	
	},
	# -----------------------------------
	
	# -----------------------------------
	"ongoing_containment": {
		"resources": {
			#"metrics": func() -> Dictionary:
				#return {
					#RESOURCE.BASE_METRICS.SAFETY: -4
			#},
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: 15,
					RESOURCE.TYPE.SCIENCE: 5
				},
		}	
	},
	# -----------------------------------

	# -----------------------------------
	"testing_options": [
		# -------------------------
		{
			"name": "Research one",
			"description": "",
			"requirements": {
				"resources": {
					"amount": func() -> Dictionary:
						return {
							RESOURCE.TYPE.MONEY: 50,
							RESOURCE.TYPE.SCIENCE: 50,
						},
					#"utilized": func() -> Dictionary:
						#return {
							#RESOURCE.TYPE.STAFF: 5
						#},
				}
			},	
			"event_instructions": func(room_extract:Dictionary, count:int) -> Array:
				var scp_details:Dictionary = room_extract.scp.details
				var is_success:bool = true
				
				var option_selected:Dictionary = {"val": null}
				var onSelected = func(val:int) -> void:
					option_selected.val = val
				
				
				var options:Array = [{
					"completed": false,
					"title": "Resolve (success).",
					"val": -1,
					"onSelected": onSelected			
				}] if is_success else [{
					"completed": false,
					"title": "Resolve (fail).",
					"val": -1,
					"onSelected": onSelected			
				}]
				
				
					
				return [
					func() -> Dictionary:
						return {
							"header": "%s: RESEARCH ONE COMPLETE" % [scp_details.name],
							"img_src": scp_details.img_src,
							"text": [
								"THIS IS A SUCCESS STATE"
							] if is_success else [
								"THIS IS A FAIL STATE"
							],
							"options": options
						},	
				],
		},
		# -------------------------
	
		
	],
	# -----------------------------------	
	
	# -----------------------------------
	"events": {
		# -------------------------
		SCP.EVENT_TYPE.DAY_SPECIFIC: [
			{
				"trigger_threshold": func(_count:int) -> int:
					return 100,
				"trigger_check": func(_dict:Dictionary) -> Array:
					var details:Dictionary = _dict.details
					var progress_data:Dictionary = _dict.progress_data
					match progress_data.day:
						50:
							return [
								func() -> Dictionary:
									return {
										"header": "%s: DAY EVENT" % [details.name],
										"img_src": details.img_src,
										"text": [
											"LOREM ISPUM",
										]
									},								
							]
						_:
							return []
					pass,
			},
			{
				"trigger_threshold": func(_count:int) -> int:
					return 2,
				"trigger_check": func(_dict:Dictionary) -> Array:
					var details:Dictionary = _dict.details
					return [
						func() -> Dictionary:
							return {
								"header": "%s: RANDOM EVENT 1" % [details.name],
								"img_src": details.img_src,
								"text": [
									"Random event 1.  Times triggered: %s" % [_dict.count]
								]
							},
					],
			},
			{
				"trigger_threshold": func(_trigger_count:int) -> int:
					return 2,
				"trigger_check": func(_dict:Dictionary) -> Array:
					var details:Dictionary = _dict.details
					return [
						func() -> Dictionary:
							return {
								"header": "%s: RANDOM EVENT 2" % [details.name],
								"img_src": details.img_src,
								"text": [
									"Random event 2.  Times triggered: %s" % [_dict.count]
								]
							},
					],
			}						
		],
		# -------------------------
		
		# -------------------------
		SCP.EVENT_TYPE.START_TESTING: [
			{
				"trigger_threshold": func(_trigger_count:int) -> int:
					return 100,
				"trigger_check": func(_dict:Dictionary) -> Array:
					return return_event_testing_template(_dict),
			}
		],
		# -------------------------
		
		# -------------------------
		SCP.EVENT_TYPE.DURING_TESTING: [
			{
				"trigger_threshold": func(_trigger_count:int) -> int:
					return 10 if _trigger_count == 0 else 0,
				"trigger_check": func(_dict:Dictionary) -> Array:
					var details:Dictionary = _dict.details
					return [
						func() -> Dictionary:
							return {
								"header": "%s: DURING TESTING EVENT" % [details.name],
								"img_src": details.img_src,
								"text": [
									"Lorem ipsum."
								]
							},
					],
			}
		],
		# -------------------------				
		
		# -------------------------
		SCP.EVENT_TYPE.AFTER_CONTAINMENT: [
			{
				"trigger_threshold": func(_trigger_count:int) -> int:
					return 100,
				"trigger_check": func(_dict:Dictionary) -> Array:
					var details:Dictionary = _dict.details
					return [
						func() -> Dictionary:
							return {
								"header": "%s: AFTER CONTAINMENT EVENT" % [details.name],
								"img_src": details.img_src,
								"text": [
									"After containment text"
								]
							},
					],
			}
		],
		# -------------------------		
		
		# -------------------------
		SCP.EVENT_TYPE.DURING_TRANSFER: [
			{
				"trigger_threshold": func(_count:int) -> int:
					return 10 if _count == 0 else 0,
				"trigger_check": func(_dict:Dictionary) -> Array:
					var details:Dictionary = _dict.details
					var option_selected:Dictionary = {
						"val": null
					}
					var onSelected = func(val:int) -> void:
						option_selected.val = val
					
					return [
						# ---------
						func() -> Dictionary:
							return {
								"header": "%s: DURING TRANSFER EVENT" % [details.name],
								"img_src": details.img_src,
								"text": [
									"Transfer event.  Times triggered: %s" % [_dict.count],
									"Should we cancel the transfer?"
								],
								"options": [
									{
										"include": true,
										"title": "Cancel transfer.  We can't risk damaging it or the facility.",
										"val": true,
										"onSelected": onSelected
									},
									{
										"include": true,
										"title": "Continue transfer.  Its just a door.",
										"val": false,
										"onSelected": onSelected
									}
								]
							},
						# ---------
						func() -> Dictionary:
							if option_selected.val:
								_dict.perform_action.call(ACTION.CONTAINED.CANCEL_TRANSFER)
						
							return {
								"text": [
									"You stop the transfer.  Shortly after, the shaking stops.",
								] if option_selected.val else [
									"The staff back off and the shaking immediately stops.",
									"Hmm."
								]
							}	
					],
			}
		],
		# -------------------------
		
		# -------------------------
		SCP.EVENT_TYPE.AFTER_TRANSFER: [
			{
				"trigger_threshold": func(_count:int) -> int:
					return 100,
				"trigger_check": func(_dict:Dictionary) -> Array:
					var details:Dictionary = _dict.details
					return [
						func() -> Dictionary:
							return {
								"header": "%s: AFTER TRANSFER EVENT" % [details.name],
								"img_src": details.img_src,
								"text": [
									"AFTER transfer event."
								]
							},
					],
			}
		],
		# -------------------------
		
		# -------------------------
		SCP.EVENT_TYPE.RANDOM_EVENTS: [
			{
				"trigger_threshold": func(_count:int) -> int:
					return 2,
				"trigger_check": func(_dict:Dictionary) -> Array:
					var details:Dictionary = _dict.details
					return [
						func() -> Dictionary:
							return {
								"header": "%s: RANDOM EVENT 0" % [details.name],
								"img_src": details.img_src,
								"text": [
									"Random event 0.  Times triggered: %s" % [_dict.count]
								]
							},
					],
			},
			{
				"trigger_threshold": func(_count:int) -> int:
					return 2,
				"trigger_check": func(_dict:Dictionary) -> Array:
					var details:Dictionary = _dict.details
					return [
						func() -> Dictionary:
							return {
								"header": "%s: RANDOM EVENT 1" % [details.name],
								"img_src": details.img_src,
								"text": [
									"Random event 1.  Times triggered: %s" % [_dict.count]
								]
							},
					],
			},
			{
				"trigger_threshold": func(_trigger_count:int) -> int:
					return 2,
				"trigger_check": func(_dict:Dictionary) -> Array:
					var details:Dictionary = _dict.details
					return [
						func() -> Dictionary:
							return {
								"header": "%s: RANDOM EVENT 2" % [details.name],
								"img_src": details.img_src,
								"text": [
									"Random event 2.  Times triggered: %s" % [_dict.count]
								]
							},
					],
			}						
		],
		# -------------------------
		
		# -------------------------
		SCP.EVENT_TYPE.BEFORE_DESTROY: [
			{
				"trigger_threshold": func(_trigger_count:int) -> int:
					return 100,
				"trigger_check": func(_dict:Dictionary) -> Array:
					var details:Dictionary = _dict.details
					return [
						func() -> Dictionary:
							return {
								"header": "%s: BEFORE DESTROY EVENT" % [details.name],
								"img_src": details.img_src,
								"text": [
									"After containment text"
								]
							},
					],
			}
		],
		# -------------------------		
		
		# -------------------------
		SCP.EVENT_TYPE.AFTER_DESTROY: [
			{
				"trigger_threshold": func(_trigger_count:int) -> int:
					return 100,
				"trigger_check": func(_dict:Dictionary) -> Array:
					var details:Dictionary = _dict.details
					return [
						func() -> Dictionary:
							return {
								"header": "%s: AFTER DESTROY EVENT" % [details.name],
								"img_src": details.img_src,
								"text": [
									"After containment text"
								]
							},
					],
			}
		],
		# -------------------------				
		
	}
	# -----------------------------------
}

var SCP_002:Dictionary = {
	"name": "SCP-XX2",
	"nickname": "LSD PAINT",
	"img_src": "res://Media/scps/lsd_paint.png",
	"quote": "Quote goes here.",
	# -----------------------------------
	
	# -----------------------------------
	"effects": {
		"containment_requirements": {
			"metrics":{
				RESOURCE.BASE_METRICS.MORALE: 1,
				RESOURCE.BASE_METRICS.SAFETY: 1,
				RESOURCE.BASE_METRICS.READINESS: 1
			}
		},
		"description": {
			"contained": "SUPPLIES ALL RESOURCES",
			"uncontained": "SUPPLIES DO NOT WORK"
		},
		"floor": func() -> Dictionary:
			return {
				
			},
		"ring": func() -> Dictionary: 
			return {
				"provides": [

				]
			},
	},
	# -----------------------------------	
	
	# -----------------------------------	
	"item_class": func() -> String:
		return "KETER",		
			
	"containment_procedures": func(self_ref:Dictionary) -> Array:
		return [
			"%s is to be contained in a locked containment cell." % [self_ref.name],
		],
	"description": func(self_ref:Dictionary) -> Array:
		return [
			"%s is a basic wooden door that remains locked until a human being gets within 3 feet of the door. Door then opens up to an unknown location.  If a person goes through the door, it then shuts." % [self_ref.name],
			"That person is never seen again."
		],
	# -----------------------------------
	
	# -----------------------------------
	"initial_containment": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: 50,
				},
			"capacity": func() -> Dictionary:
				return {
					
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
	#"unlockables": {
		#SCP.UNLOCKABLE.ONE: {
			#"add_to": {
				#"containment_procedures": func(self_ref:Dictionary) -> Array: 
					#return [
						#"ADDENUMDUM:",
						#"Containment of %s requires the use of 2 guards stationed outside the door." % [self_ref.name]
					#],
				#"description": func(self_ref:Dictionary) -> Array:
					#return [
						#"%s should show up now that I've been added." % [self_ref.name]
					#],
			#},
			#
			#"event_text": func(self_ref:Dictionary) -> Array:
				#return [
					#"You ignore the knocking."
				#],
		#}
	#},
	# -----------------------------------

	# -----------------------------------
	"events": {
		
		# -------------------------
		"after_inital_containment": [
			{
				"trigger_threshold": 100,
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
								"header": "%s INITIAL CONTAINMENT REPORT" % [details.name],
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
										"include": true,
										"title": "Ignore it, but monitor for activity from outside the containment cell.",
										"val": SCP.UNLOCKABLE.ONE,
										"onSelected": onSelected
									},
									{
										"include": true,
										"title": "Send an MTF to cautiously open the door.",
										"val": SCP.UNLOCKABLE.ONE,
										"onSelected": onSelected
									},
									{
										"include": true,
										"title": "Have a staff member open the door.",
										"val": SCP.UNLOCKABLE.ONE,
										"onSelected": onSelected
									},
									{
										"include": true,
										"title": "Instruct a D-Class to open the door.",
										"val": SCP.UNLOCKABLE.ONE,
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
	#SCP.TYPE.SCP_002: SCP_002
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
func return_unavailable_rooms(ref:int) -> Array: 
	return SHARED_UTIL.return_unavailable_rooms(return_data(ref))
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_wing_effects_list(room_extract:Dictionary) -> Array:
	return SHARED_UTIL.return_wing_effects_list(return_data(room_extract.scp.details.ref), room_extract, "wing_effect")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------		
func return_wing_effect(extract_data:Dictionary) -> Dictionary:
	var scp_data:Dictionary = return_data(extract_data.scp.details.ref)
	if "wing_effect" in scp_data:
		return scp_data.wing_effect.call(extract_data)
	
	return {}
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------
func calculate_initial_containment_bonus(ref:int, refund:bool = false) -> Dictionary:
	return SHARED_UTIL.calculate_resources(return_data(ref), "initial_containment", resources_data, refund)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_ongoing_containment(ref:int, resources_data:Dictionary, refund:bool = false) -> Dictionary:
	return SHARED_UTIL.calculate_resources(return_data(ref), "ongoing_containment", resources_data, refund)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_testing_requirements(scp_ref:int, testing_index:int) -> Array:
	var scp_data:Dictionary = return_data(scp_ref)
	var list:Array = []

	var resource_requirements:Dictionary = scp_data.testing_options[testing_index].requirements.resources
	if "amount" in resource_requirements:
		var amount_dict:Dictionary = resource_requirements.amount.call()
		for key in amount_dict:
			var amount:int = amount_dict[key]
			list.push_back({"type": "amount", "amount": amount, "resource": RESOURCE_UTIL.return_data(key)})	
	
	if "utilized" in resource_requirements:
		var utilized_dict:Dictionary = resource_requirements.utilized.call()
		for key in utilized_dict:
			var amount:int = utilized_dict[key]
			list.push_back({"type": "amount", "amount": amount, "resource": RESOURCE_UTIL.return_data(key)})			

	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_testing_costs(scp_ref:int, testing_index:int) -> Dictionary:
	var scp_data:Dictionary = return_data(scp_ref)
	var resource_data_copy:Dictionary = resources_data.duplicate(true)
	var resource_requirements:Dictionary = scp_data.testing_options[testing_index].requirements.resources
	
	if "utilized" in resource_requirements:
		var dict:Dictionary = resource_requirements.utilized.call()
		for key in dict:
			var amount:int = dict[key]
			resource_data_copy[key].utilized += amount
			resource_data_copy[key].amount -= amount
			
	if "amount" in resource_requirements:
		var dict:Dictionary = resource_requirements.amount.call()
		for key in dict:
			var amount:int = dict[key]
			resource_data_copy[key].amount -= amount
			if resource_data_copy[key].amount < 0:
				resource_data_copy[key].amount = 0
						
	return resource_data_copy	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_refunded_utilizied(utilized_data:Dictionary, resources_data:Dictionary) -> Dictionary:
	var resource_data_copy:Dictionary = resources_data.duplicate(true)
	for key in utilized_data:
		resource_data_copy[key].utilized -= utilized_data[key]
		resource_data_copy[key].amount += utilized_data[key]
		if resource_data_copy[key].amount > resources_data[key].capacity:
			resource_data_copy[key].amount = resources_data[key].capacity
	
	return resource_data_copy
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func check_for_events(ref:int, event_type:SCP.EVENT_TYPE, get_data_snapshot:Callable, get_self_ref:Callable) -> Dictionary:
	var data:Dictionary = return_data(ref)
	var event_arr:Array = []
	var event_instructions:Array = []
	var event_id:int = -1
	
	if "events" in data and event_type in data.events:
		var events:Array = data.events[event_type]
		for index in events.size():
			var event:Dictionary = events[index]
			var rand_int:int = U.generate_rand(0, 100)
			var event_type_count:int = get_self_ref.call().event_type_count.call(event_type, index)
			if rand_int <= event.trigger_threshold.call(event_type_count):
				event_arr.push_back(event) 
	
	if event_arr.size() > 0:
		# if multiple events are available, will pick one in the array at random
		event_id = U.generate_rand(0, event_arr.size() - 1)
		var event_trigger_count:int = get_self_ref.call().event_type_count.call(event_type, event_id)
		var scp_details:Dictionary = get_self_ref.call().details
		var scp_contained_details:Dictionary = get_self_ref.call().contained_list_details.call()
		var perform_action:Callable = get_self_ref.call().perform_action
		var combined_dict:Dictionary = {
			"details": scp_details, 
			"list_details": scp_contained_details,
			"count":  event_trigger_count,
			"progress_data": progress_data,
			"resources_data": resources_data,
			"researcher_details": get_self_ref.call().researcher_details.call(),
			# ------- functions
			"perform_action": perform_action,
			"get_self_ref": get_self_ref,
			"get_data_snapshot": get_data_snapshot
		}
		event_instructions = event_arr[event_id].trigger_check.call(combined_dict)

	# if event_instructions are empty, then check if there's a default available
	if event_instructions.is_empty():
		match event_type:
			# -----------------------
			SCP.EVENT_TYPE.AFTER_CONTAINMENT:
				event_instructions = [
					func() -> Dictionary:
						return {
							"header": "%s INITIAL CONTAINMENT REPORT" % [data.name],
							"img_src": data.img_src,
							"text": [
								"%s was successfully contained without incident." % [data.name]
							]
						}
				]
			# -----------------------
			SCP.EVENT_TYPE.AFTER_TRANSFER:
				event_instructions = [
					func() -> Dictionary:
						return {
							"header": "%s TRANSFER REPORT" % [data.name],
							"img_src": data.img_src,
							"text": [
								"%s was successfully transfered without incident." % [data.name]
							]
						}
				]				
				
	return {
		"event_id": event_id,
		"event_instructions": event_instructions
	}
# ------------------------------------------------------------------------------	
	
# ------------------------------------------------------------------------------	
func check_for_testing_events(ref:int, testing_ref:SCP.TESTING, room_extract:Dictionary, test_count:int) -> Dictionary:
	var data:Dictionary = return_data(ref)
	var event_arr:Array = []
	var event_instructions:Array = []
	
	if "testing_options" in data and testing_ref in data.testing_options:		
		if "event_instructions" in data.testing_options[testing_ref]:
			event_instructions = data.testing_options[testing_ref].event_instructions.call(room_extract, test_count)


	return {
		"event_instructions": event_instructions
	}
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func return_event_testing_template(_dict:Dictionary) -> Array:
	var scp_details:Dictionary = _dict.details
	var list_details:Dictionary = _dict.list_details
	var resources_data:Dictionary = _dict.resources_data
	var research_completed:Array = list_details.data.research_completed
	var researcher_details:Array = _dict.researcher_details		
	var option_selected:Dictionary = {"val": null}
	var onSelected = func(val) -> void:
		option_selected.val = val
	
	var img_src:String = researcher_details[0].img_src
	var portrait_title_name:String = "RESEARCHER %s" % [researcher_details[0].name]
	
	if researcher_details.size() == 2:
		portrait_title_name = "RESEARCHERS %s and %s" % [researcher_details[0].name, researcher_details[1].name]
		
	if researcher_details.size() > 2:
		portrait_title_name = "RESEARCH TEAM"	
		# TODO: replace with group of researchers pic
		img_src = researcher_details[0].img_src
	
	return [
		func() -> Dictionary:
			return {
				"header": "UPDATE ON %s" % [scp_details.name],
				"img_src": img_src,
				"portrait": {
					"title": portrait_title_name,
					"img_src": 	img_src,
				},
				"text": [
					"%s, these are %s proposals for %s." % [prefered_greeting, "my" if researcher_details.size() < 2 else "our", scp_details.name]
				],
				"options": build_event_options_list(_dict, option_selected, onSelected)
			},
		func() -> Dictionary:
			return {
				"text": [
					"I'll begin immediately." if option_selected.val != -1 else "Probably for the best."
				],
				"set_return_val": func() -> Dictionary:
					return option_selected,
			}		
	]
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func build_event_options_list(_dict:Dictionary, option_selected:Dictionary, onSelected:Callable) -> Array:
	var details:Dictionary = _dict.details
	var list_details:Dictionary = _dict.list_details
	var resources_data:Dictionary = _dict.resources_data
	var researcher_details:Array = _dict.researcher_details	
	var research_completed:Array = list_details.data.research_completed
	var testing_options:Dictionary = details.testing_options

	# first, check if all research options are exhasted
	var options:Array = []
	for testing_ref in testing_options:
		var option:Dictionary = testing_options[testing_ref]
		var completed:bool = testing_ref in research_completed
		var repeatable:bool = option.repeatable if "repeatable" in option else false
		
		# -----------
		# checks if prerequirites have been met
		var prerequisites:Dictionary = option.prerequisites.call()
		var required_traits:Array = prerequisites.traits if "traits" in prerequisites else []
		var required_specilization:Array = prerequisites.specializations if "specializations" in prerequisites else []
		var requires_trait:bool = required_traits.size() > 0
		var requires_specilization:bool = required_specilization.size() > 0
		var all_traits:Array = []
		var all_specilization:Array = []
		
		for researcher in researcher_details:
			for key in researcher.traits:
				if key not in all_traits:
					all_traits.push_back(key)
			for key in researcher.specializations:
				if key not in all_specilization:
					all_specilization.push_back(key)

		var useable_traits:Array = required_traits.filter(func(i): return all_traits.has(i)).map(func(i): return RESEARCHER_UTIL.return_trait_data(i))
		var useable_specilization:Array = required_specilization.filter(func(i): return all_specilization.has(i)).map(func(i): return RESEARCHER_UTIL.return_specialization_data(i))
		var is_missing_traits:bool = false if !requires_trait else required_traits.filter(func(i): return all_traits.has(i)).size() == 0
		var is_missing_specilization:bool = false if !requires_specilization else required_specilization.filter(func(i): return all_specilization.has(i)).size() == 0
		
		var trait_tag:String = "[%s] " % useable_traits[0].fullname if useable_traits.size() > 0 else ""
		var specilization_tag:String = "[%s] " % useable_specilization[0].fullname if useable_specilization.size() > 0 else ""
		var usable_tag_string:String = "%s %s%s" % ["" if !completed else "[REPEAT]", trait_tag, specilization_tag]
		# -----------
		
		# -----------
		var not_enough_resources:bool = false
		var required_resources_amount:Dictionary = option.requirements.resources.amount.call() if "amount" in option.requirements.resources else {}
		var required_resources_utilized:Dictionary = option.requirements.resources.utilized.call() if "utilized" in option.requirements.resources else {}
		var required_notes:Dictionary = {
			"header": "Resources required",
			"list": []
		}
		var utilized_notes:Dictionary = {
			"header": "Resources utilized",
			"list": []
		}		
		
		var missing_resources:Array = []
		
		for key in required_resources_amount:
			var amount:int = required_resources_amount[key]
			var resource_details:Dictionary = RESOURCE_UTIL.return_data(key)
			required_notes.list.push_back({
				"is_checked": resources_data[key].amount >= amount,
				"icon": resource_details.icon, 
				"text": "[%s] %s %s" % [resource_details.name, amount, "(You have %s)" % [resources_data[key].amount] if resources_data[key].amount < amount else ""]
			})
			
			if resources_data[key].amount < amount:
				missing_resources.push_back(key)
				
		for key in required_resources_utilized:
			var amount:int = required_resources_utilized[key]
			var resource_details:Dictionary = RESOURCE_UTIL.return_data(key)
			utilized_notes.list.push_back({
				"is_checked": resources_data[key].amount >= amount,
				"icon": resource_details.icon, 
				"text": "[%s] %s %s" % [resource_details.name, amount, "(You have %s)" % [resources_data[key].amount] if resources_data[key].amount < amount else ""]
			})
			
			if resources_data[key].amount < amount:
				missing_resources.push_back(key)				
			
		
		var locked:bool = is_missing_traits or is_missing_specilization or missing_resources.size() > 0
		
		
		var lock_str:String = "PREREQUISITES MISSING: "
		if is_missing_traits:
			for data in required_traits.map(func(i): return RESEARCHER_UTIL.return_trait_data(i)):
				lock_str += " [TRAIT - %s]" % [data.fullname]

		if is_missing_specilization:
			for data in required_specilization.map(func(i): return RESEARCHER_UTIL.return_specialization_data(i)):
				lock_str += " [SPECIALIZATION - %s]" % [data.fullname]
		
		if missing_resources.size() > 0 and (!is_missing_traits and !is_missing_specilization) :
			lock_str = "%s [NOT ENOUGH RESOURCES]" % [option.name]
	
		if !completed or (completed and repeatable):
			options.push_back({
				"completed": testing_ref in research_completed,
				"repeatable": repeatable,
				"locked": locked,
				"notes": [required_notes, utilized_notes],
				"title": "%s%s" % ["%s " % [usable_tag_string] if !usable_tag_string.is_empty() else "", option.name] if !locked else "%s" % [lock_str], 
				"description": "",
				"val": testing_ref,
				"onSelected": onSelected			
			})

	options.push_back({
		"completed": false,
		"title": "I've changed my mind.",
		"val": -1,
		"onSelected": onSelected			
	})
	
				
	return options
# ------------------------------------------------------------------------------
