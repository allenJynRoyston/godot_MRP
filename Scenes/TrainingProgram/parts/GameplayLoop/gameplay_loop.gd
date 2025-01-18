extends PanelContainer

enum SHOP_STEPS {
	HIDE, START, SHOW, PLACEMENT,
	CONFIRM_RESEARCH_ITEM_PURCHASE, CONFIRM_BUILD, CONFIRM_TIER_PURCHASE, CONFIRM_BASE_ITEM_PURCHASE,
	FINALIZE_PURCHASE_BUILD, FINALIZE_PURCHASE_RESEARCH, FINALIZE_PURCHASE_TIER, FINALIZE_PURCHASE_BASE_ITEM,
	REFUND
}
enum CONTAIN_STEPS {HIDE, START, SHOW, PLACEMENT, CONFIRM_PLACEMENT, 
	ON_REJECT, ON_TRANSFER_CANCEL, 
	ON_TRANSFER_TO_NEW_LOCATION, 
	CONFIRM_RESEARCHER, CONFIRM_REMOVE_RESEARCHER,
	CONFIRM, FINALIZE
}
enum RECRUIT_STEPS {HIDE, START, SHOW, CONFIRM_HIRE_LEAD, CONFIRM_HIRE_SUPPORT, FINALIZE}
enum BUILD_COMPLETE_STEPS {HIDE, START, FINALIZE}

enum RESEARCHERS_STEPS {RESET, START, WAIT_FOR_SELECT}
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
#endregion
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------ 
#region SAVABLE DATA
var previous_camera_settings:CAMERA.ZOOM 

var camera_settings:Dictionary = {
	"zoom": CAMERA.ZOOM.OVERVIEW,
	"is_locked": false
}

