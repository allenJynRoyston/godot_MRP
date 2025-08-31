@tool
extends SubscribeWrapper

const dlc_folder:String = "res://_DLC/"

var ROOM_TEMPLATE:Dictionary = {
	# ------------------------------------------
	"ref": null,
	"categories": [],
	"link_categories": null,
	"is_core": false,
		
	"name": "FULL NAME",
	"shortname": "SHORTNAME",
	"img_src": "res://Media/images/redacted.png",
	"description": "Requires description...",
	# ------------------------------------------
	
	# ------------------------------------------	
	"influence": {
		"starting_range": 0,
		"effect": null
	},	
	# ------------------------------------------
	
	# ------------------------------------------
	"can_destroy": true,
	"can_assign_researchers": true,
	"requires_unlock": true,	
	"own_limit": 1,
	"unlock_level": 0,
	"required_staffing": [],
	"required_energy": 1,
	# ------------------------------------------	

	# ------------------------------------------
	"can_contain": false,
	"containment_properties": [],
	# ------------------------------------------
	
	# ------------------------------------------
	"on_before_build_event": null, 		# "on_before_build_event": EVT.TYPE.ADMIN_SETUP,
	"on_build_complete_event": null,	# "on_build_complete_event": EVT.TYPE.TEST_EVENT_A
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"unlock": 10,
		"purchase": 5,
	},
	# ------------------------------------------	
	
	# ------------------------------------------	
	"effect": {},
	 #{
		#"description": "",
		#"func": func(new_room_config:Dictionary) -> void:
			#pass,
	#},
	"on_activate": func(_state:bool) -> void:pass,
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
	"environmental":{
		"hazard": 0,
		"temp": 0,
		"pollution": 0
	},
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
func return_data_via_location(use_location:Dictionary = current_location) -> Dictionary:
	for item in purchased_facility_arr:
		if use_location == item.location:
			return return_data(item.ref)
	return {}

func return_scp_data_via_location(use_location:Dictionary = current_location) -> Dictionary:
	for item in purchased_facility_arr:
		if use_location == item.location:
			var room_level_config:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
			return room_level_config.scp_data
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
	var room_details:Dictionary = ROOM_UTIL.return_data(ref)
	
	# if has before build event, trigger it
	if room_details.on_before_build_event != null:
		await GAME_UTIL.run_event(room_details.on_before_build_event)

	purchased_facility_arr.push_back({
		"ref": ref,
		# rooms are built instantly if you have this perk
		"under_construction": true,
		#"linkable": linkable,
		"location": {
			"floor": location_copy.floor,
			"ring": location_copy.ring,
			"room": location_copy.room
		}
	})
	
	SUBSCRIBE.purchased_facility_arr = purchased_facility_arr
	
	if gameplay_conditionals[CONDITIONALS.TYPE.ADMIN_PERK_3]: 
		await ROOM_UTIL.finish_construction(use_location)
	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func reset_room(use_location:Dictionary) -> void:
	
	SUBSCRIBE.purchased_facility_arr = purchased_facility_arr.filter(func(i): 
		if i.location == use_location:
			base_states.room[U.location_to_designation(use_location)] = {
				"abl_lvl": 0,
				"influence": {
					"added_range": 0,
					"allow_horizontal": false,
					"allow_vertical": false
				},
				"passives_enabled_list": [],
				"passives_enabled": {},
				"ability_on_cooldown": {},
				"events_pending": [],
				"buffs": [],
				"debuffs": [],				
			}
			SUBSCRIBE.base_states = base_states
		
		return !(i.location == use_location)
	)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func can_activate_check(ref:int) -> bool:
	var room_data:Dictionary = ROOM_UTIL.return_data(ref)
	
	# get of required staff, 
	var has_enough:bool = true
	var tally:Dictionary = {}
	for index in room_data.required_staffing.size():
		var _ref:int = room_data.required_staffing[index]
		if _ref not in tally:
			tally[_ref] = 0
		tally[_ref] += 1
	
	# ... now check and see if you have enough			
	for key in tally:
		# if required > the amount that you have...
		if tally[key] > RESEARCHER_UTIL.get_spec_available_count(key):
			has_enough = false
			break	
	
	return has_enough
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func finish_construction(use_location:Dictionary) -> void:
	var room_ref:int
	SUBSCRIBE.purchased_facility_arr = purchased_facility_arr.map(func(x):
		if x.location == use_location:
			x.under_construction = false
			room_ref = x.ref
		return x
	)	
	
	var updated_data:Dictionary = purchased_facility_arr.filter(func(x): return x.location == use_location)[0]
	var room_details:Dictionary = return_data(updated_data.ref)
	## if has build event, trigger it
	if room_details.on_build_complete_event != null:
		await GAME_UTIL.run_event(room_details.on_build_complete_event)	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func is_under_construction(use_location:Dictionary = current_location) -> bool:
	for item in purchased_facility_arr:
		if use_location == item.location:
			return item.under_construction
	return false
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func is_room_activated(use_location:Dictionary = current_location) -> bool:
	return room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].is_activated
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func is_nuke_active() -> bool:
	return room_config.base.onsite_nuke.triggered	
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func is_room_empty(use_location:Dictionary = current_location) -> bool:
	return room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].room_data.is_empty()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func is_scp_empty(use_location:Dictionary = current_location) -> bool:
	return room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].scp_data.is_empty()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func is_ring_powered(use_location:Dictionary = current_location) -> bool:
	return room_config.floor[use_location.floor].ring[use_location.ring].power_distribution.energy > 1
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
func is_floor_in_lockdown(use_location:Dictionary = current_location) -> bool:
	return room_config.floor[use_location.floor].in_lockdown
