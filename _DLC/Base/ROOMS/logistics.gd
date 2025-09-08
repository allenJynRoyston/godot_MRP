extends Node

enum INFTYPE {	
	ECONOMY,
	FREE_BUILD,
}


static var INFLUENCE_PRESETS:Dictionary = {
	# --------------------
	INFTYPE.ECONOMY: {
		"range": 1,
		"horizontal": true, 
		"vertical": false,
		"effect": {
			"description": func() -> String:
				return "Adjacent facilities have the same ECONOMY as this facility.",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> Dictionary:
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
						var amount:int = dict_copy[_ref]
						_new_room_config.floor[location.floor].ring[location.ring].room[room].currencies[_ref] += amount				

				# return update config
				return _new_room_config,			
		},		
	}, 	
	# --------------------
	INFTYPE.FREE_BUILD: {
		"range": 1,
		"horizontal": false, 
		"vertical": true,
		"effect": {
			"description": func() -> String:
				return "Anything built here has no CONSTRUCTION cost.",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> Dictionary:
				# return update config
				return _new_room_config,			
		},		
	}, 		
}

static func get_room_data(ref:ROOM.REF) -> Dictionary:
	var room_data:Dictionary = {}
	match ref:
		# ----------------------------------------------------------------------
		ROOM.REF.LOGISTICS_DEPARTMENT:
			room_data = {
				"categories": [ROOM.CATEGORY.DEPARTMENT],
				"name": "LOGISTICS DEPARTMENT",
				"shortname": "LOG DEPT", 	
				"description": "Central hub for LOGISTICS facilities.",
				"quote": "...",

				"requires_unlock": false, 	
				
				"required_staffing": [],
				"required_energy": 1,
				
				"department_properties": {
					"operator": ROOM.OPERATOR.ADD,
					"currency": [RESOURCE.CURRENCY.MATERIAL],
					"metric": [],
					"level": 1,
					"effects": [ROOM.EFFECTS.LOGISTICS_DEFAULT],
				},
				
				"passive_abilities": func() -> Array: 
					return [
						ABL_P.get_ability(ABL_P.REF.ADD_SCIENCE_TO_ALL_IN_RING, 0)
					],
								
				
				"influence": {
					"range": 1,
					"description": "FACILITIES built here will influence the LOGISTICS DEPT."
				},
			}

		

	room_data.link_categories = ROOM.CATEGORY.LOGISTICS
	room_data.img_src = "res://Media/rooms/logistic_section.png"
	room_data.ref = ref
	return room_data