var current_location:Dictionary = {
	"floor": 0,
	"ring": 0,
	"room": 0
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

var action_queue_data:Array = []

var purchased_facility_arr:Array = [] 

var purchased_base_arr:Array = []

var purchased_research_arr:Array = []

var bookmarked_rooms:Array = [] # ["000", "201"] <- "floor_index, ring_index, room_index"]

var unavailable_rooms:Array = []

var researcher_hire_list:Array = RESEARCHER_UTIL.generate_new_researcher_hires() 

var hired_lead_researchers_arr:Array = [] 

var resources_data:Dictionary = { 
	RESOURCE.TYPE.MONEY: {"amount": 500, "capacity": 9999},
	RESOURCE.TYPE.ENERGY: {"amount": 25, "capacity": 28},
	RESOURCE.TYPE.LEAD_RESEARCHERS: {"amount": 0, "capacity": 0},
	RESOURCE.TYPE.STAFF: {"amount": 0, "capacity": 0},
	RESOURCE.TYPE.SECURITY: {"amount": 0, "capacity": 0},
	RESOURCE.TYPE.DCLASS: {"amount": 0, "capacity": 0},
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
		0: get_floor_default(false),
		1: get_floor_default(),
		2: get_floor_default(),
		3: get_floor_default(),
		4: get_floor_default(),
		5: get_floor_default(),
		6: get_floor_default(),
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
var expired_scp_items:Array = [] 

var showing_states:Dictionary = {} 
var revert_state_location:Dictionary = {}
var tenative_location:Dictionary = {}

var completed_build_items:Array = [] : 
	set(val):
		completed_build_items = val
		if !completed_build_items.is_empty():
			current_build_complete_step = BUILD_COMPLETE_STEPS.START
			
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
		
var current_build_complete_step:BUILD_COMPLETE_STEPS = BUILD_COMPLETE_STEPS.HIDE : 
	set(val):
		current_build_complete_step = val
		on_current_build_complete_step_update()

var current_event_step:EVENT_STEPS = EVENT_STEPS.RESET : 
	set(val):
		current_event_step = val
		on_current_event_step_update()

var current_researcher_step:RESEARCHERS_STEPS = RESEARCHERS_STEPS.RESET : 
	set(val):
		current_researcher_step = val
		on_current_researcher_step_update()


signal store_select_location
signal on_complete_build_complete
signal on_expired_scp_items_complete
signal on_events_complete

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

	# other
	on_show_confirm_modal_update()
	on_is_busy_update()
	
	# steps
	#on_show_store_update()
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
	after_start()
	quickload()

func start_load_game() -> void:
	# load save file
	after_start()
	
func after_start() -> void:
	LocationContainer.goto_location(current_location)	
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
#region defaults functions
func get_floor_default(is_locked:bool = true) -> Dictionary:
	return { 
		"is_locked": is_locked,
		"readings": {
			RESOURCE.BASE.MORALE: 4,
			RESOURCE.BASE.SECURITY: 4,
			RESOURCE.BASE.READINESS: 3,
			RESOURCE.BASE.HUME: 5,
		},
		"ring": { 
			0: get_room_default(),
			1: get_room_default(),
			2: get_room_default()
		}
	}

func get_room_default() -> Dictionary:
	return {
		"room": {
			0: get_room_item_default(),
			1: get_room_item_default(),
			2: get_room_item_default(),
			3: get_room_item_default(),
			4: get_room_item_default(),
			5: get_room_item_default(),
		}
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
		BuildCompleteContainer, InfoContainer, EventContainer
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

func cancel_action(item_data:Dictionary) -> void:
	selected_refund_item = item_data
	current_shop_step = SHOP_STEPS.REFUND

func update_tenative_location(location:Dictionary) -> void:
	tenative_location = location	
			
func goto_location(location:Dictionary) -> void:
	LocationContainer.goto_location(location)
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
			"perform_action": func(action:int) -> void:
				match action:
					ACTION.CONTAINED.CANCEL_TRANSFER:
						var filtered_arr:Array = action_queue_data.filter(func(i): return i.data.ref == scp_ref and i.action == ACTION.CONTAINED.TRANSFER_TO_NEW_LOCATION)
						if !filtered_arr.is_empty():
							var action_queue_item:Dictionary = filtered_arr[0]
							cancel_scp_transfer(action_queue_item)
						else:
							print("perform_action CANCEL_TRANSFER_SCP_TO_NEW_LOCATION: action queue item does not exists for this action.")
				pass,
			# -------------------------	
			# get counts for type (randomize, after_contained, etc)
			"event_type_count": func(type:int, event_id:int) -> int:
				var res:Dictionary = find_in_contained(scp_ref)
				var event_name:String = "%s%s" % [type, event_id]
				return 0 if event_name not in res.data.event_type_count else res.data.event_type_count[event_name].count,
			# -------------------------
			# easy method to call when you want to add something to their unlockable
			"add_unlockable": func(unlockable:SCP_UTIL.UNLOCKABLE) -> void:
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
					"get_data": func() -> Dictionary:
						return SCP_UTIL.return_data(item.ref)
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
					"get_data": func() -> Dictionary:
						return SCP_UTIL.return_data(item.ref)
				}			
			var floor:int = item.location.floor
			var ring:int = item.location.ring
			var room:int = item.location.room	
			new_room_config.floor[floor].ring[ring].room[room].scp_data = {
				"ref": item.ref,
				"is_transfer": item.transfer_status.state,
				"get_data": func() -> Dictionary:
					return SCP_UTIL.return_data(item.ref)
			}				
	
	# mark rooms that are under construction...
	for item in action_queue_data:
		match item.action:
			ACTION.AQ.BUILD_ITEM:
				var floor:int = item.location.floor
				var ring:int = item.location.ring
				var room:int = item.location.room		
				new_room_config.floor[floor].ring[ring].room[room].build_data = {
					"ref": item.data.ref,
					"get_data": func() -> Dictionary:
						return ROOM_UTIL.return_data(item.data.ref)
				}

	# mark rooms that are already built...
	for item in purchased_facility_arr:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		new_room_config.floor[floor].ring[ring].room[room].room_data = {
			"ref": item.data.ref,
			"get_data": func() -> Dictionary:
				return ROOM_UTIL.return_data(item.data.ref)
		}
		# if facility is built, clear build_data
		new_room_config.floor[floor].ring[ring].room[room].build_data = {}
	
	# mark rooms and push to subscriptions
	for floor_index in new_room_config.floor.size():
		for ring_index in new_room_config.floor[floor_index].ring.size():
			for room_index in new_room_config.floor[floor_index].ring[ring_index].room.size():
				var designation:String = "%s%s%s" % [floor_index, ring_index, room_index]
				var config_data:Dictionary = new_room_config.floor[floor_index].ring[ring_index].room[room_index]
				if !config_data.build_data.is_empty():
					under_construction_rooms.push_back(designation)
				if !config_data.room_data.is_empty():
					built_rooms.push_back(designation)
			
	# mark rooms that are already built...
	new_room_config.floor[1].is_locked = BASE_UTIL.get_count(BASE.TYPE.UNLOCK_FLOOR_2, purchased_base_arr) == 0
	new_room_config.floor[2].is_locked = BASE_UTIL.get_count(BASE.TYPE.UNLOCK_FLOOR_3, purchased_base_arr) == 0
			
	SUBSCRIBE.room_config = new_room_config	
	SUBSCRIBE.under_construction_rooms = under_construction_rooms
	SUBSCRIBE.built_rooms = built_rooms
# -----------------------------------

# -----------------------------------
func cancel_scp_transfer(selected_data:Dictionary) -> void:
	# resets it in the available list
	scp_data.contained_list = scp_data.contained_list.map(func(i) -> Dictionary:
		if i.ref == selected_data.data.ref:
			i.transfer_status = {
				"state": false, 
				"days_till_complete": -1,
				"location": {}
			}
		return i
	)
	SUBSCRIBE.scp_data = scp_data
	
	# remove from action queue list
	SUBSCRIBE.action_queue_data = action_queue_data.filter(func(i): 
		return !(i.action == ACTION.CONTAINED.TRANSFER_TO_NEW_LOCATION and i.data.ref == selected_data.data.ref)
	)
	ActionQueueContainer.remove_from_queue([selected_data])
# -----------------------------------

# -----------------------------------
func cancel_scp_containment(selected_data:Dictionary) -> void:
	# resets it in the available list
	scp_data.available_list = scp_data.available_list.map(func(i) -> Dictionary:
		if i.ref == selected_data.data.ref:
			i.transfer_status = {
				"state": false, 
				"days_till_complete": -1,
				"location": {}
			}
		return i
	)
	SUBSCRIBE.scp_data = scp_data
	
	# remove from action queue list
	SUBSCRIBE.action_queue_data = action_queue_data.filter(func(i): 
		return !(i.action == ACTION.CONTAINED.START_CONTAINMENT and i.data.ref == selected_data.data.ref)
	)
	ActionQueueContainer.remove_from_queue([selected_data])
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
func assign_researcher_to_scp(lead_researcher:Dictionary, scp_details:Dictionary) -> void:
	var res:Dictionary = find_in_contained(scp_details.ref)
	var index:int = res.index
	var list_data:Dictionary = res.data
	scp_data.contained_list[index].lead_researcher = {
		"uid": lead_researcher.details.uid
	}
	SUBSCRIBE.scp_data = scp_data
# -----------------------------------

# -----------------------------------
func unassign_researcher_to_scp(scp_details:Dictionary) -> void:
	var res:Dictionary = find_in_contained(scp_details.ref)
	var index:int = res.index
	var list_data:Dictionary = res.data
	scp_data.contained_list[index].lead_researcher = {}
	SUBSCRIBE.scp_data = scp_data
# -----------------------------------	

# -----------------------------------
func check_events(ref:int, type:SCP.EVENT_TYPE, skip_wait:bool = false) -> void:
	var res:Dictionary = find_in_contained(ref)
	var index:int = res.index
	var list_data:Dictionary = res.data
	var event:Dictionary = SCP_UTIL.check_for_events(ref, get_data_snapshot, get_self_ref_callable(ref), type)
	var event_arr:Array = []
	if !event.event_instructions.is_empty():
		var event_id:int = event.event_id
		
		# add number of times an event has been triggered
		var event_type_id:String = "%s%s" % [type, event_id]
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
		await on_events_complete
# -----------------------------------

# -----------------------------------
func next_day() -> void:		
	# turn processing next day flag to true
	processing_next_day = true
	
	# show busy modal
	await wait_please(1.0)	
	
	# ADD TO PROGRESS DATA day count
	progress_data.day += 1
	SUBSCRIBE.progress_data = progress_data
	
	# UPDATES ALL THINGS LEFT IN QUEUE THAT REQUIRES MORE TIME
	action_queue_data = action_queue_data.map(func(i): 
		i.days_in_queue += 1
		return i
	)	
	var completed_build_items_arr:Array = action_queue_data.filter(func(i): return i.days_in_queue == i.build_time)	
	SUBSCRIBE.action_queue_data = action_queue_data.filter(func(i): return i.days_in_queue < i.build_time)
		
	# ADDS DAY COUNT TO SCP DATA
	scp_data.available_list = scp_data.available_list.map(func(i): i.days_until_expire = i.days_until_expire - 1; return i)
	scp_data.contained_list = scp_data.contained_list.map(func(i): i.days_in_containment = i.days_in_containment + 1; return i)
	
	# ...and remove if expired, add to expire list
	expired_scp_items = scp_data.available_list.filter(func(i): return i.days_until_expire == 0 and !i.transfer_status.state)
	scp_data.available_list = scp_data.available_list.filter(func(i): return i.days_until_expire > 0 or i.transfer_status.state)
	
	# ADDS TO COMPLETED BUILD ITEMS LIST IF THEY'RE DONE
	if completed_build_items_arr.size() > 0:
		completed_build_items = completed_build_items_arr
		await on_complete_build_complete
	
	
	# make notification that SCP has expired
	if expired_scp_items.size() > 0:
		pass	
	
	# CHECK FOR RANDOMIZED EVENTS
	#var event_data_arr = []
	for index in scp_data.contained_list.size():
		var data:Dictionary = scp_data.contained_list[index]
		if data.days_in_containment > 0:
			var event_type:int = SCP.EVENT_TYPE.RANDOM_EVENTS if !data.transfer_status.state else SCP.EVENT_TYPE.DURING_TRANSFER
			await check_events(data.ref, event_type, true)
	processing_next_day = false
	
	
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
	if is_node_ready() or Engine.is_editor_hint():
		LocationContainer.is_showing = show_location
		showing_states[LocationContainer] = show_location
	
func on_show_structures_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		Structure3dContainer.is_showing = show_structures
		showing_states[Structure3dContainer] = show_structures
	
func on_show_actions_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ActionContainer.is_showing = show_actions
		showing_states[ActionContainer] = show_actions
	
func on_show_action_queue_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ActionQueueContainer.is_showing = show_action_queue
		showing_states[ActionQueueContainer] = show_action_queue

func on_show_reseachers_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ResearchersContainer.is_showing = show_reseachers
		showing_states[ResearchersContainer] = show_reseachers
		
func on_room_item_status_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		RoomStatusContainer.is_showing = room_item_status
		showing_states[RoomStatusContainer] = room_item_status

func on_show_resources_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ResourceContainer.is_showing = show_resources
		showing_states[ResourceContainer] = show_resources
		
func on_show_dialogue_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		DialogueContainer.is_showing = show_dialogue
		showing_states[DialogueContainer] = show_dialogue

func on_show_store_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		StoreContainer.is_showing = show_store
		showing_states[StoreContainer] = show_store

func on_show_containment_status_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ContainmentContainer.is_showing = show_containment_status
		showing_states[ContainmentContainer] = show_containment_status

func on_show_confirm_modal_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ConfirmModal.is_showing = show_confirm_modal
		showing_states[ConfirmModal] = show_confirm_modal

func on_show_recruit_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		RecruitmentContainer.is_showing = show_recruit
		showing_states[RecruitmentContainer] = show_recruit

func on_show_status_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		StatusContainer.is_showing = show_status
		showing_states[StatusContainer] = show_status

func on_show_info_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		InfoContainer.is_showing = show_info
		showing_states[InfoContainer] = show_info

func on_show_events_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		EventContainer.is_showing = show_events
		showing_states[EventContainer] = show_events
		
		
func on_show_build_complete_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		BuildCompleteContainer.is_showing = show_build_complete
		showing_states[BuildCompleteContainer] = show_build_complete

func _on_container_rect_changed() -> void:	
	if is_node_ready() or Engine.is_editor_hint():
		for sidebar in [RoomStatusContainer, ActionQueueContainer]:
			sidebar.max_height = self.size.y

#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	SHOP STEPS
#region SHOP STATES
func on_current_shop_step_update() -> void:
	if !is_node_ready() and !Engine.is_editor_hint():return
	match current_shop_step:
		# ---------------
		SHOP_STEPS.HIDE:
			SUBSCRIBE.suppress_click = false
			await restore_default_state()
			StoreContainer.end()
		# ---------------
		SHOP_STEPS.START:
			SUBSCRIBE.suppress_click = true
			selected_shop_item = {}
			
			StoreContainer.start()
			await show_only([ResourceContainer, StoreContainer])
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
					SUBSCRIBE.unavailable_rooms = ROOM_UTIL.return_unavailable_rooms(selected_shop_item.ref, room_config)			
					current_shop_step = SHOP_STEPS.PLACEMENT
				
				ACTION.PURCHASE.RESEARCH_AND_DEVELOPMENT:
					selected_shop_item = response.selected
					current_shop_step = SHOP_STEPS.CONFIRM_RESEARCH_ITEM_PURCHASE
		# ---------------
		SHOP_STEPS.PLACEMENT:		
			# sort which rooms can be built in
			await show_only([Structure3dContainer, RoomStatusContainer])			
			Structure3dContainer.select_location()
			Structure3dContainer.placement_instructions = ROOM_UTIL.return_placement_instructions(selected_shop_item.ref)
			
			var structure_response:Dictionary = await Structure3dContainer.user_response
			Structure3dContainer.placement_instructions = []
			
			match structure_response.action:
				ACTION.BACK:					
					SUBSCRIBE.camera_settings = camera_settings
					SUBSCRIBE.unavailable_rooms = []
					current_shop_step = SHOP_STEPS.START
				ACTION.NEXT:
					SUBSCRIBE.camera_settings = camera_settings
					SUBSCRIBE.unavailable_rooms = []
					current_shop_step = SHOP_STEPS.CONFIRM_BUILD
		# ---------------
		SHOP_STEPS.CONFIRM_TIER_PURCHASE:
			ConfirmModal.set_text("Confirm TIER purchase?")
			await show_only([Structure3dContainer, ConfirmModal])			
			var confirm_response:Dictionary = await ConfirmModal.user_response			
			match confirm_response.action:
				ACTION.BACK:
					current_shop_step = SHOP_STEPS.START
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.FINALIZE_PURCHASE_TIER
		# ---------------
		SHOP_STEPS.CONFIRM_RESEARCH_ITEM_PURCHASE:
			ConfirmModal.set_text("Confirm research?")
			await show_only([Structure3dContainer, ConfirmModal])
			var confirm_response:Dictionary = await ConfirmModal.user_response
			match confirm_response.action:
				ACTION.BACK:
					current_shop_step = SHOP_STEPS.START
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.FINALIZE_PURCHASE_RESEARCH
		# ---------------
		SHOP_STEPS.CONFIRM_BASE_ITEM_PURCHASE:
			ConfirmModal.set_text("Confirm base item purchase?")
			await show_only([Structure3dContainer, ConfirmModal])
			var confirm_response:Dictionary = await ConfirmModal.user_response
			match confirm_response.action:
				ACTION.BACK:
					current_shop_step = SHOP_STEPS.START
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.FINALIZE_PURCHASE_BASE_ITEM
		# ---------------
		SHOP_STEPS.CONFIRM_BUILD:
			ConfirmModal.set_text("Confirm location?")
			await show_only([Structure3dContainer, ConfirmModal])			
			var confirm_response:Dictionary = await ConfirmModal.user_response			
			match confirm_response.action:
				ACTION.BACK:
					current_shop_step = SHOP_STEPS.PLACEMENT
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.FINALIZE_PURCHASE_BUILD
					
		# ---------------
		SHOP_STEPS.FINALIZE_PURCHASE_BUILD:
			var purchase_item_data:Dictionary = ROOM_UTIL.return_data(selected_shop_item.ref)
			action_queue_data.push_back({
				"action": ACTION.AQ.BUILD_ITEM,
				"data": selected_shop_item,
				"days_in_queue": 0,
				"build_time": purchase_item_data.get_build_time.call() if "get_build_time" in purchase_item_data else 0,
				"location": current_location.duplicate(),
			})
			
			SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(selected_shop_item.ref, resources_data)
			SUBSCRIBE.action_queue_data = action_queue_data
			current_shop_step = SHOP_STEPS.HIDE
		# ---------------
		SHOP_STEPS.FINALIZE_PURCHASE_RESEARCH:
			var purchase_item_data:Dictionary = RD_UTIL.return_data(selected_shop_item.ref)

			action_queue_data.push_back({
				"action": ACTION.AQ.RESEARCH_ITEM,
				"data": selected_shop_item,
				"days_in_queue": 0,
				"build_time": purchase_item_data.get_build_time.call() if "get_build_time" in purchase_item_data else 0,
			})
			
			SUBSCRIBE.resources_data = RD_UTIL.calculate_purchase_cost(selected_shop_item.ref, resources_data)
			SUBSCRIBE.action_queue_data = action_queue_data
			current_shop_step = SHOP_STEPS.HIDE			
		# ---------------
		SHOP_STEPS.FINALIZE_PURCHASE_BASE_ITEM:
			var purchased_item_data:Dictionary = BASE_UTIL.return_data(selected_shop_item.ref)

			action_queue_data.push_back({
				"action": ACTION.AQ.BASE_ITEM,
				"data": selected_shop_item,
				"days_in_queue": 0,
				"build_time": purchased_item_data.get_build_time.call() if "get_build_time" in purchased_item_data else 0,
			})
			
			SUBSCRIBE.resources_data = BASE_UTIL.calculate_purchase_cost(selected_shop_item.ref, resources_data)
			SUBSCRIBE.action_queue_data = action_queue_data
			current_shop_step = SHOP_STEPS.HIDE
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
			current_shop_step = SHOP_STEPS.HIDE
		# ---------------
		SHOP_STEPS.REFUND:
			match selected_refund_item.action:
				ACTION.AQ.CONTAIN:
					ConfirmModal.set_text("Cancel containment?", "There are no costs for this action.")
				ACTION.AQ.TRANSFER:
					ConfirmModal.set_text("Cancel transfer?", "There are no costs for this action.")					
				ACTION.AQ.BUILD_ITEM:
					ConfirmModal.set_text("Cancel build?", "Resources will be refunded.")
				ACTION.AQ.RESEARCH_ITEM:
					ConfirmModal.set_text("Cancel research?", "Resources will be refunded.")
				ACTION.AQ.BASE_ITEM:
					ConfirmModal.set_text("Cancel construction?", "Resources will be refunded.")
			await show_only([ActionQueueContainer, ConfirmModal])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.NEXT:
					match selected_refund_item.action:
						ACTION.AQ.CONTAIN:
							cancel_scp_containment(selected_refund_item)
						ACTION.AQ.TRANSFER:
							cancel_scp_transfer(selected_refund_item)
						ACTION.AQ.BUILD_ITEM:
							SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(selected_refund_item.data.ref, resources_data, false)
							SUBSCRIBE.action_queue_data = action_queue_data.filter(func(i): return i.data.uid != selected_refund_item.data.uid)
							ActionQueueContainer.remove_from_queue([selected_refund_item])
						ACTION.AQ.RESEARCH_ITEM:
							SUBSCRIBE.resources_data = RD_UTIL.calculate_resources(selected_refund_item.data.ref, resources_data, false)
							SUBSCRIBE.action_queue_data = action_queue_data.filter(func(i): return i.data.uid != selected_refund_item.data.uid)
							ActionQueueContainer.remove_from_queue([selected_refund_item])
						ACTION.AQ.BASE_ITEM:
							SUBSCRIBE.resources_data = BASE_UTIL.calculate_resources(selected_refund_item.data.ref, resources_data, false)
							SUBSCRIBE.action_queue_data = action_queue_data.filter(func(i): return i.data.uid != selected_refund_item.data.uid)
							ActionQueueContainer.remove_from_queue([selected_refund_item])

					selected_refund_item = {}
					
			current_shop_step = SHOP_STEPS.HIDE
			await restore_default_state()
					
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	CONTAIN STEPS
#region CONTAIN STEPS
func on_current_contain_step_update() -> void:
	if !is_node_ready() and !Engine.is_editor_hint():return
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
					ResearchersContainer.assign_only = true
					await show_only([ResearchersContainer])
					var res:Dictionary = await ResearchersContainer.user_response
					match res.action:
						ACTION.RESEARCHERS.BACK:
							current_contain_step = CONTAIN_STEPS.START
						ACTION.RESEARCHERS.SELECT_FOR_ASSIGN:
							selected_researcher_item = res.data
							# store selected researcher id 
							current_contain_step = CONTAIN_STEPS.CONFIRM_RESEARCHER
				# --------------------
				ACTION.CONTAINED.UNASSIGN_RESEARCHER:
					current_contain_step = CONTAIN_STEPS.CONFIRM_REMOVE_RESEARCHER
				# --------------------
				ACTION.CONTAINED.START_TESTING:
					await check_events(response.data.ref, SCP.EVENT_TYPE.START_TESTING, true)
					print("AFTER TESTING ENDS...")
					current_contain_step = CONTAIN_STEPS.HIDE
				_:
					print("action missing")
					current_contain_step = CONTAIN_STEPS.HIDE
		# ---------------
		CONTAIN_STEPS.CONFIRM_RESEARCHER:
			ConfirmModal.set_text("Make %s lead researcher for SCP-%s?" % [selected_researcher_item.details.name, selected_contain_item.item_id])
			await show_only([ConfirmModal])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.BACK:
					current_contain_step = CONTAIN_STEPS.START
				ACTION.NEXT:
					assign_researcher_to_scp(selected_researcher_item, selected_contain_item)
					current_contain_step = CONTAIN_STEPS.START
		# ---------------
		CONTAIN_STEPS.CONFIRM_REMOVE_RESEARCHER:
			ConfirmModal.set_text("Remove researcher from SCP-%s?" % [selected_contain_item.item_id])
			await show_only([ConfirmModal])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.BACK:
					current_contain_step = CONTAIN_STEPS.START
				ACTION.NEXT:
					unassign_researcher_to_scp(selected_contain_item)
					current_contain_step = CONTAIN_STEPS.START
		# ---------------
		CONTAIN_STEPS.PLACEMENT:
			await show_only([Structure3dContainer, RoomStatusContainer])			
			SUBSCRIBE.unavailable_rooms = SCP_UTIL.return_unavailable_rooms(selected_contain_item.ref, room_config, scp_data)
			
			Structure3dContainer.select_location()
			Structure3dContainer.placement_instructions = [] #ROOM_UTIL.return_placement_instructions(selected_shop_item.id)
			
			var structure_response:Dictionary = await Structure3dContainer.user_response
			Structure3dContainer.placement_instructions = []
			
			match structure_response.action:
				ACTION.BACK:					
					SUBSCRIBE.camera_settings = camera_settings
					SUBSCRIBE.unavailable_rooms = []
					current_contain_step = CONTAIN_STEPS.START
				ACTION.NEXT:
					SUBSCRIBE.camera_settings = camera_settings
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
					var action_queue_item:Dictionary = action_queue_data.filter(func(i): return i.data.ref == selected_contain_item.ref)[0]
					cancel_scp_containment(action_queue_item)
					scp_data.available_list = scp_data.available_list.filter(func(i):return i.ref != selected_contain_item.ref)
					SUBSCRIBE.scp_data = scp_data
					current_contain_step = CONTAIN_STEPS.START
		# ---------------
		CONTAIN_STEPS.ON_TRANSFER_CANCEL:
			ConfirmModal.set_text("Cancel containment?" if selected_contain_item.is_new_transfer else "Cancel transfer?")
			await show_only([ConfirmModal])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.BACK:
					current_contain_step = CONTAIN_STEPS.START
				ACTION.NEXT:
					var action_queue_item:Dictionary = action_queue_data.filter(func(i): return i.data.ref == selected_contain_item.ref)[0]
					if selected_contain_item.is_new_transfer:
						cancel_scp_containment(action_queue_item)
					else:
						cancel_scp_transfer(action_queue_item)
					current_contain_step = CONTAIN_STEPS.START
		# ---------------
		CONTAIN_STEPS.ON_TRANSFER_TO_NEW_LOCATION:
			await show_only([Structure3dContainer, RoomStatusContainer])
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
			selected_contain_item.uid = U.generate_uid()
			
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

			action_queue_data.push_back({
				"action": ACTION.AQ.CONTAIN if selected_contain_item.is_new_transfer else ACTION.AQ.TRANSFER,
				"data": selected_contain_item,
				"days_in_queue": 0,
				"build_time": scp_details.containment_time.call(),
				"location": current_location.duplicate(),
				"note": "CONTAINMENT IN PROGRESS" if selected_contain_item.is_new_transfer else "TRANSFER IN PROGRESS"
			})
			
			SUBSCRIBE.action_queue_data = action_queue_data
			SUBSCRIBE.scp_data = scp_data

			current_contain_step = CONTAIN_STEPS.START	
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	RECRUIT STEPS
#region RECRUIT STEPS
func on_current_recruit_step_update() -> void:
	if !is_node_ready() and !Engine.is_editor_hint():return

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
			await show_only([ResourceContainer, RecruitmentContainer, ActionQueueContainer, RoomStatusContainer])
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
#region BUILD COMPLETE
func on_current_build_complete_step_update() -> void:
	if !is_node_ready() and !Engine.is_editor_hint():return

	match current_build_complete_step:
		# ---------------
		BUILD_COMPLETE_STEPS.HIDE:
			SUBSCRIBE.suppress_click = false
			await restore_default_state()
		# ---------------
		BUILD_COMPLETE_STEPS.START:
			SUBSCRIBE.suppress_click = true
			revert_state_location = current_location
			BuildCompleteContainer.completed_build_items = completed_build_items
			await show_only([Structure3dContainer, ResourceContainer, BuildCompleteContainer])
			var response:Dictionary = await BuildCompleteContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.DONE:
					current_build_complete_step = BUILD_COMPLETE_STEPS.HIDE
				ACTION.SKIP:
					current_build_complete_step = BUILD_COMPLETE_STEPS.HIDE
			
			current_location = revert_state_location
			
			# REMOVES FROM QUEUE LIST
			await ActionQueueContainer.remove_from_queue(completed_build_items)
			
			# resets event_data 
			var event_data_arr:Array = []
		
			# UPDATE SAVABLE DATA
			for item in completed_build_items:
				match item.action:
					# ----------------------------
					ACTION.AQ.CONTAIN:
						# first, remove from available list...
						scp_data.available_list = scp_data.available_list.filter(func(i):return i.ref != item.data.ref)
						# then add to contained list...
						var new_contained_item:Dictionary = { 
							"ref": item.data.ref,
							"unlocked": [],
							"location": item.location,
							"days_in_containment": 0,
							"lead_researcher": {},
							"event_type_count": {
								#["type/event_id"]: count[int]
							},
							"current_activity": {},
							"transfer_status": {
								"state": false, 
								"days_till_complete": -1,
								"location": {}
							}	
						}
						scp_data.contained_list.push_back(new_contained_item)

						SUBSCRIBE.resources_data = SCP_UTIL.calculate_initial_containment_bonus(item.data.ref, resources_data)
						SUBSCRIBE.scp_data = scp_data

						await check_events(item.data.ref, SCP.EVENT_TYPE.AFTER_CONTAINMENT)
					# ----------------------------
					ACTION.AQ.TRANSFER:
						scp_data.contained_list = scp_data.contained_list.map(func(i):
							if i.ref == item.data.ref:
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
						
						await check_events(item.data.ref, SCP.EVENT_TYPE.AFTER_TRANSFER)
					# ----------------------------
					ACTION.AQ.BASE_ITEM:
						purchased_base_arr.push_back({
							"data": item.data,
						})
						# update resources_data
						SUBSCRIBE.resources_data = BASE_UTIL.calculate_build_complete(item.data.id, resources_data)
						SUBSCRIBE.purchased_base_arr = purchased_base_arr
					# ----------------------------	
					ACTION.AQ.BUILD_ITEM:
						purchased_facility_arr.push_back({
							"data": item.data,
							"location": item.location
						})
						# update resources_data
						SUBSCRIBE.resources_data = ROOM_UTIL.calculate_build_complete(item.data.ref, resources_data)
						SUBSCRIBE.purchased_facility_arr = purchased_facility_arr
					# ----------------------------
					ACTION.AQ.RESEARCH_ITEM:
						purchased_research_arr.push_back({
							"data": item.data
						})
						SUBSCRIBE.purchased_research_arr = purchased_research_arr


			# update reactively
			SUBSCRIBE.resources_data = resources_data	
			

			completed_build_items = []
			on_complete_build_complete.emit()
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
#region BUILD COMPLETE
func on_current_event_step_update() -> void:
	if !is_node_ready() and !Engine.is_editor_hint():return

	match current_event_step:
		EVENT_STEPS.RESET:
			SUBSCRIBE.suppress_click = false
			await restore_default_state()
		EVENT_STEPS.START:
			SUBSCRIBE.suppress_click = true
			await show_only([EventContainer])
			EventContainer.event_data = event_data
			EventContainer.start()
			await EventContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			# reset and evempty event_data
			event_data = []
			current_event_step = EVENT_STEPS.RESET
			await U.set_timeout(0.5)
			# trigger signal
			on_events_complete.emit()
			
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
		RESEARCHERS_STEPS.START:
			SUBSCRIBE.suppress_click = true
			ResearchersContainer.assign_only = false
			await show_only([ResearchersContainer])
			var response:Dictionary = await ResearchersContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.RESEARCHERS.BACK:
					current_researcher_step = RESEARCHERS_STEPS.RESET

#endregion
# ------------------------------------------------------------------------------		


# ------------------------------------------------------------------------------	
func on_expired_scp_items_update() -> void:
	pass
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	CONTROLS
#region CONTROL UPDATE
func is_occupied() -> bool:
	if is_busy or processing_next_day or GBL.has_animation_in_queue():
		return true
	if (current_shop_step != SHOP_STEPS.HIDE) or (current_contain_step != CONTAIN_STEPS.HIDE) or (current_recruit_step != RECRUIT_STEPS.HIDE) or (current_build_complete_step != BUILD_COMPLETE_STEPS.HIDE) or (current_event_step != EVENT_STEPS.RESET):
		return true
	return false

func on_mouse_scroll(dir:int) -> void:
	if is_occupied() or camera_settings.is_locked:return
	match dir:
		0: #UP
			if camera_settings.zoom - 1 >= 0:
				camera_settings.zoom = camera_settings.zoom - 1
		1: #DOWN
			if camera_settings.zoom + 1 < CAMERA.ZOOM.size():
				camera_settings.zoom = camera_settings.zoom + 1
				
	SUBSCRIBE.camera_settings = camera_settings
	
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
		"progress_data": progress_data,		
		"scp_data": scp_data,
		"action_queue_data": action_queue_data,
		"purchased_base_arr": purchased_base_arr,
		"purchased_facility_arr": purchased_facility_arr,
		"purchased_research_arr": purchased_research_arr,
		"hired_lead_researchers_arr": hired_lead_researchers_arr,
		"resources_data": resources_data,
		"current_location": current_location,
		"bookmarked_rooms": bookmarked_rooms,
		"researcher_hire_list": researcher_hire_list,
		"tier_unlocked": tier_unlocked,
		"unavailable_rooms": unavailable_rooms, 
		"camera_settings": camera_settings
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
	SUBSCRIBE.current_location = initial_values.current_location if no_save else restore_data.current_location
	SUBSCRIBE.tier_unlocked = initial_values.tier_unlocked if no_save else restore_data.tier_unlocked
	SUBSCRIBE.camera_settings = initial_values.camera_settings if no_save else restore_data.camera_settings	
	SUBSCRIBE.unavailable_rooms = initial_values.unavailable_rooms if no_save else restore_data.unavailable_rooms

	# comes after purchased_research_arr, fix this later
	SUBSCRIBE.hired_lead_researchers_arr = initial_values.hired_lead_researchers_arr if no_save else restore_data.hired_lead_researchers_arr

	goto_location(initial_values.current_location)
#endregion		
# ------------------------------------------------------------------------------
