@tool
extends SubscribeWrapper

const dlc_folder:String = "res://_DLC/"

var ROOM_TEMPLATE:Dictionary = {
	# ------------------------------------------
	"ref": null,
	"categories": [],
	"link_categories": null,
	"link_back": null,
		
	"name": "FULL NAME",
	"shortname": "SHORTNAME",
	"img_src": "res://Media/images/redacted.png",
	"description": "Requires description...",
	"quote": "Quote...",
	# ------------------------------------------
	
	# ------------------------------------------	
	"department_properties": {},
	"utility_props": {},
	"influence": {},	
	# ------------------------------------------
	
	# ------------------------------------------
	"can_destroy": true,
	"can_assign_researchers": true,
	"requires_unlock": true,	
	"own_limit": 40,
	"unlock_level": 0,
	"required_staffing": [],
	"required_energy": 0,
	# ------------------------------------------	

	# ------------------------------------------
	"can_contain": false,
	"containment_properties": [],
	# ------------------------------------------
	
	# ------------------------------------------
	"events": {
		"build_complete": null,	
	},
	# ------------------------------------------

	# ------------------------------------------
	"costs": {
		"build": 1,
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
	"temp_required": [0], # include as range of acceptable temperatures
	"hazard": 0,
	"pollution": 0,
	
	# TODO REMOVE THIS AND USE PREFERED ABOVE
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
	return reference_data[ref].duplicate(true)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_data_via_location(use_location:Dictionary = current_location) -> Dictionary:
	for item in purchased_facility_arr:
		if use_location == item.location:
			var room_details:Dictionary = return_data(item.ref)
			return room_details
	return {}

func return_scp_data_via_location(use_location:Dictionary = current_location) -> Dictionary:
	var room_level_config:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
	if !room_level_config.scp_data.is_empty():
		return SCP_UTIL.return_data(room_level_config.scp_data.ref)
		
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
	var room_details:Dictionary = return_data(ref)
	var location_copy:Dictionary = use_location.duplicate(true)
	var skip_build:bool = true #gameplay_conditionals[CONDITIONALS.TYPE.LOGISTIC_PERK_1]
	
	purchased_facility_arr.push_back({
		"ref": ref,
		"under_construction": !skip_build,
		"location": {
			"floor": location_copy.floor,
			"ring": location_copy.ring,
			"room": location_copy.room
		}
	})
	
	# update array
	SUBSCRIBE.purchased_facility_arr = purchased_facility_arr
	
	# tally costs
	RESOURCE_UTIL.make_update_to_currency_amount(RESOURCE.CURRENCY.MONEY, room_details.costs.purchase)	
	
	if skip_build: 
		await ROOM_UTIL.finish_construction(use_location)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func add_random_room(use_location:Dictionary) -> void:
	var skip_build:bool = true #gameplay_conditionals[CONDITIONALS.TYPE.LOGISTIC_PERK_1]
	var utility_rooms:Dictionary = get_category(ROOM.CATEGORY.UTILITY, 0, 50)
	var refs:Array = utility_rooms.list.map(func(x): return x.ref)
	var selected_ref:int = refs[randi() % refs.size()]

	purchased_facility_arr.push_back({
		"ref": selected_ref,
		"under_construction": !skip_build,
		"location": {
			"floor": use_location.floor,
			"ring": use_location.ring,
			"room": use_location.room
		}
	})
	
	# update array
	SUBSCRIBE.purchased_facility_arr = purchased_facility_arr
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func reset_room(use_location:Dictionary) -> bool:
	var room_details:Dictionary = return_data_via_location(use_location)
	var confirm:bool = await GAME_UTIL.create_modal("Deconstruct %s?" % room_details.name, "No refunds.", room_details.img_src)
	
	if confirm:
		# remove base
		SUBSCRIBE.purchased_facility_arr = purchased_facility_arr.filter(func(i): 
			return !(i.location == use_location)
		)
		
		if room_details.has("on_activate"):
			room_details.on_activate.call(false)
		
		# reset any base state effects
		var base_state_room:Dictionary = base_states.room[U.location_to_designation(use_location)]
		base_state_room.abl_lvl = 0
		base_state_room.influence = {
				"added_range": 0,
				"allow_horizontal": false,
				"allow_vertical": false
			}
		base_state_room.passives_enabled_list = []
		base_state_room.passives_enabled = {}
		base_state_room.events_pending = []
		base_state_room.buffs = []
		SUBSCRIBE.base_states = base_states
		
	return confirm
# ------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func cancel_construction(use_location:Dictionary = current_location) -> bool:
	var room_details:Dictionary = return_data_via_location(use_location)
	var refund_val:int = floori(room_details.costs.purchase)
	var costs:Array = [{
		"amount": refund_val, 
		"resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)
	}]	
	var confirm:bool = await GAME_UTIL.create_modal("Cancel construction of %s?" % room_details.name, "Construction costs will be refunded.", room_details.img_src, costs)
	
	if confirm:	
		reset_room(use_location)

	return confirm
# --------------------------------------------------------------------------------------------------		

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
	if room_details.events.build_complete != null:
		priority_events.push_back(room_details.events.build_complete)
		SUBSCRIBE.priority_events = priority_events
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
	# this check is a bit redundant, but will sometimes stop an error
	var room_details:Dictionary = return_data_via_location(use_location)
	if room_details.is_empty():
		return true
	return room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].room_data.is_empty()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func is_scp_empty(use_location:Dictionary = current_location) -> bool:	
	return room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].scp_data.is_empty()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func is_ring_powered(use_location:Dictionary = current_location) -> bool:
	return true #room_config.floor[use_location.floor].ring[use_location.ring].power_distribution.energy > 1
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
	var room_details:Dictionary = return_data(room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].room_data.ref) 
	return room_details.can_contain
