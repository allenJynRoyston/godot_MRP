extends SubscribeWrapper

const ObjectivesPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ObjectivesContainer/ObjectivesContainer.tscn")
const ConfirmModalPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ConfirmModal/ConfirmModal.tscn")
const WarningModalPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/WarningModal/WarningModal.tscn")
const EventContainerPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/EventContainer/EventContainer.tscn")
const NewTallyPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/NewTallyModal/NewTallyModal.tscn")

const ResearcherHireScreenPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResearcherHireScreen/ResearcherHireScreen.tscn")
const ScpSelectScreenPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/SCPSelectScreen/SCPSelectScreen.tscn")

const StoreGridPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/StoreGrid/StoreGrid.tscn")
const ScpGridPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ScpGrid/ScpGrid.tscn")
const ResearchersGridPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResearcherGrid/ResearcherGrid.tscn")

const DialogPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/DialogueContainer/DialogueContainer.tscn")
const ContainmentBreachPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ContainmentBreachSplash/ContainmentBreachSplash.tscn")

const z_index_lvl:int = 10
const new_scp_entry:Dictionary = {
	"level": 0,
	"location": {},
	"contained_on_day": null,
	"check_for_breaches_on": [],
	"breach_count": 0,
	"next_breach_at": 0,
	"event_results": {}
}

var GameplayNode:Control
var Structure3dContainer:Control
var ToastContainer:Control
var ActionContainer:Control

var previous_show_taskbar_state:bool

# ------------------------------------------------------------------------------
func assign_nodes() -> void:	
	GameplayNode = GBL.find_node(REFS.GAMEPLAY_LOOP)
	#ConfirmModal = GameplayNode.ConfirmModal
	Structure3dContainer = GameplayNode.Structure3dContainer
	ToastContainer = GameplayNode.ToastContainer
	ActionContainer = GameplayNode.ActionContainer
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func mark_current_objectives() -> void:
	var objectives:Array = STORY.get_objectives()
	var story_progress:Dictionary = GBL.active_user_profile.story_progress
	var current_objectives:Dictionary = objectives[story_progress.current_story_val]	
	
	var bookmarked_objectives:Array = []
	for objective in current_objectives.list:
		bookmarked_objectives.push_back(objective)
		
	SUBSCRIBE.bookmarked_objectives = bookmarked_objectives
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func are_objectives_complete() -> bool:
	# CHECK IF SCENARIO DATA IS COMPLETE
	var objectives:Array = STORY.get_objectives()
	var story_progress:Dictionary = GBL.active_user_profile.story_progress
	var current_objectives:Dictionary = objectives[story_progress.current_story_val]
	var completed_by_day:int = current_objectives.complete_by_day
	
					
	# CHECK FOR FAIL STATE
	var objective_failed:bool = false
	for objective in current_objectives.list:
		if !objective.is_optional and !objective.is_completed.call():
			objective_failed = true
			break	
	
	return !objective_failed
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
func get_vibes_summary(use_location:Dictionary) -> Dictionary:
	var floor_config_data:Dictionary = room_config.floor[use_location.floor]
	var ring_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring]	
	var floor_level_metrics:Dictionary = floor_config_data.metrics	
	var ring_level_metrics:Dictionary = ring_config_data.metrics
	var total_metrics:Dictionary = {}
	
	for dict in [floor_level_metrics, ring_level_metrics]:
		for ref in dict:
			if ref not in total_metrics:
				total_metrics[ref] = 0
			total_metrics[ref] += dict[ref]		
	
	return total_metrics
# ------------------------------------------------------------------------------
	