# ------------------------------------------------------------------------------			

# ------------------------------------------------------------------------------		
func room_can_contain(use_location:Dictionary = current_location) -> bool:
	var is_room_empty:bool = is_room_empty(use_location)
	if is_room_empty:
		return false
		
	return room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].room_data.details.can_contain
# ------------------------------------------------------------------------------			

# ------------------------------------------------------------------------------		
func room_can_deconstruct(use_location:Dictionary = current_location) -> bool:
	var is_room_empty:bool = is_room_empty(use_location)
	if is_room_empty:
		return false
		
	return room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].room_data.details.can_destroy
# ------------------------------------------------------------------------------			

# ------------------------------------------------------------------------------		
func get_room_lvl(use_location:Dictionary = current_location) -> int:
	var is_room_empty:bool = is_room_empty(use_location)
	if is_room_empty:
		return -1
		
	var floor_level_config:Dictionary = room_config.floor[use_location.floor]
	var ring_level_config:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring]
	var room_level_config:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
	var abl_lvl:int = room_level_config.abl_lvl + ring_level_config.abl_lvl + floor_level_config.abl_lvl
		
	return abl_lvl
# ------------------------------------------------------------------------------			

# ------------------------------------------------------------------------------		
func get_room_max_level(use_location:Dictionary = current_location) -> int:
	var is_room_empty:bool = is_room_empty(use_location)
	if is_room_empty:
		return -1
	
	var room_details:Dictionary = ROOM_UTIL.return_data_via_location(use_location)
	var max_upgrade_lvl:int = ROOM_UTIL.get_max_level(room_details.ref)
	return max_upgrade_lvl
# ------------------------------------------------------------------------------			

