extends SubscribeWrapper

var GameplayNode:Control
var ConfirmModal:Control
var BuildContainer:Control
var Structure3dContainer:Control
var SCPSelectScreen:Control
var SelectResearcherScreen:Control
var ToastContainer:Control

# -----------------------------------
func find_in_contained(ref:int) -> Dictionary:
	var index:int = -1
	var res_data:Dictionary = {} 

	for ind in scp_data.contained_list.size():
		var data:Dictionary = scp_data.contained_list[ind]
		if data.ref == ref:
			index = ind
			res_data = data
			break	
	
	return {
		"index": index,
		"data": res_data
	}
# -----------------------------------	

# -----------------------------------
func find_in_available(ref:int) -> Dictionary:
	var index:int = -1
	var res_data:Dictionary = {} 

	for ind in scp_data.available_list.size():
		var data:Dictionary = scp_data.available_list[ind]
		if data.ref == ref:
			index = ind
			res_data = data
			break	
	
	return {
		"index": index,
		"data": res_data
	}
# -----------------------------------	

# ------------------------------------------------------------------------------
func assign_nodes() -> void:	
	GameplayNode = GBL.find_node(REFS.GAMEPLAY_LOOP)
	ConfirmModal = GameplayNode.ConfirmModal
	Structure3dContainer = GameplayNode.Structure3dContainer
	SCPSelectScreen = GameplayNode.SCPSelectScreen
	ToastContainer = GameplayNode.ToastContainer
	SelectResearcherScreen = GameplayNode.SelectResearcherScreen
	BuildContainer = GameplayNode.BuildContainer
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_ability_level(use_location:Dictionary = current_location) -> int:
	var floor:int = use_location.floor
	var ring:int = use_location.ring	
	var room:int = use_location.room
	var wing_abl_lvl:int = 	room_config.floor[floor].ring[ring].abl_lvl
	var room_abl_lvl:int = room_config.floor[floor].ring[ring].room[room].abl_lvl
	return wing_abl_lvl + room_abl_lvl
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_room_traits(use_location:Dictionary, use_config:Dictionary = room_config) -> Dictionary:
	var designation:String = U.location_to_designation(use_location)	
	var floor:int = use_location.floor
	var ring:int = use_location.ring
	var room:int = use_location.room
	var config_data:Dictionary = use_config.floor[floor].ring[ring].room[room]
	var room_data:Dictionary = config_data.room_data
	var scp_data:Dictionary = config_data.scp_data 

	var total_traits_list := []
	var synergy_traits := []
	var dup_list := []		
	var trait_list := []
	var synergy_list := []

	
	var researchers:Array = hired_lead_researchers_arr.filter(func(x):
		var details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(x[0])
		if (!details.props.assigned_to_room.is_empty() and U.location_to_designation(details.props.assigned_to_room) == designation):
			return true
		return false	
	).map(func(x):return RESEARCHER_UTIL.return_data_with_uid(x[0]))
		
	# records bonus from traits
	for researcher in researchers:
		total_traits_list.push_back(researcher.traits)
	
	# records bonus from traits
	for traits in total_traits_list:
		for t in traits:
			if t not in dup_list:
				trait_list.push_back(RESEARCHER_UTIL.return_trait_details(t, use_location, use_config))
				
	# records bonus from synergy traits
	if total_traits_list.size() == 2:
		var list:Array = RESEARCHER_UTIL.return_trait_synergy(total_traits_list[0], total_traits_list[1])
		#for details in list:
			#var effect:Dictionary = details.get_effect.call({"room_details": room_details, "scp_details": scp_details, "resource_details": resource_details})
			#var resource_list:Array = []
			#var metric_list:Array = []
			## -------------------
			#if "resource" in effect:
				#for key in effect.resource:
					#var amount:int = effect.resource[key]
					#
					#if key not in resource_details.synergy_traits:
						#resource_details.synergy_traits[key] = 0
					#if key not in resource_details.total:
						#resource_details.total[key] = 0
					#resource_details.synergy_traits[key] += amount
					#resource_details.total[key] += amount
					#
					#resource_list.push_back({"resource": RESOURCE_UTIL.return_currency(key), "amount": amount})
			## -------------------
			#if "metrics" in effect:
				#for key in effect.metrics:
					#var amount:int = effect.metrics[key]