# ------------------------------------------------------------------------------
func get_floor_summary(use_location:Dictionary = current_location) -> Dictionary:
	if use_location.is_empty():return {}
	
	var designation:String = U.location_to_designation(use_location)
	var floor:int = use_location.floor
	var ring:int = use_location.ring
	var room:int = use_location.room	
	var floor_config:Dictionary = room_config.floor[floor]
	var ring_config:Dictionary = room_config.floor[floor].ring[ring]
	var room_config:Dictionary = room_config.floor[floor].ring[ring].room[room]	
	var currencies_diff:Dictionary = floor_config.currencies
	
	var metrics_diff:Dictionary = {
		RESOURCE.METRICS.MORALE: 0,
		RESOURCE.METRICS.SAFETY: 0,
		RESOURCE.METRICS.READINESS: 0
	}	
	
	# no differential on a ring level
	var personnel_diff:Dictionary = {
		RESOURCE.PERSONNEL.STAFF: 0,
		RESOURCE.PERSONNEL.TECHNICIANS: 0,
		RESOURCE.PERSONNEL.SECURITY: 0,
		RESOURCE.PERSONNEL.DCLASS: 0
	}
		
	return {
		"currency_diff": currencies_diff,
		"metric_diff": metrics_diff,
		"energy_diff": 0,
		"personnel_diff": personnel_diff
	}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_ring_summary(use_location:Dictionary = current_location) -> Dictionary:
	if use_location.is_empty():return {}
	
	var designation:String = U.location_to_designation(use_location)
	var floor:int = use_location.floor
	var ring:int = use_location.ring
	var room:int = use_location.room	
	var ring_config:Dictionary = room_config.floor[floor].ring[ring]
	var room_config:Dictionary = room_config.floor[floor].ring[ring].room[room]	
	
	var currencies_diff:Dictionary = ring_config.currencies
	
	var metrics_diff:Dictionary = {
		RESOURCE.METRICS.MORALE: 0,
		RESOURCE.METRICS.SAFETY: 0,
		RESOURCE.METRICS.READINESS: 0
	}	
	
	# no differential on a ring level
	var personnel_diff:Dictionary = {
		RESOURCE.PERSONNEL.STAFF: 0,
		RESOURCE.PERSONNEL.TECHNICIANS: 0,
		RESOURCE.PERSONNEL.SECURITY: 0,
		RESOURCE.PERSONNEL.DCLASS: 0
	}

		
	return {
		"currency_diff": currencies_diff,
		"metric_diff": metrics_diff,
		"energy_diff": 0,
		"personnel_diff": personnel_diff
	}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_room_summary(use_location:Dictionary = current_location) -> Dictionary:
	if use_location.is_empty():return {}
	
	var designation:String = U.location_to_designation(use_location)
	var floor:int = use_location.floor
	var ring:int = use_location.ring
	var room:int = use_location.room	
	var room_config:Dictionary = room_config.floor[floor].ring[ring].room[room]
	
	var currencies_diff:Dictionary = room_config.currencies
	var metrics_diff:Dictionary = room_config.metrics
	var energy_diff:int = room_config.energy_used
	var personnel_diff:Dictionary = {
		RESOURCE.PERSONNEL.STAFF: 0,
		RESOURCE.PERSONNEL.TECHNICIANS: 0,
		RESOURCE.PERSONNEL.SECURITY: 0,
		RESOURCE.PERSONNEL.DCLASS: 0
	}
	
	for key in room_config.personnel:
		if room_config.personnel[key]:
			personnel_diff[key] = 1
		
	return {
		"currency_diff": currencies_diff,
		"metric_diff": metrics_diff,
		"energy_diff": energy_diff,
		"personnel_diff": personnel_diff
	}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_metric_val(use_location:Dictionary, metric_ref:RESOURCE.METRICS) -> int:
	if use_location.is_empty():
		use_location = current_location
		
	var floor_config_data:Dictionary = room_config.floor[use_location.floor]
	var ring_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring]
	var room_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
	
	var floor_val:int = floor_config_data.metrics[metric_ref]
	var ring_val:int = ring_config_data.metrics[metric_ref]
	var room_val:int = room_config_data.metrics[metric_ref]
	
	return floor_val + ring_val + room_val	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_daily_resources() -> void:
	for ref in resources_data:
		resources_data[ref].amount += resources_data[ref].diff
	
	SUBSCRIBE.resources_data = resources_data
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func extract_room_details(use_location:Dictionary = current_location, use_config:Dictionary = room_config) -> Dictionary:
	if use_config.is_empty():return {}
	var designation:String = U.location_to_designation(use_location)
	var floor:int = use_location.floor
	var ring:int = use_location.ring
	var room:int = use_location.room
	var floor_level:Dictionary = use_config.floor[floor]
	var ring_level:Dictionary = use_config.floor[floor].ring[ring]
	var room_level:Dictionary = use_config.floor[floor].ring[ring].room[room]
	
	var is_room_empty:bool = room_level.room_data.is_empty()
	var is_scp_empty:bool = room_level.scp_data.is_empty()
	
	var room_details:Dictionary = {} if is_room_empty else room_level.room_data.details 
	var scp_details:Dictionary = {} if is_scp_empty else room_level.scp_data.details
	
	var researchers:Array = hired_lead_researchers_arr.filter(func(x):
		var details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(x[0])
		if (!details.props.assigned_to_room.is_empty() and U.location_to_designation(details.props.assigned_to_room) == designation):
			return true
		return false	
	).map(func(x):return RESEARCHER_UTIL.return_data_with_uid(x[0]))
	
	# compiles metrics
	var metrics:Dictionary = {}
	for dict in [room_details, scp_details]:
		if "metrics" in dict:
			for ref in dict.metrics:
				var amount:int = dict.metrics[ref]
				if ref not in metrics:
					metrics[ref] = 0
				metrics[ref] += amount
	
	# get currency this room is producing (combines room/scp/etc)
	var currency_list:Array = []
	for ref in room_level.currencies:
		var resource_details:Dictionary = RESOURCE_UTIL.return_currency(ref)
		var amount:int = room_level.currencies[ref]		
		currency_list.push_back({"ref": ref, "icon": resource_details.icon, "title": str(amount)})			
				
	return {
		# -----------
		"room": {
			"details": room_details,
			"can_destroy": room_details.can_contain,
			"can_contain": room_details.can_destroy,
			"is_activated": false if is_room_empty else room_level.is_activated,
			"metrics": metrics,
			"abl_lvl": 0, #room_config.abl_lvl + ring_config.abl_lvl,		
			"currency_list": currency_list
		} if !is_room_empty else {},
		
		# -----------
		"scp": {
			"details": scp_details,
		} if !is_scp_empty else {},
		
		# -----------
		"researchers": researchers
	}
