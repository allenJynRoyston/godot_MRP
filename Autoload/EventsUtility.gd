@tool
extends Node

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


var reference_data:Dictionary = {
	EVT.TYPE.DISMISS_RESEARCHER: DISMISS_RESEARCHER,
	EVT.TYPE.SITEWIDE_BROWNOUT: SITEWIDE_BROWNOUT,
	EVT.TYPE.IN_DEBT_WARNING: IN_DEBT_WARNING
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
