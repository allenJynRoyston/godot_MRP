@tool
extends GameContainer

@onready var SelectLocationInstructions:VBoxContainer = $PanelContainer/MarginContainer/SelectLocationInstructions
@onready var PlacementInstructions:VBoxContainer = $PanelContainer/MarginContainer/PlacementInstructions

@onready var OverlayContainer:Control = $OverlayContainer
@onready var BookmarkedInfo:Control = $OverlayContainer/BookmarkedInfo
@onready var FloatingInfo:Control = $OverlayContainer/FloatingInfo
@onready var TestPoint:Control = $OverlayContainer/FloatingInfo/TestPoint
@onready var LineDrawController:Control = $OverlayContainer/LineDrawController
#
@onready var RenderLayer1:Node3D = $SubViewport/Rendering
#@onready var RenderLayer2:Node3D = $SubViewport2/Rendering

enum STEPS { SELECT_FLOOR, SELECT_ROOM, FINALIZE }

const FloatingInfoPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/Structure3DContainer/parts/FloatingItem.tscn")
const CheckboxPreload:PackedScene = preload("res://UI/Buttons/Checkbox/checkbox.tscn")

var floating_node_refs:Dictionary = {}
var bookmarked_node_refs:Dictionary = {}
var tracking_nodes:Array = []
var unavailable_rooms:Array = []
var active_designation:String = ""

#var show_instructions:bool = false : 
	#set(val):
		#show_instructions = val
		#on_show_instructions_update()

var on_floor:int = -1

var placement_instructions:Array = [] : 
	set(val):
		placement_instructions = val
		on_placement_instructions_update()
		
var current_step:STEPS = STEPS.SELECT_FLOOR : 
	set(val):
		current_step = val
		on_current_step_update()
		
var grid_array:Array = [] : 
	set(val):
		grid_array = val
		on_grid_array_update()

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
	on_bookmarked_rooms_update()
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
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if !is_node_ready() or room_config.is_empty():return
	active_designation = "%s%s%s" % [current_location.floor, current_location.ring, current_location.room]
	
	var callback:Callable = func(ref_name:String, floor_index:int, ring_index:int, room_index:int):
		if ref_name in floating_node_refs:			
			var node:Control = floating_node_refs[ref_name]
			node.show() if ref_name == active_designation else node.hide() 
	traverse(callback) 
	
	LineDrawController.draw_keys = []
	
	if on_floor != current_location.floor:
		var temp_grid_array := []
		on_floor = current_location.floor
		var array_size:int = room_config.floor[current_location.floor].array_size
		var count:int = 0
		for x in range(array_size):
			var row:Array = []
			for y in range(array_size):
				row.push_back(count)
				count += 1
			temp_grid_array.push_back(row)
		grid_array = temp_grid_array

	for child in PlacementInstructions.get_children():
		child.on_condition_check(current_location)
# --------------------------------------------------------------------------------------------------

## --------------------------------------------------------------------------------------------------
#func on_show_instructions_update() -> void:
	#if !is_node_ready():return
	#SelectLocationInstructions.show() if show_instructions else SelectLocationInstructions.hide()
	#PlacementInstructions.show() if show_instructions else PlacementInstructions.hide()
## --------------------------------------------------------------------------------------------------	
	#

# --------------------------------------------------------------------------------------------------
func on_bookmarked_rooms_update(new_val:Array = bookmarked_rooms) -> void:
	bookmarked_rooms = new_val
	if !is_node_ready() or room_config.is_empty():return
	
	bookmarked_node_refs = {}
	for child in BookmarkedInfo.get_children():
		child.queue_free()

	var callback:Callable = func(ref_name:String, floor_index:int, ring_index:int, room_index:int):
		if ref_name in bookmarked_rooms:
			var new_floating_node:Control = FloatingInfoPreload.instantiate()
			BookmarkedInfo.add_child(new_floating_node)
			new_floating_node.show()
			
			bookmarked_node_refs[ref_name] = new_floating_node
			bookmarked_node_refs[ref_name].data = room_config.floor[floor_index].ring[ring_index].room[room_index].room_data
			bookmarked_node_refs[ref_name].location = {"floor": floor_index, "ring": ring_index, "room": room_index}
	
	traverse(callback) 
	
	LineDrawController.draw_keys = []
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func update_draw_keys() -> void:
	LineDrawController.draw_keys =  [active_designation] + bookmarked_rooms
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_step_update() -> void:
	if !is_node_ready() or camera_settings.is_empty():return
	match current_step:
		# ------------------------------------------------
		STEPS.SELECT_FLOOR:
			camera_settings.type = CAMERA.TYPE.FLOOR_SELECT
			SUBSCRIBE.camera_settings = camera_settings
			
			#var key:String = await wait_for_input
			#match key:
				#"BACK":
					#user_response.emit({"action": ACTION.BACK})
				#_:
					#current_step = current_step
		# ------------------------------------------------
		STEPS.SELECT_ROOM:
			camera_settings.type = CAMERA.TYPE.ROOM_SELECT
			SUBSCRIBE.camera_settings = camera_settings
			
			#var key:String = await wait_for_input
