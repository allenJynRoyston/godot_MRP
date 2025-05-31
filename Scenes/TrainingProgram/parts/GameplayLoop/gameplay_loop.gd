extends PanelContainer

@onready var Structure3dContainer:Control = $Structure3DContainer
@onready var TimelineContainer:PanelContainer = $TimelineContainer
@onready var ActionContainer:PanelContainer = $ActionContainer
@onready var DialogueContainer:MarginContainer = $DialogueContainer
@onready var ResourceContainer:Control = $ResourceContainer
@onready var LineDrawContainer:PanelContainer = $LineDrawContainer
@onready var PhaseAnnouncement:PanelContainer = $PhaseAnnouncement
@onready var ToastContainer:PanelContainer = $ToastContainer
@onready var WaitContainer:PanelContainer = $WaitContainer
@onready var TransitionScreen:Control = $TransitionScreen

const SetupContainedPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/SetupContainer/SetupContainer.tscn")

enum PHASE { STARTUP, PLAYER, RESOURCE_COLLECTION, RANDOM_EVENTS, CALC_NEXT_DAY, SCHEDULED_EVENTS, CONCLUDE, GAME_WON, GAME_LOST }

enum OBJECTIVES_STATE {
	HIDE, 
	SHOW
}

enum SELECT_SCP_STEPS { RESET, START }

# ------------------------------------------------------------------------------	EXPORT VARS
#region EXPORT VARS
var show_structures:bool = true: 
	set(val):
		show_structures = val
		on_show_structures_update()
		
var show_timeline:bool = true : 
	set(val):
		show_timeline = val
		on_show_timeline_update()

var show_actions:bool = false : 
	set(val):
		show_actions = val
		on_show_actions_update()

var show_dialogue:bool = false : 
	set(val):
		show_dialogue = val
		on_show_dialogue_update()
		
var show_linedraw:bool = true : 
	set(val):
		show_linedraw = val
		on_show_linedraw_update()
		
var show_resources:bool = false : 
	set(val):
		show_resources = val
		on_show_resources_update()
		
		
#endregion
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------ 
#region INITIAL DATA
var initial_values:Dictionary = {
	# ----------------------------------
	"current_location": func() -> Dictionary:
		return {
			"floor": 0,
			"ring": 0,
			"room": 4 # 4 is the center
		},
	# ----------------------------------
	"scp_data": func() -> Dictionary:
		return {

		},
	# ----------------------------------
	"progress_data": func() -> Dictionary:
		return { 
			"day": 1,
			"record": [],
			"previous_records": []
		},
	# ----------------------------------
	"resources_data": func(starting_resources:Dictionary = {}) -> Dictionary:
		return { 
			RESOURCE.CURRENCY.MONEY: {
				"amount": starting_resources[RESOURCE.CURRENCY.MONEY] if !DEBUG.get_val(DEBUG.GAMEPLAY_ALL_PERSONNEL) else 999, 
				"capacity": 9999
			},
			RESOURCE.CURRENCY.SCIENCE: {
				"amount": starting_resources[RESOURCE.CURRENCY.SCIENCE] if !DEBUG.get_val(DEBUG.GAMEPLAY_ALL_PERSONNEL) else 999, 
				"capacity": 1000
			},
			RESOURCE.CURRENCY.MATERIAL: {
				"amount": starting_resources[RESOURCE.CURRENCY.MATERIAL] if !DEBUG.get_val(DEBUG.GAMEPLAY_ALL_PERSONNEL) else 999, 
				"capacity": 500
			},
			RESOURCE.CURRENCY.CORE: {
				"amount": starting_resources[RESOURCE.CURRENCY.CORE] if !DEBUG.get_val(DEBUG.GAMEPLAY_ALL_PERSONNEL) else 10, 
				"capacity": 10
			},						
		},
	# ----------------------------------
	"researcher_hire_list": func() -> Array:
		return [],
	# ----------------------------------
	"shop_unlock_purchases": func() -> Array:
		return [],
	# ----------------------------------
	"room_config": func() -> Dictionary:
		return {
			"base": {
				"in_brownout": false,
				"in_debt": false,
				"generator_lvl": 0,
			},
			"floor": {
				0: get_floor_default(true, 3),
				1: get_floor_default(true, 3),
				2: get_floor_default(false, 3),
				3: get_floor_default(false, 3),
				4: get_floor_default(false, 3),
				5: get_floor_default(false, 3),
				6: get_floor_default(false, 3),
			}
		},
	# ----------------------------------
	"camera_settings": func() -> Dictionary:
		return {
			"type": CAMERA.TYPE.FLOOR_SELECT,
			"is_locked": false
		},
	# ----------------------------------
	"base_states": func() -> Dictionary:
		var floor:Dictionary = {}
		var ring:Dictionary = {}
		var room:Dictionary = {} 
		
		# ------------------------------
		for floor_index in [0, 1, 2, 3, 4, 5, 6]:
			floor[str(floor_index)] = {
				"generator_level": 0,
				"buffs": [{"ref": BASE.BUFF.MORALE_BOOST, "duration": 3}],
				"debuffs": [],
			} 
			# ------------------------------
			for ring_index in [0, 1, 2, 3]:
				ring[str(floor_index, ring_index)] = {
					"emergency_mode": ROOM.EMERGENCY_MODES.NORMAL,
					"researchers_per_room": DEBUG.get_val(DEBUG.GAMEPLAY_RESEARCHERS_PER_ROOM),
					#"hotkeys": {},
					"buffs": [{"ref": BASE.BUFF.MORALE_BOOST, "duration": 3}],
					"debuffs": [],
				}
				
				# ------------------------------
				for room_index in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
					room[str(floor_index, ring_index, room_index)] = {
						"passives_enabled": {},
						"ability_on_cooldown": {},
						"buffs": [{"ref": BASE.BUFF.MORALE_BOOST, "duration": 3}],
						"debuffs": [],
					}	

		
		return {
			#"global_hotkeys": {},
			"floor": floor, 	# not currently used for anything
			"ring": ring,
			"room": room		 # not currently used for anything
		},
	# ----------------------------------
	"gameplay_conditionals": func() -> Dictionary:
		return {						

		},
	# ----------------------------------
	"timeline_array": func() -> Array:
		return [],
	# ----------------------------------
	"purchased_facility_arr": func() -> Array:
		return [],
	# ----------------------------------
	"purchased_base_arr": func() -> Array:
		return [],
	# ----------------------------------
	"purchased_research_arr": func() -> Array:
		return [],
	# ----------------------------------
	"bookmarked_rooms": func() -> Array:
		return [],
	# ----------------------------------
	"unavailable_rooms": func() -> Array:
		return [],
	# ----------------------------------
	"hired_lead_researchers_arr": func() -> Array:
		return [],	
}

