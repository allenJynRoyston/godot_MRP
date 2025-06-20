@tool
extends SubscribeWrapper

const dlc_folder:String = "res://_DLC/"

var ROOM_TEMPLATE:Dictionary = {
	# ------------------------------------------
	"name": "FULL NAME",
	"shortname": "SHORTNAME",
	"categories": [ROOM.CATEGORY.STANDARD],
	"img_src": "res://Media/images/redacted.png",
	"description": "Room description.",
	# ------------------------------------------

	# ------------------------------------------
	"can_contain": false,
	"can_destroy": true,
	"can_assign_researchers": true,
	"requires_unlock": true,	
	"own_limit": 99,
	"unlock_level": 0,
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 50,
		"purchase": 100,
	},
	# ------------------------------------------	
	
	# ------------------------------------------
	"requires_specialization": RESEARCHER.SPECIALIZATION.ANY,	
	"required_personnel": [
		# RESOURCE.PERSONNEL.STAFF
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
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.CORE: 0
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"metrics": {
		RESOURCE.METRICS.MORALE: 0,
		RESOURCE.METRICS.SAFETY: 0,
		RESOURCE.METRICS.READINESS: 0,
	},	
	# ------------------------------------------
	
}

var reference_data:Dictionary = {}
var reference_list:Array = []

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
func fill_template(data:Dictionary, ref_count:int) -> void:
	var template_copy:Dictionary = ROOM_TEMPLATE.duplicate(true)
	for key in data:
		var value = data[key]
		if key in template_copy:
			template_copy[key] = value
	
	if "metrics" in data:
		for key in data.metrics:
			var amount:int = data.metrics[key]
			template_copy.metrics[key] = amount

	if "currencies" in data:
		for key in data.currencies:
			var amount:int = data.currencies[key]
			template_copy.currencies[key] = amount

	if "ref" in data:
		reference_list.push_back(data.ref)
		reference_data[data.ref] = template_copy		
	else:
		reference_list.push_back(ref_count)
		reference_data[ref_count] = template_copy
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
func return_purchase_cost(ref:int) -> int:
	var room_data:Dictionary = return_data(ref)
	return room_data.costs.purchase
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_unlock_costs(ref:int) -> int:
	var room_data:Dictionary = return_data(ref)
	return room_data.costs.unlock
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
#func return_pairs_with_details(ref:int) -> Dictionary:
	#var room_data:Dictionary = return_data(ref)
	#var details:Dictionary = {}
	#if "pairs_with" in room_data:
		#details = {
			#"specialization": RESEARCHER_UTIL.return_specialization_data(room_data.pairs_with.specialization),
			##"trait": RESEARCHER_UTIL.return_trait_data(room_data.pairs_with.trait),
		#}
#
	#return details
# ------------------------------------------------------------------------------

## ------------------------------------------------------------------------------
#func check_for_pairing(ref:int, researchers:Array) -> bool:
	#var scp_details:Dictionary = return_data(ref)
	#var match_spec:bool = false
	#
	#for researcher in researchers:
		#if !match_spec and (scp_details.pairs_with.specialization in researcher.specializations):
			#match_spec = true
		##if !match_trait and (scp_details.pairs_with.trait in researcher.traits):
			##match_trait = true
	#
	#return {
		#"match_spec": match_spec,
		##"match_trait": match_trait,
		#
	#}
## ------------------------------------------------------------------------------

## ------------------------------------------------------------------------------
func get_max_possible_level(ref:int) -> int:
	var room_data:Dictionary = return_data(ref)	
	var max_lvl:int = 0
	for abl in room_data.abilities.call():
		if abl.lvl_required > max_lvl:
			max_lvl = abl.lvl_required
	
	for abl in room_data.passive_abilities.call():
		if abl.lvl_required > max_lvl:
			max_lvl = abl.lvl_required
			
	return max_lvl
## ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func check_for_room_pair(ref:int, researcher:Dictionary) -> bool:
	var room_data:Dictionary = return_data(ref)	
	return room_data.requires_specialization == researcher.specialization.ref
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func calculate_unlock_cost(ref:int, add:bool = false) -> void:		
	var room_data:Dictionary = return_data(ref)
	
	resources_data[RESOURCE.CURRENCY.SCIENCE].amount = U.min_max(resources_data[RESOURCE.CURRENCY.SCIENCE].amount - room_data.costs.unlock, 0, resources_data[RESOURCE.CURRENCY.SCIENCE].capacity)

	SUBSCRIBE.resources_data = resources_data
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_purchase_cost(ref:int, add:bool = false) -> Dictionary:		
	var room_data:Dictionary = return_data(ref)
	
	resources_data[RESOURCE.CURRENCY.MONEY].amount = U.min_max(resources_data[RESOURCE.CURRENCY.MONEY].amount - room_data.costs.purchase, 0, resources_data[RESOURCE.CURRENCY.MONEY].capacity)

	SUBSCRIBE.resources_data = resources_data
	return resources_data
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_operating_costs(ref:int, add:bool = true) -> Dictionary:		
	var room_data:Dictionary = return_data(ref)
	
	resources_data[RESOURCE.CURRENCY.MONEY].amount = U.min_max(resources_data[RESOURCE.CURRENCY.MONEY].amount - room_data.costs.operating, 0, resources_data[RESOURCE.CURRENCY.MONEY].capacity)

	SUBSCRIBE.resources_data = resources_data
	return resources_data
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func build_count(ref:int) -> int:
	var filter:Array = purchased_facility_arr.filter(func(i):return i.ref == ref)
	return filter.size()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func owns_and_is_active(ref:int) -> bool:
	var filter:Array = purchased_facility_arr.filter(func(i):return i.ref == ref)
	if filter.size() == 0:
		return false
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(filter[0].location)
	return room_extract.room.is_activated
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func get_category(category:ROOM.CATEGORY, unlock_level:int, start_at:int, limit:int) -> Dictionary:
	var filter:Callable = func(list:Array) -> Array:
		return list.filter(func(i): return (category in i.details.categories) and (unlock_level >= i.details.unlock_level))
	
	return SHARED_UTIL.return_tier_paginated(reference_data, filter, start_at, limit)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_unlocked_category(category:ROOM.CATEGORY, start_at:int, limit:int) -> Dictionary:
	# start list with everything that's unlocked
	var ref_list:Array = shop_unlock_purchases 
	
	# then add the anything that doesn't require an unlock
	for ref in reference_data:
		if !reference_data[ref].requires_unlock:
			ref_list.push_back(ref)
	
	# weed out duplicates
	ref_list = U.array_find_uniques(ref_list)
	
	# filter for matching categories
	var filter:Callable = func(list:Array) -> Array:
		return list.filter(func(i): return category in i.details.categories and i.ref in ref_list)

	# return pagination results
	return SHARED_UTIL.return_tier_paginated(reference_data, filter, start_at, limit)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# remove this later
#func return_wing_effects_list(room_extract:Dictionary) -> Array:
	#return []
	##return SHARED_UTIL.return_wing_effects_list(return_data(room_extract.room.details.ref), room_extract, "activation_effect")
## ------------------------------------------------------------------------------	

## ------------------------------------------------------------------------------		
#func return_wing_effect(extract_data:Dictionary) -> Dictionary:
	#var room_data:Dictionary = return_data(extract_data.room.details.ref)
	#if "wing_effect" in room_data:
		#return room_data.wing_effect.call(extract_data)
	#
	#return {}
## ------------------------------------------------------------------------------		

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
