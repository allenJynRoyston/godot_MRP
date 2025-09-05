extends Node

enum INFTYPE {	
	MORALE,
}


static var INFLUENCE_PRESETS:Dictionary = {
	# --------------------
	INFTYPE.MORALE: {
		"starting_range": 1,
		"horizontal": true, 
		"vertical": true,
		"effect": {
			"description": func() -> String:
				return "Generate additional MORALE.",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> void:
				# self ref to get currency data
				var room_details:Dictionary = ROOM_UTIL.return_data(ref)
				# now get adjacent rooms
				for room in ROOM_UTIL.find_influenced_rooms( location, room_details.influence ):
					# and apply the bonus to them
					_new_room_config.floor[location.floor].ring[location.ring].room[room].metrics[RESOURCE.METRICS.MORALE] += 1,
		},		
	},	
	# --------------------
}

static func get_room_data(ref:ROOM.REF) -> Dictionary:
	var room_data:Dictionary = {}
	match ref:
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_CAFETERIA:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				
				"name": "CAFETERIA",
				"shortname": "CAFETERIA",
				"description": "Provides meals and sustenance for staff, maintaining morale in the face of anomalous threats.",
				"quote": "A hot meal goes a long way in a place like this.",

				"requires_unlock": false, 	
				"own_limit": 4,
				"required_staffing": [RESOURCE.PERSONNEL.STAFF, RESOURCE.PERSONNEL.STAFF],
				"required_energy": 1,
				
				"metrics": {
					RESOURCE.METRICS.MORALE: 1
				},

				"costs": {
					"unlock": 0,
					"purchase": 10,
				}, 	
				"effect": {
					"description": "Additional MORALE if placed next to WASHROOM.",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						var count:int = ROOM_UTIL.find_refs_of_adjuacent_rooms(_room_data.location).filter(func(x): return x == ROOM.REF.UTIL_WASHROOM).size()
						if count > 0:
							var room_level_config:Dictionary = _new_room_config.floor[_room_data.location.floor].ring[_room_data.location.ring].room[_room_data.location.room]
							room_level_config.metrics[RESOURCE.METRICS.MORALE] += 1,
				},
			}
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_WASHROOM:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				
				"name": "WASHROOM",
				"shortname": "WASHROOM",
				"description": "Basic sanitation facilities for staff, maintaining hygiene amidst a high-risk environment.",
				"quote": "A faucet, a mirror, and a fleeting moment of normalcy.",

				"requires_unlock": false, 	
				"own_limit": 4,
				"required_staffing": [],
				"required_energy": 1,
				
				"metrics": {					
					RESOURCE.METRICS.SAFETY: 1
				},

				"costs": {
					"unlock": 0,
					"purchase": 10,
				}, 
				
				"effect": {
					"description": "Additional SAFETY if placed next to BREAKROOM.",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						var count:int = ROOM_UTIL.find_refs_of_adjuacent_rooms(_room_data.location).filter(func(x): return x == ROOM.REF.UTIL_WASHROOM).size()
						if count > 0:
							var room_level_config:Dictionary = _new_room_config.floor[_room_data.location.floor].ring[_room_data.location.ring].room[_room_data.location.room]
							room_level_config.metrics[RESOURCE.METRICS.SAFETY] += 1,
				},
			}									
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_BREAKROOM:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				
				"name": "BREAKROOM",
				"shortname": "BREAKROOM",
				"description": "A small area for staff to rest, recharge, and momentarily forget the anomalies around them.",
				"quote": "Coffee, he smiled.",

				"requires_unlock": false, 	
				"own_limit": 4,
				"required_staffing": [],
				"required_energy": 1,
				
				"metrics": {					
					RESOURCE.METRICS.READINESS: 1
				},

				"costs": {
					"unlock": 0,
					"purchase": 10,
				}, 	
				
				"effect": {
					"description": "Additional MORALE if placed next to WASHROOM.",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						var count:int = ROOM_UTIL.find_refs_of_adjuacent_rooms(_room_data.location).filter(func(x): return x == ROOM.REF.UTIL_CAFETERIA).size()
						if count > 0:
							var room_level_config:Dictionary = _new_room_config.floor[_room_data.location.floor].ring[_room_data.location.ring].room[_room_data.location.room]
							room_level_config.metrics[RESOURCE.METRICS.MORALE] += 1,
				},
			}

		

	room_data.img_src = "res://Media/rooms/admin_section.png"
	room_data.ref = ref
	return room_data
