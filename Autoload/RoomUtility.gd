@tool
extends SubscribeWrapper

var DIRECTORS_OFFICE:Dictionary = {
	# ------------------------------------------
	"name": "DIRECTORS OFFICE",
	"shortname": "D.OFFICE",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "The site directors office.",
	# ------------------------------------------

	# ------------------------------------------
	"can_contain": true,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------
	
	# ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#{
				#"name": "AQUIRE SCP",
				#"unlock_cost": func() -> Dictionary:
					#return {
						#RESOURCE.TYPE.SCIENCE: -20
					#},
				#"cooldown_duration":  5, 
				#"effect": func() -> bool:
					#return await GAME_UTIL.get_new_scp(),
			#}
		#],	
	# ------------------------------------------
	
	# ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
			#{
				#"name": "TEST +1",
				#"use_cost": func() -> Dictionary:
					#return {
						#RESOURCE.TYPE.ENERGY: -1
					#},
			#}
		#],	
	# ------------------------------------------	

	# ------------------------------------------
	"unlock_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					
				},
		}	
	},
		
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					
				},
		}	
	},

	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	},
	# ------------------------------------------
	
	# ------------------------------------------	
	"specilization_bonus": func(specilizations:Array) -> Dictionary:
		return {},
	# ------------------------------------------	
}

var HQ:Dictionary = {
	"name": "HEADQUARTERS",
	"shortname": "HQ",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Base headquarters.",
		
	# ------------------------------------------
	"can_contain": false,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			{
				"name": "HIRE RESEARCHER",
				"use_at": 0,
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"cooldown_duration":  5, 
				"effect": func() -> bool:
					return await GAME_UTIL.recruit_new_researcher(1),
			},
			{
				"name": "PROMOTE RESEARCHER",
				"use_at": 0,
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"cooldown_duration":  5, 
				"effect": func() -> bool:
					return await GAME_UTIL.promote_researchers(),
			}
		],	
	# ------------------------------------------

	# ------------------------------------------
	"unlock_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.SCIENCE: -20
				},
		}	
	},
		
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.SCIENCE: -20
				},
		}	
	},

	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	},
	# ------------------------------------------
	
	# ------------------------------------------	
	"specilization_bonus": func(specilizations:Array) -> Dictionary:
		if RESEARCHER.SPECIALIZATION.CHEMISTRY in specilizations:
			return {
				"ap": 1,
				"metrics":{
					RESOURCE.BASE_METRICS.MORALE: 1
				}				
			}
		if RESEARCHER.SPECIALIZATION.PSYCHOLOGY in specilizations:
			return {
				"metrics":{
					RESOURCE.BASE_METRICS.MORALE: 1
				}
			}
		return {}
	# ------------------------------------------		
}

var AQUISITION_DEPARTMENT:Dictionary = {
	"name": "AQUISITIONS DEPARTMENT",
	"shortname": "AQUISITIONS DEPT.",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Allows you to view any REDACTED room profiles before unlocking them.",

	# ------------------------------------------
	"can_contain": false,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			{
				"name": "UNLOCK FACILITIES", 
				"use_at": 0,
				"cooldown_duration":  1, 
				"effect": func() -> bool:
					return await GAME_UTIL.open_store(),
			}
		],	
	# ------------------------------------------

	# ------------------------------------------
	"unlock_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {

				},
		}	
	},
		
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},

	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	},
	# ------------------------------------------	
	
	# ------------------------------------------	
	"specilization_bonus": func(specilizations:Array) -> Dictionary:
		if RESEARCHER.SPECIALIZATION.PHARMACOLOGY in specilizations:
			return {
				"resource":{
					RESOURCE.TYPE.ENERGY: 2
				},
			}
		if RESEARCHER.SPECIALIZATION.PSYCHOLOGY in specilizations:
			return {
				"metrics":{
					RESOURCE.BASE_METRICS.MORALE: 1
				}
			}
		return {},
	# ------------------------------------------		
}

