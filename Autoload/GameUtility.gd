extends SubscribeWrapper

const ObjectivesPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ObjectivesContainer/ObjectivesContainer.tscn")
const ConfirmModalPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ConfirmModal/ConfirmModal.tscn")
const EventContainerPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/EventContainer/EventContainer.tscn")

const ResearcherHireScreenPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResearcherHireScreen/ResearcherHireScreen.tscn")
const ScpSelectScreenPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/SCPSelectScreen/SCPSelectScreen.tscn")

const StoreGridPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/StoreGrid/StoreGrid.tscn")
const ScpGridPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ScpGrid/ScpGrid.tscn")
const ResearchersGridPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResearcherGrid/ResearcherGrid.tscn")

const z_index_lvl:int = 10
const new_scp_entry:Dictionary = {
	"level": 0,
	"location": {},
	"contained_on": null,
	"breach_results": {}
}

var GameplayNode:Control
var Structure3dContainer:Control
var ToastContainer:Control

# ------------------------------------------------------------------------------
func assign_nodes() -> void:	
	GameplayNode = GBL.find_node(REFS.GAMEPLAY_LOOP)
	#ConfirmModal = GameplayNode.ConfirmModal
	Structure3dContainer = GameplayNode.Structure3dContainer
	ToastContainer = GameplayNode.ToastContainer
# ------------------------------------------------------------------------------

## ------------------------------------------------------------------------------
#func get_ability_level(use_location:Dictionary = current_location) -> int:
	#var floor:int = use_location.floor
	#var ring:int = use_location.ring	
	#var room:int = use_location.room
	#var wing_abl_lvl:int = 	room_config.floor[floor].ring[ring].abl_lvl
	#var room_abl_lvl:int = room_config.floor[floor].ring[ring].room[room].abl_lvl
	#return wing_abl_lvl + room_abl_lvl
## ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
#func get_room_traits(use_location:Dictionary, use_config:Dictionary = room_config) -> Dictionary:
	#var designation:String = U.location_to_designation(use_location)	
	#var floor:int = use_location.floor
	#var ring:int = use_location.ring
	#var room:int = use_location.room
	#var config_data:Dictionary = use_config.floor[floor].ring[ring].room[room]
	#var room_data:Dictionary = config_data.room_data
	#var scp_data:Dictionary = config_data.scp_data 
#
	#var total_traits_list := []
	#var synergy_traits := []
	#var dup_list := []		
	#var trait_list := []
	#var synergy_list := []
#
	#
	#var researchers:Array = hired_lead_researchers_arr.filter(func(x):
		#var details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(x[0])
		#if (!details.props.assigned_to_room.is_empty() and U.location_to_designation(details.props.assigned_to_room) == designation):
			#return true
		#return false	
	#).map(func(x):return RESEARCHER_UTIL.return_data_with_uid(x[0]))
		#
	## records bonus from traits
	#for researcher in researchers:
		#total_traits_list.push_back(researcher.traits)
	#
	## records bonus from traits
	##for traits in total_traits_list:
		##for t in traits:
			##if t not in dup_list:
				##trait_list.push_back(RESEARCHER_UTIL.return_trait_details(t, use_location, use_config))
				#
	## records bonus from synergy traits
	##if total_traits_list.size() == 2:
		##var list:Array = RESEARCHER_UTIL.return_trait_synergy(total_traits_list[0], total_traits_list[1])
		##for details in list:
			##var effect:Dictionary = details.get_effect.call({"room_details": room_details, "scp_details": scp_details, "resource_details": resource_details})
			##var resource_list:Array = []
			##var metric_list:Array = []
			### -------------------
			##if "resource" in effect:
				##for key in effect.resource:
					##var amount:int = effect.resource[key]
					##
					##if key not in resource_details.synergy_traits:
						##resource_details.synergy_traits[key] = 0
					##if key not in resource_details.total:
						##resource_details.total[key] = 0
					##resource_details.synergy_traits[key] += amount
					##resource_details.total[key] += amount
					##
					##resource_list.push_back({"resource": RESOURCE_UTIL.return_currency(key), "amount": amount})
			### -------------------
			##if "metrics" in effect:
				##for key in effect.metrics:
					##var amount:int = effect.metrics[key]
