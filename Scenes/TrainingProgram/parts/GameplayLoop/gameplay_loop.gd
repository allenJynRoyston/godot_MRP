extends PanelContainer

@onready var Structure3dContainer:Control = $Structure3DContainer

@onready var TimelineContainer:PanelContainer = $TimelineContainer
@onready var ActionContainer:PanelContainer = $ActionContainer
@onready var DialogueContainer:MarginContainer = $DialogueContainer
@onready var ResourceContainer:Control = $ResourceContainer
@onready var ObjectivesContainer:PanelContainer = $ObjectivesContainer
@onready var LineDrawContainer:PanelContainer = $LineDrawContainer
@onready var PhaseAnnouncement:PanelContainer = $PhaseAnnouncement
@onready var ToastContainer:PanelContainer = $ToastContainer

@onready var RoomInfo:PanelContainer = $RoomInfo
@onready var FloorInfo:PanelContainer = $FloorInfo

@onready var ConfirmModal:PanelContainer = $ConfirmModal
@onready var WaitContainer:PanelContainer = $WaitContainer
@onready var SetupContainer:PanelContainer = $SetupContainer

var BuildContainer:Control 
var SCPSelectScreen:Control 
var SelectResearcherScreen:Control
var StoreContainer:Control
var EventContainer:Control 

const EventContainerPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/EventContainer/EventContainer.tscn")
const StoreContainerPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/StoreContainer/StoreContainer.tscn")
const SelectResearcherScreenPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/SelectResearcherScreen/SelectResearcherScreen.tscn")
const ScpSelectScreenPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/SCPSelectScreen/SCPSelectScreen.tscn")
const ResearcherPromotionScreenPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResearcherPromotionScreen/ResearcherPromotionScreen.tscn")
const BuildContainerPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/BuildContainer/BuildContainer.tscn")
const ResearchersContainerPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResearchersContainer/ResearchersContainer.tscn")

enum PHASE { STARTUP, PLAYER, RESOURCE_COLLECTION, RANDOM_EVENTS, CALC_NEXT_DAY, SCHEDULED_EVENTS, CONCLUDE, GAME_WON, GAME_LOST }

enum OBJECTIVES_STATE {
	HIDE, 
	SHOW
}

enum SHOP_STEPS {
	RESET, 
	OPEN
}

enum BUILDER_STEPS {
	RESET, 
	OPEN
}

enum RECRUIT_STEPS {
	RESET, 
	OPEN
}

enum CONTAIN_STEPS {
	RESET, START, SHOW, PLACEMENT, CONFIRM_PLACEMENT, 
	ON_REJECT, ON_TRANSFER_CANCEL, 
	ON_TRANSFER_TO_NEW_LOCATION, 
	CONFIRM, FINALIZE
}

enum ACTION_COMPLETE_STEPS {RESET, START, FINALIZE}
enum SUMMARY_STEPS {RESET, START, DISMISS}
enum RESEARCHERS_STEPS {RESET, DETAILS_ONLY, ASSIGN, PROMOTE}
enum EVENT_STEPS {RESET, START}
enum SELECT_SCP_STEPS { RESET, START }
enum PROMOTE_RESEARCHER_STEPS { RESET, START }

# ------------------------------------------------------------------------------	EXPORT VARS
#region EXPORT VARS
#@export var skip_progress_screen:bool = true
#@export var debug_energy:bool = false
#@export var debug_personnel:bool = false

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

var show_objectives:bool = false : 
	set(val):
		show_objectives = val
		on_show_objectives_update()		

var show_dialogue:bool = false : 
	set(val):
		show_dialogue = val
		on_show_dialogue_update()
		
var show_linedraw:bool = true : 
	set(val):
		show_linedraw = val
		on_show_linedraw_update()
		