var R_AND_D_LAB:Dictionary = {
	"name": "R&D LAB",
	"shortname": "R&D LAB",
	"tier": TIER.VAL.ONE,
	"img_src": "res://Media/rooms/research_lab.jpg",
	"description": "Enables research and development.",

	# ------------------------------------------
	"can_contain": false,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------
		
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			{
				"name": "UPGRADE +1",
				"use_at": 0,
				"use_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.ENERGY: -1
					},
				"conditional": func(gpc:Dictionary) -> Dictionary:
					gpc[CONDITIONALS.TYPE.ENABLE_UPGRADES] = 1
					return gpc,
			}
		],	
	# ------------------------------------------

	# ------------------------------------------
	"unlock_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -30
				},
		}	
	},
		
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},
	
	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	}	
	# ------------------------------------------
}

var CONSTRUCTION_YARD:Dictionary = {
	"name": "CONSTRUCTION YARD",
	"shortname": "C.YARD",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/construction_yard.jpg",
	"description": "Enables base development.",

	# ------------------------------------------
	"can_contain": false,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	"resource_requirements": [
		RESOURCE.TYPE.SECURITY
	],	
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [

		],	
	# ------------------------------------------

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},
	
	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	}	
	# ------------------------------------------
}

var BARRICKS:Dictionary = {
	"name": "BARRICKS",
	"shortname": "BARRICKS",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/rooms/barricks.jpg",
	"description": "Houses security forces.",

	# ------------------------------------------
	"can_contain": false,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	"resource_requirements": [],	
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			{
				"name": "SUPPLY SECURITY",
				"use_at": 0,
				"use_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.ENERGY: -1
					},
				"provides": [
					RESOURCE.TYPE.SECURITY
				]
			},
		],	
	# ------------------------------------------

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},
		
	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	}	
	# ------------------------------------------
}

var DORMITORY:Dictionary = {
	"name": "DORMITORY",
	"shortname": "DORM",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/images/redacted.png",
	"description": "Houses facility staff.",
	
	# ------------------------------------------
	"can_contain": false,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------
		
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			{
				"name": "SUPPLY STAFF",
				"use_at": 0,
				"use_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.ENERGY: -1
					},
				"provides": [
					RESOURCE.TYPE.STAFF,
				]
			}
		],	
	# ------------------------------------------

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},

	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	}	
	# ------------------------------------------
}

var HOLDING_CELLS:Dictionary = {
	"name": "HOLDING CELLS",
	"shortname": "H CELLS",
	"tier": TIER.VAL.TWO,
	"img_src": "res://Media/images/redacted.png",
	"description": "Houses D-class personel.",
	
	# ------------------------------------------
	"can_contain": false,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			{
				"name": "SUPPLY DCLASS",
				"use_at": 0,
				"use_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.ENERGY: -1
					},
				"provides": [
					RESOURCE.TYPE.DCLASS,
				]
			}
		],	
	# ------------------------------------------	

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},

	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	}	
	# ------------------------------------------
}

var HR_DEPARTMENT:Dictionary = {
	"name": "HUMAN RESOURCES DEPARTMENT",
	"shortname": "HR DEPT",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/images/redacted.png",
	"description": "Enables recruitment of key staff.",
	
	# ------------------------------------------
	"can_contain": false,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------
		
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			{
				"name": "HIRE STAFF",
				"use_at": 0,
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"cooldown_duration":  7, 
				"effect": func() -> bool:
					return await GAME_UTIL.recruit_new_personel(RESOURCE.TYPE.STAFF, 10),
			},
			{
				"name": "HIRE SECURITY",
				"use_at": 0,
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"cooldown_duration":  7, 
				"effect": func() -> bool:
					return await GAME_UTIL.recruit_new_personel(RESOURCE.TYPE.SECURITY, 10),
			},
			{
				"name": "HIRE TECHNICANS",
				"use_at": 0,
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"cooldown_duration":  7, 
				"effect": func() -> bool:
					return await GAME_UTIL.recruit_new_personel(RESOURCE.TYPE.TECHNICIANS, 10),
			}
		],	
	# ------------------------------------------

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},

	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	}	
	# ------------------------------------------
}