# ------------------------------------------------------------------------------			

# ------------------------------------------------------------------------------		
func room_can_deconstruct(use_location:Dictionary = current_location) -> bool:
	var is_room_empty:bool = is_room_empty(use_location)
	if is_room_empty:
		return false
	var room_details:Dictionary = return_data(room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].room_data.ref) 		
	return room_details.can_destroy
# ------------------------------------------------------------------------------			

# ------------------------------------------------------------------------------		
func get_room_lvl(use_location:Dictionary = current_location) -> int:
	var is_room_empty:bool = is_room_empty(use_location)
	var room_level_config:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
	
	if is_room_empty or room_level_config.department_properties.is_empty():
		return -1

	return room_level_config.department_properties.level
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
func get_room_currency_list(room_ref:int, use_location:Dictionary = current_location, is_preview:bool = false) -> Dictionary:
	var is_room_empty:bool = is_room_empty(use_location)

	var floor_level_config:Dictionary = room_config.floor[use_location.floor]
	var ring_level_config:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring]
	var room_level_config:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
	var room_details:Dictionary = ROOM_UTIL.return_data(room_ref) if is_preview else ROOM_UTIL.return_data_via_location(use_location) 
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
	for dict in [room_details, scp_details]:
		if dict.has("currencies"):
			for ref in dict.currencies:
				var amount:int = dict.currencies[ref]
				currency_list[ref].amount += amount
	
	# ... finally add bonuses from room_config
	#for config in [room_level_config, ring_level_config, floor_level_config]:
		#for ref in config.currencies:
			#var amount:int = config.currencies[ref]		
			#currency_list[ref].bonus_amount += amount
	
	return currency_list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_room_effect(use_location:Dictionary = current_location) -> Dictionary:
	var is_room_empty:bool = is_room_empty(use_location)
	if is_room_empty:
		return {}

	var room_details:Dictionary = return_data( room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].room_data.ref ) 		
	return room_details.effect
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
func return_room_abilities(use_location:Dictionary = current_location) -> Array:
	var is_room_empty:bool = is_room_empty(use_location)
	if is_room_empty:
		return []	
	var room_details:Dictionary = return_data( room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].room_data.ref ) 		
	return room_details.abilities.call()
# ------------------------------------------------------------------------------			

# ------------------------------------------------------------------------------			
func return_room_passive_abilities(use_location:Dictionary = current_location) -> Array:
	var is_room_empty:bool = is_room_empty(use_location)
	if is_room_empty:
		return []	
	var room_details:Dictionary = return_data( room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].room_data.ref ) 		
	return room_details.passive_abilities.call()
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
func department_count(use_location:Dictionary = current_location) -> int:	
	var department_refs:Array = get_department_refs()
	var filter:Array = purchased_facility_arr.filter(func(i):return i.ref in department_refs and i.location.floor == current_location.floor and i.location.ring == current_location.ring)
	return filter.size()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func room_count_per_ring(ref:int, use_location:Dictionary = current_location) -> int:
	var filter:Array = purchased_facility_arr.filter(func(i):return i.ref == ref and i.location.floor == current_location.floor and i.location.ring == current_location.ring)
	return filter.size()
# ------------------------------------------------------------------------------		
	
# ------------------------------------------------------------------------------
func build_count(ref:int) -> int:
	var filter:Array = purchased_facility_arr.filter(func(i):return i.ref == ref)
	return filter.size()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func ring_contains(ref:int, use_location:Dictionary = current_location) -> bool:
	var filter:Array = purchased_facility_arr.filter(func(i):return i.ref == ref and i.location.floor == use_location.floor and i.location.ring == use_location.ring)
	return filter.size() > 0
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	
func ring_contains_count(ref:int, use_location:Dictionary = current_location) -> int:
	var filter:Array = purchased_facility_arr.filter(func(i):return i.ref == ref and i.location.floor == use_location.floor and i.location.ring == use_location.ring)
	return filter.size()