#
					#if key not in metric_details.traits:
						#metric_details.traits[key] = 0
					#if key not in metric_details.total:
						#metric_details.total[key] = 0
					#metric_details.traits[key] += amount
					#metric_details.total[key] += amount					
					#
					#metric_list.push_back({"resource": RESOURCE_UTIL.return_metric(key), "amount": amount})		
						#
			#synergy_trait_list.push_back({"details": details, "effect": {"resource_list": resource_list, "metric_list": metric_list}} )
				
	return {
		"trait_list": trait_list,
		"synergy_list": synergy_list
	}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func extract_wing_details(use_location:Dictionary = current_location) -> Dictionary:	
	var floor:int = use_location.floor
	var ring:int = use_location.ring
	var room:int = use_location.room
	
	var wing_data:Dictionary = room_config.floor[floor].ring[ring]
	var room_refs:Array = wing_data.room_refs
	var abilities:Dictionary = {}
	var passive_abilities:Dictionary = {}

	for room_index in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
		var room_config_data:Dictionary = room_config.floor[floor].ring[ring].room[room_index]
		var designation:String = U.location_to_designation({"floor": floor, "ring": ring, "room": room_index})

		if !room_config_data.room_data.is_empty():
			if room_config_data.is_activated:
				var room_details:Dictionary = room_config_data.room_data.details
				
				abilities[designation] = []
				passive_abilities[designation] = []
				
				if "abilities" in room_details:
					var ability_list:Array = room_details.abilities.call()
			
					for index in ability_list.size():
						#if index <= ring_ability_level:
						abilities[designation].push_back({
							"room_ref": room_details.ref,
							"room_index": room_index,
							"index": index, 
							"lvl_required": ability_list[index].lvl_required, 
							"details": ability_list[index]
						})
				
				if "passive_abilities" in room_details:
					var ability_list:Array = room_details.passive_abilities.call()
					for index in ability_list.size():
						#if index <= ring_ability_level:
						passive_abilities[designation].push_back({
							"room_ref": room_details.ref,
							"room_index": room_index,
							"index": index, 
							"lvl_required": ability_list[index].lvl_required, 
							"details": ability_list[index]
						})

	return {
		"room_refs": wing_data.room_refs,
		"abilities": abilities,
		"passive_abilities": passive_abilities
	}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func extract_room_details(use_location:Dictionary = current_location, use_config:Dictionary = room_config) -> Dictionary:
	if use_config.is_empty():return {}
	
	var designation:String = U.location_to_designation(use_location)
	var floor:int = use_location.floor
	var ring:int = use_location.ring
	var room:int = use_location.room

	var floor_data:Dictionary = room_config.floor[floor]
	var wing_data:Dictionary = room_config.floor[floor].ring[ring]
	var room_config_data:Dictionary = room_config.floor[floor].ring[ring].room[room]
	var is_room_empty:bool = room_config_data.room_data.is_empty()
	var can_purchase:bool = room_config_data.build_data.is_empty() and room_config_data.room_data.is_empty()
	var is_room_under_construction:bool  = !room_config_data.build_data.is_empty()
	var room_details:Dictionary = {} if is_room_empty else room_config_data.room_data.details 
	
	var is_activated:bool = false if is_room_empty else room_config_data.is_activated 
	var can_activate:bool = false if is_room_empty else (RESOURCE_UTIL.check_if_have_enough(ROOM_UTIL.return_activation_cost(room_config_data.room_data.ref)) if !is_activated else false)
	var can_contain:bool = false if is_room_empty else room_details.can_contain
	var can_destroy:bool = false if is_room_empty else room_details.can_destroy
	var ap_diff_amount:int = 1 if is_activated else 0
	var abilities:Array = [] if (is_room_empty or "abilities" not in room_details) else room_details.abilities.call()	
	
	var room_base_state:Dictionary = base_states.room[str(current_location.floor, current_location.ring, current_location.room)]
	var passives_enabled:Dictionary = room_base_state.passives_enabled	
	var passive_abl:Array = [] if (is_room_empty or "passive_abilities" not in room_details) else room_details.passive_abilities.call()	
	var passive_abilities:Array = []
	for index in passive_abl.size():
		var pa:Dictionary = passive_abl[index]
		var auid:String = str(room_details.ref, index)
		pa.index = index
		pa.is_enabled = passives_enabled[auid] if auid in passives_enabled else false
		passive_abilities.push_back(pa)
	
	var scp_data:Dictionary = room_config_data.scp_data 
	var is_scp_empty:bool = scp_data.is_empty()
	var scp_details:Dictionary = {} if is_scp_empty else SCP_UTIL.return_data(scp_data.ref)
	var is_transfer:bool = false #if is_scp_empty else room_config_data.scp_data.is_transfer
	var is_contained:bool = false #if is_scp_empty else room_config_data.scp_data.is_contained
	
	
	var researchers:Array = hired_lead_researchers_arr.filter(func(x):
		var details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(x[0])
		if (!details.props.assigned_to_room.is_empty() and U.location_to_designation(details.props.assigned_to_room) == designation):
			return true
		return false	
	).map(func(x):return RESEARCHER_UTIL.return_data_with_uid(x[0]))
	
	var traits_res:Dictionary = get_room_traits(use_location, use_config)
	var trait_list:Array = traits_res.trait_list
	var synergy_list:Array = traits_res.synergy_list
	
	# tracks 
	var resource_details:Dictionary = {
		# captures just for room
		"room": {},
		# all resources for scp
		"scp": {},
		# 
		"researchers": {},
		# combines room, scp and researchers 
		"facility": {},
		#
		"traits": {},
		"synergy_traits": {},
		"total": {},
	}
	var metric_details:Dictionary = {
		# captures just for room
		"room": {},
		# all resources for scp
		"scp": {},
		# 
		"researchers": {},
		# combines room, scp and researchers 
		"facility": {},
		#
		"traits": {},
		"synergy_traits": {},
		"total": {},
	}
	
	# get resources spent/added by rooms
	if !is_room_empty:
		for item in ROOM_UTIL.return_operating_cost(room_details.ref):
			if item.resource.ref not in resource_details.room:
				resource_details.room[item.resource.ref] = 0
			if item.resource.ref not in resource_details.facility:
				resource_details.facility[item.resource.ref] = 0
			if item.resource.ref not in resource_details.total:
				resource_details.total[item.resource.ref] = 0
			resource_details.room[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
			resource_details.facility[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
			resource_details.total[item.resource.ref] += item.amount if is_activated and !is_room_under_construction else 0
				
	# get resources spent/added by scp
	if !is_scp_empty:
		for item in SCP_UTIL.return_ongoing_containment_rewards(scp_details.ref):
			if item.resource.ref not in resource_details.scp:
				resource_details.scp[item.resource.ref] = 0
			if item.resource.ref not in resource_details.facility:
				resource_details.facility[item.resource.ref] = 0
			if item.resource.ref not in resource_details.total:
				resource_details.total[item.resource.ref] = 0
				
			resource_details.facility[item.resource.ref] += item.amount if is_contained else 0
			resource_details.scp[item.resource.ref] += item.amount if is_contained else 0
			resource_details.total[item.resource.ref] += item.amount if is_contained else 0

	# convert resource as a dict to a list form for easy reading
	var resources_as_list:Array = []
	for key in resource_details.total:
		var amount:int = resource_details.total[key]
		resources_as_list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_currency(key)})

	return {
		"floor_config_data": floor_data,
		"wing_config_data": wing_data,
		"room_config_data": room_config_data,
		# -----
		"is_directors_office": room_details.ref == ROOM.TYPE.DIRECTORS_OFFICE if !room_details.is_empty() else false,
		"is_hq": room_details.ref == ROOM.TYPE.HQ if !room_details.is_empty() else false,
		"is_room_empty": room_details.is_empty(),
		"is_room_under_construction": is_room_under_construction,
		"is_activated": is_activated,
		"can_activate": can_activate,
		"can_contain": can_contain,
		"can_destroy": can_destroy,
		"room_category": ROOM.CATEGORY.CONTAINMENT_CELL if (!room_details.is_empty() and room_details.can_contain) else ROOM.CATEGORY.FACILITY,
		# ------		
		"is_scp_empty": is_scp_empty,
		#"is_scp_transfering": is_transfer,
		#"is_scp_contained": is_contained,
		#"is_scp_testing": !is_transfer and is_contained and researchers.size() > 0,
		# ------
		"researchers_count": researchers.size(),
		# -----
		"room": {						
			"details": room_details if !is_room_under_construction else ROOM_UTIL.return_data(room_config_data.build_data.ref),
			"abilities": abilities,
			"passive_abilities": passive_abilities,
		} if !is_room_empty or is_room_under_construction else {},
		"scp": {
			"details": scp_details,
			#"is_transfer": is_transfer,
			#"is_contained": is_contained,
		} if !is_scp_empty else {},
		"trait_list": trait_list,
		"synergy_list": synergy_list,
		"resources_as_list": resources_as_list,
		"resource_details": resource_details,
		"metric_details": metric_details,
		"researchers": researchers
	}
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func does_passive_ability_exists_in_ring(ability:Dictionary, use_location:Dictionary = current_location) -> bool:
	var extract_data:Dictionary = extract_wing_details(use_location)
	for key in extract_data.passive_abilities:
		for item in extract_data.passive_abilities[key]:
			if ability.name == item.details.name:
				return true
				break
	return false
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func does_ability_exists_in_ring(ability:Dictionary, use_location:Dictionary = current_location) -> bool:
	var extract_data:Dictionary = extract_wing_details(use_location)
	for key in extract_data.abilities:
		for item in extract_data.abilities[key]:
			if ability.name == item.details.name:
				return true
				break
	return false
