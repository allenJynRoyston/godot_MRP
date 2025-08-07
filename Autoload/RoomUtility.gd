@tool
extends SubscribeWrapper

const dlc_folder:String = "res://_DLC/"

var ROOM_TEMPLATE:Dictionary = {
	# ------------------------------------------
	"name": "FULL NAME",
	"shortname": "SHORTNAME",
	"categories": [ROOM.CATEGORY.UTILITY],
	"img_src": "res://Media/images/redacted.png",
	"description": "Room description.",
	# ------------------------------------------

	# ------------------------------------------
	"can_contain": false,
	"containment_properties": [],
	# ------------------------------------------
	
	# ------------------------------------------
	"event_trigger": {},
	#{
		#"ref": EVT.TYPE.DIRECTORS_OFFICE,
		#"day": 10
	#},	
	# ------------------------------------------
	
	# ------------------------------------------
	"can_destroy": true,
	"can_assign_researchers": true,
	"requires_unlock": true,	
	"own_limit": 99,
	"unlock_level": 0,
	"required_staffing": [RESEARCHER.SPECIALIZATION.ANY],	
	"required_energy": 1,
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------	
	
	# ------------------------------------------	
	"effect": {},
	 #{
		#"description": "",
		#"func": func(new_room_config:Dictionary) -> void:
			#pass,
	#},
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
	
	# ------------------------------------------
	"personnel_capacity": {
		RESEARCHER.SPECIALIZATION.ADMIN: 0, 
		RESEARCHER.SPECIALIZATION.RESEARCHER: 0, 
		RESEARCHER.SPECIALIZATION.SECURITY: 0, 
		RESEARCHER.SPECIALIZATION.DCLASS: 0, 
	}
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
func return_data_via_location(use_location:Dictionary) -> Dictionary:
	for item in purchased_facility_arr:
		if use_location == item.location:
			return return_data(item.ref)
	return {}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func list_of_rooms_in_wing(use_location:Dictionary = current_location) -> Array:	
	var list:Array = purchased_facility_arr.filter(func(x):
		if use_location.floor == x.location.floor and use_location.ring == x.location.ring:
			return x
		).map(func(x): return x.location.room)
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func is_under_construction(use_location:Dictionary) -> bool:
	for item in purchased_facility_arr:
		if use_location == item.location:
			return item.under_construction
	return false
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
func get_room_ability_level(use_location:Dictionary = current_location) -> int:
	if room_config.is_empty(): return -1
	
	var room_abl_lvl:int = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].abl_lvl
	var wing_abl_lvl:int = room_config.floor[use_location.floor].ring[use_location.ring].abl_lvl
	var abl_lvl:int = room_abl_lvl + wing_abl_lvl	
	return abl_lvl
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func get_max_level(ref:int) -> int:
	if ref == -1:
		return -1
	
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

## ------------------------------------------------------------------------------
func get_activated_count() -> int:
	var count:int = purchased_facility_arr.filter(func(x): 
		var room_config:Dictionary = room_config.floor[x.location.floor].ring[x.location.ring].room[x.location.room]
		if room_config.is_activated:
			return x
	).size()	
	
	return count
## ------------------------------------------------------------------------------

## ------------------------------------------------------------------------------
func add_to_unlocked_list(ref:int) -> void:
	if ref not in shop_unlock_purchases:
		shop_unlock_purchases.push_back(ref)
	SUBSCRIBE.shop_unlock_purchases = shop_unlock_purchases	
## ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func add_room(ref:int, use_location:Dictionary = current_location) -> void:
	var location_copy:Dictionary = use_location.duplicate(true)
	var WingRenderNode:Node3D = GBL.find_node(REFS.WING_RENDER)		
	WingRenderNode.start_construction(location_copy)	
	await U.tick()
	
	purchased_facility_arr.push_back({
		"ref": ref,
		"under_construction": true,
		"location": {
			"floor": location_copy.floor,
			"ring": location_copy.ring,
			"room": location_copy.room
		}
	})
	
	SUBSCRIBE.purchased_facility_arr = purchased_facility_arr
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func reset_room(use_location:Dictionary) -> void:
	SUBSCRIBE.purchased_facility_arr = purchased_facility_arr.filter(func(i): return !(i.location == use_location))
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func finish_construction(use_location:Dictionary) -> void:
	var location_copy:Dictionary = use_location.duplicate(true)	
	var WingRenderNode:Node3D = GBL.find_node(REFS.WING_RENDER)		
	WingRenderNode.complete_construction(location_copy)
	
	await U.tick()
	
	SUBSCRIBE.purchased_facility_arr = purchased_facility_arr.map(func(x):
		if x.location == location_copy:
			x.under_construction = false
			
			# auto activate if possible
			var room_data:Dictionary = ROOM_UTIL.return_data(x.ref)
			for index in room_data.required_staffing.size():
				var ref:int = room_data.required_staffing[index]
				GAME_UTIL.auto_assign_staff(ref, index, location_copy)	
				
		return x
	)	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func is_room_activated(use_location:Dictionary = current_location) -> bool:
	return room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].is_activated
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func set_room_is_active_state(use_location:Dictionary = current_location, is_activated:bool = true) -> void:	
	var room_base_state:Dictionary = base_states.room[str(use_location.floor, use_location.ring, use_location.room)]
	room_base_state.is_activated = is_activated
	SUBSCRIBE.base_states = base_states
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
func get_category(category:ROOM.CATEGORY, start_at:int, limit:int) -> Dictionary:
	var filter:Callable = func(list:Array) -> Array:
		return list.filter(func(i): 
			return (category in i.details.categories)# and (unlock_level >= i.details.unlock_level)
		)
	return SHARED_UTIL.return_tier_paginated(reference_data, filter, start_at, limit)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_unlocked_category(category:ROOM.CATEGORY, start_at:int, limit:int) -> Dictionary:
	# start list with everything that's unlocked
	var ref_list:Array = shop_unlock_purchases 
	var debug_make_all_available:bool = DEBUG.get_val(DEBUG.GAMPELAY_ALL_ROOMS_AVAILABLE) 
	
	# then add the anything that doesn't require an unlock
	for ref in reference_data:
		if !reference_data[ref].requires_unlock or debug_make_all_available:
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
func check_if_passive_is_active(ref:ABL_P.REF) -> bool:
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var room_base_state:Dictionary = base_states.room[str(floor, ring, room)]
		var room_config:Dictionary = room_config.floor[floor].ring[ring].room[room]
		
		if ref in room_base_state.passives_enabled_list:
			return true
			break
					
	return false
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


# ------------------------------------------------------------------------------	
func find_adjacent_rooms(room:int) -> Array:
	match room:
		0:
			return [1, 2]
		1:
			return [0, 3, 4]
		2:
			return [0, 4, 5]
		3:
			return [1, 6]
		4:
			return [2, 6, 1, 7]
		5:
			return [2, 7]
		6:
			return [4, 3, 8]
		7:
			return [5, 8, 4]
		8:
			return [7, 6]
		_:
			return []
# ------------------------------------------------------------------------------	
