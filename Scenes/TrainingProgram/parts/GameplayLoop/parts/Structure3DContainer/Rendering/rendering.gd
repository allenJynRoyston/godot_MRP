extends Control

@onready var TransitionRect:TextureRect = $TransitionRect
@onready var RenderSubviewport:SubViewport = $SubViewport
@onready var MainViewportTexture:TextureRect = $MainViewportTexture

@onready var BGColorRect:ColorRect = $BGColorRect
@onready var MaterialRect:ColorRect = $ColorRect
@onready var NukeSplashContainer:Control = $NukeSplashContainer

@onready var BorderControl:Control = $BorderControl
@onready var TopLeftBorder:PanelContainer = $BorderControl/TopLeft
@onready var BottomRightBorder:PanelContainer = $BorderControl/BottomRight

@onready var OverviewScene:Node3D = $SubViewport/Rendering/OverviewScene
@onready var OverviewCamera:Camera3D = $SubViewport/Rendering/OverviewScene/OverviewCamera
@onready var OverviewSubviewport:SubViewport = $SubViewport/Rendering/OverviewScene/SubViewport
@onready var OverviewNode:Control = $SubViewport/Rendering/OverviewScene/SubViewport/OverviewNode

@onready var WingScene:Node3D = $SubViewport/Rendering/WingScene
@onready var WingCamera:Camera3D = $SubViewport/Rendering/WingScene/WingCamera
@onready var WingSubviewport:SubViewport = $SubViewport/Rendering/WingScene/SubViewport
@onready var WingCurrentFloor:Control = $SubViewport/Rendering/WingScene/SubViewport/WingCurrentFloor
@onready var WingTransitionFloor:Control = $SubViewport/Rendering/WingScene/SubViewport2/WingTransitionFloor
@onready var WingSpriteA:Sprite3D = $SubViewport/Rendering/WingScene/WingCamera/Sprite3D
@onready var WingSpriteB:Sprite3D = $SubViewport/Rendering/WingScene/WingCamera/Sprite3D2

@onready var GeneratorScene:Node3D = $SubViewport/Rendering/GeneratorScene
@onready var GeneratorCamera:Camera3D = $SubViewport/Rendering/GeneratorScene/GenCamera
@onready var GeneratorSubviewport:SubViewport = $SubViewport/Rendering/GeneratorScene/SubViewport
@onready var GeneratorNode:Control = $SubViewport/Rendering/GeneratorScene/SubViewport/Generator

@onready var TopPanel:PanelContainer = $Top/PanelContainer
@onready var TopMargin:MarginContainer = $Top/PanelContainer/MarginContainer
@onready var BottomPanel:PanelContainer = $Bottom/PanelContainer
@onready var BottomMargin:MarginContainer = $Bottom/PanelContainer/MarginContainer
@onready var CenterPanel:PanelContainer = $Center/PanelContainer
@onready var CenterMargin:MarginContainer = $Center/PanelContainer/MarginContainer

const SplashPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/Splash/Splash.tscn")

var current_location:Dictionary = {}
var camera_settings:Dictionary = {} 
var control_pos:Dictionary = {}
var previous_camera_type:int = -1
var material_dupe:ShaderMaterial

var previous_floor:int = -1
var previous_ring:int = 0

var previous_nuke_state:bool = false
var nuke_is_triggered:bool = false : 
	set(val):
		nuke_is_triggered = val
		on_nuke_is_triggered_update()

