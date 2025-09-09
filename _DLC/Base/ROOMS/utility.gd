extends Node

static func get_costs(level:int) -> Dictionary:
	match level:
		0:
			return {
				"build": 5,
				"unlock": 25,
				"purchase": 10,
			}
		1:
			return {
				"build": 10,
				"unlock": 50,
				"purchase": 25,
			}
		2:
			return {
				"build": 25,
				"unlock": 100,
				"purchase": 50,
			}
		_:
			return {
				"build": 25,
				"unlock": 100,
				"purchase": 50,
			}

static func get_room_data(ref:ROOM.REF) -> Dictionary:
	var room_data:Dictionary = {}
	match ref:
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_LEVEL_DOWN_1:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "STORAGE ROOM",
				"shortname": "LVL-1",
				"description": "Dusty shelves and cobwebbed corners, heavy with stillness.",
				"quote": "Warning: cobwebs may be sentient.",
				"costs": get_costs(0),
				"utility_props": {
					"level": -1,
				}
			}				
		ROOM.REF.UTIL_LEVEL_DOWN_2:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "MAINTENANCE ROOM",
				"shortname": "LVL-2",
				"description": "Dim lights flicker over rusted pipes and machinery.",
				"quote": "It’s alive… mostly in the parts you don’t touch.",
				"costs": get_costs(1),
				"utility_props": {
					"level": -2,
				},
			}							
		ROOM.REF.UTIL_LEVEL_DOWN_3:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "BOILER ROOM",
				"shortname": "LVL-3",
				"description": "Heat and steam warp the walls, whispering in the corners.",
				"quote": "Hot enough to boil water, suspiciously close to your patience.",
				"costs": get_costs(2),
				"utility_props": {
					"level": -3,
				},
			}										

		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_LEVEL_UP_1:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "MEETING ROOM",
				"shortname": "LVL+1",
				"description": "Polished surfaces reflect light oddly across the ceiling.",
				"quote": "Nothing boosts morale like staring at fluorescent lighting.",
				"requires_unlock": false,
				"costs": get_costs(0),
				"utility_props": {
					"level": 1,
				}
			}		
		ROOM.REF.UTIL_LEVEL_UP_2:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "CONFERENCE ROOM",
				"shortname": "LVL+2",
				"description": "Windows are opaque with condensation and time.",
				"quote": "Endless meetings: now with slightly more mysterious condensation.",
				"costs": get_costs(1),
				"utility_props": {
					"level": 2,
				}
			}
		ROOM.REF.UTIL_LEVEL_UP_3:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "EXECUTIVE SUITE",
				"shortname": "LVL+3",
				"description": "Lavish furnishings gleam under unnatural light.",
				"quote": "Where ‘strategic thinking’ mostly means avoiding work.",
				"costs": get_costs(2),
				"utility_props": {
					"level": 3,
				}
			}

		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_ADD_CURRENCY_MONEY:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ACCOUNTING DEPT",
				"shortname": "MONEY",
				"description": "Stacks of ledgers and coins sit untouched for years.",
				"quote": "Counting money is fun until it starts counting back.",
				"costs": get_costs(1),
				"utility_props": {
					"currency": RESOURCE.CURRENCY.MONEY,
				}
			}

		ROOM.REF.UTIL_ADD_CURRENCY_SCIENCE:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "RESEARCH LAB",
				"shortname": "RESEARCH",
				"description": "Arcane instruments hum quietly, even when off.",
				"quote": "Science: because guessing loudly didn’t feel professional enough.",
				"costs": get_costs(1),
				"utility_props": {
					"currency": RESOURCE.CURRENCY.SCIENCE,
				}				
			}			

		ROOM.REF.UTIL_ADD_CURRENCY_MATERIAL:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "SUPPLY DEPOT",
				"shortname": "MATERIAL",
				"description": "Shelves bow under crates that shouldn’t be so full.",
				"quote": "One crate short of organized chaos.",
				"costs": get_costs(1),
				"utility_props": {
					"currency": RESOURCE.CURRENCY.MATERIAL,
				}				
			}

		ROOM.REF.UTIL_ADD_CURRENCY_CORE:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "SERVER ROOM",
				"shortname": "CORE",
				"description": "Machines blink in patterns no one can read.",
				"quote": "The servers are judging your life choices.",
				"costs": get_costs(1),
				"utility_props": {
					"currency": RESOURCE.CURRENCY.CORE,
				}				
			}

		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_RMV_CURRENCY_MONEY:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "AUDITING OFFICE",
				"shortname": "MONEY",
				"description": "Ledgers lie open, ink fading into shadows.",
				"quote": "Auditors: because someone has to make money feel guilty.",
				"costs": get_costs(1),
				"utility_props": {
					"remove_currency": RESOURCE.CURRENCY.MONEY,
				}
			}

		ROOM.REF.UTIL_RMV_CURRENCY_SCIENCE:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "EXPERIMENTAL LAB",
				"shortname": "RESEARCH",
				"description": "Broken glass and scorched floors speak of failed trials.",
				"quote": "Experiments: results may vary, sanity not guaranteed.",
				"costs": get_costs(1),
				"utility_props": {
					"remove_currency": RESOURCE.CURRENCY.SCIENCE,
				}				
			}			

		ROOM.REF.UTIL_RMV_CURRENCY_MATERIAL:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "WORKSHOP",
				"shortname": "MATERIAL",
				"description": "Tools lie scattered, as if used by invisible hands.",
				"quote": "Measure twice, cut once, panic always.",
				"costs": get_costs(1),
				"utility_props": {
					"remove_currency": RESOURCE.CURRENCY.MATERIAL,
				}				
			}

		ROOM.REF.UTIL_RMV_CURRENCY_CORE:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ARCHIVES",
				"shortname": "CORE",
				"description": "Dust coats every surface, thick and choking.",
				"quote": "Secrets here gossip more than the staff.",
				"costs": get_costs(1),
				"utility_props": {
					"remove_currency": RESOURCE.CURRENCY.CORE,
				}				
			}

		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_ADD_METRIC_MORALE:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "BREAK ROOM",
				"shortname": "MORALE",
				"description": "Soft lights and quiet corners invite fleeting comfort.",
				"quote": "Coffee: the real morale booster.",
				"costs": get_costs(1),
				"utility_props": {
					"metric": RESOURCE.METRICS.MORALE,
				}
			}

		ROOM.REF.UTIL_ADD_METRIC_SAFETY:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "SECURITY OFFICE",
				"shortname": "SAFETY",
				"description": "Monitors flicker with static that almost looks alive.",
				"quote": "Watching you watch the monitors is our favorite pastime.",
				"costs": get_costs(1),
				"utility_props": {
					"metric": RESOURCE.METRICS.SAFETY,
				}				
			}			

		ROOM.REF.UTIL_ADD_METRIC_READINESS:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "TRAINING FACILITY",
				"shortname": "READINESS",
				"description": "Rows of worn mats and dummies fill the room.",
				"quote": "Sweat today, mysterious bruises tomorrow.",
				"costs": get_costs(1),
				"utility_props": {
					"metric": RESOURCE.METRICS.READINESS,
				}				
			}

		ROOM.REF.UTIL_RMV_METRIC_MORALE:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "INTERROGATION ROOM",
				"shortname": "MORALE",
				"description": "Cold walls and metal chairs stare back at you.",
				"quote": "Cheerful conversation not included.",
				"costs": get_costs(1),
				"utility_props": {
					"remove_metric": RESOURCE.METRICS.MORALE,
				}				
			}

		ROOM.REF.UTIL_RMV_METRIC_SAFETY:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "HOLDING CELL",
				"shortname": "SAFETY",
				"description": "Bars and shadows crisscross the floor and ceiling.",
				"quote": "You’ll get plenty of ‘alone time’ in here.",
				"costs": get_costs(1),
				"utility_props": {
					"remove_metric": RESOURCE.METRICS.SAFETY,
				}				
			}			

		ROOM.REF.UTIL_RMV_METRIC_READINESS:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "LOUNGE",
				"shortname": "READINESS",
				"description": "Faded chairs and stale air linger in silence.",
				"quote": "Nap responsibly, or at least theatrically.",
				"costs": get_costs(1),
				"utility_props": {
					"remove_metric": RESOURCE.METRICS.READINESS,
				}				
			}


			
			
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_DOUBLE_ECON_OUTPUT:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "AUTOMATION HUB",
				"shortname": "2X",
				"description": "Conveyor belts and blinking panels hum with quiet purpose.",
				"quote": "Naps optional.",
				"costs": get_costs(1), 
				"utility_props": {
					"effect": ROOM.EFFECTS.DOUBLE_ECON_OUTPUT
				}				
			}
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_TRIPLE_ECON_OUTPUT:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "ROBOTICS LABB",
				"shortname": "3X",
				"description": "Machines twitch and spark.",
				"quote": "They said the robots wouldn’t replace us. They lied badly.",
				"costs": get_costs(2), 
				"utility_props": {
					"effect": ROOM.EFFECTS.TRIPLE_ECON_OUTPUT
				}				
			}					
			
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_HALF_ECON_OUTPUT:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "CONVERSION LAB",
				"shortname": "1/2",
				"description": "Strange apparatus grind and hiss, reshaping matter into questionable forms.",
				"quote": "If it fits, we convert it. If it doesn’t fit... we still convert it.",
				"costs": get_costs(1), 
				"utility_props": {
					"effect": ROOM.EFFECTS.HALF_ECON_OUTPUT
				}				
			}
			
		# ----------------------------------------------------------------------
		ROOM.REF.UTIL_ZERO_ECON_OUTPUT:
			room_data = {
				"categories": [ROOM.CATEGORY.UTILITY],
				"name": "INCINERATOR",
				"shortname": "=0",
				"description": "A scorched chamber lined with blackened steel, reeking of finality.",
				"quote": "Everything burns eventually.",
				"costs": get_costs(2), 
				"utility_props": {
					"effect": ROOM.EFFECTS.ZERO_ECON_OUTPUT
				}				
			}						

	room_data.own_limit = 20
	room_data.required_staffing = []
	room_data.required_energy = 0
	room_data.img_src = "res://Media/rooms/admin_section.png"
	room_data.ref = ref
	return room_data
