@tool
extends PanelContainer

enum SHOP_STEPS {HIDE, START, SHOW, PLACEMENT, CONFIRM_LOCATION, CONFIRM, FINALIZE, REFUND}
enum CONTAIN_STEPS {HIDE, START, SHOW, CONFIRM_LOCATION, CONFIRM, FINALIZE}
enum RECRUIT_STEPS {HIDE, START, SHOW, CONFIRM_LOCATION, CONFIRM, FINALIZE}
enum BUILD_COMPLETE_STEPS {HIDE, START, FINALIZE}

@onready var Structure3dContainer:Control = $Structure3DContainer
@onready var LocationContainer:MarginContainer = $LocationContainer
@onready var ActionQueueContainer:MarginContainer = $ActionQueueContainer
@onready var RoomStatusContainer:MarginContainer = $RoomStatusContainer
@onready var ActionContainer:MarginContainer = $ActionContainer
@onready var ResourceContainer:MarginContainer = $ResourceContainer
@onready var DialogueContainer:MarginContainer = $DialogueContainer
@onready var StoreContainer:MarginContainer = $StoreContainer
@onready var ItemSelectContainer:MarginContainer = $ItemSelectContainer
@onready var RecruitContainer:MarginContainer = $RecruitContainer
@onready var StatusContainer:MarginContainer = $StatusContainer
@onready var BuildCompleteContainer:MarginContainer = $BuildCompleteContainer

@onready var ConfirmModal:MarginContainer = $ConfirmModal
@onready var WaitContainer:PanelContainer = $WaitContainer

@onready var TestPoint:PanelContainer = $Control/TestPoint

# ------------------------------------------------------------------------------	EXPORT VARS
#region EXPORT VARS
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

@export var show_item_select:bool = false : 
	set(val):
		show_item_select = val
		on_show_item_select_update()
		
@export var show_confirm_modal:bool = false : 
	set(val):
		show_confirm_modal = val
		on_show_confirm_modal_update()
		
@export var show_status:bool = false : 
	set(val):
		show_status = val
		on_show_status_update()

@export var show_build_complete:bool = false : 
	set(val):
		show_build_complete = val
		on_show_build_complete_update()
#endregion
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------ 
#region SAVABLE DATA
var current_location:Dictionary = {} : 
	set(val):
		current_location = val
		on_current_location_update()
		
var progress_data:Dictionary = { 
		"day": 1,
	} : 
	set( val ) : 
		progress_data = val
		on_progress_data_update()
		
var action_queue_data:Array = [] : 
	set( val ) : 
		action_queue_data = val
		on_action_queue_data_update()

var facility_room_data:Array = [] : 
	set( val ):
		facility_room_data = val
		on_facility_room_data_update()

var lead_researchers_data:Array = [
	{
		"name": "Dr. Doctor",
		"motivation": 0, 
		"image_src": "res://Media/images/example_doctor.jpg",
		"specialization": [
			RESEARCHER.SPECALIZATION.ENGINEERING
		],
		"traits": [
			RESEARCHER.TRAIT.MOTIVATED
		]
	},
		{
		"name": "Dr. Bright",
		"motivation": 0, 
		"image_src": "res://Media/images/example_doctor.jpg",
		"specialization": [
			RESEARCHER.SPECALIZATION.ENGINEERING
		],
		"traits": [
			RESEARCHER.TRAIT.MOTIVATED
		]
	}
] : 
	set( val ):
		lead_researchers_data = val
		on_lead_researchers_data_update()

var resources_data:Dictionary = { 
	RESOURCE.TYPE.MONEY: {"amount": 10, "capacity": 9999},
	RESOURCE.TYPE.ENERGY: {"amount": 25, "capacity": 28},
	RESOURCE.TYPE.LEAD_RESEARCHERS: {"amount": 0, "capacity": 0},
	RESOURCE.TYPE.STAFF: {"amount": 0, "capacity": 0},
	RESOURCE.TYPE.SECURITY: {"amount": 0, "capacity": 0},
	RESOURCE.TYPE.DCLASS: {"amount": 0, "capacity": 0},
} : 
	set(val): 
		resources_data = val
		on_resources_data_update()

