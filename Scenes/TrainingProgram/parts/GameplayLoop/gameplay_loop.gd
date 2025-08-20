extends PanelContainer

@onready var Structure3dContainer:PanelContainer = $Structure3DContainer
@onready var TimelineContainer:PanelContainer = $TimelineContainer
@onready var MarkedObjectivesContainer:PanelContainer = $MarkedObjectivesContainer
@onready var ActionContainer:PanelContainer = $ActionContainer
@onready var LineDrawContainer:PanelContainer = $LineDrawContainer
@onready var HeaderControl:PanelContainer = $HeaderControl
@onready var PhaseAnnouncement:PanelContainer = $PhaseAnnouncement
@onready var ToastContainer:PanelContainer = $ToastContainer
@onready var WaitContainer:PanelContainer = $WaitContainer

const SetupContainedPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/SetupContainer/SetupContainer.tscn")

enum PHASE { STARTUP, PLAYER, RESOURCE_COLLECTION, RANDOM_EVENTS, CALC_NEXT_DAY, SCHEDULED_EVENTS, CONCLUDE, NUKE_DETONATION, GAME_WON, GAME_LOST }

var options:Dictionary = {}
var is_tutorial:bool = false

# ------------------------------------------------------------------------------	EXPORT VARS
#region EXPORT VARS
var show_structures:bool = false: 
	set(val):
		show_structures = val
		on_show_structures_update()
		
var show_timeline:bool = false : 
	set(val):
		show_timeline = val
		on_show_timeline_update()
		
var show_marked_objectives:bool = false : 
	set(val):
		show_marked_objectives = val
		on_show_marked_objectives_update()

var show_actions:bool = false : 
	set(val):
		show_actions = val
		on_show_actions_update()
		
