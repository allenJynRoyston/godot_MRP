extends PanelContainer

enum SHOP_STEPS {
	HIDE, 
	START_BASE, 
	START_ROOM,
	PLACEMENT,
	CONFIRM_RESEARCH_ITEM_PURCHASE, CONFIRM_BUILD, CONFIRM_TIER_PURCHASE, CONFIRM_BASE_ITEM_PURCHASE,
	FINALIZE_PURCHASE_BUILD, FINALIZE_PURCHASE_RESEARCH, FINALIZE_PURCHASE_TIER, FINALIZE_PURCHASE_BASE_ITEM,
	REFUND
}
enum CONTAIN_STEPS {
	HIDE, START, SHOW, PLACEMENT, CONFIRM_PLACEMENT, 
	ON_REJECT, ON_TRANSFER_CANCEL, 
	ON_TRANSFER_TO_NEW_LOCATION, 
	CONFIRM, FINALIZE
}
enum RECRUIT_STEPS {HIDE, START, SHOW, CONFIRM_HIRE_LEAD, CONFIRM_HIRE_SUPPORT, FINALIZE}
enum ACTION_COMPLETE_STEPS {HIDE, START, FINALIZE}

enum SUMMARY_STEPS {RESET, START, DISMISS}

enum RESEARCHERS_STEPS {RESET, START, DISMISS, FINALIZE_DISMISS, WAIT_FOR_SELECT}
enum EVENT_STEPS {RESET, START}

@onready var Structure3dContainer:Control = $Structure3DContainer
@onready var LocationContainer:MarginContainer = $LocationContainer
@onready var ActionQueueContainer:MarginContainer = $ActionQueueContainer
@onready var RoomStatusContainer:MarginContainer = $RoomStatusContainer
@onready var ActionContainer:MarginContainer = $ActionContainer
@onready var ResourceContainer:MarginContainer = $ResourceContainer
@onready var DialogueContainer:MarginContainer = $DialogueContainer
@onready var StoreContainer:MarginContainer = $StoreContainer
@onready var ContainmentContainer:MarginContainer = $ContainmentContainer
@onready var RecruitmentContainer:MarginContainer = $RecruitmentContainer
@onready var StatusContainer:MarginContainer = $StatusContainer
@onready var BuildCompleteContainer:MarginContainer = $BuildCompleteContainer
@onready var InfoContainer:MarginContainer = $InfoContainer
@onready var ResearchersContainer:MarginContainer = $ResearcherContainer
@onready var EventContainer:MarginContainer = $EventContainer
@onready var MetricsContainer:MarginContainer = $MetricsContainer
@onready var BackContainer:MarginContainer = $BackContainer
@onready var EndOfPhaseContainer:MarginContainer = $EndofPhaseContainer

@onready var ConfirmModal:MarginContainer = $ConfirmModal
@onready var WaitContainer:PanelContainer = $WaitContainer

@onready var TestPoint:PanelContainer = $Control/TestPoint

# ------------------------------------------------------------------------------	EXPORT VARS
#region EXPORT VARS
@export var debug_mode:bool = false 

@export var show_structures:bool = true: 
	set(val):
		show_structures = val
		on_show_structures_update()
		
@export var show_location:bool = true : 
	set(val):
		show_location = val
		on_show_location_update()

@export var show_action_queue:bool = true : 
	set(val):
		show_action_queue = val
		on_show_action_queue_update()
		
@export var room_item_status:bool = true : 
	set(val):
		room_item_status = val
		on_room_item_status_update()

@export var show_actions:bool = true : 
	set(val):
		show_actions = val
		on_show_actions_update()

@export var show_resources:bool = true : 
	set(val):
		show_resources = val
		on_show_resources_update()

@export var show_dialogue:bool = true : 
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
		
@export var show_status:bool = false : 
	set(val):
		show_status = val
		on_show_status_update()
		
@export var show_info:bool = false : 
	set(val):
		show_info = val
		on_show_info_update()		

@export var show_events:bool = false : 
	set(val):
		show_events = val
		on_show_events_update()		

@export var show_build_complete:bool = false : 
	set(val):
		show_build_complete = val
		on_show_build_complete_update()
		
@export var show_metrics:bool = false : 
	set(val):
		show_metrics = val
		on_show_metrics_update()
		
@export var show_back:bool = false : 
	set(val):
		show_back = val
		on_show_back_update()
		
@export var show_end_of_phase:bool = false : 
	set(val):
		show_end_of_phase = val
		on_show_end_of_phase_update()
		
#endregion
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------ 
#region SAVABLE DATA
var camera_settings:Dictionary = {
	"type": CAMERA.TYPE.FLOOR_SELECT,
	"is_locked": false
}

var current_location:Dictionary = {
	"floor": 0,
	"ring": 0,
	"room": 4 # 4 is the center
} 
var progress_data:Dictionary = { 
	"day": 1,
	"days_till_new_hires": 7,
} 

