extends PanelContainer

@onready var Structure3dContainer:Control = $Structure3DContainer

@onready var TimelineContainer:PanelContainer = $TimelineContainer
@onready var ActionContainer:PanelContainer = $ActionContainer
@onready var DialogueContainer:MarginContainer = $DialogueContainer
@onready var StoreContainer:PanelContainer = $StoreContainer
@onready var ContainmentContainer:MarginContainer = $ContainmentContainer
@onready var RecruitmentContainer:MarginContainer = $RecruitmentContainer
@onready var ResourceContainer:PanelContainer = $ResourceContainer
@onready var BuildCompleteContainer:PanelContainer = $BuildCompleteContainer
@onready var ObjectivesContainer:MarginContainer = $ObjectivesContainer
@onready var ResearchersContainer:PanelContainer = $ResearcherContainer
@onready var EventContainer:MarginContainer = $EventContainer
@onready var MetricsContainer:PanelContainer = $MetricsContainer
@onready var EndOfPhaseContainer:MarginContainer = $EndofPhaseContainer
@onready var PhaseAnnouncement:PanelContainer = $PhaseAnnouncement
@onready var ToastContainer:PanelContainer = $ToastContainer
@onready var SCPSelectScreen:PanelContainer = $SCPSelectScreen

@onready var RoomInfo:PanelContainer = $RoomInfo
@onready var FloorInfo:PanelContainer = $FloorInfo

@onready var ConfirmModal:PanelContainer = $ConfirmModal
@onready var WaitContainer:PanelContainer = $WaitContainer
@onready var SetupContainer:PanelContainer = $SetupContainer

const ResearcherPromotionScreenPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResearcherPromotionScreen/ResearcherPromotionScreen.tscn")

enum PHASE { STARTUP, PLAYER, RESOURCE_COLLECTION, METRIC_EVENTS, RANDOM_EVENTS, CALC_NEXT_DAY, SCHEDULED_EVENTS, CONCLUDE }

enum SHOP_STEPS {
	RESET, 
	START_BASE, 
	START_ROOM,
	PLACEMENT,
	CONFIRM_RESEARCH_ITEM_PURCHASE, CONFIRM_BUILD, CONFIRM_TIER_PURCHASE, CONFIRM_BASE_ITEM_PURCHASE,
	FINALIZE_PURCHASE_BUILD, FINALIZE_PURCHASE_RESEARCH, FINALIZE_PURCHASE_TIER, FINALIZE_PURCHASE_BASE_ITEM,
	REFUND
}
enum CONTAIN_STEPS {
	RESET, START, SHOW, PLACEMENT, CONFIRM_PLACEMENT, 
	ON_REJECT, ON_TRANSFER_CANCEL, 
	ON_TRANSFER_TO_NEW_LOCATION, 
	CONFIRM, FINALIZE
}
enum RECRUIT_STEPS {RESET, START, SHOW, CONFIRM_HIRE_LEAD, CONFIRM_HIRE_SUPPORT, FINALIZE}
enum ACTION_COMPLETE_STEPS {RESET, START, FINALIZE}
enum SUMMARY_STEPS {RESET, START, DISMISS}
enum RESEARCHERS_STEPS {RESET, DETAILS_ONLY, ASSIGN}
enum EVENT_STEPS {RESET, START}
enum SELECT_SCP_STEPS { RESET, START }
enum PROMOTE_RESEARCHER_STEPS { RESET, START }

# ------------------------------------------------------------------------------	EXPORT VARS
#region EXPORT VARS
@export var debug_mode:bool = false 
@export var skip_progress_screen:bool = true

@export var show_structures:bool = true: 
	set(val):
		show_structures = val
		on_show_structures_update()
		
@export var show_timeline:bool = true : 
	set(val):
		show_timeline = val
		on_show_timeline_update()

@export var show_actions:bool = true : 
	set(val):
		show_actions = val
		on_show_actions_update()

@export var show_objectives:bool = false : 
	set(val):
		show_objectives = val
		on_show_objectives_update()		
		
@export var show_metrics:bool = true : 
	set(val):
		show_metrics = val
		on_show_metrics_update()

@export var show_dialogue:bool = false : 
	set(val):
		show_dialogue = val
		on_show_dialogue_update()
		
@export var show_store:bool = false : 
	set(val):
		show_store = val
		on_show_store_update()		
		
@export var show_recruit:bool = false : 
	set(val):
		show_recruit = val
		on_show_recruit_update()		

@export var show_reseachers:bool = false : 
	set(val):
		show_reseachers = val
		on_show_reseachers_update()

@export var show_containment_status:bool = false : 
	set(val):
		show_containment_status = val
		on_show_containment_status_update()
		
@export var show_confirm_modal:bool = false : 
	set(val):
		show_confirm_modal = val
		on_show_confirm_modal_update()
		
@export var show_resources:bool = false : 
	set(val):
		show_resources = val
		on_show_resources_update()
		

@export var show_events:bool = false : 
	set(val):
		show_events = val
		on_show_events_update()		

@export var show_build_complete:bool = false : 
	set(val):
		show_build_complete = val
		on_show_build_complete_update()

		
@export var show_end_of_phase:bool = false : 
	set(val):
		show_end_of_phase = val
		on_show_end_of_phase_update()
		