var room_config:Dictionary 
var scp_data:Dictionary
var timeline_array:Array 
var progress_data:Dictionary
var camera_settings:Dictionary
var current_location:Dictionary
var base_states:Dictionary
var resources_data:Dictionary 
var shop_unlock_purchases:Array 
var researcher_hire_list:Array
var action_queue_data:Array
var purchased_facility_arr:Array 
var purchased_base_arr:Array
var purchased_research_arr:Array 
var bookmarked_rooms:Array # ["000", "201"] <- "floor_index, ring_index, room_index"]
var unavailable_rooms:Array 
var hired_lead_researchers_arr:Array
var gameplay_conditionals:Dictionary

#endregion
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------	LOCAL DATA
#region LOCAL DATA
var onEndGame:Callable = func(_scenario_ref:int, _scenario_data:Dictionary, _endgame_state:bool) -> void:pass
var onExitGame:Callable = func(_exit_game:bool) -> void:pass

var processing_next_day:bool = false

var is_busy:bool = false : 
	set(val):
		is_busy = val
		on_is_busy_update()
		
var setup_complete:bool = false
var scenario_data:Dictionary
var scenario_ref:int
var awarded_rooms:Array = []

var current_location_snapshot:Dictionary 
var camera_settings_snapshot:Dictionary

var showing_states:Dictionary = {} 
var revert_state_location:Dictionary = {}
var tenative_location:Dictionary = {}

var completed_actions:Array = [] : 
	set(val):
		completed_actions = val

var current_phase:PHASE = PHASE.STARTUP : 
	set(val):
		current_phase = val
		on_current_phase_update()

signal phase_cycle_complete
signal on_events_complete
signal on_objective_signal