var scp_data:Dictionary = {
	"available_list": [
		{
			"ref": SCP.TYPE.SCP_001, 
			"days_until_expire": 99, 
			"is_new": true,
			"transfer_status": {
				"state": false, 
				"days_till_complete": -1,
				"location": {}
			}
		},
		{
			"ref": SCP.TYPE.SCP_002, 
			"days_until_expire": 99, 
			"is_new": true,
			"transfer_status": {
				"state": false, 
				"days_till_complete": -1,
				"location": {}
			}
		}		
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
}

var shop_revert_step:SHOP_STEPS

var action_queue_data:Array = []

var purchased_facility_arr:Array = [] 

var purchased_base_arr:Array = []

var purchased_research_arr:Array = []

var bookmarked_rooms:Array = [] # ["000", "201"] <- "floor_index, ring_index, room_index"]

var unavailable_rooms:Array = []

var researcher_hire_list:Array = RESEARCHER_UTIL.generate_new_researcher_hires() 

var hired_lead_researchers_arr:Array = [] 

var resources_data:Dictionary = { 
	RESOURCE.TYPE.MONEY: {
		"amount": 500, 
		"utilized": 0, 
		"capacity": 9999
	},
	RESOURCE.TYPE.ENERGY: {
		"amount": 10, 
		"utilized": 0, 
		"capacity": 50
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
}

var tier_unlocked:Dictionary = {
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
}

var room_config:Dictionary = {
	"floor": {
		0: get_floor_default(true, 3),
		1: get_floor_default(true, 3),
		2: get_floor_default(false, 3),
		3: get_floor_default(false, 3),
		4: get_floor_default(false, 3),
		5: get_floor_default(false, 3),
		6: get_floor_default(false, 3),
	}
} 

var initial_values:Dictionary = {
	"current_location": current_location,
	"scp_data": scp_data,
	"progress_data": progress_data,
	"action_queue_data": action_queue_data,
	"purchased_facility_arr": purchased_facility_arr,
	"purchased_base_arr": purchased_base_arr,
	"purchased_research_arr": purchased_research_arr,
	"bookmarked_rooms": bookmarked_rooms,
	"unavailable_rooms": unavailable_rooms,
	"researcher_hire_list": researcher_hire_list,
	"hired_lead_researchers_arr": hired_lead_researchers_arr,
	"resources_data": resources_data,
	"tier_unlocked": tier_unlocked,
	"room_config": room_config,
	"camera_settings": camera_settings
}.duplicate(true)


#endregion
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------	LOCAL DATA
#region LOCAL DATA
var is_busy:bool = false : 
	set(val):
		is_busy = val
		on_is_busy_update()
		
var processing_next_day:bool = false

var selected_support_hire:Dictionary = {}
var selected_lead_hire:Dictionary = {}
var selected_shop_item:Dictionary = {}
var selected_refund_item:Dictionary = {}
var selected_contain_item:Dictionary = {} 
var selected_researcher_item:Dictionary = {}
var selected_scp_details:Dictionary = {} 
var expired_scp_items:Array = [] 

var showing_states:Dictionary = {} 
var revert_state_location:Dictionary = {}
var tenative_location:Dictionary = {}

var completed_actions:Array = [] : 
	set(val):
		completed_actions = val
		if !completed_actions.is_empty():
			current_action_complete_step = ACTION_COMPLETE_STEPS.START
			
var event_data:Array = [] : 
	set(val):
		event_data = val
		if !event_data.is_empty():
			current_event_step = EVENT_STEPS.START

var current_shop_step:SHOP_STEPS = SHOP_STEPS.HIDE : 
	set(val):
		current_shop_step = val
		on_current_shop_step_update()

var current_contain_step:CONTAIN_STEPS = CONTAIN_STEPS.HIDE : 
	set(val):
		current_contain_step = val
		on_current_contain_step_update()
		
var current_recruit_step:RECRUIT_STEPS = RECRUIT_STEPS.HIDE : 
	set(val):
		current_recruit_step = val
		on_current_recruit_step_update()
		
var current_action_complete_step:ACTION_COMPLETE_STEPS = ACTION_COMPLETE_STEPS.HIDE : 
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

signal store_select_location
signal on_complete_build_complete
signal on_expired_scp_items_complete
signal on_events_complete
signal on_summary_complete
signal on_store_closed
signal on_confirm_complete
signal on_cancel_construction_complete
signal on_reset_room_complete
signal on_activate_room_complete

#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	LIFECYCLE
#region LIFECYCLE
func _init() -> void:
	GBL.register_node(REFS.GAMEPLAY_LOOP, self)
	GBL.subscribe_to_mouse_input(self)
	GBL.subscribe_to_control_input(self)

	SUBSCRIBE.subscribe_to_progress_data(self)
	SUBSCRIBE.subscribe_to_action_queue_data(self)
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
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.GAMEPLAY_LOOP)
	GBL.unsubscribe_to_mouse_input(self)
	GBL.unsubscribe_to_control_input(self)
	
	SUBSCRIBE.unsubscribe_to_progress_data(self)
	SUBSCRIBE.unsubscribe_to_action_queue_data(self)
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
	  
func _ready() -> void:
	if !Engine.is_editor_hint():
		hide()
		set_process(false)
		set_physics_process(false)	
	setup()	
	
	

func setup() -> void:
	# first these
	on_show_structures_update()
	on_show_actions_update()
	on_show_resources_update()
	on_show_location_update()
	on_show_action_queue_update()
	on_room_item_status_update()
	on_show_dialogue_update()
	on_show_containment_status_update()
	on_show_recruit_update()
	on_show_status_update()
	on_show_info_update()
	on_show_events_update()
	on_show_build_complete_update()
	on_show_reseachers_update()
	on_show_store_update()
	on_show_metrics_update()
	on_show_back_update()
	on_show_end_of_phase_update()
	
	# other
	on_show_confirm_modal_update()
	on_is_busy_update()
	
	# steps
	#
	#on_current_shop_step_update()
	
	# get default showing state
	capture_default_showing_state()
		
	LocationContainer.onRoomSelected = func(data:Dictionary) -> void:
		SUBSCRIBE.current_location = data

		
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	START GAME
#region START GAME
func start(game_data:Dictionary = {}) -> void:
	show()
	set_process(true)
	set_physics_process(true)	
	_on_container_rect_changed()
	
	# initially all animation speed is set to 0 but after this is all ready, set animation speed
	for node in get_all_container_nodes():
		node.animation_speed = 0.3

	if game_data.is_empty():
		start_new_game()
	else:
		start_load_game()

func start_new_game() -> void:
	quickload()

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
		"in_lockdown": false,
		"array_size": array_size,
		"readings": {
			RESOURCE.BASE.MORALE: 5,
			RESOURCE.BASE.SAFETY: 5,
			RESOURCE.BASE.READINESS: 5,
			RESOURCE.BASE.HUME: 5,
		},
		"ring": { 
			0: get_room_default(array_size),
			1: get_room_default(array_size),
			2: get_room_default(array_size),
			3: get_room_default(array_size)
		}
	}

func get_room_default(array_size:int) -> Dictionary:
	var room:Dictionary
	for n in range(array_size*array_size):
		room[n] = get_room_item_default()
	return {
		"room": room
	}

func get_room_item_default() -> Dictionary:
	return {
		"build_data": {},
		"room_data": {},
		"scp_data": {}
	}
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	SHOW/HIDE CONTAINERS
#region show/hide functions
func on_is_busy_update() -> void:
	WaitContainer.show() if is_busy else WaitContainer.hide()