#@export var show_choices:bool = false : 
	#set(val):
		#show_choices = val
		#on_show_choices_update()		
		
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
			"available_list": [
				#{
					#"ref": SCP.TYPE.SCP_001, 
					#"days_until_expire": 99, 
					#"is_new": true,
					#"transfer_status": {
						#"state": false, 
						#"days_till_complete": -1,
						#"location": {}
					#}
				#},
				#{
					#"ref": SCP.TYPE.SCP_002, 
					#"days_until_expire": 99, 
					#"is_new": true,
					#"transfer_status": {
						#"state": false, 
						#"days_till_complete": -1,
						#"location": {}
					#}
				#}		
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
		},
	# ----------------------------------
	"progress_data": func() -> Dictionary:
		return { 
			"day": 1,
			"days_till_report": days_till_report_limit - 1,
			"next_metric": RESOURCE.BASE_METRICS.MORALE,
			"show_report": false,
			"record": [],
			"previous_records": []
		},
	# ----------------------------------
	"resources_data": func() -> Dictionary:
		return { 
			RESOURCE.TYPE.MONEY: {
				"amount": 100, 
				"utilized": 0, 
				"capacity": 9999
			},
			RESOURCE.TYPE.ENERGY: {
				"amount": 50, 
				"utilized": 0, 
				"capacity": 100
			},
			RESOURCE.TYPE.SCIENCE: {
				"amount": 20, 
				"utilized": 0, 
				"capacity": 9999
			},			
			RESOURCE.TYPE.LEAD_RESEARCHERS: {
				"amount": 0, 
				"utilized": 0, 
				"capacity": 0
			},
			RESOURCE.TYPE.STAFF: {
				"amount": 0, 
				"utilized": 0, 
				"capacity": 0
			},
			RESOURCE.TYPE.SECURITY: {
				"amount": 0, 
				"utilized": 0, 
				"capacity": 0
			},
			RESOURCE.TYPE.DCLASS: {
				"amount": 0, 
				"utilized": 0, 
				"capacity": 0
			},
		},
	# ----------------------------------
	"tier_unlocked": func() -> Dictionary:
		return {
			TIER.TYPE.BASE_DEVELOPMENT: {
				TIER.VAL.ZERO: true,
				TIER.VAL.ONE: false,
				TIER.VAL.TWO: false,
				TIER.VAL.THREE: false,
				TIER.VAL.FOUR: false,
				TIER.VAL.FIVE: false
			},
			TIER.TYPE.FACILITY: {
				TIER.VAL.ZERO: true,
				TIER.VAL.ONE: false,
				TIER.VAL.TWO: false,
				TIER.VAL.THREE: false,
				TIER.VAL.FOUR: false,
				TIER.VAL.FIVE: false
			},
			TIER.TYPE.RESEARCH_AND_DEVELOPMENT: {
				TIER.VAL.ZERO: true,
				TIER.VAL.ONE: false,
				TIER.VAL.TWO: false,
				TIER.VAL.THREE: false,
				TIER.VAL.FOUR: false,
				TIER.VAL.FIVE: false
			},
		},
	# ----------------------------------
	"room_config": func() -> Dictionary:
		return {
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
		
		for floor_index in [0, 1, 2, 3, 4, 5, 6]:
			floor[str(floor_index)] = {
				"in_lockdown": false,
				"is_powered": floor_index == 0,
			}
			
			# ------------------------------
			for ring_index in [0, 1, 2, 3]:
				ring[str(floor_index, ring_index)] = {
					"emergency_mode": ROOM.EMERGENCY_MODES.NORMAL
				}
				
				# ------------------------------
				for room_index in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
					room[str(floor_index, ring_index, room_index)] = {
						"is_activated": false,  
						"is_destroyed": false
					}						
		
		
		return {
			"base": {
				"in_brownout": false,
				"in_debt": false
			},
			"counts": {
				"in_brownout": 0,
				"in_debt": 0
			},
			"floor": floor,
			"ring": ring,
			"room": room,
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
	"researcher_hire_list": func() -> Array:
		return RESEARCHER_UTIL.generate_new_researcher_hires(),
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
var tier_unlocked:Dictionary 
var researcher_hire_list:Array
var action_queue_data:Array
var purchased_facility_arr:Array 
var purchased_base_arr:Array
var purchased_research_arr:Array 
var bookmarked_rooms:Array # ["000", "201"] <- "floor_index, ring_index, room_index"]
var unavailable_rooms:Array 
var hired_lead_researchers_arr:Array

#endregion
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------	LOCAL DATA
#region LOCAL DATA
const days_till_report_limit:int = 7
var shop_revert_step:SHOP_STEPS

var processing_next_day:bool = false

var is_busy:bool = false : 
	set(val):
		is_busy = val
		on_is_busy_update()
		
var setup_complete:bool = false : 
	set(val):
		setup_complete = val
		on_setup_complete_update()

var selected_support_hire:Dictionary = {}
var selected_lead_hire:Dictionary = {}
var selected_shop_item:Dictionary = {}
var selected_refund_item:Dictionary = {}
var selected_contain_item:Dictionary = {} 
var selected_researcher_item:Dictionary = {}
var selected_scp_details:Dictionary = {} 
var expired_scp_items:Array = [] 

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

var current_contain_step:CONTAIN_STEPS = CONTAIN_STEPS.RESET : 
	set(val):
		current_contain_step = val
		on_current_contain_step_update()
		
var current_recruit_step:RECRUIT_STEPS = RECRUIT_STEPS.RESET : 
	set(val):
		current_recruit_step = val
		on_current_recruit_step_update()
		
var current_action_complete_step:ACTION_COMPLETE_STEPS = ACTION_COMPLETE_STEPS.RESET : 
	set(val):
		current_action_complete_step = val
		on_current_action_complete_step_update()

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

var current_researcher_promotion_step:PROMOTE_RESEARCHER_STEPS = PROMOTE_RESEARCHER_STEPS.RESET : 
	set(val):
		current_researcher_promotion_step = val
		on_current_researcher_promotion_step_update()

signal store_select_location
signal on_complete_build_complete
signal on_expired_scp_items_complete
signal on_events_complete
signal on_summary_complete
signal on_store_closed
signal on_store_purchase_complete
signal on_confirm_complete
signal on_cancel_construction_complete
signal on_reset_room_complete
signal on_activate_room_complete
signal on_contain_reset
signal on_recruit_complete
signal on_researcher_component_complete
signal on_assign_researcher_complete
signal on_scp_testing_complete
signal on_scp_select_complete
signal on_promote_researcher_complete 
signal on_promotions_complete

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
	SUBSCRIBE.subscribe_to_tier_unlocked(self)
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
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.GAMEPLAY_LOOP)
	GBL.unsubscribe_to_mouse_input(self)
	GBL.unsubscribe_to_control_input(self)
	
	SUBSCRIBE.unsubscribe_to_progress_data(self)
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_tier_unlocked(self)
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
	
func _ready() -> void:
	if !Engine.is_editor_hint():
		hide()
		set_process(false)
		set_physics_process(false)	
	setup()
	
		

func setup() -> void:
	current_phase = PHASE.STARTUP
	
	# first these
	on_show_structures_update()
	on_show_actions_update()

	on_show_dialogue_update()
	on_show_containment_status_update()
	on_show_recruit_update()
	on_show_resources_update()
	on_show_objectives_update()
	on_show_events_update()
	on_show_build_complete_update()
	on_show_reseachers_update()
	on_show_store_update()
	on_show_metrics_update()
	on_show_end_of_phase_update()
	
	# other
	on_show_confirm_modal_update()
	on_is_busy_update()

	# get default showing state
	capture_default_showing_state()

#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	START GAME
#region START GAME
func start(game_data:Dictionary = {}) -> void:
	show()
	set_process(true)
	set_physics_process(true)	
	
	# initially all animation speed is set to 0 but after this is all ready, set animation speed
	for node in get_all_container_nodes():
		node.animation_speed = 0.3

	if game_data.is_empty():
		start_new_game()
	else:
		start_load_game()

func start_new_game() -> void:
	setup_complete = false
	
	# reset steps
	await show_only()
	current_shop_step = SHOP_STEPS.RESET
	current_contain_step = CONTAIN_STEPS.RESET
	current_recruit_step = RECRUIT_STEPS.RESET
	current_action_complete_step = ACTION_COMPLETE_STEPS.RESET
	current_summary_step = SUMMARY_STEPS.RESET
	current_event_step = EVENT_STEPS.RESET
	current_researcher_step = RESEARCHERS_STEPS.RESET
		
	if !skip_progress_screen:
		SetupContainer.title = "SETTING UP... PLEASE WAIT."
		SetupContainer.subtitle = "SORTING FILES..."
		SetupContainer.progressbar_val = 0.1
		await U.set_timeout(0.5)

	# trigger reset if applicable
	for node in get_all_container_nodes():
		if "on_reset" in node:
			node.on_reset()
	
	if !skip_progress_screen:
		SetupContainer.subtitle = "RESETING THE MATRIX..."
		SetupContainer.progressbar_val = 0.3
		await U.set_timeout(0.5)	

		SetupContainer.subtitle = "LOADING SAVE FILE..."
		SetupContainer.progressbar_val = 0.7
		await U.set_timeout(0.5)		
		await quickload()
	
		SetupContainer.subtitle = "PREDICTING THE FUTURE..."
		SetupContainer.progressbar_val = 0.9
		await U.set_timeout(0.5)			
	
		SetupContainer.subtitle = "READY!  PROGRAM STARTING..."
		SetupContainer.progressbar_val = 1.0	
		await U.set_timeout(0.5)
	else:
		await quickload()
	
	
	await restore_player_hud()	
	# runs room config once everything is ready
	await U.set_timeout(0.2)
	
	set_room_config()	
	setup_complete = true
	current_phase = PHASE.PLAYER



func start_load_game() -> void:
	# load save file
	pass
	
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
#region defaults functions
func get_floor_default(is_powered:bool, array_size:int) -> Dictionary:
	return { 
		"is_powered": is_powered,
		"in_brownout": false,
		"in_lockdown": false,
		"array_size": array_size,
		"metrics": {
			RESOURCE.BASE_METRICS.HUME: 1,
		},
		"scp_refs": [],
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
		"emergency_mode": ROOM.EMERGENCY_MODES.NORMAL,	
		"metrics": {
			RESOURCE.BASE_METRICS.MORALE: 0,
			RESOURCE.BASE_METRICS.SAFETY: 0,
			RESOURCE.BASE_METRICS.READINESS: 0
		},
		"active_buffs": [],
		"room_refs": [],
		"scp_refs": [],
		"room": room
	}

func get_room_defaults() -> Dictionary:
	return {
		"is_activated": false,
		"build_data": {},
		"room_data": {},
		"scp_data": {},
		"attached_researchers": []
	}
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	SHOW/HIDE CONTAINERS
#region show/hide functions
func on_setup_complete_update() -> void:
	if !is_node_ready():return
	SetupContainer.show() if !setup_complete else SetupContainer.hide()
	
func on_is_busy_update() -> void:
	if !is_node_ready():return
	WaitContainer.show() if is_busy else WaitContainer.hide()

func get_all_container_nodes(exclude:Array = []) -> Array:
	return [
		Structure3dContainer, TimelineContainer, ResearchersContainer,
		ActionContainer, 
		DialogueContainer, StoreContainer, ContainmentContainer, 
		ConfirmModal, RecruitmentContainer, ResourceContainer,
		BuildCompleteContainer, ObjectivesContainer, EventContainer,
		MetricsContainer,  EndOfPhaseContainer,	SCPSelectScreen,
		RoomInfo, FloorInfo
	].filter(func(node): return node not in exclude)
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func capture_default_showing_state() -> void:
	for node in get_all_container_nodes():
		showing_states[node] = node.is_showing
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func restore_player_hud() -> void:	
	await show_only([Structure3dContainer, TimelineContainer, ActionContainer, MetricsContainer, ResourceContainer, RoomInfo, FloorInfo])
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func restore_default_state() -> void:
	for node in get_all_container_nodes():
		if showing_states[node] != node.is_showing:
			node.is_showing = showing_states[node]
	await U.set_timeout(0.5)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func show_only(nodes:Array = []) -> void:
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
func get_self_ref_callable(scp_ref:int) -> Callable:
	# setup self reference callables
	return func() -> Dictionary:
		return {
			# get scp details
			# -------------------------get_me
			"details": SCP_UTIL.return_data(scp_ref),
			# -------------------------
			# get their contained_list details
			"contained_list_details": func() -> Dictionary:
				var res:Dictionary = find_in_contained(scp_ref)
				return {
					"index": res.index,
					"data": res.data
				},
			# -------------------------	
			# return current researcher(s) attached to scp
			"researcher_details": func() -> Array:
				var res:Dictionary = find_in_contained(scp_ref)
				var room_extract:Dictionary = ROOM_UTIL.extract_room_details(res.data.location)
				return room_extract.researchers,
			# -------------------------	
			"progress_data": func() -> Dictionary:
				return progress_data.duplicate(true),
			# get a count of the current resources available
			"resources_data": func() -> Dictionary:
				return resources_data.duplicate(true),
			# -------------------------	
			# preform an action (like cancel transfer, stop reserach, etc)
			"perform_action": func(action:int) -> void:
				pass,
				#match action:
					#ACTION.CONTAINED.CANCEL_TRANSFER:
						#var filtered_arr:Array = action_queue_data.filter(func(i): return i.ref == scp_ref and i.action == ACTION.AQ.TRANSFER)
						#cancel_scp_transfer(scp_ref)
						#remove_from_timeline(filtered_arr[0])
				#pass,
			# -------------------------	
			# get counts for type (randomize, after_contained, etc)
			"event_type_count": func(type:int, event_id:int) -> int:
				var res:Dictionary = find_in_contained(scp_ref)
				var event_name:String = "%s%s" % [type, event_id]
				return 0 if event_name not in res.data.event_type_count else res.data.event_type_count[event_name].count,
			# -------------------------
			# easy method to call when you want to add something to their unlockable
			"add_unlockable": func(unlockable:SCP.UNLOCKABLE) -> void:
				scp_data.contained_list = scp_data.contained_list.map(func(i): 
					if i.ref == scp_ref:
						var refs_arr:Array = i.unlocked.map(func(i): return i.ref)
						if unlockable not in refs_arr:
							i.unlocked.push_back({
								"ref": unlockable
							})
					return i
				)
				scp_data = scp_data
		}
# -----------------------------------


# -----------------------------------

func set_room_config(force_setup:bool = false) -> void:
	# otherwise, run the full script.  This prevents this code from running multiple times
	var new_room_config:Dictionary = initial_values.room_config.call()	
	var under_construction_rooms:Array = []
	var built_rooms:Array = []

	# mark rooms that are being transfered to a room 
	if "available_list" in scp_data:
		for item in scp_data.available_list:
			if item.transfer_status.state:
				var floor:int = item.transfer_status.location.floor
				var ring:int = item.transfer_status.location.ring
				var room:int = item.transfer_status.location.room	
				new_room_config.floor[floor].ring[ring].room[room].scp_data = {
					"ref": item.ref,
					"is_contained": false,
					"is_transfer": true,
					"get_scp_details": func() -> Dictionary:
						return SCP_UTIL.return_data(item.ref)
				}
				
	# ... and mark rooms that are currently contained 
	if "contained_list" in scp_data:
		for item in scp_data.contained_list:
			# ... or in a state of being transfered to another room
			if item.transfer_status.state:
				var ifloor:int = item.transfer_status.location.floor
				var iring:int = item.transfer_status.location.ring
				var iroom:int = item.transfer_status.location.room	
				new_room_config.floor[ifloor].ring[iring].room[iroom].scp_data = {
					"ref": item.ref,
					"is_contained": true,
					"is_transfer": true,
					"get_scp_details": func() -> Dictionary:
						return SCP_UTIL.return_data(item.ref)
				}			
			
			var scp_details:Dictionary = SCP_UTIL.return_data(item.ref)
			var floor:int = item.location.floor
			var ring:int = item.location.ring
			var room:int = item.location.room	
			
			# add to ref count
			new_room_config.floor[floor].ring[ring].scp_refs.push_back(item.ref)
			
			# update the scp data and utility functions
			new_room_config.floor[floor].ring[ring].room[room].scp_data = {
				"ref": item.ref,
				"is_contained": true,
				"is_transfer": item.transfer_status.state,
				"get_operating_costs": func() -> Array:
					return SCP_UTIL.return_ongoing_containment_rewards(item.ref),	
				"get_scp_details": func() -> Dictionary:
					return SCP_UTIL.return_data(item.ref),
				"get_researcher_details": func() -> Dictionary:
					return RESEARCHER_UTIL.return_data_with_uid(item.lead_researcher.uid) if !item.lead_researcher.is_empty() else {},
				"get_testing_details": func() -> Dictionary:
					return item.current_testing
			}

			# first add scp ref to list to both ring and floor			
			new_room_config.floor[floor].scp_refs.push_back(item.ref)
			new_room_config.floor[floor].ring[ring].scp_refs.push_back(item.ref)

	
	# mark rooms that are under construction...
	for item in timeline_array:		
		match item.action:
			ACTION.AQ.BUILD_ITEM:
				var floor:int = item.location.floor
				var ring:int = item.location.ring
				var room:int = item.location.room		
				new_room_config.floor[floor].ring[ring].room[room].build_data = {
					"ref": item.ref
				}				

	# mark rooms that are already built...
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		var designation:String = U.location_to_designation(item.location)
		var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)

		# if facility is built, clear build_data 
		new_room_config.floor[floor].ring[ring].room[room].build_data = {}
		
		# add to ref count
		new_room_config.floor[floor].ring[ring].room_refs.push_back(item.ref)		

		# updatae room config with ref and utility functions
		new_room_config.floor[floor].ring[ring].room[room].room_data = {
			"ref": item.ref,
			"get_room_details": func() -> Dictionary:
				return ROOM_UTIL.return_data(item.ref),
			"get_is_activated": func() -> bool:
				return base_states.room[designation].is_activated,
			"get_operating_costs": func() -> Array:
				return ROOM_UTIL.return_operating_cost(item.ref)
		}
		
	# mark rooms and push to subscriptions
	for floor_index in new_room_config.floor.size():		
		# add brownout state if applicable
		new_room_config.floor[floor_index].in_brownout = base_states.base.in_brownout
		new_room_config.floor[floor_index].is_powered = base_states.floor[str(floor_index)].is_powered
		new_room_config.floor[floor_index].in_lockdown = base_states.floor[str(floor_index)].in_lockdown
		
		for ring_index in new_room_config.floor[floor_index].ring.size():					
			var ring_designation:String = "%s%s" % [floor_index, ring_index]

			## transfer in_lockdown state
			new_room_config.floor[floor_index].ring[ring_index].emergency_mode = base_states.ring[ring_designation].emergency_mode	
			
			for room_index in new_room_config.floor[floor_index].ring[ring_index].room.size():
				var room_designation:String = "%s%s%s" % [floor_index, ring_index, room_index]
				var config_data:Dictionary = new_room_config.floor[floor_index].ring[ring_index].room[room_index]
	
				if !config_data.build_data.is_empty():
					under_construction_rooms.push_back(room_designation)
				if !config_data.room_data.is_empty():
					built_rooms.push_back(room_designation)
	

	SUBSCRIBE.under_construction_rooms = under_construction_rooms
	SUBSCRIBE.built_rooms = built_rooms
	SUBSCRIBE.room_config = new_room_config	
	
	update_metrics(new_room_config)
# -----------------------------------

