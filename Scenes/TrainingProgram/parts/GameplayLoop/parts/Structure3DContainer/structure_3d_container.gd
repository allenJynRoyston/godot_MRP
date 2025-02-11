@tool
extends GameContainer

@onready var SelectLocationInstructions:VBoxContainer = $PanelContainer/MarginContainer/SelectLocationInstructions
@onready var PlacementInstructions:VBoxContainer = $PanelContainer/MarginContainer/PlacementInstructions
@onready var Rendering:Node3D = $SubViewport/Rendering

enum STEPS { SELECT_FLOOR, SELECT_ROOM, SELECT_PLACEMENT }
enum DIR {UP, DOWN, LEFT, RIGHT}

const CheckboxPreload:PackedScene = preload("res://UI/Buttons/Checkbox/checkbox.tscn")

var floating_node_refs:Dictionary = {}
var bookmarked_node_refs:Dictionary = {}
var tracking_nodes:Array = []
var unavailable_rooms:Array = []
var active_designation:String = ""

var placement_instructions:Array = [] : 
	set(val):
		placement_instructions = val
		on_placement_instructions_update()
		
var current_step:STEPS = STEPS.SELECT_FLOOR : 
	set(val):
		current_step = val
		on_current_step_update()
		
var location_pos:Vector2 = Vector2(0, 0)
var freeze_input:bool = false

signal wait_for_input

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.STRUCTURE_3D, self)
	GBL.subscribe_to_process(self)
	SUBSCRIBE.subscribe_to_unavailable_rooms(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	

func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.STRUCTURE_3D)
	GBL.unsubscribe_to_process(self)
	SUBSCRIBE.unsubscribe_to_unavailable_rooms(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)
	
func _ready() -> void:
	super._ready()
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	on_placement_instructions_update()
	on_current_step_update()
	
	after_ready.call_deferred()