var show_confirm_modal:bool = false : 
	set(val):
		show_confirm_modal = val
		on_show_confirm_modal_update()
		
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
			"available_refs": [
				#	"ref0", "ref1", "ref2"
			],
			"contained_list": [
				#{ 
					#"ref": item.data.ref,
					#"progression": {
						#"research_level": 0,
						#"path_unlocks": [],
						#"progression": {}
					#}
				#}		
			],
			"lock": {
				
			}
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
				"generator_level": 0
			} 	# not used 
			
			# ------------------------------
			for ring_index in [0, 1, 2, 3]:
				ring[str(floor_index, ring_index)] = {
					"emergency_mode": ROOM.EMERGENCY_MODES.NORMAL,
					"researchers_per_room": 1,					
					"hotkeys": {},
				}
				
				# ------------------------------
				for room_index in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
					room[str(floor_index, ring_index, room_index)] = {
						"passives_enabled": {},
						"ability_on_cooldown": {},
					}		# not used 

		
		return {
			"global_hotkeys": {},
			"floor": floor, 	# not currently used for anything
			"ring": ring,
			"room": room		 # not currently used for anything
		},
	# ----------------------------------
	"gameplay_conditionals": func() -> Dictionary:
		return {
			# enables more than initial builds to be setup
			CONDITIONALS.TYPE.BASE_IS_SETUP: false,
			
			CONDITIONALS.TYPE.ENABLE_NEXT: false,
			CONDITIONALS.TYPE.ENABLE_DESTROY_ROOM: true,
			#CONDITIONALS.TYPE.ENABLE_ACTIVE_ABILITY_SHORTCUTS: true,
			#CONDITIONALS.TYPE.ENABLE_PASSIVE_ABILITY_SHORTCUTS: true,
			CONDITIONALS.TYPE.ENABLE_INVESTIGATE: true,
			CONDITIONALS.TYPE.ENABLE_OBJECTIVES_BTN: false,
			CONDITIONALS.TYPE.ENABLE_SAVE_AND_LOAD: true,
			
			# enables the "details btn" in the action menu
			CONDITIONALS.TYPE.ENABLE_ACTION_DETAILS: false,
			# enables the "researcher btn" in the action menu
			CONDITIONALS.TYPE.ENABLE_ACTIONS_RESEARCHER: false,
			# enables the "scp btn" in the action menu
			CONDITIONALS.TYPE.ENABLE_ACTIONS_SCP: false,
			# enables the "upgrade" ability in rooms
			CONDITIONALS.TYPE.ENABLE_UPGRADES: false,
			# enables btns in action menu
			
			CONDITIONALS.TYPE.ENABLE_ROOM_DETAILS_BTN: false,
			CONDITIONALS.TYPE.ENABLE_DATABASE_BTN: false,
			
			# ui stuff
			CONDITIONALS.TYPE.UI_ENABLE_ABILITY_HINTS: true,
			CONDITIONALS.TYPE.UI_ENABLE_NAMETAGS: true,
			
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
var selected_support_hire:Dictionary = {}
var selected_lead_hire:Dictionary = {}
var selected_shop_item:Dictionary = {}
var selected_refund_item:Dictionary = {}
var selected_contain_item:Dictionary = {} 
var selected_researcher_item:Dictionary = {}
var selected_scp_details:Dictionary = {} 
var expired_scp_items:Array = [] 
var awarded_rooms:Array = []

var current_location_snapshot:Dictionary 
var camera_settings_snapshot:Dictionary

var showing_states:Dictionary = {} 
var revert_state_location:Dictionary = {}
var tenative_location:Dictionary = {}

var completed_actions:Array = [] : 
	set(val):
		completed_actions = val

			
var event_data:Array = [] : 
	set(val):
		event_data = val
		if !event_data.is_empty():
			current_event_step = EVENT_STEPS.START

var current_phase:PHASE = PHASE.STARTUP : 
	set(val):
		current_phase = val
		on_current_phase_update()

var current_shop_step:SHOP_STEPS = SHOP_STEPS.RESET : 
	set(val):
		current_shop_step = val
		on_current_shop_step_update()
		
var current_builder_step:BUILDER_STEPS = BUILDER_STEPS.RESET : 
	set(val):
		current_builder_step = val
		on_current_builder_step_update()		

var current_contain_step:CONTAIN_STEPS = CONTAIN_STEPS.RESET : 
	set(val):
		current_contain_step = val
		on_current_contain_step_update()
		
var current_recruit_step:RECRUIT_STEPS = RECRUIT_STEPS.RESET : 
	set(val):
		current_recruit_step = val
		on_current_recruit_step_update()

var current_event_step:EVENT_STEPS = EVENT_STEPS.RESET : 
	set(val):
		current_event_step = val
		on_current_event_step_update()

var current_researcher_step:RESEARCHERS_STEPS = RESEARCHERS_STEPS.RESET : 
	set(val):
		current_researcher_step = val
		on_current_researcher_step_update()

var current_summary_step:SUMMARY_STEPS = SUMMARY_STEPS.RESET : 
	set(val):
		current_summary_step = val
		on_current_summary_step_update()
		
var current_select_scp_step:SELECT_SCP_STEPS = SELECT_SCP_STEPS.RESET : 
	set(val):
		current_select_scp_step = val
		on_current_select_scp_step_update()

#var current_researcher_promotion_step:PROMOTE_RESEARCHER_STEPS = PROMOTE_RESEARCHER_STEPS.RESET : 
	#set(val):
		#current_researcher_promotion_step = val
		#on_current_researcher_promotion_step_update()

var current_objective_state:OBJECTIVES_STATE = OBJECTIVES_STATE.HIDE : 
	set(val):
		current_objective_state = val
		on_current_objective_state_update()

signal phase_cycle_complete
signal store_select_location
signal on_complete_build_complete
signal on_expired_scp_items_complete
signal on_events_complete
signal on_summary_complete
signal on_store_closedt
signal on_store_purchase_complete
signal on_confirm_complete
signal on_cancel_construction_complete
signal on_reset_room_complete

signal on_contain_reset
signal on_recruit_complete
signal on_researcher_component_complete
signal on_assign_researcher_complete
signal on_scp_testing_complete
signal on_scp_select_complete
signal on_promote_researcher_complete 
signal on_promotions_complete
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
	
	
	# first these
	on_show_structures_update()
	on_show_actions_update()

	on_show_dialogue_update()
	on_show_resources_update()
	on_show_objectives_update()
	on_show_linedraw_update()
	
	# other
	on_show_confirm_modal_update()
	on_is_busy_update()

	# get default showing state
	capture_default_showing_state()
	
	# assign
	GAME_UTIL.assign_nodes()
	
	# initially all animation speed is set to 0 but after this is all ready, set animation speed
	for node in get_all_container_nodes():
		node.set_process(false)
		node.set_physics_process(false)		

	await U.tick()
	LineDrawContainer.show()
	show_only([])
	
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	START GAME
#region START GAME
func start(new_game_data_config:Dictionary = {}) -> void:
	show()	
	# initially all animation speed is set to 0 but after this is all ready, set animation speed
	set_process(true)
	set_physics_process(true)		
	for node in get_all_container_nodes():
		node.set_process(true)
		node.set_physics_process(true)
		node.activate()
	
	await U.tick()
	start_new_game(new_game_data_config)
	
func exit_to_titlescreen() -> void:
	onExitGame.call(false)

func exit_game() -> void:
	onExitGame.call(true)
	
func setup_scenario(is_new_game:bool) -> void:
	scenario_data.objectives.push_back({
		"title": "SURVIVE FOR %s DAYS." % [scenario_data.day_limit],
		"is_completed": func() -> bool:
			return progress_data.day >= scenario_data.day_limit
	})
	
	# updates objectives
	ObjectivesContainer.objectives = scenario_data.objectives	
	
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
	
	# trigger reset if applicable
	for node in get_all_container_nodes():
		if "on_reset" in node:
			node.on_reset()	
	
	# progress screen
	if !skip_progress_screen:
		SetupContainer.show()
		SetupContainer.title = "SETTING UP... PLEASE WAIT."
		SetupContainer.subtitle = "SORTING FILES..."
		SetupContainer.progressbar_val = 0
		await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.7)
		
		SetupContainer.subtitle = "RESETING THE MATRIX..."
		SetupContainer.progressbar_val = 0.3
		await U.set_timeout(0.5)	

		SetupContainer.subtitle = "LOADING SAVE FILE..."
		SetupContainer.progressbar_val = 0.7
		await U.set_timeout(0.5)		
		await parse_restore_data(game_data_config)
	
		SetupContainer.subtitle = "PREDICTING THE FUTURE..."
		SetupContainer.progressbar_val = 0.9
		await U.set_timeout(0.5)			
	
		SetupContainer.subtitle = "READY!  PROGRAM STARTING..."
		SetupContainer.progressbar_val = 1.0	
		await U.set_timeout(0.5)
	else:
		U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0)
		await parse_restore_data(game_data_config)
		await U.set_timeout(1.0)
	
	# runs room config once everything is ready
	await U.tween_node_property(SetupContainer, "modulate", Color(1, 1, 1, 0), 0.7)
	SetupContainer.queue_free()
	setup_complete = true
	update_room_config()	
	setup_scenario(game_data_config.filedata.is_empty())
		
	# show objectives on game start
	if !DEBUG.get_val(DEBUG.GAMEPLAY_SKIP_OBJECTIVES):
		await GAME_UTIL.open_objectives()
		quicksave(true)

	# then show player hud
	await restore_player_hud()	

	# start at ring level
	if DEBUG.get_val(DEBUG.GAMEPLAY_START_AT_RING_LEVEL):
		ActionContainer.toggle_camera_view()

	# update phase and start game
	current_phase = PHASE.PLAYER
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
		"abl_lvl": 0,
		"energy": {
			"available": 0,
			"used": 0
		},
		"active_buffs": [],
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
		"abl_lvl": 0,
		"energy": {
			"available": 0,
			"used": 0
		},
		"active_buffs": [],
		"room_refs": [],
		"scp_refs": [],
		# --------------
		"emergency_mode": ROOM.EMERGENCY_MODES.NORMAL,
		"room": room
		# --------------
	}

