extends SubscribeWrapper

var specialization_data:Dictionary = { 
	#RESEARCHER.SPECIALIZATION.ANY: {
		#"shortname": "ANY",
		#"name": "ANY",
	#},	
	RESEARCHER.SPECIALIZATION.RESEARCHER: {
		"shortname": "RS",
		"name": "RESEARCHER"
	},
	RESEARCHER.SPECIALIZATION.ADMIN: {
		"shortname": "ADM",
		"name": "ADMIN"
	},	
	RESEARCHER.SPECIALIZATION.SECURITY: {
		"shortname": "SEC",
		"name": "SECURITY OFFICER"
	},
	RESEARCHER.SPECIALIZATION.DCLASS: {
		"shortname": "DC",
		"name": "D-CLASS"
	},
};

var trait_data: Dictionary = {
	# ---------------------------
	RESEARCHER.TRAITS.AVERAGE: {
		"name": "AVERAGE",
		"description": "Subject displays baseline psychological and behavioral responses. No anomalous tendencies or notable cognitive irregularities observed."
	},
	
	
	# ---------------------------
	RESEARCHER.TRAITS.RESOURCEFUL: {
		"name": "RESOURCEFUL",
		"description": "Adapts quickly.  Ocassionally reveals an additional option during EVENTS."
	},
	RESEARCHER.TRAITS.OPTIMIST: {
		"name": "OPTIMIST",
		"description": "Generally negative attitude.  Reveals positive CONSEQUENCES during events."
	},
	RESEARCHER.TRAITS.PESSIMIST: {
		"name": "PESSIMIST",
		"description": "Generally negative attitude.  Reveals negative CONSEQUENCES during events."
	},	
	
	
	# ---------------------------
	RESEARCHER.TRAITS.ANALYTICAL: {
		"name": "ANALYTICAL",
		"description": "Great at spotting patterns.  Reveals the likely odds of success when making CHOICES."
	},
	RESEARCHER.TRAITS.PARANOID: {
		"name": "PARANOID",
		"description": "Subject displays heightened vigilance, suspicion of external intent, and a tendency to infer hostile motives. Exhibits resistance to surveillance procedures."
	},
	
	RESEARCHER.TRAITS.DYSLEXIC: {
		"name": "DYSLEXIC",
		"description": "Processess written languages differently.  Makes CHOICES harder to read."
	},	

};


var mood_data:Dictionary = {	
	RESEARCHER.MOODS.STABLE: {
		"name": "STABLE",
		"description": "Focused and mentally balanced. Can make all choices without restriction."
	},
	RESEARCHER.MOODS.FRIGHTENED: {
		"name": "FRIGHTENED",
		"description": "Gripped by fear. Unable to choose actions related to SAFETY."
	},
	RESEARCHER.MOODS.DEPRESSED: {
		"name": "DEPRESSED",
		"description": "Overwhelmed by hopelessness. Unable to choose actions related to MORALE."
	},
	RESEARCHER.MOODS.RELUCTANT: {
		"name": "RELUCTANT",
		"description": "Hesitant and disengaged. Unable to choose actions related to READINESS."
	},
}


# ------------------------------------------------------------------------------
func generate_new_researcher_hires(amount:int, specializations:RESEARCHER.SPECIALIZATION) -> Array:
	var researchers:Array = []
	for n in range(0, amount):
		researchers.push_back(generate_researcher(specializations))
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
func generate_researcher(specialization:RESEARCHER.SPECIALIZATION) -> Array:
	var uid:String = U.generate_uid()
	var lname:int =  U.generate_rand(0, 100)
	
	# TODO: add this in later
	# var img_src:String = "res://Media/images/example_doctor.jpg"		
	var max_health:int = 3 if specialization == RESEARCHER.SPECIALIZATION.SECURITY else 2
	var max_sanity:int = 3 if specialization == RESEARCHER.SPECIALIZATION.RESEARCHER else 2
	
	var traits:int = U.generate_rand(0, RESEARCHER.TRAITS.size() - 1)
	var mood:int = RESEARCHER.MOODS.STABLE
	var status:int = RESEARCHER.STATUS.ALIVE
	
	return [ 
		uid, 																	 	# 0 UID
		lname, 																		# 1 LASTNAME
		traits, 																	# 2 TRAITS
		specialization, 															# 3 SPECS
		mood, 																		# 4 MOOD
		status,																		# 5 STATUS
		{'current': max_health, "max": max_health}, 								# 6 HEALTH
		{'current': max_sanity, 'max': max_sanity}, 								# 7	SANITY
		0, 																			# 8 EXP
		1, 																			# 9 LVL
		{"clone_iteration": 0, "original_uid": null}, 								# 10 CLONE TRACKER
		{"assigned_to_room": {}, "slot": 0},										# 11 ASSIGNED TO ROOM
		
	]