func after_ready() -> void:
	await U.set_timeout(0.5)
	on_current_location_update.call_deferred()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func traverse(callback:Callable) -> void:
	for floor_index in room_config.floor:
		for ring_index in room_config.floor[floor_index].ring:
			for room_index in room_config.floor[floor_index].ring[ring_index].room:	
				callback.call("%s%s%s" % [floor_index, ring_index, room_index], floor_index, ring_index, room_index)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_unavailable_rooms_update(new_val:Array = unavailable_rooms) -> void:
	unavailable_rooms = new_val
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func select_location(state:bool) -> void:
	if state:
		#SelectLocationInstructions.show()	
		freeze_input = false
		Rendering.RoomNode.show_menu = false
		current_step = STEPS.SELECT_PLACEMENT
	else:
		current_step = STEPS.SELECT_ROOM
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready():return
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func on_placement_instructions_update() -> void:
	if !is_node_ready():return
	for child in PlacementInstructions.get_children():
		child.queue_free()
	
	for item in placement_instructions:
		var new_checkbox:Control = CheckboxPreload.instantiate()
		new_checkbox.title = item.title
		new_checkbox.onCondition = item.is_checked
		new_checkbox.on_condition_check(current_location)
		PlacementInstructions.add_child(new_checkbox)
	
	PlacementInstructions.show() if placement_instructions.size() > 0 else PlacementInstructions.hide()
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	active_designation = "%s%s%s" % [current_location.floor, current_location.ring, current_location.room]

	for child in PlacementInstructions.get_children():
		child.on_condition_check(current_location)
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func location_lookup(val:int, dir:DIR) -> int:
	match val:
		0:
			match dir:
				DIR.UP: return -1
				DIR.DOWN: return 4
				DIR.LEFT: return 1
				DIR.RIGHT: return 2
		1:
			match dir:
				DIR.UP: return 0
				DIR.DOWN: return 6
				DIR.LEFT: return 3
				DIR.RIGHT: return 2
		2:
			match dir:
				DIR.UP: return 0
				DIR.DOWN: return 7
				DIR.LEFT: return 1
				DIR.RIGHT: return 5	
		3:
			match dir:
				DIR.UP: return 1
				DIR.DOWN: return 6
				DIR.LEFT: return -1
				DIR.RIGHT: return 4
		4:
			match dir:
				DIR.UP: return 0
				DIR.DOWN: return 8
				DIR.LEFT: return 3
				DIR.RIGHT: return 5
		5:
			match dir:
				DIR.UP: return 2
				DIR.DOWN: return 7
				DIR.LEFT: return 4
				DIR.RIGHT: return -1
		6:
			match dir:
				DIR.UP: return 1
				DIR.DOWN: return 8
				DIR.LEFT: return 3
				DIR.RIGHT: return 7
		7:
			match dir:
				DIR.UP: return 2
				DIR.DOWN: return 8
				DIR.LEFT: return 6
				DIR.RIGHT: return 5
		8:
			match dir:
				DIR.UP: return 4
				DIR.DOWN: return -1
				DIR.LEFT: return 6
				DIR.RIGHT: return 7
	
	return val
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func on_current_step_update() -> void:
	if !is_node_ready() or camera_settings.is_empty():return
	match current_step:
		# ------------------------------------------------
		STEPS.SELECT_FLOOR:
			camera_settings.type = CAMERA.TYPE.FLOOR_SELECT
			SUBSCRIBE.camera_settings = camera_settings
		# ------------------------------------------------
		STEPS.SELECT_ROOM:
			camera_settings.type = CAMERA.TYPE.ROOM_SELECT
			SUBSCRIBE.camera_settings = camera_settings
		# ------------------------------------------------	
		STEPS.SELECT_PLACEMENT:
			camera_settings.type = CAMERA.TYPE.ROOM_SELECT
			SUBSCRIBE.camera_settings = camera_settings
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:		
	if !is_visible_in_tree() or current_location.is_empty() or (GameplayNode.is_occupied() and current_step != STEPS.SELECT_PLACEMENT) or freeze_input: # GBL.has_animation_in_queue()
		return
		
	if Rendering.show_menu or Rendering.RoomNode.show_menu:
		return
	
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"W":
			match current_step:
				STEPS.SELECT_FLOOR:
					current_location.floor = clampi(current_location.floor - 1, 0, room_config.floor.size() - 1)
				STEPS.SELECT_ROOM:
					room_up()
				STEPS.SELECT_PLACEMENT:
					room_up()
		"S":
			match current_step:
				STEPS.SELECT_FLOOR:
					current_location.floor = clampi(current_location.floor + 1, 0, room_config.floor.size() - 1)
				STEPS.SELECT_ROOM:
					room_down()
				STEPS.SELECT_PLACEMENT:
					room_down()
		"D":
			match current_step:
				STEPS.SELECT_FLOOR:
					current_location.ring = clampi(current_location.ring + 1, 0, 3)
				STEPS.SELECT_ROOM:
					room_right()
				STEPS.SELECT_PLACEMENT:
					room_right()
				
			
		"A":
			match current_step:
				STEPS.SELECT_FLOOR:
					current_location.ring = clampi(current_location.ring - 1, 0, 3)				
				STEPS.SELECT_ROOM:
					room_left()
				STEPS.SELECT_PLACEMENT:
					room_left()	
					
		"TAB":
			if current_step != STEPS.SELECT_PLACEMENT:
				if current_step == STEPS.SELECT_FLOOR:
					current_step = STEPS.SELECT_ROOM
				elif current_step == STEPS.SELECT_ROOM:
					current_step = STEPS.SELECT_FLOOR
					
		"E":
			on_next()
			
		"B":
			on_back()
			
		"BACK":
			on_back()
			
	SUBSCRIBE.current_location = current_location
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
# TODO: 
func room_up() -> void:
	var room_index:int = location_lookup(current_location.room, DIR.UP)
	if room_index == -1:
		if current_location.floor - 1 >= 0:
			var next_val:int = clampi(current_location.floor - 1, 0, room_config.floor.size() - 1)
			current_location.floor = next_val
			current_location.room = 4
	else:
		current_location.room = room_index	
	SUBSCRIBE.current_location = current_location

func room_down() -> void:
	var room_index:int = location_lookup(current_location.room, DIR.DOWN)
	if room_index == -1:
		if current_location.floor + 1 < room_config.floor.size() - 1:
			var next_val:int = clampi(current_location.floor + 1, 0, room_config.floor.size() - 1)
			current_location.floor = next_val
			current_location.room = 4	
	else:
		current_location.room = room_index	
	SUBSCRIBE.current_location = current_location
		
