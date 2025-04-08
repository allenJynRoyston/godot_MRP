extends SubscribeWrapper

# ---------------------------------------------	FOR EVENTS
enum OPTION {CURRENCY}

var option_selected:Dictionary = {"store": null}

func onSelected(item:Dictionary) -> void: 
	option_selected.store = item

func getSelectedOption() -> Dictionary:
	return option_selected.store.option

func getSelectedIndex() -> int:
	return option_selected.store.index

func getSelectedVal():
	return option_selected.store.option.val
	
func build_option(dict:Dictionary = {}) -> Dictionary:
	var title:String = dict.title if "title" in dict else ""
	var change:Dictionary = dict.change if "change" in dict else {}
	var description_list:Array = []
	var is_locked:bool = false
	var onSelectedChild:Callable = onSelected
	
	for type in change:
		match type:
			OPTION.CURRENCY:
				var arr:Array = []
				for key in change[type]:
					var details:Dictionary = RESOURCE_UTIL.return_currency(key)
					var amount:int = change[type][key]
					if amount != 0:
						var description:String = "WILL %s [%s] %s." % ["CONSUME" if amount < 0 else "GAIN", absi(amount), details.name]
						description_list.push_back({
							"text": description, 
							"font_color": Color.RED if amount < 0 else Color.GREEN
						})
						
						if amount > resources_data[key].amount and !is_locked:
							is_locked = true
							
						arr.push_back(func() -> void: 
							#resources_data[key].capacity
							resources_data[key].amount = U.min_max(resources_data[key].amount + amount, 0, 999999))
					
					onSelectedChild = func(item:Dictionary) -> void:
						option_selected.store = item
						for arr_item in arr:
							arr_item.call()
						SUBSCRIBE.resources_data = resources_data

	if title.is_empty():
		title = "DO NOTHING"
		description_list = []
	
	return 	{
		"include": true,
		"title": title,
		"description_list": description_list, 
		"locked": is_locked,
		"val": true,
		"onSelected": onSelectedChild
	}
	
# ---------------------------------------------