#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	LIFECYCLE
#region LIFECYCLE
func _init() -> void:
	GBL.register_node(REFS.GAMEPLAY_LOOP, self)
	GBL.subscribe_to_mouse_input(self)
	GBL.subscribe_to_control_input(self)

	SUBSCRIBE.subscribe_to_progress_data(self)
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_shop_unlock_purchases(self)
	SUBSCRIBE.subscribe_to_researcher_hire_list(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_purchased_research_arr(self)
	SUBSCRIBE.subscribe_to_purchased_base_arr(self)
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)
	SUBSCRIBE.subscribe_to_current_location(self)	
	SUBSCRIBE.subscribe_to_scp_data(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	SUBSCRIBE.subscribe_to_timeline_array(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)	
	SUBSCRIBE.subscribe_to_gameplay_conditionals(self)
	SUBSCRIBE.subscribe_to_awarded_room(self)
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.GAMEPLAY_LOOP)
	GBL.unsubscribe_to_mouse_input(self)
	GBL.unsubscribe_to_control_input(self)
	
	SUBSCRIBE.unsubscribe_to_progress_data(self)
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_shop_unlock_purchases(self)
	SUBSCRIBE.unsubscribe_to_researcher_hire_list(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_purchased_research_arr(self)
	SUBSCRIBE.unsubscribe_to_purchased_base_arr(self)
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_scp_data(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)
	SUBSCRIBE.unsubscribe_to_timeline_array(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)	
	SUBSCRIBE.unsubscribe_to_gameplay_conditionals(self)
	SUBSCRIBE.unsubscribe_to_awarded_room(self)

func _ready() -> void:
	self.modulate = Color(1, 1, 1, 0)

	# initially all animation speed is set to 0 but after this is all ready, set animation speed
	for node in get_all_container_nodes():
		node.set_process(false)
		node.set_physics_process(false)			
	
	# first these
	on_show_structures_update()
	on_show_actions_update()

	on_show_dialogue_update()
	on_show_resources_update()
	on_show_linedraw_update()
	
	# other
	on_is_busy_update()

	# get default showing state
	capture_default_showing_state()
	
	# assign
	GAME_UTIL.assign_nodes()
	
	await U.tick()
	LineDrawContainer.show()
	show_only([])

func exit_to_titlescreen() -> void:
	onExitGame.call(false)

func exit_game() -> void:
	onExitGame.call(true)
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	START GAME
#region START GAME
func start(new_game_data_config:Dictionary = {}) -> void:
	show()
	# initially all animation speed is set to 0 but after this is all ready, set animation speed
	set_process(true)
	set_physics_process(true)		
	
	await U.tick()
	start_new_game(new_game_data_config)
	

func setup_scenario(is_new_game:bool) -> void:
	scenario_data.objectives.push_back({
		"title": "SURVIVE FOR %s DAYS." % [scenario_data.day_limit],
		"is_completed": func() -> bool:
			return progress_data.day >= scenario_data.day_limit
	})
		
	# add endgame timeline object
	if is_new_game:
		GAME_UTIL.add_timeline_item({
			"title": "SCENARIO END",
			"icon": SVGS.TYPE.CONVERSATION,
			"description": "Win or lose...",
			"day": scenario_data.day_limit,
			"location": {"floor": 0, "ring": 0, "room": 0}
		})


func start_new_game(game_data_config:Dictionary) -> void:
	var skip_progress_screen:bool = DEBUG.get_val(DEBUG.GAMEPLAY_SKIP_SETUP_PROGRSS)	
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	
	# -----------------------
	var SetupContainer:Control = SetupContainedPreload.instantiate()
	add_child(SetupContainer)
	SetupContainer.z_index = 100
	
	await SetupContainer.start()
	SetupContainer.title = "SETTING UP... PLEASE WAIT."
	SetupContainer.subtitle = "SORTING FILES..."
	SetupContainer.progressbar_val = 0
	# 1.) loading game data config
	await parse_restore_data(game_data_config)
	await U.set_timeout(0.5 if !skip_progress_screen else 0.02)	
	
	# -----------------------
	SetupContainer.subtitle = "READING DATA CONFIG..."
	SetupContainer.progressbar_val = 0.3
	await U.set_timeout(0.5 if !skip_progress_screen else 0.02)	
	# 2.) setup game
	setup_complete = true
	update_room_config()	
	setup_scenario(game_data_config.filedata.is_empty())					

	# -----------------------
	SetupContainer.subtitle = "SETTING DEBUG VALUES..."
	SetupContainer.progressbar_val = 0.7
	await U.set_timeout(0.5 if !skip_progress_screen else 0.02)	
	# 3.) load any debug options
	var starting_number_of_researchers:int = DEBUG.get_val(DEBUG.GAMEPLAY_RESEARCHERS_BY_DEFAULT)
	if DEBUG.get_val(DEBUG.NEW_QUICKSAVE_FILE) and starting_number_of_researchers > 0:
			SUBSCRIBE.hired_lead_researchers_arr = RESEARCHER_UTIL.generate_new_researcher_hires(starting_number_of_researchers)
	
	# -----------------------
	SetupContainer.subtitle = "CLEANUP..."
	SetupContainer.progressbar_val = 0.9
	await U.set_timeout(0.5 if !skip_progress_screen else 0.02)
	# 4.) reset any nodes
	for node in get_all_container_nodes():
		node.set_process(true)
		node.set_physics_process(true)
		node.activate()
		if "on_reset" in node:
			node.on_reset()			
	
	# -----------------------
	# then show player hud
	await restore_player_hud()					
	SetupContainer.subtitle = "STARTING PROGRAM..."
	SetupContainer.progressbar_val = 1.0	
	await U.set_timeout(0.3)	
	# 5.) render everything to screen
	if !DEBUG.get_val(DEBUG.GAMEPLAY_SKIP_OBJECTIVES):
		await GAME_UTIL.open_objectives()
		quicksave(true)
				
	# animate out
	await SetupContainer.end()
	# update phase and start game
	current_phase = PHASE.PLAYER
	
	# start action
	# start at ring level
	if DEBUG.get_val(DEBUG.GAMEPLAY_START_AT_RING_LEVEL):
		ActionContainer.start(true)		
	else:
		ActionContainer.start()
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
#region defaults functions
func get_floor_default(is_powered:bool, array_size:int) -> Dictionary:
	return { 
		# --------------  # FLOOR WIDE STATS
		"metrics": {
			RESOURCE.METRICS.MORALE: 0,
			RESOURCE.METRICS.SAFETY: 0,
			RESOURCE.METRICS.READINESS: 0
		},
		"personnel": {
			RESOURCE.PERSONNEL.TECHNICIANS: false,
			RESOURCE.PERSONNEL.STAFF: false,
			RESOURCE.PERSONNEL.SECURITY: false,
			RESOURCE.PERSONNEL.DCLASS: false	
		},		
		"currencies": {
			RESOURCE.CURRENCY.MONEY: 0,
			RESOURCE.CURRENCY.MATERIAL: 0,
			RESOURCE.CURRENCY.SCIENCE: 0,
			RESOURCE.CURRENCY.CORE: 0,
		},
		"buffs": [],
		"debuffs": [],
		"room_refs": [],
		"scp_refs": [],		
		# --------------
		"is_powered": is_powered,
		"in_lockdown": false,
		"array_size": array_size,
		# --------------
		"ring": { 
			0: get_ring_defaults(array_size),
			1: get_ring_defaults(array_size),
			2: get_ring_defaults(array_size), 
			3: get_ring_defaults(array_size)
		}
	}

func get_ring_defaults(array_size:int) -> Dictionary:
	var room:Dictionary
	for n in range(array_size*array_size):
		room[n] = get_room_defaults()
	return {	
		# --------------  # FLOOR RING STATS
		"metrics": {
			RESOURCE.METRICS.MORALE: 0,
			RESOURCE.METRICS.SAFETY: 0,
			RESOURCE.METRICS.READINESS: 0
		},
		"personnel": {
			RESOURCE.PERSONNEL.TECHNICIANS: false,
			RESOURCE.PERSONNEL.STAFF: false,
			RESOURCE.PERSONNEL.SECURITY: false,
			RESOURCE.PERSONNEL.DCLASS: false	
		},
		"currencies": {
			RESOURCE.CURRENCY.MONEY: 0,
			RESOURCE.CURRENCY.MATERIAL: 0,
			RESOURCE.CURRENCY.SCIENCE: 0,
			RESOURCE.CURRENCY.CORE: 0,
		},
		"buffs": [],
		"debuffs": [],
		"room_refs": [],
		"scp_refs": [],		
		# --------------
		"abl_lvl": 0,
		"energy": {
			"available": 0,
			"used": 0
		},
		# --------------
		"emergency_mode": ROOM.EMERGENCY_MODES.NORMAL,
		"room": room
		# --------------
	}

func get_room_defaults() -> Dictionary:
	return {
		# --------------
		"metrics": {
			RESOURCE.METRICS.MORALE: 0,
			RESOURCE.METRICS.SAFETY: 0,
			RESOURCE.METRICS.READINESS: 0
		},
		"personnel": {
			RESOURCE.PERSONNEL.TECHNICIANS: false,
			RESOURCE.PERSONNEL.STAFF: false,
			RESOURCE.PERSONNEL.SECURITY: false,
			RESOURCE.PERSONNEL.DCLASS: false	
		},
		"currencies": {
			RESOURCE.CURRENCY.MONEY: 0,
			RESOURCE.CURRENCY.MATERIAL: 0,
			RESOURCE.CURRENCY.SCIENCE: 0,
			RESOURCE.CURRENCY.CORE: 0,
		},
		"buffs": [],
		"debuffs": [],		
		"applied_bonus": 0,
		# --------------
		"room_paired_with": {
			"specilization": false,
			"trait": false
		},
		# --------------
		"energy_used": 0, 		
		"damage_val": 0,
		"abl_lvl": 0,
		# --------------
		"is_activated": false,
		"room_data": {},
		"scp_data": {},
	}
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	SHOW/HIDE CONTAINERS
#region show/hide functions	
func on_is_busy_update() -> void:
	if !is_node_ready():return
	WaitContainer.show() if is_busy else WaitContainer.hide()

func get_all_container_nodes(exclude:Array = []) -> Array:
	return [
		Structure3dContainer, 
		TimelineContainer,
		ActionContainer, 
		DialogueContainer, 
		ResourceContainer,
		PhaseAnnouncement, 
		ToastContainer
	].filter(func(node): return node not in exclude)
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
var current_show_state:Dictionary = {}
func capture_current_showing_state() -> void:
	current_show_state = {}
	for node in get_all_container_nodes():
		current_show_state[node] = node.is_showing		
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func restore_showing_state() -> void:	
	var visible_nodes:Array = []
	for node in current_show_state:
		if current_show_state[node]:
			visible_nodes.push_back(node)
	await show_only(visible_nodes)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func capture_default_showing_state() -> void:
	for node in get_all_container_nodes():
		showing_states[node] = node.is_showing
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func restore_player_hud() -> void:	
	await show_only([Structure3dContainer, ActionContainer, TimelineContainer, ResourceContainer])
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func show_only(nodes:Array = []) -> void:
	capture_current_showing_state()
	
	var show_filter:Array = get_all_container_nodes().filter(func(node): return node in nodes)
	var hide_filter:Array = get_all_container_nodes().filter(func(node): return node not in nodes)
	
	for node in hide_filter:
		if node.is_showing != false:
			node.is_showing = false
	
	for node in show_filter:
		if node.is_showing != true:
			node.is_showing = true
	
	await U.set_timeout(0.5)
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
#region LOCAL FUNCS
## -----------------------------------
#func check_events(ref:int, event_ref:SCP.EVENT_TYPE, props:Dictionary = {}) -> void:
	#var res:Array = SCP_UTIL.check_for_events(ref, event_ref, props)
	#
	#if !res.is_empty():
		#GBL.find_node(REFS.LINE_DRAW).clear()
		#event_data = res
		#await on_events_complete
	#else:
		#restore_player_hud()
		#
	#await U.tick()
## -----------------------------------

# -----------------------------------
#func calculate_daily_costs(costs:Array) -> void:
	## MINUS RESOURCES
	#for cost in costs:
		#if cost.resource_ref in resources_data:
			#resources_data[cost.resource_ref].amount += cost.amount
			#var capacity:int = resources_data[cost.resource_ref].capacity
			#match cost.resource_ref:
				##----------------------------
				## trigger in debt if less than 50.  
				#RESOURCE.CURRENCY.MONEY:
					#var new_val:int = U.min_max(resources_data[cost.resource_ref].amount, -50, capacity)
					#resources_data[cost.resource_ref].amount = new_val
					#
					#if new_val < -5:
						#var props:Dictionary = {
							#"count": base_states.counts.in_debt,
							#"onSelection": func(val:EVT.IN_DEBT_OPTIONS) -> void:
								#match val:
									#EVT.IN_DEBT_OPTIONS.EMERGENCY_FUNDS:
										#resources_data[cost.resource_ref].amount = 20
									#EVT.IN_DEBT_OPTIONS.DO_NOTHING:
										#pass
										#
						#}
						##await triggger_event(EVT.TYPE.IN_DEBT_WARNING, props)
				##----------------------------
# -----------------------------------

# -----------------------------------
func execute_record_audit() -> void:
	# TRACK PROGRESS REPORT
	progress_data.previous_records.push_back(progress_data.record.duplicate(true))
	# then reset the record
	progress_data.record = []

	# CREATE WEEKLY AUDIT / RUN OPERATING COSTS
	for floor_index in room_config.floor.size():
		for ring_index in room_config.floor[floor_index].ring.size():
			for room_index in room_config.floor[floor_index].ring[ring_index].room.size():
				pass
				#var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": floor_index, "ring": ring_index, "room": room_index})
				#var is_room_empty:bool = extract_data.is_room_empty
				#var is_room_active:bool = extract_data.is_activated
				#var is_scp_empty:bool = extract_data.is_scp_empty
#
				#var researchers:Array = extract_data.researchers
				#var location:Dictionary = {
					#"designation": "%s%s%s" % [floor_index, ring_index, room_index],
					#"floor": floor_index,
					#"ring": ring_index,
					#"room": room_index,
				#}
#
				## ------- GETS ROOM DATA PROFITS/COSTS
				#if !is_room_empty and is_room_active:
					#var room_details:Dictionary = extract_data.room.details
					#var diff:Array = ROOM_UTIL.return_operating_cost(room_details.ref).map(func(i):
						#return {
							#"amount": i.amount, 
							#"resource_ref": i.resource.ref
						#}
					#)
					#
					#if diff.size() > 0:
						#progress_data.record.push_back({
							#"source": REFS.SOURCE.FACILITY,
							#"data": {
								#"name": room_details.name,
								#"day": progress_data.day,
								#"location": location,
								#"diff": diff
							#}
						#})
						#
						##calculate_daily_costs(diff)
					#
#
				## ------- GETS SCP DATA PROFITS
				#if !is_scp_empty:
					#var scp_details:Dictionary = extract_data.scp.details
					##var diff:Array = SCP_UTIL.return_ongoing_containment_rewards(scp_details.ref).map(func(i):
						##return {
							##"amount": i.amount, 
							##"resource_ref": i.resource.ref
						##}
					##)
					#
					##progress_data.record.push_back({
						##"source": REFS.SOURCE.SCPS,
						##"data": {
							##"name": scp_details.name,
							##"day": progress_data.day,
							##"location": location,
							##"diff": diff
						##}
					##})
					##
					##calculate_daily_costs(diff)
					#
					## CALUCLATE SCIENCE FROM SCP's
					#for researcher in researchers:
						#var science_amount:int = 1
						#var xp_amount:int = 2 - (researchers.size() - 1)   # 2xp if 1 researcher attached, 1xp if 2 are attached
						##for specilization in researcher.specializations:
							##if specilization in scp_details.researcher_preferences:
								##science_amount = scp_details.researcher_preferences[specilization]
						#
						#var science_diff:Array = [{
							#"amount": science_amount, 
							#"resource_ref": RESOURCE.CURRENCY.SCIENCE
						#}]
						#
						#progress_data.record.push_back({
							#"source": REFS.SOURCE.TESTING,
							#"data": {
								#"scp_ref": scp_details,
								#"researcher_uid": researcher.uid,
								#"name": researcher.name,
								#"day": progress_data.day,
								#"location": location,
								#"diff": science_diff
							#}
						#})
						#
						### add experience
						##var leveled_up:bool = RESEARCHER_UTIL.add_experience(researcher.uid, xp_amount)
						##progress_data.record.push_back({
							##"source": REFS.SOURCE.RESEARCHERS,
							##"data": {
								##"xp": xp_amount
							##}
						##})
						##
						#
						##calculate_daily_costs(science_diff)
# -----------------------------------

# -----------------------------------
func next_day() -> void:
	current_phase = PHASE.RESOURCE_COLLECTION
	await phase_cycle_complete
# -----------------------------------
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
#region GAMEPLAY FUNCS
# -----------------------------------
func game_over() -> void:
	await show_only([])	
	#var props:Dictionary = {
		#"onSelection": func(val:EVT.GAME_OVER_OPTIONS) -> void:
			#match val:
				#EVT.GAME_OVER_OPTIONS.RESTART:
					#start_new_game()
	#}	
	#triggger_event(EVT.TYPE.GAME_OVER, props)
# -----------------------------------
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
#region local SAVABLE ONUPDATES
# ------------------------------------------------------------------------------	LOCAL ON_UPDATES
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val

func on_progress_data_update(new_val:Dictionary = progress_data) -> void:
	progress_data = new_val

func on_purchased_research_arr_update(new_val:Array = purchased_research_arr) -> void:
	purchased_research_arr = new_val
	
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val 

func on_shop_unlock_purchases_update(new_val:Array = shop_unlock_purchases) -> void:
	shop_unlock_purchases = new_val

func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val

func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val

func on_bookmarked_rooms_update(new_val:Array = bookmarked_rooms) -> void:
	bookmarked_rooms = new_val
		
func on_researcher_hire_list_update(new_val:Array = researcher_hire_list) -> void:
	researcher_hire_list = new_val

func on_gameplay_conditionals_update(new_val:Dictionary = gameplay_conditionals) -> void:
	gameplay_conditionals = new_val
	
func on_awarded_rooms_update(new_val:Array = awarded_rooms) -> void:
	awarded_rooms = new_val

func on_hired_lead_researchers_arr_update(new_val:Array = hired_lead_researchers_arr) -> void:
	hired_lead_researchers_arr = new_val
	if setup_complete:
		U.debounce("update_room_config", update_room_config)

func on_base_states_update(new_val:Dictionary = base_states) -> void:
	base_states = new_val
	if setup_complete:
		U.debounce("update_room_config", update_room_config)
		
func on_purchased_facility_arr_update(new_val:Array = purchased_facility_arr) -> void:
	purchased_facility_arr = new_val	
	if setup_complete:
		U.debounce("update_room_config", update_room_config)
	
func on_purchased_base_arr_update(new_val:Array = purchased_base_arr) -> void:
	purchased_base_arr = new_val	
	if setup_complete:
		U.debounce("update_room_config", update_room_config)

func on_timeline_array_update(new_val:Array = timeline_array) -> void:
	timeline_array = new_val	
	if setup_complete:
		U.debounce("update_room_config", update_room_config)

func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val
	if setup_complete:
		U.debounce("update_room_config", update_room_config)

#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	ON_SHOW_UPDATES
#region on_show_updates
func on_show_structures_update() -> void:
	if !is_node_ready():return
	Structure3dContainer.is_showing = show_structures
	showing_states[Structure3dContainer] = show_structures
	
func on_show_actions_update() -> void:
	if !is_node_ready():return
	ActionContainer.is_showing = show_actions
	showing_states[ActionContainer] = show_actions
	
func on_show_timeline_update() -> void:
	if !is_node_ready():return
	TimelineContainer.is_showing = show_timeline
	showing_states[TimelineContainer] = show_timeline

func on_show_linedraw_update() -> void:
	if !is_node_ready():return
	LineDrawContainer.is_showing = show_linedraw
	showing_states[LineDrawContainer] = show_linedraw
		
func on_show_dialogue_update() -> void:
	if !is_node_ready():return
	DialogueContainer.is_showing = show_dialogue
	showing_states[DialogueContainer] = show_dialogue

func on_show_resources_update() -> void:
	if !is_node_ready():return
	ResourceContainer.is_showing = show_resources
	showing_states[ResourceContainer] = show_resources

#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	SHOP STEPS
func on_current_phase_update() -> void:
	if !is_node_ready():return

	match current_phase:
		# ------------------------
		PHASE.STARTUP:
			show_only([])
		# ------------------------
		PHASE.PLAYER:
			pass
			#current_phase = PHASE.SCHEDULED_EVENTS
		# ------------------------
		PHASE.RESOURCE_COLLECTION:
			current_location_snapshot = current_location.duplicate(true)
			camera_settings_snapshot = camera_settings.duplicate(true)
			
			if camera_settings_snapshot.type != CAMERA.TYPE.WING_SELECT:
				camera_settings.type = CAMERA.TYPE.WING_SELECT
				SUBSCRIBE.camera_settings = camera_settings	
				await U.set_timeout(1.0)
			
			
			PhaseAnnouncement.start("RESOURCE COLLECTION")	

			execute_record_audit()
			if progress_data.record.size() > 0:
				for record in progress_data.record:				
					match record.source:
						REFS.SOURCE.FACILITY:
							SUBSCRIBE.current_location = record.data.location
							for item in record.data.diff:
								var resource_details:Dictionary = RESOURCE_UTIL.return_currency(item.resource_ref)
								ToastContainer.add("%s %s %s %s" % [record.data.name, "generated" if item.amount > 0 else "spent", item.amount, resource_details.name])				
								await U.set_timeout(0.3)
							
					SUBSCRIBE.resources_data = resources_data		
				
			
			await U.set_timeout(1.0)
			current_phase = PHASE.CALC_NEXT_DAY
		# ------------------------
		PHASE.CALC_NEXT_DAY:
			PhaseAnnouncement.start("ADVANCING THE DAY")	
			
			# ADD TO PROGRESS DATA day count
			progress_data.day += 1
			
			# mark rooms and push to subscriptions
			#for floor_index in room_config.floor.size():		
				#for ring_index in room_config.floor[floor_index].ring.size():
					#for room_index in room_config.floor[floor_index].ring[ring_index].size():
						#var room_designation:String = str(floor_index, ring_index, room_index)
						#for key in base_states.room[room_designation].ability_on_cooldown:
							#if base_states.room[room_designation].ability_on_cooldown[key] > 0:
								#base_states.room[room_designation].ability_on_cooldown[key] -= 1
								#if base_states.room[room_designation].ability_on_cooldown[key] == 0:
									#ToastContainer.add("[%s] is ready!" % [key])
				#
			# update subscriptions
			SUBSCRIBE.progress_data = progress_data
			SUBSCRIBE.base_states = base_states
			
			await U.set_timeout(1.0)
			current_phase = PHASE.SCHEDULED_EVENTS
		# ------------------------
		PHASE.SCHEDULED_EVENTS:
			# EVENT FIRES			
			var timeline_filter:Array = timeline_array.filter(func(i): return i.day == progress_data.day)	
			if timeline_filter.size() > 0:
				PhaseAnnouncement.start("EVENTS")	
				await U.set_timeout(1.5)
				# plays any scp events
				#for item in timeline_filter:
					#if "event" in item and !item.event.is_empty():
						#await check_events(item.event.scp_ref, item.event.event_ref, {"event_count": item.event.event_count, "use_location": item.event.use_location})
			
			current_phase = PHASE.CONCLUDE
		# ------------------------
		PHASE.CONCLUDE:	
			# CHECK IF SCENARIO DATA IS COMPLETE
			var objectives_completed:bool = true
			for objective in scenario_data.objectives:
				if !objective.is_completed.call():
					objectives_completed = false
			
			if progress_data.day >= scenario_data.day_limit:
				await U.set_timeout(1.0)
				current_phase = PHASE.GAME_WON if objectives_completed else PHASE.GAME_LOST
				return
			
			PhaseAnnouncement.end()
			await U.set_timeout(1.0)
			# revert
			SUBSCRIBE.camera_settings = camera_settings_snapshot
			SUBSCRIBE.current_location = current_location_snapshot
			
			await restore_player_hud()
			current_phase = PHASE.PLAYER
			phase_cycle_complete.emit()
			
		# ------------------------
		PHASE.GAME_WON:
			PhaseAnnouncement.start("OBJECTIVES COMPLETE!")	
			onEndGame.call(scenario_ref, scenario_data, true)
			return
		# ------------------------
		PHASE.GAME_LOST:
			PhaseAnnouncement.start("FAILED TO MEET OBJECTIVES...")	
			onEndGame.call(scenario_ref, scenario_data, false)
			return
		# ------------------------
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------	SAVE/LOAD
#region SAVE/LOAD
func quicksave(skip_timeout:bool = false) -> void:
	is_busy = true

	var save_data := {
		# NOTE: ROOM CONFIG IS NEVER SAVED: IT IS READ-ONLY AS IT IS CREATED AS BY-PRODUCT
		# OF ALL THE OTHER DATA THAT'S HERE		
		"scenario_ref": scenario_ref,
		"progress_data": progress_data,		
		"scp_data": scp_data,
		"timeline_array": timeline_array,
		"gameplay_conditionals": gameplay_conditionals,
		"purchased_base_arr": purchased_base_arr,
		"purchased_facility_arr": purchased_facility_arr,
		"purchased_research_arr": purchased_research_arr,
		"hired_lead_researchers_arr": hired_lead_researchers_arr,
		"resources_data": resources_data,
		"bookmarked_rooms": bookmarked_rooms,
		"researcher_hire_list": researcher_hire_list,
		"shop_unlock_purchases": shop_unlock_purchases,
		"base_states": base_states,
	}	
	FS.save_file(FS.FILE.QUICK_SAVE, save_data)
	if !skip_timeout:
		await U.set_timeout(1.0)
	is_busy = false


func parse_restore_data(game_data_config:Dictionary) -> void:
	var restore_data:Dictionary = game_data_config.filedata
	var is_new_game:bool = restore_data.is_empty() 
	
	# load the scenario_data
	scenario_ref = game_data_config.scenario_ref if is_new_game else restore_data.scenario_ref
	scenario_data = SCENARIO_UTIL.get_scenario_data(scenario_ref)
	
	# modify if starting a new game
	var resources_data:Dictionary = initial_values.resources_data.call(scenario_data.start_conditions.resources) if is_new_game else restore_data.resources_data	
	SUBSCRIBE.resources_data = resources_data
	
	# any rooms completed by scenarios become allowed
	SUBSCRIBE.awarded_rooms = game_data_config.awarded_rooms
	
	# reactive data
	SUBSCRIBE.progress_data = initial_values.progress_data.call() if is_new_game else restore_data.progress_data
	SUBSCRIBE.scp_data = initial_values.scp_data.call() if is_new_game else restore_data.scp_data
	SUBSCRIBE.timeline_array = initial_values.timeline_array.call() if is_new_game else restore_data.timeline_array
	SUBSCRIBE.gameplay_conditionals = initial_values.gameplay_conditionals.call() #if no_save else restore_data.gameplay_conditionals	
	SUBSCRIBE.purchased_facility_arr = initial_values.purchased_facility_arr.call() if is_new_game else restore_data.purchased_facility_arr  
	SUBSCRIBE.purchased_base_arr = initial_values.purchased_base_arr.call() if is_new_game else restore_data.purchased_base_arr
	SUBSCRIBE.bookmarked_rooms = initial_values.bookmarked_rooms.call() if is_new_game else restore_data.bookmarked_rooms
	SUBSCRIBE.researcher_hire_list = initial_values.researcher_hire_list.call() if is_new_game else restore_data.researcher_hire_list
	SUBSCRIBE.purchased_research_arr = initial_values.purchased_research_arr.call() if is_new_game else restore_data.purchased_research_arr
	SUBSCRIBE.shop_unlock_purchases = initial_values.shop_unlock_purchases.call() if is_new_game else restore_data.shop_unlock_purchases
	SUBSCRIBE.base_states = initial_values.base_states.call() if is_new_game else restore_data.base_states
	SUBSCRIBE.hired_lead_researchers_arr = initial_values.hired_lead_researchers_arr.call() if is_new_game else restore_data.hired_lead_researchers_arr

	# don't need to be saved, just load from defaults
	SUBSCRIBE.current_location = initial_values.current_location.call() 
	SUBSCRIBE.camera_settings = initial_values.camera_settings.call() 
	SUBSCRIBE.unavailable_rooms = initial_values.unavailable_rooms.call()	

#endregion		
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# NOTE: THIS IS THE MAIN LOGIC THAT HAPPENS WHEN GAMEPLAY ESSENTIAL DATA IS UPDATED
# ------------------------------------------------------------------------------
func setup_default_energy_and_metrics(new_room_config:Dictionary) -> void:
	# energy availble per levels
	const energy_levels:Array = [5, 10, 15, 20, 25]
	
	for floor_index in new_room_config.floor.size():		
		for ring_index in new_room_config.floor[floor_index].ring.size():
			var energy_available:int = energy_levels[base_states.floor[str(floor_index)].generator_level]				
			var ring_config:Dictionary = new_room_config.floor[floor_index].ring[ring_index]
			var floor_ring_designation:String = str(floor_index, ring_index)
			
			# setup initial energy
			ring_config.energy.available = energy_available if !DEBUG.get_val(DEBUG.GAMEPLAY_MAX_ENERGY)	 else 99
			ring_config.energy.used = 0

func scp_run_first_effects(new_room_config:Dictionary) -> void:
	# CALCULATE CONTAINED SCP - LAST THING TO BE COMPUTED
	for ref in scp_data:
		var sdata:Dictionary = scp_data[ref]
		if !sdata.location.is_empty():
			var floor:int = sdata.location.floor
			var ring:int = sdata.location.ring
			var room:int = sdata.location.room	
			var floor_ring_designation:String = str(floor, ring)
			var floor_config:Dictionary = new_room_config.floor[floor]
			var ring_config:Dictionary = new_room_config.floor[floor].ring[ring]
			var room_config:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
			var scp_details:Dictionary = SCP_UTIL.return_data(ref)
			
			# run first level effects to get personnel
			if "personnel" in scp_details.effects:
				for key in scp_details.effects.personnel:
					ring_config.personnel[key] = scp_details.effects.personnel[key]
					room_config.personnel[key] = scp_details.effects.personnel[key]
			
			# run first level effects to get metrics		
			if "metrics" in scp_details.effects:
				for key in scp_details.effects.metrics:		
					var amount:int = scp_details.effects.metrics[key]
					ring_config.metrics[key] += amount
					room_config.metrics[key] += amount
					
			# run first level effects to get metrics		
			if "currencies" in scp_details.effects:
				for key in scp_details.effects.currencies:		
					var amount:int = scp_details.effects.currencies[key]
					floor_config.currencies[key] += amount
					ring_config.currencies[key] += amount
					room_config.currencies[key] += amount				
					
			## NEXT, check if any researchers pair with this SCP
			#for researcher in hired_lead_researchers_arr:
				#var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(researcher[0])
				#var assigned_to_room:Dictionary = researcher_details.props.assigned_to_room
				#if assigned_to_room == item.location:
					## TODO; remove not later
					#if scp_details.pairs_with.specilization in researcher_details.specializations:
						#room_config.scp_paired_with.specilization = true
					#if scp_details.pairs_with.trait in researcher_details.traits:
						#room_config.scp_paired_with.trait = true	

func room_setup_passives_and_ability_level(new_room_config:Dictionary) -> void:
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]		
		var room_base_state:Dictionary = base_states.room[str(floor, ring, room)]
		
		# FIRST, set default passives abilities
		var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)		
		if "passive_abilities" in room_data:
			var passive_abilities:Array = room_data.passive_abilities.call()
			for ability_index in passive_abilities.size():
				var ability:Dictionary = passive_abilities[ability_index]
				var ability_uid:String = str(room_data.ref, ability_index)
				# creates default state if it doesn't exist
				if ability_uid not in room_base_state.passives_enabled:
					room_base_state.passives_enabled[ability_uid] = false
					
		# NEXT, check if any researchers pair with this SCP
		for researcher in hired_lead_researchers_arr:
			var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(researcher[0])
			var assigned_to_room:Dictionary = researcher_details.props.assigned_to_room
			if assigned_to_room == item.location:
				if room_data.pairs_with.specilization in researcher_details.specializations:
					room_config_data.room_paired_with.specilization = true
					room_config_data.abl_lvl += researcher_details.level
				#if room_data.pairs_with.trait in researcher_details.traits:
					#room_config_data.room_paired_with.trait = true
					#room_config_data.abl_lvl += 1

