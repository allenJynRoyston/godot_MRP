@tool
extends UtilityWrapper

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
	"abilities": func() -> Array: 
		return [
			{
				"name": "AQUIRE SCP",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  5, 
				"effect": func(GameplayNode:Control) -> bool:
					return await GameplayNode.get_new_scp(),
			},
			{
				"name": "PROMOTE RESEARCHER",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  5, 
				"effect": func(GameplayNode:Control) -> bool:
					return await GameplayNode.promote_researchers(),
			},
			{
				"name": "ABILITY 2",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  5, 
				"effect": func() -> void:
					pass,
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
					
				},
		}	
	},
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
		"resources": {
			"amount": func() -> Dictionary:
				return {

				},
		}	
	},	
	
	"operating_costs": {
		"resources": {
			"metrics": func() -> Dictionary:
				return {
					RESOURCE.BASE_METRICS.SAFETY: -1
			},			
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
				"name": "HIRE RESEARCHER (1 OPTION)",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  5, 
				"effect": func(GameplayNode:Control) -> bool:
					return await GameplayNode.recruit_new_researcher(1),
			},
			{
				"name": "HIRE RESEARCHER (1 OPTION)",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  7, 
				"effect": func(GameplayNode:Control) -> bool:
					return await GameplayNode.recruit_new_researcher(2),
			},
			{
				"name": "HIRE RESEARCHER (1 OPTION)",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  10, 
				"effect": func(GameplayNode:Control) -> bool:
					return await GameplayNode.recruit_new_researcher(3),
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
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					
				},
		}	
	},		
	
	"activation_effect": {
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
				"name": "UNLOCK FACILITIES",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  1, 
				"effect": func(GameplayNode:Control) -> bool:
					return await GameplayNode.open_store(),
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
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
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
	"can_contain": true,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------
		
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			{
				"name": "ENABLE UPGRADES",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  1, 
				"conditional": func(gpc:Dictionary) -> Dictionary:
					gpc[CONDITIONALS.TYPE.ENABLE_UPGRADES] = true
					return gpc,
			},
			{
				"name": "UPGRADE +",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  2, 
				"conditional": func(gpc:Dictionary) -> Dictionary:
					gpc[CONDITIONALS.TYPE.UPGRADE_LEVEL] += 1
					return gpc,
			},
			{
				"name": "UPGRADE ++",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  3, 
				"conditional": func(gpc:Dictionary) -> Dictionary:
					gpc[CONDITIONALS.TYPE.UPGRADE_LEVEL] += 1
					return gpc,
			},
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
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
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
				"name": "ABILITY X",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  1, 
				"effect": func(GameplayNode:Control) -> void:
					pass,
					#await GameplayNode.recruit_new_researcher(1),
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
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
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
	"can_contain": true,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			{
				"name": "TRAIN (INCREASE READINESS)",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  1, 
				"effect": func() -> Dictionary:
					return {
						"metrics":{
							RESOURCE.BASE_METRICS.READINESS: 1
						}
					},
			},
			{
				"name": "TRAIN (INCREASE SAFETY)",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  2, 
				"effect": func() -> Dictionary:
					return {
						"metrics":{
							RESOURCE.BASE_METRICS.SAFETY: 1
						}
					},
			},
			{
				"name": "TRAIN (INCREASE MORALE)",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  3, 
				"effect": func() -> Dictionary:
					return {
						"metrics":{
							RESOURCE.BASE_METRICS.MORALE: 1
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
		
	"activation_cost": {
		"resources": {
			"personnel": func() -> Dictionary:
				return {
					RESOURCE.TYPE.STAFF: -7,
				},
		}	
	},		
	
	"activation_effect": {
		"resources": {
			"metrics": func() -> Dictionary:
				return {
					RESOURCE.BASE_METRICS.SAFETY: 3
				},
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
	"can_contain": true,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------
		
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			{
				"name": "HOUSE 10",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  1, 
				"capacity": func() -> Dictionary:
					return {
						RESOURCE.TYPE.STAFF: 10,
					},
			},
			{
				"name": "HOUSE 20",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  2, 
				"capacity": func() -> Dictionary:
					return {
						RESOURCE.TYPE.STAFF: 20,
					},
			},
			{
				"name": "HOUSE 30",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  3, 
				"capacity": func() -> Dictionary:
					return {
						RESOURCE.TYPE.STAFF: 30,
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
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
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
	"can_contain": true,
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
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
				},
		}	
	},		
	
	"activation_effect": {
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
				"name": "HIRE STAFF",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  7, 
				"effect": func(GameplayNode:Control) -> bool:
					return await GameplayNode.recruit_new_personel(RESOURCE.TYPE.STAFF, 10),
			},
			#{
				#"name": "FIRE STAFF",
				#"available_at_lvl": 0, 
				#"ap_cost":  7, 
				#"effect": func(GameplayNode:Control) -> bool:
					#return await GameplayNode.fire_personel(RESOURCE.TYPE.STAFF, 10),
			#},			
			{
				"name": "HIRE SECURITY",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  7, 
				"effect": func(GameplayNode:Control) -> bool:
					return await GameplayNode.recruit_new_personel(RESOURCE.TYPE.SECURITY, 10),
			},
			{
				"name": "HIRE TECHNICANS",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  7, 
				"effect": func(GameplayNode:Control) -> bool:
					return await GameplayNode.recruit_new_personel(RESOURCE.TYPE.TECHNICIANS, 10),
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
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -1,
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
	"can_contain": true,
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
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					RESOURCE.TYPE.ENERGY: -5,
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

var STANDARD_LOCKER:Dictionary = {
	"name": "STANDARD_LOCKER",
	"shortname": "S.LOCKER",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/images/redacted.png",
	"description": "A basic room with a high security lock.",
	
	# ------------------------------------------
	"can_contain": true,
	"can_destroy": false,
	"requires_unlock": false,	
	"own_limit": 1,
	"build_time": 1,
	# ------------------------------------------
	
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			{
				"name": "STATION GUARDS",
				"unlock_cost": func() -> Dictionary:
					return {
						RESOURCE.TYPE.SCIENCE: -20
					},
				"ap_cost":  1, 
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
		
	"activation_cost": {
		"resources": {
			"amount": func() -> Dictionary:
				return {
					
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
	ROOM.TYPE.STANDARD_LOCKER: STANDARD_LOCKER,
	
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
		var unlock_cost:Dictionary = abilities[ability_index].unlock_cost.call()
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
func calculate_activation_cost(ref:ROOM.TYPE, refund:bool = false) -> Dictionary:	
	var room_data:Dictionary = return_data(ref)
	var resource_data_copy:Dictionary = resources_data.duplicate(true)

	if "activation_cost" in room_data:
		for prop in ["amount", "personnel"]:
			if prop in room_data.activation_cost.resources:
				var dict:Dictionary = room_data.activation_cost.resources[prop].call()
				for key in dict:
					var amount:int = absi(dict[key])
					resource_data_copy[key].utilized += amount if !refund else -amount
					resource_data_copy[key].amount -= amount if !refund else -amount
					if resource_data_copy[key].amount < 0:
						resource_data_copy[key].amount = 0
	
	return resource_data_copy
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
	var room_extract:Dictionary = extract_room_details(filter[0].location)
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
		# once base is setup, should return all unlocked
		if gameplay_conditionals[CONDITIONALS.TYPE.BASE_IS_SETUP]:	
			return list.filter(func(i): 
				if "requires_unlock" not in i.details:
					return true
				return true if !i.details.requires_unlock else i.ref in shop_unlock_purchases
			)
		# else, just the directors office and hq
		else:
			return list.filter(func(i): return i.ref in [ROOM.TYPE.DIRECTORS_OFFICE, ROOM.TYPE.HQ])
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

# ------------------------------------------------------------------------------
func extract_room_details(current_location:Dictionary, use_config:Dictionary = room_config) -> Dictionary:
	var designation:String = U.location_to_designation(current_location)
	var floor:int = current_location.floor
	var ring:int = current_location.ring
	var room:int = current_location.room

	var floor_data:Dictionary = use_config.floor[floor]
	var wing_data:Dictionary = use_config.floor[floor].ring[ring]
	var room_config_data:Dictionary = use_config.floor[floor].ring[ring].room[room]
	var is_room_empty:bool = room_config_data.room_data.is_empty()
	var can_purchase:bool = room_config_data.build_data.is_empty() and room_config_data.room_data.is_empty()
	var is_room_under_construction:bool  = !room_config_data.build_data.is_empty()
	var room_details:Dictionary = {} if is_room_empty else room_config_data.room_data.details 
	var room_base_state:Dictionary = {} if is_room_empty else room_config_data.room_data.base_state 
	
	var is_activated:bool = false if is_room_empty else room_base_state.is_activated 
	var can_activate:bool = false if is_room_empty else (RESOURCE_UTIL.check_if_have_enough(ROOM_UTIL.return_activation_cost(room_config_data.room_data.ref)) if !is_activated else false)
	var can_contain:bool = false if is_room_empty else room_details.can_contain
	var can_destroy:bool = false if is_room_empty else room_details.can_destroy
	var ap_diff_amount:int = 1 if is_activated else 0
	var abilities:Array = [] if (is_room_empty or "abilities" not in room_details) else room_details.abilities.call()	
	var passive_abilities:Array = [] if (is_room_empty or "passive_abilities" not in room_details) else room_details.passive_abilities.call()	
	var passives_enabled:Array = [] if is_room_empty else room_base_state.passives_enabled
	var abilities_unlocked:Array = [] if is_room_empty else room_base_state.abilities_unlocked
	var passives_unlocked:Array = [] if is_room_empty else room_base_state.passives_unlocked
	
	var scp_data:Dictionary = room_config_data.scp_data 
	var is_scp_empty:bool = scp_data.is_empty()
	var scp_details:Dictionary = {} if is_scp_empty else SCP_UTIL.return_data(scp_data.ref)
	var is_transfer:bool = false #if is_scp_empty else room_config_data.scp_data.is_transfer
	var is_contained:bool = false #if is_scp_empty else room_config_data.scp_data.is_contained
	
	var researchers:Array = hired_lead_researchers_arr.filter(func(x):
		var details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(x[0])
		if (!details.props.assigned_to_room.is_empty() and U.location_to_designation(details.props.assigned_to_room) == designation):
			return true
		return false	
	).map(func(x):return RESEARCHER_UTIL.return_data_with_uid(x[0]))
	

	# tracks 
	var resource_details:Dictionary = {
		# captures just for room
		"room": {},
		# all resources for scp
		"scp": {},
		# 
		"researchers": {},
		# combines room, scp and researchers 
		"facility": {},
		#
		"traits": {},
		"synergy_traits": {},
		"total": {},
	}
	var metric_details:Dictionary = {
		# captures just for room
		"room": {},
		# all resources for scp
		"scp": {},
		# 
		"researchers": {},
		# combines room, scp and researchers 
		"facility": {},
		#
		"traits": {},
		"synergy_traits": {},
		"total": {},
	}
	

	# get resources spent/added by rooms
	if !is_room_empty:
		for item in return_operating_cost(room_details.ref):
			match item.type:
				# -----------------------
				"amount":
					if item.resource.ref not in resource_details.room:
						resource_details.room[item.resource.ref] = 0
					if item.resource.ref not in resource_details.facility:
						resource_details.facility[item.resource.ref] = 0
					if item.resource.ref not in resource_details.total:
						resource_details.total[item.resource.ref] = 0
					resource_details.room[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
					resource_details.facility[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
					resource_details.total[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
				# -----------------------
				"metrics":
					if item.resource.ref not in metric_details.room:
						metric_details.room[item.resource.ref] = 0
					if item.resource.ref not in metric_details.facility:
						metric_details.facility[item.resource.ref] = 0
					if item.resource.ref not in metric_details.total:
						metric_details.total[item.resource.ref] = 0

					metric_details.room[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
					metric_details.facility[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
					metric_details.total[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
				
	
	# get resources spent/added by scp
	if !is_scp_empty:
		for item in SCP_UTIL.return_ongoing_containment_rewards(scp_details.ref):
			match item.type:
				# -----------------------
				"amount":
					if item.resource.ref not in resource_details.scp:
						resource_details.scp[item.resource.ref] = 0
					if item.resource.ref not in resource_details.facility:
						resource_details.facility[item.resource.ref] = 0
					if item.resource.ref not in resource_details.total:
						resource_details.total[item.resource.ref] = 0
						
					resource_details.facility[item.resource.ref] += item.amount if is_contained else 0
					resource_details.scp[item.resource.ref] += item.amount if is_contained else 0
					resource_details.total[item.resource.ref] += item.amount if is_contained else 0
				# -----------------------
				"metrics":
					if item.resource.ref not in metric_details.scp:
						metric_details.scp[item.resource.ref] = 0
					if item.resource.ref not in metric_details.facility:
						metric_details.facility[item.resource.ref] = 0
					if item.resource.ref not in metric_details.total:
						metric_details.total[item.resource.ref] = 0

					metric_details.scp[item.resource.ref] += item.amount if is_contained else 0
					metric_details.facility[item.resource.ref] += item.amount if is_contained else 0
					metric_details.total[item.resource.ref] += item.amount if is_contained else 0
	

	var total_traits_list := []
	var synergy_traits := []
	var dup_list := []		
	var trait_list := []
	var synergy_trait_list := []

	for researcher in researchers:
		# records researcher profession bonus (I.E. ECONOMIST, PSYCHOLOGIST, etc)
		if !is_room_empty:
			var spec_bonus:Array = ROOM_UTIL.return_specilization_bonus(room_details.ref, researcher.specializations)
			for item in spec_bonus:
				match item.type:
					"ap":
					# -----------------------
						ap_diff_amount += item.amount
					# -----------------------
					"resource":
						if item.resource.ref not in resource_details.researchers:
							resource_details.researchers[item.resource.ref] = 0
						if item.resource.ref not in resource_details.facility:
							resource_details.facility[item.resource.ref] = 0					
						if item.resource.ref not in resource_details.total:
							resource_details.total[item.resource.ref] = 0
							
						resource_details.researchers[item.resource.ref] += item.amount
						resource_details.facility[item.resource.ref] += item.amount
						resource_details.total[item.resource.ref] += item.amount
					# -----------------------
					"metrics":
						if item.resource.ref not in metric_details.researchers:
							metric_details.researchers[item.resource.ref] = 0
						if item.resource.ref not in metric_details.facility:
							metric_details.facility[item.resource.ref] = 0					
						if item.resource.ref not in metric_details.total:
							metric_details.total[item.resource.ref] = 0
							
						metric_details.researchers[item.resource.ref] += item.amount
						metric_details.facility[item.resource.ref] += item.amount
						metric_details.total[item.resource.ref] += item.amount					

		# add selected to selected list	
		total_traits_list.push_back(researcher.traits)

	# records bonus from traits
	for traits in total_traits_list:
		for t in traits:
			if t not in dup_list:
				var traits_detail:Dictionary = RESEARCHER_UTIL.return_trait_data(t)
				var effect:Dictionary = traits_detail.get_effect.call({"room_details": room_details, "scp_details": scp_details, "resource_details": resource_details})
				var resource_list:Array = []
				var metric_list:Array = []
				# -------------------
				if "resource" in effect:
					for key in effect.resource:
						var amount:int = effect.resource[key]
						
						if key not in resource_details.traits:
							resource_details.traits[key] = 0
						if key not in resource_details.total:
							resource_details.total[key] = 0
						resource_details.traits[key] += amount
						resource_details.total[key] += amount
						
						resource_list.push_back({"resource": RESOURCE_UTIL.return_data(key), "amount": amount})
				# -------------------
				if "metrics" in effect:
					for key in effect.metrics:
						var amount:int = effect.metrics[key]
						
						if key not in metric_details.traits:
							metric_details.traits[key] = 0
						if key not in metric_details.total:
							metric_details.total[key] = 0
						metric_details.traits[key] += amount
						metric_details.total[key] += amount
						
						metric_list.push_back({"resource": RESOURCE_UTIL.return_metric_data(key), "amount": amount})						
							
				trait_list.push_back({"details": traits_detail, "effect": {"resource_list": resource_list, "metric_list": metric_list}} )
	
	# records bonus from synergy traits
	if total_traits_list.size() == 2:
		var list:Array = RESEARCHER_UTIL.return_trait_synergy(total_traits_list[0], total_traits_list[1])
		for details in list:
			var effect:Dictionary = details.get_effect.call({"room_details": room_details, "scp_details": scp_details, "resource_details": resource_details})
			var resource_list:Array = []
			var metric_list:Array = []
			# -------------------
			if "resource" in effect:
				for key in effect.resource:
					var amount:int = effect.resource[key]
					
					if key not in resource_details.synergy_traits:
						resource_details.synergy_traits[key] = 0
					if key not in resource_details.total:
						resource_details.total[key] = 0
					resource_details.synergy_traits[key] += amount
					resource_details.total[key] += amount
					
					resource_list.push_back({"resource": RESOURCE_UTIL.return_data(key), "amount": amount})
			# -------------------
			if "metrics" in effect:
				for key in effect.metrics:
					var amount:int = effect.metrics[key]

					if key not in metric_details.traits:
						metric_details.traits[key] = 0
					if key not in metric_details.total:
						metric_details.total[key] = 0
					metric_details.traits[key] += amount
					metric_details.total[key] += amount					
					
					metric_list.push_back({"resource": RESOURCE_UTIL.return_metric_data(key), "amount": amount})		
						
			synergy_trait_list.push_back({"details": details, "effect": {"resource_list": resource_list, "metric_list": metric_list}} )
			
			
	# change ap_diff value for enabled passives
	for index in passive_abilities.size():
		var ability:Dictionary = passive_abilities[index]
		if index in passives_enabled:
			ap_diff_amount -= ability.ap_cost
	
	# convert resource as a dict to a list form for easy reading
	var resources_as_list:Array = []
	for key in resource_details.total:
		var amount:int = resource_details.total[key]
		resources_as_list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_data(key)})

	return {
		"floor_config_data": floor_data,
		"wing_config_data": wing_data,
		"room_config_data": room_config_data,
		# -----
		"is_directors_office": room_details.ref == ROOM.TYPE.DIRECTORS_OFFICE if !room_details.is_empty() else false,
		"is_hq": room_details.ref == ROOM.TYPE.HQ if !room_details.is_empty() else false,
		"is_room_empty": room_details.is_empty(),
		"is_room_under_construction": is_room_under_construction,
		"is_activated": is_activated,
		"can_activate": can_activate,
		"can_contain": can_contain,
		"can_destroy": can_destroy,
		"room_category": ROOM.CATEGORY.CONTAINMENT_CELL if (!room_details.is_empty() and room_details.can_contain) else ROOM.CATEGORY.FACILITY,
		# ------		
		"is_scp_empty": is_scp_empty,
		#"is_scp_transfering": is_transfer,
		#"is_scp_contained": is_contained,
		#"is_scp_testing": !is_transfer and is_contained and researchers.size() > 0,
		# ------
		"researchers_count": researchers.size(),
		"room_base_state": room_base_state, 
		# -----
		"room": {						
			"details": room_details if !is_room_under_construction else ROOM_UTIL.return_data(room_config_data.build_data.ref),
			"abilities_unlocked": abilities_unlocked,
			"passives_unlocked": passives_unlocked,
			"abilities": abilities,
			"passive_abilities": passive_abilities,
			"passives_enabled": passives_enabled,						
			# current amount
			"ap": 0 if room_base_state.is_empty() else room_base_state.ap,
			# charge rate
			"ap_diff": 0 if room_base_state.is_empty() else ap_diff_amount,
			# upgrade level
			#"upgrade_level": 0 if room_base_state.is_empty() else room_base_state.upgrade_level,
		} if !is_room_empty or is_room_under_construction else {},
		"scp": {
			"details": scp_details,
			#"is_transfer": is_transfer,
			#"is_contained": is_contained,
		} if !is_scp_empty else {},
		"trait_list": trait_list,
		"synergy_trait_list": synergy_trait_list,
		"resources_as_list": resources_as_list,
		"resource_details": resource_details,
		"metric_details": metric_details,
		"researchers": researchers
	}
# ------------------------------------------------------------------------------	