#endregion
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------	LOCAL DATA
#region LOCAL DATA
var is_busy:bool = false : 
	set(val):
		is_busy = val
		on_is_busy_update()

var selected_shop_item:Dictionary = {}
var completed_build_items:Array = [] : 
	set(val):
		completed_build_items = val
		on_completed_build_items_update()

var showing_states:Dictionary = {} 
var revert_state_location:Dictionary = {}

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

var current_camera_zoom:CAMERA.ZOOM = CAMERA.ZOOM.OVERVIEW : 
	set(val):
		current_camera_zoom = val
		on_current_camera_zoom_update()

var room_config:Dictionary = {
	"floor": {
		0: get_ring_default(),
		1: get_ring_default(),
		2: get_ring_default(),
		3: get_ring_default(),
		4: get_ring_default(),
		5: get_ring_default(),
	}
} : 
	set(val) : 
		room_config = val
		on_room_config_update()

var bookmarked_rooms:Array = ["001", "005", "003"] : # ["000", "201"] <- "floor_index, ring_index, room_index"]
	set(val):
		bookmarked_rooms = val
		on_bookmarked_rooms_update()

func get_ring_default() -> Dictionary:
	return { 
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
			5: get_room_item_default()
		}
	}

func get_room_item_default() -> Dictionary:
	return {
		"build_data": {},
		"room_data": {},
		"item_data": {}
	}
		
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	LIFECYCLE
#region LIFECYCLE
func _init() -> void:
	GBL.register_node(REFS.GAMEPLAY_LOOP, self)
	GBL.subscribe_to_mouse_input(self)
	GBL.subscribe_to_control_input(self)
	
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.GAMEPLAY_LOOP)
	GBL.unsubscribe_to_mouse_input(self)
	GBL.unsubscribe_to_control_input(self)

	
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
	on_show_item_select_update()
	on_show_recruit_update()
	on_show_status_update()
	on_show_build_complete_update()
	
	# savable data update
	on_progress_data_update()
	on_action_queue_data_update()	
	on_resources_data_update()
	on_facility_room_data_update()

	
	# other
	on_show_confirm_modal_update()
	on_is_busy_update()
	on_current_camera_zoom_update()
	on_bookmarked_rooms_update()
	
	# steps
	on_show_store_update()
	on_current_shop_step_update()
	
	# get default showing state
	capture_default_showing_state()
		
	LocationContainer.onRoomSelected = func(data:Dictionary) -> void:
		current_location = data

		
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

# ------------------------------------------------------------------------------	SHOW/HIDE CONTAINERS
#region show/hide functions
func on_is_busy_update() -> void:
	WaitContainer.show() if is_busy else WaitContainer.hide()