func get_all_container_nodes(exclude:Array = []) -> Array:
	return [
		Structure3dContainer, LocationContainer, ActionQueueContainer, ResearchersContainer,
		RoomStatusContainer, ActionContainer, ResourceContainer, 
		DialogueContainer, StoreContainer, ContainmentContainer, 
		ConfirmModal, RecruitmentContainer, StatusContainer,
		BuildCompleteContainer, InfoContainer, EventContainer,
		MetricsContainer, BackContainer, EndOfPhaseContainer
	].filter(func(node): return node not in exclude)
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func capture_default_showing_state() -> void:
	for node in get_all_container_nodes():
		showing_states[node] = node.is_showing
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func restore_default_state() -> void:
	for node in get_all_container_nodes():
		if showing_states[node] != node.is_showing:
			node.is_showing = showing_states[node]
	await U.set_timeout(0.3)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func show_only(nodes:Array = []) -> void:
	var show_filter:Array = get_all_container_nodes().filter(func(node): return node in nodes)
	var hide_filter:Array = get_all_container_nodes().filter(func(node): return node not in nodes)
	
	for node in hide_filter:
		if node.is_showing != false:
			node.is_showing = false
	await U.set_timeout(0.3)
	
	for node in show_filter:
		if node.is_showing != true:
			node.is_showing = true
			
	await U.set_timeout(0.3)
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
			# -------------------------
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
			# return current researcher attached to scp
			"research_details": func() -> Dictionary:
				var res:Dictionary = find_in_contained(scp_ref)
				var list_data:Dictionary = res.data
				if list_data.lead_researcher.is_empty():
					return {}		
				return RESEARCHER_UTIL.return_data_with_uid(list_data.lead_researcher.uid, hired_lead_researchers_arr),
			# -------------------------	
			"progress_data": func() -> Dictionary:
				return progress_data.duplicate(true),
			# get a count of the current resources available
			"resources_data": func() -> Dictionary:
				return resources_data.duplicate(true),
			# -------------------------	
			# preform an action (like cancel transfer, stop reserach, etc)
			"perform_action": func(action:int) -> void:
				match action:
					ACTION.CONTAINED.CANCEL_TRANSFER:
						var filtered_arr:Array = action_queue_data.filter(func(i): return i.ref == scp_ref and i.action == ACTION.AQ.TRANSFER)
						cancel_scp_transfer(scp_ref)
						remove_from_action_queue(filtered_arr[0])
				pass,
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
func set_room_config() -> void:
	var new_room_config:Dictionary = initial_values.room_config.duplicate(true)
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
					"is_transfer": true,
				}
				
	# ... and mark rooms that are currently contained 
	if "contained_list" in scp_data:
		for item in scp_data.contained_list:
			# ... or in a state of being transfered to another room
			if item.transfer_status.state:
				var floor:int = item.transfer_status.location.floor
				var ring:int = item.transfer_status.location.ring
				var room:int = item.transfer_status.location.room	
				new_room_config.floor[floor].ring[ring].room[room].scp_data = {
					"ref": item.ref,
					"is_transfer": true,
				}			
			var floor:int = item.location.floor
			var ring:int = item.location.ring
			var room:int = item.location.room	
			new_room_config.floor[floor].ring[ring].room[room].scp_data = {
				"ref": item.ref,
				"is_transfer": item.transfer_status.state,
			}				
	
	
	# mark rooms that are under construction...
	for item in action_queue_data:
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
		var room_data:Dictionary = ROOM_UTIL.return_data(item.ref)
		new_room_config.floor[floor].ring[ring].room[room].room_data = {
			"ref": item.ref,
			# if activation cost not in room, then it's activated
			"is_activated": !("activation_cost" in room_data),  
		}
		# if facility is built, clear build_data
		new_room_config.floor[floor].ring[ring].room[room].build_data = {}

	# mark rooms and push to subscriptions
	for floor_index in new_room_config.floor.size():
		new_room_config.floor[floor_index].in_lockdown = room_config.floor[floor_index].in_lockdown
		#new_room_config.floor[floor_index].in_lockdown = room_config.floor[current_location.floor].in_lockdown
		#print(floor_index, new_room_config.floor[floor_index].in_lockdown)
		for ring_index in new_room_config.floor[floor_index].ring.size():
			for room_index in new_room_config.floor[floor_index].ring[ring_index].room.size():
				var designation:String = "%s%s%s" % [floor_index, ring_index, room_index]
				var config_data:Dictionary = new_room_config.floor[floor_index].ring[ring_index].room[room_index]
				if !config_data.build_data.is_empty():
					under_construction_rooms.push_back(designation)
				if !config_data.room_data.is_empty():
					built_rooms.push_back(designation)
			
	# mark rooms that are already powered...
	new_room_config.floor[1].is_powered = BASE_UTIL.get_count(BASE.TYPE.UNLOCK_FLOOR_2, purchased_base_arr) > 0
	new_room_config.floor[2].is_powered = BASE_UTIL.get_count(BASE.TYPE.UNLOCK_FLOOR_3, purchased_base_arr) > 0
	
	SUBSCRIBE.room_config = new_room_config	
	SUBSCRIBE.under_construction_rooms = under_construction_rooms
	SUBSCRIBE.built_rooms = built_rooms
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
func check_testing_events(ref:int, testing_ref:SCP.TESTING) -> Dictionary:
	var res:Dictionary = find_in_contained(ref)
	var index:int = res.index
	var list_data:Dictionary = res.data
	var event:Dictionary = SCP_UTIL.check_for_testing_events(ref, testing_ref, get_data_snapshot, get_self_ref_callable(ref))
	var event_arr:Array = []
	if !event.event_instructions.is_empty():
		event_data = [event]
		return await on_events_complete
		
	return {}
# -----------------------------------

# -----------------------------------
func next_day() -> void:		
	# turn processing next day flag to true
	processing_next_day = true
	
	# show busy modal
	await wait_please(1.0)	
	
	#current_summary_step = SUMMARY_STEPS.START
	#await on_summary_complete
	
	# ADD TO PROGRESS DATA day count
	progress_data.day += 1
	SUBSCRIBE.progress_data = progress_data
	
	# UPDATES ALL THINGS LEFT IN QUEUE THAT REQUIRES MORE TIME
	action_queue_data = action_queue_data.map(func(i): 
		i.count.day += 1
		return i
	)
	SUBSCRIBE.action_queue_data = action_queue_data	
	
	# ADDS DAY COUNT TO SCP DATA
	scp_data.available_list = scp_data.available_list.map(func(i): i.days_until_expire = i.days_until_expire - 1; return i)
	scp_data.contained_list = scp_data.contained_list.map(func(i): i.days_in_containment = i.days_in_containment + 1; return i)
	
	# ...and remove if expired, add to expire list
	expired_scp_items = scp_data.available_list.filter(func(i): return i.days_until_expire == 0 and !i.transfer_status.state)
	scp_data.available_list = scp_data.available_list.filter(func(i): return i.days_until_expire > 0 or i.transfer_status.state)
	
	# ADDS TO COMPLETED BUILD ITEMS LIST IF THEY'RE DONE
	completed_actions = action_queue_data.filter(func(i): return i.count.day >=i.count.completed_at)	
	if completed_actions.size() > 0:
		await on_complete_build_complete
	
	
	# make notification that SCP has expired
	if expired_scp_items.size() > 0:
		pass	
	
	# CHECK FOR RANDOMIZED EVENTS
	#var event_data_arr = []
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
				
				
	processing_next_day = false
# -----------------------------------
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
#region GAMEPLAY FUNCS
func set_floor_lockdown(state:bool) -> void:
	var title:String = ("Initiate lockdown for floor %s?" if state else "Remove lockdown for floor %s?") % [current_location.floor] 
	
	ConfirmModal.set_text(title, "All actions will be frozen." if state else "All actions will resume.")
	await show_only([ConfirmModal, Structure3dContainer])	
	var response:Dictionary = await ConfirmModal.user_response

	match response.action:
		ACTION.NEXT:
			room_config.floor[current_location.floor].in_lockdown = state
			SUBSCRIBE.room_config = room_config
		ACTION.BACK:
			pass

	on_confirm_complete.emit()
	await restore_default_state()
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
#region GAMEPLAY FUNCS
# ---------------------
func activate_room(from_location:Dictionary, is_activated:bool) -> void:
	var floor_index:int = from_location.floor
	var ring_index:int = from_location.ring
	var room_index:int = from_location.room
	
	ConfirmModal.set_text("Activate this room?" if is_activated else "Deactivate this room")
	
	# will cost X amount first
	await show_only([ConfirmModal])	
	var response:Dictionary = await ConfirmModal.user_response
	
	match response.action:		
		ACTION.NEXT:
			print("ACTIVATE ROOM")
			room_config.floor[from_location.floor].ring[from_location.ring].room[from_location.room].room_data.is_activated = is_activated
			room_config = room_config
			
	await restore_default_state()
	on_activate_room_complete.emit()
# ---------------------