func room_passive_check_for_effect(new_room_config:Dictionary) -> void:
	# NEXT check for passives in rooms
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)		
		var room_base_state:Dictionary = base_states.room[str(floor, ring, room)]
		var floor_config:Dictionary = new_room_config.floor[floor]
		var ring_config:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
		var floor_ring_designation:String = str(floor, ring)
			
		# if passives are enabled...
		if "passive_abilities" in room_data:
			var passive_abilities:Array = room_data.passive_abilities.call()
			for ability_index in passive_abilities.size():
				var ability:Dictionary = passive_abilities[ability_index]
				var ability_uid:String = str(room_data.ref, ability_index)
				var energy_cost:int = ability.energy_cost if "energy_cost" in ability else 1
				var room_abl_lvl:int = new_room_config.floor[floor].ring[ring].room[room].abl_lvl
				var wing_abl_lvl:int = new_room_config.floor[floor].ring[ring].abl_lvl
				var abl_lvl:int = room_abl_lvl + wing_abl_lvl

				# check if passive is enabled
				if room_base_state.passives_enabled[ability_uid]:
					# check if level is equal or less then what is required...
					# aand check if check if enough energy available to power the passive
					if ability.lvl_required <= abl_lvl and ring_config.energy.used < ring_config.energy.available:
						# if it's enabled, add to energy cost
						ring_config.energy.used += energy_cost
						room_config.energy_used += energy_cost

						# check provides (like staff, dclass, security, etc)
						if "personnel" in ability: 
							for key in ability.personnel:
								ring_config.personnel[key] = true
								room_config.personnel[key] = true

						# check for metrics
						if "metrics" in ability: 
							for key in ability.metrics:
								var amount:int = ability.metrics[key]
								ring_config.metrics[key] += amount
								room_config.metrics[key] += amount
								
						# check for metrics
						if "currencies" in ability: 
							for key in ability.currencies:
								var amount:int = ability.currencies[key]
								floor_config.currencies[key] += amount
								ring_config.currencies[key] += amount
								room_config.currencies[key] += amount
								
						# check for any conditional changes
						if "conditional" in ability:
							ability.conditional.call(gameplay_conditionals)
					else:
						room_base_state.passives_enabled[ability_uid] = false

