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

@onready var GeneratorScene:Node3D = $SubViewport/Rendering/GeneratorScene
@onready var GeneratorCamera:Camera3D = $SubViewport/Rendering/GeneratorScene/GenCamera
@onready var GeneratorSubviewport:SubViewport = $SubViewport/Rendering/GeneratorScene/SubViewport
@onready var GeneratorNode:Control = $SubViewport/Rendering/GeneratorScene/SubViewport/Generator

const TransitionShader:ShaderMaterial = preload("res://CanvasShader/Dissolve/Dissolve.tres")

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
func transition() -> void:
	TransitionRect.show()
	TransitionRect.texture = U.get_viewport_texture(RenderSubviewport)
	var current_val:float = TransitionRect.material.get_shader_parameter("sensitivity")
	await U.tween_range(0.0, 1.0, 0.3, func(val:float) -> void:
		TransitionRect.material.set_shader_parameter("sensitivity", val)
	).finished	
	TransitionRect.hide()
# ------------------------------------------------

# ------------------------------------------------
func enable_overview(state:bool) -> void:
	if state:
		transition()
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
		transition()
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
func enable_generator(state:bool) -> void:
	if state:
		transition()
		GeneratorScene.show()
		GeneratorNode.show()
		GeneratorNode.set_process(true)
		GeneratorCamera.make_current()
	else:
		GeneratorScene.hide()
		GeneratorNode.hide()
		GeneratorNode.set_process(false)
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
			enable_generator(false)
		# --------------------	
		CAMERA.TYPE.WING_SELECT:
			await enable_wing(true)			
			enable_overview(false)
			enable_generator(false)
		# --------------------		
		CAMERA.TYPE.ROOM_SELECT:
			await enable_wing(true)			
			enable_overview(false)
			enable_generator(false)			
		# --------------------	
		CAMERA.TYPE.GENERATOR:
			await enable_generator(true)
			enable_overview(false)
			enable_wing(false)

	GBL.remove_from_animation_queue(self)
# ------------------------------------------------