# ------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func use_active_ability(ability:Dictionary, room_ref:int, ability_index:int, use_location:Dictionary) -> void:
	var designation:String = U.location_to_designation(use_location)
	var ability_uid:String = str(room_ref, ability_index)
	var apply_cooldown:bool = await ability.effect.call()
	if apply_cooldown:
		if ability_uid not in base_states.room[designation].ability_on_cooldown:
			base_states.room[designation].ability_on_cooldown[ability_uid] = 0		
			
		base_states.room[designation].ability_on_cooldown[ability_uid] = ability.cooldown_duration
		resources_data[RESOURCE.CURRENCY.SCIENCE].amount -= ability.science_cost
		
		SUBSCRIBE.resources_data = resources_data
		SUBSCRIBE.base_states = base_states
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func toggle_passive_ability(room_ref:int, ability_index:int, use_location:Dictionary = current_location) -> void:
	var ring_config:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring]
	var designation:String = U.location_to_designation(use_location)
	var ability_uid:String = str(room_ref, ability_index)

	if ability_uid not in base_states.room[designation].passives_enabled:
		base_states.room[designation].passives_enabled[ability_uid] = false
	
	var toggle_val:bool = !base_states.room[designation].passives_enabled[ability_uid]
	if ring_config.energy.used >= ring_config.energy.available and toggle_val:return

	base_states.room[designation].passives_enabled[ability_uid] = toggle_val

	SUBSCRIBE.base_states = base_states
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

	var confirm:bool = await create_modal("Reset room?", "Room will be destroyed, researchers will be unassigned.")
	SUBSCRIBE.unavailable_rooms = []
	
	if confirm:	
		var floor_index:int = current_location.floor
		var ring_index:int = current_location.ring
		var room_index:int = current_location.room
		var reset_arr:Array = purchased_facility_arr.filter(func(i): return (i.location.floor == floor_index and i.location.ring == ring_index and i.location.room == room_index))
		# ---------------------
		if reset_arr.size() > 0:
			var reset_item:Dictionary = reset_arr[0]
			SUBSCRIBE.purchased_facility_arr = purchased_facility_arr.filter(func(i): return !(i.location.floor == floor_index and i.location.ring == ring_index and i.location.room == room_index))
			SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(reset_item.ref, true)
			
			hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
				# clear out prior researchers
				if U.dictionaries_equal(i[11].assigned_to_room, current_location):
					i[10].assigned_to_room = {}
				return i
			)
			SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
			
			return true
		else:
			return false
	else:
		GameplayNode.restore_player_hud()
		return false	
# --------------------------------------------------------------------------------------------------		

# -----------------------------------
func add_objectives_to_timeline(objectives:Array = []) -> void:
	for objective in objectives:
		print(objective.complete_by_day)
		GAME_UTIL.add_timeline_item({
			"title": "Objectives deadline",
			"icon": SVGS.TYPE.INFO,
			"description": "Objective",
			"day": objective.complete_by_day
		})
# -----------------------------------

# -----------------------------------
func start_containment_breach() -> Control:
	var ContainmentNode:Control = ContainmentBreachPreload.instantiate()
	ContainmentNode.z_index = z_index_lvl
	GameplayNode.add_child(ContainmentNode)
	
	await ContainmentNode.activate()
	
	ContainmentNode.start()
	
	return ContainmentNode
# -----------------------------------


# -----------------------------------
func open_objectives() -> void:	
	disable_taskbar(true)
	
	var ObjectivesNode:Control = ObjectivesPreload.instantiate()
	ObjectivesNode.z_index = z_index_lvl
	GameplayNode.add_child(ObjectivesNode)
	
	await ObjectivesNode.activate()
	
	GameplayNode.show_only([Structure3dContainer])
	ObjectivesNode.start()

	await ObjectivesNode.user_response
	
	GameplayNode.restore_player_hud()
	disable_taskbar(false)