# ---------------------
func reset_room(from_location:Dictionary) -> void:
	var floor_index:int = from_location.floor
	var ring_index:int = from_location.ring
	var room_index:int = from_location.room
	var reset_arr:Array = purchased_facility_arr.filter(func(i): return (i.location.floor == floor_index and i.location.ring == ring_index and i.location.room == room_index))
	
	if reset_arr.size() > 0:
		ConfirmModal.set_text("This room will be reset back to empty.", "Half your resources will be refunded.")
			
		await show_only([ConfirmModal])	
		var response:Dictionary = await ConfirmModal.user_response
		match response.action:		
			ACTION.NEXT:
				var reset_item:Dictionary = reset_arr[0]
				SUBSCRIBE.purchased_facility_arr = purchased_facility_arr.filter(func(i): return !(i.location.floor == floor_index and i.location.ring == ring_index and i.location.room == room_index))
				SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(reset_item.ref, resources_data, true)
	
	print( room_config.floor[current_location.floor].in_lockdown )
	
	await restore_default_state()
	on_reset_room_complete.emit()
# ---------------------

# ---------------------
func cancel_construction(from_location:Dictionary) -> void:
	var floor_index:int = from_location.floor
	var ring_index:int = from_location.ring
	var room_index:int = from_location.room
	
	var filtered_arr:Array = action_queue_data.filter(func(i): return (i.location.floor == floor_index and i.location.ring == ring_index and i.location.room == room_index)and i.action == ACTION.AQ.BUILD_ITEM)
	await cancel_action_queue(filtered_arr[0])

	on_cancel_construction_complete.emit()
