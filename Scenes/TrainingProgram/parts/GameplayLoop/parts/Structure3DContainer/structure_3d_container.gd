@tool
extends GameContainer

@onready var ZoomA:BtnBase = $Control/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/ZoomA
@onready var ZoomB:BtnBase = $Control/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/ZoomB
@onready var ZoomC:BtnBase = $Control/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/ZoomC

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
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.STRUCTURE_3D)
	
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