# ------------------------------------------------------------------------------	

## ------------------------------------------------------------------------------
func get_passive_ability_state(room_ref:int, ability_index:int, use_location:Dictionary = current_location) -> bool:
	var designation:String = U.location_to_designation(use_location)
	var passives_enabled:Dictionary = base_states.room[designation].passives_enabled
	var ability_uid:String = str(room_ref, ability_index)

	return passives_enabled[ability_uid] if (ability_uid in passives_enabled) else false
## ------------------------------------------------------------------------------	

## ------------------------------------------------------------------------------
func get_ability_cooldown(ability:Dictionary, use_location:Dictionary = current_location) -> int:
	var designation:String = U.location_to_designation(use_location)
	var ability_uid:String = str(use_location.floor, use_location.ring, use_location.room, ability.ref)	
	var cooldown_duration:int = 0
	
	if ability_uid in base_states.room[designation].ability_on_cooldown:
		cooldown_duration = base_states.room[designation].ability_on_cooldown[ability_uid]	

	return cooldown_duration
## ------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func use_active_ability(ability:Dictionary, use_location:Dictionary = current_location) -> void:
	var designation:String = U.location_to_designation(use_location)
	var ability_uid:String = str(use_location.floor, use_location.ring, use_location.room, ability.ref)
	var apply_cooldown:bool = await ability.effect.call()
	
	if ability_uid not in base_states.room[designation].ability_on_cooldown:
		base_states.room[designation].ability_on_cooldown[ability_uid] = 0
			
	if apply_cooldown:
		base_states.room[designation].ability_on_cooldown[ability_uid] = ability.cooldown_duration
		resources_data[RESOURCE.CURRENCY.SCIENCE].amount -= ability.science_cost
		SUBSCRIBE.resources_data = resources_data
		
	SUBSCRIBE.base_states = base_states
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func toggle_passive_ability(room_ref:int, ability_index:int, use_location:Dictionary = current_location) -> void:
	var designation:String = U.location_to_designation(use_location)
	var ability_uid:String = str(room_ref, ability_index)

	if ability_uid not in base_states.room[designation].passives_enabled:
		base_states.room[designation].passives_enabled[ability_uid] = false
	
	base_states.room[designation].passives_enabled[ability_uid] = !base_states.room[designation].passives_enabled[ability_uid]
	
	#print(base_states.room[designation].passives_enabled)

	SUBSCRIBE.base_states = base_states
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		