var show_linedraw:bool = false : 
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
var starting_data:Dictionary

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
	"resource_diff": func() -> Dictionary:
		return { 
			RESOURCE.CURRENCY.MONEY: starting_data.diff[RESOURCE.CURRENCY.MONEY],
			RESOURCE.CURRENCY.MATERIAL: starting_data.diff[RESOURCE.CURRENCY.SCIENCE],
			RESOURCE.CURRENCY.SCIENCE: starting_data.diff[RESOURCE.CURRENCY.MATERIAL],
			RESOURCE.CURRENCY.CORE: starting_data.diff[RESOURCE.CURRENCY.CORE],
		},
	# ----------------------------------
	"resources_data": func() -> Dictionary:
		return { 
			RESOURCE.CURRENCY.MONEY: {
				"amount": starting_data.starting_resources[RESOURCE.CURRENCY.MONEY] + starting_data.resources[RESOURCE.CURRENCY.MONEY] if !DEBUG.get_val(DEBUG.GAMEPLAY_ALL_RESOURCES) else 99, 
				"diff": 0,
				"capacity": 99
			},
			RESOURCE.CURRENCY.SCIENCE: {
				"amount": starting_data.starting_resources[RESOURCE.CURRENCY.SCIENCE] + starting_data.resources[RESOURCE.CURRENCY.SCIENCE] if !DEBUG.get_val(DEBUG.GAMEPLAY_ALL_RESOURCES) else 99, 
				"diff": 0,
				"capacity": 99
			},
			RESOURCE.CURRENCY.MATERIAL: {
				"amount": starting_data.starting_resources[RESOURCE.CURRENCY.MATERIAL] + starting_data.resources[RESOURCE.CURRENCY.MATERIAL] if !DEBUG.get_val(DEBUG.GAMEPLAY_ALL_RESOURCES) else 99, 
				"diff": 0,
				"capacity": 99
			},
			RESOURCE.CURRENCY.CORE: {
				"amount":starting_data.starting_resources[RESOURCE.CURRENCY.CORE] + starting_data.resources[RESOURCE.CURRENCY.CORE] if !DEBUG.get_val(DEBUG.GAMEPLAY_ALL_RESOURCES) else 99, 
				"diff": 0,
				"capacity": 99
			},
		},		
	# ----------------------------------
	"researcher_hire_list": func() -> Array:
		return [],
	# ----------------------------------
	"shop_unlock_purchases": func() -> Array:
		return [],
	# ----------------------------------
	"hints_unlocked": func() -> Array:
		return [],		
	# ----------------------------------
	"room_config": func() -> Dictionary:
		return {
			"base": {
				# --------------  # FLOOR WIDE STATS
				"metrics": {
					RESOURCE.METRICS.MORALE: 0,
					RESOURCE.METRICS.SAFETY: 0,
					RESOURCE.METRICS.READINESS: 0
				},
				"currencies": {
					RESOURCE.CURRENCY.MONEY: 0,
					RESOURCE.CURRENCY.MATERIAL: 0,
					RESOURCE.CURRENCY.SCIENCE: 0,
					RESOURCE.CURRENCY.CORE: 0,
				},
				"staff_capacity": {
					RESEARCHER.SPECIALIZATION.ADMIN: 0,
					RESEARCHER.SPECIALIZATION.RESEARCHER: 0,
					RESEARCHER.SPECIALIZATION.SECURITY: 0,
					RESEARCHER.SPECIALIZATION.DCLASS: 0,
				},
				"room_unlock_val": 0,
				"buffs": [],
				"debuffs": [],
				"onsite_nuke": {
					"triggered": false
				},
			},
			"floor": {
				0: get_floor_default(3),
				1: get_floor_default(3),
				2: get_floor_default(3),
				3: get_floor_default(3),
				4: get_floor_default(3),
				5: get_floor_default(3),
				6: get_floor_default(3),
			}
		},
	# ----------------------------------
	"camera_settings": func() -> Dictionary:
		return {
			"type": CAMERA.TYPE.FLOOR_SELECT,
			"is_locked": true
		},
	# ----------------------------------
	"base_states": func() -> Dictionary:
		var floor:Dictionary = {}
		var ring:Dictionary = {}
		var room:Dictionary = {} 
		
		# ------------------------------
		for floor_index in [0, 1, 2, 3, 4, 5, 6]:
			floor[str(floor_index)] = {
				# if start on ring level, floor 0 starts with power
				"previous_powered": false,
				"buffs": [],
				"debuffs": [],
			} 
			# ------------------------------
			for ring_index in [0, 1, 2, 3]:
				ring[str(floor_index, ring_index)] = {
					"emergency_mode": ROOM.EMERGENCY_MODES.NORMAL,
					"has_containment_breach": false,
					"buffs": [],
					"debuffs": [],
					"power_distribution": {
						"heating": 1,
						"cooling": 1,
						"ventilation": 2,
						"sra": 1,
						"energy": 2 if floor_index in [0, 1] else 1,
					}
				}
				
				# ------------------------------
				for room_index in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
					room[str(floor_index, ring_index, room_index)] = {
						"abl_lvl": 0,
						"is_activated": false,
						"passives_enabled_list": [],
						"passives_enabled": {},
						"ability_on_cooldown": {},
						"events_pending": [],
						"buffs": [],
						"debuffs": [],
					}	

		
		return {
			"metrics": {
				RESOURCE.METRICS.MORALE: 0,
				RESOURCE.METRICS.SAFETY: 0,
				RESOURCE.METRICS.READINESS: 0
			},
			"event_record": {
				# record events and their outcomes
			},
			"base": {
				"onsite_nuke": {
					"triggered": false
				},
				"buffs": [],
				"debuffs": []
			},
			"floor": floor, 	# not currently used for anything
			"ring": ring,
			"room": room		 # not currently used for anything
		},
	# ----------------------------------
	"gameplay_conditionals": func() -> Dictionary:
		return {	
			CONDITIONALS.TYPE.ENABLE_TIMELINE: {
				"val": false,
				"on_change": func(val:bool) -> void:
					pass,
			},
			CONDITIONALS.TYPE.ENABLE_OBJECTIVES: {
				"val": false,
				"on_change": func(val:bool) -> void:
					pass,
			},
			
			CONDITIONALS.TYPE.SHOW_VIBE_IN_HEADER: {
				"val": false,
				"on_change": func(val:bool) -> void:
					pass,
			},
			CONDITIONALS.TYPE.SHOW_MTF_IN_HEADER: {
				"val": false,
				"on_change": func(val:bool) -> void:
					pass,
			},			
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
var hints_unlocked:Array 
var bookmarked_rooms:Array # ["000", "201"] <- "floor_index, ring_index, room_index"]
var unavailable_rooms:Array 
var hired_lead_researchers_arr:Array
var gameplay_conditionals:Dictionary

#endregion
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------	LOCAL DATA
#region LOCAL DATA
var onGameOver:Callable = func() -> void:pass
var onExitGame:Callable = func(_exit_game:bool) -> void:pass

var is_busy:bool = false : 
	set(val):
		is_busy = val
		on_is_busy_update()
		
var setup_complete:bool = false
#var scenario_data:Dictionary
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

var current_phase:PHASE : 
	set(val):
		current_phase = val
		on_current_phase_update()

signal phase_cycle_complete

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
	SUBSCRIBE.subscribe_to_hints_unlocked(self)
	
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
	SUBSCRIBE.unsubscribe_to_hints_unlocked(self)

func _ready() -> void:
	self.modulate = Color(1, 1, 1, 0)

	# initially all animation speed is set to 0 but after this is all ready, set animation speed
	for node in get_all_container_nodes():
		node.set_process(false)
		node.set_physics_process(false)			
	
	# other
	on_is_busy_update()

	# get default showing state
	capture_default_showing_state()

	await U.tick()

	show_only([])

func exit_to_titlescreen() -> void:
	onExitGame.call(false)

func exit_game() -> void:
	onExitGame.call(true)
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	START GAME
#region START GAME
func start() -> void:
	show()
	
	# initially all animation speed is set to 0 but after this is all ready, set animation speed
	set_process(true)
	set_physics_process(true)		
		
	await U.tick()	
	start_new_game()

func restart_game() -> void:
	GBL.loaded_gameplay_data = {}
	setup_complete = false
	await U.tick()
	start_new_game()

func start_new_game() -> void:
	# assign and disable 
	GAME_UTIL.assign_nodes()
	await U.tick()
	GAME_UTIL.disable_taskbar(true)	
	
	var skip_progress_screen:bool = DEBUG.get_val(DEBUG.GAMEPLAY_SKIP_SETUP_PROGRSS)	
	var is_new_game:bool = GBL.loaded_gameplay_data.is_empty()
	var duration:float = 0.02 if skip_progress_screen else 0.5

	# skip_progress_screen assign set to true after the first load screen
	DEBUG.assign(DEBUG.GAMEPLAY_SKIP_SETUP_PROGRSS, true)	

	# set tutorial flag
	is_tutorial = true # options.is_tutorial if "is_tutorial" in options else false
	
	# fade in
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.7)
	
	# -----------------------
	var SetupContainer:Control = SetupContainedPreload.instantiate()
	add_child(SetupContainer)
	SetupContainer.z_index = 9
	SetupContainer.title = "SETTING UP. PLEASE WAIT."
	SetupContainer.subtitle = "Initializing systems..."
	SetupContainer.progressbar_val = 0
	await SetupContainer.activate()
	await SetupContainer.start()	
	

	# 1.) loading game data config
	parse_restore_data()
	await U.set_timeout(duration)	

	# -----------------------
	SetupContainer.subtitle = "Calibrating visual interface..."
	SetupContainer.progressbar_val = 0.2
	await U.set_timeout(duration)	
	# 2.) setup game
	setup_complete = true
	update_room_config()	
		
	# -----------------------
	SetupContainer.subtitle = "Synchronizing mission parameters..."
	SetupContainer.progressbar_val = 0.5
	await U.set_timeout(duration)
	
	# 3.) generate researchers/security/dclass (if new game)
	if is_new_game:
		var staff_debug:bool = DEBUG.get_val(DEBUG.STAFF_DEBUG)
		
		var staff_list:Array = []
		for item in RESEARCHER_UTIL.generate_new_researcher_hires( (starting_data.starting_personnel[RESEARCHER.SPECIALIZATION.ADMIN] + starting_data.personnel[RESEARCHER.SPECIALIZATION.ADMIN]) if !staff_debug else DEBUG.get_val(DEBUG.STAFF_STARTING_ADMIN), RESEARCHER.SPECIALIZATION.ADMIN):
			staff_list.push_back(item)		
		for item in RESEARCHER_UTIL.generate_new_researcher_hires( (starting_data.starting_personnel[RESEARCHER.SPECIALIZATION.RESEARCHER] + starting_data.personnel[RESEARCHER.SPECIALIZATION.RESEARCHER]) if !staff_debug else DEBUG.get_val(DEBUG.STAFF_STARTING_RESEARCHERS), RESEARCHER.SPECIALIZATION.RESEARCHER):
			staff_list.push_back(item)
		for item in RESEARCHER_UTIL.generate_new_researcher_hires( (starting_data.starting_personnel[RESEARCHER.SPECIALIZATION.SECURITY] + starting_data.personnel[RESEARCHER.SPECIALIZATION.SECURITY]) if !staff_debug else DEBUG.get_val(DEBUG.STAFF_STARTING_SECURITY), RESEARCHER.SPECIALIZATION.SECURITY):
			staff_list.push_back(item)
		for item in RESEARCHER_UTIL.generate_new_researcher_hires( (starting_data.starting_personnel[RESEARCHER.SPECIALIZATION.DCLASS] + starting_data.personnel[RESEARCHER.SPECIALIZATION.DCLASS]) if !staff_debug else DEBUG.get_val(DEBUG.STAFF_STARTING_DCLASS), RESEARCHER.SPECIALIZATION.DCLASS):
			staff_list.push_back(item)
		staff_list.reverse()
		
		SUBSCRIBE.hired_lead_researchers_arr = staff_list
		

	# -----------------------
	SetupContainer.subtitle = "Finalizing deployment protocols..."
	SetupContainer.progressbar_val = 0.7
	
	# swap wing and then back to floor to fix the scenes
	camera_settings.type = CAMERA.TYPE.WING_SELECT
	SUBSCRIBE.camera_settings = camera_settings		
	if !DEBUG.get_val(DEBUG.GAMEPLAY_START_AT_RING_LEVEL):
		await U.tick()
		camera_settings.type = CAMERA.TYPE.FLOOR_SELECT
		SUBSCRIBE.camera_settings = camera_settings		

	
	await U.set_timeout(duration)
	# 4.) reset any nodes
	for node in get_all_container_nodes():
		node.set_process(true)
		node.set_physics_process(true)
		node.activate()
		if "on_reset" in node:
			node.on_reset()			
	
	# -----------------------
	# 5.) SETUP OBJECTIVES, progress timeline to correct day
	if is_new_game:
		GAME_UTIL.add_objectives_to_timeline(STORY.get_objectives())		
	else:
		SUBSCRIBE.timeline_array = timeline_array
		SUBSCRIBE.progress_data = progress_data
		

	# ----------------------- LAST PHASE, START EVERYTHING AND REMOVE SETUP
	# then show player hud
	SetupContainer.subtitle = "Initilization simulation."
	SetupContainer.progressbar_val = 1.0	
	restore_player_hud()	
	await U.set_timeout(duration)	
	await SetupContainer.end()	
	
	# start game music
	OS_AUDIO.play(OS_AUDIO.TRACK.GAME_TRACK_ONE)
		
	# then build marked objectives
	GAME_UTIL.mark_current_objectives()
	
	# start actionContainer or start at ring level
	ActionContainer.start()
	HeaderControl.start()
		
	# 6.) CREATE NEW CHECKPOINT IF NEW GAME, 
	# clear all quicksaves/restorespoints/aftersetup
	if is_new_game:
		GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.quicksaves = {}
		GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.restore_checkpoint = {}
		GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.after_setup = {}
		GBL.update_and_save_user_profile()			
	
	current_phase = PHASE.STARTUP
