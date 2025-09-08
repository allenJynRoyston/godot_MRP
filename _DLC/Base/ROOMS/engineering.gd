extends Node

enum INFTYPE {	
	COOLDOWN,
}


static var INFLUENCE_PRESETS:Dictionary = {
	# --------------------
	INFTYPE.COOLDOWN: {
		"range": 1,
		"horizontal": true, 
		"vertical": true,
		"effect": {
			"description": func() -> String:
				return "Generate additional CORE.",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> void:
				# self ref to get currency data
				var room_details:Dictionary = ROOM_UTIL.return_data(ref)
				# copy it
				var dict_copy:Dictionary = room_details.currencies.duplicate()
				# get room level currency (added bonuses)
				var room_level_config:Dictionary = _new_room_config.floor[location.floor].ring[location.ring].room[location.room]
				var currencies:Dictionary = room_level_config.currencies
				
				# add any bonuses in the room to it
				for currency_ref in currencies:
					var amount:int = currencies[currency_ref]
					if currency_ref not in dict_copy:
						dict_copy[currency_ref] = 0
					dict_copy[currency_ref] += amount

				# now get adjacent rooms
				for room in ROOM_UTIL.find_influenced_rooms( location, room_details.influence ):		
					# and apply the bonus to them
					for _ref in dict_copy:
						if _ref == RESOURCE.CURRENCY.CORE:
							var amount:int = dict_copy[_ref]
							_new_room_config.floor[location.floor].ring[location.ring].room[room].currencies[_ref] += amount,
		},		
	}, 	
}

static func get_room_data(ref:ROOM.REF) -> Dictionary:
	var room_data:Dictionary = {}
	match ref:
		# ----------------------------------------------------------------------
		ROOM.REF.ENGINEERING_DEPARTMENT:
			room_data = {
				"categories": [ROOM.CATEGORY.DEPARTMENT],
				"name": "ENGINEERING DEPARTMENT",
				"shortname": "ENG DEPT", 	
				"description": "Central hub for ENGINEERING facilities.",
				"quote": "...",

				"requires_unlock": false, 	
				
				"required_staffing": [],
				"required_energy": 1,
				
				"department_properties": {
					"operator": ROOM.OPERATOR.SUBTRACT,
					"currency": [RESOURCE.CURRENCY.MONEY],
					"metric": [],
					"level": 1,
					"effects": [ROOM.EFFECTS.ENGINEERING_DEFAULT],
				},
				
				"passive_abilities": func() -> Array: 
					return [

					],
								
				
				"influence": {
					"range": 1,
					"description": "FACILITIES built here will influence the ENGINEERING DEPT."
				},
			}
		

	room_data.link_categories = ROOM.CATEGORY.ENGINEERING
	room_data.img_src = "res://Media/rooms/engineering_section.png"
	room_data.ref = ref
	return room_data