#func recruit_new_personel(type:RESOURCE.TYPE, amount:int) -> bool:
	#var dict:Dictionary = RESOURCE_UTIL.return_currency(type)
	#
	#ConfirmModal.set_props("Hire %s %s?" % [amount, dict.name], "%s" % ["Overcrowding will occur." if amount > resources_data[type].amount else ""])
	#await GameplayNode.show_only([Structure3dContainer, ConfirmModal])
	#
	#var confirm:bool = await ConfirmModal.user_response
	#if confirm:
		#resources_data[type].amount += amount
		#SUBSCRIBE.resources_data = resources_data
		#ToastContainer.add("Hired %s %s!" % [amount, dict.name])
	#
	#GameplayNode.restore_showing_state()
	#return confirm
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reset_room() -> bool:
	var room_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].room
	var unavailable_rooms:Array = []
	for room_index in room_config_data.size():
		var designation:String = str(current_location.floor, current_location.ring, room_index)
		if room_config_data[room_index].room_data.is_empty() or !room_config_data[room_index].scp_data.is_empty():
			unavailable_rooms.push_back(designation)
	SUBSCRIBE.unavailable_rooms = unavailable_rooms

	ConfirmModal.allow_controls = true
	ConfirmModal.set_props("Reset room?", "Room will be destroyed, researchers will be unassigned.")
	await GameplayNode.show_only([Structure3dContainer, ConfirmModal])
	var confirm:bool = await ConfirmModal.user_response
	SUBSCRIBE.unavailable_rooms = []
	
	if confirm:	
		var floor_index:int = current_location.floor
		var ring_index:int = current_location.ring
		var room_index:int = current_location.room
		var reset_arr:Array = purchased_facility_arr.filter(func(i): return (i.location.floor == floor_index and i.location.ring == ring_index and i.location.room == room_index))
		
		GameplayNode.restore_player_hud()
		# ---------------------
		if reset_arr.size() > 0:
			var reset_item:Dictionary = reset_arr[0]
			SUBSCRIBE.purchased_facility_arr = purchased_facility_arr.filter(func(i): return !(i.location.floor == floor_index and i.location.ring == ring_index and i.location.room == room_index))
			SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(reset_item.ref, true)
			return true
		else:
			return false
		
	# ---------------------
	GameplayNode.restore_player_hud()
	return confirm	