#endregion
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
#region defaults functions
func get_floor_default(array_size:int) -> Dictionary:
	return { 
		# --------------  # FLOOR WIDE STATS
		"metrics": {
			RESOURCE.METRICS.MORALE: 0,
			RESOURCE.METRICS.SAFETY: 0,
			RESOURCE.METRICS.READINESS: 0
		},
		"currencies": {
			RESOURCE.CURRENCY.MONEY: 0,
			RESOURCE.CURRENCY.MATERIAL: 0,
			RESOURCE.CURRENCY.SCIENCE: 0,
			RESOURCE.CURRENCY.CORE: 0,
		},
		"abl_lvl": 0,
		"buffs": [],
		"debuffs": [],
		# --------------
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
		"currencies": {
			RESOURCE.CURRENCY.MONEY: 0,
			RESOURCE.CURRENCY.MATERIAL: 0,
			RESOURCE.CURRENCY.SCIENCE: 0,
			RESOURCE.CURRENCY.CORE: 0,
		},
		"mtf": [],
		"buffs": [],
		"debuffs": [],
		"monitor": {
			"temp": 0,
			"reality": 0,
			"pollution": 0
		},
		"power_distribution": {
			"heating": 0,
			"cooling": 0,
			"ventilation": 0,
			"sra": 0,
			"energy": 0
		},
		# --------------
		"emergency_mode": ROOM.EMERGENCY_MODES.NORMAL,		
		"abl_lvl": 0,
		"energy": {
			"available": 0,
			"used": 0
		},
		# --------------
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
		"currencies": {
			RESOURCE.CURRENCY.MONEY: 0,
			RESOURCE.CURRENCY.MATERIAL: 0,
			RESOURCE.CURRENCY.SCIENCE: 0,
			RESOURCE.CURRENCY.CORE: 0,
		},
		"buffs": [],
		"debuffs": [],		
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
		ActionContainer, 
		TimelineContainer,
		MarkedObjectivesContainer,
		HeaderControl,
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
	var arr:Array = [Structure3dContainer, ActionContainer,  HeaderControl]
	
	if show_marked_objectives:
		arr.push_back(MarkedObjectivesContainer)
		
	if show_timeline:
		arr.push_back(TimelineContainer)
	
	await show_only(arr)
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
# -----------------------------------
func next_day() -> void:
	var objectives:Array = STORY.get_objectives()
	var story_progress:Dictionary = GBL.active_user_profile.story_progress
	var current_objectives:Dictionary = objectives[story_progress.on_chapter]	
	var previous_location:Dictionary = current_location.duplicate(true)
	var previous_camera_setting:Dictionary = camera_settings.duplicate(true)
	
	if base_states.base.onsite_nuke.triggered:
		var res:bool = await GAME_UTIL.create_warning("ONSITE NUCLEAR DEVICE IS ACTIVE!", "Game will end if you continue.", "res://Media/images/Defaults/stop_sign.png")
		if res:
			current_phase = PHASE.NUKE_DETONATION
		return
	
	if !GAME_UTIL.are_objectives_complete() and (progress_data.day + 1) >= current_objectives.complete_by_day:
		var res:bool = await GAME_UTIL.create_warning("OBJECTIVES NOT MET!", "Ignore warning and continue?", "res://Media/images/Defaults/stop_sign.png")
		if res:
			current_phase = PHASE.RESOURCE_COLLECTION
			await phase_cycle_complete
		return

	GAME_UTIL.disable_taskbar(true)
	current_phase = PHASE.RESOURCE_COLLECTION
	await phase_cycle_complete		
	GAME_UTIL.disable_taskbar(false)	
	
	# revert to user location
	SUBSCRIBE.camera_settings = previous_camera_setting
	SUBSCRIBE.current_location = previous_location
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
	
func on_hints_unlocked_update(new_val:Array = hints_unlocked) -> void:
	hints_unlocked = new_val

func on_hired_lead_researchers_arr_update(new_val:Array = hired_lead_researchers_arr) -> void:
	hired_lead_researchers_arr = new_val
	U.debounce("update_room_config", update_room_config)

func on_base_states_update(new_val:Dictionary = base_states) -> void:
	base_states = new_val
	U.debounce("update_room_config", update_room_config)
		
func on_purchased_facility_arr_update(new_val:Array = purchased_facility_arr) -> void:
	purchased_facility_arr = new_val	
	U.debounce("update_room_config", update_room_config)
	
func on_purchased_base_arr_update(new_val:Array = purchased_base_arr) -> void:
	purchased_base_arr = new_val	
	U.debounce("update_room_config", update_room_config)

func on_timeline_array_update(new_val:Array = timeline_array) -> void:
	timeline_array = new_val	
	U.debounce("update_room_config", update_room_config)

func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val
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

func on_show_marked_objectives_update() -> void:
	if !is_node_ready():return
	MarkedObjectivesContainer.is_showing = show_marked_objectives
	showing_states[MarkedObjectivesContainer] = show_marked_objectives

func on_show_linedraw_update() -> void:
	if !is_node_ready():return
	LineDrawContainer.is_showing = show_linedraw
	showing_states[LineDrawContainer] = show_linedraw

func on_show_resources_update() -> void:
	if !is_node_ready():return
	HeaderControl.is_showing = show_resources
	showing_states[HeaderControl] = show_resources

#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	SHOP STEPS
func on_current_phase_update() -> void:
	if !is_node_ready():return	

	match current_phase:
		# ------------------------
		PHASE.STARTUP:
			var story_progress:Dictionary = GBL.active_user_profile.story_progress
			var chapter:Dictionary = STORY.get_chapter( story_progress.on_chapter )			
			
			#if chapter.has("tutorial") and is_tutorial:
				#await GAME_UTIL.play_tutorial(chapter)
				
			# show objectives
			if !DEBUG.get_val(DEBUG.GAMEPLAY_SKIP_OBJECTIVES):
				await GAME_UTIL.open_objectives()
				
			current_phase = PHASE.PLAYER
		# ------------------------
		PHASE.PLAYER:
			await restore_player_hud()			
			GAME_UTIL.disable_taskbar(false)
			await U.set_timeout(0.4)

		# ------------------------
		PHASE.RESOURCE_COLLECTION:
			await show_only([Structure3dContainer, TimelineContainer])
			current_location_snapshot = {
				"floor": current_location.floor,
				"ring": current_location.ring,
				"room": current_location.room
			}
			
			camera_settings_snapshot = camera_settings.duplicate(true)
			
			# hide objectives
			show_marked_objectives = false
			

			PhaseAnnouncement.start("RESOURCE COLLECTION")	
			await GAME_UTIL.open_tally( RESOURCE_UTIL.return_diff() )
			
			
			current_phase = PHASE.CALC_NEXT_DAY
		# ------------------------
		PHASE.CALC_NEXT_DAY:
			PhaseAnnouncement.start("ADVANCING THE DAY")	
			
			# ADD TO PROGRESS DATA day count
			progress_data.day += 1

			# first, get list of rooms that will be completed in order of floor -> ring -> room
			var construction_complete:Dictionary = {}
			var previous_ring:int = -1
			var previous_floor:int = -1
			var build_count:int = 0
			
			for floor_index in room_config.floor.size():		
				var floor_list:Dictionary = {}
				for ring_index in room_config.floor[floor_index].ring.size():
					var ring_list:Array = []
					for room_index in room_config.floor[floor_index].ring[ring_index].room.size():
						var power_distribution:Dictionary = room_config.floor[floor_index].ring[ring_index].power_distribution
						
						var filtered:Array = purchased_facility_arr.filter(func(x):
							if x.location.floor == floor_index and x.location.ring == ring_index and x.location.room == room_index:
								var floor_base_state:Dictionary = base_states.floor[str(x.location.floor)]
								return power_distribution.energy > 0 and x.under_construction
							return false
						)
						if !filtered.is_empty():
							ring_list.push_back(filtered[0])
							build_count += 1
					floor_list[ring_index] = ring_list
				construction_complete[floor_index] = floor_list

									
			# jump to each room...
			if build_count > 0:
				# change to wing view
				if camera_settings.type != CAMERA.TYPE.WING_SELECT:
					camera_settings.type = CAMERA.TYPE.WING_SELECT
					SUBSCRIBE.camera_settings = camera_settings
					await U.set_timeout(0.3)
				
				# jump to room and show the build
				for floor_index in construction_complete:
					var ring_list:Dictionary = construction_complete[floor_index]
					if !ring_list.is_empty():
						for ring_index in ring_list:
							var room_list:Array = ring_list[ring_index]
							if !room_list.is_empty():
								# first, move camera to this floor and ring
								previous_floor = current_location.floor
								previous_ring = current_location.ring
								var first_item:Dictionary = room_list[0]
								SUBSCRIBE.current_location = {"floor": first_item.location.floor, "ring": first_item.location.ring, "room": 4}
								await U.set_timeout(0.2)
								# wait for transistion...
								
								# now update the state of all the rooms on that ring at once
								for item in room_list:
									await ROOM_UTIL.finish_construction(item.location)
								
								# wait for animation
								await U.set_timeout(0.3)
						
			# reduce cooldown in abilities
			for floor_index in room_config.floor.size():		
				for ring_index in room_config.floor[floor_index].ring.size():
					for room_index in room_config.floor[floor_index].ring[ring_index].room.size() :
						var room_designation:String = str(floor_index, ring_index, room_index)
						if room_designation in base_states.room[room_designation]:
							for key in base_states.room[room_designation].ability_on_cooldown:
								if base_states.room[room_designation].ability_on_cooldown[key] > 0:
									base_states.room[room_designation].ability_on_cooldown[key] -= 1
									if base_states.room[room_designation].ability_on_cooldown[key] == 0:
										ToastContainer.add("[%s] is ready!" % [key])
			
			for facility in purchased_facility_arr:
				var room_details:Dictionary = ROOM_UTIL.return_data(facility.ref)				
				var room_base_state:Dictionary = GAME_UTIL.get_room_base_state(facility.location) 
				for event in room_details.event_triggers.conditionals:
					# first check if condition has been met
					var condition_met:bool = event.check.call(facility.location)
					if !condition_met:
						break
					# then check if event is repeatable
					var is_repeatable:bool = EVENT_UTIL.return_data(event.ref).is_repeatable
					
					# check if event has not occurred yet OR it has occured but it's repeatable
					if (event.ref not in base_states.event_record) or (event.ref in base_states.event_record and is_repeatable):
						
						# then add it to events_pending
						if event.ref not in room_base_state.events_pending:
							GAME_UTIL.add_room_event(event.ref, facility.location)
					
			# update subscriptions
			SUBSCRIBE.progress_data = progress_data
			SUBSCRIBE.base_states = base_states
			
			await U.set_timeout(0.5)
			current_phase = PHASE.SCHEDULED_EVENTS
		# ------------------------
		PHASE.SCHEDULED_EVENTS:
			PhaseAnnouncement.start("EVENTS")	
			await U.set_timeout(0.5)
			
			# CHECK FOR SCP BREACH EVENTS
			var event_breach_refs:Array = []
			var event_final_containment:Array = []
			#var previous_track:OS_AUDIO.TRACK = SUBSCRIBE.music_data.selected

			for ref in scp_data:
				var data:Dictionary = scp_data[ref]
				var scp_details:Dictionary = SCP_UTIL.return_data(ref)
				var breach_event_chance:int = SCP_UTIL.get_breach_event_chance(ref, data.location)	
				var random_int:int = U.generate_rand(0, 100)
				var is_contained:bool = data.is_contained
				var contained_for_total:int = data.contained_on_day + progress_data.day
				var contained_on_day:int = scp_details.days_until_contained + data.contained_on_day
				
				if !is_contained:
					if (progress_data.day >= contained_on_day):
						event_final_containment.push_back(ref)
					
					# check and add event breachs
					if (random_int < breach_event_chance) and (ref not in event_final_containment):
						event_breach_refs.push_back(ref)
						
			# start breach splash
			if event_breach_refs.size() > 0:
				PhaseAnnouncement.end()
				# then do them...
				for index in event_breach_refs.size():
					await GAME_UTIL.trigger_breach_event(event_breach_refs[index])
			
			# start breach splash
			if event_final_containment.size() > 0:
				PhaseAnnouncement.end()				
				# then do them...
				for index in event_final_containment.size():
					await GAME_UTIL.trigger_containment_event(event_final_containment[index])						
			
			# CHECK FOR TIMELINE EVENTS			
			var timeline_filter:Array = timeline_array.filter(func(i): return i.day == progress_data.day and !i.event.is_empty())	
			if timeline_filter.size() > 0:
				for item in timeline_filter:
					var event_data:Dictionary = EVENT_UTIL.return_data(item.event.ref)
					var previous_emergency_mode:int = base_states.ring[str(current_location.floor, current_location.ring)].emergency_mode
					if event_data.timeline.has("emergency_mode"):
						base_states.ring[str(current_location.floor, current_location.ring)].emergency_mode = event_data.timeline.emergency_mode
						SUBSCRIBE.base_states = base_states
						
						# open music player, no music selected
						#SUBSCRIBE.music_data = {
							#"selected": OS_AUDIO.TRACK.SCP_CONTAINMENT_BREACH,
						#}
						
						await U.set_timeout(1.5)
					
					await GAME_UTIL.trigger_event([EVENT_UTIL.run_event(
						item.event.ref,
							{
								"timeline": event_data.timeline,
								"onSelection": func(selection:Dictionary) -> void:
									print(selection),
							}
						)
					])	
					
					base_states.ring[str(current_location.floor, current_location.ring)].emergency_mode = previous_emergency_mode
					SUBSCRIBE.base_states = base_states
			
			# restore previous music and location
			#SUBSCRIBE.music_data = {
				#"selected": previous_track,
			#}

			#print( event_triggers.conditionals )
						
						
			
			# next
			current_phase = PHASE.CONCLUDE
		# ------------------------	
		PHASE.NUKE_DETONATION:
			PhaseAnnouncement.start("NUCLEAR DETONATION IMMINENT")
			await show_only([Structure3dContainer])
			PhaseAnnouncement.end()
			
			await U.set_timeout(2.0)
			
			current_phase = PHASE.GAME_LOST
		# ------------------------
		PHASE.CONCLUDE:
			# CHECK IF SCENARIO DATA IS COMPLETE
			var objectives:Array = STORY.get_objectives()
			var story_progress:Dictionary = GBL.active_user_profile.story_progress
			var current_objectives:Dictionary = objectives[story_progress.on_chapter]
						
			# check for objectivess fail/succeed on appropriate day
			if progress_data.day >= current_objectives.complete_by_day:
				PhaseAnnouncement.start("CHECKING OBJECTIVES")
				await U.set_timeout(0.5)				

				# CHECK FOR FAIL STATE
				var is_complete:bool = GAME_UTIL.are_objectives_complete()
				current_phase = PHASE.GAME_LOST if !is_complete else PHASE.GAME_WON
				return
			
			# continue
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
			PhaseAnnouncement.end()
				
			# fetch next objective, update objective
			var story_progress:Dictionary = GBL.active_user_profile.story_progress
			var chapter:Dictionary = STORY.get_chapter( story_progress.on_chapter )

			# trigger reward event
			await GAME_UTIL.trigger_event([EVENT_UTIL.run_event(
				EVT.TYPE.OBJECTIVE_REWARD, 
					{
						"rewarded": chapter.rewarded.call() if chapter.has("rewarded") else [],
						"onSelection": func(selection:Dictionary) -> void:
							await selection.func.call(),
					}
				)
			])	
						
			
			# update story...
			GAME_UTIL.increament_story()

			# increament current story val
			var next_chapter = STORY.get_chapter(GBL.active_user_profile.story_progress.on_chapter )
			var show_new_message:bool = "story_message" in next_chapter

			#
			# also this checkpoint ONLY ONCE
			if GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.after_setup.is_empty():
				create_after_setup_restore_point()
				
			
			# create a restore point
			create_checkpoint()
			
			# update objectives
			PhaseAnnouncement.start("OBJECTIVES ARE BEING UPDATED...")
			await U.set_timeout(1.5)
			await PhaseAnnouncement.end()		
			
			await GAME_UTIL.open_objectives()
			# update bookmarked objectives
			GAME_UTIL.mark_current_objectives()
			
			#await quicksave(true)			
			
			if show_new_message:
				ActionContainer.show_new_message_btn = true
			
			# continue game
			restore_player_hud()			
			current_phase = PHASE.PLAYER
			phase_cycle_complete.emit()
		# ------------------------
		PHASE.GAME_LOST:
			PhaseAnnouncement.start("FAILED TO MEET OBJECTIVES...")	
			onGameOver.call()
			return
		# ------------------------
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------	SAVE/LOAD
#region SAVE/LOAD
func get_save_state() -> Dictionary:
	var story_progress:Dictionary = GBL.active_user_profile.story_progress

	return {
		"metadata":{
			"modification_date": Time.get_date_dict_from_system()
		},		
		"on_chapter": story_progress.on_chapter,
		# NOTE: ROOM CONFIG IS NEVER SAVED: IT IS READ-ONLY AS IT IS CREATED AS BY-PRODUCT
		"progress_data": progress_data,		
		"scp_data": scp_data,
		"timeline_array": timeline_array,
		"gameplay_conditionals": gameplay_conditionals,
		"purchased_base_arr": purchased_base_arr,
		"purchased_facility_arr": purchased_facility_arr,
		"purchased_research_arr": purchased_research_arr,
		"hints_unlocked": hints_unlocked,
		"hired_lead_researchers_arr": hired_lead_researchers_arr,
		"resources_data": resources_data,
		"bookmarked_rooms": bookmarked_rooms,
		"researcher_hire_list": researcher_hire_list,
		"shop_unlock_purchases": shop_unlock_purchases,
		"base_states": base_states,
	}.duplicate(true)

func quicksave(skip_timeout:bool = false) -> void:
	is_busy = true

	GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.quicksaves = get_save_state()	

	# update and save user profile
	GBL.update_and_save_user_profile()
	
	if !skip_timeout:
		await U.set_timeout(1.0)
		
	is_busy = false


func create_after_setup_restore_point(skip_timeout:bool = false) -> void:
	is_busy = true
	
	GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.after_setup = get_save_state()
	
	# update and save user profile
	GBL.update_and_save_user_profile()	
	
	if !skip_timeout:
		await U.set_timeout(1.0)
	is_busy = false
	

func create_checkpoint(skip_timeout:bool = false) -> void:
	is_busy = true
	
	GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.restore_checkpoint = get_save_state()
	
	# update and save user profile
	GBL.update_and_save_user_profile()	
	
	if !skip_timeout:
		await U.set_timeout(1.0)
	is_busy = false
	

func load_checkpoint() -> void:
	var restore_checkpoint:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.restore_checkpoint
	if restore_checkpoint.is_empty():return
	GBL.loaded_gameplay_data = restore_checkpoint	
	
	await U.tick()
	start_new_game()

func parse_restore_data() -> void:
	var restore_data:Dictionary = GBL.loaded_gameplay_data
	var is_new_game:bool = restore_data.is_empty() 

	# modify if starting a new game
	var resources_data:Dictionary = initial_values.resources_data.call() if is_new_game else restore_data.resources_data	
	SUBSCRIBE.resources_data = resources_data
	
	# any rooms completed by scenarios become allowed
	SUBSCRIBE.awarded_rooms = [] #	game_data_config.awarded_rooms
	SUBSCRIBE.bookmarked_objectives = [] # always starts blank
	
	# reactive data
	SUBSCRIBE.progress_data = initial_values.progress_data.call() if is_new_game else restore_data.progress_data
	SUBSCRIBE.scp_data = initial_values.scp_data.call() if is_new_game else restore_data.scp_data
	SUBSCRIBE.timeline_array = initial_values.timeline_array.call() if is_new_game else restore_data.timeline_array
	#SUBSCRIBE.gameplay_conditionals = initial_values.gameplay_conditionals.call() #if no_save else restore_data.gameplay_conditionals	
	SUBSCRIBE.purchased_facility_arr = initial_values.purchased_facility_arr.call() if is_new_game else restore_data.purchased_facility_arr  
	SUBSCRIBE.purchased_base_arr = initial_values.purchased_base_arr.call() if is_new_game else restore_data.purchased_base_arr
	SUBSCRIBE.bookmarked_rooms = initial_values.bookmarked_rooms.call() if is_new_game else restore_data.bookmarked_rooms
	SUBSCRIBE.hints_unlocked = initial_values.hints_unlocked.call() if is_new_game else restore_data.hints_unlocked
	
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
func update_room_config(force_setup:bool = false) -> void:
	if !setup_complete:return
	# grab default values
	var new_room_config:Dictionary = initial_values.room_config.call()	
	var new_gameplay_conditionals:Dictionary = initial_values.gameplay_conditionals.call()		
	var resource_diff:Dictionary = initial_values.resource_diff.call()

	# add to starting diff to resources_diff
	for key in resource_diff:
		resources_data[key].diff = resource_diff[key]

	# EXECUTE IN THIS ORDER
	# zero out defaults 
	transfer_base_states_to_room_config(new_room_config)
	## check if room is activated
	room_activation_check(new_room_config)
	
	# ROOM, check for effects
	room_check_for_effects(new_room_config)	
	scp_check_for_effects(new_room_config)	
	
	# ROOM, setup and loop
	room_setup_passives_and_ability_level(new_room_config, new_gameplay_conditionals)
	
	# check for buffs/debuffs
	check_for_buffs_and_debuffs(new_room_config)		
	# check for passives
	room_passive_check_for_effect(new_room_config)	
	
	# check after effects
	room_check_for_after_effects(new_room_config)	
	
	# add metrics/currencies
	room_calculate(new_room_config)
	scp_calculate(new_room_config)
#
	# trigger any gameplay conditional effects
	for key in new_gameplay_conditionals:
		var conditional_dict:Dictionary = new_gameplay_conditionals[key]
		var val = conditional_dict.val
		if "on_change" in conditional_dict:
			conditional_dict.on_change.call(val)
		
	# then go through each floor and add/sub from the diff
	for floor_index in new_room_config.floor.size():
		var floor_level:Dictionary = new_room_config.floor[floor_index]
		for key in floor_level.currencies:
			var amount:int = floor_level.currencies[key]
			resource_diff[key] += amount
	

	SUBSCRIBE.resources_data = resources_data
	SUBSCRIBE.room_config = new_room_config	
	SUBSCRIBE.gameplay_conditionals = new_gameplay_conditionals
	
func transfer_base_states_to_room_config(new_room_config:Dictionary) -> void:
	# energy availble per levels
	const energy_levels:Array = [0, 5, 10, 15]
	
	# duplicate base config nuke status
	new_room_config.base.onsite_nuke = base_states.base.onsite_nuke.duplicate()
	#new_room_config.base.generator_level = base_states.base.generator_level
	#new_room_config.base.generator_energy = base_states.base.generator_energy
	
	# FLOOR LEVEL ------------- 
	for floor_index in new_room_config.floor.size():
		var floor_base_state:Dictionary = base_states.floor[str(floor_index)]
		var floor_level:Dictionary = new_room_config.floor[floor_index]
		
		# set is_powered state
		#floor_level.is_powered = floor_base_state.is_powered
		
		# RING LEVEL ------------- 
		for ring_index in new_room_config.floor[floor_index].ring.size():
			var ring_base_state:Dictionary = base_states.ring[str(floor_index, ring_index)]			
			var ring_level_config:Dictionary = new_room_config.floor[floor_index].ring[ring_index]

			# setup initial energy
			ring_level_config.energy.available = energy_levels[ring_base_state.power_distribution.energy - 1] if !DEBUG.get_val(DEBUG.GAMEPLAY_MAX_ENERGY) else 99
			ring_level_config.energy.used = 0
			#ring_level.is_ventilated = ring_base_state.is_ventilated
			#ring_level.is_overheated = ring_base_state.is_overheated
			
			# transfer power_distribution
			ring_level_config.power_distribution = ring_base_state.power_distribution
			
			# TODO: swap 0 for heat, pollution, reality generated from room
			ring_level_config.monitor.temp =  U.min_max(0 + (ring_base_state.power_distribution.heating - 1) - (ring_base_state.power_distribution.cooling - 1), -3, 3) 
			ring_level_config.monitor.reality = U.min_max(0 - (ring_base_state.power_distribution.sra - 1), 0, 3)  
			ring_level_config.monitor.pollution = U.min_max(0 - (ring_base_state.power_distribution.ventilation - 1), 0, 3) 
			
			# set emergency mode
			if base_states.base.onsite_nuke.triggered:
				ring_level_config.emergency_mode = ROOM.EMERGENCY_MODES.DANGER
			else:
				ring_level_config.emergency_mode = ring_base_state.emergency_mode
				
			# ROOM LEVEL ------------- 
			for room_index in new_room_config.floor[floor_index].ring[ring_index].room.size():
				var room_base_state:Dictionary = base_states.room[str(floor_index, ring_index, room_index)]			
				var room_level:Dictionary = new_room_config.floor[floor_index].ring[ring_index].room[room_index]
				
				# room level ability level
				room_level.abl_lvl = room_base_state.abl_lvl
				room_level.is_activated = room_base_state.is_activated

func check_for_buffs_and_debuffs(new_room_config:Dictionary) -> void:
	var floor_added:Array = []
	var ring_added:Array = []
	var room_added:Array = []
		
	# --------------------------------------------------------------		ADD BUFFS/DEBUFFS at the BASE level
	var base_level:Dictionary = new_room_config.base
	for prop in ["buffs", "debuffs"]:	
		for item in base_states.base[prop]:
			if (prop == "buffs" and !base_states.base.onsite_nuke.triggered or prop == "debuffs"):
				var data:Dictionary = BASE_UTIL.return_buff(item.ref) if prop == "buffs" else BASE_UTIL.return_debuff(item.ref)
				base_level[prop].push_back({"data": data, "duration": item.duration})
				if "metrics" in data:
					for key in data.metrics:
						var amount:int = data.metrics[key]
						base_level.metrics[key] += amount
				if "effect" in data:
					data.effect.call(new_room_config)
	# --------------------------------------------------------------

	# --------------------------------------------------------------
	for floor_index in new_room_config.floor.size():
		var floor_level:Dictionary = new_room_config.floor[floor_index]

		for ring_index in new_room_config.floor[floor_index].ring.size():
			var ring_level:Dictionary = new_room_config.floor[floor_index].ring[ring_index]				

			for room_index in new_room_config.floor[floor_index].ring[ring_index].room.size():
				var room_level:Dictionary = new_room_config.floor[floor_index].ring[ring_index].room[room_index]				

				var floor_designation:String = str(floor_index)
				var floor_base_state:Dictionary = base_states.floor[floor_designation]
				
				var ring_designation:String = str(floor_index, ring_index)
				var ring_base_state:Dictionary = base_states.ring[ring_designation]
				
				var room_designation:String = str(floor_index, ring_index, room_index)
				var room_base_state:Dictionary = base_states.room[room_designation]

				# --------------------------------------------------------------		FLOOR BUFFS/DEBUFFS
				if floor_designation not in floor_added:
					floor_added.push_back(floor_designation)
					
					for prop in ["buffs", "debuffs"]:
						# buffs only work when nuke is NOT triggered	
						if (prop == "buffs" and !base_states.base.onsite_nuke.triggered or prop == "debuffs"):						
							for item in floor_base_state[prop]:
								var data:Dictionary = BASE_UTIL.return_buff(item.ref) if prop == "buffs" else BASE_UTIL.return_debuff(item.ref)
								floor_level[prop].push_back({"data": data, "duration": item.duration})
								
								if "metrics" in data:
									for key in data.metrics:
										var amount:int = data.metrics[key]
										floor_level.metrics[key] += amount
								if "effect" in data:
									data.effect.call(new_room_config)
				# --------------------------------------------------------------
				
				# --------------------------------------------------------------		FLOOR BUFFS/DEBUFFS
				if ring_designation not in ring_added:
					var power_distribution:Dictionary = ring_base_state.power_distribution
					
					# TODO CHANGE THIS LATER
					#if power_distribution.ventilation == 1:
						#var data:Dictionary = BASE_UTIL.return_debuff(BASE.DEBUFF.MIASMA)
						#ring_level.debuffs.push_back({"data": data, "duration": 100})
						
					if power_distribution.energy > 1:
						var data:Dictionary = BASE_UTIL.return_buff(BASE.BUFF.POWERED)
						ring_level.buffs.push_back({"data": data, "duration": 100})
					else:
						var data:Dictionary = BASE_UTIL.return_debuff(BASE.DEBUFF.UNPOWERED)
						ring_level.debuffs.push_back({"data": data, "duration": 100})
				

					ring_added.push_back(ring_designation)
					for prop in ["buffs", "debuffs"]:	
						# buffs only work when nuke is NOT triggered	
						if (prop == "buffs" and !base_states.base.onsite_nuke.triggered or prop == "debuffs"):						
							for item in ring_base_state[prop]:
								var data:Dictionary = BASE_UTIL.return_buff(item.ref) if prop == "buffs" else BASE_UTIL.return_debuff(item.ref)
								ring_level[prop].push_back({"data": data, "duration": item.duration})
								if "metrics" in data:
									for key in data.metrics:
										var amount:int = data.metrics[key]
										ring_level.metrics[key] += amount								
				# --------------------------------------------------------------
				
				# --------------------------------------------------------------		FLOOR BUFFS/DEBUFFS
				if room_designation not in room_added:
					room_added.push_back(room_designation)
					for prop in ["buffs", "debuffs"]:	
						# buffs only work when nuke is NOT triggered	
						if (prop == "buffs" and !base_states.base.onsite_nuke.triggered or prop == "debuffs"):						
							for item in room_base_state[prop]:
								var data:Dictionary = BASE_UTIL.return_buff(item.ref) if prop == "buffs" else BASE_UTIL.return_debuff(item.ref)
								room_level[prop].push_back({"data": data, "duration": item.duration})
								if "metrics" in data:
									for key in data.metrics:
										var amount:int = data.metrics[key]
										room_level.metrics[key] += amount								
				# --------------------------------------------------------------				
				
func room_setup_passives_and_ability_level(new_room_config:Dictionary, new_gameplay_conditionals:Dictionary) -> void:
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var floor_config_data:Dictionary = new_room_config.floor[floor]
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
				
				if room_base_state.passives_enabled[ability_uid]:
					if "mtf_ref" in ability:
						ring_config_data.mtf.push_back(ability.mtf_ref)
					if "base_effect" in ability:
						ability.base_effect.call(new_room_config.base)
					if "floor_effect" in ability:
						ability.floor_effect.call(floor_config_data)
					if "ring_effect" in ability:
						ability.ring_effect.call(ring_config_data)
					if "room_effect" in ability:
						ability.room_effect.call(room_config_data)
					if "conditionals" in ability:
						for conditional in ability.conditionals:
							new_gameplay_conditionals[conditional].val = true
							
func room_check_for_effects(new_room_config:Dictionary) -> void:
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var floor_config_data:Dictionary = new_room_config.floor[floor]
		var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]		
		var room_base_state:Dictionary = base_states.room[str(floor, ring, room)]
		var room_config:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
		var is_activated:bool = room_config.is_activated
	
		var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)		
		if !room_data.effect.is_empty() and is_activated:
			if room_data.effect.has("func"):
				new_room_config = room_data.effect.func.call( new_room_config, item )
			