##
					##if key not in metric_details.traits:
						##metric_details.traits[key] = 0
					##if key not in metric_details.total:
						##metric_details.total[key] = 0
					##metric_details.traits[key] += amount
					##metric_details.total[key] += amount					
					##
					##metric_list.push_back({"resource": RESOURCE_UTIL.return_metric(key), "amount": amount})		
						##
			##synergy_trait_list.push_back({"details": details, "effect": {"resource_list": resource_list, "metric_list": metric_list}} )
				#
	#return {
		#"trait_list": trait_list,
		#"synergy_list": synergy_list
	#}
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
#func apply_scp_pair_and_morale_bonus(use_location:Dictionary, amount:int, use_room_config:Dictionary = room_config) -> int:
	#var floor:int = use_location.floor
	#var ring:int = use_location.ring
	#var room:int = use_location.room
	#
	#var ring_config:Dictionary = use_room_config.floor[floor].ring[ring]
	#var room_config:Dictionary = use_room_config.floor[floor].ring[ring].room[room]
	## double the amount if specilization has a match
	#if room_config.scp_paired_with.specilization:
		#amount = amount * 2
		#
	## double room_config amount if trait has a match	
	#if room_config.scp_paired_with.trait:
		#amount = amount * 2
		#
	#var morale_val:float = (ring_config.metrics[RESOURCE.METRICS.MORALE] * 20) * 0.01
	#var bonus_val:int = ceili( amount * morale_val )
	#
	#return amount + bonus_val
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_morale_val(use_location:Dictionary = {}) -> int:
	if use_location.is_empty():
		use_location = current_location
		
	var floor_config_data:Dictionary = room_config.floor[use_location.floor]
	var ring_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring]
	var room_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
	
	var floor_morale_val:int = floor_config_data.metrics[RESOURCE.METRICS.MORALE]
	var ring_morale_val:int = ring_config_data.metrics[RESOURCE.METRICS.MORALE]
	var room_morale_val:int = room_config_data.metrics[RESOURCE.METRICS.MORALE]
	
	return floor_morale_val + ring_morale_val + room_morale_val	
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func apply_morale_bonus(use_location:Dictionary, total_morale_val:int, resource_amount:int,  use_room_config:Dictionary = room_config) -> Dictionary:
	var floor:int = use_location.floor
	var ring:int = use_location.ring
	var room:int = use_location.room
	var room_config:Dictionary = use_room_config.floor[floor].ring[ring].room[room]
	var applied_bonus:float = (total_morale_val * 10) * 0.01		
	var amount:int = resource_amount + floori( resource_amount * applied_bonus )
	
	return {
		"applied_bonus": applied_bonus,
		"total_morale_val": total_morale_val,
		"amount": amount
	}
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

### ------------------------------------------------------------------------------
#func get_passive_ability_state(room_ref:int, ability_index:int, use_location:Dictionary = current_location) -> bool:
	#var designation:String = U.location_to_designation(use_location)
	#var passives_enabled:Dictionary = base_states.room[designation].passives_enabled
	#var ability_uid:String = str(room_ref, ability_index)
	#
#
	#return passives_enabled[ability_uid] if (ability_uid in passives_enabled) else false
### ------------------------------------------------------------------------------	
#
### ------------------------------------------------------------------------------
#func get_ability_cooldown(ability:Dictionary, use_location:Dictionary = current_location) -> int:
	#var designation:String = U.location_to_designation(use_location)
	#var ability_uid:String = str(use_location.floor, use_location.ring, use_location.room, ability.ref)	
	#var cooldown_duration:int = 0
	#
	#if ability_uid in base_states.room[designation].ability_on_cooldown:
		#cooldown_duration = base_states.room[designation].ability_on_cooldown[ability_uid]	
#
	#return cooldown_duration
