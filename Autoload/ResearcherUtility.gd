extends UtilityWrapper

	#HARD_WORKING,
	#MOTIVATED, 
	#CLEVER,
	#STUBBORN

var specialization_data:Dictionary = { 
	RESEARCHER.SPECALIZATION.PSYCHOLOGY: {
		"name": "PSYCHOLOGY",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECALIZATION.BIOLOGY: {
		"name": "BIOLOGY",
		"icon": SVGS.TYPE.ENERGY,
	},
	RESEARCHER.SPECALIZATION.ENGINEERING: {
		"name": "ENGINEERING",
		"icon": SVGS.TYPE.ENERGY,
	}
}

var trait_data:Dictionary = {
	RESEARCHER.TRAITS.HARD_WORKING: {
		"name": "HARD_WORKING",
		"description": "HARD_WORKING description goes here.",
		"icon": SVGS.TYPE.ENERGY,
		"synergy_check": func(partner_traits:Array) -> Dictionary:
			return {
				RESEARCHER.SYNERGY_TRAITS.DREAM_TEAM: RESEARCHER.TRAITS.MOTIVATED in partner_traits
			},
		"wing_effect": func(self_data:Dictionary) -> Dictionary:		
			var extract_details:Dictionary = get_details_from_extract(self_data.props.assigned_to_room)
			var researchers:Array = extract_details.researchers.filter(func(i): return i.uid != self_data.uid)			
			var metrics:Dictionary = return_wing_effect(researchers[0]) if researchers.size() > 0 else {}			
			return metrics,
	},
	RESEARCHER.TRAITS.MOTIVATED: {
		"name": "MOTIVATED",
		"description": "MOTIVATED description goes here.",
		"icon": SVGS.TYPE.ENERGY,
		"synergy_check": func(partner_traits:Array) -> Dictionary:
			return {
				RESEARCHER.SYNERGY_TRAITS.DREAM_TEAM: RESEARCHER.TRAITS.HARD_WORKING in partner_traits
			},
		"wing_effect": func(self_data:Dictionary) -> Dictionary:		
			var extract_details:Dictionary = get_details_from_extract(self_data.props.assigned_to_room)
			return {
				RESOURCE.BASE_METRICS.MORALE: 1 if (!extract_details.room.is_empty and extract_details.room.is_activated) else 0
			},
	},
	RESEARCHER.TRAITS.CLEVER: {
		"name": "CLEVER",
		"description": "CLEVER description goes here.",
		"icon": SVGS.TYPE.ENERGY,
		"synergy_check": func(partner_traits:Array) -> Dictionary:
			return {
				
			},
		"wing_effect": func(self_data:Dictionary) -> Dictionary:		
			var extract_details:Dictionary = get_details_from_extract(self_data.props.assigned_to_room)
			return {
				RESOURCE.BASE_METRICS.MORALE: 1 if (!extract_details.room.is_empty and extract_details.room.is_activated) else 0
			},
	},	
	RESEARCHER.TRAITS.STUBBORN: {
		"name": "STUBBORN",
		"description": "STUBBORN description goes here.",
		"icon": SVGS.TYPE.ENERGY,
		"synergy_check": func(partner_traits:Array) -> Dictionary:
			return {
				
			},
		"wing_effect": func(self_data:Dictionary) -> Dictionary:		
			var extract_details:Dictionary = get_details_from_extract(self_data.props.assigned_to_room)
			return {
				RESOURCE.BASE_METRICS.MORALE: 1 if (!extract_details.room.is_empty and extract_details.room.is_activated) else 0
			},
	},
}

var synergy_trait_data:Dictionary = {
	RESEARCHER.SYNERGY_TRAITS.DREAM_TEAM: {
		"name": "DREAM_TEAM",
		"description": "DREAM_TEAM description goes here.",
		"icon": SVGS.TYPE.ENERGY,
		"wing_effect": func(self_data:Dictionary) -> Dictionary:		
			var extract_details:Dictionary = get_details_from_extract(self_data.props.assigned_to_room)
			return {
				RESOURCE.BASE_METRICS.MORALE: 1 if (!extract_details.room.is_empty and extract_details.room.is_activated) else 0
			},
	}
}

# ------------------------------------------------------------------------------
func generate_new_researcher_hires() -> Array:
	return [
		generate_researcher(),
		generate_researcher(),
		generate_researcher(),	
	]
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
		var val:int = U.generate_rand(0, RESEARCHER.SPECALIZATION.size() - 1)
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
	
	var img_src:String = "res://Media/images/example_doctor.jpg"
	
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
func return_specialization_data(key:RESEARCHER.SPECALIZATION) -> Dictionary:
	specialization_data[key].ref = key
	return specialization_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------		
func return_wing_effect(researcher_data:Dictionary) -> Dictionary:
	for trait_key in researcher_data.traits:
		var trait_data:Dictionary = return_trait_data(trait_key)
		return trait_data.wing_effect.call(researcher_data)
	return {}
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
func return_trait_synergy(t1:Array, t2:Array) -> Array:
	var synergy_traits:Array = []
	for trait_key in t1:
		var trait_data:Dictionary = return_trait_data(trait_key)
		var res:Dictionary = trait_data.synergy_check.call(t2)
		for key in res:
			if res[key]:
				synergy_traits.push_back(return_synergy_trait_data(key))
				
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
		var room_extract:Dictionary = ROOM_UTIL.extract_room_details(location)			
		
		return {
			"researchers": room_extract.researchers,			
			"room": {
				"is_empty": room_extract.room.is_empty(),
				"ref": -1 if room_extract.room.is_empty() else room_extract.room.details.ref,	
				"is_activated": false if room_extract.room.is_empty() else room_extract.room.is_activated, 
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
func add_experience(uid:String, amount:int) -> bool:
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
		if i[0] == uid:
			# i[7] is xp
			i[7] += amount
			if i[7] >= 10:
				i[7] = i[7] - 10
				# i[8] is level
				if i[8] <= 3:
					i[8] += 1
					i[9].can_promote = true
			else:
				i[9].can_promote = false
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
