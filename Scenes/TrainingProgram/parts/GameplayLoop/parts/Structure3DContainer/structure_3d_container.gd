@tool
extends GameContainer

@onready var ZoomA:BtnBase = $TextureRect2/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ZoomA
@onready var ZoomB:BtnBase = $TextureRect2/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ZoomB
@onready var ZoomC:BtnBase = $TextureRect2/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ZoomC

@onready var FloatingPointContainer:Control = $TextureRect2/PanelContainer/MarginContainer/PanelContainer/FloatingPointContainer
@onready var TestPoint:Control = $TextureRect2/PanelContainer/MarginContainer/PanelContainer/FloatingPointContainer/TestPoint
@onready var LineDrawController:Control = $TextureRect2/PanelContainer/MarginContainer/PanelContainer/LineDrawController

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
	
func _draw():
	# Draw a line between the start and end points
	var start_point: Vector2 = Vector2(50, 50)
	var end_point: Vector2 = Vector2(150, 150)
	var line_color: Color = Color(1, 0, 0)  # Red color
	var line_width: float = 2.0	
	draw_line(start_point, end_point, line_color, line_width)	
	
func _ready() -> void:
	super._ready()
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	ZoomA.onClick = func() -> void:
		pass
		#camera_type = CAMERA.TYPE.PERSPECTIVE
	ZoomB.onClick = func() -> void:
		pass
		#$camera_type = CAMERA.TYPE.OVERHEAD
	ZoomC.onClick = func() -> void:
		pass
		#camera_type = CAMERA.TYPE.OVERHEAD		
	
	on_camera_type_update()
	on_current_camera_zoom_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_camera_zoom_update() -> void:
	for node in [RenderLayer1, RenderLayer2]:
		node.current_camera_zoom = current_camera_zoom
# --------------------------------------------------------------------------------------------------			
	
# --------------------------------------------------------------------------------------------------
func on_current_location_update() -> void:
	for node in [RenderLayer1, RenderLayer2]:
		node.current_location = current_location
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
	var active_room_pos:Vector2 = U.convert_from_normalized_position(FloatingPointContainer.size, GBL.get_projected_3d_object_normalized_position("active_room"))
	TestPoint.position = active_room_pos - Vector2(0, 20)
	
	LineDrawController.start_point = active_room_pos
# --------------------------------------------------------------------------------------------------