var HUME_DETECTOR:Dictionary = {
	"name": "HUME DETECTOR",
	"shortname": "HUME DET",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/images/redacted.png",
	"description": "Makes hume levels visible.",
	
	# ------------------------------------------
	"can_contain": false,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},

	"operating_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	}	
	# ------------------------------------------
}

var CONTAINMENT_CELL:Dictionary = {
	"name": "CONTAINMENT_CELL",
	"shortname": "C.CELL",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/images/redacted.png",
	"description": "A basic room with a high security lock.  Used to contain SCPs.",
	
	# ------------------------------------------
	"can_contain": true,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			{
				"name": "CONTAIN SCP",
				"use_at": 0,
				"cooldown_duration":  14, 
				"effect": func() -> bool:
					return await GAME_UTIL.contain_scp(),
			}
		],	
	# ------------------------------------------	
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			{
				"name": "STATION GUARDS",
				"use_at": 0,
				"use_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"effect": func() -> Dictionary:
					return {
						"metrics":{
							RESOURCE.BASE_METRICS.READINESS: 1
						}
					},
			}
		],	
	# ------------------------------------------	

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},

	"operating_costs": {
		"resources": {
			"metrics": func() -> Dictionary:
				return {
					RESOURCE.BASE_METRICS.SAFETY: 2
			},
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	},
	# ------------------------------------------	
	"specilization_bonus": func(specilizations:Array) -> Dictionary:
		if RESEARCHER.SPECIALIZATION.BIOLOGIST in specilizations:
			return {
				"resource":{
					RESOURCE.TYPE.ENERGY: 2
				},
			}
		if RESEARCHER.SPECIALIZATION.PSYCHOLOGY in specilizations:
			return {
				"metrics":{
					RESOURCE.BASE_METRICS.MORALE: 1
				}
			}
		return {},
	# ------------------------------------------
}

var ENGINEERING_BAY:Dictionary = {
	"name": "ENGINEERING BAY",
	"shortname": "ENG. BAY",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/images/redacted.png",
	"description": "Increases the upgrade level of the entire wing.",
	
	# ------------------------------------------
	"can_contain": false,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 2,
	"build_time": 1,
	"resource_requirements": [
		# RESOURCE.TYPE.TECHNICIANS
	],		
	# ------------------------------------------
	
	# ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#{
				#"name": "CONTAIN",
				#"unlock_cost": func() -> Dictionary:
					#return {
						#RESOURCE.TYPE.SCIENCE: -20
					#},
				#"cooldown_duration":  7, 
				#"effect": func() -> bool:
					#return await GAME_UTIL.contain_scp(),
			#}
		#],	
	# ------------------------------------------	
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			{
				"name": "UPGRADE LVL 2",
				"use_at": 0,
				"energy_cost": 3,
				"update_room_config": func(ring_config_data:Dictionary) -> Dictionary:
					if ring_config_data.ability_level < 1:
						ring_config_data.ability_level = 1
					return ring_config_data,
			},
			{
				"name": "UPGRADE LVL 3",
				"use_at": 1,
				"energy_cost": 1,
				"update_room_config": func(ring_config_data:Dictionary) -> Dictionary:
					if ring_config_data.ability_level == 1:
						ring_config_data.ability_level = 2
					return ring_config_data,
			}			
		],	
	# ------------------------------------------	

	# ------------------------------------------
	"purchase_costs": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -20
				},
		}	
	},

	"operating_costs": {
		"resources": {
			"metrics": func() -> Dictionary:
				return {
					RESOURCE.BASE_METRICS.SAFETY: 2
			},
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.MONEY: -1
				},
		}	
	},
	# ------------------------------------------	
	"specilization_bonus": func(specilizations:Array) -> Dictionary:
		if RESEARCHER.SPECIALIZATION.BIOLOGIST in specilizations:
			return {
				"resource":{
					RESOURCE.TYPE.ENERGY: 2
				},
			}
		if RESEARCHER.SPECIALIZATION.PSYCHOLOGY in specilizations:
			return {
				"metrics":{
					RESOURCE.BASE_METRICS.MORALE: 1
				}
			}
		return {},
	# ------------------------------------------
}