func room_activation_check(new_room_config:Dictionary) -> void:
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var floor_ring_designation:String = str(floor, ring)
		var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)		
		var ring_config:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
		var is_activated:bool = true
		
		# check if room has any requirements
		for ref in room_data.required_personnel:
			if !ring_config.personnel[ref]:
				is_activated = false
				break
		# add is activated statement
		room_config.is_activated = is_activated 

func room_passive_activation_check(new_room_config:Dictionary) -> void:
	# NEXT check for passives in rooms
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)		
		var room_base_state:Dictionary = base_states.room[str(floor, ring, room)]
		var ring_config:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
		var floor_ring_designation:String = str(floor, ring)
			
		# if passives are enabled...
		if "passive_abilities" in room_data:
			var passive_abilities:Array = room_data.passive_abilities.call()
			for ability_index in passive_abilities.size():
				var ability:Dictionary = passive_abilities[ability_index]
				var ability_uid:String = str(room_data.ref, ability_index)
				var energy_cost:int = ability.energy_cost if "energy_cost" in ability else 1
				var is_activated:bool = room_config.is_activated
				
				# check if passive is enabled
				if room_base_state.passives_enabled[ability_uid]:
					# check if level is equal or less then what is required...
					if !is_activated:
						#room_base_state.passives_enabled[ability_uid] = false
						ring_config.energy.used -= energy_cost
						room_config.energy_used -= energy_cost