# -----------------------------------

# ------------------------------------------------------------------------------	
func construct_room(allow_placement:bool = true) -> void:	
	GameplayNode.current_builder_step = GameplayNode.BUILDER_STEPS.OPEN
	await U.tick()
	#GameplayNode.BuildContainer.allow_placement = allow_placement
	await GameplayNode.on_store_purchase_complete	
# ---------------------

# ---------------------
func trigger_event(event_data:Array) -> Dictionary:
	disable_taskbar(true)
	
	var EventContainer:Control = EventContainerPreload.instantiate()
	GameplayNode.add_child(EventContainer)
	EventContainer.z_index = z_index_lvl - 1
	
	await EventContainer.activate()
	EventContainer.start(event_data)
	var event_res:Dictionary = await EventContainer.user_response
	
	disable_taskbar(false)
	return event_res
# ---------------------

# ---------------------
func set_onsite_nuke() -> bool:
	var confirm:bool = await create_modal("Set the onsite nuclear to trigger?", "Panic will ensure.")
	
	if !confirm:
		return false
	
	# update trigger event
	base_states.base.onsite_nuke.triggered = true
	SUBSCRIBE.base_states = base_states		
	
	# update debuff
	#for floor in range(0, room_config.floor.size()):
	add_debuff_to_base(BASE.DEBUFF.PANIC, 3)

	return false
# ---------------------

# ---------------------
func set_warning_mode() -> bool:
	var confirm:bool = await create_modal("Set the wing to WARNING mode?", "")
	
	if !confirm:
		return false
			

	# set emergency mode
	base_states.ring[str(current_location.floor, current_location.ring)].emergency_mode = ROOM.EMERGENCY_MODES.WARNING
	SUBSCRIBE.base_states = base_states
	
	# add debuff
	add_debuff_to_floor_and_rings(BASE.DEBUFF.PANIC, -3, current_location.floor, [current_location.ring])
	
	return true
# ---------------------

# ---------------------
func set_danger_mode() -> bool:
	var confirm:bool = await create_modal("Set the wing to DANGER mode?", "")
	
	if !confirm:
		return false
			
	# set emergency mode
	base_states.ring[str(current_location.floor, current_location.ring)].emergency_mode = ROOM.EMERGENCY_MODES.DANGER
	SUBSCRIBE.base_states = base_states
	
	# add debuff
	add_debuff_to_floor_and_rings(BASE.DEBUFF.PANIC, -3, current_location.floor, [current_location.ring])
	
	return true
# ---------------------

# --------------------------------------------------------------------------------------------------
# Add buff to an entire floor
func add_buff_to_floor(buff_ref:int, duration:int, floor:int = current_location.floor) -> void:
	BASE_UTIL.add_buff_or_debuff_to_floor(BASE.TYPE.BUFF, buff_ref, duration, floor)
# ---------------------

# ---------------------
# Add buff to an entire floor, but can add specific rings.
func add_buff_to_floor_and_rings(buff_ref:int, duration:int, floor:int = current_location.floor, rings:Array = [current_location.ring]) -> void:
	BASE_UTIL.add_buff_or_debuff_to_ring(BASE.TYPE.BUFF, buff_ref, duration, floor, rings)
# ---------------------

# ---------------------
# Add buff to an entire floor, but can add specific rings and rooms
func add_buff_to_floor_and_rings_rooms(buff_ref:int, duration:int, floor:int = current_location.floor, rings:Array = [current_location.ring], rooms:Array = [current_location.room]) -> void:
	BASE_UTIL.add_buff_or_debuff_to_rooms(BASE.TYPE.BUFF, buff_ref, duration, floor, rings, rooms)
# ---------------------

# ---------------------
# Add DEbuff to an entire base
func add_debuff_to_base(debuff_ref:int, duration:int) -> void:
	BASE_UTIL.add_buff_or_deubff_to_base(BASE.TYPE.DEBUFF, debuff_ref, duration)
# ---------------------

# ---------------------
# Add DEbuff to an entire floor
func add_debuff_to_floor(debuff_ref:int, duration:int, floor:int = current_location.floor) -> void:
	BASE_UTIL.add_buff_or_debuff_to_floor(BASE.TYPE.DEBUFF, debuff_ref, duration, floor)
# ---------------------

# ---------------------
# Add DEbuff to an entire floor, but can add specific rings.
func add_debuff_to_floor_and_rings(debuff_ref:int, duration:int, floor:int = current_location.floor, rings:Array = [current_location.ring]) -> void:
	BASE_UTIL.add_buff_or_debuff_to_ring(BASE.TYPE.DEBUFF, debuff_ref, duration, floor, rings)