# ------------------------------------------------------------------------------		
	
# ------------------------------------------------------------------------------
func owns(ref:int, use_location:Dictionary = current_location) -> bool:
	var filter:Array = purchased_facility_arr.filter(func(i):return i.ref == ref and i.location.floor == use_location.floor and i.location.ring == use_location.ring)
	return filter.size() > 0
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func owns_and_is_active(ref:int) -> bool:
	var filter:Array = purchased_facility_arr.filter(func(i):return i.ref == ref)
	if filter.size() == 0:
		return false
		
	return ROOM_UTIL.is_room_activated( filter[0].location )
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
func get_departments(use_location:Dictionary = current_location) -> Array:
	var department_refs:Array = get_department_refs()
	var filtered:Array = purchased_facility_arr.filter(func(x): 
		return x.location.floor == use_location.floor and x.location.ring == use_location.ring and x.ref in department_refs
	)

	return filtered	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_all_room_catagories() -> Array:
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
func has_negative_energy() -> bool:
	var energy_check_pass:bool = false
	# FLOOR LEVEL ------------- 
	for floor_index in room_config.floor.size():
		# RING LEVEL ------------- 
		for ring_index in room_config.floor[floor_index].ring.size():
			var ring_level_config:Dictionary = room_config.floor[floor_index].ring[ring_index]
			# setup initial energy
			if ring_level_config.energy.used > ring_level_config.energy.available:
				return true

	return energy_check_pass
# ------------------------------------------------------------------------------	


# ------------------------------------------------------------------------------	
func check_end_of_turn_event() -> void:
	for item in purchased_facility_arr:
		var room_config_data:Dictionary = room_config.floor[item.location.floor].ring[item.location.ring].room[item.location.room]	
		var is_activated:bool = room_config_data.is_activated
		var department_properties:Dictionary = room_config_data.department_properties
		if department_properties.has("effects"):
			for ref in department_properties.effects:
				var effect:Dictionary = ROOM.return_effect(ref)
				# call effect
				if effect.has("end_of_turn"):
					effect.end_of_turn.call(item.location)	
	
	SUBSCRIBE.purchased_facility_arr = purchased_facility_arr
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
	var room_level_config:Dictionary = GAME_UTIL.get_room_level_config(use_location)
	var range_is_two:bool = GAME_UTIL.is_conditional_active(CONDITIONALS.TYPE.INFLUENCE_RANGE_IS_TWO)
	if room_level_config.is_empty() or influence_data.is_empty():
		return []
		
	var include_vertical:bool = true #influence_data.vertical if influence_data.has("vertical") else false
	var include_horizontal:bool = true #influence_data.horizontal if influence_data.has("horizontal") else false			
	var neighbors:Array = range_one(use_location.room, include_vertical, include_horizontal) if !range_is_two else range_two(use_location.room, include_vertical, include_horizontal)
	
	return neighbors

func find_all_influenced_rooms(convert_to_index:bool = false) -> Dictionary:
	var all_influenced_rooms:Dictionary

	for room in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
		var use_location:Dictionary = {"floor": current_location.floor, "ring": current_location.ring, "room": room}
		var room_details:Dictionary = ROOM_UTIL.return_data_via_location(use_location)
		var scp_details:Dictionary = ROOM_UTIL.return_scp_data_via_location(use_location)

		# add influence from room details
		if !room_details.is_empty():
			if !room_details.influence.is_empty():
				# now add self
				#var center_room:int = index_to_room_lookup(use_location.room) if convert_to_index else use_location.room
				#if center_room not in all_influenced_rooms:
					#all_influenced_rooms[center_room] = []
				#all_influenced_rooms[center_room].push_back({"room_ref": room_details.ref})
				# add adjacent rooms
				for room_id in ROOM_UTIL.find_influenced_rooms( use_location, room_details.influence ):
					var actual_ref:int = index_to_room_lookup(room_id) if convert_to_index else room_id
					if room_id not in all_influenced_rooms:
						all_influenced_rooms[room_id] = []
					all_influenced_rooms[room_id].push_back({"room_ref": room_details.ref})

		# add influnence from scp details
		if !scp_details.is_empty():
			if !scp_details.influence.is_empty():
				# now add self
				#var center_room:int = index_to_room_lookup(use_location.room) if convert_to_index else use_location.room
				#if center_room not in all_influenced_rooms:
					#all_influenced_rooms[center_room] = []
				#all_influenced_rooms[center_room].push_back({"scp_ref": scp_details.ref})
								
				for room_id in ROOM_UTIL.find_influenced_rooms( use_location, scp_details.influence ):
					var actual_ref:int = index_to_room_lookup(room_id) if convert_to_index else room_id
					if room_id not in all_influenced_rooms:
						all_influenced_rooms[room_id] = []
					all_influenced_rooms[room_id].push_back({"scp_ref": scp_details.ref})
						
	return all_influenced_rooms
	
