@tool
extends GameContainer

@onready var ZoomA:BtnBase = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/HBoxContainer/ZoomA
@onready var ZoomB:BtnBase = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/HBoxContainer/ZoomB
@onready var ZoomC:BtnBase = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/HBoxContainer/ZoomC
@onready var ZoomD:BtnBase = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/HBoxContainer/ZoomD

@onready var OverlayContainer:Control = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer
@onready var FloatingInfo:Control = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/FloatingInfo
@onready var TestPoint:Control = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/FloatingInfo/TestPoint
@onready var LineDrawController:Control = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/LineDrawController

@onready var RoomName:Label = $TextureRect2/PanelContainer/MarginContainer/OverlayContainer/FloatingInfo/TestPoint/VBoxContainer/MarginContainer/RoomName

@onready var RenderLayer1:Node3D = $SubViewport/Rendering
@onready var RenderLayer2:Node3D = $SubViewport2/Rendering

var camera_type:CAMERA.TYPE = CAMERA.TYPE.PERSPECTIVE : 
	set(val):
		camera_type = val
		on_camera_type_update()

var current_camera_zoom:CAMERA.ZOOM = CAMERA.ZOOM.FLOOR : 
	set(val):
		current_camera_zoom = val
		on_current_camera_zoom_update()
		
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
func on_current_camera_zoom_update() -> void:
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
func on_current_location_update() -> void:
	if !is_node_ready():return
	for node in [RenderLayer1, RenderLayer2]:
		node.current_location = current_location
	
	if room_config.is_empty():return
	var floor:int = current_location.floor
	var ring:int = current_location.ring
	var room:int = current_location.room		
	var room_data:Dictionary = room_config.floor[floor].ring[ring].room[room].room_data
	if room_data.is_empty():
		RoomName.text = "Empty"
	else:
		RoomName.text = room_data.get_room_data.call().name
	#RoomName.text = 
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_camera_type_update() -> void:
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
	if !is_node_ready():return		
	var active_room_pos:Vector2 = U.convert_from_normalized_position(FloatingInfo.size, GBL.get_projected_3d_object_normalized_position("active_room"))
	TestPoint.position = active_room_pos - Vector2(TestPoint.size.x + 50, 40)
	LineDrawController.update_line_vectors(active_room_pos, TestPoint.global_position - LineDrawController.global_position + TestPoint.size/2 )	
# --------------------------------------------------------------------------------------------------