var reference_data:Dictionary = {
	# TIER ZERO
	ROOM.TYPE.DIRECTORS_OFFICE: DIRECTORS_OFFICE,
	ROOM.TYPE.HQ: HQ,
	ROOM.TYPE.AQUISITION_DEPARTMENT: AQUISITION_DEPARTMENT,
	ROOM.TYPE.BARRICKS: BARRICKS,
	ROOM.TYPE.DORMITORY: DORMITORY,
	ROOM.TYPE.HR_DEPARTMENT: HR_DEPARTMENT,
	ROOM.TYPE.CONSTRUCTION_YARD: CONSTRUCTION_YARD,
	ROOM.TYPE.ENGINEERING_BAY: ENGINEERING_BAY,
	## TIER ONE
	
	ROOM.TYPE.R_AND_D_LAB: R_AND_D_LAB,
	#4: DIRECTORS_OFFICE,
	#5: DIRECTORS_OFFICE,
	#6: DIRECTORS_OFFICE,
	#7: DIRECTORS_OFFICE,
	#8: DIRECTORS_OFFICE,
	#9: DIRECTORS_OFFICE,
	#10: DIRECTORS_OFFICE,
	#11: DIRECTORS_OFFICE,
	#12: DIRECTORS_OFFICE,
	#13: DIRECTORS_OFFICE,
	#14: DIRECTORS_OFFICE,
	#15: DIRECTORS_OFFICE,
	#16: DIRECTORS_OFFICE,
	#17: DIRECTORS_OFFICE,
	#18: DIRECTORS_OFFICE,
	
	#ROOM.TYPE.CONSTRUCTION_YARD: CONSTRUCTION_YARD,
	#ROOM.TYPE.BARRICKS: BARRICKS,
	#ROOM.TYPE.DORMITORY: DORMITORY,
	
	#ROOM.TYPE.HOLDING_CELLS: HOLDING_CELLS,
	ROOM.TYPE.CONTAINMENT_CELL: CONTAINMENT_CELL,
	
	#ROOM.TYPE.HUME_DETECTOR: HUME_DETECTOR,
	
}

#var tier_data:Dictionary = {
	#TIER.VAL.ZERO: {
		#"name": "ADMIN",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 0,
			#},
	#},
	#TIER.VAL.ONE: {
		#"name": "CONTAINMENT",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 5,
			#},
	#},
	#TIER.VAL.TWO: {
		#"name": "ADVANCED",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 50,
			#},
	#},
	#TIER.VAL.THREE: {
		#"name": "METAPHYSICAL",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 250,
			#},
	#},
	#TIER.VAL.FOUR: {
		#"name": "TECHNOLOGICAL",
		#"get_unlock_cost": func() -> Dictionary:
			#return {
				#RESOURCE.TYPE.MONEY: 500,
			#},
	#},
#}



#
## ------------------------------------------------------------------------------
#func return_tier_data(key:TIER.VAL) -> Dictionary:
	#tier_data[key].ref = key
	#return tier_data[key]
## ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_data(ref:ROOM.TYPE) -> Dictionary:
	reference_data[ref].ref = ref
	return reference_data[ref]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_placement_instructions(ref:ROOM.TYPE) -> Array:
	return SHARED_UTIL.return_placement_instructions(return_data(ref))
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_unavailable_rooms(ref:ROOM.TYPE, room_config:Dictionary) -> Array: 
	return SHARED_UTIL.return_unavailable_rooms(return_data(ref))
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func return_ability(ref:ROOM.TYPE, ability_index:int) -> Dictionary:
	var room_data:Dictionary = return_data(ref)
	var abilities:Array = room_data.abilities.call() if "abilities" in room_data else []
	return abilities[ability_index]
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	
func return_passive_ability(ref:ROOM.TYPE, ability_index:int) -> Dictionary:
	var room_data:Dictionary = return_data(ref)
	var abilities:Array = room_data.passive_abilities.call() if "passive_abilities" in room_data else []
	return abilities[ability_index]