func find_refs_of_adjuacent_rooms(use_location:Dictionary, use_room_config:Dictionary = room_config) -> Array: 
	var room_level_config:Dictionary = use_room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
	var range_is_two:bool = GAME_UTIL.is_conditional_active(CONDITIONALS.TYPE.INFLUENCE_RANGE_IS_TWO)
	var adjacent_rooms:Array = range_one(use_location.room, true, true) if !range_is_two else range_two(use_location.room, true, true)
	
	var refs:Array = []
	for room in adjacent_rooms:
		var room_details:Dictionary = return_data_via_location({"floor": use_location.floor, "ring": use_location.ring, "room": room})
		if !room_details.is_empty():
			refs.push_back(room_details.ref)
	return refs

func find_linkables_categories_of_adjuacent_rooms(use_location:Dictionary) -> Array: 
	var room_level_config:Dictionary = GAME_UTIL.get_room_level_config(use_location)
	var range_is_two:bool = GAME_UTIL.is_conditional_active(CONDITIONALS.TYPE.INFLUENCE_RANGE_IS_TWO)	
	var adjacent_rooms:Array = range_one(use_location.room, true, true) if !range_is_two else range_two(use_location.room, true, true)
	

	var link_categories:Array = []
	for room in adjacent_rooms:
		var room_details:Dictionary = return_data_via_location({"floor": use_location.floor, "ring": use_location.ring, "room": room})
		if !room_details.is_empty() and room_details.link_categories != null:
			link_categories.push_back(room_details.link_categories)
	return link_categories

func get_department_refs() -> Array:
	return [
		ROOM.REF.CONTAINMENT_CELL,
		
		ROOM.REF.DEBUG_DEPARTMENT,
		ROOM.REF.PROCUREMENT_DEPARTMENT,
		ROOM.REF.ENGINEERING_DEPARTMENT,
		ROOM.REF.LOGISTICS_DEPARTMENT, 
		ROOM.REF.SCIENCE_DEPARTMENT,
		
		ROOM.REF.ADMIN_DEPARTMENT, 
		ROOM.REF.SECURITY_DEPARTMENT,
		ROOM.REF.TEMPORAL_DEPARTMENT,
		
		ROOM.REF.ANTIMEMETICS_DEPARTMENT,
		ROOM.REF.PATAPHYSICS_DEPARTMENT,
		ROOM.REF.THEOLOGY_DEPARTMENT,
		ROOM.REF.MISCOMMUNICATION_DEPARTMENT,
	]
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func index_to_room_lookup(val:int) -> int:
	match val:
		0: return 2
		1: return 1
		2: return 5
		4: return 4
		5: return 8
		6: return 3
		7: return 7
		8: return 6
	return 0
	
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

# ------------------------------------------------------------------------------	
# Mapping of room IDs to grid coordinates
const ROOM_MAP = {
	0: Vector2(0,0),
	2: Vector2(0,1),
	5: Vector2(0,2),
	1: Vector2(1,0),
	4: Vector2(1,1),
	7: Vector2(1,2),
	3: Vector2(2,0),
	6: Vector2(2,1),
	8: Vector2(2,2),
}

# Check if start_id is connected to all target_ids
# grid: 2D array with true = room exists, false = empty
func are_rooms_connected(grid: Array, start_id: int, target_ids: Array) -> bool:
	if not ROOM_MAP.has(start_id):
		return false
	var start = ROOM_MAP[start_id]

	# Quick check: if start isn't actually a room
	if not grid[start.x][start.y]:
		return false

	# BFS
	var visited = {}
	var queue = [start]

	while queue.size() > 0:
		var current = queue.pop_front()
		if visited.has(current):
			continue
		visited[current] = true

		# Explore orthogonal neighbors
		var dirs = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]
		for d in dirs:
			var nr = current.x + d.x
			var nc = current.y + d.y
			if nr >= 0 and nr < grid.size() and nc >= 0 and nc < grid[0].size():
				if grid[nr][nc] and not visited.has(Vector2(nr, nc)):
					queue.append(Vector2(nr, nc))

	# Check that all target IDs were reached
	for tid in target_ids:
		if not ROOM_MAP.has(tid):
			return false
		var coord = ROOM_MAP[tid]
		if not visited.has(coord):
			return false

	return true
# ------------------------------------------------------------------------------	