func room_calculate_metrics(new_room_config:Dictionary) -> void:
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var floor_ring_designation:String = str(floor, ring)
		var floor_config:Dictionary = new_room_config.floor[floor]
		var ring_config:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
		if room_config.is_activated:
			var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)
			# tally metrics
			for key in room_data.metrics:
				var amount:int = room_data.metrics[key]
				ring_config.metrics[key] += amount
				room_config.metrics[key] += amount

func scp_calculate_metrics(new_room_config:Dictionary) -> void:
	for ref in scp_data:
		var sdata:Dictionary = scp_data[ref]
		if !sdata.location.is_empty():
			var floor:int = sdata.location.floor
			var ring:int = sdata.location.ring
			var room:int = sdata.location.room	
			var floor_ring_designation:String = str(floor, ring)
			var floor_config:Dictionary = new_room_config.floor[floor]		
			var ring_config:Dictionary = new_room_config.floor[floor].ring[ring]
			var room_config:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
			var scp_details:Dictionary = SCP_UTIL.return_data(ref)
			
			# add to ring level metrics
			for key in scp_details.metrics:
				var amount:int = scp_details.metrics[key]
				ring_config.metrics[key] += amount
				room_config.metrics[key] += amount
				
func room_calculate_curriences(new_room_config:Dictionary) -> void:
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var floor_ring_designation:String = str(floor, ring)
		var floor_config_data:Dictionary = new_room_config.floor[floor]
		var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
		#print(room_config.currencies)

		if room_config_data.is_activated:
			var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)
			# tally their currencies
			for key in room_config_data.currencies:
				var amount:int = room_data.currencies[key]
				var added_amount:int = room_config_data.currencies[key]
				var total_amount:int = amount + added_amount
				var floor_morale_val:int = floor_config_data.metrics[RESOURCE.METRICS.MORALE]
				var ring_morale_val:int = ring_config_data.metrics[RESOURCE.METRICS.MORALE]
				var room_morale_val:int = room_config_data.metrics[RESOURCE.METRICS.MORALE]
				var total_morale_val:float = floor_morale_val + ring_morale_val + room_morale_val
				var res:Dictionary = GAME_UTIL.apply_morale_bonus(item.location, total_morale_val, total_amount, new_room_config)
				
				# add to totals
				floor_config_data.currencies[key] += res.amount
				ring_config_data.currencies[key] += res.amount
				
				# set as final amount
				room_config_data.currencies[key] = res.amount
				room_config_data.applied_bonus = res.applied_bonus

