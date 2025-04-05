@tool
extends SubscribeWrapper

const dlc_folder:String = "res://_DLC/"


var ROOM_TEMPLATE:Dictionary = {
	# ------------------------------------------
	"type_ref": null,
	"name": "FULL NAME",
	"shortname": "SHORTNAME",
	"tier": TIER.VAL.ZERO,
	"img_src": "res://Media/images/redacted.png",
	"description": "Room description.",
	# ------------------------------------------

	# ------------------------------------------
	"can_contain": false,
	"can_destroy": true,
	"can_assign_researchers": true,
	"requires_unlock": true,	
	"own_limit": 10,
	"build_time": 1,
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
		"operating": 10
	},
	# ------------------------------------------	
	
	# ------------------------------------------
	"resource_requirements": [
	],	
	# ------------------------------------------

	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			
		],
	# ------------------------------------------	
	
	# ------------------------------------------	
	"passive_abilities": func() -> Array: 
		return [

		],		
	# ------------------------------------------
	
	# ------------------------------------------	
	"pairs_with": [
		#RESEARCHER.SPECIALIZATION.SOCIOLOGY,
		#RESEARCHER.SPECIALIZATION.PHYSICS
	],
	# ------------------------------------------
	
	# ------------------------------------------
	"metrics": {
		RESOURCE.BASE_METRICS.MORALE: 0,
		RESOURCE.BASE_METRICS.SAFETY: 0,
		RESOURCE.BASE_METRICS.READINESS: 0,
	},	
	# ------------------------------------------
	
}
#
#var DIRECTORS_OFFICE:Dictionary = {
	## ------------------------------------------
	#"name": "DIRECTORS OFFICE",
	#"shortname": "D.OFFICE",
	#"tier": TIER.VAL.ZERO,
	#"img_src": "res://Media/rooms/research_lab.jpg",
	#"description": "The site directors office.",
	## ------------------------------------------
#
	## ------------------------------------------
	#"can_contain": true,
	#"can_destroy": false,
	#"requires_unlock": false,	
	#"own_limit": 1,
	#"build_time": 1,
	#
	#"costs": {
		#"unlock": 50,
		#"purchase": 100,
		#"operating": 10
	#},
	#
	#"passive_abilities": func() -> Array: 
		#return [
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_SECURITY, 0),
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_STAFF, 1),
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_TECHNICIANS, 2),
		#],		
	#
	#"pairs_with": [
		#RESEARCHER.SPECIALIZATION.SOCIOLOGY,
		#RESEARCHER.SPECIALIZATION.PHYSICS
	#],
	#
	#"metrics": {
		#RESOURCE.BASE_METRICS.MORALE: 1,
		#RESOURCE.BASE_METRICS.SAFETY: 1,
		#RESOURCE.BASE_METRICS.READINESS: 1,
	#},	
	## ------------------------------------------
	#
	## ------------------------------------------
	##"abilities": func() -> Array: 
		##return [
			##{
				##"name": "AQUIRE SCP",
				##"unlock_cost": func() -> Dictionary:
					##return {
						##RESOURCE.TYPE.SCIENCE: -20
					##},
				##"cooldown_duration":  5, 
				##"effect": func() -> bool:
					##return await GAME_UTIL.get_new_scp(),
			##}
		##],	
	## ------------------------------------------
	#
	## ------------------------------------------
	##"passive_abilities": func() -> Array: 
		##return [
			##{
				##"name": "TEST +1",
				##"use_cost": func() -> Dictionary:
					##return {
						##RESOURCE.TYPE.ENERGY: -1
					##},
			##}
		##],	
	## ------------------------------------------	
#
	## ------------------------------------------
	##"unlock_costs": {
		##"resources": {
			##"amount": func() -> Dictionary:
				##return {
					##
				##},
		##}	
	##},
		##
	##"purchase_costs": {
		##"resources": {
			##"amount": func() -> Dictionary:
				##return {
					##
				##},
		##}	
	##},
##
	##"operating_costs": {
		##"resources": {
			##"amount": func() -> Dictionary:
				##return {
					##RESOURCE.TYPE.MONEY: -1
				##},
		##}	
	##},
	## ------------------------------------------
	#
	## ------------------------------------------	
	##"specilization_bonus": func(specilizations:Array) -> Dictionary:
		##return {},
	## ------------------------------------------	
