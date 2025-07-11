extends Control

@onready var TransitionRect:TextureRect = $TransitionRect
@onready var RenderSubviewport:SubViewport = $SubViewport
@onready var BGColorRect:ColorRect = $ColorRect

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

var camera_settings:Dictionary = {} 
var previous_camera_type:int
var material_dupe:ShaderMaterial

# ------------------------------------------------
func _init() -> void:
	GBL.register_node(REFS.RENDERING, self)
	GBL.subscribe_to_process(self)
	SUBSCRIBE.subscribe_to_audio_data(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.RENDERING)
	GBL.unsubscribe_to_process(self)
	
	SUBSCRIBE.unsubscribe_to_audio_data(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)	
	
func _ready() -> void:
	material_dupe = BGColorRect.material.duplicate(true)
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
		
		#WingNode.camera_rotate_right()
		#await U.set_timeout(1.0)
		#WingNode.camera_rotate_left()
		#await U.set_timeout(1.0)
		#WingNode.camera_center()
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
	BGColorRect.material = material_dupe
	var new_amount:float = 6.0
		
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
			new_amount = 3.0
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


	U.tween_range(material_dupe.get_shader_parameter("zoom"), new_amount, 0.5, func(val:float) -> void:
		material_dupe.set_shader_parameter("zoom", val)
	)	
				

	GBL.remove_from_animation_queue(self)
# ------------------------------------------------

# ------------------------------------------------
var time_accum: float = 0.0
func on_process_update(delta: float) -> void:
	if !is_node_ready() or !is_visible_in_tree():return
	var hue := fmod(time_accum * 0.01, 1.0)  # Adjust 0.1 to control speed
	var color := Color.from_hsv(hue, 1.0, 1.0)
	time_accum += delta  # Accumulate time in seconds	
	material_dupe.set_shader_parameter("line_color", color)
# ------------------------------------------------

func on_audio_data_update(new_val:Dictionary) -> void:
	if !is_node_ready() or !is_visible_in_tree() or new_val.is_empty():return
	var new_audio_data:Array = new_val.data
	var music_position:float = new_val.pos
	var bass_level:float = new_audio_data[10]
	var normalized:float = clamp((bass_level - 0.5) / 0.1, 0.1, 1)
	material_dupe.set_shader_parameter("glow_strength", normalized + 0.5)