func check_for_buffs_and_debuffs(new_room_config:Dictionary) -> void:
	for floor_index in new_room_config.floor.size():
		var floor_base_state:Dictionary = base_states.floor[str(floor_index)]
		var floor_config:Dictionary = new_room_config.floor[floor_index]
		
		# --------------------------------------------------------------		FLOOR BUFFS/DEBUFFS
		for prop in ["buffs", "debuffs"]:	
			for item in floor_base_state[prop]:
				var data:Dictionary = BASE_UTIL.return_buff(item.ref)
				floor_config[prop].push_back({"data": data, "duration": item.duration})
				if "metrics" in data:
					for key in data.metrics:
						var amount:int = data.metrics[key]
						floor_config.metrics[key] += amount
		# --------------------------------------------------------------
		
		# --------------------------------------------------------------		RING BUFFS/DEBUFFS
		for ring_index in new_room_config.floor[floor_index].ring.size():
			var ring_base_state:Dictionary = base_states.ring[str(floor_index, ring_index)]
			var ring_config:Dictionary = new_room_config.floor[floor_index].ring[ring_index]
			for prop in ["buffs", "debuffs"]:	
				for item in ring_base_state[prop]:
					var data:Dictionary = BASE_UTIL.return_buff(item.ref)
					ring_config.buffs.push_back({"data": data, "duration": item.duration})
					if "metrics" in data:
						for key in data.metrics:
							var amount:int = data.metrics[key]
							ring_config.metrics[key] += amount
		# --------------------------------------------------------------
		
		# --------------------------------------------------------------		ROOM BUFFS/DEBUFFS
			for room_index in new_room_config.floor[floor_index].ring[ring_index].room.size():
				var room_base_state:Dictionary = base_states.room[str(floor_index, ring_index, room_index)]
				var room_config:Dictionary = new_room_config.floor[floor_index].ring[ring_index].room[room_index]
				for prop in ["buffs", "debuffs"]:	
					for item in room_base_state[prop]:
						var data:Dictionary = BASE_UTIL.return_buff(item.ref)
						room_config.buffs.push_back({"data": data, "duration": item.duration})
						if "metrics" in data:
							for key in data.metrics:
								var amount:int = data.metrics[key]
								room_config.metrics[key] += amount
		# --------------------------------------------------------------