#}
#
#var HQ:Dictionary = {
	#"name": "HEADQUARTERS",
	#"shortname": "HQ",
	#"tier": TIER.VAL.ZERO,
	#"img_src": "res://Media/rooms/research_lab.jpg",
	#"description": "Base headquarters.",
		#
	## ------------------------------------------
	#"can_contain": false,
	#"can_destroy": false,
	#"requires_unlock": false,	
	#"own_limit": 1,
	#"build_time": 1,
	## ------------------------------------------
#
	## --------------------------------------
	#"pairs_with": [
		#RESEARCHER.SPECIALIZATION.ADMINISTRATION
	#],
	#
	#"metrics": {
		#RESOURCE.BASE_METRICS.MORALE: 1,
		#RESOURCE.BASE_METRICS.SAFETY: 1,
		#RESOURCE.BASE_METRICS.READINESS: 1,
	#},
	## --------------------------------------	
		#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.HIRE_RESEARCHER),
			#ABL.get_ability(ABL.REF.PROMOTE_RESEARCHER, 1),
		#],	
	## ------------------------------------------
#
	## ------------------------------------------
	#"unlock_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.SCIENCE: -20
				#},
		#}	
	#},
		#
	#"purchase_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.SCIENCE: -20
				#},
		#}	
	#},
#
	#"operating_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.SCIENCE: 10,
					#RESOURCE.TYPE.MONEY: 10
				#},
		#}	
	#},
	## ------------------------------------------
	#
	## ------------------------------------------	
	##"specilization_bonus": func(specilizations:Array) -> Dictionary:
		##if RESEARCHER.SPECIALIZATION.CHEMISTRY in specilizations:
			##return {
				##"ap": 1
			##}
		##if RESEARCHER.SPECIALIZATION.PSYCHOLOGY in specilizations:
			##return {
				##
			##}
		##return {}
	## ------------------------------------------		
#}
#
#var AQUISITION_DEPARTMENT:Dictionary = {
	#"name": "AQUISITIONS DEPARTMENT",
	#"shortname": "AQUISITIONS DEPT.",
	#"tier": TIER.VAL.ZERO,
	#"img_src": "res://Media/rooms/research_lab.jpg",
	#"description": "Allows you to view any REDACTED room profiles before unlocking them.",
#
	## ------------------------------------------
	#"can_contain": false,
	#"can_destroy": false,
	#"requires_unlock": false,		
	#"build_time": 1,
	## ------------------------------------------
		#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.UNLOCK_FACILITIES),
		#],	
	## ------------------------------------------
#
	## ------------------------------------------
	#"unlock_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
#
				#},
		#}	
	#},
		#
	#"purchase_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -20
				#},
		#}	
	#},
#
	#"operating_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -1
				#},
		#}	
	#},
	## ------------------------------------------	
	#
	## ------------------------------------------	
	##"specilization_bonus": func(specilizations:Array) -> Dictionary:
		##if RESEARCHER.SPECIALIZATION.PHARMACOLOGY in specilizations:
			##return {
				##"resource":{
					##RESOURCE.TYPE.ENERGY: 2
				##},
			##}
		##if RESEARCHER.SPECIALIZATION.PSYCHOLOGY in specilizations:
			##return {
##
			##}
		##return {},
	## ------------------------------------------		
#}
#
#var R_AND_D_LAB:Dictionary = {
	#"name": "R&D LAB",
	#"shortname": "R&D LAB",
	#"tier": TIER.VAL.ONE,
	#"img_src": "res://Media/rooms/research_lab.jpg",
	#"description": "Enables research and development.",
#
	## ------------------------------------------
	#"can_contain": false,
	#"can_destroy": false,
	#"requires_unlock": false,	
	#"build_time": 1,
	## ------------------------------------------
		#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
			#ABL_P.get_ability(ABL_P.REF.UPGRADE_ABL_LVL)
		#],	
	## ------------------------------------------
#
	## ------------------------------------------
	#"unlock_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -30
				#},
		#}	
	#},
		#
	#"purchase_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -20
				#},
		#}	
	#},
	#
	#"operating_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.SCIENCE: 25
				#},
		#}	
	#}	
	## ------------------------------------------
