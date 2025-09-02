extends Node

enum INFTYPE {	
	CURRENCIES
}


static var INFLUENCE_PRESETS:Dictionary = {
	# --------------------
	INFTYPE.CURRENCIES: {
		"starting_range": 1,
		"horizontal": true, 
		"vertical": false,
		"effect": {
			"description": "Adjacent facilities have the same ECONOMY as this facility.",
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
}

static func get_room_data(ref:ROOM.REF) -> Dictionary:
	var room_data:Dictionary = {}
	match ref:
		# ----------------------------------------------------------------------
		ROOM.REF.LOGISTICS_DEPARTMENT:
			room_data = {
				"categories": [ROOM.CATEGORY.DEPARTMENT],
				"link_categories": ROOM.CATEGORY.LOGISTICS_LINKABLE,
				
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
				
				"influence": INFLUENCE_PRESETS[INFTYPE.CURRENCIES], 
				
				"costs": {
					"unlock": 1,
					"purchase": 10,
				},	
				
				"abilities": func() -> Array: 
					return [
						ABL.get_ability(ABL.REF.INFLUENCE_RANGE_ONE),
						ABL.get_ability(ABL.REF.INFLUENCE_RANGE_TWO, 1),
					],		
							
				"passive_abilities": func() -> Array: 
					return [
						ABL_P.get_ability(ABL_P.REF.ENABLE_LOGISTIC_SUBDIVISON, 1),
					],
				
				"on_before_build_event": EVT.TYPE.LOGISTIC_SETUP,
			}
		# ----------------------------------------------------------------------
		ROOM.REF.LOGISTICS_LINK_1:
			room_data = {
				"categories": [ROOM.CATEGORY.LOGISTICS_LINKABLE],
				"name": "SUPPLY HUB",
				"shortname": "S.HUB",
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
				"currencies": {
					RESOURCE.CURRENCY.MATERIAL: 1,
				},
				"effect": {
					"description": "Additional MATERIAL when placed next to other SUPPLY HUBS.",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						var count:int = ROOM_UTIL.find_refs_of_adjuacent_rooms(_room_data.location).filter(func(x): return x == ROOM.REF.LOGISTICS_LINK_1).size()
						var room_level_config:Dictionary = _new_room_config.floor[_room_data.location.floor].ring[_room_data.location.ring].room[_room_data.location.room]
						room_level_config.currencies[RESOURCE.CURRENCY.MATERIAL] += count * 5,
				},				
			}
		# ----------------------------------------------------------------------			
		ROOM.REF.ADMIN_LINK_2:
			room_data = {
				"categories": [ROOM.CATEGORY.LOGISTICS_LINKABLE],
				"name": "ADMIN_LINK_2",
				"shortname": "L2",
				"description": "L2 description...",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER
				],	
				"own_limit": 1,
				"costs": {
					"unlock": 0,
					"purchase": 50,
				},
			}		
		# ----------------------------------------------------------------------
		ROOM.REF.ADMIN_LINK_3:
			room_data = {
				"categories": [ROOM.CATEGORY.LOGISTICS_LINKABLE],
				"name": "ADMIN_LINK_3",
				"shortname": "L3",
				"description": "L3 description...",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER
				],	
				"own_limit": 1,
				"costs": {
					"unlock": 0,
					"purchase": 50,
				},
				"abilities": func() -> Array: 
					return [
					],	
				"passive_abilities": func() -> Array: 
					return [
					],					
			}								
		# ----------------------------------------------------------------------
		ROOM.REF.ADMIN_LINK_4:
			room_data = {
				"categories": [ROOM.CATEGORY.LOGISTICS_LINKABLE],
				"name": "ADMIN_LINK_4",
				"shortname": "L4",
				"description": "L4 description...",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER
				],	
				"own_limit": 1,
				"costs": {
					"unlock": 0,
					"purchase": 50,
				},
				"abilities": func() -> Array: 
					return [
					],	
				"passive_abilities": func() -> Array: 
					return [
					],					
			}
		## ----------------------------------------------------------------------		
		ROOM.REF.ADMIN_LINK_5:
			room_data = {
				"categories": [ROOM.CATEGORY.LOGISTICS_LINKABLE],
				"name": "ADMIN_LINK_5",
				"shortname": "L5",
				"description": "L5 description...",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER
				],	
				"own_limit": 1,
				"costs": {
					"unlock": 0,
					"purchase": 50,
				},
				"abilities": func() -> Array: 
					return [
					],	
				"passive_abilities": func() -> Array: 
					return [
					],					
			}

	room_data.img_src = "res://Media/rooms/logistic_section.png"
	room_data.ref = ref
	return room_data