func room_check_for_after_effects(new_room_config:Dictionary) -> void:
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var floor_config_data:Dictionary = new_room_config.floor[floor]
		var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]		
		var room_base_state:Dictionary = base_states.room[str(floor, ring, room)]
		var room_config:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
		var is_activated:bool = room_config.is_activated
	
		var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)		
		if !room_data.effect.is_empty() and is_activated:
			if room_data.effect.has("after_func"):
				new_room_config = room_data.effect.after_func.call( new_room_config, item )			
		
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
		var is_activated:bool = room_config.is_activated
		
		# if passives are enabled...
		if room_data.has("passive_abilities"):
			var passive_abilities:Array = room_data.passive_abilities.call()
			for ability_index in passive_abilities.size():
				var ability:Dictionary = passive_abilities[ability_index]
				var ability_uid:String = str(room_data.ref, ability_index)
				var energy_cost:int = ability.energy_cost if "energy_cost" in ability else 1
				var room_abl_lvl:int = new_room_config.floor[floor].ring[ring].room[room].abl_lvl
				var wing_abl_lvl:int = new_room_config.floor[floor].ring[ring].abl_lvl
				var abl_lvl:int = ROOM_UTIL.get_room_ability_level(item.location)

				if !is_activated:
					room_base_state.passives_enabled_list.erase(ability.ref)
					return
					
				# check if passive is enabled
				if room_base_state.passives_enabled[ability_uid]:
					# check if level is equal or less then what is required...
					# aand check if check if enough energy available to power the passive
					if ability.lvl_required <= abl_lvl and ring_config.energy.used < ring_config.energy.available:
						# if it's enabled, add to energy cost
						ring_config.energy.used += energy_cost
						room_config.energy_used += energy_cost
						
						# add to list of enabled passives
						if ability.ref not in room_base_state.passives_enabled_list:
							room_base_state.passives_enabled_list.push_back(ability.ref)

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
							
					# not enough energy or below room requirment level, deactivate and remove from list
					else:
						room_base_state.passives_enabled[ability_uid] = false
						room_base_state.passives_enabled_list.erase(ability.ref)
				else:
					# ability not active, remove from list
					room_base_state.passives_enabled_list.erase(ability.ref)
								