# -----------------------------------
func update_metrics(new_room_config:Dictionary) -> void:

	# now update all metrics once everything has been attached
	for floor_index in new_room_config.floor.size():
		for ring_index in new_room_config.floor[floor_index].ring.size():
			# reset metrics before recalcualting them
			var metric_defaults:Dictionary = {
				RESOURCE.BASE_METRICS.MORALE: 0,
				RESOURCE.BASE_METRICS.SAFETY: 0,
				RESOURCE.BASE_METRICS.READINESS: 0
			}

			for room_index in new_room_config.floor[floor_index].ring[ring_index].room.size():
				var room_extract:Dictionary = ROOM_UTIL.extract_room_details({"floor": floor_index, "ring": ring_index, "room": room_index}, new_room_config)
				for key in room_extract.metric_details.total:
					var amount:int = room_extract.metric_details.total[key]
					metric_defaults[key] += amount
			
			# first, compile all the metrics from rooms, scps and researchers
			new_room_config.floor[floor_index].ring[ring_index].metrics = metric_defaults
			
			var in_lockdown:bool = new_room_config.floor[floor_index].in_lockdown
			if in_lockdown:
					metric_defaults[RESOURCE.BASE_METRICS.READINESS] += 3
					metric_defaults[RESOURCE.BASE_METRICS.MORALE] -= 3
			else:
				# then add any bonuses from the emergency states
				var emergency_mode:int = new_room_config.floor[floor_index].ring[ring_index].emergency_mode
				match emergency_mode:
					ROOM.EMERGENCY_MODES.CAUTION:
						metric_defaults[RESOURCE.BASE_METRICS.SAFETY] += 1
						metric_defaults[RESOURCE.BASE_METRICS.READINESS] += 1
						metric_defaults[RESOURCE.BASE_METRICS.MORALE] -= 2
					ROOM.EMERGENCY_MODES.WARNING:
						metric_defaults[RESOURCE.BASE_METRICS.SAFETY] += 3
						metric_defaults[RESOURCE.BASE_METRICS.MORALE] -= 3
					ROOM.EMERGENCY_MODES.DANGER:
						metric_defaults[RESOURCE.BASE_METRICS.READINESS] += 3
						metric_defaults[RESOURCE.BASE_METRICS.MORALE] -= 3
					
		
	SUBSCRIBE.room_config = new_room_config	
# -----------------------------------

# -----------------------------------
func check_events(ref:int, event_ref:SCP.EVENT_TYPE, skip_wait:bool = false) -> Dictionary:
	var res:Dictionary = find_in_contained(ref)
	var index:int = res.index
	var list_data:Dictionary = res.data
	var event:Dictionary = SCP_UTIL.check_for_events(ref, event_ref, get_data_snapshot, get_self_ref_callable(ref))
	var event_arr:Array = []
	if !event.event_instructions.is_empty():
		var event_id:int = event.event_id
		
		# add number of times an event has been triggered
		var event_type_id:String = "%s%s" % [event_ref, event_id]
		if event_type_id not in list_data.event_type_count:
			scp_data.contained_list[index].event_type_count[event_type_id] = {
				"count": 0
			}
		scp_data.contained_list[index].event_type_count[event_type_id].count += 1
			
		# update scp data first
		SUBSCRIBE.scp_data = scp_data
	
		if !skip_wait:
			await wait_please()
		
		event_data = [event]
		return await on_events_complete
		
	return {}
# -----------------------------------

# -----------------------------------
func check_testing_events(ref:int, testing_ref:SCP.TESTING) -> void:
	var res:Dictionary = find_in_contained(ref)
	var index:int = res.index
	var list_data:Dictionary = res.data	
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(list_data.location)
	
	# add to testing count
	if testing_ref not in list_data.testing_count:
		list_data.testing_count[testing_ref] = 0 
	list_data.testing_count[testing_ref] += 1
	var test_count:int = list_data.testing_count[testing_ref]
		
	var event:Dictionary = SCP_UTIL.check_for_testing_events(ref, testing_ref, room_extract, test_count)
	var event_arr:Array = []
	if !event.event_instructions.is_empty():
		event_data = [event]
		await on_events_complete
# -----------------------------------

# -----------------------------------
func calculate_daily_costs(costs:Array) -> void:
	# MINUS RESOURCES
	for cost in costs:
		resources_data[cost.resource_ref].amount += cost.amount
		var capacity:int = resources_data[cost.resource_ref].capacity
		match cost.resource_ref:
			#----------------------------
			# trigger brownout status effect if energy is less < 2
			RESOURCE.TYPE.ENERGY:
				var new_val:int = U.min_max(resources_data[cost.resource_ref].amount, 0, capacity)
				resources_data[cost.resource_ref].amount = new_val
				
				# not enough power, enter brownout state
				base_states.base.in_brownout = new_val == 0
				
				if new_val == 0:
					var props:Dictionary = {
						"count": base_states.count.in_brownout,
						"onSelection": func(val:EVT.BROWNOUT_OPTIONS) -> void:
							match val:
								EVT.BROWNOUT_OPTIONS.EMERGENCY_GENERATORS:
									resources_data[cost.redsource_ref].amount = 50
									base_states.base.in_brownout = false
								EVT.BROWNOUT_OPTIONS.DO_NOTHING:
									pass
									
					}
					await triggger_event(EVT.TYPE.SITEWIDE_BROWNOUT, props)
			#----------------------------
			# trigger in debt if less than 50.  
			RESOURCE.TYPE.MONEY:
				var new_val:int = U.min_max(resources_data[cost.resource_ref].amount, -50, capacity)
				resources_data[cost.resource_ref].amount = new_val
				base_states.base.in_debt = new_val < 0

				if new_val < -5:
					var props:Dictionary = {
						"count": base_states.counts.in_debt,
						"onSelection": func(val:EVT.IN_DEBT_OPTIONS) -> void:
							match val:
								EVT.IN_DEBT_OPTIONS.EMERGENCY_FUNDS:
									resources_data[cost.resource_ref].amount = 20
									base_states.base.in_debt = false
								EVT.IN_DEBT_OPTIONS.DO_NOTHING:
									pass
									
					}
					await triggger_event(EVT.TYPE.IN_DEBT_WARNING, props)
			#----------------------------
			# all other resources, minus until 
			_:
				var new_val:int = U.min_max(resources_data[cost.resource_ref].amount, 0, capacity)
				resources_data[cost.resource_ref].amount = new_val	
# -----------------------------------

