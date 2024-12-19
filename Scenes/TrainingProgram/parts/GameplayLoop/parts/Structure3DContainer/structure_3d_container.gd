@tool
extends GameContainer

@onready var CameraA:BtnBase = $Control/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/CameraA
@onready var CameraB:BtnBase = $Control/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/CameraB
@onready var RenderLayer1:Node3D = $SubViewport/Rendering
@onready var RenderLayer2:Node3D = $SubViewport2/Rendering

enum CAMERA_TYPE {PERSPECTIVE, OVERHEAD}

var camera_type:CAMERA_TYPE = CAMERA_TYPE.PERSPECTIVE : 
	set(val):
		camera_type = val
		on_camera_type_update()

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
	
	CameraA.onClick = func() -> void:
		camera_type = CAMERA_TYPE.PERSPECTIVE
	CameraB.onClick = func() -> void:
		camera_type = CAMERA_TYPE.OVERHEAD
	
	on_camera_type_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func set_camera_focus(type:String) -> void:
	print("set camera focus: ", type)
# --------------------------------------------------------------------------------------------------			
	

# --------------------------------------------------------------------------------------------------
func on_current_location_update() -> void:
	for node in [RenderLayer1, RenderLayer2]:
		node.current_location = current_location
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_camera_type_update() -> void:
	for node in [RenderLayer1, RenderLayer2]:
		node.camera_type = camera_type
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
