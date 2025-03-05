@tool
extends Node

# ------------------------------------------------------------------------
var GAME_OVER:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"val": null
		}
		var onSelected = func(val) -> void:
			option_selected.val = val
			
		return [
			# ---------
			func() -> Dictionary:
				return {
					"header": "FAIL STATE",
					"img_src": "res://Media/images/redacted.png",
					"text": [
						"Your facility has fallen into disarray.",
					],
					"options": [
						{
							"show": true,
							"title": "Restart.",
							"val": EVT.GAME_OVER_OPTIONS.RESTART,
							"onSelected": onSelected
						},
						{
							"show": true,
							"title": "Restart with random perk.",
							"val": EVT.GAME_OVER_OPTIONS.RESTART,
							"onSelected": onSelected
						}
					]
				},
			# ---------
			func() -> Dictionary:
				props.onSelection.call(option_selected.val)
				return {
					"text": [
						"You selected %s" % [option_selected.val],
					]
				}	
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var DISMISS_RESEARCHER:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"val": null
		}
		var onSelected = func(val) -> void:
			option_selected.val = val
			
		return [
			# ---------
			func() -> Dictionary:
				return {
					"header": "Event header",
					"img_src": "res://Media/images/redacted.png",
					"text": [
						"You've decided that %s should be dismissed." % [props.name],
						"Should you take any other precautions?"
					],
					"options": [
						{
							"show": true,
							"title": "Thank them for their service.",
							"val": EVT.DISMISS_TYPE.THANK_AND_DISMISS,
							"onSelected": onSelected
						},
						{
							"show": true,
							"title": "Administer Class-B amnestics.",
							"val": EVT.DISMISS_TYPE.ADMINISTER_AMNESTICS,
							"onSelected": onSelected
						},
						{
							"show": true,
							"title": "Terminate them and destroy their research.",
							"val": EVT.DISMISS_TYPE.TERMINATE,
							"onSelected": onSelected
						}						
					]
				},
			# ---------
			func() -> Dictionary:
				props.onSelection.call(option_selected.val)
				return {
					"text": [
						"You selected %s" % [option_selected.val],
					]
				}	
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var SITEWIDE_BROWNOUT:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"val": null
		}
		var onSelected = func(val) -> void:
			option_selected.val = val
			
		return [
			# ---------
			func() -> Dictionary:
				return {
					"header": "Event header",
					"img_src": "res://Media/images/redacted.png",
					"text": [
						"The lights begin to flicker as the power in the facility fluctuates.  Your batteries are almost out of juice.",
					],
					"options": [
						{
							"show": true,
							"title": "Utilize the emergency backup generators.",
							"val": EVT.BROWNOUT_OPTIONS.EMERGENCY_GENERATORS,
							"onSelected": onSelected
						},
						{
							"show": true,
							"title": "Do nothing",
							"val": EVT.BROWNOUT_OPTIONS.DO_NOTHING,
							"onSelected": onSelected
						}
					]
				},
			# ---------
			func() -> Dictionary:
				props.onSelection.call(option_selected.val)
				return {
					"text": [
						"You selected %s" % [option_selected.val],
					]
				}	
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var IN_DEBT_WARNING:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"val": null
		}
		var onSelected = func(val) -> void:
			option_selected.val = val
			
		return [
			# ---------
			func() -> Dictionary:
				return {
					"header": "Event header",
					"img_src": "res://Media/images/redacted.png",
					"text": [
						"IN DEBT WARNING",
					],
					"options": [
						{
							"show": true,
							"title": "Utilize the emergency funds.",
							"val": EVT.BROWNOUT_OPTIONS.EMERGENCY_GENERATORS,
							"onSelected": onSelected
						},
						{
							"show": true,
							"title": "Do nothing",
							"val": EVT.BROWNOUT_OPTIONS.DO_NOTHING,
							"onSelected": onSelected
						}
					]
				},
			# ---------
			func() -> Dictionary:
				props.onSelection.call(option_selected.val)
				return {
					"text": [
						"You selected %s" % [option_selected.val],
					]
				}	
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var MORALE:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"selected": null
		}
		var onSelected = func(option:Dictionary) -> void:
			option_selected.selected = option
			#option_selected.val = val
			
		return [
			# ---------
			func() -> Dictionary:
				return {
					"header": "Morale 1 event",
					"img_src": "res://Media/images/redacted.png",
					"portrait": {
						"title": "DR SMITHERS",
						"img_src": 	"res://Media/images/example_doctor.jpg",
					},					
					"text": [
						"MORALE EVENT 1",
					],
					"options": [
						{
							"show": true,
							"title": "Option a",
							"description": "Description goes here.",
							"success_rate": func() -> int:
								return 60,
							"val": 0,
							"onSelected": onSelected
						},
						{
							"show": true,
							"title": "Option b",
							"description": "Description goes here.",
							"success_rate": func() -> int:
								return 80,
							"val": 1,
							"onSelected": onSelected
						},
						{
							"show": true,
							"title": "Option c",
							"description": "Description goes here.",
							"success_rate": func() -> int:
								return 90,
							"val": 2,
							"onSelected": onSelected
						},
						{
							"show": true,
							"title": "Do nothing",
							"success_rate": func() -> int:
								return 100,
							"val": -1,
							"onSelected": onSelected
						}
					]
				},
			# ---------
			func() -> Dictionary:
				print(option_selected)
				props.onSelection.call(option_selected)
				return {
					"text": [
						"You selected %s" % [option_selected.selected.option.title],
					]
				},
			# ---------
			func() -> Dictionary:
				return {
					"text": [
						"And yet they soldiered on.",
					]
				}					
				
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var SAFETY:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"val": null
		}
		var onSelected = func(val) -> void:
			option_selected.val = val
			
		return [
			# ---------
			func() -> Dictionary:
				return {
					"header": "SAFETY 1 event",
					"img_src": "res://Media/images/redacted.png",
					"text": [
						"SAFETY EVENT 1",
					],
					"options": [
						{
							"show": true,
							"title": "Option a",
							"val": 0,
							"onSelected": onSelected
						},
						{
							"show": true,
							"title": "Do nothing",
							"val": -1,
							"onSelected": onSelected
						}
					]
				},
			# ---------
			func() -> Dictionary:
				props.onSelection.call(option_selected.val)
				return {
					"text": [
						"You selected %s" % [option_selected.val],
					]
				}	
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var READINESS:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"val": null
		}
		var onSelected = func(val) -> void:
			option_selected.val = val
			
		return [
			# ---------
			func() -> Dictionary:
				return {
					"header": "READINESS 1 event",
					"img_src": "res://Media/images/redacted.png",
					"text": [
						"READINESS EVENT 1",
					],
					"options": [
						{
							"show": true,
							"title": "Option a",
							"val": 0,
							"onSelected": onSelected
						},
						{
							"show": true,
							"title": "Do nothing",
							"val": -1,
							"onSelected": onSelected
						}
					]
				},
			# ---------
			func() -> Dictionary:
				props.onSelection.call(option_selected.val)
				return {
					"text": [
						"You selected %s" % [option_selected.val],
					]
				}	
		],
}
# ------------------------------------------------------------------------

var reference_data:Dictionary = {
	EVT.TYPE.GAME_OVER: GAME_OVER,
	EVT.TYPE.DISMISS_RESEARCHER: DISMISS_RESEARCHER,
	EVT.TYPE.SITEWIDE_BROWNOUT: SITEWIDE_BROWNOUT,
	EVT.TYPE.IN_DEBT_WARNING: IN_DEBT_WARNING,
	EVT.TYPE.MORALE: MORALE,
	EVT.TYPE.SAFETY: SAFETY,
	EVT.TYPE.READINESS: READINESS
}

# ------------------------------------------------------------------------
func return_data(val:EVT.TYPE) -> Dictionary:
	return reference_data[val]
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
func run_event(val:EVT.TYPE, props:Dictionary = {}) -> Dictionary:
	var data:Dictionary = return_data(val)
	return {
		"event_id": EVT.TYPE,
		"event_instructions": data.event_instructions.call(props)
	}
# ------------------------------------------------------------------------
