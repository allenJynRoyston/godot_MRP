extends SubscribeWrapper

var specialization_data:Dictionary = { 
	RESEARCHER.SPECIALIZATION.ADMINISTRATION: {
		"shortname": "ADMIN",
		"name": "ADMINISTRATION",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.BIOLOGIST: {
		"shortname": "BIO",
		"name": "BIOLOGY",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.ENGINEERING: {
		"shortname": "ENG",
		"name": "ENGINEERING",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.COMPUTER_SCIENCE: {
		"shortname": "CS",
		"name": "COMPUTER SCIENCE",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.MATHEMATICS: {
		"shortname": "MATHS",
		"name": "MATHEMATICS",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.PHYSICS: {
		"shortname": "PHY",
		"name": "PHYSICS",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECIALIZATION.CHEMISTRY: {
		"shortname": "CHEM",
		"name": "CHEMISTRY",
		"icon": SVGS.TYPE.ENERGY,
	},
};

var trait_data: Dictionary = {
	RESEARCHER.TRAITS.HARD_WORKING: {
		"name": "HARD WORKING",
		"type": RESEARCHER.TRAIT_TYPE.POSITIVE,
		"on_promotion": {
			"description": "Colleagues nod approvingly — 'They earned it. They'll probably pick up the slack too.'",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.MOTIVATED: {
		"name": "MOTIVATED",
		"type": RESEARCHER.TRAIT_TYPE.POSITIVE,
		"on_promotion": {
			"description": "'That one’s always pushing for results,' others say. Expectations are high — maybe too high.",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.DISCIPLINED: {
		"name": "DISCIPLINED",
		"type": RESEARCHER.TRAIT_TYPE.POSITIVE,
		"on_promotion": {
			"description": "'Good. They'll keep the team in line,' someone remarks. Most expect a structured, by-the-book leader.",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.CLEVER: {
		"name": "CLEVER",
		"type": RESEARCHER.TRAIT_TYPE.POSITIVE,
		"on_promotion": {
			"description": "'Smart move,' someone says. 'Just keep an eye on them — brilliance can be... unpredictable.'",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.ADAPTABLE: {
		"name": "ADAPTABLE",
		"type": RESEARCHER.TRAIT_TYPE.POSITIVE,
		"on_promotion": {
			"description": "Generally met with approval — 'They can handle whatever the Foundation throws at them.'",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.RESOURCEFUL: {
		"name": "RESOURCEFUL",
		"type": RESEARCHER.TRAIT_TYPE.POSITIVE,
		"on_promotion": {
			"description": "'They'll find a way out of any mess,' says a team lead. Some feel safer already.",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.FRUGAL: {
		"name": "FRUGAL",
		"type": RESEARCHER.TRAIT_TYPE.POSITIVE,
		"on_promotion": {
			"description": "'Good — finally someone who won’t waste grant funds,' say the accountants. Others fear corner-cutting.",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.METICULOUS: {
		"name": "METICULOUS",
		"type": RESEARCHER.TRAIT_TYPE.POSITIVE,
		"on_promotion": {
			"description": "'That lab's about to run like clockwork,' someone says. Others brace for micromanagement.",
			"effect": func(): pass
		}
	},
	# -----------------------------------
	RESEARCHER.TRAITS.BRAVE: {
		"name": "BRAVE",
		"type": RESEARCHER.TRAIT_TYPE.POSITIVE,
		"on_promotion": {
			"description": "'They won't flinch when it matters,' others agree. Trusted in the field, but caution is advised.",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.IMPULSIVE: {
		"name": "IMPULSIVE",
		"type": RESEARCHER.TRAIT_TYPE.NEGATIVE,
		"on_promotion": {
			"description": "Raised eyebrows and a few muttered concerns — 'Let’s just hope they don’t do anything rash.'",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.PESSIMISTIC: {
		"name": "PESSIMISTIC",
		"type": RESEARCHER.TRAIT_TYPE.NEGATIVE,
		"on_promotion": {
			"description": "'That’s... surprising,' one researcher says. Morale dips slightly — no one expects optimism from them.",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.STUBBORN: {
		"name": "STUBBORN",
		"type": RESEARCHER.TRAIT_TYPE.NEGATIVE,
		"on_promotion": {
			"description": "'Well, at least they'll never back down,' says one. Others worry about inflexibility during crises.",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.WASTEFUL: {
		"name": "WASTEFUL",
		"type": RESEARCHER.TRAIT_TYPE.NEGATIVE,
		"on_promotion": {
			"description": "Audible groans — 'There goes the equipment budget.' Fiscal officers aren't pleased.",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.EXCITABLE: {
		"name": "EXCITABLE",
		"type": RESEARCHER.TRAIT_TYPE.NEGATIVE,
		"on_promotion": {
			"description": "Some smirk. Others sigh. 'Let’s hope they don’t panic the next time something breaches containment.'",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.COWARD: {
		"name": "COWARD",
		"type": RESEARCHER.TRAIT_TYPE.NEGATIVE,
		"on_promotion": {
			"description": "Confusion and concern spread — 'Them? Really? Hope they don’t bolt when shit hits the fan.'",
			"effect": func(): pass
		}
	},
	# -----------------------------------
	RESEARCHER.TRAITS.SCIENTIFIC: {
		"name": "SCIENTIFIC",
		"type": RESEARCHER.TRAIT_TYPE.NEUTRAL,
		"on_promotion": {
			"description": "‘Makes sense,’ others nod. Cold logic is appreciated, though some worry about empathy gaps.",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.INTROVERT: {
		"name": "INTROVERT",
		"type": RESEARCHER.TRAIT_TYPE.NEUTRAL,
		"on_promotion": {
			"description": "'Quiet choice,' one remarks. Some worry about communication, others trust their focus.",
			"effect": func(): pass
		}
	},
	RESEARCHER.TRAITS.EXTROVERT: {
		"name": "EXTROVERT",
		"type": RESEARCHER.TRAIT_TYPE.NEUTRAL,
		"on_promotion": {
			"description": "Mixed reactions — 'They’ll boost morale,' says one, while another mutters, 'Too loud for the lab.'",
			"effect": func(): pass
		}
	}
};

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
		{"clone_iteration": 0, "original_uid": null}, # 9 CLONE TRACKER
		{"assigned_to_room": {}}	# 10
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
	var clone_props:Dictionary = val[9]
	var props:Dictionary = val[10]
	
	var img_src:String = "res://Media/images/researcher_female_02.jpg"
	
	var lname:String = get_lname(name_val)
	
	var traits:Array = []
	for i in traits_list:
		traits.push_back(i)
		
	var specializations:Array = []
	for t in specializations_list:
		specializations.push_back(t)
	
	# if original, this is the number of clones "you" have
	var number_of_clones:int = hired_lead_researchers_arr.filter(func(x): return x[9].original_uid == uid_val).size()
	
	# if you're a clone, this is how many "copies" of you exists
	var clone_copies:int = 0 if clone_props.clone_iteration == 0 else hired_lead_researchers_arr.filter(func(x): return x[9].original_uid == clone_props.original_uid).size()
	
	# if you're a clone, this is what iteration you are 
	var clone_iteration:int = clone_props.clone_iteration
	
	var clone_str:String = ""
	if clone_iteration > 0:
		clone_str = " (CLONE)"
	if number_of_clones > 2 or clone_copies > 2:
		clone_str = " (CLONE?)"
	
	return {
		"uid": uid_val,
		"name": "%s%s" % [lname, clone_str],
		"img_src": img_src,
		"traits": traits,
		"specializations": specializations,
		"r_val": r_val,
		"l_val": l_val,
		"stress": stress,
		"experience": experience,
		"level": level,
		"clone": {
			"number_of_clones": number_of_clones,
			"clone_copies": clone_copies,
			"clone_iteration": clone_props.clone_iteration,
			"original_uid": clone_props.original_uid
		},
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
	#var effect:Dictionary = traits_detail.get_effect.call(config_data)
	#var resource_list:Array = []
	#var metric_list:Array = []
#
	## -------------------
	#if "metrics" in effect:
		#for key in effect.metrics:
			#var amount:int = effect.metrics[key]
			#metric_list.push_back({"resource": RESOURCE_UTIL.return_metric(key), "amount": amount})
#
	### -------------------
	#if "resource" in effect:
		#for key in effect.resource:
			#var amount:int = effect.resource[key]
			#resource_list.push_back({"resource": RESOURCE_UTIL.return_currency(key), "amount": amount})

	return {"details": traits_detail, "effect": {"vibes": [], "resources": []}}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_trait_data(key:RESEARCHER.TRAITS) -> Dictionary:
	trait_data[key].ref = key
	return trait_data[key]
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
func return_wing_effects_list(researcher_data:Dictionary) -> Array:
	var list:Array = []
	for trait_key in researcher_data.traits:
		var trait_data:Dictionary = return_trait_data(trait_key)
		var effects_dict:Dictionary = trait_data.wing_effect.call(researcher_data)
		for key in effects_dict:
			var amount:int = effects_dict[key]
			var resource_data:Dictionary = RESOURCE_UTIL.return_metric(key)
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
func sort_ascending(a:Dictionary, b:Dictionary) -> bool:
	return a.level > b.level
	
func sort_descending(a:Dictionary, b:Dictionary) -> bool:
	return a.level < b.level
	
func get_paginated_list(spec:int, start_at:int, limit:int, sort_asc:bool = true) -> Dictionary:
	var list:Array = hired_lead_researchers_arr.map(func(x): return return_data_with_uid(x[0]))

	# Sort list
	list.sort_custom(sort_ascending if sort_asc else sort_descending)

	# Filter by specialization
	var filtered_list: Array = []
	for item in list:
		if spec == -1 or spec in item.specializations:
			filtered_list.append(item)

	# Slice the list based on start_at and limit
	var sliced_list: Array = filtered_list.slice(start_at, start_at + limit)

	return {
		"list": sliced_list,
		"size": list.size(),
		"has_more": limit < filtered_list.size()
	}
# ------------------------------------------------------------------------------		


# ------------------------------------------------------------------------------	
func promote_researcher(uid:String) -> void:	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
		if i[0] == uid:
			# i[8] is level
			i[8] += 1
		return i
	) 		
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func clone_researcher(uid:String) -> void:
	var cloned_researcher = hired_lead_researchers_arr.filter(func(i):
		if i[0] == uid:
			return i
		)[0].duplicate(true)
	
	var is_original:bool = cloned_researcher[9].original_uid == null
	
	cloned_researcher[0] = U.generate_uid()
	cloned_researcher[9].clone_iteration += 1
	cloned_researcher[9].original_uid = uid if is_original else cloned_researcher[9].original_uid
	cloned_researcher[10].assigned_to_room = {}
	
	hired_lead_researchers_arr.push_back(cloned_researcher)
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func add_experience(uid:String, amount:int) -> bool:
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
		if i[0] == uid:
			# i[7] is xp
			i[7] += amount
		return i
	) 	
	
	var researcher:Array = hired_lead_researchers_arr.filter(func(i): return i[0] == uid)[0]
	# returns if reasearcher leveled up
	return researcher[9].can_promote
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func can_be_promoted(uid:String) -> bool:	
	var xp_required_for_promotion:int = DEBUG.get_val(DEBUG.RESEARCHER_XP_REQUIRED_FOR_PROMOTION)
	return hired_lead_researchers_arr.filter(func(i): return i[7] >= xp_required_for_promotion and i[0] == uid).size() > 0
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
func get_list_of_specilizations() -> Array:
	var list:Array = []
	for ref in specialization_data:
		var spec:Dictionary = specialization_data[ref]
		spec.ref = ref
		list.push_back(spec)
	return list
# ------------------------------------------------------------------------------		
	