func room_activation_check(new_room_config:Dictionary) -> void:
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room		
		var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]		
		var is_under_construction:bool = item.under_construction
		var energy_availble:int = ring_config_data.energy.available - ring_config_data.energy.used
		
		# check if activated
		var room_details:Dictionary = ROOM_UTIL.return_data(item.ref)	
		var required_staffing:Array = room_details.required_staffing
		var assigned_to_room_count:int = hired_lead_researchers_arr.filter(func(x): 
			var researcher_data:Dictionary = RESEARCHER_UTIL.get_user_object(x) 
			return !researcher_data.props.assigned_to_room.is_empty() and (item.location == researcher_data.props.assigned_to_room) 
		).size()
		
		# apply is activated state if have enough staff and enough energy
		if energy_availble >= room_details.required_energy:
			room_config_data.is_activated = required_staffing.size() == assigned_to_room_count
			ring_config_data.energy.used += room_details.required_energy
			room_config_data.energy_used += room_details.required_energy
		else:
			room_config_data.is_activated = false
		

		# if activated, then check if room has additional properties
		if room_config_data.is_activated:
			for key in room_details.personnel_capacity:
				var amount:int = room_details.personnel_capacity[key]
				new_room_config.base.staff_capacity[key] += amount
		



func room_calculate(new_room_config:Dictionary) -> void:
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var floor_config_data:Dictionary = new_room_config.floor[floor]
		var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]

		if room_config_data.is_activated:
			var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)
			# tally their currencies
			for key in room_config_data.currencies:
				if key in room_data.currencies:
					var amount:int = room_data.currencies[key]
					# add to totals
					#floor_config_data.currencies[key] += amount
					#ring_config_data.currencies[key] += amount
					room_config_data.currencies[key] += amount
					
			# tally metrics
			for key in room_data.metrics:
				var amount:int = room_data.metrics[key]
				#ring_config_data.metrics[key] += amount
				room_config_data.metrics[key] += amount
		
					
		room_config_data.room_data = {
			"ref": item.ref,
			"details": ROOM_UTIL.return_data(item.ref), 
		}				