var SCP0:Dictionary = {
	# -----------------------------------
	"nickname": "THE SCP0",
	"img_src": "res://Media/scps/the_door.png",
	"quote": "How many of you exist now?  Like six?",
	# -----------------------------------
	
	# -----------------------------------	
	"item_class": "SAFE",	
	"description": func(ref:ROOM.TYPE) -> Array:
		return [
			"Description line one",
			"Description line two"
		],
	# -----------------------------------	
	
	# -----------------------------------	
	"breach_events_at": [5, 8, 11],
	# -----------------------------------	
	
	# -----------------------------------
	"effects": {
		"metrics":{
			RESOURCE.BASE_METRICS.MORALE: 2,
			RESOURCE.BASE_METRICS.SAFETY: 2,
			RESOURCE.BASE_METRICS.READINESS: 2
		},
		"contained": {
			"description": "All resources are available.", 
			"effect": func(new_room_config:Dictionary, location:Dictionary) -> Dictionary:
				var ring_config_data:Dictionary = new_room_config.floor[location.floor].ring[location.ring]
				ring_config_data.available_resources = {
					RESOURCE.TYPE.TECHNICIANS: true,
					RESOURCE.TYPE.STAFF: true,
					RESOURCE.TYPE.SECURITY: true,
					RESOURCE.TYPE.DCLASS: true
				}
				return new_room_config,
		},
		"uncontained": {
			"description": "Makes resources unusable.",
			"effect": func(new_room_config:Dictionary, location:Dictionary) -> Dictionary:
				var ring_config_data:Dictionary = new_room_config.floor[location.floor].ring[location.ring]
				ring_config_data.available_resources = {
					RESOURCE.TYPE.TECHNICIANS: false,
					RESOURCE.TYPE.STAFF: false,
					RESOURCE.TYPE.SECURITY: false,
					RESOURCE.TYPE.DCLASS: false
				}
				return new_room_config,
		}
	},
	# -----------------------------------	
	
	"events": {
		# -------------------------
		SCP.EVENT_TYPE.AFTER_CONTAINMENT: func(scp_details:Dictionary, props:Dictionary) -> Array:
			var passes_metric_check:bool = true #SCP_UTIL.passes_metric_check(scp_details.ref, props.use_location)
			var dict:Dictionary = {
				"title": "PASSED METRIC CHECK.",
				"change": {
					OPTION.CURRENCY: {
						RESOURCE.CURRENCY.MONEY: -100,
					}
				} 
			} if passes_metric_check else {
				"title": "FAILED METRIC CHECK.",
				"change": {}
			}
			
			return [
					# --------------------
					func() -> Dictionary:
						return {
							"header": "CONTAINMENT EVENT",
							"img_src": scp_details.img_src,
							"text": [
								"I pass the metric test" if passes_metric_check else "I did NOT pass the metrics test."
							],
							"options": [
								build_option(),
								build_option(dict),
							]
						},
					# --------------------
					
					# --------------------
					func() -> Dictionary:
						print(getSelectedOption())
						return {
							"text": [
								"You last selected index [%s]." % [getSelectedIndex()],
								"The value was [%s]." % [getSelectedVal()]
							],
						},
					# --------------------
			],
		# -------------------------
		
		# -------------------------
		SCP.EVENT_TYPE.WARNING: func(scp_details:Dictionary, props:Dictionary) -> Array:
			var passes_metric_check:bool = SCP_UTIL.passes_metric_check(scp_details.ref, props.use_location)
			print("props.event_count: ", props.event_count)
			
			
			match props.event_count:
				0:
					# --------------------
					return [
							# --------------------
							func() -> Dictionary:
								return {
									"header": "WARNING 1",
									"img_src": scp_details.img_src,
									"text": [
										"The door begins to hum at an alarming frequency."
									]
								},
							# --------------------
					]
					# --------------------
				1:
					# --------------------
					return [
							# --------------------
							func() -> Dictionary:
								return {
									"header": "WARNING 2",
									"img_src": scp_details.img_src,
									"text": [
										"The door begins to hum at an alarming frequency."
									]
								},
							# --------------------
					]
					# --------------------
			# --------------------
			return [
					# --------------------
					func() -> Dictionary:
						return {
							"header": "WARNING 3",
							"img_src": scp_details.img_src,
							"text": [
								"The door begins to hum at an alarming frequency."
							]
						},
					# --------------------
			],
			# --------------------
		# -------------------------
		
		# -------------------------
		SCP.EVENT_TYPE.BREACH_EVENT: func(scp_details:Dictionary, props:Dictionary) -> Array:
			var passes_metric_check:bool = SCP_UTIL.passes_metric_check(scp_details.ref, props.use_location)
			print("passes_metric_check: ", passes_metric_check)
						
			match props.event_count:
				# --------------------
				0:
					return [
							# --------------------
							func() -> Dictionary:
								return {
									"header": "BREACH EVENT",
									"img_src": scp_details.img_src,
									"text": [
										"The door flings open and a swarm of shadows seep out."
									]
								},
							# --------------------
					]
				# --------------------
				1:
					return [
							# --------------------
							func() -> Dictionary:
								return {
									"header": "BREACH EVENT",
									"img_src": scp_details.img_src,
									"text": [
										"The door flings open and a swarm of shadows seep out."
									]
								},
							# --------------------
					]
				# --------------------
			
			# --------------------
			return [
					# --------------------
					func() -> Dictionary:
						return {
							"header": "BREACH EVENT",
							"img_src": scp_details.img_src,
							"text": [
								"The door flings open and a swarm of shadows seep out."
							]
						},
					# --------------------
			],
			# --------------------
		# -------------------------	
		},
}

var SCP1:Dictionary = {
	# -----------------------------------
	"nickname": "The Forgetful Remote",
	"img_src": "res://Media/scps/the_remote.png",
	"quote": "I swear I just put it here...",
	# -----------------------------------

	# -----------------------------------	
	"item_class": "EUCLID",	
	"description": func(ref:ROOM.TYPE) -> Array:
		return [
			"A standard television remote that persistently relocates itself when not in direct observation.",
			"Tests show that SCP1 disappears the moment it is placed down and left unattended, reappearing in another random location within the room.",
			"Despite extensive testing, no footage has ever captured the moment of relocation, as all recording devices inexplicably fail during the transition.",
			"The object has been responsible for numerous containment breaches due to personnel frustration and repeated unauthorized relocations."
		],
	# -----------------------------------	
	
	# -----------------------------------
	"effects": {
		"metrics":{
			RESOURCE.BASE_METRICS.MORALE: 1,
			RESOURCE.BASE_METRICS.SAFETY: 1,
			RESOURCE.BASE_METRICS.READINESS: 3
		},
		"contained": {
			"description": "Randomly swaps with another item in a containment cell on the same floor.", 
			"effect": func(new_room_config:Dictionary, location:Dictionary) -> Dictionary:
				return new_room_config,
		},
		"uncontained": {
			"description": "Randomly swaps with another item in a containment cell.", 
			"effect": func(new_room_config:Dictionary, location:Dictionary) -> Dictionary:
				return new_room_config,
		}
	},
	# -----------------------------------		
}