#}
#
#var CONSTRUCTION_YARD:Dictionary = {
	#"name": "CONSTRUCTION YARD",
	#"shortname": "C.YARD",
	#"tier": TIER.VAL.ZERO,
	#"img_src": "res://Media/rooms/construction_yard.jpg",
	#"description": "Enables base development.",
#
	## ------------------------------------------
	#"can_contain": false,
	#"can_destroy": false,
	#"requires_unlock": false,		
	#"build_time": 1,
	#"resource_requirements": [
		#RESOURCE.TYPE.SECURITY
	#],	
	## ------------------------------------------
		#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
#
		#],	
	## ------------------------------------------
#
	## ------------------------------------------
	#"purchase_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -20
				#},
		#}	
	#},
	#
	#"operating_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -1
				#},
		#}	
	#}	
	## ------------------------------------------
#}
#
#var BARRICKS:Dictionary = {
	#"name": "BARRICKS",
	#"shortname": "BARRICKS",
	#"tier": TIER.VAL.ZERO,
	#"img_src": "res://Media/rooms/barricks.jpg",
	#"description": "Houses security forces.",
#
	## ------------------------------------------
	#"can_contain": false,
	#"can_destroy": false,
	#"requires_unlock": false,		
	#"build_time": 1,
	#"resource_requirements": [],	
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_SECURITY),
		#],	
	## ------------------------------------------
#
	## ------------------------------------------
	#"purchase_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -20
				#},
		#}	
	#},
		#
	#"operating_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -10
				#},
		#}	
	#}	
	## ------------------------------------------
#}
#
#var DORMITORY:Dictionary = {
	#"name": "DORMITORY",
	#"shortname": "DORM",
	#"tier": TIER.VAL.ZERO,
	#"img_src": "res://Media/images/redacted.png",
	#"description": "Houses facility staff.",
	#
	## ------------------------------------------
	#"can_contain": false,
	#"can_destroy": false,
	#"requires_unlock": false,		
	#"build_time": 1,
	## ------------------------------------------
		#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_STAFF)
		#],	
	## ------------------------------------------
#
	## ------------------------------------------
	#"purchase_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -20
				#},
		#}	
	#},
#
	#"operating_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -1
				#},
		#}	
	#}	
	## ------------------------------------------
#}
#
#var HOLDING_CELLS:Dictionary = {
	#"name": "HOLDING CELLS",
	#"shortname": "H CELLS",
	#"tier": TIER.VAL.TWO,
	#"img_src": "res://Media/images/redacted.png",
	#"description": "Houses D-class personel.",
	#
	## ------------------------------------------
	#"can_contain": false,
	#"can_destroy": false,
	#"requires_unlock": false,		
	#"build_time": 1,
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_DCLASS),
	#],	
	## ------------------------------------------	
#
	## ------------------------------------------
	#"purchase_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -20
				#},
		#}	
	#},
#
	#"operating_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -1
				#},
		#}	
	#}	
	## ------------------------------------------
#}
#
#var HR_DEPARTMENT:Dictionary = {
	#"name": "HUMAN RESOURCES DEPARTMENT",
	#"shortname": "HR DEPT",
	#"tier": TIER.VAL.ZERO,
	#"img_src": "res://Media/images/redacted.png",
	#"description": "Enables recruitment of key staff.",
	#
	## ------------------------------------------
	#"can_contain": false,
	#"can_destroy": false,
	#"requires_unlock": false,	
	#"build_time": 1,
	## ------------------------------------------
		#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
#
		#],	
	## ------------------------------------------
#
	## ------------------------------------------
	#"purchase_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -20
				#},
		#}	
	#},
#
	#"operating_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -1
				#},
		#}	
	#}	
	## ------------------------------------------
#}
#
#var HUME_DETECTOR:Dictionary = {
	#"name": "HUME DETECTOR",
	#"shortname": "HUME DET",
	#"tier": TIER.VAL.ZERO,
	#"img_src": "res://Media/images/redacted.png",
	#"description": "Makes hume levels visible.",
	#
	## ------------------------------------------
	#"can_contain": false,
	#"can_destroy": false,
	#"requires_unlock": false,		
	#"build_time": 1,
	## ------------------------------------------
#
	## ------------------------------------------
	#"purchase_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -20
				#},
		#}	
	#},
#
	#"operating_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -1
				#},
		#}	
	#}	
	## ------------------------------------------