# -----------------------------------
func end_of_turn_metrics_event_count() -> int:
	var count:int = 0
	for floor_index in room_config.floor.size():
		for ring_index in room_config.floor[floor_index].ring.size():
			var ring_data:Dictionary = room_config.floor[floor_index].ring[ring_index]			
			var room_refs:Array = ring_data.room_refs
			var scp_refs:Array = ring_data.scp_refs	
			
			# IF ANY OF THE METRICS ARE NEGATIVE/POSTIVE
			if ring_data.metrics[progress_data.next_metric] != 0:
				count += 1
	
	return count
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
				var extract_data:Dictionary = ROOM_UTIL.extract_room_details({"floor": floor_index, "ring": ring_index, "room": room_index})
				var is_room_empty:bool = extract_data.is_room_empty
				var is_room_active:bool = extract_data.is_room_active
				var is_scp_empty:bool = extract_data.is_scp_empty
				var is_scp_contained:bool = extract_data.is_scp_contained
				var is_scp_transfering:bool = extract_data.is_scp_transfering
				var is_scp_testing:bool = extract_data.is_scp_testing
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
				if !is_scp_empty and is_scp_contained and !is_scp_transfering:
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
					if is_scp_testing:
						for researcher in researchers:
							var science_amount:int = 1
							var xp_amount:int = 2 - (researchers.size() - 1)   # 2xp if 1 researcher attached, 1xp if 2 are attached
							for specilization in researcher.specializations:
								if specilization in scp_details.researcher_preferences:
									science_amount = scp_details.researcher_preferences[specilization]
							
							var science_diff:Array = [{
								"amount": science_amount, 
								"resource_ref": RESOURCE.TYPE.SCIENCE
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
func execute_random_scp_events() -> void:
	# CHECK FOR RANDOMIZED EVENTS
	var event_data_arr = []
	for index in scp_data.contained_list.size():
		var data:Dictionary = scp_data.contained_list[index]
		var event_count:int = 0
		var event_res:Dictionary = {}

		if data.days_in_containment > 0:
			# check for specific day event first...
			event_res = await check_events(data.ref, SCP.EVENT_TYPE.DAY_SPECIFIC, true) 
			if event_res.is_empty():event_count += 1
				
				# ... then check for testing events
			if !data.current_testing.is_empty():
				event_res = await check_events(data.ref, SCP.EVENT_TYPE.DURING_TESTING, true)	
				if event_res.is_empty():event_count += 1
				
			# ... then check for transfer events
			if data.transfer_status.state:	
				event_res = await check_events(data.ref, SCP.EVENT_TYPE.DURING_TRANSFER, true)	
				if event_res.is_empty():event_count += 1
				
			# ... then check for random events 
			if event_count == 0:
				await check_events(data.ref, SCP.EVENT_TYPE.RANDOM_EVENTS, true)
# -----------------------------------

# -----------------------------------
func execute_metric_check() -> void:
	if end_of_turn_metrics_event_count() > 0:
		# SCAN RING FOR ANY ROOM REFS/SCP REFS
		for floor_index in room_config.floor.size():
			for ring_index in room_config.floor[floor_index].ring.size():
				var ring_data:Dictionary = room_config.floor[floor_index].ring[ring_index]			
				var room_refs:Array = ring_data.room_refs
				var scp_refs:Array = ring_data.scp_refs	
				var metric_val:int = ring_data.metrics[progress_data.next_metric]
				# IF ANY OF THE METRICS ARE NEGATIVE/POSTIVE
				if metric_val != 0:

					# EVENTS TRIGGER ONLY IF ROOM_REFS OR SCP_REFS ARE AVAILABLE
					SUBSCRIBE.current_location = {"floor": floor_index, "ring": ring_index, "room": 4}
					await wait_please(1.0)
					var event_props:Dictionary = {"metric_val": metric_val, "room_refs": room_refs, "scp_refs": scp_refs, "onSelection": func(val):print(val)}
					match progress_data.next_metric:
						RESOURCE.BASE_METRICS.MORALE:
							await triggger_event(EVT.TYPE.MORALE, event_props)
						RESOURCE.BASE_METRICS.SAFETY:
							await triggger_event(EVT.TYPE.SAFETY, event_props)
						RESOURCE.BASE_METRICS.READINESS:
							await triggger_event(EVT.TYPE.READINESS, event_props)



	await wait_please(1.0)		
# -----------------------------------

# -----------------------------------
func next_day() -> void:
	current_phase = PHASE.RESOURCE_COLLECTION
# -----------------------------------
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
#region GAMEPLAY FUNCS
# ---------------------
func triggger_event(event:EVT.TYPE, props:Dictionary = {}) -> void:
	event_data = [EVENT_UTIL.run_event(event, props)]
	await on_events_complete
# ---------------------	
	
# ---------------------
func game_over() -> void:
	await show_only([])	
	var props:Dictionary = {
		"onSelection": func(val:EVT.GAME_OVER_OPTIONS) -> void:
			match val:
				EVT.GAME_OVER_OPTIONS.RESTART:
					start_new_game()
	}	
	triggger_event(EVT.TYPE.GAME_OVER, props)
# ---------------------
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
#region ROOM ACTION QUEUE (assign/unassign/dismiss, etc)
func set_floor_lockdown(from_location:Dictionary, state:bool) -> Dictionary:
	var title:String
	var subtitle:String

	title = "Lockdown floor %s?" % [current_location.floor] if state else "Remove lockdown."
	subtitle = "All wings will have their actions frozen." if state else ""
			
	ConfirmModal.set_props(title, subtitle)
	await show_only([ConfirmModal, Structure3dContainer])	
	var response:Dictionary = await ConfirmModal.user_response

	match response.action:
		ACTION.NEXT:			
			base_states.floor[str(from_location.floor)].in_lockdown = state
			SUBSCRIBE.base_states = base_states

	#on_confirm_complete.emit()
	await restore_player_hud()
	return {"has_changes": response.action == ACTION.NEXT}	
# ---------------------

# ------------------------------------------------------------------------------	
func set_wing_emergency_mode(from_location:Dictionary, mode:ROOM.EMERGENCY_MODES) -> Dictionary:
	var title:String
	var subtitle:String
	
	match mode:
		ROOM.EMERGENCY_MODES.DANGER:
			title = "SET ALERT LEVEL TO DANGER?"
			subtitle = "All actions (research, construction, etc) will be halted.  READINESS will be increased by 5, MORALE will be decreaed by 3."
		ROOM.EMERGENCY_MODES.WARNING:
			title = "SET ALERT LEVEL WARNING?"
			subtitle = "All actions will take longer.  SAFETY will be increased by 5, MORALE will be decreaed by 3."			
		ROOM.EMERGENCY_MODES.CAUTION:
			title = "SET ALERT LEVEL CAUTION?"
			subtitle = "SAFETY and READINESS will be increased by 1, MORALE will decrease by 1."						
		ROOM.EMERGENCY_MODES.NORMAL:
			title = "SET ALERT LEVEL BACK TO NORMAL?"
			subtitle = "Metrics will be returned to normal."

	ConfirmModal.set_props(title, subtitle)
	await show_only([ConfirmModal, Structure3dContainer])	
	var response:Dictionary = await ConfirmModal.user_response
	
	match response.action:
		ACTION.NEXT:			
			var designation:String = "%s%s" % [from_location.floor, from_location.ring]
			base_states.ring[designation].emergency_mode = mode
			SUBSCRIBE.base_states = base_states
#
	#on_confirm_complete.emit()
	await restore_player_hud()	
	return {"has_changes": response.action == ACTION.NEXT}	
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func activate_floor(from_location:Dictionary) -> Dictionary:
	SUBSCRIBE.suppress_click = true

	var activated_count:int = 0
	for n in room_config.floor.size():
		if base_states.floor[str(n)].is_powered:
			activated_count += 1
	var activation_cost:int = activated_count * 10
	var can_purchase:bool = resources_data[RESOURCE.TYPE.ENERGY].amount >= activation_cost
	
	ConfirmModal.set_props("Activate this floor?", "It will require %s energy (you have %s available)." % [activation_cost, resources_data[RESOURCE.TYPE.ENERGY].amount])
	if !can_purchase:
		ConfirmModal.cancel_only = true
	await show_only([ConfirmModal])	
	var response:Dictionary = await ConfirmModal.user_response
	
	match response.action:		
		ACTION.NEXT:
			base_states.floor[str(from_location.floor)].is_powered = true
			SUBSCRIBE.base_states = base_states
			
	restore_player_hud()
	return {"has_changes": response.action == ACTION.NEXT}	
# ------------------------------------------------------------------------------
		
# ------------------------------------------------------------------------------	
func construct_room(from_location:Dictionary) -> Dictionary:
	SUBSCRIBE.suppress_click = true
	current_shop_step = SHOP_STEPS.START_ROOM
	var made_purchase:bool = await on_store_purchase_complete
	restore_player_hud()
	return {"has_changes": made_purchase}
# ---------------------

# ---------------------
func cancel_construction(from_location:Dictionary) -> Dictionary:
	var floor_index:int = from_location.floor
	var ring_index:int = from_location.ring
	var room_index:int = from_location.room
	var filtered_arr:Array = timeline_array.filter(func(i): return (i.location.floor == floor_index and i.location.ring == ring_index and i.location.room == room_index) and i.action == ACTION.AQ.BUILD_ITEM)
	var has_changes:bool = await cancel_action_queue(filtered_arr[0])
	return {"has_changes": has_changes}
# ---------------------	

# ---------------------
func activate_room(from_location:Dictionary, room_ref:int, is_activated:bool, show_confirm_modal:bool = true) -> Dictionary:
	var stop:bool = false
	# with confirm modal
	if show_confirm_modal:
		ConfirmModal.set_props("Activate this room?" if is_activated else "Deactivate this room")
		await show_only([ConfirmModal, Structure3dContainer])	
		var response:Dictionary = await ConfirmModal.user_response
		match response.action:		
			ACTION.BACK:
				stop = true
		
		restore_player_hud()

	# without confirm modal
	if !stop:
		resources_data = ROOM_UTIL.calculate_activation_cost(room_ref, resources_data, is_activated)
		resources_data = ROOM_UTIL.calculate_activation_effect(room_ref, resources_data, is_activated)
		SUBSCRIBE.resources_data = resources_data
		# set is activated state here
		base_states.room[U.location_to_designation(from_location)].is_activated = is_activated
		SUBSCRIBE.base_states = base_states
		
	return {"has_changes": !stop}
# ---------------------

# ---------------------
func reset_room(from_location:Dictionary) -> Dictionary:
	var floor_index:int = from_location.floor
	var ring_index:int = from_location.ring
	var room_index:int = from_location.room
	var reset_arr:Array = purchased_facility_arr.filter(func(i): return (i.location.floor == floor_index and i.location.ring == ring_index and i.location.room == room_index))
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(from_location)
	
	if reset_arr.size() > 0:
		ConfirmModal.set_props("This room will be destroyed.", "Room will be deactivated and resources will be refunded." if room_extract.room.is_activated else "")
			
		await show_only([ConfirmModal, Structure3dContainer])	
		var response:Dictionary = await ConfirmModal.user_response
		match response.action:		
			ACTION.NEXT:
				var reset_item:Dictionary = reset_arr[0]
				if room_extract.room.is_activated:
					activate_room(from_location, room_extract.room.details.ref, false, false)
					
				SUBSCRIBE.purchased_facility_arr = purchased_facility_arr.filter(func(i): return !(i.location.floor == floor_index and i.location.ring == ring_index and i.location.room == room_index))
				SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(reset_item.ref, resources_data, true)
		
		restore_player_hud()
		
		return {"has_changes": response.action != ACTION.BACK}
		
	return {"has_changes": false}		
# ---------------------

#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
#region SCP ACTION QUEUE (assign/unassign/dismiss, etc)
func on_completed_action(timeline_item:Dictionary) -> void:
	match timeline_item.action:
		# RUNS AFTER TESTING ACCESSMENT IS COMPLETED
		ACTION.AQ.ACCESSING:
			var scp_ref:int = timeline_item.ref 
			var event_res:Dictionary = await check_events(scp_ref, SCP.EVENT_TYPE.START_TESTING, true)
			var testing_ref:int = event_res.val			
			update_scp_testing(timeline_item.ref, testing_ref)
		# ----------------------------
		# RUNS AFTER A TESTING EVENT HAS COMPLETEDperform_action
		ACTION.AQ.TESTING:  
			var scp_ref:int = timeline_item.ref 
			var testing_ref:int = timeline_item.props.testing_ref
			var utilized_amounts:Dictionary = timeline_item.props.utilized_amounts
			var res:Dictionary = find_in_contained(scp_ref)
			var index:int = res.index
			
			# refunds utilized amounts
			SUBSCRIBE.resources_data = SCP_UTIL.calculate_refunded_utilizied(utilized_amounts, resources_data)

			# trigger post research event
			await check_testing_events(scp_ref, testing_ref)
			
			# update reesearch completed
			if testing_ref not in scp_data.contained_list[index].research_completed:
				scp_data.contained_list[index].research_completed.push_back(testing_ref)
				
			# promote researchers
			if RESEARCHER_UTIL.check_for_promotions().size() > 0:
				promote_researchers()
				await on_promotions_complete

			# clear out testing data
			scp_data.contained_list[index].current_testing = {}
			
			SUBSCRIBE.scp_data = scp_data
		# ----------------------------
		ACTION.AQ.CONTAIN:
			# first, remove from available list...
			scp_data.available_list = scp_data.available_list.filter(func(i):return i.ref != timeline_item.ref)
			# then add to contained list...
			var new_contained_item:Dictionary = create_new_contained_item(timeline_item.ref, timeline_item.location)
			scp_data.contained_list.push_back(new_contained_item)

			SUBSCRIBE.resources_data = SCP_UTIL.calculate_initial_containment_bonus(timeline_item.ref, resources_data)
			SUBSCRIBE.scp_data = scp_data

			await check_events(timeline_item.ref, SCP.EVENT_TYPE.AFTER_CONTAINMENT)
		# ----------------------------
		ACTION.AQ.TRANSFER:
			scp_data.contained_list = scp_data.contained_list.map(func(i):
				if i.ref == timeline_item.ref:
					# move to new location
					i.location = i.transfer_status.location
					# remove transfer status
					i.transfer_status = {
						"state": false, 
						"days_till_complete": -1,
						"location": {}	
					}
				return i
			)
			
			SUBSCRIBE.scp_data = scp_data
			await check_events(timeline_item.ref, SCP.EVENT_TYPE.AFTER_TRANSFER)
		# ----------------------------
			
	remove_from_timeline(timeline_item)
# -----------------------------------

# -----------------------------------
func cancel_action_queue(timeline_item:Dictionary, include_restore:bool = true) -> bool:
	match timeline_item.action:
		ACTION.AQ.CONTAIN:
			ConfirmModal.set_props("Cancel containment?", "There are no costs for this action.")
		ACTION.AQ.TRANSFER:
			ConfirmModal.set_props("Cancel transfer?", "There are no costs for this action.")					
		ACTION.AQ.BUILD_ITEM:
			ConfirmModal.set_props("Cancel construction?", "Resources will be refunded.")
		ACTION.AQ.RESEARCH_ITEM:
			ConfirmModal.set_props("Cancel research?", "Resources will be refunded.")						
		ACTION.AQ.BASE_ITEM:
			ConfirmModal.set_props("Cancel base upgrade?", "Resources will be refunded.")
		ACTION.AQ.ACCESSING:
			ConfirmModal.set_props("Cancel accessing SCP?", "Unspent resources will be refunded.")
		ACTION.AQ.TESTING:
			ConfirmModal.set_props("Cancel SCP testing?", "Unspent resources will be refunded.")			
		_:
			ConfirmModal.set_props("Missing instruction...", "Check for errors.")
			
	await show_only([Structure3dContainer, ConfirmModal])	
	var response:Dictionary = await ConfirmModal.user_response
	match response.action:
		ACTION.NEXT:
			match timeline_item.action:
				ACTION.AQ.BUILD_ITEM:
					SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(timeline_item.ref, resources_data, true)
				ACTION.AQ.RESEARCH_ITEM:
					SUBSCRIBE.resources_data = RD_UTIL.calculate_purchase_cost(timeline_item.ref, resources_data, true)
				ACTION.AQ.BASE_ITEM:
					SUBSCRIBE.resources_data = BASE_UTIL.calculate_purchase_cost(timeline_item.ref, resources_data, true)
				ACTION.AQ.CONTAIN:
					cancel_scp_containment(timeline_item.ref)
				ACTION.AQ.TRANSFER:
					cancel_scp_transfer(timeline_item.ref)
				ACTION.AQ.ACCESSING:
					stop_scp_testing(timeline_item.ref)
				ACTION.AQ.TESTING:
					stop_scp_testing(timeline_item.ref)
					
			await remove_from_timeline(timeline_item)
	
	if include_restore:
		await restore_player_hud()
		
	return response.action == ACTION.NEXT
# -----------------------------------

# -----------------------------------
func remove_from_timeline(timeline_item:Dictionary) -> void:	
	SUBSCRIBE.timeline_array = timeline_array.filter(func(i): return i.uid != timeline_item.uid)
	#await ActionQueueContainer.remove_from_queue([timeline_item])
# -----------------------------------

# -----------------------------------
func add_timeline_item(dict:Dictionary, props:Dictionary = {}) -> void:
	timeline_array.push_back({
		"uid": U.generate_uid(),
		"action": dict.action,
		"ref": dict.ref,
		"title": dict.title,
		"icon": dict.icon,
		"description": dict.description,
		"completed_at": progress_data.day + dict.completed_at,
		"location": dict.location,
		"props": props
	})
	
	SUBSCRIBE.timeline_array = timeline_array
# -----------------------------------
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
#region SCP FUNCS (assign/unassign/dismiss, etc)
# -----------------------------------
func view_scp_details() -> void:
	current_contain_step = CONTAIN_STEPS.START
	await on_contain_reset
	
	

# -----------------------------------
func create_new_contained_item(ref:int, location:Dictionary) -> Dictionary:
	return { 
		"ref": ref,
		"unlocked": [],
		"location": location,
		"days_in_containment": 0,
		"attached_researchers": [],
		"testing_count": {
			
		},
		"research_completed": [
			#0, 1 [RESEARCH.ONE, RESEARCH.TWO, etc]
		],
		"event_type_count": {
			#["type/event_id"]: count[int]
		},
		"current_testing": {
			#"research_id": -1,
			#"progress": -1 			
		},
		"transfer_status": {
			"state": false, 
			"days_till_complete": -1,
			"location": {}
		}	
	}
# -----------------------------------

# -----------------------------------
func find_in_contained_via_location(from_location:Dictionary) -> Dictionary:
	var index:int = -1
	var res_data:Dictionary = {} 

	for ind in scp_data.contained_list.size():
		var data:Dictionary = scp_data.contained_list[ind]
		if data.location.floor == from_location.floor and data.location.ring == from_location.ring and data.location.room == from_location.room:
			index = ind
			res_data = data
			break	
	
	return {
		"index": index,
		"data": res_data
	}
# -----------------------------------	

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

# -----------------------------------
func contain_scp(from_location:Dictionary, scp_ref:int) -> Dictionary:
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)	
	ConfirmModal.set_props("Contain %s here?" % [scp_details.name], "", scp_details.img_src)
	await show_only([Structure3dContainer, ConfirmModal])
	var response:Dictionary = await ConfirmModal.user_response	
	match response.action:
		ACTION.NEXT:	
			#var new_contained_item:Dictionary = create_new_contained_item(scp_ref, from_location)
			#scp_data.contained_list.push_back(new_contained_item)
#
			#SUBSCRIBE.resources_data = SCP_UTIL.calculate_initial_containment_bonus(scp_ref, resources_data)
			#SUBSCRIBE.scp_data = scp_data
			#
			#await check_events(scp_ref, SCP.EVENT_TYPE.AFTER_CONTAINMENT)
		
						
			scp_data.available_list = scp_data.available_list.map(func(i) -> Dictionary:
				if i.ref == scp_details.ref:
					i.transfer_status = {
						"state": true, 
						"days_till_complete": 1, #scp_details.containment_time.call(),
						"location": from_location.duplicate(),
					}
				return i
			)

			add_timeline_item({
				"action": ACTION.AQ.CONTAIN,
				"ref": scp_details.ref,
				"title": scp_details.name, 
				"icon": SVGS.TYPE.CONTAIN,
				"completed_at": 1, #scp_details.containment_time.call(),
				"description": "CONTAINMENT IN PROGRESS",
				"location": from_location.duplicate()
			})			
			
			SUBSCRIBE.scp_data = scp_data

	restore_player_hud()		
	return {"has_changes": response.action != ACTION.BACK}
# -----------------------------------

# -----------------------------------
func transfer_scp(from_location:Dictionary) -> Dictionary:
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(from_location)
	var scp_details:Dictionary = room_extract.scp.details
	var is_looped:bool = false
	
	Structure3dContainer.select_location(true)
	Structure3dContainer.placement_instructions = [] #ROOM_UTIL.return_placement_instructions(selected_shop_item.id)
	SUBSCRIBE.unavailable_rooms = SCP_UTIL.return_unavailable_rooms(scp_details.ref)	
	await show_only([Structure3dContainer ])	
	var structure_response:Dictionary = await Structure3dContainer.user_response
	Structure3dContainer.freeze_input = true
	Structure3dContainer.select_location(false)
	SUBSCRIBE.unavailable_rooms = []
	
	if structure_response.action == ACTION.NEXT:
		scp_data.contained_list = scp_data.contained_list.map(func(i) -> Dictionary:
			if i.ref == scp_details.ref:
				i.transfer_status = {
					"state": true, 
					"days_till_complete": scp_details.containment_time.call(),
					"location": current_location.duplicate(),
				}
			return i
		)				
				
		add_timeline_item({
			"action": ACTION.AQ.TRANSFER,
			"ref": scp_details.ref,
			"title": "TRANSFER IN PROGRESS",
			"icon": SVGS.TYPE.CONTAIN,
			"completed_at": scp_details.containment_time.call(),
			"description": "%s %s." % [scp_details.name, "TRANSFER" ],
			"location": current_location.duplicate()
		})			
	
	await restore_player_hud()		
	return {"has_changes": structure_response.action == ACTION.NEXT}
# -----------------------------------

# -----------------------------------
func upgrade_scp(from_location:Dictionary) -> Dictionary:
	ConfirmModal.set_props("Upgrade SCP?")
	await show_only([Structure3dContainer, ConfirmModal])
	var response:Dictionary = await ConfirmModal.user_response	
	match response.action:
		ACTION.NEXT:	
			pass
		
	restore_player_hud()		
	return {"has_changes": response.action != ACTION.BACK}
# -----------------------------------

# -----------------------------------
func contain_scp_cancel(from_location:Dictionary, action:ACTION.AQ) -> Dictionary:
	ConfirmModal.set_props("Cancel containment?")
	await show_only([Structure3dContainer, ConfirmModal])
	var response:Dictionary = await ConfirmModal.user_response	
	match response.action:
		ACTION.NEXT:	
			var floor_index:int = from_location.floor
			var ring_index:int = from_location.ring
			var room_index:int = from_location.room
			var scp_details:Dictionary = room_config.floor[floor_index].ring[ring_index].room[room_index].scp_data.get_scp_details.call()
			var filtered_arr:Array = timeline_array.filter(func(i): return i.ref == scp_details.ref and i.action == action)
			match action:
				ACTION.AQ.CONTAIN:
					cancel_scp_containment(scp_details.ref)
				ACTION.AQ.TRANSFER:
					cancel_scp_transfer(scp_details.ref)
			remove_from_timeline(filtered_arr[0])
		
	restore_player_hud()		
	return {"has_changes": response.action != ACTION.BACK}
# -----------------------------------

# -----------------------------------
func set_scp_testing_state(from_location:Dictionary, is_testing:bool) -> void:
	var scp_list_data:Dictionary = find_in_contained_via_location(from_location)
	if is_testing:
		await start_scp_testing(scp_list_data.data.ref)
	else:
		pass
		#var filtered_arr:Array = action_queue_data.filter(func(i): return (i.location.floor == from_location.floor and i.location.ring == from_location.ring and i.location.room == from_location.room))
		#await cancel_action_queue(filtered_arr[0])
		
	restore_player_hud()
# -----------------------------------	

# -----------------------------------
func start_scp_testing(scp_ref:int) -> void:
	var event_res:Dictionary = await check_events(scp_ref, SCP.EVENT_TYPE.START_TESTING, true)
	var testing_ref:int = event_res.val			
	update_scp_testing(scp_ref, testing_ref)
	## resets it in the available list
	#var res:Dictionary = find_in_contained(ref)
	#var index:int = res.index
	#var list_data:Dictionary = res.data
	#var scp_details:Dictionary = SCP_UTIL.return_data(ref)
	#
	## not a confirmation modal - just a text one
	#ConfirmModal.confirm_only = true
	#ConfirmModal.set_props("Testing on %s has begun." % [scp_details.name])
	#await show_only([ConfirmModal])	
	#var response:Dictionary = await ConfirmModal.user_response	
	#
	## add placeholder
	#scp_data.contained_list[index].current_testing = { 
		#"testing_ref": -1,
		#"progress": -1 
	#}	
	#
	#add_timeline_item({
		#"action": ACTION.AQ.ACCESSING,
		#"ref": scp_details.ref,
		#"title_btn": {
			#"title": "ACCESSING",
			#"icon": SVGS.TYPE.CONTAIN,
		#},
		#"completed_at": 1,
		#"description": "Accessing %s." % [scp_details.name],
		#"location": list_data.location
	#})	
	#
#
	#
	#SUBSCRIBE.action_queue_data = action_queue_data
	#SUBSCRIBE.scp_data = scp_data
# -----------------------------------

# -----------------------------------
func update_scp_testing(scp_ref:int, testing_ref:int) -> void:
	var res:Dictionary = find_in_contained(scp_ref)
	var index:int = res.index
	var list_data:Dictionary = res.data
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)

	# canceled
	if testing_ref == -1:
		scp_data.contained_list[index].current_testing = {}
	else:
		# calculate resources data usage
		SUBSCRIBE.resources_data = 	SCP_UTIL.calculate_testing_costs(scp_ref, testing_ref, resources_data)
		
		# else add research id and being progress
		scp_data.contained_list[index].current_testing = { 
			"testing_ref": testing_ref,
			"progress": 0 
		}
		
		add_timeline_item({
			"action": ACTION.AQ.TESTING,
			"ref": scp_ref,
			"title": "TESTING",
			"icon": SVGS.TYPE.RESEARCH,
			"completed_at": 1,
			"description": "Testing %s." % [scp_details.name],
			"location": list_data.location,
		}, {
			"testing_ref": testing_ref, 
			"utilized_amounts": SCP_UTIL.return_utilized_amounts(scp_ref, testing_ref)
		})			
		
