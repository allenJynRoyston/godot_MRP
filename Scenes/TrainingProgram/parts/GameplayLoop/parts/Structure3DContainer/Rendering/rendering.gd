extends Control

@onready var RenderTextureRect:TextureRect = $TextureRect
@onready var TransitionRect:TextureRect = $TransitionRect
@onready var RenderSubviewport:SubViewport = $SubViewport

@onready var OverviewScene:Node3D = $SubViewport/Rendering/OverviewScene
@onready var OverviewCamera:Camera3D = $SubViewport/Rendering/OverviewScene/OverviewCamera
@onready var OverviewSubviewport:SubViewport = $SubViewport/Rendering/OverviewScene/SubViewport
@onready var OverviewNode:Control = $SubViewport/Rendering/OverviewScene/SubViewport/OverviewNode

@onready var WingScene:Node3D = $SubViewport/Rendering/WingScene
@onready var WingCamera:Camera3D = $SubViewport/Rendering/WingScene/WingCamera
@onready var WingSubviewport:SubViewport = $SubViewport/Rendering/WingScene/SubViewport
@onready var WingNode:Control = $SubViewport/Rendering/WingScene/SubViewport/WingNode

var camera_settings:Dictionary = {} 
var previous_camera_type:int

# ------------------------------------------------
func _init() -> void:
	GBL.register_node(REFS.RENDERING, self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.RENDERING)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)	
# ------------------------------------------------

# ------------------------------------------------
func get_preview_viewport() -> SubViewport:
	return WingSubviewport
# ------------------------------------------------

# ------------------------------------------------
func transition_out() -> void:
	TransitionRect.texture = U.get_viewport_texture(RenderSubviewport)
	await U.tween_range(0.0, 1.0, 0.5, func(val:float) -> void:
		TransitionRect.material.set_shader_parameter("sensitivity", val)
	).finished	
# ------------------------------------------------

# ------------------------------------------------
func enable_overview(state:bool) -> void:
	if state:
		transition_out()
		OverviewScene.show()
		OverviewNode.show()
		OverviewNode.set_process(true)
		OverviewCamera.make_current()
	else:
		OverviewNode.hide()
		OverviewNode.set_process(false)		
		OverviewScene.hide()
# ------------------------------------------------

# ------------------------------------------------
func enable_wing(state:bool) -> void:
	if state:
		transition_out()
		WingScene.show()
		WingNode.show()
		WingNode.set_process(true)
		WingCamera.make_current()
	else:
		WingScene.hide()
		WingNode.hide()
		WingNode.set_process(false)
# ------------------------------------------------


# ------------------------------------------------
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
		
	
	GBL.add_to_animation_queue(self)

	match camera_settings.type:
		# --------------------
		CAMERA.TYPE.FLOOR_SELECT:
			await enable_overview(true)
			enable_wing(false)
		# --------------------	
		CAMERA.TYPE.WING_SELECT:
			await enable_wing(true)			
			enable_overview(false)
			

	GBL.remove_from_animation_queue(self)
# ------------------------------------------------