# ------------------------------------------------------------------------------
	
# ------------------------------------------------------------------------------
func get_user_object(val:Array) -> Dictionary:
	var uid_val:String = val[0]
	var name_val:int = val[1]
	var trait_val:int = val[2]
	var spec_val:int = val[3]
	var mood_val:int = val[4]
	var status:int = val[5]
	var health:Dictionary = val[6]
	var sanity:Dictionary = val[7]
	var experience:int = val[8] 
	var level:int = val[9]
	var clone_props:Dictionary = val[10]
	var props:Dictionary = val[11]
	var gender_val:int = int(uid_val.right(2))

	# images
	var img_src:String = ""
	match spec_val: 
		RESEARCHER.SPECIALIZATION.ADMIN:
			img_src = "res://Media/images/ProfilePics/admin_male_01.png"
		RESEARCHER.SPECIALIZATION.SECURITY:
			img_src = "res://Media/images/ProfilePics/security_male_01.png" if gender_val % 2 == 0 else "res://Media/images/ProfilePics/security_female_01.png"
		_: 
			img_src = "res://Media/images/ProfilePics/researcher_male_01.png" #if gender_val % 2 == 0 else "res://Media/images/ProfilePics/researcher_female_01.jpg"	
			
	# get name
	var lname:String = get_lname(name_val)
	
	# if original, this is the number of clones "you" have
	var number_of_clones:int = hired_lead_researchers_arr.filter(func(x): return x[10].original_uid == uid_val).size()
	
	# if you're a clone, this is how many "copies" of you exists
	var clone_copies:int = 0 if clone_props.clone_iteration == 0 else hired_lead_researchers_arr.filter(func(x): return x[10].original_uid == clone_props.original_uid).size()
	
	# if you're a clone, this is what iteration you are 
	var clone_iteration:int = clone_props.clone_iteration
	var clone_str:String = ""
	if clone_iteration > 0:
		clone_str = "(CLONE)"
	if number_of_clones > 2 or clone_copies > 2:
		clone_str = "(CLONE?)"
	var spec_data:Dictionary = return_specialization_data(spec_val)
	
	# name string
	var name_str:String = "%s %s %s" % [spec_data.name, lname, clone_str] 
	if spec_val == RESEARCHER.SPECIALIZATION.DCLASS:
		name_str = "%s %s %s" % [spec_data.name, uid_val.substr(uid_val.length() - 5, 5), clone_str] 
	
	return {
		"uid": uid_val,
		"name": name_str,
		"img_src": img_src,
		"trait": {"ref": trait_val, "details": return_trait_data(trait_val)},
		"specialization": {"ref": spec_val, "details": spec_data},
		"mood": {"ref": mood_val, "details": return_mood_data(mood_val)},
		"status": status,
		"health": health,
		"sanity": sanity,
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
func get_lname(i: int) -> String:
	match i:
		0: return 'ADAMS'
		1: return 'ALEXANDER'
		2: return 'ARNOLD'
		3: return 'BAILEY'
		4: return 'BARNES'
		5: return 'BELL'
		6: return 'BENNETT'
		7: return 'BOONE'
		8: return 'BOWMAN'
		9: return 'BRYANT'
		10: return 'BROOKS'
		11: return 'BURNS'
		12: return 'BUTLER'
		13: return 'CARTER'
		14: return 'CASEY'
		15: return 'COLE'
		16: return 'COLEMAN'
		17: return 'COX'
		18: return 'DAVIS'
		19: return 'DIAZ'
		20: return 'DOUGLAS'
		21: return 'FLEMING'
		22: return 'FORD'
		23: return 'FOSTER'
		24: return 'GARCIA'
		25: return 'GIBBS'
		26: return 'GONZALEZ'
		27: return 'GRAHAM'
		28: return 'GRIFFIN'
		29: return 'HAMILTON'
		30: return 'HAYES'
		31: return 'HENDERSON'
		32: return 'HERNANDEZ'
		33: return 'HOLLAND'
		34: return 'HOUSTON'
		35: return 'HOWARD'
		36: return 'JENKINS'
		37: return 'JOHNSON'
		38: return 'KIM'
		39: return 'KNIGHT'
		40: return 'LEE'
		41: return 'MARTIN'
		42: return 'MCCOY'
		43: return 'MORALES'
		44: return 'MYERS'
		45: return 'NELSON'
		46: return 'OYAS'
		47: return 'PARKER'
		48: return 'PAUL'
		49: return 'PEARSON'
		50: return 'PERRY'
		51: return 'PRICE'
		52: return 'RAMOS'
		53: return 'REED'
		54: return 'RIVERA'
		55: return 'ROSS'
		56: return 'RUSSELL'
		57: return 'RYAN'
		58: return 'SANDERS'
		59: return 'SINCLAIRE'
		60: return 'SPENCER'
		61: return 'STEPHENS'
		62: return 'SULLIVAN'
		63: return 'VIAJAR'
		64: return 'WALLACE'
		65: return 'WATSON'
		66: return 'WEST'
		67: return 'WOOD'
		68: return 'WOODS'
		69: return 'SMITH'
		70: return 'ALLEN'
		71: return 'BANKS'
		72: return 'BLAKE'
		73: return 'BURTON'
		74: return 'CHAVEZ'
		75: return 'CLARK'
		76: return 'CRUZ'
		77: return 'DUNN'
		78: return 'ELLIOTT'
		79: return 'EVANS'
		80: return 'FISHER'
		81: return 'FRANKLIN'
		82: return 'GARRETT'
		83: return 'GEORGE'
		84: return 'GIBSON'
		85: return 'GRAVES'
		86: return 'GREEN'
		87: return 'HARRIS'
		88: return 'HUNTER'
		89: return 'JACKSON'
		90: return 'JAMES'
		91: return 'JORDAN'
		92: return 'KENNEDY'
		93: return 'LARSON'
		94: return 'LAWSON'
		95: return 'MORGAN'
		96: return 'MURPHY'
		97: return 'REYNOLDS'
		98: return 'SHAW'
		99: return 'WELLS'
	return 'SMITH'
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_mood_data_from_string(str:String) -> Dictionary:
	return mood_data[RESEARCHER.MOODS[str]]

func return_trait_data_from_string(str:String) -> Dictionary:
	return trait_data[RESEARCHER.TRAITS[str]]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_trait_data(ref:RESEARCHER.TRAITS) -> Dictionary:
	trait_data[ref].ref = ref
	return trait_data[ref]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_specialization_data(ref:RESEARCHER.SPECIALIZATION) -> Dictionary:
	specialization_data[ref].ref = ref
	return specialization_data[ref]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_mood_data(ref:RESEARCHER.MOODS) -> Dictionary:
	mood_data[ref].ref = ref
	return mood_data[ref]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_spec_available_count(ref:RESEARCHER.SPECIALIZATION) -> int:
	var filtered:Array = hired_lead_researchers_arr.filter(func(x): 
		var data:Dictionary = return_data_with_uid(x[0])
		if data.specialization.ref == ref and data.props.assigned_to_room.is_empty():
			return x
	)
	return filtered.size()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_spec_count(ref:RESEARCHER.SPECIALIZATION) -> int:
	var filtered:Array = hired_lead_researchers_arr.filter(func(x): 
		var data:Dictionary = return_data_with_uid(x[0])
		if data.specialization.ref == ref:
			return x
	)
	return filtered.size()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_spec_capacity_count(ref:RESEARCHER.SPECIALIZATION) -> int:	
	var GameplayNode:Control = GBL.find_node(REFS.GAMEPLAY_LOOP)
	return room_config.base.staff_capacity[ref] + OS_STORE.starting_data.starting_personnel_capacity[ref] + GameplayNode.starting_data.personnel_capacity[ref]
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
		if spec == -1 or spec == item.specialization.ref:
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
func remove_assigned_location(use_location:Dictionary) -> void:
	hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
		# clear out prior researchers
		if U.dictionaries_equal(i[11].assigned_to_room, use_location):
			i[11].assigned_to_room = {}
			i[11].slot = 0
		return i
	)
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	
func promote_researcher(uid:String) -> void:	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
		if i[0] == uid:
			# i[9] is level
			i[9] += 1
		return i
	) 		
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func clone_researcher(uid:String) -> void:
	var cloned_researcher = hired_lead_researchers_arr.filter(func(i):
		if i[0] == uid:
			return i
		)[0].duplicate(true)
	
	var is_original:bool = cloned_researcher[10].original_uid == null
	
	cloned_researcher[0] = U.generate_uid()
	cloned_researcher[10].clone_iteration += 1
	cloned_researcher[10].original_uid = uid if is_original else cloned_researcher[10].original_uid
	cloned_researcher[11].assigned_to_room = {}
	cloned_researcher[11].slot = 0
	
	hired_lead_researchers_arr.push_back(cloned_researcher)
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func change_mood(uid:String, mood_ref:RESEARCHER.MOODS) -> void:
	var filtered:Array = hired_lead_researchers_arr.filter(func(i):
		if i[0] == uid:
			# update mood
			i[4] = mood_ref
		return i
	)
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func change_trait(uid:String, trait_ref:RESEARCHER.TRAITS) -> void:
	var filtered:Array = hired_lead_researchers_arr.filter(func(i):
		if i[0] == uid:
			# update trait
			i[2] = trait_ref
		return i
	)
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func change_status_to_kia(uid:String) -> Dictionary:
	var filtered:Array = hired_lead_researchers_arr.filter(func(i):
		if i[0] == uid:
			# update health val
			i[6].current = 0
			
			# out of hp, change status and remove from room
			if i[6].current <= 0:
				i[5] = RESEARCHER.STATUS.KIA
				i[11].assigned_to_room = {}
				i[11].slot = 0
		return i
	)
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
	
	return get_user_object(filtered[0])
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func change_status_to_insane(uid:String) -> Dictionary:
	var filtered:Array = hired_lead_researchers_arr.filter(func(i):
		if i[0] == uid:
			# update sanity val
			i[7].current = 0
			
			# out of hp, change status and remove from room
			if i[7].current <= 0:
				i[5] = RESEARCHER.STATUS.INSANE
		return i
	)
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
	
	return get_user_object(filtered[0])
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func damage_sanity(uid:String, amount:int) -> Dictionary:
	var filtered:Array = hired_lead_researchers_arr.filter(func(i):
		if i[0] == uid:
			# update val
			i[7].current = U.min_max(i[7].current - amount, 0, i[7].max)
			
			# out of hp, change status and remove from room
			if i[7].current <= 0:
				change_status_to_insane(uid)
		return i
	)
	
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr

	return get_user_object(filtered[0])
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func take_damage(uid:String, amount:int) -> Dictionary:
	var filtered:Array = hired_lead_researchers_arr.filter(func(i):
		if i[0] == uid:
			# update val
			i[6].current = U.min_max(i[6].current - amount, 0, i[6].max)
			
			# out of hp, change status and remove from room
			if i[6].current <= 0:
				change_status_to_kia(uid)
		return i
	)
	
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr

	return get_user_object(filtered[0])
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func restore_health(uid:String, amount:int) -> Dictionary:
	var filtered:Array = hired_lead_researchers_arr.filter(func(i):
		if i[0] == uid:
			# update val
			i[6].current = U.min_max(i[6].current + amount, 0, i[6].max)
			
			# out of hp, change status and remove from room
			if i[6].current > 0:
				i[5] = RESEARCHER.STATUS.ALIVE

		return i
	)
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr

	return get_user_object(filtered[0])
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func restore_sanity(uid:String, amount:int) -> Dictionary:
	var filtered:Array = hired_lead_researchers_arr.filter(func(i):
		if i[0] == uid:
			# update val
			i[7].current = U.min_max(i[6].current + amount, 0, i[7].max)
			
			# if was insane, revert back to ALIVE status
			if i[5] == RESEARCHER.STATUS.INSANE:
				i[5] = RESEARCHER.STATUS.ALIVE
				
		return i
	)
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr

	return get_user_object(filtered[0])
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func add_experience(uid:String, amount:int) -> bool:
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
		if i[0] == uid:
			# i[8] is xp
			i[8] += amount
		return i
	) 	
	
	var researcher:Array = hired_lead_researchers_arr.filter(func(i): return i[0] == uid)[0]
	# returns if reasearcher leveled up
	return researcher[9].can_promote
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func can_be_promoted(uid:String) -> bool:	
	var xp_required_for_promotion:int = 10 #1DEBUG.get_val(DEBUG.RESEARCHER_XP_REQUIRED_FOR_PROMOTION)
	return hired_lead_researchers_arr.filter(func(i): return i[8] >= xp_required_for_promotion and i[0] == uid).size() > 0
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
func get_list_of_available(filter_for_specs: Array = []) -> Array:
	return hired_lead_researchers_arr.filter(func(x):
		var researcher_data: Dictionary = get_user_object(x)
		var is_unassigned = researcher_data.props.assigned_to_room.is_empty()
		var specialization_ref = researcher_data.specialization.ref
		var accepts_any = false #RESEARCHER.SPECIALIZATION.ANY in filter_for_specs
		var matches_spec = specialization_ref in filter_for_specs
		var is_unavailable = researcher_data.status == RESEARCHER.STATUS.KIA or researcher_data.status == RESEARCHER.STATUS.INSANE
		
		if accepts_any and is_unassigned and !is_unavailable:
			return true
		
		return is_unassigned and matches_spec and !is_unavailable
	)
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
func get_list_of_specializations() -> Array:
	var list:Array = []
	for ref in specialization_data:
		var spec:Dictionary = specialization_data[ref]
		spec.ref = ref
		list.push_back(spec)
	return list
# ------------------------------------------------------------------------------		
	