func scp_run_final_effects(new_room_config:Dictionary) -> void:
	# CALCULATE CONTAINED SCP - LAST THING TO BE COMPUTED
	pass
	#for item in scp_data.contained_list:
		#var floor:int = item.location.floor
		#var ring:int = item.location.ring
		#var room:int = item.location.room	
		#var floor_ring_designation:String = str(floor, ring)
		#var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
		#var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
		#var scp_details:Dictionary = SCP_UTIL.return_data(item.ref)
		
		## run first level effects to get personnel
		#if "personnel" in scp_details.effects:
			#for key in scp_details.effects.personnel:
				#ring_config_data.personnel[key] = scp_details.effects.personnel[key]
				#room_config_data.personnel[key] = scp_details.effects.personnel[key]
		#
		## run first level effects to get metrics		
		#if "metrics" in scp_details.effects:
			#for key in scp_details.effects.metrics:		
				#var amount:int = scp_details.effects.metrics[key]
				#metric_defaults[floor_ring_designation][key] = amount	

func room_final_pass(new_room_config:Dictionary) -> void:
	# final room pass, tally currencies, save final metrics and other props
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var floor_ring_designation:String = str(floor, ring)
		var ring_config:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
			
		# add to ref count
		ring_config.room_refs.push_back(item.ref)
		
		# set room config data
		room_config.room_data = {
			"ref": item.ref,
			"details": ROOM_UTIL.return_data(item.ref), 
		}

func scp_final_pass(new_room_config:Dictionary) -> void:
	for ref in scp_data:
		var sdata:Dictionary = scp_data[ref]
		if !sdata.location.is_empty():
			var floor:int = sdata.location.floor
			var ring:int = sdata.location.ring
			var room:int = sdata.location.room	
			var room_config:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
			# add to room config data
			room_config.scp_data = {
				"ref": ref,
				"details": SCP_UTIL.return_data(ref), 
			}			

func update_room_config(force_setup:bool = false) -> void:
	if !setup_complete:return
	# grab default values
	var new_room_config:Dictionary = initial_values.room_config.call()	
	var new_gameplay_conditionals:Dictionary = initial_values.gameplay_conditionals.call()		

	# EXECUTE IN THIS ORDER
	# zero out defaults 
	setup_default_energy_and_metrics(new_room_config)
	
	# check for buffs/debuffs
	check_for_buffs_and_debuffs(new_room_config)		
	
	# SCP, run first effects
	scp_run_first_effects(new_room_config)
		
	# ROOM, setup and loop
	room_setup_passives_and_ability_level(new_room_config)
	room_passive_check_for_effect(new_room_config)
	room_activation_check(new_room_config)
	room_passive_activation_check(new_room_config)	
	
	# calculte metrics	
	room_calculate_metrics(new_room_config) 
	scp_calculate_metrics(new_room_config)
	room_calculate_curriences(new_room_config)
	
	# final pass	
	scp_run_final_effects(new_room_config)
	room_final_pass(new_room_config)
	scp_final_pass(new_room_config) 
	
	# update subscriptions
	SUBSCRIBE.resources_data = resources_data
	SUBSCRIBE.room_config = new_room_config	
	SUBSCRIBE.gameplay_conditionals = new_gameplay_conditionals
# -----------------------------------
