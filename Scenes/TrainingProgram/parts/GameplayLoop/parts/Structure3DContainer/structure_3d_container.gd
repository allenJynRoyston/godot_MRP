@tool
extends GameContainer

@onready var ZoomA:BtnBase = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/HBoxContainer/ZoomA
@onready var ZoomB:BtnBase = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/HBoxContainer/ZoomB
@onready var ZoomC:BtnBase = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/HBoxContainer/ZoomC
@onready var ZoomD:BtnBase = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/HBoxContainer/ZoomD

@onready var OverlayContainer:Control = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer
@onready var BookmarkedInfo:Control = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/BookmarkedInfo
@onready var FloatingInfo:Control = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/FloatingInfo
@onready var TestPoint:Control = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/FloatingInfo/TestPoint
@onready var LineDrawController:Control = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/LineDrawController

@onready var RoomName:Label = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/FloatingInfo/TestPoint/VBoxContainer/MarginContainer/RoomName

@onready var RenderLayer1:Node3D = $SubViewport/Rendering
@onready var RenderLayer2:Node3D = $SubViewport2/Rendering

const FloatingInfoPreload = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/Structure3DContainer/parts/FloatingItem.tscn")

var camera_type:CAMERA.TYPE = CAMERA.TYPE.PERSPECTIVE : 
	set(val):
		camera_type = val
		on_camera_type_update()

var current_camera_zoom:CAMERA.ZOOM = CAMERA.ZOOM.FLOOR : 
	set(val):
		current_camera_zoom = val
		on_current_camera_zoom_update()

var floating_node_refs:Dictionary = {}
var bookmarked_node_refs:Dictionary = {}
var tracking_nodes:Array = []

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.STRUCTURE_3D, self)
	GBL.subscribe_to_process(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.STRUCTURE_3D)
	GBL.unsubscribe_to_process(self)
	
func _ready() -> void:
	super._ready()
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	ZoomA.onClick = func() -> void:
		GBL.find_node(REFS.GAMEPLAY_LOOP).current_camera_zoom = CAMERA.ZOOM.OVERVIEW
		
	ZoomB.onClick = func() -> void:
		GBL.find_node(REFS.GAMEPLAY_LOOP).current_camera_zoom = CAMERA.ZOOM.FLOOR
		
	ZoomC.onClick = func() -> void:
		GBL.find_node(REFS.GAMEPLAY_LOOP).current_camera_zoom = CAMERA.ZOOM.RING
		
	ZoomD.onClick = func() -> void:
		GBL.find_node(REFS.GAMEPLAY_LOOP).current_camera_zoom = CAMERA.ZOOM.RM
	
	on_camera_type_update()
	on_current_camera_zoom_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func traverse(callback:Callable) -> void:
	for floor_index in room_config.floor:
		for ring_index in room_config.floor[floor_index].ring:
			for room_index in room_config.floor[floor_index].ring[ring_index].room:	
				callback.call("%s%s%s" % [floor_index, ring_index, room_index], floor_index, ring_index, room_index)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_camera_zoom_update() -> void:
	if !is_node_ready():return
	for node in [ZoomA, ZoomB, ZoomC, ZoomD]:
		node.inactive_color = Color(0.292, 0.292, 0.292, 0.827)
	
	match current_camera_zoom:
		CAMERA.ZOOM.OVERVIEW:
			ZoomA.inactive_color = Color.WHITE
		CAMERA.ZOOM.FLOOR:
			ZoomB.inactive_color = Color.WHITE
		CAMERA.ZOOM.RING:
			ZoomC.inactive_color = Color.WHITE
		CAMERA.ZOOM.RM:
			ZoomD.inactive_color = Color.WHITE			
			
	for node in [RenderLayer1, RenderLayer2]:
		node.current_camera_zoom = current_camera_zoom
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------
func on_room_config_update() -> void:
	if !is_node_ready() or room_config.is_empty():return
	
	var callback:Callable = func(ref_name:String, floor_index:int, ring_index:int, room_index:int):
		if ref_name not in floating_node_refs:
			var new_floating_node:Control = FloatingInfoPreload.instantiate()
			FloatingInfo.add_child(new_floating_node)
			floating_node_refs[ref_name] = new_floating_node
		floating_node_refs[ref_name].data = room_config.floor[floor_index].ring[ring_index].room[room_index].room_data
		floating_node_refs[ref_name].location = {"floor": floor_index, "ring": ring_index, "room": room_index}
	traverse(callback) 
	
	on_bookmarked_rooms_update()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_current_location_update() -> void:
	if !is_node_ready() or room_config.is_empty():return
	for node in [RenderLayer1, RenderLayer2]:
		node.current_location = current_location

	var callback:Callable = func(ref_name:String, floor_index:int, ring_index:int, room_index:int):
		if ref_name in floating_node_refs:
			var active_ref:String = "%s%s%s" % [current_location.floor, current_location.ring, current_location.room]
			var node:Control = floating_node_refs[ref_name]
			node.show() if ref_name == active_ref else node.hide() 
	traverse(callback) 
	
	LineDrawController.draw_keys = []
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_bookmarked_rooms_update() -> void:
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
	var active_ref:String = "%s%s%s" % [current_location.floor, current_location.ring, current_location.room]
	LineDrawController.draw_keys =  [active_ref] + bookmarked_rooms
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func on_camera_type_update() -> void:
	if !is_node_ready():return
	for node in [RenderLayer1, RenderLayer2]:
		node.current_camera_zoom = current_camera_zoom
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if is_visible_in_tree():
		var key:String = input_data.key
		var keycode:int = input_data.keycode

		match key:
			"ENTER":
				user_response.emit({"action": ACTION.NEXT})
			"BACK":
				user_response.emit({"action": ACTION.BACK})
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_process_update(delta:float) -> void:
	if !is_node_ready() or current_location.is_empty():return	
	
	# display all bookmarked rooms as a floating tag
	for index in bookmarked_rooms.size():
		var ref_name:String = bookmarked_rooms[index]
		var active_room_pos:Vector2 = U.convert_from_normalized_position(FloatingInfo.size, GBL.get_projected_3d_object_normalized_position(ref_name))
		var floating_node:Control = bookmarked_node_refs[ref_name]
		floating_node.position = Vector2(OverlayContainer.size.x - 80, (((10 + floating_node.size.y) * index) + 10) )

	if !floating_node_refs.is_empty():
		var ref_name:String = "%s%s%s" % [current_location.floor, current_location.ring, current_location.room]
		var active_room_pos:Vector2 = U.convert_from_normalized_position(FloatingInfo.size, GBL.get_projected_3d_object_normalized_position(ref_name))
		var floating_node:Control = floating_node_refs[ref_name]
		floating_node.position = active_room_pos - Vector2(floating_node.size.x, 40)
		var line_data:Dictionary = {
			"key": ref_name, 
			"lines": [
				{
					"start_point": active_room_pos,
					"end_point": floating_node.global_position - LineDrawController.global_position + floating_node.size/2
				}
			]
		}
		LineDrawController.update_line_data(line_data)			

# --------------------------------------------------------------------------------------------------
