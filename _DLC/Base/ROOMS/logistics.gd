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
		ROOM.REF.LOGISTICS_DEPARTMENT:
			room_data = {
				"categories": [ROOM.CATEGORY.DEPARTMENT],
				"link_categories": ROOM.CATEGORY.LOGISTICS,
				
				"name": "LOGISTICS DEPARTMENT",
				"shortname": "LOGISTICS DEPT",	
				"description": "Sometimes the cargo delivers itself.",

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
						ABL_P.get_ability(ABL_P.REF.ENABLE_LOGISTIC_BRANCH),
					],
				
				"events": {
					"build_complete": EVT.TYPE.LOGISTIC_SETUP
				}
			}
		# ----------------------------------------------------------------------
		ROOM.REF.LOGISTICS_BRANCH:
			room_data = {
				"categories": [ROOM.CATEGORY.BRANCH],
				"link_categories": ROOM.CATEGORY.LOGISTICS,
				"name": "LOGISTICS BRANCH",
				"shortname": "L.BRANCH",
				"img_src": "res://Media/rooms/research_lab.png",
				"description": "Allows the use of LOGISTICS functions.",
				"own_limit": 4,
			}
		# ----------------------------------------------------------------------
		ROOM.REF.LOGISTICS_ROOM_1:
			room_data = {
				"categories": [ROOM.CATEGORY.LOGISTICS],
				"name": "SUPPLY DEPOT",
				"shortname": "S.DEPOT",
				"description": "Efficiency is its own reward.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER
				],	
				"own_limit": 10,
				"costs": {
					"unlock": 0,
					"purchase": 10,
				},
				"effect": {
					"description": "Additional MATERIAL when placed next to other SUPPLY HUBS.",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						var count:int = ROOM_UTIL.find_refs_of_adjuacent_rooms(_room_data.location).filter(func(x): return x == ROOM.REF.LOGISTICS_ROOM_1).size()
						var room_level_config:Dictionary = _new_room_config.floor[_room_data.location.floor].ring[_room_data.location.ring].room[_room_data.location.room]
						room_level_config.currencies[RESOURCE.CURRENCY.MATERIAL] += count * 5,
				},				
			}
		# ----------------------------------------------------------------------			
		ROOM.REF.LOGISTICS_ROOM_2:
			room_data = {
				"categories": [ROOM.CATEGORY.LOGISTICS],
				"name": "PROCUREMENT OFFICE",
				"shortname": "PROCUREMENT",
				"description": "You’d be surprised what you can get with the right clearance level.",
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
				"abilities": func() -> Array: 
					return [
						ABL.get_ability(ABL.REF.CONVERT_MONEY_INTO_SCIENCE),
						ABL.get_ability(ABL.REF.CONVERT_MONEY_INTO_MATERIAL),
						ABL.get_ability(ABL.REF.CONVERT_MONEY_INTO_CORE),
					],
			}		
		# ----------------------------------------------------------------------
		ROOM.REF.LOGISTICS_ROOM_3:
			room_data = {
				"categories": [ROOM.CATEGORY.LOGISTICS],
				"name": "EMERGENCY PROVISIONS",
				"shortname": "E.PROVISIONS",
				"description": "Morale starts with a full stomach and a working respirator.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.ADMIN,
					RESEARCHER.SPECIALIZATION.SECURITY
				],	
				"own_limit": 5,
				"costs": {
					"unlock": 0,
					"purchase": 10,
				},
				"metrics": {
					RESOURCE.METRICS.READINESS: 1
				},
			}								
		# ----------------------------------------------------------------------
		ROOM.REF.LOGISTICS_ROOM_4:
			room_data = {
				"categories": [ROOM.CATEGORY.LOGISTICS],
				"name": "LOGISTICS LIASON",
				"shortname": "L.LIASON",
				"description": "Bridging decisions with action.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.ADMIN,
					RESEARCHER.SPECIALIZATION.SECURITY
				],	
				"own_limit": 5,
				"costs": {
					"unlock": 0,
					"purchase": 10,
				},
				"effect": {
					"description": "Additional MATERIALS if next to a DEPARTMENT.",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						var departments:Array = ROOM_UTIL.get_department_refs()
						var count:int = ROOM_UTIL.find_refs_of_adjuacent_rooms(_room_data.location).filter(func(x): return x in departments).size()
						var room_level_config:Dictionary = _new_room_config.floor[_room_data.location.floor].ring[_room_data.location.ring].room[_room_data.location.room]
						room_level_config.currencies[RESOURCE.CURRENCY.MATERIAL] += count * 25,
				},				
			}
		## ----------------------------------------------------------------------		
		ROOM.REF.LOGISTICS_ROOM_5:
			room_data = {
				"categories": [ROOM.CATEGORY.LOGISTICS],
				"name": "SPECIAL AQUISITIONS",
				"shortname": "SPECIAL.A",
				"description": "If it bleeds, glows, or argues... it’s probably ours.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.ADMIN,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
				],	
				"own_limit": 5,
				"costs": {
					"unlock": 0,
					"purchase": 10,
				},
				"abilities": func() -> Array: 
					return [
						ABL.get_ability(ABL.REF.INSTANT_SCIENCE_LVL_1),
					],
			}
		## ----------------------------------------------------------------------		
		ROOM.REF.LOGISTICS_ROOM_6:
			room_data = {
				"categories": [ROOM.CATEGORY.LOGISTICS],
				"name": "COLD STORAGE",
				"shortname": "COLD.S",
				"description": "Stores equipment requiring low temperatures for safe containment.",
				"temp_required": [-2, -1],
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.ADMIN,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
				],	
				"own_limit": 5,
				"costs": {
					"unlock": 0,
					"purchase": 10,
				},
				"effect": {
					"description": "Yields MATERIALS the colder the environment is (not set-up)",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						pass,
				},				
			}
		## ----------------------------------------------------------------------		
		ROOM.REF.LOGISTICS_ROOM_7:
			room_data = {
				"categories": [ROOM.CATEGORY.LOGISTICS],
				"name": "THERMAL STORAGE",
				"shortname": "THERMAL.S",
				"description": "Stores equipment requiring high temperatures for safe containment.",
				"temp_required": [1, 2],
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.ADMIN,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
				],	
				"own_limit": 5,
				"costs": {
					"unlock": 0,
					"purchase": 10,
				},
				"effect": {
					"description": "Yields MATERIALS the hotter the environment is (not set-up)",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						pass,
				},				
			}
		## ----------------------------------------------------------------------		
		ROOM.REF.LOGISTICS_ROOM_8:
			room_data = {
				"categories": [ROOM.CATEGORY.LOGISTICS],
				"name": "THERMAL STORAGE",
				"shortname": "THERMAL.S",
				"description": "Stores equipment requiring high temperatures for safe containment.",
				"temp_required": [1, 2],
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.ADMIN,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
				],	
				"own_limit": 5,
				"costs": {
					"unlock": 0,
					"purchase": 10,
				},
				"effect": {
					"description": "Yields MATERIALS the hotter the environment is (not set-up)",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						pass,
				},				
			}			

	room_data.img_src = "res://Media/rooms/logistic_section.png"
	room_data.ref = ref
	return room_data