var SCP2:Dictionary = {
	# -----------------------------------
	"nickname": "The Echoing Blender",
	"img_src": "res://Media/scps/the_blender.png",
	"quote": "I turned it off. Why do I still hear it?",
	# -----------------------------------

	# -----------------------------------	
	"item_class": "EUCLID",	
	"description": func(ref:ROOM.TYPE) -> Array:
		return [
			"A standard kitchen blender that continues to emit the sound of blending even when unplugged and disassembled.",
			"The sound persists at a constant volume, seemingly originating from the exact position where the blender was last activated.",
			"Attempts to remove the noise by moving the blender to another location result in overlapping echoes, as previous activation sites retain their own phantom sounds indefinitely.",
			"Long-term exposure to SCP2’s auditory anomaly has been linked to increased anxiety, insomnia, and, in rare cases, auditory hallucinations of other household appliances activating on their own."
		],
	# -----------------------------------	
	
	# -----------------------------------
	"effects": {
		"metrics":{
			RESOURCE.BASE_METRICS.MORALE: 2,
			RESOURCE.BASE_METRICS.SAFETY: 3,
			RESOURCE.BASE_METRICS.READINESS: 0
		},
		"contained": {
			"description": "MORALE cannot exceed 2.", 
			"effect": func(new_room_config:Dictionary, location:Dictionary) -> Dictionary:
				return new_room_config,
		},
		"uncontained": {
			"description": "Researchers assigned have a chance of developing a QUIRK.", 
			"effect": func(new_room_config:Dictionary, location:Dictionary) -> Dictionary:
				return new_room_config,
		}
	},
	# -----------------------------------			
}

var SCP3:Dictionary = {
	# -----------------------------------
	"nickname": "The Never-Dry Sponge",
	"img_src": "res://Media/scps/the_sponge.png",
	"quote": "I wrung it out five times already. Why is it still dripping?",
	# -----------------------------------

	# -----------------------------------	
	"item_class": "SAFE",	
	"description": func(ref:ROOM.TYPE) -> Array:
		return [
			"A common household sponge that continuously absorbs water but never reaches saturation.",
			"Any attempt to wring out SCP3 results in an indefinite expulsion of water, regardless of its prior exposure to moisture.",
			"Tests indicate that the water expelled from SCP3 does not originate from any known source and is chemically identical to distilled water.",
			"Despite its otherwise harmless nature, SCP3 has caused minor flooding incidents when left unattended near sinks or drains, leading to its current containment within a sealed, moisture-controlled environment."
		],
	# -----------------------------------	
}

var SCP4:Dictionary = {
	# -----------------------------------
	"nickname": "The Hungry Recliner",
	"img_src": "res://Media/scps/the_recliner.png",
	"quote": "It doesn’t swallow you whole. It takes its time.",
	# -----------------------------------

	# -----------------------------------	
	"item_class": "KETER",	
	"description": func(ref:ROOM.TYPE) -> Array:
		return [
			"A seemingly ordinary reclining chair that exhibits predatory behavior when occupied for extended periods.",
			"Subjects who sit in SCP5 report an overwhelming sense of relaxation, often leading to unintended drowsiness and prolonged use.",
			"Once a subject remains seated for more than ten minutes, the chair’s padding subtly shifts, gradually pulling the individual deeper into the cushions.",
			"Attempts to stand up become increasingly difficult, as SCP5 applies a force equivalent to twice the subject’s body weight, preventing escape.",
			"If not forcibly removed, the occupant will eventually vanish entirely into the chair, leaving no trace behind except for slight indentations in the upholstery.",
			"Containment protocols require that SCP5 be securely strapped shut when not under active observation, and all testing is to be conducted with a reinforced harness attached to personnel."
		],
	# -----------------------------------	
}


# -----------------------------------	
var list:Array[Dictionary] = [
	SCP0, SCP1, SCP2, SCP3, SCP4
]
# -----------------------------------	