### ------------------------------------------------------------------------------	

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
				if U.dictionaries_equal(i[10].assigned_to_room, current_location):
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
func open_objectives() -> void:
	var ObjectivesNode:Control = ObjectivesPreload.instantiate()
	ObjectivesNode.z_index = z_index_lvl
	GameplayNode.add_child(ObjectivesNode)
	await ObjectivesNode.activate(GameplayNode.scenario_data.objectives)
	GameplayNode.show_only([Structure3dContainer])
	ObjectivesNode.start()

	await ObjectivesNode.user_response
	GameplayNode.restore_player_hud()
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
	var EventContainer:Control = EventContainerPreload.instantiate()
	GameplayNode.add_child(EventContainer)
	EventContainer.z_index = z_index_lvl
	await EventContainer.activate()
	EventContainer.start(event_data)
	var event_res:Dictionary = await EventContainer.user_response
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
#func research_scp() -> bool:
	#var list:Array = []
	#
	## if this is the first one, always make item 0 the first item
	#if scp_data.contained_list.size() == 0:
		#list = [0]
	#else:
		## check for specific days that only supply specific scps
		#if progress_data.day == 4:
			#list = [4]
		#if progress_data.day == 20:
			#list = [20]
		#if progress_data.day == 24:
			#list = [24]
	#
	## otherwise, produce three randomly that are not in the contained list
	#if list.is_empty():
		#var unavailable_list:Array = scp_data.contained_list.map(func(x): return x.ref)
		#list = scp_data.available_refs
	#
	#if list.is_empty():
		#return false
		#
	#var ScpSelectScreen:Control = ScpSelectScreenPreload.instantiate()
	#GameplayNode.add_child(ScpSelectScreen)
	#ScpSelectScreen.z_index = z_index_lvl
	#
	#await ScpSelectScreen.activate(list)
	#ScpSelectScreen.start()
	#var response:int = await ScpSelectScreen.user_response
	#
	#if response == -1:
		#return false
			#
	#return true
# ---------------------

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
func contain_scp() -> bool:
	var ScpGridNode:Control = ScpGridPreload.instantiate()
	GameplayNode.add_child(ScpGridNode)
	ScpGridNode.z_index = z_index_lvl
	
	await ScpGridNode.activate()
	ScpGridNode.contain()
	var scp_ref:int = await ScpGridNode.user_response
	
	if scp_ref == -1:
		return false
#
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	var breach_events_at:Array = [0, 7, 14, 28]
	
	var breach
	for index in breach_events_at.size():
		var val:int = breach_events_at[index]
		var day:int = val + progress_data.day

		add_timeline_item({
			"title": scp_details.name,
			"icon": SVGS.TYPE.DANGER,
			"description": "DANGER",
			"day": day,
			"event": {
				"scp_ref": scp_ref,
				"event_ref": SCP.EVENT_TYPE.BREACH_EVENT,
				"event_count": index,
			}
		})		

	# create dict if it doesn't exist
	if scp_ref not in scp_data:
		scp_data[scp_ref] = new_scp_entry.duplicate(true)
	
	# then update entry
	scp_data[scp_ref].location = current_location.duplicate(true)
	scp_data[scp_ref].contained_on = progress_data.day
	scp_data[scp_ref].breach_results = {}
 
	var researchers:Array = hired_lead_researchers_arr.map(func(x): return RESEARCHER_UTIL.return_data_with_uid(x[0])).filter(func(x): 
		return false if x.props.assigned_to_room.is_empty() else x.props.assigned_to_room == scp_data[scp_ref].location
	)		

	# save
	SUBSCRIBE.scp_data = scp_data	
	
	# trigger event
	var res:Dictionary = await trigger_event([EVENT_UTIL.run_event(
		EVT.TYPE.SCP_ON_CONTAIN, 
			{
				"scp_details": scp_details,
				"scp_data": scp_data[scp_ref],
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
func assign_researcher(location_data:Dictionary = current_location) -> bool:
	var ResearcherGrid:Control = ResearchersGridPreload.instantiate()
	GameplayNode.add_child(ResearcherGrid)
	ResearcherGrid.z_index = 10
	
	var assigned_uids:Array =  hired_lead_researchers_arr.filter(func(i):				
		return U.dictionaries_equal(i[10].assigned_to_room, current_location)
	).map(func(i): return i[0])	
	
	await ResearcherGrid.activate()
	ResearcherGrid.start(assigned_uids, current_location)
	var uid:String = await ResearcherGrid.user_response
	GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)	

	# empty response means cancel
	if uid == "":
		return false
	
	var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(uid)
	hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
		# add current users
		if i[0] in uid:
			i[10].assigned_to_room = location_data.duplicate()
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
				i[10].assigned_to_room = {}
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
func create_modal(title:String = "", subtitle:String = "", img_src:String = "", activation_requirements:Array = [], allow_controls:bool = false, color_bg:Color = Color(0, 0, 0, 0.7)) -> bool:
	var ConfirmNode:Control = ConfirmModalPreload.instantiate()
	ConfirmNode.z_index = 100	
	GameplayNode.add_child(ConfirmNode)
	ConfirmNode.set_props(title, subtitle, img_src, color_bg)
	ConfirmNode.allow_controls = allow_controls
	
	await ConfirmNode.activate(false)
	ConfirmNode.activation_requirements = activation_requirements
	
	ConfirmNode.start()
	var confirm:bool = await ConfirmNode.user_response	
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