# ---------------------

# ---------------------
# Add DEbuff to an entire floor, but can add specific rings and rooms
func add_debuff_to_floor_and_rings_rooms(debuff_ref:int, duration:int, floor:int = current_location.floor, rings:Array = [current_location.ring], rooms:Array = [current_location.room]) -> void:
	BASE_UTIL.add_buff_or_debuff_to_rooms(BASE.TYPE.DEBUFF, debuff_ref, duration, floor, rings, rooms)
# --------------------------------------------------------------------------------------------------

# ---------------------
func eval_scp() -> bool:
	var ScpGridNode:Control = ScpGridPreload.instantiate()
	GameplayNode.add_child(ScpGridNode)
	ScpGridNode.z_index = z_index_lvl
	
	await ScpGridNode.activate()
	ScpGridNode.research()
	var scp_ref:int = await ScpGridNode.user_response
	
	if scp_ref == -1:
		return false
	
	# create dict if it doesn't exist
	if scp_ref not in scp_data:
		scp_data[scp_ref] = new_scp_entry.duplicate(true)
	
	scp_data[scp_ref].level += 1
	SUBSCRIBE.scp_data = scp_data
	
	resources_data[RESOURCE.CURRENCY.CORE].amount -= 1
	SUBSCRIBE.resources_data = resources_data
	
	return true
# ---------------------

# --------------------------------------------------------------------------------------------------	
func trigger_breach_event(scp_ref:int, BreachNode:Control) -> void:	
	# pull details
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	
	# Check for initial breach event
	var researchers:Array = hired_lead_researchers_arr.map(func(x): return RESEARCHER_UTIL.return_data_with_uid(x[0])).filter(func(x): 
		return false if x.props.assigned_to_room.is_empty() else x.props.assigned_to_room == scp_data[scp_ref].location
	)
	
	# update next breach event day
	scp_data[scp_ref].next_breach_at = progress_data.day + scp_details.breach_check_frequency
	scp_data[scp_ref].breach_count += 1
	SUBSCRIBE.scp_data = scp_data	

	# set emergency mode
	var previous_emergency_mode:int = base_states.ring[str(current_location.floor, current_location.ring)].emergency_mode
	base_states.ring[str(current_location.floor, current_location.ring)].emergency_mode = ROOM.EMERGENCY_MODES.DANGER
	SUBSCRIBE.base_states = base_states
	await U.set_timeout(3.5)	
	GameplayNode.show_only([])
	await BreachNode.zero()

	var res:Dictionary = await trigger_event([EVENT_UTIL.run_event(
		EVT.TYPE.SCP_BREACH_EVENT_1, 
			{
				"room_details": ROOM_UTIL.return_data_via_location(current_location),
				"scp_details": scp_details,
				"scp_entry": scp_data[scp_ref],
				"researchers": researchers,
			}
		)
	])
	
	# restore previous emergency mode
	base_states.ring[str(current_location.floor, current_location.ring)].emergency_mode = previous_emergency_mode
	SUBSCRIBE.base_states = base_states
# --------------------------------------------------------------------------------------------------	
	

