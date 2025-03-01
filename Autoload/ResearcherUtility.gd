extends UtilityWrapper

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
	RESEARCHER.TRAITS.HARD_WORKING: {
		"name": "HARD WORKING",
		"description": "Always willing to put in extra effort and time to complete tasks efficiently.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.MOTIVATED: {
		"name": "MOTIVATED",
		"description": "Driven to succeed and overcome obstacles, even in challenging situations.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.CLEVER: {
		"name": "CLEVER",
		"description": "Able to quickly find solutions and think outside the box when faced with problems.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.STUBBORN: {
		"name": "STUBBORN",
		"description": "Refuses to give up even when faced with resistance, often pushing through obstacles.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.ADAPTABLE: {
		"name": "ADAPTABLE",
		"description": "Quick to adjust and thrive in changing environments or situations.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.CHARISMATIC: {
		"name": "CHARISMATIC",
		"description": "Has a magnetic personality that inspires and motivates others to follow.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.EMPATHETIC: {
		"name": "EMPATHETIC",
		"description": "Cares about others.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.RESOURCEFUL: {
		"name": "RESOURCEFUL",
		"description": "Able to make the most out of limited resources and find creative solutions.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.PATIENT: {
		"name": "PATIENT",
		"description": "Willing to wait for the right moment and methodically work toward a goal.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.ASSERTIVE: {
		"name": "ASSERTIVE",
		"description": "Able to express one's thoughts, feelings, and beliefs in an open and respectful manner.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.DISCIPLINED: {
		"name": "DISCIPLINED",
		"description": "Maintains focus and control over one's actions to achieve long-term goals.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.AMBITIOUS: {
		"name": "AMBITIOUS",
		"description": "Has a strong desire to achieve great things and improve oneself.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.INNOVATIVE: {
		"name": "INNOVATIVE",
		"description": "Constantly thinking of new and creative solutions to problems.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.LOYAL: {
		"name": "LOYAL",
		"description": "Dedicated to and supportive of the organization or people they work with.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.PRAGMATIC: {
		"name": "PRAGMATIC",
		"description": "Focused on practical results and making decisions based on reality rather than ideals.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.METICULOUS: {
		"name": "METICULOUS",
		"description": "Pays great attention to detail and ensures everything is done precisely.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.OPTIMISTIC: {
		"name": "OPTIMISTIC",
		"description": "Maintains a positive outlook and expects the best outcomes.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.REALISTIC: {
		"name": "REALISTIC",
		"description": "Has a practical and logical view of situations, with an eye on the current circumstances.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.HUMBLE: {
		"name": "HUMBLE",
		"description": "Modest and free of arrogance, often valuing the contributions of others.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.COURAGEOUS: {
		"name": "COURAGEOUS",
		"description": "Willing to face danger or difficult situations despite fear or uncertainty.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.STRATEGIC: {
		"name": "STRATEGIC",
		"description": "Plans ahead, considering all variables and potential outcomes to achieve a goal.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.IMPULSIVE: {
		"name": "IMPULSIVE",
		"description": "Acts quickly and without much thought, often following immediate desires or instincts.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.INDEPENDENT: {
		"name": "INDEPENDENT",
		"description": "Works well alone and prefers to take initiative without relying on others.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.CURIOUS: {
		"name": "CURIOUS",
		"description": "Always eager to learn new things and discover unknown aspects of the world.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.TRAITS.PESSIMISTIC: {
		"name": "PESSIMISTIC",
		"description": "Tends to expect negative outcomes and focuses on the downside of situations.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	}
}

var synergy_trait_data: Dictionary = {
	RESEARCHER.SYNERGY_TRAITS.DREAM_TEAM: {
		"name": "DREAM TEAM",
		"description": "Combines cleverness and motivation to overcome challenges with creativity and determination.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.SYNERGY_TRAITS.ARCHITECTS_OF_SUCCESS: {
		"name": "ARCHITECTS OF SUCCESS",
		"description": "Resourcefulness and meticulous planning ensure every project is built to last.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.SYNERGY_TRAITS.BALANCING_ACT: {
		"name": "BALANCING ACT",
		"description": "A perfect harmony of pragmatic realism and boundless optimism, keeping projects grounded yet ambitious.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	RESEARCHER.SYNERGY_TRAITS.POWER_PAIR: {
		"name": "POWER PAIR",
		"description": "Charisma and strategy combine to lead teams with vision and precision.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},
	
	
	RESEARCHER.SYNERGY_TRAITS.TRAILBLAZER: {
		"name": "TRAILBLAZER",
		"description": "Combines innovation and courage to forge new paths and tackle the unknown head-on.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},

	RESEARCHER.SYNERGY_TRAITS.SPARK_AND_GRIND: {
		"name": "SPARK AND GRIND",
		"description": "Merges cleverness and hard work to achieve breakthroughs through insight and relentless effort.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},

	RESEARCHER.SYNERGY_TRAITS.ADAPTIVE_THINKER: {
		"name": "ADAPTIVE THINKER",
		"description": "Combines adaptability and strategy to navigate challenges with flexible, well-planned approaches.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},

	RESEARCHER.SYNERGY_TRAITS.VISIONARY: {
		"name": "VISIONARY",
		"description": "Blends optimism and curiosity to see possibilities where others see obstacles.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},

	RESEARCHER.SYNERGY_TRAITS.MAD_GENIUS: {
		"name": "MAD GENIUS",
		"description": "Combines wild innovation with impulsive action, leading to groundbreaking discoveries—or spectacular failures.",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func(details: Dictionary) -> Dictionary:
			return {},
	},	
	
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
		var room_extract:Dictionary = ROOM_UTIL.extract_room_details(location)			
		
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