#
			#match key:
				#"BACK":
					#pass
					##user_response.emit({"action": ACTION.BACK})
				#"ENTER":
					#print("enter!")
					##current_step = STEPS.FINALIZE if active_designation not in unavailable_rooms else current_step
				
		# ------------------------------------------------
		STEPS.FINALIZE:
			user_response.emit({"action": ACTION.NEXT})

# --------------------------------------------------------------------------------------------------		


# --------------------------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or current_location.is_empty() or GBL.has_animation_in_queue():return
	
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"W":
			match current_step:
				STEPS.SELECT_FLOOR:
					current_location.floor = clampi(current_location.floor - 1, 0, room_config.floor.size() - 1)
					location_pos = Vector2(0, 0)
				STEPS.SELECT_ROOM:
					location_pos.y = clampi(location_pos.y - 1, 0, grid_array.size() - 1)

		"S":
			match current_step:
				STEPS.SELECT_FLOOR:
					current_location.floor = clampi(current_location.floor + 1, 0, room_config.floor.size() - 1)
					location_pos = Vector2(0, 0)
				STEPS.SELECT_ROOM:
					location_pos.y = clampi(location_pos.y + 1, 0, grid_array.size() - 1)

		"D":
			match current_step:
				STEPS.SELECT_ROOM:
					if location_pos.x == grid_array[location_pos.y].size() - 1:
						current_location.ring = clampi(current_location.ring + 1, 0, room_config.floor[current_location.floor].ring.size() - 1)
						location_pos.x = 0
					else:
						location_pos.x = clampi(location_pos.x + 1, 0, grid_array[location_pos.y].size() - 1)
			
		"A":
			match current_step:
				STEPS.SELECT_ROOM:
					if location_pos.x == 0:
						current_location.ring = clampi(current_location.ring - 1, 0, room_config.floor[current_location.floor].ring.size() - 1)
						location_pos.x = grid_array[location_pos.y].size() - 1
					else:
						location_pos.x = clampi(location_pos.x - 1, 0, grid_array[location_pos.y].size() - 1)
					
		"TAB":
			if current_step == STEPS.SELECT_FLOOR:
				current_step = STEPS.SELECT_ROOM
			elif current_step == STEPS.SELECT_ROOM:
				current_step = STEPS.SELECT_FLOOR
				
		"ENTER":
			match current_step:
				STEPS.SELECT_ROOM:			
					user_response.emit({"action": ACTION.NEXT})
		"BACK":
			user_response.emit({"action": ACTION.BACK})
			
	# overflow checks
	if location_pos.y > grid_array.size() - 1:
		location_pos.y = grid_array.size() - 1
	if location_pos.x > grid_array[location_pos.y].size() - 1:
		location_pos.x = grid_array[location_pos.y].size() - 1		
	

	current_location.room = grid_array[location_pos.y][location_pos.x]
	
	print(current_location)
		
	
	SUBSCRIBE.current_location = current_location
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_grid_array_update() -> void:
	for node in [RenderLayer1]:
		node.grid_array = grid_array
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
#func on_process_update(delta:float) -> void:
	#if !is_node_ready() or current_location.is_empty() or bookmarked_node_refs.is_empty():return	
	#
	## display all bookmarked rooms as a floating tag
	#for index in bookmarked_rooms.size():
		#var ref_name:String = bookmarked_rooms[index]
		#var active_room_pos:Vector2 = U.convert_from_normalized_position(FloatingInfo.size, GBL.get_projected_3d_object_normalized_position(ref_name))
		#var floating_node:Control = bookmarked_node_refs[ref_name]
		#floating_node.position = Vector2(OverlayContainer.size.x - 150, (((10 + floating_node.size.y) * index) + 10) )
#
	#if !floating_node_refs.is_empty():
		#var ref_name:String = "%s%s%s" % [current_location.floor, current_location.ring, current_location.room]
		#var active_room_pos:Vector2 = U.convert_from_normalized_position(FloatingInfo.size, GBL.get_projected_3d_object_normalized_position(ref_name))
		#var floating_node:Control = floating_node_refs[ref_name]
		#floating_node.position = active_room_pos - Vector2(floating_node.size.x, 40)
		#var line_data:Dictionary = {
			#"key": ref_name, 
			#"lines": [
				#{
					#"start_point": active_room_pos,
					#"end_point": floating_node.global_position - LineDrawController.global_position + floating_node.size/2
				#}
			#]
		#}
		#LineDrawController.update_line_data(line_data)			

# --------------------------------------------------------------------------------------------------
