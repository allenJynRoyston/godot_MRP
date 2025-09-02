extends Node

enum INFTYPE {	
	MONEY,
	EXTRA_LEVEL, 
}


static var INFLUENCE_PRESETS:Dictionary = {
	# --------------------
	INFTYPE.MONEY: {
		"starting_range": 1,
		"horizontal": true, 
		"vertical": true,
		"effect": {
			"description": "Generate additional MONEY.",
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
						if _ref == RESOURCE.CURRENCY.MONEY:
							var amount:int = dict_copy[_ref]
							_new_room_config.floor[location.floor].ring[location.ring].room[room].currencies[_ref] += amount,
		},		
	}, 	
	# --------------------
	INFTYPE.EXTRA_LEVEL: {
		"starting_range": 1,
		"horizontal": true, 
		"vertical": true,
		"effect": {
			"description": "Start at an additional LEVEL.",
			"before_func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> void:
				# self ref to get currency data
				var room_details:Dictionary = ROOM_UTIL.return_data(ref)
				# get room level currency (added bonuses)
				var room_level_config:Dictionary = _new_room_config.floor[location.floor].ring[location.ring].room[location.room]
				# now get adjacent rooms
				for room in ROOM_UTIL.find_influenced_rooms( location, room_details.influence ):		
					_new_room_config.floor[location.floor].ring[location.ring].room[room].abl_lvl += 1,
		},		
	},	
	# --------------------
}

static func get_room_data(ref:ROOM.REF) -> Dictionary:
	var room_data:Dictionary = {}
	match ref:
		# ----------------------------------------------------------------------
		ROOM.REF.ADMIN_DEPARTMENT:
			room_data = {
				"categories": [ROOM.CATEGORY.DEPARTMENT],
				"link_categories": ROOM.CATEGORY.ADMIN_LINKABLE,
				
				"name": "ADMINISTRATION DEPARTMENT",
				"shortname": "ADMIN DEPT",	
				"description": "The heart of the Site beats in paperwork and protocols.",

				"requires_unlock": false,	
				"own_limit": 1,
				"required_staffing": [],
				"required_energy": 1,
				
				"currencies": {
					RESOURCE.CURRENCY.MONEY: 5,
					RESOURCE.CURRENCY.SCIENCE: 5,
					RESOURCE.CURRENCY.MATERIAL: 5,
				},

				"influence": INFLUENCE_PRESETS[INFTYPE.EXTRA_LEVEL], 
				
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
						ABL_P.get_ability(ABL_P.REF.ENABLE_ADMIN_SUBDIVISON, 1),
					],
				
				"on_before_build_event": EVT.TYPE.ADMIN_SETUP,
			}
		# ----------------------------------------------------------------------
		ROOM.REF.ADMIN_LINK_1:
			room_data = {
				"categories": [ROOM.CATEGORY.ADMIN_LINKABLE],
				"name": "DIRECTORS OFFICE",
				"shortname": "D.OFFICE",
				"description": "The most dangerous object on-site is the Director’s pen.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.ADMIN
				],	
				"own_limit": 1,
				"costs": {
					"unlock": 0,
					"purchase": 5,
				},					
				"abilities": func() -> Array: 
					return [
						ABL.get_ability(ABL.REF.TRIGGER_ONSITE_NUKE, 2),
					],	
				"passive_abilities": func() -> Array: 
					return [
						ABL_P.get_ability(ABL_P.REF.UI_ENABLE_ECONOMY, 0),
						ABL_P.get_ability(ABL_P.REF.UI_ENABLE_VIBES, 0),
						ABL_P.get_ability(ABL_P.REF.UI_ENABLE_PERSONNEL, 0),
						ABL_P.get_ability(ABL_P.REF.UI_ENABLE_DANGERS, 0),
					],					
			}
		# ----------------------------------------------------------------------			
		ROOM.REF.ADMIN_LINK_2:
			room_data = {
				"categories": [ROOM.CATEGORY.ADMIN_LINKABLE],
				"name": "HUMAN RESOURCES",
				"shortname": "HR",
				"description": "Loyalty is mandatory. Morale is optional.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.ADMIN,
				],
				"own_limit": 1,
				"costs": {
					"unlock": 0,
					"purchase": 5,
				},	
								
				"passive_abilities": func() -> Array: 
					return [
						ABL_P.get_ability(ABL_P.REF.HR_ADMIN_BONUS, 0),
						ABL_P.get_ability(ABL_P.REF.HR_RESEARCHER_BONUS, 1),
						ABL_P.get_ability(ABL_P.REF.HR_SECURITY_BONUS, 2),
						ABL_P.get_ability(ABL_P.REF.HR_DCLASS_BONUS, 3),
					],
			}		
		# ----------------------------------------------------------------------
		ROOM.REF.ADMIN_LINK_3:
			room_data = {
				"categories": [ROOM.CATEGORY.ADMIN_LINKABLE],
				"name": "OPERATIONS",
				"shortname": "OPERATIONS",
				"description": "Operations turns chaos into a calendar.",
				"requires_unlock": false,	
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.ADMIN
				],	
				"own_limit": 1,
				"costs": {
					"unlock": 0,
					"purchase": 5,
				},	
				"effect": {
					"description": CONDITIONALS.return_data(CONDITIONALS.TYPE.ENABLE_TIMELINE).description
				},
				"on_activate": func(state:bool) -> void:
					GAME_UTIL.set_conditional(CONDITIONALS.TYPE.ENABLE_TIMELINE, state),
			}								
		# ----------------------------------------------------------------------
		ROOM.REF.ADMIN_LINK_4:
			room_data = {
				"categories": [ROOM.CATEGORY.ADMIN_LINKABLE],
				"name": "ACCOUNTING",
				"shortname": "ACCOUNTING",
				"description": "In the end, anomalies aren’t secured with steel, but with spreadsheets.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.ADMIN
				],	
				"own_limit": 5,	
				"costs": {
					"unlock": 0,
					"purchase": 5,
				},	
				#"influence": INFLUENCE_PRESETS[INFTYPE.MONEY],
				"currencies": {
					RESOURCE.CURRENCY.MONEY: 1,
				},
				"effect": {
					"description": "Additional income when placed next to other ACCOUNTING offices",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						var count:int = ROOM_UTIL.find_refs_of_adjuacent_rooms(_room_data.location).filter(func(x): return x == ROOM.REF.ADMIN_LINK_4).size()
						var room_level_config:Dictionary = _new_room_config.floor[_room_data.location.floor].ring[_room_data.location.ring].room[_room_data.location.room]
						room_level_config.currencies[RESOURCE.CURRENCY.MONEY] += count * 5,
				},				
			}
		## ----------------------------------------------------------------------		
		ROOM.REF.ADMIN_LINK_5:
			room_data = {
				"categories": [ROOM.CATEGORY.ADMIN_LINKABLE],
				"name": "INTERNAL AFFAIRS",
				"shortname": "I.AFFAIRS",
				"description": "The quietest rooms often contain the loudest control.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.ADMIN
				],	
				"metrics": {
					RESOURCE.METRICS.SAFETY: 1,
				},
				"passive_abilities": func() -> Array: 
					return [
						ABL_P.get_ability(ABL_P.REF.IA_LEVEL_1, 0),
						ABL_P.get_ability(ABL_P.REF.IA_LEVEL_2, 1),
						ABL_P.get_ability(ABL_P.REF.IA_LEVEL_3, 2)
					],				
			}

	room_data.img_src = "res://Media/rooms/admin_section.png"
	room_data.ref = ref
	return room_data