func room_right() -> void:
	var room_index:int = location_lookup(current_location.room, DIR.RIGHT)
	if room_index == -1:
		if current_location.ring < room_config.floor[current_location.floor].ring.size() - 1:
			var next_val:int = clampi(current_location.ring + 1, 0, room_config.floor[current_location.floor].ring.size() - 1)
			current_location.ring = next_val
			current_location.room = 4	
	else:
		current_location.room = room_index	
	SUBSCRIBE.current_location = current_location

func room_left() -> void:
	var room_index:int = location_lookup(current_location.room, DIR.LEFT)
	if room_index == -1:
		if current_location.ring > 0:
			var next_val:int = clampi(current_location.ring - 1, 0, room_config.floor[current_location.floor].ring.size() - 1)
			current_location.ring = next_val
			current_location.room = 4
	else:
		current_location.room = room_index	
	SUBSCRIBE.current_location = current_location
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func wait_for_floor_response() -> void:
	Rendering.freeze_input = false
	freeze_input = false			

	var res:Dictionary = await Rendering.menu_response
	freeze_input = true
	Rendering.freeze_input = true
				
	match res.action:
		# -------------------
		ACTION.STRUCTURE.BACK:
			Rendering.show_menu = false
			Rendering.freeze_input = false
			freeze_input = false
			return
		# -------------------
		ACTION.STRUCTURE.GOTO_FLOOR:
			current_step = STEPS.SELECT_ROOM
			#Rendering.show_menu = false
			Rendering.freeze_input = false
			freeze_input = false			
			return
		# ------------------- 
		ACTION.STRUCTURE.LOCKDOWN:
			var in_lockdown:bool = !(room_config.floor[current_location.floor].in_lockdown)
			var response:Dictionary = await GameplayNode.set_floor_lockdown( current_location.duplicate(), in_lockdown )	
			if response.has_changes:
				Rendering.on_show_menu_update() # update menu if anything changed			

			wait_for_floor_response()			
		# ------------------- 
		ACTION.STRUCTURE.ACTIVATE_FLOOR:
			var response:Dictionary = await GameplayNode.activate_floor( current_location.duplicate() )	
			if response.has_changes:
				Rendering.on_show_menu_update() # update menu if anything changed			

			wait_for_floor_response()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func wait_for_room_node_response() -> void:
	var RoomNode:Control = Rendering.RoomNode
	RoomNode.freeze_input = false
	RoomNode.is_active = true
	freeze_input = true
	
	var res:Dictionary = await RoomNode.menu_response
	RoomNode.freeze_input = true
				
	match res.action:
		# -------------------
		ACTION.ROOM_NODE.BACK:
			RoomNode.show_menu = false
			RoomNode.is_active = false
			freeze_input = false
			return
		# -------------------
		
		# ------------------------------------------------------------------------------------------ ROOM STUFF
		# -------------------	
		ACTION.ROOM_NODE.OPEN_STORE:
			var response:Dictionary = await GameplayNode.construct_room(current_location.duplicate())
			if response.has_changes:
				RoomNode.on_show_menu_update() # update menu if anything changed
		# -------------------	
		ACTION.ROOM_NODE.CANCEL_CONSTRUCTION:
			var response:Dictionary = await GameplayNode.cancel_construction(current_location.duplicate())
			if response.has_changes:
				RoomNode.on_show_menu_update() # update menu if anything changed
		# -------------------	
		ACTION.ROOM_NODE.RESET_ROOM:
			var response:Dictionary = await GameplayNode.reset_room(current_location.duplicate())
			if response.has_changes:
				RoomNode.on_show_menu_update()
		# -------------------	
		ACTION.ROOM_NODE.ACTIVATE_ROOM:
			var response:Dictionary =  await GameplayNode.activate_room(current_location.duplicate(), res.room_details.ref, true)
			if response.has_changes:
				RoomNode.on_show_menu_update()
		# -------------------	
		ACTION.ROOM_NODE.DEACTIVATE_ROOM:
			var response:Dictionary = await await GameplayNode.activate_room(current_location.duplicate(), res.room_details.ref, false)			
			if response.has_changes:
				RoomNode.on_show_menu_update()
		# -------------------	
		
		# ------------------------------------------------------------------------------------------ RESEARCHER STUFF
		# -------------------	
		ACTION.ROOM_NODE.UNASSIGN_RESEARCHER:
			var response:Dictionary = await GameplayNode.unassign_researcher(res.researcher, res.room_details)		
			if response.has_changes:	
				RoomNode.on_show_menu_update() # update menu if anything changed
		# -------------------	
		ACTION.ROOM_NODE.ASSIGN_RESEARCHER:
			var response:Dictionary = await GameplayNode.assign_researcher(current_location.duplicate())
			if response.has_changes:
				RoomNode.on_show_menu_update() # update menu if anything changed
		# -------------------		
			
		# ------------------------------------------------------------------------------------------ SCP STUFF
		# -------------------	
		ACTION.ROOM_NODE.CONTAIN_SCP:
			var response:Dictionary = await GameplayNode.contain_scp(current_location.duplicate())
			if response.has_changes:
				RoomNode.on_show_menu_update()
		# -------------------	
		ACTION.ROOM_NODE.TRANSFER_SCP:
			var location_snapshot:Dictionary = current_location.duplicate()
			var menu_config:Dictionary = RoomNode.return_menu_config()
			var response:Dictionary = await GameplayNode.transfer_scp(current_location.duplicate())
			if response.has_changes:
				RoomNode.on_show_menu_update() 
			SUBSCRIBE.current_location = location_snapshot
			RoomNode.restore_menu_config(menu_config)
		# -------------------	
		ACTION.ROOM_NODE.CANCEL_CONTAIN_SCP:
			var response:Dictionary = await GameplayNode.contain_scp_cancel(current_location.duplicate(), ACTION.AQ.CONTAIN)
			if response.has_changes:
				RoomNode.on_show_menu_update() 
		# -------------------	
		ACTION.ROOM_NODE.CANCEL_TRANSFER_SCP:
			var response:Dictionary =  await GameplayNode.contain_scp_cancel(current_location.duplicate(), ACTION.AQ.TRANSFER)
			if response.has_changes:
				RoomNode.on_show_menu_update() 
		# -------------------	
		ACTION.ROOM_NODE.START_TESTING:
			# no response here
			await GameplayNode.set_scp_testing_state(current_location.duplicate(), true)
			RoomNode.on_show_menu_update() 
		# -------------------	
		ACTION.ROOM_NODE.STOP_TESTING:
			await GameplayNode.set_scp_testing_state(current_location.duplicate(), false)
			RoomNode.on_show_menu_update()
		# -------------------			
		ACTION.ROOM_NODE.SET_WING_MODE:
			# no response here
			var response:Dictionary = await GameplayNode.set_wing_emergency_mode(current_location.duplicate(), res.mode)
			if response.has_changes:
				RoomNode.on_show_menu_update() 		
		# -------------------	
		
	wait_for_room_node_response()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------

func goto_floor() -> void:
	current_step = STEPS.SELECT_ROOM	

# --------------------------------------------------------------------------------------------------
func on_next() -> void:
	match current_step:
		STEPS.SELECT_FLOOR:
			if !Rendering.show_menu:
				Rendering.show_menu = true
				wait_for_floor_response()
						
		STEPS.SELECT_ROOM:
			var RoomNode:Control = Rendering.RoomNode
			if !RoomNode.show_menu:
				RoomNode.show_menu = true
				wait_for_room_node_response()
				
		STEPS.SELECT_PLACEMENT:
			if active_designation not in unavailable_rooms:
				user_response.emit({"action": ACTION.NEXT})
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_back() -> void:
	match current_step:
		STEPS.SELECT_FLOOR:
			Rendering.show_menu = false
			
		#STEPS.SELECT_ROOM:
			#current_step = STEPS.SELECT_FLOOR
			
		STEPS.SELECT_PLACEMENT:
			user_response.emit({"action": ACTION.BACK})
# --------------------------------------------------------------------------------------------------