# -----------------------------------

# -----------------------------------
func stop_scp_testing(ref:int) -> void:
	var res:Dictionary = find_in_contained(ref)
	var index:int = res.index
	
	scp_data.contained_list[index].current_testing = {}	

	SUBSCRIBE.scp_data = scp_data	
# -----------------------------------

# -----------------------------------
func cancel_scp_transfer(ref:int) -> void:
	var res:Dictionary = find_in_contained(ref)
	var index:int = res.index
	
	scp_data.contained_list[index].transfer_status = { 
		"state": false, 
		"days_till_complete": -1,
		"location": {}
	}	

	SUBSCRIBE.scp_data = scp_data
# -----------------------------------

# -----------------------------------
func cancel_scp_containment(ref:int) -> void:
	var res:Dictionary = find_in_available(ref)
	var index:int = res.index
		
	# resets it in the available list
	scp_data.available_list[index].transfer_status = { 
		"state": false, 
		"days_till_complete": -1,
		"location": {}
	}
	
	SUBSCRIBE.scp_data = scp_data
# -----------------------------------

# -----------------------------------	
func destroy_scp(selected_data:Dictionary) -> void:
	pass
# -----------------------------------	

# -----------------------------------	
func on_expired_scp_items_update() -> void:
	pass
# -----------------------------------	
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
#region RESEARCHER FUNCS (assign/unassign/dismiss, etc)
# -----------------------------------
func recruit() -> void:
	current_recruit_step = RECRUIT_STEPS.START
	await on_recruit_complete

# -----------------------------------
func open_researcher_details() -> void:
	current_researcher_step = RESEARCHERS_STEPS.DETAILS_ONLY
	await on_researcher_component_complete
# -----------------------------------

# -----------------------------------
func promote_researchers() -> void:	
	var list:Array = RESEARCHER_UTIL.check_for_promotions()	
	if list.size() == 0:
		on_promotions_complete.emit()
		return
	current_researcher_promotion_step = PROMOTE_RESEARCHER_STEPS.START
	await on_promote_researcher_complete
	promote_researchers()
# -----------------------------------

# -----------------------------------
func assign_researcher(location_data:Dictionary) -> Dictionary:
	current_researcher_step = RESEARCHERS_STEPS.ASSIGN
	var response:Dictionary = await ResearchersContainer.user_response
	
	match response.action:
		ACTION.RESEARCHERS.SELECT:
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
			
	restore_player_hud()
	return {"has_changes": response.action != ACTION.RESEARCHERS.BACK }
# -----------------------------------

# -----------------------------------
func dismiss_researcher(researcher_data:Dictionary) -> void:
	# first, remove from any projects
	#scp_data.contained_list = scp_data.contained_list.map(func(i): 
		#if !i.lead_researcher.is_empty() and (i.lead_researcher.uid == researcher_data.details.uid):
			#i.lead_researcher = {}
		#return i
	#)
	
	hired_lead_researchers_arr = hired_lead_researchers_arr.filter(func(i):
		return i[0] != researcher_data.details.uid	
	)
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
	SUBSCRIBE.scp_data = scp_data
# -----------------------------------

# -----------------------------------
func assign_researcher_to_scp(location:Dictionary, assign:bool) -> void:
	pass
	#var scp_list_data:Dictionary = find_in_contained_via_location(location)
	#print(scp_list_data)
	#if assign:
		#await assign_researcher_to_scp_find_researcher(location)
	#else:
		#await unassign_researcher_to_scp(scp_list_data.data.ref)
		#
	#await restore_player_hud()
	#on_assign_researcher_to_scp_complete.emit()
# -----------------------------------	

# -----------------------------------	
func unassign_researcher(researcher_data:Dictionary, room_details:Dictionary) -> Dictionary:
	pass
	#ConfirmModal.set_props("Remove %s from %s?" % [researcher_data.name, room_details.name if !room_details.is_empty() else "this location."])
	#await show_only([Structure3dContainer, ConfirmModal])
	#
	#var response:Dictionary = await ConfirmModal.user_response
#
	#match response.action:
		#ACTION.NEXT:	
			#SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
				#if i[0] == researcher_data.uid:
					#i[9].assigned_to_room = null
				#return i
			#)
#
	restore_player_hud()
	return {"has_changes": true}
# -----------------------------------	