func scp_check_for_effects(new_room_config:Dictionary) -> void:
	for ref in scp_data:
		var sdata:Dictionary = scp_data[ref]
		if !sdata.location.is_empty():
			var floor:int = sdata.location.floor
			var ring:int = sdata.location.ring
			var room:int = sdata.location.room	
			var floor_config_data:Dictionary = new_room_config.floor[floor]
			var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
			var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
			
			var scp_details:Dictionary = SCP_UTIL.return_data(ref)
			if !scp_details.effect.is_empty():				
				if scp_details.effect.has("func"):					
					new_room_config = scp_details.effect.func.call( new_room_config, sdata )



func scp_calculate(new_room_config:Dictionary) -> void:
	for ref in scp_data:
		var sdata:Dictionary = scp_data[ref]
		if !sdata.location.is_empty():
			var floor:int = sdata.location.floor
			var ring:int = sdata.location.ring
			var room:int = sdata.location.room	
			var floor_config_data:Dictionary = new_room_config.floor[floor]
			var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
			var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
			
			if room_config_data.is_activated:
				var scp_details:Dictionary = SCP_UTIL.return_data(ref)
				for key in room_config_data.currencies:
					if key in scp_details.currencies:
						var amount:int = scp_details.currencies[key]
						# add to totals
						floor_config_data.currencies[key] += amount
						ring_config_data.currencies[key] += amount
						room_config_data.currencies[key] = amount

				# add to ring level metrics
				for key in scp_details.metrics:
					var amount:int = scp_details.metrics[key]
					ring_config_data.metrics[key] += amount
					room_config_data.metrics[key] += amount
					
			room_config_data.scp_data = {
				"ref": ref,
				"details": SCP_UTIL.return_data(ref), 
			}			
				
# -----------------------------------