# ------------------------------------------------------------------------------
func get_room_metric_list(use_location:Dictionary = current_location, is_preview:bool = false) -> Dictionary:
	var is_room_empty:bool = is_room_empty(use_location)
	if is_room_empty and !is_preview:
		return {}
			
	var floor_level_config:Dictionary = room_config.floor[use_location.floor]
	var ring_level_config:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring]
	var room_level_config:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
	var room_details:Dictionary = ROOM_UTIL.return_data_via_location(use_location)
	var scp_details:Dictionary = ROOM_UTIL.return_scp_data_via_location(use_location)


	# get baseline for metrics
	var metric_list:Dictionary = {}
	for ref in [RESOURCE.METRICS.MORALE, RESOURCE.METRICS.SAFETY, RESOURCE.METRICS.READINESS]:
		var metric_data:Dictionary = RESOURCE_UTIL.return_metric(ref)
		metric_list[ref] = {
			"metric_data": metric_data,
			"amount": 0, 
			"bonus_amount": 0
		}
	
	# ...then get all metrics from room/scp
	if !is_room_empty:
		for dict in [room_details, scp_details]:
			if dict.has("metrics"):
				for ref in dict.metrics:
					var amount:int = dict.metrics[ref]
					metric_list[ref].amount += amount

	# ... finally add bonuses from room_config
	for config in [room_level_config, ring_level_config, floor_level_config]:
		for ref in config.metrics:
			var amount:int = config.metrics[ref]
			metric_list[ref].bonus_amount += amount
	
	return metric_list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_room_currency_list(use_location:Dictionary = current_location, is_preview:bool = false) -> Dictionary:
	var is_room_empty:bool = is_room_empty(use_location)
	if is_room_empty and !is_preview:
		return {}

	var floor_level_config:Dictionary = room_config.floor[use_location.floor]
	var ring_level_config:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring]
	var room_level_config:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
	var room_details:Dictionary = ROOM_UTIL.return_data_via_location(use_location)
	var scp_details:Dictionary = ROOM_UTIL.return_scp_data_via_location(use_location)
		
	# get baseline of currency list
	var currency_list:Dictionary = {}
	for ref in [RESOURCE.CURRENCY.MONEY, RESOURCE.CURRENCY.SCIENCE, RESOURCE.CURRENCY.MATERIAL, RESOURCE.CURRENCY.CORE]:
		var resource_details:Dictionary = RESOURCE_UTIL.return_currency(ref)
		currency_list[ref] = {
			"icon": resource_details.icon, 
			"amount": 0,
			"bonus_amount": 0
		}
	
	# ... then get all currency from room
	if !is_room_empty:
		for dict in [room_details, scp_details]:
			if dict.has("currencies"):
				for ref in dict.currencies:
					var amount:int = dict.currencies[ref]
					currency_list[ref].amount += amount
	
	# ... finally add bonuses from room_config
	for config in [room_level_config, ring_level_config, floor_level_config]:
		for ref in config.currencies:
			var amount:int = config.currencies[ref]		
			currency_list[ref].bonus_amount += amount
	
	return currency_list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_room_effect(use_location:Dictionary = current_location) -> Dictionary:
	var is_room_empty:bool = is_room_empty(use_location)
	if is_room_empty:
		return {}

	var room_level_config:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]	
	return room_level_config.room_data.details.effect
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
func return_room_abilities(use_location:Dictionary = current_location) -> Array:
	var is_room_empty:bool = is_room_empty(use_location)
	if is_room_empty:
		return []	
	var room_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].room_data
	return room_data.details.abilities.call()
# ------------------------------------------------------------------------------			