func get_room_defaults() -> Dictionary:
	return {
		# if any passives ENABLE (provides) personnel, mark it here
		"personnel": {
			RESOURCE.PERSONNEL.TECHNICIANS: false,
			RESOURCE.PERSONNEL.STAFF: false,
			RESOURCE.PERSONNEL.SECURITY: false,
			RESOURCE.PERSONNEL.DCLASS: false	
		},
		# if any passive use energy, mark it here
		"energy_used": 0, 		
		"damage_val": 0,
		"abl_lvl": 0,
		"is_activated": false,
		"build_data": {},
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
		ConfirmModal,
		ActionContainer, 
		DialogueContainer, 
		ResourceContainer,
		ObjectivesContainer,
		RoomInfo, FloorInfo, PhaseAnnouncement, ToastContainer
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
	GBL.find_node(REFS.LINE_DRAW).clear()
	await show_only([Structure3dContainer, ActionContainer, TimelineContainer, ResourceContainer, RoomInfo, FloorInfo])
# ------------------------------------------------------------------------------


## ------------------------------------------------------------------------------
#func restore_player_full_hud() -> void:
	#GBL.find_node(REFS.LINE_DRAW).clear()
	#await show_only([Structure3dContainer, ActionContainer, TimelineContainer, ResourceContainer, RoomInfo, FloorInfo])
## ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
#func show_default_state() -> void:
	#for node in self.get_children():
		#if node in [LineDrawContainer]:
			#node.show()
		#else:
			#node.hide()
			#
	#await U.set_timeout(0.5)
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
func get_data_snapshot(self_ref:Dictionary = {}) -> Dictionary:
	return {
		"room_config": room_config.duplicate(true),
		"hired_lead_researchers_arr": hired_lead_researchers_arr.duplicate(true),
		"scp_data": scp_data.duplicate(true),
		"resources_data": resources_data.duplicate(true),
		"purchased_base_arr": purchased_base_arr.duplicate(true),
		"purchased_facility_arr": purchased_facility_arr.duplicate(true),
		"purchased_research_arr": purchased_research_arr.duplicate(true),
		"self_ref": self_ref,
	}
	
func wait_please(duration:float = 0.5) -> void:
	is_busy = true
	await U.set_timeout(duration)
	is_busy = false	

func update_tenative_location(location:Dictionary) -> void:
	tenative_location = location	
# -----------------------------------

# -----------------------------------
func check_events(ref:int, event_ref:SCP.EVENT_TYPE, props:Dictionary = {}) -> void:
	print("check for events...")
	var res:Array = SCP_UTIL.check_for_events(ref, event_ref, props)
	
	if !res.is_empty():
		GBL.find_node(REFS.LINE_DRAW).clear()
		event_data = res
		await on_events_complete
	else:
		restore_player_hud()
		
	await U.tick()
# -----------------------------------

## -----------------------------------
#func check_testing_events(ref:int, testing_ref:SCP.TESTING) -> void:
	#var res:Dictionary = GAME_UTIL.find_in_contained(ref)
	#var index:int = res.index
	#var list_data:Dictionary = res.data	
	#var room_extract:Dictionary = GAME_UTIL.extract_room_details(list_data.location)
	#
	## add to testing count
	#if testing_ref not in list_data.testing_count:
		#list_data.testing_count[testing_ref] = 0 
	#list_data.testing_count[testing_ref] += 1
	#var test_count:int = list_data.testing_count[testing_ref]
		#
	#var event:Dictionary = SCP_UTIL.check_for_testing_events(ref, testing_ref, room_extract, test_count)
	#var event_arr:Array = []
	#if !event.event_instructions.is_empty():
		#event_data = [event]
		#await on_events_complete
## -----------------------------------

# -----------------------------------
func calculate_daily_costs(costs:Array) -> void:
	# MINUS RESOURCES
	for cost in costs:
		if cost.resource_ref in resources_data:
			resources_data[cost.resource_ref].amount += cost.amount
			var capacity:int = resources_data[cost.resource_ref].capacity
			match cost.resource_ref:
				#----------------------------
				# trigger in debt if less than 50.  
				RESOURCE.CURRENCY.MONEY:
					var new_val:int = U.min_max(resources_data[cost.resource_ref].amount, -50, capacity)
					resources_data[cost.resource_ref].amount = new_val
					
					if new_val < -5:
						var props:Dictionary = {
							"count": base_states.counts.in_debt,
							"onSelection": func(val:EVT.IN_DEBT_OPTIONS) -> void:
								match val:
									EVT.IN_DEBT_OPTIONS.EMERGENCY_FUNDS:
										resources_data[cost.resource_ref].amount = 20
									EVT.IN_DEBT_OPTIONS.DO_NOTHING:
										pass
										
						}
						await triggger_event(EVT.TYPE.IN_DEBT_WARNING, props)
				#----------------------------
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
				var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": floor_index, "ring": ring_index, "room": room_index})
				var is_room_empty:bool = extract_data.is_room_empty
				var is_room_active:bool = extract_data.is_activated
				var is_scp_empty:bool = extract_data.is_scp_empty

				var researchers:Array = extract_data.researchers
				var location:Dictionary = {
					"designation": "%s%s%s" % [floor_index, ring_index, room_index],
					"floor": floor_index,
					"ring": ring_index,
					"room": room_index,
				}

				# ------- GETS ROOM DATA PROFITS/COSTS
				if !is_room_empty and is_room_active:
					var room_details:Dictionary = extract_data.room.details
					var diff:Array = ROOM_UTIL.return_operating_cost(room_details.ref).map(func(i):
						return {
							"amount": i.amount, 
							"resource_ref": i.resource.ref
						}
					)
					
					if diff.size() > 0:
						progress_data.record.push_back({
							"source": REFS.SOURCE.FACILITY,
							"data": {
								"name": room_details.name,
								"day": progress_data.day,
								"location": location,
								"diff": diff
							}
						})
						
						calculate_daily_costs(diff)
					

				# ------- GETS SCP DATA PROFITS
				if !is_scp_empty:
					var scp_details:Dictionary = extract_data.scp.details
					var diff:Array = SCP_UTIL.return_ongoing_containment_rewards(scp_details.ref).map(func(i):
						return {
							"amount": i.amount, 
							"resource_ref": i.resource.ref
						}
					)
					
					progress_data.record.push_back({
						"source": REFS.SOURCE.SCPS,
						"data": {
							"name": scp_details.name,
							"day": progress_data.day,
							"location": location,
							"diff": diff
						}
					})
					
					calculate_daily_costs(diff)
					
					# CALUCLATE SCIENCE FROM SCP's
					for researcher in researchers:
						var science_amount:int = 1
						var xp_amount:int = 2 - (researchers.size() - 1)   # 2xp if 1 researcher attached, 1xp if 2 are attached
						#for specilization in researcher.specializations:
							#if specilization in scp_details.researcher_preferences:
								#science_amount = scp_details.researcher_preferences[specilization]
						
						var science_diff:Array = [{
							"amount": science_amount, 
							"resource_ref": RESOURCE.CURRENCY.SCIENCE
						}]
						
						progress_data.record.push_back({
							"source": REFS.SOURCE.TESTING,
							"data": {
								"scp_ref": scp_details,
								"researcher_uid": researcher.uid,
								"name": researcher.name,
								"day": progress_data.day,
								"location": location,
								"diff": science_diff
							}
						})
						
						# add experience
						var leveled_up:bool = RESEARCHER_UTIL.add_experience(researcher.uid, xp_amount)
						progress_data.record.push_back({
							"source": REFS.SOURCE.RESEARCHERS,
							"data": {
								"xp": xp_amount
							}
						})
						
						
						calculate_daily_costs(science_diff)
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
func triggger_event(event:EVT.TYPE, props:Dictionary = {}) -> void:
	event_data = [EVENT_UTIL.run_event(event, props)]
	await on_events_complete
# -----------------------------------

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

func on_show_confirm_modal_update() -> void:
	if !is_node_ready():return
	ConfirmModal.is_showing = show_confirm_modal
	showing_states[ConfirmModal] = show_confirm_modal

func on_show_resources_update() -> void:
	if !is_node_ready():return
	ResourceContainer.is_showing = show_resources
	showing_states[ResourceContainer] = show_resources

func on_show_objectives_update() -> void:
	if !is_node_ready():return
	ObjectivesContainer.is_showing = show_objectives
	showing_states[ObjectivesContainer] = show_objectives


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
			for floor_index in room_config.floor.size():		
				for ring_index in room_config.floor[floor_index].ring.size():
					for room_index in room_config.floor[floor_index].ring[ring_index].size():
						var room_designation:String = str(floor_index, ring_index, room_index)
						for key in base_states.room[room_designation].ability_on_cooldown:
							if base_states.room[room_designation].ability_on_cooldown[key] > 0:
								base_states.room[room_designation].ability_on_cooldown[key] -= 1
								if base_states.room[room_designation].ability_on_cooldown[key] == 0:
									ToastContainer.add("[%s] is ready!" % [key])
				
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
				for item in timeline_filter:
					if "event" in item and !item.event.is_empty():
						await check_events(item.event.scp_ref, item.event.event_ref, {"event_count": item.event.event_count, "use_location": item.event.use_location})
			
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

# ------------------------------------------------------------------------------	SHOP STEPS
#region SHOP STATES
func on_current_builder_step_update() -> void:
	if !is_node_ready():return
	
	match current_builder_step:
		# ---------------
		BUILDER_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
		# ---------------
		BUILDER_STEPS.OPEN:
			SUBSCRIBE.suppress_click = true
			BuildContainer = BuildContainerPreload.instantiate()
			add_child(BuildContainer)
			BuildContainer.z_index = 10
			await U.tick()

			BuildContainer.activate()
			await U.tick()
			BuildContainer.start()
			#show_only([Structure3dContainer, ResourceContainer])
			await BuildContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			#await restore_player_hud()
			
			on_store_purchase_complete.emit()	
			BuildContainer.queue_free()
			current_builder_step = BUILDER_STEPS.RESET
		## ---------------

#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	SHOP STEPS
#region SHOP STATES
func on_current_objective_state_update() -> void:
	if !is_node_ready():return
	
	match current_objective_state:
		# ---------------
		OBJECTIVES_STATE.HIDE:
			SUBSCRIBE.suppress_click = false
		# ---------------
		OBJECTIVES_STATE.SHOW:
			SUBSCRIBE.suppress_click = true
			ObjectivesContainer.start()
			await show_only([ObjectivesContainer, Structure3dContainer])
			await ObjectivesContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			await restore_player_hud()
			on_objective_signal.emit()	
			current_objective_state = OBJECTIVES_STATE.HIDE
		## ---------------

#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	SHOP STEPS
#region SHOP STATES
func on_current_shop_step_update() -> void:
	if !is_node_ready():return
	
	match current_shop_step:
		# ---------------
		SHOP_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
		# ---------------
		SHOP_STEPS.OPEN:
			SUBSCRIBE.suppress_click = true
			StoreContainer = StoreContainerPreload.instantiate()
			add_child(StoreContainer)
			StoreContainer.z_index = 10

			await U.tick()
			StoreContainer.activate()
			
			StoreContainer.start()
			var response:bool = await StoreContainer.user_response
			StoreContainer.queue_free()

			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			on_store_purchase_complete.emit(response)	
			current_shop_step = SHOP_STEPS.RESET
		## ---------------

#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	CONTAIN STEPS
#region CONTAIN STEPS
func on_current_contain_step_update() -> void:
	if !is_node_ready():return
	pass	
# ------------------------------------------------------------------------------	RECRUIT STEPS
#endregion
# ------------------------------------------------------------------------------		


# ------------------------------------------------------------------------------		
#region CURRENT EVENT STEPS
func on_current_event_step_update() -> void:
	if !is_node_ready():return

	match current_event_step:
		EVENT_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
		EVENT_STEPS.START:
			SUBSCRIBE.suppress_click = true
			EventContainer = EventContainerPreload.instantiate()
			add_child(EventContainer)
			EventContainer.z_index = 10
			
			await U.tick()
			EventContainer.activate()
			await U.tick()
			EventContainer.start(event_data)
			var event_res:Dictionary = await EventContainer.user_response
			EventContainer.queue_free()
			
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			# trigger signal
			on_events_complete.emit(event_res)			
			# reset and evempty event_data
			event_data = []
			#restore_player_hud()
			current_event_step = EVENT_STEPS.RESET
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
#region SUMMARY STEPS
func on_current_summary_step_update() -> void:
	if !is_node_ready():return

	#match current_summary_step:
		#SUMMARY_STEPS.RESET:
			#SUBSCRIBE.suppress_click = false
			#await restore_player_hud()
		#SUMMARY_STEPS.START:
			#SUBSCRIBE.suppress_click = true
			#await show_only([EndOfPhaseContainer])
			#EndOfPhaseContainer.start()
			#await EndOfPhaseContainer.user_response
			#GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			#current_summary_step = SUMMARY_STEPS.RESET
			#await U.set_timeout(0.5)
			## trigger signal
			#on_summary_complete.emit()
			#
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	
#region SELECT SCP STEPS
func on_current_select_scp_step_update() -> void:
	if !is_node_ready():return

	match current_select_scp_step:
		# ------------------------
		SELECT_SCP_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
		# ------------------------
		SELECT_SCP_STEPS.START:
			SUBSCRIBE.suppress_click = true
			SCPSelectScreen = ScpSelectScreenPreload.instantiate()
			add_child(SCPSelectScreen)
			SCPSelectScreen.z_index = 10
			
			#for node in [Structure3dContainer, ActionContainer, TimelineContainer, ResourceContainer, RoomInfo, FloorInfo]:
				#node.set_process(false)
				#node.set_physics_process(false)		
				#node.hide()
				
			await U.tick()
			SCPSelectScreen.activate()
			
			var response:Dictionary = await SCPSelectScreen.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			
			if response.made_selection:
				scp_data.available_refs	= SCP_UTIL.get_next_available_refs(response.selected_scp)
				SUBSCRIBE.scp_data = scp_data
			
			SCPSelectScreen.queue_free()
			
			#for node in [Structure3dContainer, ActionContainer, TimelineContainer, ResourceContainer, RoomInfo, FloorInfo]:
				#node.set_process(true)
				#node.set_physics_process(true)		
				#node.show()			
			
			# trigger signal
			on_scp_select_complete.emit(response)
			current_select_scp_step = SELECT_SCP_STEPS.RESET
		# ------------------------
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------		
#region RESEARCHER STEPS
func on_current_recruit_step_update() -> void:
	if !is_node_ready():return

	match current_recruit_step:
		# ---------------
		RECRUIT_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
		# ---------------
		RECRUIT_STEPS.OPEN:
			SUBSCRIBE.suppress_click = true
			SelectResearcherScreen = SelectResearcherScreenPreload.instantiate()
			add_child(SelectResearcherScreen)
			SelectResearcherScreen.z_index = 10
			
			await U.tick()
			SelectResearcherScreen.activate()
			
			SelectResearcherScreen.start()
			var response:bool = await SelectResearcherScreen.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			SelectResearcherScreen.queue_free()
			
			# trigger signal
			on_recruit_complete.emit(response)
			await restore_showing_state()
			current_recruit_step = RECRUIT_STEPS.RESET


#func on_current_researcher_promotion_step_update() -> void:
	#if !is_node_ready():return
	#
	#match current_researcher_promotion_step:
		## ------------------------
		#PROMOTE_RESEARCHER_STEPS.RESET:
			#SUBSCRIBE.suppress_click = false
		## ------------------------
		#PROMOTE_RESEARCHER_STEPS.START:
			#pass
			##print("here?")
			##SUBSCRIBE.suppress_click = true
			##var ResearcherPromotionNode:Control = ResearcherPromotionScreenPreload.instantiate()
			##add_child(ResearcherPromotionNode)
			##ResearcherPromotionNode.activate()
			##await U.tick()
			##await show_only([])
			##ResearcherPromotionNode.start()
			##await ResearcherPromotionNode.user_response
			##GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			##ResearcherPromotionNode.queue_free()
			##on_promote_researcher_complete.emit(true)
			##await restore_showing_state()
			##current_select_scp_step = SELECT_SCP_STEPS.RESET


func on_current_researcher_step_update() -> void:
	if !is_node_ready():return
	
	match current_researcher_step:
		# ------------------------
		RESEARCHERS_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
		# ------------------------
		RESEARCHERS_STEPS.DETAILS_ONLY:
			SUBSCRIBE.suppress_click = true
			var ResearchersContainer:Control = ResearchersContainerPreload.instantiate()
			add_child(ResearchersContainer)
			ResearchersContainer.z_index = 10

			await U.tick()
			ResearchersContainer.activate()
			
			await U.tick()
			ResearchersContainer.start([], true)
			var response:Dictionary = await ResearchersContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			ResearchersContainer.queue_free()
			
			on_researcher_component_complete.emit()
			current_researcher_step = RESEARCHERS_STEPS.RESET
		# ------------------------
		RESEARCHERS_STEPS.ASSIGN:
			SUBSCRIBE.suppress_click = true
			
			var ResearchersContainer:Control = ResearchersContainerPreload.instantiate()
			add_child(ResearchersContainer)
			ResearchersContainer.z_index = 10
			
			await U.tick()
			ResearchersContainer.activate()
		
			var assigned_uids:Array =  hired_lead_researchers_arr.filter(func(i):				
				return U.dictionaries_equal(i[9].assigned_to_room, current_location)
			).map(func(i): return i[0])
			
			await U.tick()						
			ResearchersContainer.assign(assigned_uids, false)
			var response:Dictionary = await ResearchersContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)	
			ResearchersContainer.queue_free()
			
			on_researcher_component_complete.emit(response)
			current_researcher_step = RESEARCHERS_STEPS.RESET
		# --------------------------------------
		RESEARCHERS_STEPS.PROMOTE:
			SUBSCRIBE.suppress_click = true
			
			var ResearchersContainer:Control = ResearchersContainerPreload.instantiate()
			add_child(ResearchersContainer)
			ResearchersContainer.z_index = 10			
			
			await U.tick()			
			ResearchersContainer.activate()

			var uids:Array =  hired_lead_researchers_arr.map(func(i): return i[0])
			await U.tick()									
			ResearchersContainer.promote(uids)
			var response:Dictionary = await ResearchersContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			ResearchersContainer.queue_free()