# ------------------------------------------------
func _init() -> void:
	GBL.register_node(REFS.RENDERING, self)
	GBL.subscribe_to_process(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_audio_data(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.RENDERING)
	GBL.unsubscribe_to_process(self)
	
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_audio_data(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)	
	SUBSCRIBE.unsubscribe_to_base_states(self)
	
	
func _ready() -> void:
	material_dupe = MaterialRect.material.duplicate(true)
	on_nuke_is_triggered_update()
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
		WingScene.show()
		WingCurrentFloor.show()
		WingTransitionFloor.show()
		WingCurrentFloor.set_process(true)
		WingCamera.make_current()
	else:
		WingScene.hide()
		WingCurrentFloor.hide()
		WingTransitionFloor.hide()
		WingCurrentFloor.set_process(false)
# ------------------------------------------------

# ------------------------------------------------
func enable_generator(state:bool) -> void:
	if state:
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
func shift_vertically(state:bool, duration:float, current_location:Dictionary) -> void:
	var distance:int = MainViewportTexture.size.y
	const pixel_size_a:float = 0.0013
	const pixel_size_b:float = 0.0012
	const border_size:int = 200
	
	TopLeftBorder.position = Vector2(-border_size, -border_size)
	BottomRightBorder.position = Vector2(border_size, border_size)

	TopLeftBorder.show()
	BottomRightBorder.show()
	WingTransitionFloor.show()

	WingCurrentFloor.set_current_location( current_location )
	WingTransitionFloor.set_current_location(  {"floor": U.min_max(current_location.floor + (1 if !state else -1), 0, 6, true), "ring": current_location.ring, "room": current_location.room} )	
		
	WingCurrentFloor.position = Vector2(0, distance if !state else -distance)
	WingTransitionFloor.position = Vector2(0, 0)
	
	
	U.tween_range(WingCamera.get_child(0).pixel_size, pixel_size_b, 0.1, func(val:float) -> void:
		for sprite in WingCamera.get_children():
			sprite.pixel_size = val
	)			

	U.tween_node_property(TopLeftBorder, "position", Vector2(0, 0), 0.1, 0, Tween.TRANS_SINE)
	U.tween_node_property(BottomRightBorder, "position", Vector2(0, 0), 0.1, 0, Tween.TRANS_SINE)

	U.tween_node_property(WingCurrentFloor, "position:y", 0, duration, 0, Tween.TRANS_SINE)
	await U.tween_node_property(WingTransitionFloor, "position:y", distance if state else -distance, duration, 0, Tween.TRANS_SINE)

	
	U.tween_range(WingCamera.get_child(0).pixel_size, pixel_size_a, 0.1, func(val:float) -> void:
		for sprite in WingCamera.get_children():
			sprite.pixel_size = val
	)	


	U.tween_node_property(TopLeftBorder, "position", Vector2(-border_size, -border_size), 0.1, 0, Tween.TRANS_SINE)
	U.tween_node_property(BottomRightBorder, "position", Vector2(border_size, border_size), 0.1, 0, Tween.TRANS_SINE)

	WingTransitionFloor.hide()
# ------------------------------------------------

# ------------------------------------------------
func shift_horizontally(state:bool, duration:float, current_location:Dictionary) -> void:
	var distance:int = MainViewportTexture.size.x 
	const pixel_size_a:float = 0.0013
	const pixel_size_b:float = 0.0012
	const border_size:int = 200
		
	TopLeftBorder.position = Vector2(-border_size, -border_size)
	BottomRightBorder.position = Vector2(border_size, border_size)

	WingSpriteB.show()
	TopLeftBorder.show()
	BottomRightBorder.show()
	WingTransitionFloor.show()

	WingCurrentFloor.set_current_location( current_location )
	WingTransitionFloor.set_current_location(  {"floor": U.min_max(current_location.floor + (1 if !state else -1), 0, 6, true), "ring": current_location.ring, "room": current_location.room} )	
	
	WingCurrentFloor.position = Vector2(distance if !state else -distance, 0)
	WingTransitionFloor.position = Vector2(0, 0)
	
	
	U.tween_range(WingCamera.get_child(0).pixel_size, pixel_size_b, 0.1, func(val:float) -> void:
		for sprite in WingCamera.get_children():
			sprite.pixel_size = val
	)			

	U.tween_node_property(TopLeftBorder, "position", Vector2(0, 0), 0.1, 0, Tween.TRANS_SINE)
	U.tween_node_property(BottomRightBorder, "position", Vector2(0, 0), 0.1, 0, Tween.TRANS_SINE)

	U.tween_node_property(WingCurrentFloor, "position:x", 0, duration, 0, Tween.TRANS_SINE, Tween.EASE_OUT)
	await U.tween_node_property(WingTransitionFloor, "position:x", distance if state else -distance, duration, 0, Tween.TRANS_SINE, Tween.EASE_OUT)

	
	U.tween_range(WingCamera.get_child(0).pixel_size, pixel_size_a, 0.1, func(val:float) -> void:
		for sprite in WingCamera.get_children():
			sprite.pixel_size = val
	)	

	U.tween_node_property(TopLeftBorder, "position", Vector2(-border_size, -border_size), 0.1, 0, Tween.TRANS_SINE)
	U.tween_node_property(BottomRightBorder, "position", Vector2(border_size, border_size), 0.1, 0, Tween.TRANS_SINE)
	
	WingSpriteB.hide()
	WingTransitionFloor.hide()
# ------------------------------------------------

# ------------------------------------------------
func on_base_states_update(new_base_state:Dictionary) -> void:
	if !is_node_ready() or new_base_state.is_empty():return
	if previous_nuke_state != new_base_state.base.onsite_nuke.triggered:
		nuke_is_triggered = new_base_state.base.onsite_nuke.triggered
		previous_nuke_state = nuke_is_triggered
# ------------------------------------------------

# ------------------------------------------------
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty() or previous_camera_type == camera_settings.type:return
	previous_camera_type = camera_settings.type
	transition()
	
	var new_amount:float = 6.0

	match camera_settings.type:
		# --------------------
		CAMERA.TYPE.FLOOR_SELECT:
			enable_overview(true)
			enable_wing(false)
			enable_generator(false)
		# --------------------	
		CAMERA.TYPE.WING_SELECT:
			enable_wing(true)			
			enable_overview(false)
			enable_generator(false)
			new_amount = 3.0
		# --------------------		
		CAMERA.TYPE.ROOM_SELECT:
			enable_wing(true)			
			enable_overview(false)
			enable_generator(false)			
		# --------------------	
		CAMERA.TYPE.GENERATOR:
			enable_generator(true)
			enable_overview(false)
			enable_wing(false)

	
	MaterialRect.material = material_dupe
	U.tween_range(material_dupe.get_shader_parameter("zoom"), new_amount, 0.5, func(val:float) -> void:
		material_dupe.set_shader_parameter("zoom", val)
	)	
				
	U.debounce(str(self.name, "_animate_wing"), animate_wing)
# ------------------------------------------------

# ------------------------------------------------
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	U.debounce(str(self.name, "_animate_wing"), animate_wing)
# ------------------------------------------------

# --------------------------------------------------------
func set_wing_camera_size(new_size:int) -> void:
	for node in [WingCurrentFloor, WingTransitionFloor]:
		node.update_camera_size(new_size)
# --------------------------------------------------------

# ------------------------------------------------
func on_nuke_is_triggered_update() -> void:
	if !is_node_ready():return
	for child in NukeSplashContainer.get_children():
		child.queue_free()

	BGColorRect.color = Color(1, 0, 0, 0.5) if nuke_is_triggered else Color(0.184, 0.193, 0.212) 	
	material_dupe.set_shader_parameter("line_color", Color.ORANGE_RED)	
	material_dupe.set_shader_parameter("angle", 0.5 if nuke_is_triggered else 0 )	
	material_dupe.set_shader_parameter("speed", 5 if nuke_is_triggered else 0.2 )	

	if nuke_is_triggered:
		for index in range(0, 10):
			var splash_node:Control = SplashPreload.instantiate()
			splash_node.title = "NUCLEAR DETONATION IMMINENT EVACUATE BASE IMMEDIATELY NUCLEAR DETONATION IMMINENT EVACUATE BASE IMMEDIATELY"
			splash_node.auto_start = true
			splash_node.v_offset = index * 150
			NukeSplashContainer.add_child(splash_node)
# ------------------------------------------------

# ------------------------------------------------
func animate_wing() -> void:
	if !is_node_ready() or current_location.is_empty() or camera_settings.is_empty():return
	if camera_settings.type == CAMERA.TYPE.WING_SELECT or camera_settings.type == CAMERA.TYPE.ROOM_SELECT:
		if previous_floor != current_location.floor and !GBL.has_animation_in_queue():
			GBL.add_to_animation_queue(self)
			await shift_vertically(previous_floor > current_location.floor, 0.3, current_location)
			GBL.remove_from_animation_queue(self)
			
		if previous_ring != current_location.ring:
			GBL.add_to_animation_queue(self)
			await shift_horizontally(previous_ring > current_location.ring, 0.3, current_location)
			GBL.remove_from_animation_queue(self)
			
		previous_floor = current_location.floor
		previous_ring = current_location.ring
# ------------------------------------------------

# ------------------------------------------------
var time_accum: float = 0.0
func on_process_update(delta: float) -> void:
	if !is_node_ready() or !is_visible_in_tree() or nuke_is_triggered:return
	var hue := fmod(time_accum * 0.01, 1.0)  # Adjust 0.1 to control speed
	var color := Color.from_hsv(hue, 1.0, 1.0)
	time_accum += delta  # Accumulate time in seconds	
	material_dupe.set_shader_parameter("line_color", color)
# ------------------------------------------------

# ------------------------------------------------
func on_audio_data_update(new_val:Dictionary) -> void:
	if !is_node_ready() or !is_visible_in_tree() or new_val.is_empty()  or nuke_is_triggered:return
	var new_audio_data:Array = new_val.data
	var music_position:float = new_val.pos
	var bass_level:float = new_audio_data[10]
	var normalized:float = clamp((bass_level - 0.5) / 0.1, 0.1, 1)
	material_dupe.set_shader_parameter("glow_strength", normalized + 0.5)
# ------------------------------------------------