# -----------------------------------
func assign_researcher_to_scp_find_scp(reseacher_details:Dictionary) -> void:
	pass
	#ContainmentContainer.assign_only = true
	#await show_only([ContainmentContainer])
	#var response:Dictionary = await ContainmentContainer.user_response
	#match response.action:
		#ACTION.CONTAINED.SELECT_FOR_ASSIGN:
			#var res:Dictionary = find_in_contained(response.data.ref)
			#var index:int = res.index
			#var list_data:Dictionary = res.data
			#scp_data.contained_list[index].lead_researcher = {
				#"uid": reseacher_details.details.uid
			#}
			#SUBSCRIBE.scp_data = scp_data	
			#
	#await restore_player_hud()
# -----------------------------------

# -----------------------------------
func unassign_researcher_to_scp(scp_ref:int) -> void:
	var res:Dictionary = find_in_contained(scp_ref)
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	var index:int = res.index
	var list_data:Dictionary = res.data
	var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(list_data.lead_researcher.uid)

	ConfirmModal.set_props("Remove %s as Lead Researcher on %s?" % [researcher_details.name, scp_details.name])
	await show_only([Structure3dContainer, ConfirmModal])
	var response:Dictionary = await ConfirmModal.user_response
	match response.action:
		ACTION.NEXT:	
			scp_data.contained_list[index].lead_researcher = {}
			SUBSCRIBE.scp_data = scp_data
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

func on_tier_unlocked_update(new_val:Dictionary = tier_unlocked) -> void:
	tier_unlocked = new_val

func on_hired_lead_researchers_arr_update(new_val:Array = hired_lead_researchers_arr) -> void:
	hired_lead_researchers_arr = new_val
	resources_data[RESOURCE.TYPE.LEAD_RESEARCHERS] = {
		"amount": hired_lead_researchers_arr.size() 
	} 
	SUBSCRIBE.resources_data = resources_data
	if setup_complete:
		U.debounce("set_room_config", set_room_config)

func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val

func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val

func on_bookmarked_rooms_update(new_val:Array = bookmarked_rooms) -> void:
	bookmarked_rooms = new_val
		
func on_researcher_hire_list_update(new_val:Array = researcher_hire_list) -> void:
	researcher_hire_list = new_val

func on_base_states_update(new_val:Dictionary = base_states) -> void:
	base_states = new_val
	if setup_complete:
		U.debounce("set_room_config", set_room_config)

func on_purchased_facility_arr_update(new_val:Array = purchased_facility_arr) -> void:
	purchased_facility_arr = new_val
	if setup_complete:
		U.debounce("set_room_config", set_room_config)
	
func on_purchased_base_arr_update(new_val:Array = purchased_base_arr) -> void:
	purchased_base_arr = new_val	
	if setup_complete:
		U.debounce("set_room_config", set_room_config)

func on_timeline_array_update(new_val:Array = timeline_array) -> void:
	timeline_array = new_val	
	if setup_complete:
		U.debounce("set_room_config", set_room_config)

func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val
	if setup_complete:
		U.debounce("set_room_config", set_room_config)

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

func on_show_reseachers_update() -> void:
	if !is_node_ready():return
	ResearchersContainer.is_showing = show_reseachers
	showing_states[ResearchersContainer] = show_reseachers
		
func on_show_dialogue_update() -> void:
	if !is_node_ready():return
	DialogueContainer.is_showing = show_dialogue
	showing_states[DialogueContainer] = show_dialogue

func on_show_store_update() -> void:
	if !is_node_ready():return
	StoreContainer.is_showing = show_store
	showing_states[StoreContainer] = show_store

func on_show_containment_status_update() -> void:
	if !is_node_ready():return
	ContainmentContainer.is_showing = show_containment_status
	showing_states[ContainmentContainer] = show_containment_status

func on_show_confirm_modal_update() -> void:
	if !is_node_ready():return
	ConfirmModal.is_showing = show_confirm_modal
	showing_states[ConfirmModal] = show_confirm_modal

func on_show_recruit_update() -> void:
	if !is_node_ready():return
	RecruitmentContainer.is_showing = show_recruit
	showing_states[RecruitmentContainer] = show_recruit

func on_show_resources_update() -> void:
	if !is_node_ready():return
	ResourceContainer.is_showing = show_resources
	showing_states[ResourceContainer] = show_resources

func on_show_objectives_update() -> void:
	if !is_node_ready():return
	ObjectivesContainer.is_showing = show_objectives
	showing_states[ObjectivesContainer] = show_objectives

func on_show_events_update() -> void:
	if !is_node_ready():return
	EventContainer.is_showing = show_events
	showing_states[EventContainer] = show_events
		
func on_show_build_complete_update() -> void:
	if !is_node_ready():return
	BuildCompleteContainer.is_showing = show_build_complete
	showing_states[BuildCompleteContainer] = show_build_complete

func on_show_metrics_update() -> void:
	if !is_node_ready():return
	MetricsContainer.is_showing = show_metrics
	showing_states[MetricsContainer] = show_metrics


func on_show_end_of_phase_update() -> void:
	if !is_node_ready():return
	EndOfPhaseContainer.is_showing = show_end_of_phase
	showing_states[EndOfPhaseContainer] = show_end_of_phase

#func on_show_choices_update() -> void:
	#if !is_node_ready():return
	#ChoiceContainer.is_showing = show_choices
	#showing_states[ChoiceContainer] = show_choices

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

			
			if camera_settings_snapshot.type != CAMERA.TYPE.ROOM_SELECT:
				camera_settings.type = CAMERA.TYPE.ROOM_SELECT
				SUBSCRIBE.camera_settings = camera_settings	
				await U.set_timeout(1.0)						
			
			
			await show_only([Structure3dContainer, ResourceContainer])	
			PhaseAnnouncement.start("RESOURCE COLLECTION")	


			execute_record_audit()
			if progress_data.record.size() > 0:
				for record in progress_data.record:				
					match record.source:
						REFS.SOURCE.FACILITY:
							SUBSCRIBE.current_location = record.data.location
							for item in record.data.diff:
								var resource_details:Dictionary = RESOURCE_UTIL.return_data(item.resource_ref)
								ToastContainer.add("%s %s %s %s" % [record.data.name, "generated" if item.amount > 0 else "spent", item.amount, resource_details.name])				
								await U.set_timeout(0.5)
							
					SUBSCRIBE.resources_data = resources_data		
				
			
			await U.set_timeout(1.0)
			current_phase = PHASE.METRIC_EVENTS
		# ------------------------
		PHASE.METRIC_EVENTS:
			PhaseAnnouncement.start("VIBE CHECK")	
			await show_only([Structure3dContainer, MetricsContainer])	

			for floor_index in room_config.floor.size():		
				for ring_index in room_config.floor[floor_index].ring.size():
					var ring_data:Dictionary = room_config.floor[floor_index].ring[ring_index]
					# IF ANY OF THE METRICS ARE NEGATIVE/POSTIVE
					if ring_data.metrics[progress_data.next_metric] != 0:
						SUBSCRIBE.current_location = {"floor": floor_index, "ring": ring_index, "room": 4}
					
						await U.set_timeout(0.2)
			
			
			await U.set_timeout(1.0)
			current_phase = PHASE.RANDOM_EVENTS
		# ------------------------
		PHASE.RANDOM_EVENTS:
			pass
			current_phase = PHASE.CALC_NEXT_DAY			
		# ------------------------
		PHASE.CALC_NEXT_DAY:
			PhaseAnnouncement.start("ADVANCING THE DAY")	
			await show_only([Structure3dContainer, TimelineContainer])	
			
			# update next metric (goes from MORALE -> 
			progress_data.next_metric = U.min_max(progress_data.next_metric + 1, 0, RESOURCE.BASE_METRICS.size() - 2, true)

			# ADD TO PROGRESS DATA day count
			progress_data.day += 1
				
			# update subscriptions
			SUBSCRIBE.progress_data = progress_data
			SUBSCRIBE.base_states = base_states
			
			var timeline_filter:Array = timeline_array.filter(func(i): return i.completed_at == progress_data.day)	
			if timeline_filter.size() > 0:
				PhaseAnnouncement.start("TIMELINE ITEMS COMPLETE")	
				completed_actions = timeline_filter
				current_action_complete_step = ACTION_COMPLETE_STEPS.START
				await on_complete_build_complete	
			else:	
				await U.set_timeout(1.0)
			current_phase = PHASE.SCHEDULED_EVENTS
		# ------------------------
		PHASE.SCHEDULED_EVENTS:
			# EVENT FIRES
			await show_only([Structure3dContainer])	
			PhaseAnnouncement.start("CONTAINMENT REQUEST")	
			current_select_scp_step = SELECT_SCP_STEPS.START
			await on_scp_select_complete		
			await PhaseAnnouncement.end()
			
			# IF NO EVENTS, NO NEED FOR AWAIT
			#PhaseAnnouncement.end()
			
			current_phase = PHASE.CONCLUDE
		# ------------------------
		PHASE.CONCLUDE:			
			# revert
			SUBSCRIBE.camera_settings = camera_settings_snapshot
			SUBSCRIBE.current_location = current_location_snapshot
			
			await restore_player_hud()
			current_phase = PHASE.PLAYER
		# ------------------------

# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	SHOP STEPS
#region SHOP STATES
func on_current_shop_step_update() -> void:
	if !is_node_ready():return
	
	match current_shop_step:
		# ---------------
		SHOP_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
			await restore_player_hud()
			StoreContainer.end()
			on_store_closed.emit()		
			on_store_purchase_complete.emit(false)	
		# ---------------
		SHOP_STEPS.START_BASE:
			shop_revert_step = current_shop_step
			SUBSCRIBE.suppress_click = true
			selected_shop_item = {}
			
			StoreContainer.start('BASE')
			await show_only([StoreContainer, Structure3dContainer])
			var response:Dictionary = await StoreContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.PURCHASE.BACK:
					current_shop_step = SHOP_STEPS.RESET
					
				ACTION.PURCHASE.TIER_ITEM:
					selected_shop_item = response.selected
					current_shop_step = SHOP_STEPS.CONFIRM_TIER_PURCHASE
				
				ACTION.PURCHASE.BASE_ITEM:
					selected_shop_item = response.selected
					current_shop_step = SHOP_STEPS.CONFIRM_BASE_ITEM_PURCHASE
					
				ACTION.PURCHASE.FACILITY_ITEM:
					selected_shop_item = response.selected		
					current_shop_step = SHOP_STEPS.PLACEMENT
				
				ACTION.PURCHASE.RESEARCH_AND_DEVELOPMENT:
					selected_shop_item = response.selected
					current_shop_step = SHOP_STEPS.CONFIRM_RESEARCH_ITEM_PURCHASE
		# ---------------
		SHOP_STEPS.START_ROOM:
			shop_revert_step = current_shop_step
			SUBSCRIBE.suppress_click = true
			selected_shop_item = {}
			
			StoreContainer.start()
			await show_only([StoreContainer, Structure3dContainer])
			var response:Dictionary = await StoreContainer.user_response

			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.PURCHASE.BACK:					
					current_shop_step = SHOP_STEPS.RESET
					
				ACTION.PURCHASE.TIER_ITEM:
					selected_shop_item = response.selected
					current_shop_step = SHOP_STEPS.CONFIRM_TIER_PURCHASE
				
				ACTION.PURCHASE.BASE_ITEM:
					selected_shop_item = response.selected
					current_shop_step = SHOP_STEPS.CONFIRM_BASE_ITEM_PURCHASE
					
				ACTION.PURCHASE.FACILITY_ITEM:
					selected_shop_item = response.selected		
					current_shop_step = SHOP_STEPS.CONFIRM_BUILD
				
				ACTION.PURCHASE.RESEARCH_AND_DEVELOPMENT:
					selected_shop_item = response.selected
					current_shop_step = SHOP_STEPS.CONFIRM_RESEARCH_ITEM_PURCHASE					
					
		# ---------------
		SHOP_STEPS.CONFIRM_TIER_PURCHASE:
			ConfirmModal.set_props("Confirm TIER purchase?")
			await show_only([Structure3dContainer, ConfirmModal])			
			var confirm_response:Dictionary = await ConfirmModal.user_response			
			match confirm_response.action:
				ACTION.BACK:
					current_shop_step = shop_revert_step
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.FINALIZE_PURCHASE_TIER
			
		# ---------------
		SHOP_STEPS.CONFIRM_RESEARCH_ITEM_PURCHASE:
			ConfirmModal.set_props("Confirm research?")
			await show_only([Structure3dContainer, ConfirmModal])
			var confirm_response:Dictionary = await ConfirmModal.user_response
			match confirm_response.action:
				ACTION.BACK:
					current_shop_step = shop_revert_step
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.FINALIZE_PURCHASE_RESEARCH

		# ---------------
		SHOP_STEPS.CONFIRM_BASE_ITEM_PURCHASE:
			ConfirmModal.set_props("Confirm base item purchase?")
			await show_only([Structure3dContainer, ConfirmModal])
			var confirm_response:Dictionary = await ConfirmModal.user_response
			match confirm_response.action:
				ACTION.BACK:
					current_shop_step = shop_revert_step
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.FINALIZE_PURCHASE_BASE_ITEM
	
		# ---------------
		SHOP_STEPS.CONFIRM_BUILD:
			var room_details:Dictionary = ROOM_UTIL.return_data(selected_shop_item.ref)
			ConfirmModal.set_props("Purchase %s?" % [room_details.name], "Construction will take %s days." % [room_details.get_build_time.call()])
			await show_only([Structure3dContainer, ConfirmModal])			
			var confirm_response:Dictionary = await ConfirmModal.user_response			
			match confirm_response.action:
				ACTION.BACK:
					current_shop_step = shop_revert_step
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.FINALIZE_PURCHASE_BUILD
		# ---------------
		SHOP_STEPS.FINALIZE_PURCHASE_BUILD:
			var purchase_item_data:Dictionary = ROOM_UTIL.return_data(selected_shop_item.ref)
			add_timeline_item({
				"action": ACTION.AQ.BUILD_ITEM,
				"ref": selected_shop_item.ref,
				"title": purchase_item_data.name,
				"icon": SVGS.TYPE.BUILD,
				"completed_at": purchase_item_data.get_build_time.call() if "get_build_time" in purchase_item_data else 0,
				"description": "CONSTRUCTING",
				"location": current_location.duplicate()
			})
			
			SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(selected_shop_item.ref, resources_data)
			current_shop_step = SHOP_STEPS.RESET
			on_store_purchase_complete.emit(true)
		# ---------------
		SHOP_STEPS.FINALIZE_PURCHASE_RESEARCH:
			var purchase_item_data:Dictionary = RD_UTIL.return_data(selected_shop_item.ref)
			add_timeline_item({
				"action": ACTION.AQ.RESEARCH_ITEM,
				"ref": selected_shop_item.ref,
				"title": purchase_item_data.name,
				"icon": SVGS.TYPE.RESEARCH,
				"completed_at": purchase_item_data.get_build_time.call() if "get_build_time" in purchase_item_data else 0,
				"description": "RESEARCHING",
				"location": current_location.duplicate()
			})

			
			SUBSCRIBE.resources_data = RD_UTIL.calculate_purchase_cost(selected_shop_item.ref, resources_data)
			current_shop_step = shop_revert_step
			on_store_purchase_complete.emit(true)
		# ---------------
		SHOP_STEPS.FINALIZE_PURCHASE_BASE_ITEM:
			var purchase_item_data:Dictionary = BASE_UTIL.return_data(selected_shop_item.ref)
			add_timeline_item({
				"action": ACTION.AQ.BASE_ITEM,
				"ref": selected_shop_item.ref,
				"title": purchase_item_data.name,
				"icon": SVGS.TYPE.RESEARCH,
				"completed_at": purchase_item_data.get_build_time.call() if "get_build_time" in purchase_item_data else 0,
				"description": "UPGRADING",
				"location": current_location.duplicate()
			})
			
			SUBSCRIBE.resources_data = BASE_UTIL.calculate_purchase_cost(selected_shop_item.ref, resources_data)
			current_shop_step = shop_revert_step
			on_store_purchase_complete.emit(true)
		# ---------------
		SHOP_STEPS.FINALIZE_PURCHASE_TIER:
			# unlock the tier
			tier_unlocked[selected_shop_item.tier_type][selected_shop_item.tier_data.ref] = true
			
			# remove costs
			var resource_list:Dictionary = selected_shop_item.tier_data.get_unlock_cost.call()
			for key in resource_list:
				var amount:int = resource_list[key]
				resources_data[key].amount -= amount	
			
			# update subscribes
			SUBSCRIBE.resources_data = resources_data
			SUBSCRIBE.tier_unlocked = tier_unlocked
			current_shop_step = shop_revert_step
			on_store_purchase_complete.emit(true)
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	CONTAIN STEPS
#region CONTAIN STEPS
func on_current_contain_step_update() -> void:
	if !is_node_ready():return
	
	match current_contain_step:
		# ---------------
		CONTAIN_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
			await restore_player_hud()
			on_contain_reset.emit()
		# ---------------
		CONTAIN_STEPS.START:
			selected_contain_item = {} 
			selected_researcher_item = {} 
			SUBSCRIBE.suppress_click = true
			ContainmentContainer.assign_only = false
			await show_only([ ContainmentContainer, Structure3dContainer ])
			var response:Dictionary = await ContainmentContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			
			if "data" in response:
				selected_contain_item = response.data
				
			match response.action:
				# --------------------
				ACTION.CONTAINED.BACK:
					current_contain_step = CONTAIN_STEPS.RESET
				# --------------------
				ACTION.CONTAINED.START_CONTAINMENT:
					selected_contain_item.is_new_transfer = true
					current_contain_step = CONTAIN_STEPS.PLACEMENT
				# --------------------
				ACTION.CONTAINED.STOP_CONTAINMENT:
					selected_contain_item.is_new_transfer = true
					current_contain_step = CONTAIN_STEPS.ON_TRANSFER_CANCEL
				# --------------------
				ACTION.CONTAINED.REJECT_AND_REMOVE:
					current_contain_step = CONTAIN_STEPS.ON_REJECT
				# --------------------
				ACTION.CONTAINED.TRANSFER_TO_NEW_LOCATION:
					selected_contain_item.is_new_transfer = false
					current_contain_step = CONTAIN_STEPS.ON_TRANSFER_TO_NEW_LOCATION
				# --------------------
				ACTION.CONTAINED.CANCEL_TRANSFER:
					selected_contain_item.is_new_transfer = false
					current_contain_step = CONTAIN_STEPS.ON_TRANSFER_CANCEL
				# --------------------
				ACTION.CONTAINED.ASSIGN_RESEARCHER:
					pass
					#await assign_researcher_to_scp_find_researcher(selected_contain_item)
					#current_contain_step = CONTAIN_STEPS.START
				# --------------------
				ACTION.CONTAINED.UNASSIGN_RESEARCHER:
					await unassign_researcher_to_scp(selected_contain_item.ref)
					current_contain_step = CONTAIN_STEPS.START
				# --------------------
				ACTION.CONTAINED.START_TESTING:
					await start_scp_testing(selected_contain_item.ref)
					current_contain_step = CONTAIN_STEPS.START
				# --------------------
				ACTION.CONTAINED.STOP_TESTING:
					ConfirmModal.set_props("Cancel SCP testing?", "Unspent resources will be refunded.")
					await show_only([ConfirmModal, Structure3dContainer])
					var res:Dictionary = await ConfirmModal.user_response
					match res.action:
						ACTION.NEXT:					
							await stop_scp_testing(selected_contain_item.ref)
					current_contain_step = CONTAIN_STEPS.START
		# ---------------
		CONTAIN_STEPS.PLACEMENT:
			await show_only([Structure3dContainer])			
			SUBSCRIBE.unavailable_rooms = SCP_UTIL.return_unavailable_rooms(selected_contain_item.ref)
			
			Structure3dContainer.select_location(true)
			Structure3dContainer.placement_instructions = [] #ROOM_UTIL.return_placement_instructions(selected_shop_item.id)
			
			var structure_response:Dictionary = await Structure3dContainer.user_response
			Structure3dContainer.select_location(false)
			
			match structure_response.action:
				ACTION.BACK:					
					#SUBSCRIBE.camera_settings = camera_settings
					SUBSCRIBE.unavailable_rooms = []
					current_contain_step = CONTAIN_STEPS.START
				ACTION.NEXT:
					#SUBSCRIBE.camera_settings = camera_settings
					SUBSCRIBE.unavailable_rooms = []
					current_contain_step = CONTAIN_STEPS.CONFIRM_PLACEMENT
		# ---------------			
		CONTAIN_STEPS.ON_REJECT:
			ConfirmModal.set_props("Remove SCP from available list?")
			await show_only([ConfirmModal, Structure3dContainer])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.BACK:
					current_contain_step = CONTAIN_STEPS.START
				ACTION.NEXT:
					pass
					#var action_queue_item:Dictionary = action_queue_data.filter(func(i): return i.ref == selected_contain_item.ref)[0]
					#cancel_scp_containment(action_queue_item.ref)
					#scp_data.available_list = scp_data.available_list.filter(func(i):return i.ref != selected_contain_item.ref)
					#SUBSCRIBE.scp_data = scp_data
					#current_contain_step = CONTAIN_STEPS.START
		# ---------------
		CONTAIN_STEPS.ON_TRANSFER_CANCEL:
			var action_queue_item:Dictionary = {}
			pass
			#if selected_contain_item.is_new_transfer:
				#action_queue_item = action_queue_data.filter(func(i): return i.ref == selected_contain_item.ref and i.action == ACTION.AQ.CONTAIN)[0]
			#else:
				#action_queue_item = action_queue_data.filter(func(i): return i.ref == selected_contain_item.ref and i.action == ACTION.AQ.TRANSFER)[0]
			#await cancel_action_queue(action_queue_item, false)
			current_contain_step = CONTAIN_STEPS.START
		# ---------------
		CONTAIN_STEPS.ON_TRANSFER_TO_NEW_LOCATION:
			await show_only([Structure3dContainer])
			SUBSCRIBE.unavailable_rooms = SCP_UTIL.return_unavailable_rooms(selected_contain_item.ref)
			
			Structure3dContainer.select_location(true)
			Structure3dContainer.placement_instructions = [] #ROOM_UTIL.return_placement_instructions(selected_shop_item.id)
			
			var structure_response:Dictionary = await Structure3dContainer.user_response
			Structure3dContainer.placement_instructions = []
			
			#match structure_response.action:
				#ACTION.BACK:					
					#SUBSCRIBE.unavailable_rooms = []
					#current_contain_step = CONTAIN_STEPS.START
				#ACTION.NEXT:
					#SUBSCRIBE.unavailable_rooms = []
					#current_contain_step = CONTAIN_STEPS.CONFIRM_PLACEMENT
					
		# ---------------
		CONTAIN_STEPS.CONFIRM_PLACEMENT:
			ConfirmModal.set_props("Contain at this location?")
			await show_only([ConfirmModal, Structure3dContainer])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.BACK:
					current_contain_step = CONTAIN_STEPS.PLACEMENT
				ACTION.NEXT:
					current_contain_step = CONTAIN_STEPS.FINALIZE
		# ---------------
		CONTAIN_STEPS.FINALIZE:
			var scp_details:Dictionary = SCP_UTIL.return_data(selected_contain_item.ref)

			# is_new means it's coming from the availble_list 
			if selected_contain_item.is_new_transfer:
				scp_data.available_list = scp_data.available_list.map(func(i) -> Dictionary:
					if i.ref == selected_contain_item.ref:
						i.transfer_status = {
							"state": true, 
							"days_till_complete": scp_details.containment_time.call(),
							"location": current_location.duplicate(),
						}
					return i
				)
				
			else:
				scp_data.contained_list = scp_data.contained_list.map(func(i) -> Dictionary:
					if i.ref == selected_contain_item.ref:
						i.transfer_status = {
							"state": true, 
							"days_till_complete": scp_details.containment_time.call(),
							"location": current_location.duplicate(),
						}
					return i
				)				
			
			add_timeline_item({
				"action": ACTION.AQ.CONTAIN if selected_contain_item.is_new_transfer else ACTION.AQ.TRANSFER,
				"ref": selected_contain_item.ref,
				"title": selected_contain_item.name,
				"icon": SVGS.TYPE.CONTAIN,
				"completed_at": scp_details.containment_time.call(),
				"description": "CONTAINMENT IN PROGRESS" if selected_contain_item.is_new_transfer else "TRANSFER IN PROGRESS",
				"location": current_location.duplicate()
			})			
			
			#SUBSCRIBE.action_queue_data = action_queue_data
			SUBSCRIBE.scp_data = scp_data

			current_contain_step = CONTAIN_STEPS.START	
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	RECRUIT STEPS
#region RECRUIT STEPS
func on_current_recruit_step_update() -> void:
	if !is_node_ready():return

	match current_recruit_step:
		# ---------------
		RECRUIT_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
			await restore_player_hud()
			on_recruit_complete.emit()
		# ---------------
		RECRUIT_STEPS.START:
			SUBSCRIBE.suppress_click = true
			selected_lead_hire = {}
			selected_support_hire = {}
			await show_only([Structure3dContainer, RecruitmentContainer])
			var response:Dictionary = await RecruitmentContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.HIRE.BACK:
					current_recruit_step = RECRUIT_STEPS.RESET
				ACTION.HIRE.LEAD:
					selected_lead_hire = response.data
					current_recruit_step = RECRUIT_STEPS.CONFIRM_HIRE_LEAD
				ACTION.HIRE.SUPPORT:
					selected_support_hire = response.data
					current_recruit_step = RECRUIT_STEPS.CONFIRM_HIRE_SUPPORT
		# ---------------
		RECRUIT_STEPS.CONFIRM_HIRE_LEAD:
			ConfirmModal.set_props("Confirm hire?")
			await show_only([Structure3dContainer, ConfirmModal])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.BACK:
					current_recruit_step = RECRUIT_STEPS.START
				ACTION.NEXT:
					resources_data[RESOURCE.TYPE.MONEY].amount -= selected_lead_hire.cost
					hired_lead_researchers_arr.push_back(selected_lead_hire.researcher)
					SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
					# subtract hire costs and change status from of recruit data to empty
					current_recruit_step = RECRUIT_STEPS.START
		# ---------------
		RECRUIT_STEPS.CONFIRM_HIRE_SUPPORT:
			ConfirmModal.set_props("Confirm support?")
			await show_only([ConfirmModal])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.BACK:
					current_recruit_step = RECRUIT_STEPS.START
				ACTION.NEXT:
					resources_data[RESOURCE.TYPE.MONEY].amount -= selected_support_hire.cost
					resources_data[selected_support_hire.resource].amount += selected_support_hire.amount
					SUBSCRIBE.resources_data = resources_data
					current_recruit_step = RECRUIT_STEPS.START