#
			on_researcher_component_complete.emit(response)
			current_researcher_step = RESEARCHERS_STEPS.RESET
		# ------------------------

#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	CONTROLS
#region CONTROL UPDATE
func is_occupied() -> bool:
	if is_busy or processing_next_day:
		return true
	if current_phase != PHASE.PLAYER:
		return true
	return false


#endregion
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

#func quickload() -> void:
	#is_busy = true
	#var res:Dictionary = FS.load_file(FS.FILE.QUICK_SAVE)
	#if res.success:
		#await parse_restore_data(res.filedata.data)
		#print("quickload success!")
	#else:
		#await parse_restore_data({})
		#print("quickload failed - creating new file")
	#is_busy = false

		
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
func update_room_config(force_setup:bool = false) -> void:
	if !setup_complete:return
	const energy_levels:Array = [5, 10, 15, 20, 25]
	# grab default values
	var new_room_config:Dictionary = initial_values.room_config.call()	
	var new_gameplay_conditionals:Dictionary = initial_values.gameplay_conditionals.call()		
	var room_type_refs:Array = purchased_facility_arr.map(func(x): return x.type_ref)
	var metric_defaults:Dictionary = {}

	# set defaults
	for floor_index in new_room_config.floor.size():
		var energy_available:int = energy_levels[base_states.floor[str(floor_index)].generator_level]
		for ring_index in new_room_config.floor[floor_index].ring.size():
			var ring_config_data:Dictionary = new_room_config.floor[floor_index].ring[ring_index]
			ring_config_data.energy.available = energy_available if !DEBUG.get_val(DEBUG.GAMEPLAY_MAX_ENERGY)	 else 99
			ring_config_data.energy.used = 0
			var floor_ring_designation:String = str(floor_index, ring_index)
			if floor_ring_designation not in metric_defaults:
				metric_defaults[floor_ring_designation] = {
					RESOURCE.METRICS.MORALE: 0,
					RESOURCE.METRICS.SAFETY: 0,
					RESOURCE.METRICS.READINESS: 0
				}

	# CALCULATE CONTAINED SCP - 
	for item in scp_data.contained_list:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room	
		var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
		var scp_details:Dictionary = SCP_UTIL.return_data(item.ref)
		
		if "before" in scp_details.effects:
			# call their effects
			new_room_config = scp_details.effects.before.call(new_room_config, item.location)
			# first, add this to the config
			room_config_data.scp_data = {
				"ref": item.ref
			}

	# FIRST, RESET all passive enables, check for assigned researchers and add to ability level
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)		
		var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]		
		var room_base_state:Dictionary = base_states.room[str(floor, ring, room)]
		# FIRST, set defaults
		if "passive_abilities" in room_data:
			var passive_abilities:Array = room_data.passive_abilities.call()
			for ability_index in passive_abilities.size():
				var ability:Dictionary = passive_abilities[ability_index]
				var ability_uid:String = str(room_data.ref, ability_index)
				# creates default state if it doesn't exist
				if ability_uid not in room_base_state.passives_enabled:
					room_base_state.passives_enabled[ability_uid] = false

		# check for researcher and if they pair with the room to increasae the room level ability
		for researcher in hired_lead_researchers_arr:
			var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(researcher[0])
			var assigned_to_room:Dictionary = researcher_details.props.assigned_to_room
			var specializations:Array = researcher_details.specializations
			var has_pairing:bool = ROOM_UTIL.check_for_room_pair(item.ref, specializations)
			if assigned_to_room == item.location and has_pairing:
				room_config_data.abl_lvl = U.min_max(room_config_data.abl_lvl + 1, 0, 2)
				
	# NEXT check for passives in rooms
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)		
		var room_base_state:Dictionary = base_states.room[str(floor, ring, room)]
		var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]

		var floor_ring_designation:String = str(floor, ring)
		
		if "currencies" in room_data:
			for key in room_data.currencies:
				var amount:int = room_data.currencies[key]
				new_room_config.floor[floor].ring[ring].currencies[key] += amount
			
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
					#print(ability.name, ability.lvl_required, " -> ", abl_lvl)
					if ability.lvl_required <= abl_lvl and ring_config_data.energy.used < ring_config_data.energy.available:
						# if it's enabled, add to energy cost
						ring_config_data.energy.used += energy_cost
						room_config_data.energy_used += energy_cost

						# check provides (like staff, dclass, security, etc)
						if "provides" in ability: 
							for resource in ability.provides:
								ring_config_data.personnel[resource] = true
								room_config_data.personnel[resource] = true

						# check for metrics
						if "metrics" in ability: 
							for metric in ability.metrics:
								metric_defaults[floor_ring_designation][metric] += ability.metrics[metric]
								
						# check for wing level stuff
						if "wing" in ability:
							new_room_config = ability.wing.call(new_room_config, item.location)

						# check for any conditional changes
						if "conditional" in ability:
							ability.conditional.call(gameplay_conditionals)
					else:
						room_base_state.passives_enabled[ability_uid] = false

	# go through once more to check if rooms can be activated if they have a resource requirement
	# and add their metrics if they are
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var floor_ring_designation:String = str(floor, ring)
		var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)		
		var ring_base_state:Dictionary = base_states.ring[floor_ring_designation]
		var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
		var is_activated:bool = true
		# check if room has any requirements
		if "required_personnel" in room_data:
			for ref in room_data.required_personnel:
				if !ring_config_data.personnel[ref]:
					is_activated = false
					break
		# update metrics IF room is activated
		if is_activated and "metrics" in room_data:
			for key in room_data.metrics:
				var amount:int = room_data.metrics[key]
				metric_defaults[floor_ring_designation][key] += amount
		# add is activated statement
		room_config_data.is_activated = is_activated 
		# set room config data
		room_config_data.room_data = {
			"ref": item.ref,
			"details": ROOM_UTIL.return_data(item.ref), 
		}
		# add to ref count
		ring_config_data.room_refs.push_back(item.ref)
	
	
	# now add any researcher bonuses in
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room		
		var floor_ring_designation:String = str(floor, ring)		
		var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
		# add any effects from researechers attached to room
		var trait_res:Dictionary = GAME_UTIL.get_room_traits(item.location, new_room_config)
		var trait_list:Array = trait_res.trait_list
		var synergy_list:Array = trait_res.synergy_list
		for list_item in trait_list:
			for metric in list_item.effect.metric_list:
				metric_defaults[floor_ring_designation][metric.resource.ref] += metric.amount

		ring_config_data.metrics = metric_defaults[floor_ring_designation]

	# CALCULATE CONTAINED SCP - 
	for item in scp_data.contained_list:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room	
		var ring_config_data:Dictionary = new_room_config.floor[floor].ring[ring]
		var room_config_data:Dictionary = new_room_config.floor[floor].ring[ring].room[room]
		var scp_details:Dictionary = SCP_UTIL.return_data(item.ref)
		
		if "after" in scp_details.effects:
			# call their effects
			new_room_config = scp_details.effects.after.call(new_room_config, item.location)
			# first, add this to the config
			room_config_data.scp_data = {
				"ref": item.ref
			}

	
	# checks for any conditioals triggers by built room combonations:
	if ROOM.TYPE.DIRECTORS_OFFICE in room_type_refs and ROOM.TYPE.HQ in room_type_refs:
		new_gameplay_conditionals[CONDITIONALS.TYPE.BASE_IS_SETUP] = progress_data.day > 1
	
	SUBSCRIBE.resources_data = resources_data
	SUBSCRIBE.room_config = new_room_config	
	SUBSCRIBE.gameplay_conditionals = new_gameplay_conditionals