#}
#
#var CONTAINMENT_CELL:Dictionary = {
	#"name": "CONTAINMENT_CELL",
	#"shortname": "C.CELL",
	#"tier": TIER.VAL.ZERO,
	#"img_src": "res://Media/images/redacted.png",
	#"description": "A basic room with a high security lock.  Used to contain SCPs.",
	#
	## ------------------------------------------
	#"can_contain": true,
	#"can_destroy": false,
	#"requires_unlock": false,	
	#"build_time": 1,
	## ------------------------------------------
	#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.CONTAIN_SCP)
		#],	
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
			#ABL_P.get_ability(ABL_P.REF.MEMETIC_SHILEDING)
		#],	
	## ------------------------------------------	
#
	## ------------------------------------------
	#"purchase_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -20
				#},
		#}	
	#},
#
	#"operating_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: 10
				#},
		#}	
	#},
	## ------------------------------------------	
	##"specilization_bonus": func(specilizations:Array) -> Dictionary:
		##if RESEARCHER.SPECIALIZATION.BIOLOGIST in specilizations:
			##return {
				##"resource":{
					##RESOURCE.TYPE.ENERGY: 2
				##},
			##}
		##if RESEARCHER.SPECIALIZATION.PSYCHOLOGY in specilizations:
			##return {
##
			##}
		##return {},
	## ------------------------------------------
#}
#
#var ENGINEERING_BAY:Dictionary = {
	#"name": "ENGINEERING BAY",
	#"shortname": "ENG. BAY",
	#"tier": TIER.VAL.ZERO,
	#"img_src": "res://Media/images/redacted.png",
	#"description": "Increases the upgrade level of the entire wing.",
	#
	## ------------------------------------------
	#"can_contain": false,
	#"can_destroy": false,
	#"requires_unlock": false,		
	#"build_time": 1,
	#"resource_requirements": [
		## RESOURCE.TYPE.TECHNICIANS
	#],		
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
#
		#],	
	## ------------------------------------------	
#
	## ------------------------------------------
	#"purchase_costs": {
		#"resources": {
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -20
				#},
		#}	
	#},
#
	#"operating_costs": {
		#"resources": {
#
			#"amount": func() -> Dictionary:
				#return {
					#RESOURCE.TYPE.MONEY: -1
				#},
		#}	
	#},
	## ------------------------------------------	
	##"specilization_bonus": func(specilizations:Array) -> Dictionary:
		##if RESEARCHER.SPECIALIZATION.BIOLOGIST in specilizations:
			##return {
				##"resource":{
					##RESOURCE.TYPE.ENERGY: 2
				##},
			##}
		##if RESEARCHER.SPECIALIZATION.PSYCHOLOGY in specilizations:
			##return {
##
			##}
		##return {},
	## ------------------------------------------
#}

var reference_data:Dictionary = {
	## TIER ZERO
	#ROOM.TYPE.DIRECTORS_OFFICE: DIRECTORS_OFFICE,
	#ROOM.TYPE.HQ: HQ,
	#ROOM.TYPE.AQUISITION_DEPARTMENT: AQUISITION_DEPARTMENT,
	#ROOM.TYPE.BARRICKS: BARRICKS,
	#ROOM.TYPE.DORMITORY: DORMITORY,
	#ROOM.TYPE.HR_DEPARTMENT: HR_DEPARTMENT,
	#ROOM.TYPE.CONSTRUCTION_YARD: CONSTRUCTION_YARD,
	#ROOM.TYPE.ENGINEERING_BAY: ENGINEERING_BAY,
	### TIER ONE
	#
	#ROOM.TYPE.R_AND_D_LAB: R_AND_D_LAB,
	#
	##ROOM.TYPE.HOLDING_CELLS: HOLDING_CELLS,
	#ROOM.TYPE.CONTAINMENT_CELL: CONTAINMENT_CELL,
	#
	##ROOM.TYPE.HUME_DETECTOR: HUME_DETECTOR,
	#
}

var reference_list:Array = []

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


