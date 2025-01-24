@tool
extends GameContainer

@onready var SelectLocationInstructions:VBoxContainer = $PanelContainer/MarginContainer/SelectLocationInstructions
@onready var PlacementInstructions:VBoxContainer = $PanelContainer/MarginContainer/PlacementInstructions

enum STEPS { SELECT_FLOOR, SELECT_ROOM, FINALIZE }
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
func select_location() -> Signal:
	SelectLocationInstructions.show()	
	#if current_step != STEPS.SELECT_FLOOR:
		#camera_settings.is_locked = true
		#SUBSCRIBE.camera_settings = camera_settings
		#current_step = STEPS.SELECT_FLOOR
	return user_response
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
				DIR.UP: return val
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
				DIR.DOWN: return val
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
		STEPS.FINALIZE:
			user_response.emit({"action": ACTION.NEXT})

# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or current_location.is_empty() or GBL.has_animation_in_queue():return
	
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"W":
			match current_step:
				STEPS.SELECT_FLOOR:
					current_location.floor = clampi(current_location.floor - 1, 0, room_config.floor.size() - 1)
				STEPS.SELECT_ROOM:
					current_location.room = location_lookup(current_location.room, DIR.UP)

		"S":
			match current_step:
				STEPS.SELECT_FLOOR:
					current_location.floor = clampi(current_location.floor + 1, 0, room_config.floor.size() - 1)
				STEPS.SELECT_ROOM:
					current_location.room = location_lookup(current_location.room, DIR.DOWN)

		"D":
			match current_step:
				STEPS.SELECT_ROOM:
					var room_index:int = location_lookup(current_location.room, DIR.RIGHT)
					if room_index == -1:
						if current_location.ring < room_config.floor[current_location.floor].ring.size() - 1:
							current_location.ring = clampi(current_location.ring + 1, 0, room_config.floor[current_location.floor].ring.size() - 1)
							current_location.room = 4
					else:
						current_location.room = room_index

			
		"A":
			match current_step:
				STEPS.SELECT_ROOM:
					var room_index:int = location_lookup(current_location.room, DIR.LEFT)
					if room_index == -1:
						if current_location.ring > 0:
							current_location.ring = clampi(current_location.ring - 1, 0, room_config.floor[current_location.floor].ring.size() - 1)
							current_location.room = 4
					else:
						current_location.room = room_index

					
		"TAB":
			if current_step == STEPS.SELECT_FLOOR:
				current_step = STEPS.SELECT_ROOM
			elif current_step == STEPS.SELECT_ROOM:
				current_step = STEPS.SELECT_FLOOR
		
		"E":
			match current_step:
				STEPS.SELECT_FLOOR:
					current_step = STEPS.SELECT_ROOM
				STEPS.SELECT_ROOM:			
					if active_designation not in unavailable_rooms:
						user_response.emit({"action": ACTION.NEXT})
					else:
						print("room unavailable")
				
		"ENTER":
			match current_step:
				STEPS.SELECT_FLOOR:
					current_step = STEPS.SELECT_ROOM				
				STEPS.SELECT_ROOM:			
					if active_designation not in unavailable_rooms:
						user_response.emit({"action": ACTION.NEXT})
					else:
						print("room unavailable")
		"BACK":
			user_response.emit({"action": ACTION.BACK})
			
	# overflow checks
	#if location_pos.y > grid_array.size() - 1:
		#location_pos.y = grid_array.size() - 1
	#if location_pos.x > grid_array[location_pos.y].size() - 1:
		#location_pos.x = grid_array[location_pos.y].size() - 1		
	
	#print(current_location.room)
	#current_location.room = grid_array[location_pos.y][location_pos.x]

	
	SUBSCRIBE.current_location = current_location
# --------------------------------------------------------------------------------------------------
