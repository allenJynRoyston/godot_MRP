extends UtilityWrapper

var specialization_data:Dictionary = { 
	RESEARCHER.SPECALIZATION.PSYCHOLOGY: {
		"name": "PSY", 
		"fullname": "PSYCHOLOGY",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func() -> void:
			return,
		"hire_cost": func() -> int:
			return 4,		
	},
	RESEARCHER.SPECALIZATION.BIOLOGY: {
		"name": "BIO", 
		"fullname": "BIOLOGY",
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func() -> void:
			return,
		"hire_cost": func() -> int:
			return 4,		
	},
	RESEARCHER.SPECALIZATION.ENGINEERING: {
		"name": "ENG", 
		"fullname": "ENGINEERING",
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
		"fullname": "MOTIVATED",
		"icon": SVGS.TYPE.ENERGY,
		"type": 0, # 0 IS POSITIVE, 1 IS NEGATIVE
		"get_effect": func(location:Dictionary) -> Dictionary:
			var extract_details:Dictionary = get_details_from_extract(location)
			var room_ref:int = extract_details.room_ref
			var scp_ref:int = extract_details.scp_ref
			return {
				"metrics":
					{
						RESOURCE.BASE_METRICS.MORALE: 1	if room_ref != ROOM.TYPE.R_AND_D_LAB else 2
					}
			},
		"hire_cost": func() -> int:
			return 4,		
	},
	RESEARCHER.TRAITS.DILIGENT: {
		"name": "DIL", 
		"fullname": "DILIGENT",
		"icon": SVGS.TYPE.ENERGY,
		"type": 0,
		"get_effect":  func(location:Dictionary) -> Dictionary:
			var extract_details:Dictionary = get_details_from_extract(location)
			var room_ref:int = extract_details.room_ref
			var scp_ref:int = extract_details.scp_ref
			print(room_ref, " > ", ROOM.TYPE.R_AND_D_LAB)
			return {
				"metrics":
					{
						RESOURCE.BASE_METRICS.MORALE: 0	if room_ref != ROOM.TYPE.R_AND_D_LAB else 2
					}
			},
		"hire_cost": func() -> int:
			return 4,		
	},
	RESEARCHER.TRAITS.BENEVOLENT: {
		"name": "BEN", 
		"fullname": "BENEVOLENT",
		"icon": SVGS.TYPE.ENERGY,
		"type": 0,
		"get_effect":  func(location:Dictionary) -> Dictionary:
			var extract_details:Dictionary = get_details_from_extract(location)

			return {
				"metrics":
					{
						RESOURCE.BASE_METRICS.MORALE: 1	
					}
			},
		"hire_cost": func() -> int:
			return 4,		
	},
	RESEARCHER.TRAITS.MOODY: {
		"name": "MDY", 
		"fullname": "MOODY",
		"icon": SVGS.TYPE.ENERGY,
		"type": 1,
		"get_effect":  func(location:Dictionary) -> Dictionary:
			var extract_details:Dictionary = get_details_from_extract(location)
			
			return {
				"metrics":
					{
						RESOURCE.BASE_METRICS.MORALE: 1	
					}
			},
		"hire_cost": func() -> int:
			return 4,		
	},	
	RESEARCHER.TRAITS.PARTICULAR: {
		"name": "PAR", 
		"fullname": "PARTICULAR",
		"icon": SVGS.TYPE.ENERGY,
		"type": 1,
		"get_effect":  func(location:Dictionary) -> Dictionary:
			var extract_details:Dictionary = get_details_from_extract(location)
		
			return {
				"metrics":
					{
						RESOURCE.BASE_METRICS.MORALE: 1	
					}
			},
		"hire_cost": func() -> int:
			return 4,		
	},
	RESEARCHER.TRAITS.CRUEL: {
		"name": "CRL", 
		"fullname": "CRUEL",
		"icon": SVGS.TYPE.ENERGY,
		"type": 1,
		"get_effect":  func(location:Dictionary) -> Dictionary:
			var room_extract:Dictionary = ROOM_UTIL.extract_room_details(location)

			return {
				"metrics":
					{
						RESOURCE.BASE_METRICS.MORALE: 1	
					}
			},
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
func return_data_with_uid(uid:String) -> Dictionary:
	for index in hired_lead_researchers_arr.size():
		var item:Array = hired_lead_researchers_arr[index]
		if uid == item[0]:
			return get_user_object(item)
			break
	
	return {}
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
	
	# TODO: add this in later
	# var img_src:String = "res://Media/images/example_doctor.jpg"
		
	return [ uid, lname, traits, specialization, rval, lval, 0, 10, {"assigned_to_room": null}]
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
	var sanity:int = val[7] 
	var props:Dictionary = val[8]
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
		"sanity": sanity,
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
func return_specialization_data(key:RESEARCHER.SPECALIZATION) -> Dictionary:
	specialization_data[key].ref = key
	return specialization_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------		
func return_metrics(researcher_data:Dictionary) -> Dictionary:
	for trait_key in researcher_data.traits:
		var trait_data:Dictionary = return_trait_data(trait_key)
		var effects_dict:Dictionary = trait_data.get_effect.call(researcher_data.props.assigned_to_room)
		return effects_dict.metrics if "metrics" in effects_dict else {}
	return {}
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------
func return_effects(researcher_data:Dictionary) -> Array:
	var list:Array = []
	for trait_key in researcher_data.traits:
		var trait_data:Dictionary = return_trait_data(trait_key)
		var effects_dict:Dictionary = trait_data.get_effect.call(researcher_data.props.assigned_to_room)
		if "metrics" in effects_dict:
			for key in effects_dict.metrics:
				var amount:int = effects_dict.metrics[key]
				var resource_data:Dictionary = RESOURCE_UTIL.return_metric_data(key)
				list.push_back({"resource_data": resource_data, "property": "metrics", "amount": "+" if amount > 0 else "-"})

	return list
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func get_details_from_extract(location:Dictionary) -> Dictionary:
	if !location.is_empty():
		var room_extract:Dictionary = ROOM_UTIL.extract_room_details(location)			

		return {
			"room_ref": -1 if room_extract.room.is_empty() else (room_extract.room.details.ref if room_extract.room.is_activated else -1),
			"scp_ref": -1 if room_extract.scp.is_empty() else (room_extract.scp.details.ref if room_extract.scp.is_contained else -1)
		}
		
	return {
		"room_ref": -1,
		"scp_ref": -1
	}		
# ------------------------------------------------------------------------------	