# ------------------------------------------------------------------------------
func _enter_tree() -> void:
	var dlc_dir:DirAccess = DirAccess.open(dlc_folder)
	var dlc_folders:Array = dlc_dir.get_directories()
	var ref_count:int = 0
	
	# goes through any folders in the _DLC folder
	for dfolder in dlc_folders:
		for folder_name in DirAccess.open(str(dlc_folder, dfolder)).get_directories():
			if folder_name == "ROOMS":
				for file_name in DirAccess.open(str(dlc_folder, dfolder, "/", folder_name)).get_files():
					if file_name.ends_with('.gd'):
						var file = FileAccess.open(str(dlc_folder, dfolder, "/", folder_name, "/", file_name), FileAccess.READ)
						if file:
							var script = load(str(dlc_folder, dfolder, "/", folder_name, "/", file_name))
							var instance:GDScript = GDScript.new()
							instance.source_code = script.source_code
							instance.reload()
							var ref_instance = instance.new()
							if "list" in ref_instance:
								for item in ref_instance.list:
									fill_template(item, ref_count)
									ref_count += 1
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------
func fill_template(data:Dictionary, ref:int) -> void:
	var template_copy:Dictionary = ROOM_TEMPLATE.duplicate(true)
	for key in data:
		var value = data[key]
		if key in template_copy:
			template_copy[key] = value

	reference_list.push_back(ref)
	reference_data[ref] = template_copy
# ------------------------------------------------------------------------------	


# ------------------------------------------------------------------------------
func return_data(ref:int) -> Dictionary:
	reference_data[ref].ref = ref
	return reference_data[ref]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_unavailable_rooms(ref:int, room_config:Dictionary) -> Array: 
		return SHARED_UTIL.return_unavailable_rooms(return_data(ref))
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func return_ability(ref:int, ability_index:int) -> Dictionary:
	var room_data:Dictionary = return_data(ref)
	var abilities:Array = room_data.abilities.call() if "abilities" in room_data else []
	return abilities[ability_index]
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	
func return_passive_ability(ref:int, ability_index:int) -> Dictionary:
	var room_data:Dictionary = return_data(ref)
	var abilities:Array = room_data.passive_abilities.call() if "passive_abilities" in room_data else []
	return abilities[ability_index]
# ------------------------------------------------------------------------------		
	
# ------------------------------------------------------------------------------
func return_purchase_cost(ref:int) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "purchase_costs")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_unlock_costs(ref:int) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "unlock_costs")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_operating_cost(ref:int) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "operating_costs")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_activation_cost(ref:int) -> Array:
	return SHARED_UTIL.return_resource_list(return_data(ref), "activation_cost")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_pairs_with_details(ref:int) -> Array:
	var room_data:Dictionary = return_data(ref)
	var arr:Array = []
	if "pairs_with" in room_data:
		for spec in room_data.pairs_with:
			arr.push_back(RESEARCHER_UTIL.return_specialization_data(spec))
	return arr
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func check_for_room_pair(ref:int, specializations:Array) -> bool:
	var room_data:Dictionary = return_data(ref)
	var has_pairing:bool = false
	if "pairs_with" in room_data:
		for spec in specializations:
			if spec in room_data.pairs_with:
				has_pairing = true
				break	
	return has_pairing
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
func calculate_unlock_cost(ref:int, add:bool = false) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "unlock_costs", resources_data, add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_purchase_cost(ref:int, add:bool = false) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "purchase_costs", resources_data, add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_operating_costs(ref:int, add:bool = true) -> Dictionary:		
	return SHARED_UTIL.calculate_resources(return_data(ref), "operating_costs", resources_data, add)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_count(ref:int) -> int:
	return purchased_facility_arr.filter(func(i):return i.ref == ref).size()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func owns_and_is_active(ref:int) -> bool:
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
		return list.filter(func(i): 
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
func has_prerequisites(ref:int, arr:Array) -> bool:
	var room_data:Dictionary = return_data(ref)
	return	false
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func at_own_limit(ref:int) -> bool:
	var room_data:Dictionary = return_data(ref)
	if "own_limit" not in room_data or room_data.own_limit == -1:
		return false
	var owned_count:int = purchased_facility_arr.filter(func(i): return i.ref == ref).size()
	#var in_progress_count:int = 0 #timeline_array.filter(func(i): return i.ref == ref and i.action == ACTION.AQ.BUILD_ITEM).size()
	var total_count:int = owned_count # + in_progress_count
	
	return total_count >= room_data.own_limit
# ------------------------------------------------------------------------------
