extends SubscribeWrapper

# ---------------------------------------------	FOR EVENTS
var option_selected:Dictionary = {"store": null}

func onSelected(item:Dictionary) -> void: 
	option_selected.store = item

func getSelectedOption() -> Dictionary:
	return option_selected.store.option

func getSelectedIndex() -> int:
	return option_selected.store.index

func getSelectedVal():
	return option_selected.store.option.val
# ---------------------------------------------


var SCPA:Dictionary = {
	# -----------------------------------
	"nickname": "THE SCPA",
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
	"effects": {
		"metrics":{
			RESOURCE.METRICS.MORALE: 4,
			RESOURCE.METRICS.SAFETY: 3,
			RESOURCE.METRICS.READINESS: 2
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
		SCP.EVENT_TYPE.AFTER_CONTAINMENT: func(scp_details:Dictionary) -> Array:
			return [
					# --------------------
					func() -> Dictionary:
						return {
							"header": "%s: AFTER CONTAINMENT EVENT" % [scp_details.name],
							"img_src": scp_details.img_src,
							"text": [
								"Custom injection."
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
		}
		# -------------------------				
}

var SCPB:Dictionary = {
	# -----------------------------------
	"nickname": "THE SCPB",
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
}

var SCPC:Dictionary = {
	# -----------------------------------
	"nickname": "THE SCPC",
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
}


var list:Array[Dictionary] = [
	SCPA, SCPB, SCPC
]
