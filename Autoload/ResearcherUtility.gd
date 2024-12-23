extends Node

var specialization_data:Dictionary = { 
	RESEARCHER.SPECALIZATION.PSYCHOLOGY: {
		"name": "PSY", 
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func() -> void:
			return,
		"hire_cost": func() -> int:
			return 4,		
	},
	RESEARCHER.SPECALIZATION.BIOLOGY: {
		"name": "BIO", 
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func() -> void:
			return,
		"hire_cost": func() -> int:
			return 4,		
	},
	RESEARCHER.SPECALIZATION.ENGINEERING: {
		"name": "ENG", 
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func() -> void:
			return,
		"hire_cost": func() -> int:
			return 4,					
	}
}

var trait_data:Dictionary = {
	RESEARCHER.TRAITS.MOTIVATED: {
		"name": "MOT", 
		"icon": SVGS.TYPE.ENERGY,
		"type": 0, # 0 IS POSITIVE, 1 IS NEGATIVE
		"get_effect": func() -> void:
			return,
		"hire_cost": func() -> int:
			return 4,		
	},
	RESEARCHER.TRAITS.DILIGENT: {
		"name": "DIL", 
		"icon": SVGS.TYPE.ENERGY,
		"type": 0,
		"get_effect": func() -> void:
			return,
		"hire_cost": func() -> int:
			return 4,		
	},
	RESEARCHER.TRAITS.BENEVOLENT: {
		"name": "BEN", 
		"icon": SVGS.TYPE.ENERGY,
		"type": 0,
		"get_effect": func() -> void:
			return,
		"hire_cost": func() -> int:
			return 4,		
	},
	RESEARCHER.TRAITS.MOODY: {
		"name": "MDY", 
		"icon": SVGS.TYPE.ENERGY,
		"type": 1,
		"get_effect": func() -> void:
			return,
		"hire_cost": func() -> int:
			return 4,		
	},	
	RESEARCHER.TRAITS.PARTICULAR: {
		"name": "PAR", 
		"icon": SVGS.TYPE.ENERGY,
		"type": 1,
		"get_effect": func() -> void:
			return,
		"hire_cost": func() -> int:
			return 4,		
	},
	RESEARCHER.TRAITS.CRUEL: {
		"name": "CRL", 
		"icon": SVGS.TYPE.ENERGY,
		"type": 1,
		"get_effect": func() -> void:
			return,
		"hire_cost": func() -> int:
			return 4,		
	},			
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
func generate_researcher() -> Array:
	var uid:String = U.generate_uid()
	var lname:int = U.generate_rand(0, 5)
	
	var traits:Array = []
	for i in [70, 30, 10]:
		var rand:int = U.generate_rand(0, 100)
		if i < rand:
			break
		var val:int = U.generate_rand(0, RESEARCHER.TRAITS.size() - 1)
		if val not in traits:
			traits.push_back( val )
	
	var specialization:Array = []
	for i in [100, 30, 10]:
		var rand:int = U.generate_rand(0, 100)
		if i < rand:
			break
		var val:int = U.generate_rand(0, RESEARCHER.SPECALIZATION.size() - 1)
		if val not in specialization:
			specialization.push_back( val )
	
	var rval:int = U.generate_rand(0, 9)
	var lval:int = U.generate_rand(0, 9)
		
	return [ uid, lname, traits, specialization, rval, lval]
# ------------------------------------------------------------------------------
	
# ------------------------------------------------------------------------------
func get_user_object(val:Array) -> Dictionary:
	var uid_val:String = val[0]
	var name_val:int = val[1]
	var traits_list:Array = val[2]
	var specializations_list:Array = val[3]
	var r_val:int = val[4]
	var l_val:int = val[5]
	
	var lname:String = get_lname(name_val)
	
	var traits:Array = []
	for i in traits_list:
		traits.push_back(i)
		
	var specializations:Array = []
	for t in specializations_list:
		specializations.push_back(t)
		
	return {
		"uid": uid_val,
		"name": "DR %s. %s" % [lname],
		"traits": traits,
		"specializations": specializations,
		"r_val": r_val,
		"l_val": l_val
	}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_lname(i:int) -> String:
	match i:
		0: return 'A. RYAN'
		1: return 'B. MARTIN'
		2: return 'C. OYAS'
		3: return 'D. SINCLAIRE'
		4: return 'E. WOODS'
		5: return 'F. VIAJAR'
	return 'R. SMITH'
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func return_trait_data(key:RESEARCHER.TRAITS) -> Dictionary:
	return trait_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_specialization_data(key:RESEARCHER.SPECALIZATION) -> Dictionary:
	return specialization_data[key]
# ------------------------------------------------------------------------------
