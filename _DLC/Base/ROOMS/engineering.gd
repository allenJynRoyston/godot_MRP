extends Node

enum INFTYPE {	
	ECONOMY,
	FREE_BUILD,
}


static var INFLUENCE_PRESETS:Dictionary = {
	# --------------------
	INFTYPE.ECONOMY: {
		"starting_range": 1,
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
		"starting_range": 1,
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
		ROOM.REF.ENGINEERING_DEPARTMENT:
			room_data = {
				"categories": [ROOM.CATEGORY.DEPARTMENT],
				"link_categories": ROOM.CATEGORY.ENGINEERING,
				
				"name": "ENGINEERING DEPARTMENT",
				"shortname": "ENGINEERING DEPT",	
				"description": "Central hub that enables ENGINEERING functions and resource flow.",
				"quote": "Sometimes the cargo delivers itself.",

				"requires_unlock": false,	
				"own_limit": 1,
				"required_staffing": [],
				"required_energy": 1,
				
				"currencies": {
					RESOURCE.CURRENCY.MONEY: 5,
					RESOURCE.CURRENCY.MATERIAL: 5,
				},
				
				"influence": INFLUENCE_PRESETS[INFTYPE.ECONOMY], 
				
				"costs": {
					"unlock": 1,
					"purchase": 10,
				},	
				
				"abilities": func() -> Array: 
					return [
						ABL.get_ability(ABL.REF.INFLUENCE_RANGE_ONE),
						ABL.get_ability(ABL.REF.INFLUENCE_RANGE_TWO),
					],		
								
				"passive_abilities": func() -> Array: 
					return [
						ABL_P.get_ability(ABL_P.REF.ENABLE_ENGINEERING_BRANCH),
					],
				
				"events": {
					"build_complete": EVT.TYPE.ENGINEERING_PERK_SETUP
				}
			}
		# ----------------------------------------------------------------------
		ROOM.REF.ENGINEERING_BRANCH:
			room_data = {
				"categories": [ROOM.CATEGORY.BRANCH],
				"link_categories": ROOM.CATEGORY.ENGINEERING,
				"name": "ENGINEERING BRANCH",
				"shortname": "E.BRANCH",
				"img_src": "res://Media/rooms/research_lab.png",
				"description": "Supports expansion of ENGINEERING operations.",
				"quote": "Allows the use of ENGINEERING functions.",
				"own_limit": 4,
			}
		# ----------------------------------------------------------------------
		ROOM.REF.ENG_ROOM_1:
			room_data = {
				"categories": [ROOM.CATEGORY.ENGINEERING],
				"name": "E1",
				"shortname": "E1",
				"description": "Provides basic ENGINEERING output and efficiency boosts.",
				"quote": "Efficiency is its own reward.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER
				],	
				"own_limit": 10,
				"costs": {
					"unlock": 0,
					"purchase": 10,
				},
			}
		# ----------------------------------------------------------------------			
		ROOM.REF.ENG_ROOM_2:
			room_data = {
				"categories": [ROOM.CATEGORY.ENGINEERING],
				"name": "E2",
				"shortname": "E2",
				"description": "Specialized ENGINEERING room that unlocks flexible construction options.",
				"quote": "Blueprints are only suggestions.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.ADMIN,
				],	
				"influence": INFLUENCE_PRESETS[INFTYPE.FREE_BUILD], 
				"own_limit": 1,
				"costs": {
					"unlock": 0,
					"purchase": 10,
				},
			}		
		# ----------------------------------------------------------------------
		ROOM.REF.ENG_ROOM_3:
			room_data = {
				"categories": [ROOM.CATEGORY.ENGINEERING],
				"name": "E3",
				"shortname": "E3",
				"description": "Enhances output and reliability of connected ENGINEERING rooms.",
				"quote": "If it doesn’t exist, we’ll build it. If it breaks, we’ll rebuild it stronger.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.ADMIN,
					RESEARCHER.SPECIALIZATION.RESEARCHER
				],	
				"own_limit": 5,
				"costs": {
					"unlock": 0,
					"purchase": 10,
				},
			}									
		# ----------------------------------------------------------------------

	room_data.img_src = "res://Media/rooms/engineering_section.png"
	room_data.ref = ref
	return room_data