# --------------------------------------------------------------------------------------------------	
func contain_scp() -> bool:
	var ScpGridNode:Control = ScpGridPreload.instantiate()
	GameplayNode.add_child(ScpGridNode)
	ScpGridNode.z_index = z_index_lvl
	
	await ScpGridNode.activate()
	ScpGridNode.contain()
	var scp_ref:int = await ScpGridNode.user_response
	if scp_ref == -1:return false
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)

	# create dict if it doesn't exist
	if scp_ref not in scp_data:
		scp_data[scp_ref] = new_scp_entry.duplicate(true)
	
	# then update entry
	scp_data[scp_ref].location = current_location.duplicate(true)
	scp_data[scp_ref].contained_on_day = progress_data.day
	scp_data[scp_ref].breach_count = 0
	scp_data[scp_ref].next_breach_at = progress_data.day + scp_details.breach_check_frequency
	# save
	SUBSCRIBE.scp_data = scp_data	
	
	# Check for initial breach event
	var researchers:Array = hired_lead_researchers_arr.map(func(x): return RESEARCHER_UTIL.return_data_with_uid(x[0])).filter(func(x): 
		return false if x.props.assigned_to_room.is_empty() else x.props.assigned_to_room == scp_data[scp_ref].location
	)

	var res:Dictionary = await trigger_event([EVENT_UTIL.run_event(
		EVT.TYPE.SCP_ON_CONTAINMENT, 
			{
				"room_details": ROOM_UTIL.return_data_via_location(current_location),
				"scp_details": scp_details,
				"scp_entry": scp_data[scp_ref],
				"researchers": researchers
			}
		)
	])
	

	return true
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func clone_researcher() -> bool:
	var ResearcherGrid:Control = ResearchersGridPreload.instantiate()
	GameplayNode.add_child(ResearcherGrid)
	ResearcherGrid.z_index = z_index_lvl
	
	await ResearcherGrid.activate()
	ResearcherGrid.start()
	var uid:String = await ResearcherGrid.user_response
	
	# empty response means cancel
	if uid == "":
		return false
		
	var res:Dictionary = await trigger_event([EVENT_UTIL.run_event(
		EVT.TYPE.CLONE_RESEARCHER, 
			{
				"researcher": RESEARCHER_UTIL.return_data_with_uid(uid),
				"onSelection": func(selection:Dictionary) -> void:
					# add buff, debuff
					print("todo: ADD BUFF OR DEBUFF")
					print(selection),
			}
		)
	])
	
	# promote to level
	RESEARCHER_UTIL.clone_researcher(uid)	
	
	return true
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------	
func promote_researcher() -> bool:	
	var ResearcherGrid:Control = ResearchersGridPreload.instantiate()
	GameplayNode.add_child(ResearcherGrid)
	ResearcherGrid.z_index = z_index_lvl
	
	await ResearcherGrid.activate()	
	ResearcherGrid.promote()
	var uid:String = await ResearcherGrid.user_response

	
	# empty response means cancel
	if uid == "":
		return false
	
	var res:Dictionary = await trigger_event([EVENT_UTIL.run_event(
		EVT.TYPE.PROMOTE_RESEARCHER, 
			{
				"researcher": RESEARCHER_UTIL.return_data_with_uid(uid),
				"onSelection": func(selection:Dictionary) -> void:
					# add buff, debuff
					print("todo: ADD BUFF OR DEBUFF")
					print(selection),
			}
		)
	])
	#print(res)
	
	# promote to level
	RESEARCHER_UTIL.promote_researcher(uid)
	
	return true
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func hire_researcher(total_options:int) -> bool:
	var ResearcherHireNode:Control = ResearcherHireScreenPreload.instantiate()
	GameplayNode.add_child(ResearcherHireNode)
	ResearcherHireNode.z_index = z_index_lvl
	ResearcherHireNode.total_options = total_options 	
	
	await ResearcherHireNode.activate()
	ResearcherHireNode.start()
	
	var uid:String = await ResearcherHireNode.user_response

	if uid == "":
		return false	
	
	var res:Dictionary = await trigger_event([EVENT_UTIL.run_event(
		EVT.TYPE.HIRE_RESEARCHER, 
			{
				"researcher": RESEARCHER_UTIL.return_data_with_uid(uid),
				"onSelection": func(selection:Dictionary) -> void:
					# add buff, debuff
					print("todo: ADD BUFF OR DEBUFF")
					print(selection),
			}
		)
	])
		#
	
	return true	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func assign_researcher(staffing_type:int, location_data:Dictionary = current_location) -> bool:
	var ResearcherGrid:Control = ResearchersGridPreload.instantiate()
	GameplayNode.add_child(ResearcherGrid)
	ResearcherGrid.z_index = 10
	
	var assigned_uids:Array =  hired_lead_researchers_arr.filter(func(i):				
		return U.dictionaries_equal(i[11].assigned_to_room, current_location)
	).map(func(i): return i[0])	
	

	await ResearcherGrid.activate()
	ResearcherGrid.start(assigned_uids, staffing_type, current_location)
	var uid:String = await ResearcherGrid.user_response
	GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)	

	# empty response means cancel
	if uid == "":
		return false
	
	var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(uid)
	hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
		# add current users
		if i[0] in uid:
			i[11].assigned_to_room = location_data.duplicate()
		return i
	)
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
	return true
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func unassign_researcher(researcher_data:Dictionary) -> bool:
	var confirm:bool = await create_modal("Unassign researcher from this room?", "Researcher will become available.", researcher_data.img_src)

	if confirm:
		SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
			if i[0] == researcher_data.uid:
				i[11].assigned_to_room = {}
			return i
		)
		return true
