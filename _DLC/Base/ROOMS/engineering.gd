extends Node

enum INFTYPE {	
	COOLDOWN,
}


static var INFLUENCE_PRESETS:Dictionary = {
	# --------------------
	INFTYPE.COOLDOWN: {
		"starting_range": 1,
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
				"shortname": "ENGINEERING DEPT",
				"description": "Oversees heating, cooling, and ventilation systems that keep containment environments stable.",
				"quote": "The real monsters are HVAC failures at 3 A.M.",

				"requires_unlock": false,	
				
				"required_staffing": [],
				"required_energy": 1,
				
				"currencies": {
					RESOURCE.CURRENCY.CORE: 5,
				},
				
				"influence": INFLUENCE_PRESETS[INFTYPE.COOLDOWN], 
				
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
				
				#"events": {
					#"build_complete": EVT.TYPE.ENGINEERING_PERK_SETUP
				#}
			}
		# ----------------------------------------------------------------------
		ROOM.REF.ENGINEERING_BRANCH:
			room_data = {
				"categories": [ROOM.CATEGORY.BRANCH],
				"name": "ENGINEERING BRANCH",
				"shortname": "E.BRANCH",
				"img_src": "res://Media/rooms/research_lab.png",
				"description": "Supports expansion of ENGINEERING operations.",
				"quote": "Allows the use of ENGINEERING functions.",
				
			}
		# ----------------------------------------------------------------------
		ROOM.REF.ENG_ROOM_1:
			room_data = {
				"categories": [ROOM.CATEGORY.ENGINEERING],
				"name": "WORKSHOP",
				"shortname": "W.SHOP",
				"description": "Fabricates, repairs, and customizes containment equipment and tools.",
				"quote": "Nothing lasts forever, except our repair queue.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER,
				],
				
				"costs": {
					"unlock": 0,
					"purchase": 0,
				},
				"currency": {
					RESOURCE.CURRENCY.CORE: 1
				},
				"passive_abilities": func() -> Array: 
					return [
						ABL_P.get_ability(ABL_P.REF.WORKSHOP_1),
						ABL_P.get_ability(ABL_P.REF.WORKSHOP_2),
						ABL_P.get_ability(ABL_P.REF.WORKSHOP_3)
					],
			}
		# ----------------------------------------------------------------------			
		ROOM.REF.ENG_ROOM_3:
			room_data = {
				"categories": [ROOM.CATEGORY.ENGINEERING],
				"name": "HAZARDOUS DISPOSAL",
				"shortname": "H.DISPOSAL",
				"description": "Processes and neutralizes dangerous materials, anomalous waste, and contaminated equipment safely.",
				"quote": "Some things are better left buried… permanently.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
				],
				
				"costs": {
					"unlock": 0,
					"purchase": 0,
				},
				"effect": {
					"description": "Additional CORE if next to a CONTAINMENT CELL.",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						var refs:Array = [ROOM.REF.CONTAINMENT_CELL]
						var count:int = ROOM_UTIL.find_refs_of_adjuacent_rooms(_room_data.location).filter(func(x): return x in refs).size()
						var room_level_config:Dictionary = _new_room_config.floor[_room_data.location.floor].ring[_room_data.location.ring].room[_room_data.location.room]
						room_level_config.currencies[RESOURCE.CURRENCY.CORE] += count * 25,
				},				
			}
		# ----------------------------------------------------------------------
		ROOM.REF.ENG_ROOM_4:
			room_data = {
				"categories": [ROOM.CATEGORY.ENGINEERING],
				"name": "GAS GENERATOR",
				"shortname": "GAS.GEN",
				"description": "Outputs consistant energy output but requires enhanced ventiliation.",
				"quote": "We run on diesel and dread.",
				"required_energy": 0,
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
				],
				
				"costs": {
					"unlock": 0,
					"purchase": 0,
				},
				"effect": {
					"description": "Converts fuel into energy, with unavoidable environmental hazards.",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						var floor:int = _room_data.location.floor
						var ring:int = _room_data.location.ring
						var room:int = _room_data.location.room
						var ring_config_data:Dictionary = _new_room_config.floor[floor].ring[ring]
						_new_room_config.floor[floor].ring[ring].energy.available += 10
						print(_new_room_config.floor[floor].ring[ring].energy.available),
				},
			}
		# ----------------------------------------------------------------------			
		ROOM.REF.ENG_ROOM_5:
			room_data = {
				"categories": [ROOM.CATEGORY.ENGINEERING],
				"name": "GEOTHERMAL",
				"shortname": "GEN.ROOM",
				"description": "Fabricates, repairs, and customizes containment equipment and tools.",
				"quote": "If it contains, we built it.",
				"requires_unlock": false,
				"required_energy": 0,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
				],
				
				"costs": {
					"unlock": 0,
					"purchase": 0,
				},
				"effect": {
					"description": "Adds available energy to the wing.  The lower it's built the more power available.",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						var floor:int = _room_data.location.floor
						var ring:int = _room_data.location.ring
						var room:int = _room_data.location.room
						var ring_config_data:Dictionary = _new_room_config.floor[floor].ring[ring]
						_new_room_config.floor[floor].ring[ring].energy.available += floor * 5,
				},
			}
		# ----------------------------------------------------------------------			
		ROOM.REF.ENG_ROOM_6:
			room_data = {
				"categories": [ROOM.CATEGORY.ENGINEERING],
				"name": "ASSEMBLY BAY",
				"shortname": "A.BAY",
				"description": "Constructs, assembles, and maintains large-scale equipement used throughout the site.",
				"quote": "Literally a cog in the machine.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
				],
				
				"costs": {
					"unlock": 0,
					"purchase": 0,
				},
				"effect": {
					"description": "Additional MATERIAL when placed next to other ASSEMBLY BAYS.",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						var count:int = ROOM_UTIL.find_refs_of_adjuacent_rooms(_room_data.location).filter(func(x): return x == ROOM.REF.ENG_ROOM_6).size()
						var room_level_config:Dictionary = _new_room_config.floor[_room_data.location.floor].ring[_room_data.location.ring].room[_room_data.location.room]
						room_level_config.currencies[RESOURCE.CURRENCY.MATERIAL] += count * 5,
				},				
			}
		# ----------------------------------------------------------------------			
		ROOM.REF.ENG_ROOM_6:
			room_data = {
				"categories": [ROOM.CATEGORY.ENGINEERING],
				"name": "ASSEMBLY BAY",
				"shortname": "A.BAY",
				"description": "Constructs, assembles, and maintains large-scale equipement used throughout the site.",
				"quote": "Literally a cog in the machine.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
				],
				
				
				"costs": {
					"unlock": 0,
					"purchase": 0,
				},
				"effect": {
					"description": "Additional MATERIAL when placed next to other ASSEMBLY BAYS.",
					"func": func(_new_room_config:Dictionary, _resource_data:Dictionary, _room_data:Dictionary) -> void:
						var count:int = ROOM_UTIL.find_refs_of_adjuacent_rooms(_room_data.location).filter(func(x): return x == ROOM.REF.ENG_ROOM_6).size()
						var room_level_config:Dictionary = _new_room_config.floor[_room_data.location.floor].ring[_room_data.location.ring].room[_room_data.location.room]
						room_level_config.currencies[RESOURCE.CURRENCY.MATERIAL] += count * 5,
				},				
			}
		# ----------------------------------------------------------------------			
		ROOM.REF.ENG_ROOM_7:
			room_data = {
				"categories": [ROOM.CATEGORY.ENGINEERING],
				"name": "SCRANTON REALITY ANCHOR",
				"shortname": "SRA",
				"description": "A critical containment asset that stabilizes localized reality.",
				"quote": "Deploying a backup is comforting. Deploying a backup for the backup is terrifying.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
				],
				
				"costs": {
					"unlock": 0,
					"purchase": 0,
				},
				"effect": {
					"description": "Enables the SRA option in the Engineering panel."
				},				
			}
		# ----------------------------------------------------------------------			
		ROOM.REF.ENG_ROOM_8:
			room_data = {
				"categories": [ROOM.CATEGORY.ENGINEERING],
				"name": "SCRANTON REALITY ANCHOR",
				"shortname": "SRA",
				"description": "A critical containment asset that stabilizes localized reality.",
				"quote": "Deploying a backup is comforting. Deploying a backup for the backup is terrifying.",
				"requires_unlock": false,
				"required_staffing": [
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
					RESEARCHER.SPECIALIZATION.RESEARCHER,
				],
				
				"costs": {
					"unlock": 0,
					"purchase": 0,
				},
				"effect": {
					"description": "Enables the SRA option in the Engineering panel."
				},				
			}

	room_data.link_categories = ROOM.CATEGORY.ENGINEERING
	room_data.img_src = "res://Media/rooms/engineering_section.png"
	room_data.ref = ref
	return room_data