# --------------------------------------------------------------------------------------------------		

# -----------------------------------
func open_objectives() -> void:
	GameplayNode.current_objective_state = GameplayNode.OBJECTIVES_STATE.SHOW
	await GameplayNode.on_objective_signal
# -----------------------------------

# ------------------------------------------------------------------------------	
func construct_room(allow_placement:bool = true) -> void:	
	BuildContainer.allow_placement = allow_placement
	GameplayNode.current_builder_step = GameplayNode.BUILDER_STEPS.OPEN
	await GameplayNode.on_store_purchase_complete	
# ---------------------

# --------------------------------------------------------------------------------------------------	
func contain_scp() -> bool:
	var res:Dictionary = await get_new_scp()
	
	if res.is_empty:
		ConfirmModal.confirm_only = true
		ConfirmModal.set_props("There are no items available for containment.")
		await GameplayNode.show_only([ConfirmModal, Structure3dContainer])	
		await ConfirmModal.user_response
		GameplayNode.restore_player_hud()
		return false
	
	if !res.made_selection:
		GameplayNode.restore_player_hud()
		return false

	var scp_ref:int = res.selected_scp
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	var breach_events_at:Array = []
	var use_location:Dictionary = current_location.duplicate(true)
	
	for index in scp_details.breach_events_at.size():
		var val:int = scp_details.breach_events_at[index]
		var day:int = val + progress_data.day
		breach_events_at.push_back(day)
		add_timeline_item({
			"title": scp_details.name,
			"icon": SVGS.TYPE.WARNING,
			"description": "WARNING",
			"day": day - 2,
			"location": current_location.duplicate(true),
			"event": {
				"scp_ref": scp_ref,
				"event_ref": SCP.EVENT_TYPE.WARNING,
				"use_location": use_location,
				"event_count": index,
			}
		})
		
		add_timeline_item({
			"title": scp_details.name,
			"icon": SVGS.TYPE.DANGER,
			"description": "DANGER",
			"day": day,
			"location": use_location,
			"event": {
				"scp_ref": scp_ref,
				"event_ref": SCP.EVENT_TYPE.BREACH_EVENT,
				"use_location": use_location,
				"event_count": index,
			}
		})		

	# then add to contained list...
	scp_data.contained_list.push_back({ 
		"ref": scp_ref,
		"location": use_location,
		"contained_on": progress_data.day,
	})
	
	# update 
	SUBSCRIBE.scp_data = scp_data
	
	# play event
	await GameplayNode.check_events(scp_ref, SCP.EVENT_TYPE.AFTER_CONTAINMENT, {"event_count": 0, "use_location": use_location}) 
	
	# return true
	return true
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func assign_researcher(location_data:Dictionary = current_location) -> bool:
	GameplayNode.current_researcher_step = GameplayNode.RESEARCHERS_STEPS.ASSIGN
	var response:Dictionary = await GameplayNode.on_researcher_component_complete
	if response.action == ACTION.RESEARCHERS.BACK:
		GameplayNode.restore_player_hud()
		return false
	
	var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(response.uids[0])

	#ConfirmModal.allow_controls = true
	#ConfirmModal.set_props("Assign researcher to a room.", "", researcher_details.img_src)
	#await GameplayNode.show_only([Structure3dContainer, ConfirmModal])
	#var confirm:bool = await ConfirmModal.user_response
	#
	#if confirm:
		# add new researchers
	hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
		# clear out prior researchers
		if U.dictionaries_equal(i[9].assigned_to_room, location_data):
			i[9].assigned_to_room = {}
		# add current users
		if i[0] in response.uids:
			i[9].assigned_to_room = location_data.duplicate()
		return i
	)
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
			
	GameplayNode.restore_player_hud()
	return true
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func unassign_researcher(researcher_data:Dictionary) -> bool:
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
		if i[0] == researcher_data.uid:
			i[9].assigned_to_room = {}
		return i
	)
	return true
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func dismiss_researcher(researcher_data:Dictionary) -> bool:
	# first, remove from any projects
	hired_lead_researchers_arr = hired_lead_researchers_arr.filter(func(i):
		return i[0] != researcher_data.uid	
	)
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
	SUBSCRIBE.scp_data = scp_data
	return true