#
	return false
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
			
	var confirm:bool = await create_modal(title, subtitle)
	
	if confirm:
		room_config.floor[use_location.floor].in_lockdown = state
		SUBSCRIBE.room_config = room_config

	GameplayNode.restore_showing_state()	
	return confirm
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func activate_floor(floor_val:int) -> bool:
	SUBSCRIBE.suppress_click = true

	var activated_count:int = 0
	for floor_index in room_config.floor.size():
		if base_states.floor[str(floor_index)].is_powered:
			activated_count += 1
	var activation_cost:int = activated_count * 50
	var can_purchase:bool = resources_data[RESOURCE.CURRENCY.MONEY].amount >= activation_cost
	
	var activation_requirements = [{"amount": activation_cost, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]
	var title:String = "Activate floor %s?" % floor_val
	var subtitle:String = ""

	var confirm:bool = await create_modal(title, subtitle, "", activation_requirements)

	if confirm:
		resources_data[RESOURCE.CURRENCY.MONEY].amount -= activation_cost
		base_states.floor[str(floor_val)].is_powered = true
		SUBSCRIBE.base_states = base_states 
		SUBSCRIBE.resources_data = resources_data
			
	return confirm
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func upgrade_generator_level(use_location:Dictionary = current_location) -> bool:
	var activation_cost:int = 25
	var can_purchase:bool = resources_data[RESOURCE.CURRENCY.MONEY].amount >= activation_cost
	var title:String = "Upgrade generator?"
	var subtitle:String = "X energy will be available per ring."

	var activation_requirements = [{"amount": activation_cost, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]
	var confirm:bool = await create_modal(title, subtitle, "", activation_requirements)

	if confirm:
		resources_data[RESOURCE.CURRENCY.MONEY].amount -= activation_cost
		base_states.floor[str(use_location.floor)].generator_level += 1
		SUBSCRIBE.base_states = base_states
		SUBSCRIBE.resources_data = resources_data

	return confirm
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func upgrade_facility(blacklist_self:bool = true) -> bool:
	var unavailable_rooms:Array = [] if !blacklist_self else [U.location_to_designation(current_location)]
	var previous_location:Dictionary = current_location.duplicate(true)
	
	# determine which rooms are unavailble 
	var floor:int = current_location.floor
	var ring:int = current_location.ring
	for room_index in room_config.floor[floor].ring[ring].room.size():
		var designation:String = str(current_location.floor, current_location.ring, room_index)
		
		# rooms that are empty...
		if room_config.floor[floor].ring[ring].room[room_index].room_data.is_empty():
			unavailable_rooms.push_back(designation)
		else:
			# ... and rooms that are already at the max level are added to the unavailable list
			var max_possible_level:int = ROOM_UTIL.get_max_possible_level(room_config.floor[floor].ring[ring].room[room_index].room_data.ref)
			var current_level:int = base_states.room[designation].abl_lvl
			if current_level >= max_possible_level:
				unavailable_rooms.push_back(designation)
	
	# update all unavailable rooms
	SUBSCRIBE.unavailable_rooms = unavailable_rooms
		
	# hide UI in actionContainer
	GameplayNode.show_only([Structure3dContainer])	
	
	var activation_requirements = [{"amount": 100, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.SCIENCE)}]
	var confirm:bool = await create_modal("Upgrade room?", "Upgrade room to level X?", "", activation_requirements, true, Color(0, 0, 0, 0))
	
	# clear, warp back to previous location and restore ui
	SUBSCRIBE.unavailable_rooms = []
	GameplayNode.restore_player_hud()
	
	# cancel, warp back to previous location
	if !confirm:
		SUBSCRIBE.current_location = previous_location		
		return false
		
	# add
	base_states.room[U.location_to_designation(current_location)].abl_lvl += 1
	
	# then warp back to previous location
	SUBSCRIBE.current_location = previous_location		
		
	return true
# ------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func open_store() -> bool:	
	var StoreGrid:Control = StoreGridPreload.instantiate()
	GameplayNode.add_child(StoreGrid)
	StoreGrid.z_index = 10
	
	await StoreGrid.activate()
	StoreGrid.start()
	
	var response:bool = await StoreGrid.user_response

	return response
# --------------------------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------
func upgrade_scp_level(from_location:Dictionary, scp_ref:int) -> bool:
	SUBSCRIBE.suppress_click = true
	#var contained_data:Dictionary = find_in_contained(scp_ref)
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	#var testing_index:int = scp_data.contained_list[contained_data.index].testing_completed
	
	#if testing_index >= scp_details.testing_options.size():
		#ConfirmModal.set_props("There's no additional test scenarios available.")
		#await GameplayNode.show_only([ConfirmModal, Structure3dContainer])	
		#await ConfirmModal.user_response
		#GameplayNode.restore_showing_state()	
		#return true
	#
	#var testing_event:Dictionary = scp_details.testing_options[testing_index]
	#ConfirmModal.activation_requirements = SCP_UTIL.return_testing_requirements(scp_ref, testing_index)
	#ConfirmModal.set_props("Begin testing on %s?" % [scp_details.name], "THERE ARE RISKS ASSOCIATED WITH TESTING.", scp_details.img_src)
	#await GameplayNode.show_only([ConfirmModal, Structure3dContainer])	
	#var confirm:bool = await ConfirmModal.user_response
	
	#TODO: ADD EVENT 	
	#if confirm:
		#SUBSCRIBE.resources_data = SCP_UTIL.calculate_testing_costs(scp_ref, testing_index)
		#var extract_data:Dictionary = GAME_UTIL.extract_room_details(from_location)		
		#GameplayNode.event_data = [{"event_instructions": testing_event.event_instructions.call(extract_data, 0)}]
		#await GameplayNode.on_events_complete
		## increament and save
		#scp_data.contained_list[contained_data.index].testing_completed = U.min_max( contained_data.data.testing_completed + 1, 0, scp_details.testing_options.size())
		#SUBSCRIBE.scp_data = scp_data		
		## need to restore hud here
		#await U.tick()
		#GameplayNode.restore_player_hud()
		#
	#else:
		#GameplayNode.restore_showing_state()	
	#
	#return confirm
	return false
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func open_tally(color_bg:Color = Color(0, 0, 0, 0.7)) -> void:
	previous_show_taskbar_state = GBL.find_node(REFS.OS_LAYOUT).freeze_inputs
	disable_taskbar(true)
	
	var NewtallyNode:Control = NewTallyPreload.instantiate()
	NewtallyNode.z_index = 100	
	GameplayNode.add_child(NewtallyNode)
	NewtallyNode.set_props("DAILY RESOURCES", "We gots to get paid.", "", Color(0, 0, 0, 0.7))	
	await NewtallyNode.activate(false)
	
	NewtallyNode.start()
	await NewtallyNode.user_response	
	
	disable_taskbar(previous_show_taskbar_state)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func create_warning(title:String = "", subtitle:String = "", img_src:String = "", allow_controls:bool = false, color_bg:Color = Color(0, 0, 0, 0.7)) -> bool:
	previous_show_taskbar_state = GBL.find_node(REFS.OS_LAYOUT).freeze_inputs
	disable_taskbar(true)
	
	var WarningNode:Control = WarningModalPreload.instantiate()
	WarningNode.z_index = 100	
	GameplayNode.add_child(WarningNode)
	WarningNode.set_props(title, subtitle, img_src, color_bg)
	WarningNode.allow_controls = allow_controls
	
	await WarningNode.activate(false)
	
	WarningNode.start()
	var confirm:bool = await WarningNode.user_response	
	
	disable_taskbar(previous_show_taskbar_state)
	return confirm
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func create_modal(title:String = "", subtitle:String = "", img_src:String = "", activation_requirements:Array = [], allow_controls:bool = false, color_bg:Color = Color(0, 0, 0, 0.7)) -> bool:
	previous_show_taskbar_state = GBL.find_node(REFS.OS_LAYOUT).freeze_inputs
	disable_taskbar(true)
	
	var ConfirmNode:Control = ConfirmModalPreload.instantiate()
	ConfirmNode.z_index = 100	
	GameplayNode.add_child(ConfirmNode)
	ConfirmNode.set_props(title, subtitle, img_src, color_bg)
	ConfirmNode.allow_controls = allow_controls
	
	await ConfirmNode.activate(false)
	ConfirmNode.activation_requirements = activation_requirements
	
	ConfirmNode.start()
	var confirm:bool = await ConfirmNode.user_response	
	
	disable_taskbar(previous_show_taskbar_state)
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
		"location": dict.location if "location" in dict else {},
		"event": dict.event if "event" in dict else {},
	})

	SUBSCRIBE.timeline_array = timeline_array
