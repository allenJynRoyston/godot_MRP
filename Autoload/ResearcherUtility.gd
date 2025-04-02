extends SubscribeWrapper

var specialization_data:Dictionary = { 
	RESEARCHER.SPECIALIZATION.PSYCHOLOGY: {
		"name": "PSYCHOLOGY",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.BIOLOGIST: {
		"name": "BIOLOGY",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.ENGINEERING: {
		"name": "ENGINEERING",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.COMPUTER_SCIENCE: {
		"name": "COMPUTER SCIENCE",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.MATHEMATICS: {
		"name": "MATHEMATICS",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.PHYSICS: {
		"name": "PHYSICS",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.CHEMISTRY: {
		"name": "CHEMISTRY",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.MEDICINE: {
		"name": "MEDICINE",
		"icon": SVGS.TYPE.ENERGY,
	},	
	RESEARCHER.SPECIALIZATION.PHARMACOLOGY: {
		"name": "PHARMACOLOGY",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.NEUROSCIENCE: {
		"name": "NEUROSCIENCE",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.SOCIOLOGY: {
		"name": "SOCIOLOGY",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.ANTHROPOLOGY: {
		"name": "ANTHROPOLOGY",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.PHILOSOPHY: {
		"name": "PHILOSOPHY",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.ADMINISTRATION: {
		"name": "ADMINISTRATION",
		"icon": SVGS.TYPE.ENERGY,
	},	
	RESEARCHER.SPECIALIZATION.PARAZOOLOGIST: {
		"name": "PARAZOOLOGIST",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.THAUMATURGIC_ANALYST: {
		"name": "THAUMATURGIC ANALYST",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.XENOBIOLOGIST: {
		"name": "XENOBIOLOGIST",
		"icon": SVGS.TYPE.ENERGY,
	}
};



var trait_data: Dictionary = {
	# ---------------------------------
	RESEARCHER.TRAITS.HARD_WORKING: {
		"name": "HARD WORKING",
		"description": "Increases READINESS by 1.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data:Dictionary) -> Dictionary:
			return {
				"metrics": {
					RESOURCE.BASE_METRICS.READINESS: 1
				}
			},
	},
	RESEARCHER.TRAITS.MOTIVATED: {
		"name": "MOTIVATED",
		"description": "Increases MORALE by 1.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			return {
				"metrics": {
					RESOURCE.BASE_METRICS.MORALE: 1
				}
			},
	},
	RESEARCHER.TRAITS.DISCIPLINED: {
		"name": "DISCIPLINED",
		"description": "Increases SAFETY by 1.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			return {
				"metrics": {
					RESOURCE.BASE_METRICS.SAFETY: 1
				}
			},
	},
	# ---------------------------------
	RESEARCHER.TRAITS.IMPULSIVE: {
		"name": "IMPULSIVE",
		"description": "Reduces SAFETY by 1.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			return {
				"metrics": {
					RESOURCE.BASE_METRICS.SAFETY: -1
				}
			},
	},
	RESEARCHER.TRAITS.PESSIMISTIC: {
		"name": "PESSIMISTIC",
		"description": "Reduces MORALE by 1.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			return {
				"metrics": {
					RESOURCE.BASE_METRICS.MORALE: -1
				}
			},
	},
	RESEARCHER.TRAITS.STUBBORN: {
		"name": "STUBBORN",
		"description": "Reduces READINESS by 1.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			return {
				"metrics": {
					RESOURCE.BASE_METRICS.READINESS: -1
				}
			},
	},
	# ---------------------------------
	RESEARCHER.TRAITS.CLEVER: {
		"name": "CLEVER",
		"description": "Produces the same amount of SCIENCE as it does FUNDING.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			if config_data.room_data.is_empty():
				return {}
			
			var amount:int = 0
			var list:Array = ROOM_UTIL.return_operating_cost(config_data.room_data.details.ref)
			if !config_data.scp_data.is_empty():
				list += SCP_UTIL.return_ongoing_containment_rewards(config_data.scp_data.ref)
				
			for item in list:
				if item.resource.ref == RESOURCE.TYPE.MONEY and item.amount > 0:
					amount += item.amount
					
			return {
				"resource": {
					RESOURCE.TYPE.SCIENCE: amount
				}
			},
	},
	RESEARCHER.TRAITS.ADAPTABLE: {
		"name": "ADAPTABLE",
		"description": "Doubles the SCIENCE output of a facility.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			if config_data.room_data.is_empty():
				return {}
			
			var amount:int = 0
			var list:Array = ROOM_UTIL.return_operating_cost(config_data.room_data.details.ref)
			if !config_data.scp_data.is_empty():
				list += SCP_UTIL.return_ongoing_containment_rewards(config_data.scp_data.ref)
							
			for item in list:
				if item.resource.ref == RESOURCE.TYPE.SCIENCE:
					amount += item.amount
					
			return {
				"resource": {
					RESOURCE.TYPE.SCIENCE: amount
				}
			},
	},
	RESEARCHER.TRAITS.RESOURCEFUL: {
		"name": "RESOURCEFUL",
		"description": "Room always produces some SCIENCE and FUNDING.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {
				"resource": {
					RESOURCE.TYPE.MONEY: 5,
					RESOURCE.TYPE.SCIENCE: 5
				}
			},
	},	
	# ---------------------------------
	RESEARCHER.TRAITS.WASTEFUL: {
		"name": "WASTEFUL",
		"description": "Doubles the cost of a facility.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			if config_data.room_data.is_empty():
				return {}
			
			var amount:int = 0
			var list:Array = ROOM_UTIL.return_operating_cost(config_data.room_data.details.ref)
			if !config_data.scp_data.is_empty():
				list += SCP_UTIL.return_ongoing_containment_rewards(config_data.scp_data.ref)
							
			for item in list:
				if item.resource.ref == RESOURCE.TYPE.MONEY and item.amount < 0:
					amount += item.amount
					
			return {
				"resource": {
					RESOURCE.TYPE.MONEY: amount
				}
			},
	},
	RESEARCHER.TRAITS.SCIENTIFIC: {
		"name": "SCIENTIFIC",
		"description": "Converts FUNDING into SCIENCE.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			if config_data.room_data.is_empty():
				return {}
			
			var amount:int = 0
			var list:Array = ROOM_UTIL.return_operating_cost(config_data.room_data.details.ref)
			if !config_data.scp_data.is_empty():
				list += SCP_UTIL.return_ongoing_containment_rewards(config_data.scp_data.ref)
							
			for item in list:
				if item.resource.ref == RESOURCE.TYPE.MONEY and item.amount > 0:
					amount += item.amount
					
			return {
				"resource": {
					RESOURCE.TYPE.MONEY: -amount,
					RESOURCE.TYPE.SCIENCE: amount,
				}
			},
	},	
	RESEARCHER.TRAITS.FRUGAL: {
		"name": "FRUGAL",
		"description": "Converts facility SCIENCE into FUNDING.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			if config_data.room_data.is_empty():
				return {}
			
			var amount:int = 0
			var list:Array = ROOM_UTIL.return_operating_cost(config_data.room_data.details.ref)
			if !config_data.scp_data.is_empty():
				list += SCP_UTIL.return_ongoing_containment_rewards(config_data.scp_data.ref)
							
			for item in list:
				if item.resource.ref == RESOURCE.TYPE.SCIENCE and item.amount > 0:
					amount += item.amount
					
			return {
				"resource": {
					RESOURCE.TYPE.MONEY: amount,
					RESOURCE.TYPE.SCIENCE: -amount,
				}
			},
	},	
	# ---------------------------------
	RESEARCHER.TRAITS.EXCITABLE: {
		"name": "EXCITABLE",
		"description": "If facility produces at least 25 SCIENCE, MORALE is increased.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			if config_data.room_data.is_empty():
				return {}
			
			var amount:int = 0
			var list:Array = ROOM_UTIL.return_operating_cost(config_data.room_data.details.ref)
			if !config_data.scp_data.is_empty():
				list += SCP_UTIL.return_ongoing_containment_rewards(config_data.scp_data.ref)
							
			for item in list:
				if item.resource.ref == RESOURCE.TYPE.SCIENCE and item.amou:
					amount += item.amount
					
			return {
				"metrics": {
					RESOURCE.BASE_METRICS.MORALE: 1 if amount > 25 else 0
				},
			},
	},	
	RESEARCHER.TRAITS.METICULOUS: {
		"name": "METICULOUS",
		"description": "If facility produces at least 25 FUNDING, SAFETY is increased.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			if config_data.room_data.is_empty():
				return {}
			
			var amount:int = 0
			var list:Array = ROOM_UTIL.return_operating_cost(config_data.room_data.details.ref)
			if !config_data.scp_data.is_empty():
				list += SCP_UTIL.return_ongoing_containment_rewards(config_data.scp_data.ref)
							
			for item in list:
				if item.resource.ref == RESOURCE.TYPE.MONEY:
					amount += item.amount
					
			return {
				"metrics": {
					RESOURCE.BASE_METRICS.SAFETY: 1 if amount > 25 else 0
				},
			},
	},	
	RESEARCHER.TRAITS.INTROVERT: {
		"name": "INTROVERT",
		"description": "Produces SCIENCE and FUNDING if the researcher is alone.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			return {
				"resource": {
					RESOURCE.TYPE.MONEY: 10 if config_data.researchers.size() == 1 else 0,
					RESOURCE.TYPE.SCIENCE: 10 if config_data.researchers.size() == 1 else 0,
				}
			},
	},
	RESEARCHER.TRAITS.EXTROVERT: {
		"name": "EXTROVERT",
		"description": "Produces SCIENCE and FUNDING if the researcher is not alone.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			return {
				"resource": {
					RESOURCE.TYPE.MONEY: 10 if config_data.researchers.size() > 1 else 0,
					RESOURCE.TYPE.SCIENCE: 10 if config_data.researchers.size() > 1 else 0,
				}
			},
	},
	RESEARCHER.TRAITS.BRAVE: {
		"name": "BRAVE",
		"description": "If working with an SCP item, SCIENCE output is increased.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			if config_data.scp_data.is_empty():
				return {}
			
			var amount:int = 0
			var list:Array = ROOM_UTIL.return_operating_cost(config_data.room_data.details.ref)
			if !config_data.scp_data.is_empty():
				list += SCP_UTIL.return_ongoing_containment_rewards(config_data.scp_data.ref)
			
			for item in list:
				if item.resource.ref == RESOURCE.TYPE.SCIENCE:
					amount = item.amount 
			
			return {
				"resource": {
					RESOURCE.TYPE.SCIENCE: 0 if config_data.scp_data.is_empty() else amount
				},
			},
	},
	RESEARCHER.TRAITS.COWARD: {
		"name": "COWARD",
		"description": "If working with an SCP item, SCIENCE output is reduced.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(config_data: Dictionary) -> Dictionary:
			if config_data.scp_data.is_empty():
				return {}
	
			var amount:int = 0
			var list:Array = ROOM_UTIL.return_operating_cost(config_data.room_data.details.ref)
			if !config_data.scp_data.is_empty():
				list += SCP_UTIL.return_ongoing_containment_rewards(config_data.scp_data.ref)
				
			for item in list:
				if item.resource.ref == RESOURCE.TYPE.SCIENCE:
					amount = item.amount 				
			
			return {
				"resource": {
					RESOURCE.TYPE.SCIENCE: 0 if config_data.scp_data.is_empty() else -roundi(amount/2)
				},
			},
	},
}

var synergy_trait_data: Dictionary = {
	#RESEARCHER.SYNERGY_TRAITS.DREAM_TEAM: {
		#"name": "DREAM TEAM",
		#"description": "Combines cleverness and motivation to overcome challenges with creativity and determination.",
		#"icon": SVGS.TYPE.ENERGY,
		#"get_effect": func(details: Dictionary) -> Dictionary:
			#return {},
	#},
	#RESEARCHER.SYNERGY_TRAITS.ARCHITECTS_OF_SUCCESS: {
		#"name": "ARCHITECTS OF SUCCESS",
		#"description": "Resourcefulness and meticulous planning ensure every project is built to last.",
		#"icon": SVGS.TYPE.ENERGY,
		#"get_effect": func(details: Dictionary) -> Dictionary:
			#return {},
	#},
	#RESEARCHER.SYNERGY_TRAITS.BALANCING_ACT: {
		#"name": "BALANCING ACT",
		#"description": "A perfect harmony of pragmatic realism and boundless optimism, keeping projects grounded yet ambitious.",
		#"icon": SVGS.TYPE.ENERGY,
		#"get_effect": func(details: Dictionary) -> Dictionary:
			#return {},
	#},
	#RESEARCHER.SYNERGY_TRAITS.POWER_PAIR: {
		#"name": "POWER PAIR",
		#"description": "Charisma and strategy combine to lead teams with vision and precision.",
		#"icon": SVGS.TYPE.ENERGY,
		#"get_effect": func(details: Dictionary) -> Dictionary:
			#return {},
	#},
	#
	#
	#RESEARCHER.SYNERGY_TRAITS.TRAILBLAZER: {
		#"name": "TRAILBLAZER",
		#"description": "Combines innovation and courage to forge new paths and tackle the unknown head-on.",
		#"icon": SVGS.TYPE.ENERGY,
		#"get_effect": func(details: Dictionary) -> Dictionary:
			#return {},
	#},
#
	#RESEARCHER.SYNERGY_TRAITS.SPARK_AND_GRIND: {
		#"name": "SPARK AND GRIND",
		#"description": "Merges cleverness and hard work to achieve breakthroughs through insight and relentless effort.",
		#"icon": SVGS.TYPE.ENERGY,
		#"get_effect": func(details: Dictionary) -> Dictionary:
			#return {},
	#},
#
	#RESEARCHER.SYNERGY_TRAITS.ADAPTIVE_THINKER: {
		#"name": "ADAPTIVE THINKER",
		#"description": "Combines adaptability and strategy to navigate challenges with flexible, well-planned approaches.",
		#"icon": SVGS.TYPE.ENERGY,
		#"get_effect": func(details: Dictionary) -> Dictionary:
			#return {},
	#},
#
	#RESEARCHER.SYNERGY_TRAITS.VISIONARY: {
		#"name": "VISIONARY",
		#"description": "Blends optimism and curiosity to see possibilities where others see obstacles.",
		#"icon": SVGS.TYPE.ENERGY,
		#"get_effect": func(details: Dictionary) -> Dictionary:
			#return {},
	#},
#
	#RESEARCHER.SYNERGY_TRAITS.MAD_GENIUS: {
		#"name": "MAD GENIUS",
		#"description": "Combines wild innovation with impulsive action, leading to groundbreaking discoveries—or spectacular failures.",
		#"icon": SVGS.TYPE.ENERGY,
		#"get_effect": func(details: Dictionary) -> Dictionary:
			#return {},
	#},	
	#
}

# ------------------------------------------------------------------------------
func generate_new_researcher_hires(number:int) -> Array:
	var researchers:Array = []
	for n in range(0, number):
		researchers.push_back(generate_researcher())
	return researchers
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_data_with_uid(uid:String) -> Dictionary:
	for index in hired_lead_researchers_arr.size():
		var item:Array = hired_lead_researchers_arr[index]
		if uid == item[0]:
			return get_user_object(item)
			break
	
	return {}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var count:int = 0
func generate_researcher() -> Array:
	var uid:String = U.generate_uid()
	var lname:int =  U.generate_rand(0, 5)
	
	var specialization:Array = []
	for i in [100, 10, 5]:
		var rand:int = U.generate_rand(0, 100)
		if i < rand:
			break
		var val:int = U.generate_rand(0, RESEARCHER.SPECIALIZATION.size() - 1)
		if val not in specialization:
			specialization.push_back( val )
		
	
	var traits:Array = []
	for i in [100, 25, 5]:
		var rand:int = U.generate_rand(0, 100)
		if i < rand:
			break
		var val:int = U.generate_rand(0, RESEARCHER.TRAITS.size() - 1)
		if val not in traits:
			traits.push_back( val )
	

	var rval:int = U.generate_rand(0, 9)
	var lval:int = U.generate_rand(0, 9)
	
	# TODO: add this in later
	# var img_src:String = "res://Media/images/example_doctor.jpg"		
		
	return [ 
		uid, 		 	# 0 UID
		lname, 			# 1 LASTNAME
		traits, 		# 2 TRAITS
		specialization, # 3 SPECS
		rval, 			# 4 RANDOM VALUE?
		lval, 			# 5 RANDOM VALUE?
		0, 				# 6	STRESS
		0, 				# 7 EXP
		1, 				# 8 LVL
		{"assigned_to_room": {}, "can_promote": false}	# 9
	]
# ------------------------------------------------------------------------------
	
# ------------------------------------------------------------------------------

func get_user_object(val:Array) -> Dictionary:
	var uid_val:String = val[0]
	var name_val:int = val[1]
	var traits_list:Array = val[2]
	var specializations_list:Array = val[3]
	var r_val:int = val[4]
	var l_val:int = val[5]
	var stress:int = val[6]
	var experience:int = val[7] 
	var level:int = val[8]
	var props:Dictionary = val[9]
	
	var img_src:String = "res://Media/images/researcher_female_02.jpg"
	
	var lname:String = get_lname(name_val)
	
	var traits:Array = []
	for i in traits_list:
		traits.push_back(i)
		
	var specializations:Array = []
	for t in specializations_list:
		specializations.push_back(t)

	return {
		"uid": uid_val,
		"name": "%s" % [lname],
		"img_src": img_src,
		"traits": traits,
		"specializations": specializations,
		"r_val": r_val,
		"l_val": l_val,
		"stress": stress,
		"experience": experience,
		"level": level,
		"props": props
	}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_lname(i:int) -> String:
	match i:
		0: return 'RYAN'
		1: return 'MARTIN'
		2: return 'OYAS'
		3: return 'SINCLAIRE'
		4: return 'WOODS'
		5: return 'VIAJAR'
	return 'SMITH'
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_trait_details(ref:int, use_location:Dictionary, use_config:Dictionary = room_config) -> Dictionary:
	var floor:int = use_location.floor
	var ring:int = use_location.ring
	var room:int = use_location.room	
	var designation:String = str(floor, room, room)
	var config_data:Dictionary = use_config.floor[floor].ring[ring].room[room]

	var researchers:Array = hired_lead_researchers_arr.filter(func(x):
		var details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(x[0])
		if (!details.props.assigned_to_room.is_empty() and U.location_to_designation(details.props.assigned_to_room) == designation):
			return true
		return false	
	).map(func(x):return RESEARCHER_UTIL.return_data_with_uid(x[0]))
	config_data.researchers = researchers
				
	var traits_detail:Dictionary = RESEARCHER_UTIL.return_trait_data(ref)
	var effect:Dictionary = traits_detail.get_effect.call(config_data)
	var resource_list:Array = []
	var metric_list:Array = []

	# -------------------
	if "metrics" in effect:
		for key in effect.metrics:
			var amount:int = effect.metrics[key]
			metric_list.push_back({"resource": RESOURCE_UTIL.return_metric_data(key), "amount": amount})

	## -------------------
	if "resource" in effect:
		for key in effect.resource:
			var amount:int = effect.resource[key]
			resource_list.push_back({"resource": RESOURCE_UTIL.return_data(key), "amount": amount})

	return {"details": traits_detail, "effect": {"metric_list": metric_list, "resource_list": resource_list}}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_trait_data(key:RESEARCHER.TRAITS) -> Dictionary:
	trait_data[key].ref = key
	return trait_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_synergy_trait_data(key:RESEARCHER.SYNERGY_TRAITS) -> Dictionary:
	synergy_trait_data[key].ref = key
	return synergy_trait_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_specialization_data(key:RESEARCHER.SPECIALIZATION) -> Dictionary:
	specialization_data[key].ref = key
	return specialization_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------		
func return_wing_effect(researcher_data:Dictionary) -> Dictionary:
	#for trait_key in researcher_data.traits:
		#var trait_data:Dictionary = return_trait_data(trait_key)
		#return trait_data.wing_effect.call(researcher_data)
	return {}
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
func return_trait_synergy(t1:Array, t2:Array) -> Array:
	var synergy_traits:Array = []
	for t1key in t1:
		for t2key in t2:
			var match_val:int = t1key + t2key
			for key in RESEARCHER.SYNERGY_TRAITS:
				var syn_val:int = RESEARCHER.SYNERGY_TRAITS[key]
				if syn_val == match_val:					
					synergy_traits.push_back(return_synergy_trait_data(syn_val))

	return synergy_traits
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------
func return_wing_effects_list(researcher_data:Dictionary) -> Array:
	var list:Array = []
	for trait_key in researcher_data.traits:
		var trait_data:Dictionary = return_trait_data(trait_key)
		var effects_dict:Dictionary = trait_data.wing_effect.call(researcher_data)
		for key in effects_dict:
			var amount:int = effects_dict[key]
			var resource_data:Dictionary = RESOURCE_UTIL.return_metric_data(key)
			if amount > 0:
				list.push_back({"resource_data": resource_data, "property": "metrics", "amount": amount})

	return list
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func get_details_from_extract(location:Dictionary) -> Dictionary:
	if !location.is_empty():
		var room_extract:Dictionary = GAME_UTIL.extract_room_details(location)			
		
		return {
			"researchers": room_extract.researchers,			
			"room": {
				"is_empty": room_extract.room.is_empty(),
				"ref": -1 if room_extract.room.is_empty() else room_extract.room.details.ref,	
				"is_activated": false if room_extract.room.is_empty() else room_extract.is_activated, 
			},
			"scp": {
				"is_empty": room_extract.scp.is_empty(),
				"ref": -1 if room_extract.scp.is_empty() else room_extract.scp.details.ref,
				"is_contained": false if room_extract.scp.is_empty() else room_extract.scp.is_contained,
			}			
		}
		
	return {
		"researchers": [],
		"room_ref": -1,
		"scp_ref": -1
	}		
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func get_randomized_traits(amount:int, exclude:Array) -> Array:
	var traits:Array = []
	while traits.size() < amount:
		var val:int = U.generate_rand(0, RESEARCHER.TRAITS.size() - 1)
		if val not in traits and val not in exclude:
			traits.push_back( val )	
	
	return traits
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	
func promote_researcher(researcher_details:Dictionary, new_trait:int) -> void:
	var new_trait_list:Array = researcher_details.traits + [new_trait]
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
		if i[0] == researcher_details.uid:
			# i[7] is xp
			i[7] -= 10
			i[2] = new_trait_list
			i[8] += 1
			i[9].can_promote = i[7] > 10
		return i
	) 		
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------
func add_experience(uid:String, amount:int) -> bool:
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
		if i[0] == uid:
			# i[7] is xp
			i[7] += amount
			i[9].can_promote = i[7] > 10
		return i
	) 	
	
	var researcher:Array = hired_lead_researchers_arr.filter(func(i): return i[0] == uid)[0]
	# returns if reasearcher leveled up
	return researcher[9].can_promote
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func check_for_promotions() -> Array:	
	return hired_lead_researchers_arr.filter(func(i): return i[9].can_promote).map(func(i): return {"uid": i[0]})
# ------------------------------------------------------------------------------		