# --------------------------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func set_floor_lockdown(state:bool, use_location:Dictionary = current_location) -> bool:
	var title:String
	var subtitle:String

	title = "Lockdown floor %s?" % [current_location.floor] if state else "Remove lockdown."
	subtitle = "All wings will have their actions frozen." if state else ""
			
	ConfirmModal.set_props(title, subtitle)
	await GameplayNode.show_only([ConfirmModal, Structure3dContainer])	
	var confirm:bool = await ConfirmModal.user_response

	if confirm:
		room_config.floor[use_location.floor].in_lockdown = state
		SUBSCRIBE.room_config = room_config

	GameplayNode.restore_showing_state()	
	return confirm
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func activate_floor(use_location:Dictionary = current_location) -> bool:
	SUBSCRIBE.suppress_click = true

	var activated_count:int = 0
	for floor_index in room_config.floor.size():
		if room_config.floor[floor_index].is_powered:
			activated_count += 1
	var activation_cost:int = activated_count * 50
	var can_purchase:bool = resources_data[RESOURCE.CURRENCY.MONEY].amount >= activation_cost
	
	ConfirmModal.activation_requirements = [{"amount": activation_cost, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]
	ConfirmModal.set_props("Activate this floor?")
	await GameplayNode.show_only([ConfirmModal, Structure3dContainer])	
	var confirm:bool = await ConfirmModal.user_response
	
	if confirm:
		resources_data[RESOURCE.CURRENCY.MONEY].amount -= activation_cost
		room_config.floor[use_location.floor].is_powered = true
		SUBSCRIBE.room_config = room_config
		SUBSCRIBE.resources_data = resources_data
			
	GameplayNode.restore_showing_state()	
	return confirm
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func upgrade_generator_level(use_location:Dictionary = current_location) -> bool:
	var title:String
	var subtitle:String

	var activation_cost:int = 25
	var can_purchase:bool = resources_data[RESOURCE.CURRENCY.MONEY].amount >= activation_cost

	title = "Upgrade generator?"
	subtitle = "X energy will be available per ring."
	
	ConfirmModal.activation_requirements = [{"amount": activation_cost, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]
	ConfirmModal.set_props(title, subtitle)
	await GameplayNode.show_only([GameplayNode.ConfirmModal, GameplayNode.Structure3dContainer])	
	var confirm:bool = await ConfirmModal.user_response

	if confirm:
		resources_data[RESOURCE.CURRENCY.MONEY].amount -= activation_cost
		base_states.floor[str(use_location.floor)].generator_level += 1
		SUBSCRIBE.base_states = base_states
		SUBSCRIBE.resources_data = resources_data

	GameplayNode.restore_showing_state()	
	return confirm
# ------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func open_store() -> bool:	
	GameplayNode.current_shop_step = GameplayNode.SHOP_STEPS.OPEN
	return await GameplayNode.on_store_purchase_complete
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func get_new_scp() -> Dictionary:
	var list:Array = []
	
	# if this is the first one, always make item 0 the first item
	if scp_data.contained_list.size() == 0:
		list = [0]
	else:
		# check for specific days that only supply specific scps
		if progress_data.day == 4:
			list = [4]
		if progress_data.day == 20:
			list = [20]
		if progress_data.day == 24:
			list = [24]
	
	# otherwise, produce three randomly that are not in the contained list
	if list.is_empty():
		var unavailable_list:Array = scp_data.contained_list.map(func(x): return x.ref)
		list = scp_data.available_refs
	
	if list.is_empty():
		return {"is_empty": true}
		
	SCPSelectScreen.start_selection(list)
	GameplayNode.current_select_scp_step = GameplayNode.SELECT_SCP_STEPS.START
	var res:Dictionary = await GameplayNode.on_scp_select_complete
	res.is_empty = false
	
	return res
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func promote_researchers() -> bool:	
	GameplayNode.current_researcher_step = GameplayNode.RESEARCHERS_STEPS.PROMOTE	
	var response:Dictionary = await GameplayNode.on_researcher_component_complete
	return response.action == ACTION.RESEARCHERS.PROMOTED
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func recruit_new_researcher(total_options:int) -> bool:
	SelectResearcherScreen.total_options = total_options 
	GameplayNode.current_recruit_step = GameplayNode.RECRUIT_STEPS.OPEN
	return await GameplayNode.on_recruit_complete		
# ---------------------------------------------------------------------------get-----------------------

# ------------------------------------------------------------------------------
func upgrade_scp_level(from_location:Dictionary, scp_ref:int) -> bool:
	SUBSCRIBE.suppress_click = true
	var contained_data:Dictionary = find_in_contained(scp_ref)
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	var testing_index:int = scp_data.contained_list[contained_data.index].testing_completed
	
	if testing_index >= scp_details.testing_options.size():
		ConfirmModal.set_props("There's no additional test scenarios available.")
		await GameplayNode.show_only([ConfirmModal, Structure3dContainer])	
		await ConfirmModal.user_response
		GameplayNode.restore_showing_state()	
		return true
	
	var testing_event:Dictionary = scp_details.testing_options[testing_index]
	ConfirmModal.activation_requirements = SCP_UTIL.return_testing_requirements(scp_ref, testing_index)
	ConfirmModal.set_props("Begin testing on %s?" % [scp_details.name], "THERE ARE RISKS ASSOCIATED WITH TESTING.", scp_details.img_src)
	await GameplayNode.show_only([ConfirmModal, Structure3dContainer])	
	var confirm:bool = await ConfirmModal.user_response
	
	#TODO: ADD EVENT 	
	if confirm:
		SUBSCRIBE.resources_data = SCP_UTIL.calculate_testing_costs(scp_ref, testing_index)
		var extract_data:Dictionary = GAME_UTIL.extract_room_details(from_location)		
		GameplayNode.event_data = [{"event_instructions": testing_event.event_instructions.call(extract_data, 0)}]
		await GameplayNode.on_events_complete
		# increament and save
		scp_data.contained_list[contained_data.index].testing_completed = U.min_max( contained_data.data.testing_completed + 1, 0, scp_details.testing_options.size())
		SUBSCRIBE.scp_data = scp_data		
		# need to restore hud here
		await U.tick()
		GameplayNode.restore_player_hud()
		
	else:
		GameplayNode.restore_showing_state()	
	
	return confirm
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------	
#region SCP ACTION QUEUE (assign/unassign/dismiss, etc)
# -----------------------------------
func remove_from_timeline(timeline_item:Dictionary) -> void:	
	SUBSCRIBE.timeline_array = timeline_array.filter(func(i): return i.uid != timeline_item.uid)
	await U.tick()
# -----------------------------------

# -----------------------------------
func add_timeline_item(dict:Dictionary) -> void:
	timeline_array.push_back({
		"uid": U.generate_uid(),		
		"title": dict.title,
		"icon": dict.icon,
		"description": dict.description,
		"day": dict.day,
		"location": dict.location,
		"event": dict.event if "event" in dict else {},
	})
	
	SUBSCRIBE.timeline_array = timeline_array
# -----------------------------------
#endregion	
# ------------------------------------------------------------------------------	