# ---------------------	
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
#region SCP ACTION QUEUE (assign/unassign/dismiss, etc)
func on_completed_action(action_item:Dictionary) -> void:
	match action_item.action:
		# RUNS AFTER TESTING ACCESSMENT IS COMPLETED
		ACTION.AQ.ACCESSING:
			var scp_ref:int = action_item.ref 
			var event_res:Dictionary = await check_events(scp_ref, SCP.EVENT_TYPE.START_TESTING, true)
			var testing_ref:int = event_res.val			
			update_scp_testing(action_item.ref, testing_ref)
		# ----------------------------
		# RUNS AFTER A TESTING EVENT HAS COMPLETED
		ACTION.AQ.TESTING:  
			var scp_ref:int = action_item.ref 
			var testing_ref:int = action_item.props.testing_ref
			var utilized_amounts:Dictionary = action_item.props.utilized_amounts
			var res:Dictionary = find_in_contained(scp_ref)
			var index:int = res.index
			
			# refunds utilized amounts
			SUBSCRIBE.resources_data = SCP_UTIL.calculate_refunded_utilizied(utilized_amounts, resources_data)
			
			# trigger post research event
			await check_testing_events(scp_ref, testing_ref)
			
			# update reesearch completed
			if action_item.ref not in scp_data.contained_list[index].research_completed:
				scp_data.contained_list[index].research_completed.push_back(testing_ref)
			SUBSCRIBE.scp_data = scp_data
			
			# continue testing
			var event_res:Dictionary = await check_events(scp_ref, SCP.EVENT_TYPE.START_TESTING, true)
			var new_testing_ref:int = event_res.val
			update_scp_testing(scp_ref, new_testing_ref)			
		# ----------------------------
		ACTION.AQ.CONTAIN:
			# first, remove from available list...
			scp_data.available_list = scp_data.available_list.filter(func(i):return i.ref != action_item.ref)
			# then add to contained list...
			var new_contained_item:Dictionary = create_new_contained_item(action_item.ref, action_item.location)
			scp_data.contained_list.push_back(new_contained_item)

			SUBSCRIBE.resources_data = SCP_UTIL.calculate_initial_containment_bonus(action_item.ref, resources_data)
			SUBSCRIBE.scp_data = scp_data

			await check_events(action_item.ref, SCP.EVENT_TYPE.AFTER_CONTAINMENT)
		# ----------------------------
		ACTION.AQ.TRANSFER:
			scp_data.contained_list = scp_data.contained_list.map(func(i):
				if i.ref == action_item.ref:
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
			
			await check_events(action_item.ref, SCP.EVENT_TYPE.AFTER_TRANSFER)
		# ----------------------------
		ACTION.AQ.BASE_ITEM:
			purchased_base_arr.push_back({
				"ref": action_item.ref,
			})
			SUBSCRIBE.resources_data = BASE_UTIL.calculate_build_complete(action_item.ref, resources_data)
			SUBSCRIBE.purchased_base_arr = purchased_base_arr
		# ----------------------------	
		ACTION.AQ.BUILD_ITEM:
			purchased_facility_arr.push_back({
				"ref": action_item.ref,
				"location": action_item.location.duplicate()
			})

			SUBSCRIBE.resources_data = ROOM_UTIL.calculate_build_complete(action_item.ref, resources_data)
			SUBSCRIBE.purchased_facility_arr = purchased_facility_arr
		# ----------------------------
		ACTION.AQ.RESEARCH_ITEM:
			purchased_research_arr.push_back({
				"ref": action_item.ref,
			})
			SUBSCRIBE.purchased_research_arr = purchased_research_arr
			
	remove_from_action_queue(action_item)
# -----------------------------------

# -----------------------------------
func cancel_action_queue(action_item:Dictionary, include_restore:bool = true) -> void:
	match action_item.action:
		ACTION.AQ.CONTAIN:
			ConfirmModal.set_text("Cancel containment?", "There are no costs for this action.")
		ACTION.AQ.TRANSFER:
			ConfirmModal.set_text("Cancel transfer?", "There are no costs for this action.")					
		ACTION.AQ.BUILD_ITEM:
			ConfirmModal.set_text("Cancel construction?", "Resources will be refunded.")
		ACTION.AQ.RESEARCH_ITEM:
			ConfirmModal.set_text("Cancel research?", "Resources will be refunded.")						
		ACTION.AQ.BASE_ITEM:
			ConfirmModal.set_text("Cancel base upgrade?", "Resources will be refunded.")
		ACTION.AQ.ACCESSING:
			ConfirmModal.set_text("Cancel accessing SCP?", "Unspent resources will be refunded.")
		ACTION.AQ.TESTING:
			ConfirmModal.set_text("Cancel SCP testing?", "Unspent resources will be refunded.")			
		_:
			ConfirmModal.set_text("Missing instruction...", "Check for errors.")
			
	await show_only([ConfirmModal])	
	var response:Dictionary = await ConfirmModal.user_response
	match response.action:
		ACTION.NEXT:
			match action_item.action:
				ACTION.AQ.BUILD_ITEM:
					SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(action_item.ref, resources_data, true)
				ACTION.AQ.RESEARCH_ITEM:
					SUBSCRIBE.resources_data = RD_UTIL.calculate_purchase_cost(action_item.ref, resources_data, true)
				ACTION.AQ.BASE_ITEM:
					SUBSCRIBE.resources_data = BASE_UTIL.calculate_purchase_cost(action_item.ref, resources_data, true)
				ACTION.AQ.CONTAIN:
					cancel_scp_containment(action_item.ref)
				ACTION.AQ.TRANSFER:
					cancel_scp_transfer(action_item.ref)
				ACTION.AQ.ACCESSING:
					stop_scp_testing(action_item.ref)
				ACTION.AQ.TESTING:
					stop_scp_testing(action_item.ref)
					
			await remove_from_action_queue(action_item)
	
	if include_restore:
		await restore_default_state()
# -----------------------------------

# -----------------------------------
func remove_from_action_queue(action_item:Dictionary) -> void:
	SUBSCRIBE.action_queue_data = action_queue_data.filter(func(i): return i.uid != action_item.uid)
	await ActionQueueContainer.remove_from_queue([action_item])
# -----------------------------------

# -----------------------------------
func add_action_queue_item(dict:Dictionary, props:Dictionary = {}) -> void:
	action_queue_data.push_back({
		"uid": U.generate_uid(),
		"action": dict.action,
		"ref": dict.ref,
		"title_btn": dict.title_btn,
		"description": dict.description,
		"count":{
			"day": 0,
			"completed_at": dict.completed_at,
		},
		"location": dict.location.duplicate(),
		"props": props
	})
	
	
	SUBSCRIBE.action_queue_data = action_queue_data
# -----------------------------------
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
#region SCP FUNCS (assign/unassign/dismiss, etc)
# -----------------------------------
func create_new_contained_item(ref:int, location:Dictionary) -> Dictionary:
	return { 
		"ref": ref,
		"unlocked": [],
		"location": location,
		"days_in_containment": 0,
		"lead_researcher": {
			#uid:[string[
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
func start_scp_testing(ref:int) -> void:
	# resets it in the available list
	var res:Dictionary = find_in_contained(ref)
	var index:int = res.index
	var list_data:Dictionary = res.data
	var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(list_data.lead_researcher.uid, hired_lead_researchers_arr)
	var scp_details:Dictionary = SCP_UTIL.return_data(ref)
	# add placeholder
	scp_data.contained_list[index].current_testing = { 
		"testing_ref": -1,
		"progress": -1 
	}	
	
	add_action_queue_item({
		"action": ACTION.AQ.ACCESSING,
		"ref": scp_details.ref,
		"title_btn": {
			"title": "ACCESSING",
			"icon": SVGS.TYPE.CONTAIN,
		},
		"completed_at": 1,
		"description": "Accessing research for SCP-%s." % [scp_details.item_id],
		"location": list_data.location
	})	
	
	ConfirmModal.confirm_only = true
	ConfirmModal.set_text("Researcher %s begins accessing SCP-%s." % [researcher_details.name, scp_details.item_id])
	await show_only([ConfirmModal])	
	var response:Dictionary = await ConfirmModal.user_response
	
	SUBSCRIBE.action_queue_data = action_queue_data
	SUBSCRIBE.scp_data = scp_data
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
		
		# else add research id and being progressZ
		scp_data.contained_list[index].current_testing = { 
			"testing_ref": testing_ref,
			"progress": 0 
		}
		
		add_action_queue_item({
			"action": ACTION.AQ.TESTING,
			"ref": scp_ref,
			"title_btn": {
				"title": "TESTING",
				"icon": SVGS.TYPE.RESEARCH,
			},
			"completed_at": 7,
			"description": "Testing SCP-%s." % [scp_details.item_id],
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
func dismiss_researcher(researcher_data:Dictionary) -> void:
	# first, remove from any projects
	scp_data.contained_list = scp_data.contained_list.map(func(i): 
		if !i.lead_researcher.is_empty() and (i.lead_researcher.uid == researcher_data.details.uid):
			i.lead_researcher = {}
		return i
	)
	
	hired_lead_researchers_arr = hired_lead_researchers_arr.filter(func(i):
		return i[0] != researcher_data.details.uid	
	)
	
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
	SUBSCRIBE.scp_data = scp_data
# -----------------------------------

# -----------------------------------
func assign_researcher_to_scp_find_researcher(scp_details:Dictionary) -> void:
	ResearchersContainer.assign_only = true
	await show_only([ResearchersContainer])
	var response:Dictionary = await ResearchersContainer.user_response
	match response.action:
		ACTION.RESEARCHERS.SELECT_FOR_ASSIGN:
			var res:Dictionary = find_in_contained(scp_details.ref)
			var index:int = res.index
			var list_data:Dictionary = res.data
			scp_data.contained_list[index].lead_researcher = {
				"uid": response.data.details.uid
			}
			SUBSCRIBE.scp_data = scp_data
# -----------------------------------

# -----------------------------------
func assign_researcher_to_scp_find_scp(reseacher_details:Dictionary) -> void:
	ContainmentContainer.assign_only = true
	await show_only([ContainmentContainer])
	var response:Dictionary = await ContainmentContainer.user_response
	match response.action:
		ACTION.CONTAINED.SELECT_FOR_ASSIGN:
			var res:Dictionary = find_in_contained(response.data.ref)
			var index:int = res.index
			var list_data:Dictionary = res.data
			scp_data.contained_list[index].lead_researcher = {
				"uid": reseacher_details.details.uid
			}
			SUBSCRIBE.scp_data = scp_data	
# -----------------------------------


# -----------------------------------
func unassign_researcher_to_scp(scp_details:Dictionary) -> void:
	var res:Dictionary = find_in_contained(scp_details.ref)
	var index:int = res.index
	var list_data:Dictionary = res.data
	var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(list_data.lead_researcher.uid, hired_lead_researchers_arr)

	ConfirmModal.set_text("Remove %s as Lead Researcher on SCP-%s?" % [researcher_details.name, scp_details.item_id])
	await show_only([ConfirmModal])
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

func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
		
func on_bookmarked_rooms_update(new_val:Array = bookmarked_rooms) -> void:
	bookmarked_rooms = new_val
		
func on_researcher_hire_list_update(new_val:Array = researcher_hire_list) -> void:
	researcher_hire_list = new_val

func on_purchased_facility_arr_update(new_val:Array = purchased_facility_arr) -> void:
	purchased_facility_arr = new_val
	set_room_config()
	
func on_purchased_base_arr_update(new_val:Array = purchased_base_arr) -> void:
	purchased_base_arr = new_val	
	set_room_config()

func on_action_queue_data_update(new_val:Array = action_queue_data) -> void:
	action_queue_data = new_val
	set_room_config()

func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val
	set_room_config()

#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	ON_SHOW_UPDATES
#region on_show_updates
func on_show_location_update() -> void:
	if !is_node_ready():return
	LocationContainer.is_showing = show_location
	showing_states[LocationContainer] = show_location
	
func on_show_structures_update() -> void:
	if !is_node_ready():return
	Structure3dContainer.is_showing = show_structures
	showing_states[Structure3dContainer] = show_structures
	
func on_show_actions_update() -> void:
	if !is_node_ready():return
	ActionContainer.is_showing = show_actions
	showing_states[ActionContainer] = show_actions
	
func on_show_action_queue_update() -> void:
	if !is_node_ready():return
	ActionQueueContainer.is_showing = show_action_queue
	showing_states[ActionQueueContainer] = show_action_queue

func on_show_reseachers_update() -> void:
	if !is_node_ready():return
	ResearchersContainer.is_showing = show_reseachers
	showing_states[ResearchersContainer] = show_reseachers
		
func on_room_item_status_update() -> void:
	if !is_node_ready():return
	RoomStatusContainer.is_showing = room_item_status
	showing_states[RoomStatusContainer] = room_item_status

func on_show_resources_update() -> void:
	if !is_node_ready():return
	ResourceContainer.is_showing = show_resources
	showing_states[ResourceContainer] = show_resources
		
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

func on_show_status_update() -> void:
	if !is_node_ready():return
	StatusContainer.is_showing = show_status
	showing_states[StatusContainer] = show_status

func on_show_info_update() -> void:
	if !is_node_ready():return
	InfoContainer.is_showing = show_info
	showing_states[InfoContainer] = show_info

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

func on_show_back_update() -> void:
	if !is_node_ready():return
	BackContainer.is_showing = show_back
	showing_states[BackContainer] = show_back

func on_show_end_of_phase_update() -> void:
	if !is_node_ready():return
	EndOfPhaseContainer.is_showing = show_end_of_phase
	showing_states[EndOfPhaseContainer] = show_end_of_phase

func _on_container_rect_changed() -> void:	
	if !is_node_ready():return
	for sidebar in [RoomStatusContainer, ActionQueueContainer]:
		sidebar.max_height = self.size.y

#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	SHOP STEPS
#region SHOP STATES
func on_current_shop_step_update() -> void:
	if !is_node_ready():return
	
	match current_shop_step:
		# ---------------
		SHOP_STEPS.HIDE:
			SUBSCRIBE.suppress_click = false
			await restore_default_state()
			StoreContainer.end()
			on_store_closed.emit()
		# ---------------
		SHOP_STEPS.START_BASE:
			shop_revert_step = current_shop_step
			SUBSCRIBE.suppress_click = true
			selected_shop_item = {}
			
			StoreContainer.start('BASE')
			await show_only([StoreContainer])
			var response:Dictionary = await StoreContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.PURCHASE.BACK:
					current_shop_step = SHOP_STEPS.HIDE
					
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
			
			StoreContainer.start('ROOM')
			await show_only([StoreContainer])
			var response:Dictionary = await StoreContainer.user_response

			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.PURCHASE.BACK:
					current_shop_step = SHOP_STEPS.HIDE
					
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
		#SHOP_STEPS.PLACEMENT:		
			#SUBSCRIBE.unavailable_rooms = ROOM_UTIL.return_unavailable_rooms(selected_shop_item.ref, room_config)	
			## sort which rooms can be built in
			#await show_only([Structure3dContainer, LocationContainer, ActionQueueContainer, BackContainer])			
			##Structure3dContainer.select_location()
			#Structure3dContainer.placement_instructions = ROOM_UTIL.return_placement_instructions(selected_shop_item.ref)
			#
			#var structure_response:Dictionary = await Structure3dContainer.user_response
			#Structure3dContainer.placement_instructions = []
#
			#match structure_response.action:
				#ACTION.BACK:		
					##SUBSCRIBE.camera_settings = camera_settings
					#SUBSCRIBE.unavailable_rooms = []
					#current_shop_step = shop_revert_step
				#ACTION.NEXT:
					##SUBSCRIBE.camera_settings = camera_settings
					#SUBSCRIBE.unavailable_rooms = []
					#current_shop_step = SHOP_STEPS.CONFIRM_BUILD
		# ---------------
		SHOP_STEPS.CONFIRM_TIER_PURCHASE:
			ConfirmModal.set_text("Confirm TIER purchase?")
			await show_only([Structure3dContainer, ConfirmModal])			
			var confirm_response:Dictionary = await ConfirmModal.user_response			
			match confirm_response.action:
				ACTION.BACK:
					current_shop_step = shop_revert_step
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.FINALIZE_PURCHASE_TIER
		# ---------------
		SHOP_STEPS.CONFIRM_RESEARCH_ITEM_PURCHASE:
			ConfirmModal.set_text("Confirm research?")
			await show_only([Structure3dContainer, ConfirmModal])
			var confirm_response:Dictionary = await ConfirmModal.user_response
			match confirm_response.action:
				ACTION.BACK:
					current_shop_step = shop_revert_step
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.FINALIZE_PURCHASE_RESEARCH
		# ---------------
		SHOP_STEPS.CONFIRM_BASE_ITEM_PURCHASE:
			ConfirmModal.set_text("Confirm base item purchase?")
			await show_only([Structure3dContainer, ConfirmModal])
			var confirm_response:Dictionary = await ConfirmModal.user_response
			match confirm_response.action:
				ACTION.BACK:
					current_shop_step = shop_revert_step
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.FINALIZE_PURCHASE_BASE_ITEM
		# ---------------
		SHOP_STEPS.CONFIRM_BUILD:
			ConfirmModal.set_text("Confirm location?")
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
			add_action_queue_item({
				"action": ACTION.AQ.BUILD_ITEM,
				"ref": selected_shop_item.ref,
				"title_btn": {
					"title": "CONSTRUCTING...", 
					"icon": SVGS.TYPE.BUILD,
				},
				"completed_at": purchase_item_data.get_build_time.call() if "get_build_time" in purchase_item_data else 0,
				"description": "%s" % [purchase_item_data.name],
				"location": current_location.duplicate()
			})
			
			SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(selected_shop_item.ref, resources_data)
			current_shop_step = SHOP_STEPS.HIDE
		# ---------------
		SHOP_STEPS.FINALIZE_PURCHASE_RESEARCH:
			var purchase_item_data:Dictionary = RD_UTIL.return_data(selected_shop_item.ref)
			add_action_queue_item({
				"action": ACTION.AQ.RESEARCH_ITEM,
				"ref": selected_shop_item.ref,
				"title_btn": {
					"title": "RESEARCHING...", 
					"icon": SVGS.TYPE.RESEARCH,
				},
				"completed_at": purchase_item_data.get_build_time.call() if "get_build_time" in purchase_item_data else 0,
				"description": "%s" % [purchase_item_data.name],
				"location": current_location.duplicate()
			})

			
			SUBSCRIBE.resources_data = RD_UTIL.calculate_purchase_cost(selected_shop_item.ref, resources_data)
			current_shop_step = shop_revert_step
		# ---------------
		SHOP_STEPS.FINALIZE_PURCHASE_BASE_ITEM:
			var purchase_item_data:Dictionary = BASE_UTIL.return_data(selected_shop_item.ref)
			add_action_queue_item({
				"action": ACTION.AQ.BASE_ITEM,
				"ref": selected_shop_item.ref,
				"title_btn": {
					"title": "UPGRADING...", 
					"icon": SVGS.TYPE.RESEARCH,
				},
				"completed_at": purchase_item_data.get_build_time.call() if "get_build_time" in purchase_item_data else 0,
				"description": "%s" % [purchase_item_data.name],
				"location": current_location.duplicate()
			})
			
			SUBSCRIBE.resources_data = BASE_UTIL.calculate_purchase_cost(selected_shop_item.ref, resources_data)
			current_shop_step = shop_revert_step
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
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	CONTAIN STEPS
#region CONTAIN STEPS
func on_current_contain_step_update() -> void:
	if !is_node_ready():return
	
	match current_contain_step:
		# ---------------
		CONTAIN_STEPS.HIDE:
			SUBSCRIBE.suppress_click = false
			await restore_default_state()
		# ---------------
		CONTAIN_STEPS.START:
			selected_contain_item = {} 
			selected_researcher_item = {} 
			SUBSCRIBE.suppress_click = true
			ContainmentContainer.assign_only = false
			await show_only([ ContainmentContainer])
			var response:Dictionary = await ContainmentContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			
			if "data" in response:
				selected_contain_item = response.data
				
			match response.action:
				# --------------------
				ACTION.CONTAINED.BACK:
					current_contain_step = CONTAIN_STEPS.HIDE
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
					await assign_researcher_to_scp_find_researcher(selected_contain_item)
					current_contain_step = CONTAIN_STEPS.START
				# --------------------
				ACTION.CONTAINED.UNASSIGN_RESEARCHER:
					await unassign_researcher_to_scp(selected_contain_item)
					current_contain_step = CONTAIN_STEPS.START
				# --------------------
				ACTION.CONTAINED.START_TESTING:
					await start_scp_testing(selected_contain_item.ref)
					current_contain_step = CONTAIN_STEPS.START
				# --------------------
				ACTION.CONTAINED.STOP_TESTING:
					ConfirmModal.set_text("Cancel SCP testing?", "Unspent resources will be refunded.")
					await show_only([ConfirmModal])
					var res:Dictionary = await ConfirmModal.user_response
					match res.action:
						ACTION.NEXT:					
							await stop_scp_testing(selected_contain_item.ref)
					current_contain_step = CONTAIN_STEPS.START
		# ---------------
		CONTAIN_STEPS.PLACEMENT:
			await show_only([Structure3dContainer, LocationContainer])			
			SUBSCRIBE.unavailable_rooms = SCP_UTIL.return_unavailable_rooms(selected_contain_item.ref, room_config, scp_data)
			
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
			ConfirmModal.set_text("Remove SCP from available list?")
			await show_only([ConfirmModal])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.BACK:
					current_contain_step = CONTAIN_STEPS.START
				ACTION.NEXT:
					var action_queue_item:Dictionary = action_queue_data.filter(func(i): return i.ref == selected_contain_item.ref)[0]
					cancel_scp_containment(action_queue_item.ref)
					scp_data.available_list = scp_data.available_list.filter(func(i):return i.ref != selected_contain_item.ref)
					SUBSCRIBE.scp_data = scp_data
					current_contain_step = CONTAIN_STEPS.START
		# ---------------
		CONTAIN_STEPS.ON_TRANSFER_CANCEL:
			var action_queue_item:Dictionary = {}
			if selected_contain_item.is_new_transfer:
				action_queue_item = action_queue_data.filter(func(i): return i.ref == selected_contain_item.ref and i.action == ACTION.AQ.CONTAIN)[0]
			else:
				action_queue_item = action_queue_data.filter(func(i): return i.ref == selected_contain_item.ref and i.action == ACTION.AQ.TRANSFER)[0]
			await cancel_action_queue(action_queue_item, false)
			current_contain_step = CONTAIN_STEPS.START
		# ---------------
		CONTAIN_STEPS.ON_TRANSFER_TO_NEW_LOCATION:
			await show_only([Structure3dContainer])
			SUBSCRIBE.unavailable_rooms = SCP_UTIL.return_unavailable_rooms(selected_contain_item.ref, room_config, scp_data)
			
			Structure3dContainer.select_location()
			Structure3dContainer.placement_instructions = [] #ROOM_UTIL.return_placement_instructions(selected_shop_item.id)
			
			var structure_response:Dictionary = await Structure3dContainer.user_response
			Structure3dContainer.placement_instructions = []
			
			match structure_response.action:
				ACTION.BACK:					
					SUBSCRIBE.unavailable_rooms = []
					current_contain_step = CONTAIN_STEPS.START
				ACTION.NEXT:
					SUBSCRIBE.unavailable_rooms = []
					current_contain_step = CONTAIN_STEPS.CONFIRM_PLACEMENT
					
		# ---------------
		CONTAIN_STEPS.CONFIRM_PLACEMENT:
			ConfirmModal.set_text("Contain at this location?")
			await show_only([ConfirmModal])
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
			
			add_action_queue_item({
				"action": ACTION.AQ.CONTAIN if selected_contain_item.is_new_transfer else ACTION.AQ.TRANSFER,
				"ref": selected_contain_item.ref,
				"title_btn": {
					"title": "CONTAINMENT IN PROGRESS" if selected_contain_item.is_new_transfer else "TRANSFER IN PROGRESS",
					"icon": SVGS.TYPE.CONTAIN,
				},
				"completed_at": scp_details.containment_time.call(),
				"description": "SCP-%s %s." % [selected_contain_item.item_id, "CONTAINMENT" if selected_contain_item.is_new_transfer else "TRANSFER" ],
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
		RECRUIT_STEPS.HIDE:
			SUBSCRIBE.suppress_click = false
			await restore_default_state()
		# ---------------
		CONTAIN_STEPS.START:
			SUBSCRIBE.suppress_click = true
			selected_lead_hire = {}
			selected_support_hire = {}
			await show_only([RecruitmentContainer])
			var response:Dictionary = await RecruitmentContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.HIRE.BACK:
					current_recruit_step = RECRUIT_STEPS.HIDE
				ACTION.HIRE.LEAD:
					selected_lead_hire = response.data
					current_recruit_step = RECRUIT_STEPS.CONFIRM_HIRE_LEAD
				ACTION.HIRE.SUPPORT:
					selected_support_hire = response.data
					current_recruit_step = RECRUIT_STEPS.CONFIRM_HIRE_SUPPORT
		# ---------------
		RECRUIT_STEPS.CONFIRM_HIRE_LEAD:
			ConfirmModal.set_text("Confirm hire?")
			await show_only([ConfirmModal])
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
			ConfirmModal.set_text("Confirm support?")
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
		ACTION_COMPLETE_STEPS.HIDE:
			SUBSCRIBE.suppress_click = false
			await restore_default_state()
		# ---------------
		ACTION_COMPLETE_STEPS.START:
			SUBSCRIBE.suppress_click = true
			revert_state_location = current_location
			BuildCompleteContainer.completed_build_items = completed_actions
			await show_only([BuildCompleteContainer])
			var response:Dictionary = await BuildCompleteContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.DONE:
					current_action_complete_step = ACTION_COMPLETE_STEPS.HIDE
				ACTION.SKIP:
					current_action_complete_step = ACTION_COMPLETE_STEPS.HIDE
			
			current_location = revert_state_location
			
			# REMOVES FROM QUEUE LIST
			await ActionQueueContainer.remove_from_queue(completed_actions)
			
			# resets event_data 
			var event_data_arr:Array = []
		
			# UPDATE SAVABLE DATA
			for item in completed_actions:
				await on_completed_action(item)
				
			# update reactively
			completed_actions = []
			on_complete_build_complete.emit()
			
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
#region CURRENT EVENT STEPS
func on_current_event_step_update() -> void:
	if !is_node_ready():return

	match current_event_step:
		EVENT_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
			await restore_default_state()
		EVENT_STEPS.START:
			SUBSCRIBE.suppress_click = true
			await show_only([EventContainer])
			EventContainer.event_data = event_data
			EventContainer.start()
			var event_res:Dictionary = await EventContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			# reset and evempty event_data
			event_data = []
			current_event_step = EVENT_STEPS.RESET
			await U.set_timeout(0.5)
			# trigger signal
			on_events_complete.emit(event_res)
			
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
#region SUMMARY STEPS
func on_current_summary_step_update() -> void:
	if !is_node_ready():return

	match current_summary_step:
		SUMMARY_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
			await restore_default_state()
		SUMMARY_STEPS.START:
			SUBSCRIBE.suppress_click = true
			await show_only([EndOfPhaseContainer])
			EndOfPhaseContainer.summary_data = []
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
#region RESEARCHER STEPS
func on_current_researcher_step_update() -> void:
	if !is_node_ready() and !Engine.is_editor_hint():return
	
	match current_researcher_step:
		RESEARCHERS_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
			await restore_default_state()
			selected_scp_details = {}
			selected_researcher_item = {}
			
		RESEARCHERS_STEPS.START:
			SUBSCRIBE.suppress_click = true
			ResearchersContainer.assign_only = false
			await show_only([ResearchersContainer])
			var response:Dictionary = await ResearchersContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			
			if "data" in response:
				selected_researcher_item = response.data
			
			if "scp_details" in response:
				selected_scp_details = response.scp_details
			
			match response.action:
				ACTION.RESEARCHERS.BACK:
					current_researcher_step = RESEARCHERS_STEPS.RESET
				ACTION.RESEARCHERS.DISMISS:
					current_researcher_step = RESEARCHERS_STEPS.DISMISS
				ACTION.RESEARCHERS.UNASSIGN_FROM_SCP:
					await unassign_researcher_to_scp(selected_scp_details)
					current_researcher_step = RESEARCHERS_STEPS.START
				ACTION.RESEARCHERS.ASSIGN_TO_SCP:
					await assign_researcher_to_scp_find_scp(selected_researcher_item)
					current_researcher_step = RESEARCHERS_STEPS.START
		RESEARCHERS_STEPS.DISMISS:
			ConfirmModal.set_text("Dismiss DR %s?" % [selected_researcher_item.details.name], "Researcher will be removed permanently.")
			await show_only([Structure3dContainer, ConfirmModal])			
			var confirm_response:Dictionary = await ConfirmModal.user_response
			match confirm_response.action:
				ACTION.BACK:
					current_researcher_step = RESEARCHERS_STEPS.START
				ACTION.NEXT:
					current_researcher_step = RESEARCHERS_STEPS.FINALIZE_DISMISS
		RESEARCHERS_STEPS.FINALIZE_DISMISS:
			var props:Dictionary = {
				"name": selected_researcher_item.details.name,
				"onSelection": func(val:EVT.DISMISS_TYPE) -> void:
					match val:
						EVT.DISMISS_TYPE.THANK_AND_DISMISS:
							print('no change, costs money as severence based')
						EVT.DISMISS_TYPE.ADMINISTER_AMNESTICS:
							print('no change')
						EVT.DISMISS_TYPE.TERMINATE:
							print('dec morale')
			}
			event_data = [EVENT_UTIL.run_event(EVT.TYPE.DISMISS_RESEARCHER, props)]
			await on_events_complete
			dismiss_researcher(selected_researcher_item)
			current_researcher_step = RESEARCHERS_STEPS.START
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	CONTROLS
#region CONTROL UPDATE
func is_occupied() -> bool:
	if is_busy or processing_next_day or GBL.has_animation_in_queue():
		return true
	if (current_shop_step != SHOP_STEPS.HIDE) or (current_contain_step != CONTAIN_STEPS.HIDE) or (current_recruit_step != RECRUIT_STEPS.HIDE) or (current_action_complete_step != ACTION_COMPLETE_STEPS.HIDE) or (current_event_step != EVENT_STEPS.RESET):
		return true
	return false

#func on_mouse_scroll(dir:int) -> void:
	#if is_occupied() or camera_settings.is_locked:return
	#match dir:
		#0: #UP
			#if camera_settings.zoom - 1 >= 0:
				#camera_settings.zoom = camera_settings.zoom - 1
		#1: #DOWN
			#if camera_settings.zoom + 1 < CAMERA.ZOOM.size():
				#camera_settings.zoom = camera_settings.zoom + 1
				#
	#SUBSCRIBE.camera_settings = camera_settings
	
func on_control_input_update(input_data:Dictionary) -> void:
	if is_occupied():return
	
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"5":
			quicksave()
		"8":
			quickload()
		
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	SAVE/LOAD
#region SAVE/LOAD
func quicksave() -> void:
	is_busy = true
	var save_data = {
		"room_config": room_config,
		"progress_data": progress_data,		
		"scp_data": scp_data,
		"action_queue_data": action_queue_data,
		"purchased_base_arr": purchased_base_arr,
		"purchased_facility_arr": purchased_facility_arr,
		"purchased_research_arr": purchased_research_arr,
		"hired_lead_researchers_arr": hired_lead_researchers_arr,
		"resources_data": resources_data,
		"bookmarked_rooms": bookmarked_rooms,
		"researcher_hire_list": researcher_hire_list,
		"tier_unlocked": tier_unlocked,
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
	await restore_default_state()
	
	# trigger on reset in nodes
	for node in get_all_container_nodes():
		if "on_reset" in node:
			node.on_reset()
	
	SUBSCRIBE.progress_data = initial_values.progress_data if no_save else restore_data.progress_data
	SUBSCRIBE.scp_data = initial_values.scp_data if no_save else restore_data.scp_data
	SUBSCRIBE.action_queue_data = initial_values.action_queue_data if no_save else restore_data.action_queue_data	
	SUBSCRIBE.purchased_facility_arr = initial_values.purchased_facility_arr if no_save else restore_data.purchased_facility_arr  
	SUBSCRIBE.purchased_base_arr = initial_values.purchased_base_arr if no_save else restore_data.purchased_base_arr
	SUBSCRIBE.resources_data = initial_values.resources_data if no_save else restore_data.resources_data	
	SUBSCRIBE.bookmarked_rooms = initial_values.bookmarked_rooms if no_save else restore_data.bookmarked_rooms
	SUBSCRIBE.researcher_hire_list = initial_values.researcher_hire_list if no_save else restore_data.researcher_hire_list
	SUBSCRIBE.purchased_research_arr = initial_values.purchased_research_arr if no_save else restore_data.purchased_research_arr
	SUBSCRIBE.tier_unlocked = initial_values.tier_unlocked if no_save else restore_data.tier_unlocked
	SUBSCRIBE.unavailable_rooms = initial_values.unavailable_rooms if no_save else restore_data.unavailable_rooms

	# comes after purchased_research_arr, fix this later
	SUBSCRIBE.hired_lead_researchers_arr = initial_values.hired_lead_researchers_arr if no_save else restore_data.hired_lead_researchers_arr
	SUBSCRIBE.room_config = initial_values.room_config if no_save else restore_data.room_config
	
	# don't need to be saved, just load from defaults
	SUBSCRIBE.current_location = initial_values.current_location 
	SUBSCRIBE.camera_settings = initial_values.camera_settings 
	

	
#endregion		
# ------------------------------------------------------------------------------