# -----------------------------------
#endregion	
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func disable_taskbar(state:bool) -> void:
	GBL.find_node(REFS.OS_LAYOUT).freeze_inputs = state
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func add_dialogue(data:Dictionary) -> void:
	disable_taskbar(true)
	
	var DialogNode:Control = DialogPreload.instantiate()
	DialogNode.z_index = z_index_lvl
	GameplayNode.add_child(DialogNode)
		
	await U.tick()
	DialogNode.start(data)

	await DialogNode.user_response
	GameplayNode.restore_player_hud()
	
	disable_taskbar(false)
# ------------------------------------------------------------------------------	



# ------------------------------------------------------------------------------	TUTORIAL
#region START GAME
func start_tutorial() -> void:
	await add_dialogue({
		"title": "HOW TO PLAY",
		"text": [
			'Welcome Site Director.',
			'The rules of this simulation are simple.',
			'You will have a set of objectives.  These objectives have a deadline.',
			'There is no singular way to complete an objective, but if you get stuck you can purchase a hint.',
			'Do not fear failure.  If you get to a point where you cannot proceed, start over.',
			'Knowledge, experience and creativity are the cornerstone for doing this job safetly and effectively.',
			'This is your time to practice before you have to deal with the real thing.  Good luck.',
			'- The O5 Council'
		]
	})
#endregion
# ------------------------------------------------------------------------------