#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	BUILD COMPLETE
#region CURRENT ACTION
func on_current_action_complete_step_update() -> void:
	if !is_node_ready():return

	match current_action_complete_step:
		# ---------------
		ACTION_COMPLETE_STEPS.RESET:
			pass
		# ---------------
		ACTION_COMPLETE_STEPS.START:
			SUBSCRIBE.suppress_click = true
			BuildCompleteContainer.completed_build_items = completed_actions

			for item in completed_actions:
				match item.action:
					# ----------------------------
					ACTION.AQ.BASE_ITEM:
						purchased_base_arr.push_back({
							"ref": item.ref,
						})
						SUBSCRIBE.purchased_base_arr = purchased_base_arr
					# ----------------------------	
					ACTION.AQ.BUILD_ITEM:
						purchased_facility_arr.push_back({
							"ref": item.ref,
							"location": item.location.duplicate()
						})
						SUBSCRIBE.purchased_facility_arr = purchased_facility_arr
					# ----------------------------
					ACTION.AQ.RESEARCH_ITEM:
						purchased_research_arr.push_back({
							"ref": item.ref,
						})
						SUBSCRIBE.purchased_research_arr = purchased_research_arr
			
			await show_only([BuildCompleteContainer, TimelineContainer])
			await BuildCompleteContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			await show_only([Structure3dContainer, ResourceContainer, TimelineContainer])
			
			# move back to current location
			current_location = revert_state_location
					
			# CHECK FOR EVENTS
			for item in completed_actions:
				await on_completed_action(item)
				
			# update reactively
			completed_actions = []
			on_complete_build_complete.emit()
			current_action_complete_step = ACTION_COMPLETE_STEPS.RESET
			
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
			await show_only([Structure3dContainer, EventContainer])
			EventContainer.event_data = event_data
			EventContainer.start()
			var event_res:Dictionary = await EventContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			# trigger signal
			on_events_complete.emit(event_res)			
			# reset and evempty event_data
			event_data = []
			current_event_step = EVENT_STEPS.RESET
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
#region SUMMARY STEPS
func on_current_summary_step_update() -> void:
	if !is_node_ready():return

	match current_summary_step:
		SUMMARY_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
			await restore_player_hud()
		SUMMARY_STEPS.START:
			SUBSCRIBE.suppress_click = true
			await show_only([EndOfPhaseContainer])
			EndOfPhaseContainer.start()
			await EndOfPhaseContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			current_summary_step = SUMMARY_STEPS.RESET
			await U.set_timeout(0.5)
			# trigger signal
			on_summary_complete.emit()
			
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
			await show_only([SCPSelectScreen])
			SCPSelectScreen.start([0, 1])
			await SCPSelectScreen.user_response
			SCPSelectScreen.is_showing = false
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			
			# trigger signal
			on_scp_select_complete.emit()
			current_select_scp_step = SELECT_SCP_STEPS.RESET

#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------		
#region RESEARCHER STEPS
func on_current_researcher_promotion_step_update() -> void:
	if !is_node_ready():return
	
	match current_researcher_promotion_step:
		# ------------------------
		PROMOTE_RESEARCHER_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
			await restore_player_hud()
			on_promote_researcher_complete.emit()
		# ------------------------
		PROMOTE_RESEARCHER_STEPS.START:
			SUBSCRIBE.suppress_click = true
			var ResearcherPromotionNode:Control = ResearcherPromotionScreenPreload.instantiate()
			add_child(ResearcherPromotionNode)
			await show_only([])
			ResearcherPromotionNode.start()
			await ResearcherPromotionNode.user_response
			ResearcherPromotionNode.queue_free()
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			current_select_scp_step = SELECT_SCP_STEPS.RESET


func on_current_researcher_step_update() -> void:
	if !is_node_ready():return
	
	match current_researcher_step:
		# ------------------------
		RESEARCHERS_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
			await restore_player_hud()
			
		# ------------------------
		RESEARCHERS_STEPS.DETAILS_ONLY:
			SUBSCRIBE.suppress_click = true
			ResearchersContainer.start([], true)
			await show_only([ResearchersContainer])
			var response:Dictionary = await ResearchersContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			
			on_researcher_component_complete.emit()
			
			match response.action:
				ACTION.RESEARCHERS.BACK:
					current_researcher_step = RESEARCHERS_STEPS.RESET
		# ------------------------
		RESEARCHERS_STEPS.ASSIGN:
			SUBSCRIBE.suppress_click = true
			ResearchersContainer.details_only = false
			
			var assigned_uids:Array =  hired_lead_researchers_arr.filter(func(i):				
				return U.dictionaries_equal(i[9].assigned_to_room, current_location)
			).map(func(i): return i[0])
			
			ResearchersContainer.start(assigned_uids, false)
			await show_only([ResearchersContainer])
			var response:Dictionary = await ResearchersContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)

			on_researcher_component_complete.emit(response)
			
			match response.action:
				ACTION.RESEARCHERS.BACK:
					current_researcher_step = RESEARCHERS_STEPS.RESET
		# ------------------------
		
		#RESEARCHERS_STEPS.DISMISS:
			#ConfirmModal.set_props("Dismiss DR %s?" % [selected_researcher_item.details.name], "Researcher will be removed permanently.")
			#await show_only([Structure3dContainer, ConfirmModal])			
			#var confirm_response:Dictionary = await ConfirmModal.user_response
			#match confirm_response.action:
				#ACTION.BACK:
					#current_researcher_step = RESEARCHERS_STEPS.START
				#ACTION.NEXT:
					#current_researcher_step = RESEARCHERS_STEPS.FINALIZE_DISMISS
		## ------------------------
		#RESEARCHERS_STEPS.FINALIZE_DISMISS:
			#var props:Dictionary = {
				#"name": selected_researcher_item.details.name,
				#"onSelection": func(val:EVT.DISMISS_TYPE) -> void:
					#match val:
						#EVT.DISMISS_TYPE.THANK_AND_DISMISS:
							#print('no change, costs money as severence based')
						#EVT.DISMISS_TYPE.ADMINISTER_AMNESTICS:
							#print('no change')
						#EVT.DISMISS_TYPE.TERMINATE:
							#print('dec morale')
			#}
			#await triggger_event(EVT.TYPE.DISMISS_RESEARCHER, props)
			#dismiss_researcher(selected_researcher_item)
			#current_researcher_step = RESEARCHERS_STEPS.START
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	CONTROLS
#region CONTROL UPDATE
func is_occupied() -> bool:
	if is_busy or processing_next_day:
		return true
	if current_phase != PHASE.PLAYER:
		return true
	if (current_shop_step != SHOP_STEPS.RESET) or (current_contain_step != CONTAIN_STEPS.RESET) or (current_recruit_step != RECRUIT_STEPS.RESET) or (current_action_complete_step != ACTION_COMPLETE_STEPS.RESET) or (current_event_step != EVENT_STEPS.RESET):
		return true
	return false


#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	SAVE/LOAD
#region SAVE/LOAD
func quicksave() -> void:
	is_busy = true
	var save_data = {
		# NOTE: ROOM CONFIG IS NEVER SAVED: IT IS READ-ONLY AS IT IS CREATED AS BY-PRODUCT
		# OF ALL THE OTHER DATA THAT'S HERE
		"progress_data": progress_data,		
		"scp_data": scp_data,
		#"action_queue_data": action_queue_data,
		"timeline_array": timeline_array,
		"purchased_base_arr": purchased_base_arr,
		"purchased_facility_arr": purchased_facility_arr,
		"purchased_research_arr": purchased_research_arr,
		"hired_lead_researchers_arr": hired_lead_researchers_arr,
		"resources_data": resources_data,
		"bookmarked_rooms": bookmarked_rooms,
		"researcher_hire_list": researcher_hire_list,
		"tier_unlocked": tier_unlocked,
		"base_states": base_states,
		"unavailable_rooms": unavailable_rooms, 
	}	
	var res = FS.save_file(FS.FILE.QUICK_SAVE, save_data)
	await U.set_timeout(1.0)
	is_busy = false
	print("saved game!")

func quickload() -> void:
	is_busy = true
	var res = FS.load_file(FS.FILE.QUICK_SAVE)
	if res.success:
		await parse_restore_data(res.filedata.data)
		print("quickload success!")
	else:
		print("quickload failed :(")
	is_busy = false

		
func parse_restore_data(restore_data:Dictionary = {}) -> void:
	var no_save:bool = restore_data.is_empty()
	if debug_mode:
		no_save = true
		
	# non-reactive data that's used but doesn't require a subscription
	SUBSCRIBE.progress_data = initial_values.progress_data.call() if no_save else restore_data.progress_data
	SUBSCRIBE.scp_data = initial_values.scp_data.call() if no_save else restore_data.scp_data
	SUBSCRIBE.timeline_array = initial_values.timeline_array.call() if no_save else restore_data.timeline_array
	#SUBSCRIBE.action_queue_data = initial_values.action_queue_data.call() if no_save else restore_data.action_queue_data	
	SUBSCRIBE.purchased_facility_arr = initial_values.purchased_facility_arr.call() if no_save else restore_data.purchased_facility_arr  
	SUBSCRIBE.purchased_base_arr = initial_values.purchased_base_arr.call() if no_save else restore_data.purchased_base_arr
	SUBSCRIBE.resources_data = initial_values.resources_data.call() if no_save else restore_data.resources_data	
	SUBSCRIBE.bookmarked_rooms = initial_values.bookmarked_rooms.call() if no_save else restore_data.bookmarked_rooms
	SUBSCRIBE.researcher_hire_list = initial_values.researcher_hire_list.call() if no_save else restore_data.researcher_hire_list
	SUBSCRIBE.purchased_research_arr = initial_values.purchased_research_arr.call() if no_save else restore_data.purchased_research_arr
	SUBSCRIBE.tier_unlocked = initial_values.tier_unlocked.call() if no_save else restore_data.tier_unlocked
	SUBSCRIBE.unavailable_rooms = initial_values.unavailable_rooms.call() if no_save else restore_data.unavailable_rooms
	SUBSCRIBE.base_states = initial_values.base_states.call() if no_save else restore_data.base_states
	
	# comes after purchased_research_arr, fix this later
	SUBSCRIBE.hired_lead_researchers_arr = initial_values.hired_lead_researchers_arr.call() if no_save else restore_data.hired_lead_researchers_arr
	
	# don't need to be saved, just load from defaults
	SUBSCRIBE.current_location = initial_values.current_location.call() 
	SUBSCRIBE.camera_settings = initial_values.camera_settings.call() 

#endregion		
# ------------------------------------------------------------------------------