func get_all_container_nodes(exclude:Array = []) -> Array:
	return [
		Structure3dContainer, LocationContainer, ActionQueueContainer, 
		RoomStatusContainer, ActionContainer, ResourceContainer, 
		DialogueContainer, StoreContainer, ItemSelectContainer, 
		ConfirmModal, RecruitContainer, StatusContainer,
		BuildCompleteContainer
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
func wait_please(duration:float = 0.5) -> void:
	is_busy = true
	await U.set_timeout(duration)
	is_busy = false	

func next_day() -> void:
	await wait_please()
	
	# UPDATE THINGS IN THE ACTION QUEUE
	var temp:Array = action_queue_data.duplicate().map(func(i): 
		i.days_in_queue += 1
		return i
	)	
	# UPDATES ALL THINGS LEFT IN QUEUE THAT REQUIRES MORE TIME
	action_queue_data = temp.filter(func(i): return i.days_in_queue < i.build_time)	
	# ADDS TO COMPLETED BUILD ITEMS LIST IF THEY'RE DONE
	completed_build_items = temp.filter(func(i): return i.days_in_queue == i.build_time)
	
	progress_data.day += 1
	progress_data = progress_data
	
func cancel_action(item_data:Dictionary) -> void:
	match item_data.action:
		ACTION.BUILD:
			selected_shop_item = item_data
			current_shop_step = SHOP_STEPS.REFUND
			
func goto_location(location:Dictionary) -> void:
	LocationContainer.goto_location(location)
	
func set_room_config() -> void:
	for item in action_queue_data:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room		
		room_config.floor[floor].ring[ring].room[room].build_data = {
			"id": item.data.id,
			"get_room_data": func() -> Dictionary:
				return ROOM_UTIL.return_data(item.data.id)
		}
	
	for item in facility_room_data:
		var floor:int = item.location.floor
		var ring:int = item.location.ring
		var room:int = item.location.room
		room_config.floor[floor].ring[ring].room[room].room_data = {
			"id": item.data.id,
			"get_room_data": func() -> Dictionary:
				return ROOM_UTIL.return_data(item.data.id)
		}
		# if facility is built, clear build_data
		room_config.floor[floor].ring[ring].room[room].build_data = {}
	room_config = room_config	
	
func on_current_camera_zoom_update() -> void:
	if !is_node_ready():return
	for node in [Structure3dContainer]:
		node.current_camera_zoom = current_camera_zoom
#endregion
# ------------------------------------------------------------------------------	

#region LOCAL UPDATES
# ------------------------------------------------------------------------------	LOCAL ON_UPDATES
func on_room_config_update() -> void:
	if !is_node_ready():return
	for node in get_all_container_nodes():
		node.room_config = room_config
# ------------------------------------------------------------------------------	SAVABLE ON_UPDATES	
#endregion

# ------------------------------------------------------------------------------	SAVABLE ON_UPDATES
#region local SAVABLE ONUPDATES
func on_progress_data_update() -> void:
	if !is_node_ready():return
	for node in get_all_container_nodes():
		node.progress_data = progress_data

func on_facility_room_data_update() -> void:
	if !is_node_ready():return
	# updates room data dictionary
	set_room_config()
	# then update nodes
	for node in get_all_container_nodes():
		node.facility_room_data = facility_room_data

func on_action_queue_data_update() -> void:
	if !is_node_ready():return
	set_room_config()	
	for node in get_all_container_nodes():
		node.action_queue_data = action_queue_data	

func on_resources_data_update() -> void:
	if !is_node_ready(): return
	for node in get_all_container_nodes():
		node.resources_data = resources_data		
	
func on_completed_build_items_update() -> void:
	if !is_node_ready() or completed_build_items.is_empty(): return
	current_build_complete_step = BUILD_COMPLETE_STEPS.START

func on_lead_researchers_data_update() -> void:
	if !is_node_ready(): return
	for node in get_all_container_nodes():
		node.lead_researchers_data = lead_researchers_data	
		
	resources_data[RESOURCE.TYPE.LEAD_RESEARCHERS] = {
		"amount": lead_researchers_data.size() 
	} 
	
	resources_data = resources_data

func on_current_location_update() -> void:
	if !is_node_ready(): return
	for node in get_all_container_nodes():
		node.current_location = current_location
		
func on_bookmarked_rooms_update() -> void:
	if !is_node_ready(): return
	for node in get_all_container_nodes():
		node.bookmarked_rooms = bookmarked_rooms
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

func on_show_item_select_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ItemSelectContainer.is_showing = show_item_select
		showing_states[ItemSelectContainer] = show_item_select

func on_show_confirm_modal_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ConfirmModal.is_showing = show_confirm_modal
		showing_states[ConfirmModal] = show_confirm_modal

func on_show_recruit_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		RecruitContainer.is_showing = show_recruit
		showing_states[RecruitContainer] = show_recruit

func on_show_status_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		StatusContainer.is_showing = show_status
		showing_states[StatusContainer] = show_status

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
			await restore_default_state()
			StoreContainer.end()
		# ---------------
		SHOP_STEPS.START:
			selected_shop_item = {}
			StoreContainer.start()
			await show_only([ResourceContainer, StoreContainer, ActionQueueContainer, LocationContainer, RoomStatusContainer])
			var response:Dictionary = await StoreContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.BACK:
					current_shop_step = SHOP_STEPS.HIDE
					
				ACTION.NEXT:
					selected_shop_item = response.selected
					current_shop_step = SHOP_STEPS.PLACEMENT
		# ---------------
		SHOP_STEPS.PLACEMENT:
			await show_only([LocationContainer, Structure3dContainer, RoomStatusContainer])
			var structure_response = await Structure3dContainer.user_response
			match structure_response.action:
				ACTION.BACK:
					current_shop_step = SHOP_STEPS.START
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.CONFIRM_LOCATION
		# ---------------
		SHOP_STEPS.CONFIRM_LOCATION:
			ConfirmModal.set_text("Confirm location?")
			await show_only([LocationContainer, Structure3dContainer, ConfirmModal])			
			var confirm_response:Dictionary = await ConfirmModal.user_response			
			match confirm_response.action:
				ACTION.BACK:
					current_shop_step = SHOP_STEPS.START
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.FINALIZE
		# ---------------
		SHOP_STEPS.FINALIZE:
			var room_data:Dictionary = ROOM_UTIL.return_data(selected_shop_item.id)
			action_queue_data.push_back({
				"action": ACTION.BUILD,
				"data": selected_shop_item,
				"days_in_queue": 0,
				"build_time": room_data.get_build_time.call() if "get_build_time" in room_data else 0,
				"location": current_location,
			})
			resources_data = ROOM_UTIL.calc_build_cost(selected_shop_item.id, resources_data)
			action_queue_data = action_queue_data
			current_shop_step = SHOP_STEPS.HIDE
		SHOP_STEPS.REFUND:			
			ConfirmModal.set_text("Cancel action?", "Resources will be refunded.")
			await show_only([ActionQueueContainer, ConfirmModal])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.NEXT:					
					resources_data = ROOM_UTIL.calc_build_cost(selected_shop_item.data.id, resources_data, true)
					action_queue_data = action_queue_data.filter(func(i): return i.data.uid != selected_shop_item.data.uid)
					ActionQueueContainer.remove_from_queue([selected_shop_item])
					current_shop_step = SHOP_STEPS.HIDE
					await restore_default_state()
				ACTION.BACK:
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
			await restore_default_state()
		# ---------------
		CONTAIN_STEPS.START:
			await show_only([ResourceContainer, ItemSelectContainer, ActionQueueContainer, RoomStatusContainer])
			var response:Dictionary = await ItemSelectContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.BACK:
					current_contain_step = CONTAIN_STEPS.HIDE
				ACTION.NEXT:
					current_contain_step = CONTAIN_STEPS.CONFIRM_LOCATION
		# ---------------
		CONTAIN_STEPS.CONFIRM_LOCATION:
			await show_only([LocationContainer, ConfirmModal])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.BACK:
					current_contain_step = CONTAIN_STEPS.START
				ACTION.NEXT:
					current_contain_step = CONTAIN_STEPS.FINALIZE
		# ---------------
		CONTAIN_STEPS.FINALIZE:
			# do something with data
			current_contain_step = CONTAIN_STEPS.HIDE	
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	RECRUIT STEPS
#region RECRUIT STEPS
func on_current_recruit_step_update() -> void:
	if !is_node_ready() and !Engine.is_editor_hint():return

	match current_recruit_step:
		# ---------------
		RECRUIT_STEPS.HIDE:
			await restore_default_state()
		# ---------------
		CONTAIN_STEPS.START:
			await show_only([ResourceContainer, RecruitContainer, ActionQueueContainer, RoomStatusContainer])
			var response:Dictionary = await RecruitContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.BACK:
					current_recruit_step = RECRUIT_STEPS.HIDE
				ACTION.NEXT:
					current_recruit_step = RECRUIT_STEPS.CONFIRM_LOCATION
		# ---------------
		RECRUIT_STEPS.CONFIRM_LOCATION:
			await show_only([LocationContainer, ConfirmModal])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.BACK:
					current_recruit_step = RECRUIT_STEPS.START
				ACTION.NEXT:
					current_recruit_step = RECRUIT_STEPS.FINALIZE
		# ---------------
		RECRUIT_STEPS.FINALIZE:
			# do something with data
			current_recruit_step = RECRUIT_STEPS.HIDE	
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	RECRUIT STEPS
#region BUILD COMPLETE
func on_current_build_complete_step_update() -> void:
	if !is_node_ready() and !Engine.is_editor_hint():return

	match current_build_complete_step:
		# ---------------
		RECRUIT_STEPS.HIDE:
			await restore_default_state()
		# ---------------
		CONTAIN_STEPS.START:
			revert_state_location = current_location
			BuildCompleteContainer.completed_build_items = completed_build_items
			await show_only([Structure3dContainer, ResourceContainer, LocationContainer, BuildCompleteContainer])
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
			
			# UPDATE SAVABLE DATA
			for item in completed_build_items:
				facility_room_data.push_back({
					"data": item.data,
					"location": item.location
				})
				
				# update resources_data
				resources_data = ROOM_UTIL.calc_resource_capacity(item.data.id, resources_data)
				resources_data = ROOM_UTIL.calc_resource_amount(item.data.id, resources_data)
			
			print(facility_room_data)
			
			# update reactively
			resources_data = resources_data	
			facility_room_data = facility_room_data
			completed_build_items = []
			
					
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	CONTROLS
#region CONTROL UPDATE
func is_occupied() -> bool:
	if (current_shop_step != SHOP_STEPS.HIDE) or (current_contain_step != CONTAIN_STEPS.HIDE) or (current_recruit_step != RECRUIT_STEPS.HIDE) or (current_build_complete_step != BUILD_COMPLETE_STEPS.HIDE):
		return true
	return false

func on_mouse_scroll(dir:int) -> void:
	if GBL.has_animation_in_queue():return
	
	match dir:
		0: #UP
			if current_camera_zoom - 1 >= 0:
				current_camera_zoom = current_camera_zoom - 1
		1: #DOWN
			if current_camera_zoom + 1 < CAMERA.ZOOM.size():
				current_camera_zoom = current_camera_zoom + 1
	

func on_control_input_update(input_data:Dictionary) -> void:
	if is_busy or is_occupied():return

	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	print("key: %s   keycode: %s" % [key, keycode])
	
	match key:
		"ENTER":
			print_orphan_nodes()
			
			next_day()
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
		"action_queue_data": action_queue_data,
		"facility_room_data": facility_room_data,
		"lead_researchers_data": lead_researchers_data,
		"resources_data": resources_data,
		"current_location": current_location,
		"bookmarked_rooms": bookmarked_rooms,
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
	await restore_default_state()
	
	# trigger on reset in nodes
	for node in get_all_container_nodes():
		if "on_reset" in node:
			node.on_reset()
	
	progress_data = progress_data if no_save else restore_data.progress_data
	action_queue_data = action_queue_data if no_save else restore_data.action_queue_data	
	facility_room_data = action_queue_data if no_save else restore_data.facility_room_data  
	resources_data = action_queue_data if no_save else restore_data.resources_data	
	bookmarked_rooms = bookmarked_rooms #if no_save else restore_data.bookmarked_rooms
	# comes after research data, fix this later
	lead_researchers_data = lead_researchers_data if no_save else restore_data.lead_researchers_data
	current_location = action_queue_data if no_save else restore_data.current_location
	
	goto_location(current_location)
#endregion		
# ------------------------------------------------------------------------------