# ------------------------------------------------------------------------------			
func return_room_passive_abilities(use_location:Dictionary = current_location) -> Array:
	var is_room_empty:bool = is_room_empty(use_location)
	if is_room_empty:
		return []	
	var room_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].room_data
	return room_data.details.passive_abilities.call()
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
func owns(ref:int) -> bool:
	var filter:Array = purchased_facility_arr.filter(func(i):return i.ref == ref and i.location.floor == current_location.floor and i.location.ring == current_location.ring)
	return filter.size() > 0
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func owns_and_is_active(ref:int) -> bool:
	var filter:Array = purchased_facility_arr.filter(func(i):return i.ref == ref)
	if filter.size() == 0:
		return false
	return ROOM_UTIL.is_room_activated()
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
func get_all_link_catagories() -> Array:
	return purchased_facility_arr.filter(func(x): 
		return x.location.floor == current_location.floor and x.location.ring == current_location.ring
	).map(func(x): 
		var room_details:Dictionary = ROOM_UTIL.return_data(x.ref) 
		return room_details.link_categories
	).filter(func(x):
		return x != null
	)
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
func get_personnel_counts() -> Dictionary:
	var tally:Dictionary = {}
	for item in purchased_facility_arr:
		var room_details:Dictionary = return_data(item.ref) 
		for staff_ref in room_details.required_staffing:
			if staff_ref not in tally:
				tally[staff_ref] = 0
			tally[staff_ref] += 1
		
	return tally
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func get_influenced_data(use_location:Dictionary = current_location) -> Dictionary:
	var room_details:Dictionary = return_data_via_location(use_location)

	# copy it
	var currency_list:Dictionary = {}
	var metric_list:Dictionary = {}
	# get room level currency (added bonuses)
	var room_level_config:Dictionary = GAME_UTIL.get_room_level_config()
	var currencies:Dictionary = room_level_config.currencies
	var metrics:Dictionary
	
	
	## add any bonuses in the room to it
	for dict in [room_level_config]:
		for currency_ref in dict.currencies:
			var amount:int = dict.currencies[currency_ref]
			if currency_ref not in currency_list:
				currency_list[currency_ref] = 0
			currency_list[currency_ref] += amount	
			
		for metrics_ref in dict.metrics:
			var amount:int = dict.metrics[metrics_ref]
			if metrics_ref not in metric_list:
				metric_list[metrics_ref] = 0
			metric_list[metrics_ref] += amount				
			

	return {"currency_list": currency_list, "metric_list": metric_list}
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func range_one(room:int, include_vertical:bool, include_horizontal:bool) -> Array:
	var vertical_neighbors := {
		0: [1],
		1: [0, 3],
		2: [4],
		3: [1],
		4: [2, 6],
		5: [7],
		6: [4],
		7: [5, 8],
		8: [7]
	}

	var horizontal_neighbors := {
		0: [2],
		2: [0, 5],
		5: [2],
		1: [4],
		4: [1, 7],
		7: [4],
		3: [6],
		6: [3, 8],
		8: [6]
	}	
	
	var neighbors := []
	if include_vertical and vertical_neighbors.has(room):
		neighbors.append_array(vertical_neighbors[room])
	if include_horizontal and horizontal_neighbors.has(room):
		neighbors.append_array(horizontal_neighbors[room])
	return neighbors

func range_two(room:int, include_vertical:bool, include_horizontal:bool) -> Array:
	var vertical_neighbors := {
		0: [1, 3],
		1: [0, 3],
		2: [4, 6],
		3: [1, 0],
		4: [2, 6],
		5: [7, 8],
		6: [4, 2],
		7: [5, 8],
		8: [5, 7]
	}

	var horizontal_neighbors := {
		0: [2, 5],
		2: [0, 5],
		5: [0, 2],
		1: [4, 7],
		4: [1, 7],
		7: [1, 4],
		3: [6, 8],
		6: [3, 8],
		8: [3, 6]
	}	

	var neighbors := []
	if include_vertical and vertical_neighbors.has(room):
		neighbors.append_array(vertical_neighbors[room])
	if include_horizontal and horizontal_neighbors.has(room):
		neighbors.append_array(horizontal_neighbors[room])
		
	return neighbors


func find_influenced_rooms(use_location:Dictionary, influence_data:Dictionary) -> Array:	
	# requires a quick check
	var room_config_level:Dictionary = GAME_UTIL.get_room_level_config(use_location)
	if room_config_level.is_empty():
		return []
		
	var include_vertical:bool = influence_data.vertical if influence_data.has("vertical") else false
	var include_horizontal:bool = influence_data.horizontal if influence_data.has("horizontal") else false		
	var range:int = U.min_max(0 if room_config_level.influence.added_range == -1 else influence_data.starting_range + room_config_level.influence.added_range, 0, 2)
	var neighbors:Array = range_one(use_location.room, include_vertical, include_horizontal) if range == 1 else range_two(use_location.room, include_vertical, include_horizontal)
	
	return neighbors
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