# ------------------------------------------------------------------------------		
	
# ------------------------------------------------------------------------------
func return_ability_cost(ref:ROOM.TYPE, ability_index:int) -> Array:
	var room_data:Dictionary = return_data(ref)
	var abilities:Array = room_data.abilities.call() if "abilities" in room_data else []
	if abilities.size() >= ability_index:
		var list:Array = []
		var unlock_cost:Dictionary = abilities[ability_index].unlock_cost.call()
		for key in unlock_cost:
			var amount:int = unlock_cost[key]
			list.push_back({"type": "amount", "amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
		return list
	else:
		return []
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_passive_abilities_cost(ref:ROOM.TYPE, ability_index:int) -> Array:
	var room_data:Dictionary = return_data(ref)
	var abilities:Array = room_data.passive_abilities.call() if "passive_abilities" in room_data else []
	if abilities.size() >= ability_index:
		var list:Array = []
		var unlock_cost:Dictionary = abilities[ability_index].use_cost.call()
		for key in unlock_cost:
			var amount:int = unlock_cost[key]
			list.push_back({"type": "amount", "amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
		return list
	else:
		return []
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_purchase_cost(ref:ROOM.TYPE) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "purchase_costs")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_unlock_costs(ref:ROOM.TYPE) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "unlock_costs")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_operating_cost(ref:ROOM.TYPE) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "operating_costs")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_activation_cost(ref:ROOM.TYPE) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "activation_cost")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_specilization_bonus(ref:ROOM.TYPE, specilizations:Array) -> Array:
	var data:Dictionary = return_data(ref)	
	var list:Array = []
	
	if "specilization_bonus" in data:
		var spec_bonus:Dictionary = data.specilization_bonus.call(specilizations)
		if "ap" in spec_bonus:
			list.push_back({"type": "ap", "amount": spec_bonus.ap})	
		if "resource" in spec_bonus:
			for key in spec_bonus.resource:
				list.push_back({"type": "amount", "amount": spec_bonus.resource[key], "resource": RESOURCE_UTIL.return_data(key)})	
		if "metrics" in spec_bonus:
			for key in spec_bonus.metrics:
				list.push_back({"type": "metrics", "amount": spec_bonus.metrics[key], "resource": RESOURCE_UTIL.return_metric_data(key)})	
	return list
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
var room_speclization_lookup:Dictionary = {} # makes it so this only has to do the lookup once
func return_room_speclization_preferences(ref:ROOM.TYPE) -> Array:
	if ref in room_speclization_lookup:
		return room_speclization_lookup[ref]
	
	var list:Array = []
	var room_data:Dictionary = return_data(ref)
	if "specilization_bonus" not in room_data:
		room_speclization_lookup[ref] = []
		return list
	
	for key in RESEARCHER.SPECIALIZATION:
		var enum_val:int = RESEARCHER.SPECIALIZATION[key]
		var spec_bonus:Dictionary = room_data.specilization_bonus.call([enum_val])
		if !spec_bonus.is_empty():
			var details:Dictionary = RESEARCHER_UTIL.return_specialization_data(enum_val)
			var bonus_list:Array = return_specilization_bonus(ref, [enum_val])
			list.push_back({"details": details, "bonus": bonus_list})
	
	room_speclization_lookup[ref] = list
	return list
# ------------------------------------------------------------------------------			

# ------------------------------------------------------------------------------			
func return_refs_that_can_contain() -> Array:
	var refs:Array = []
	for ref in reference_data:
		if "can_contain" in reference_data[ref] and reference_data[ref].can_contain:
			refs.push_back(ref)		
	return refs
# ------------------------------------------------------------------------------			
	