# -----------------------------------

## -----------------------------------
#func update_metrics(new_room_config:Dictionary, metric_defaults:Dictionary) -> void:
	## now update all metrics once everything has been attached
	#for floor_index in new_room_config.floor.size():
		#for ring_index in new_room_config.floor[floor_index].ring.size():
			#var floor_ring_designation:String = str(floor_index, ring_index)
			## reset metrics before recalcualting them
			#for room_index in new_room_config.floor[floor_index].ring[ring_index].room.size():
				#var room_extract:Dictionary = GAME_UTIL.extract_room_details({"floor": floor_index, "ring": ring_index, "room": room_index}, new_room_config)
				#for key in room_extract.metric_details.total:
					#var amount:int = room_extract.metric_details.total[key]
					#metric_defaults[floor_ring_designation][key] += amount
			#
			#var in_lockdown:bool = new_room_config.floor[floor_index].in_lockdown
			#if in_lockdown:
					#metric_defaults[floor_ring_designation][RESOURCE.METRICS.READINESS] += 3
					#metric_defaults[floor_ring_designation][RESOURCE.METRICS.MORALE] -= 3
			#else:
				## then add any bonuses from the emergency states
				#var emergency_mode:int = new_room_config.floor[floor_index].ring[ring_index].emergency_mode
				#match emergency_mode:
					#ROOM.EMERGENCY_MODES.CAUTION:
						#metric_defaults[floor_ring_designation][RESOURCE.METRICS.SAFETY] += 1
						#metric_defaults[floor_ring_designation][RESOURCE.METRICS.READINESS] += 1
						#metric_defaults[floor_ring_designation][RESOURCE.METRICS.MORALE] -= 2
					#ROOM.EMERGENCY_MODES.WARNING:
						#metric_defaults[floor_ring_designation][RESOURCE.METRICS.SAFETY] += 3
						#metric_defaults[floor_ring_designation][RESOURCE.METRICS.MORALE] -= 3
					#ROOM.EMERGENCY_MODES.DANGER:
						#metric_defaults[floor_ring_designation][RESOURCE.METRICS.READINESS] += 3
						#metric_defaults[floor_ring_designation][RESOURCE.METRICS.MORALE] -= 3
						#
			## lastly, compile all the metrics from rooms, scps and researchers, etc
			#new_room_config.floor[floor_index].ring[ring_index].metrics = metric_defaults[floor_ring_designation]
			#
	#SUBSCRIBE.room_config = new_room_config	
## -----------------------------------