# ------------------------------------------------------------------------------
func calculate_unlock_cost(ref:ROOM.TYPE, add:bool = false) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "unlock_costs", resources_data, add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_purchase_cost(ref:ROOM.TYPE, add:bool = false) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "purchase_costs", resources_data, add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_operating_costs(ref:ROOM.TYPE, add:bool = true) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "operating_costs", resources_data, add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
#func calculate_activation_cost(ref:ROOM.TYPE, refund:bool = false) -> Dictionary:	
	#var room_data:Dictionary = return_data(ref)
	#var resource_data_copy:Dictionary = resources_data.duplicate(true)
#
	#if "activation_cost" in room_data:
		#for prop in ["amount", "personnel"]:
			#if prop in room_data.activation_cost.resources:
				#var dict:Dictionary = room_data.activation_cost.resources[prop].call()
				#for key in dict:
					#var amount:int = absi(dict[key])
					#resource_data_copy[key].utilized += amount if !refund else -amount
					#resource_data_copy[key].amount -= amount if !refund else -amount
					#if resource_data_copy[key].amount < 0:
						#resource_data_copy[key].amount = 0
	#
	#return resource_data_copy
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_count(ref:ROOM.TYPE) -> int:
	return purchased_facility_arr.filter(func(i):return i.ref == ref).size()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func owns_and_is_active(ref:ROOM.TYPE) -> bool:
	var filter:Array = purchased_facility_arr.filter(func(i):return i.ref == ref)
	if filter.size() == 0:
		return false
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(filter[0].location)
	return room_extract.is_activated
# ------------------------------------------------------------------------------	

## ------------------------------------------------------------------------------
#func get_tier_dict() -> Dictionary:
	#return SHARED_UTIL.return_tier_dict(tier_data)
## ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_paginated_list(tier:TIER.VAL, start_at:int, limit:int) -> Dictionary:
	var facility_refs:Array = U.array_find_uniques(purchased_facility_arr.map(func(i): return i.ref))
	var filter:Callable = func(list:Array) -> Array:
		return list.filter(func(i): return i.details.tier == tier)
	return SHARED_UTIL.return_tier_paginated(reference_data, filter, start_at, limit)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_all_unlocked_paginated_list(start_at:int, limit:int)  -> Dictionary:
	var facility_refs:Array = U.array_find_uniques(purchased_facility_arr.map(func(i): return i.ref))
	var filter:Callable = func(list:Array) -> Array:
		
		if !gameplay_conditionals[CONDITIONALS.TYPE.BASE_IS_SETUP]:	
			# base not setup, only return two options
			return list.filter(func(i): return i.ref in [ROOM.TYPE.DIRECTORS_OFFICE, ROOM.TYPE.HQ])		
		else:
			# once base is setup, should return all unlocked
			return list.filter(func(i): 
				if "requires_unlock" not in i.details:
					return true
				return true if !i.details.requires_unlock else i.ref in shop_unlock_purchases
			)			

	return SHARED_UTIL.return_tier_paginated(reference_data, filter, start_at, limit)
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
# remove this later
func return_wing_effects_list(room_extract:Dictionary) -> Array:
	return []
	#return SHARED_UTIL.return_wing_effects_list(return_data(room_extract.room.details.ref), room_extract, "activation_effect")
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------		
func return_wing_effect(extract_data:Dictionary) -> Dictionary:
	var room_data:Dictionary = return_data(extract_data.room.details.ref)
	if "wing_effect" in room_data:
		return room_data.wing_effect.call(extract_data)
	
	return {}
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------
func has_prerequisites(ref:ROOM.TYPE, arr:Array) -> bool:
	var room_data:Dictionary = return_data(ref)
	return	false
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func at_own_limit(ref:ROOM.TYPE) -> bool:
	var room_data:Dictionary = return_data(ref)
	if "own_limit" not in room_data or room_data.own_limit == -1:
		return false
	var owned_count:int = purchased_facility_arr.filter(func(i): return i.ref == ref).size()
	var in_progress_count:int = timeline_array.filter(func(i): return i.ref == ref and i.action == ACTION.AQ.BUILD_ITEM).size()
	var total_count:int = owned_count + in_progress_count
	
	return total_count >= room_data.own_limit
# ------------------------------------------------------------------------------
