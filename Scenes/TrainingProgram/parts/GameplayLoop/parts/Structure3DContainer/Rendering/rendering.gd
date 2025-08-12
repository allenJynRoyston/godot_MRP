extends Control

@onready var RenderSubviewport:SubViewport = $SubViewport
@onready var MainViewportTexture:TextureRect = $MainViewportTexture
@onready var TransitionScreen:Control = $TransitionScreen
@onready var ControllerOverlay:Control = $ControllerOverlay

@onready var BGColorRect:ColorRect = $BGColorRect
@onready var MaterialRect:ColorRect = $ColorRect
@onready var NukeSplashContainer:Control = $NukeSplashContainer

@onready var BaseScene:Node3D = $SubViewport/Rendering/BaseScene
@onready var BaseCamera:Camera3D = $SubViewport/Rendering/BaseScene/BaseCamera
@onready var BaseSubviewport:SubViewport = $SubViewport/Rendering/BaseScene/SubViewport
@onready var BaseRendering:Control = $SubViewport/Rendering/BaseScene/SubViewport/BaseRendering

@onready var WingScene:Node3D = $SubViewport/Rendering/WingScene
@onready var WingCamera:Camera3D = $SubViewport/Rendering/WingScene/WingCamera
@onready var WingSubviewport:SubViewport = $SubViewport/Rendering/WingScene/SubViewport
@onready var WingCurrentFloor:Control = $SubViewport/Rendering/WingScene/SubViewport/WingCurrentFloor
@onready var WingSpriteA:Sprite3D = $SubViewport/Rendering/WingScene/SpriteA
@onready var WingSpriteB:Sprite3D = $SubViewport/Rendering/WingScene/SpriteB
#
#@onready var GeneratorScene:Node3D = $SubViewport/Rendering/GeneratorScene
#@onready var GeneratorCamera:Camera3D = $SubViewport/Rendering/GeneratorScene/GenCamera
#@onready var GeneratorSubviewport:SubViewport = $SubViewport/Rendering/GeneratorScene/SubViewport
#@onready var GeneratorNode:Control = $SubViewport/Rendering/GeneratorScene/SubViewport/Generator

@onready var main_viewport_texture_material_duplicate:ShaderMaterial = MainViewportTexture.material.duplicate(true)
@onready var material_rect_duplicate:ShaderMaterial = MaterialRect.material.duplicate(true)

const SplashPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/Splash/Splash.tscn")

var current_location:Dictionary = {}
var camera_settings:Dictionary = {} 
var control_pos:Dictionary = {}
var base_states:Dictionary = {}
var room_config:Dictionary = {} 

var previous_camera_type:int = -1

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
	SUBSCRIBE.subscribe_to_room_config(self)
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.RENDERING)
	GBL.unsubscribe_to_process(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_audio_data(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)	
	SUBSCRIBE.unsubscribe_to_base_states(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	
func _ready() -> void:
	MainViewportTexture.material = main_viewport_texture_material_duplicate
	on_nuke_is_triggered_update()
# ------------------------------------------------

# ------------------------------------------------
func transition() -> void:
	await TransitionScreen.start(0.3, true)
# ------------------------------------------------

# ------------------------------------------------
func enable_overview(state:bool) -> void:
	if state:
		BaseScene.show()
		BaseRendering.show()
		BaseRendering.set_process(true)
		BaseCamera.make_current()
	else:
		BaseRendering.hide()
		BaseRendering.set_process(false)		
		BaseScene.hide()
# ------------------------------------------------

# ------------------------------------------------
func enable_wing(state:bool) -> void:
	if state:
		WingScene.show()
		WingCurrentFloor.show()
		WingCurrentFloor.set_process(true)
		WingCamera.make_current()
	else:
		WingScene.hide()
		WingCurrentFloor.hide()
		WingCurrentFloor.set_process(false)
# ------------------------------------------------

# ------------------------------------------------
func shift_vertically(state:bool, duration:float, current_location:Dictionary) -> void:
	# first, take snapshot
	var shift_pos:float = 1.5 if !state else -1.5
	WingSpriteA.show()
	WingSpriteB.show()

	WingCurrentFloor.set_current_location( current_location )
	WingSpriteB.texture = U.get_viewport_texture(WingSubviewport)
	
	WingSpriteB.pixel_size = 0.0013
	WingSpriteB.position.y = 0
	WingSpriteB.position.x = 0
	WingSpriteA.position.y = -(shift_pos)
	WingSpriteA.modulate = Color(0, 0, 0.2, 1)
	
	await U.tween_node_property(WingCamera, "size", 2, duration/2, 0, Tween.TRANS_SINE)
	U.tween_node_property(WingSpriteA, "position:y", 0, duration, 0, Tween.TRANS_SINE)
	U.tween_node_property(WingSpriteB, "pixel_size", 0.0005, duration, 0, Tween.TRANS_SINE)		
	await U.tween_node_property(WingSpriteB, "position:y", shift_pos, duration, 0, Tween.TRANS_SINE)
	U.tween_node_property(WingCamera, "size", 1.35, duration/2, 0, Tween.TRANS_SINE)
	U.tween_node_property(WingSpriteA, "modulate", Color(1, 1, 1, 1), duration/2, 0.2, Tween.TRANS_SINE)

	WingSpriteB.hide()
# ------------------------------------------------

# ------------------------------------------------
func shift_horizontally(state:bool, duration:float, previous_location:Dictionary, current_location:Dictionary) -> void:		
	# first, take snapshot
	var shift_pos:float = 2.2 if state else -2.2
	WingSpriteA.show()
	WingSpriteB.show()

	WingCurrentFloor.set_current_location( current_location )
	WingSpriteB.texture = U.get_viewport_texture(WingSubviewport)

	WingSpriteB.pixel_size = 0.0013	
	WingSpriteB.position.y = 0
	WingSpriteB.position.x = 0
	WingSpriteA.position.x = -(shift_pos)
	WingSpriteA.modulate = Color(0, 0, 0.2, 1)
	
	await U.tween_node_property(WingCamera, "size", 1.7, duration/2, 0, Tween.TRANS_SINE)
	U.tween_node_property(WingSpriteA, "position:x", 0, duration, 0, Tween.TRANS_SINE)
	U.tween_node_property(WingSpriteB, "pixel_size", 0.0005, duration, 0, Tween.TRANS_SINE)	
	await U.tween_node_property(WingSpriteB, "position:x", shift_pos, duration, 0, Tween.TRANS_SINE)
	U.tween_node_property(WingCamera, "size", 1.35, duration/2, 0, Tween.TRANS_SINE)
	U.tween_node_property(WingSpriteA, "modulate", Color(1, 1, 1, 1), duration/2, 0.2, Tween.TRANS_SINE)

	WingSpriteB.hide()
# ------------------------------------------------

# ------------------------------------------------
func on_base_states_update(new_base_state:Dictionary) -> void:
	if !is_node_ready() or new_base_state.is_empty():return
	if previous_nuke_state != new_base_state.base.onsite_nuke.triggered:
		nuke_is_triggered = new_base_state.base.onsite_nuke.triggered
		previous_nuke_state = nuke_is_triggered
	
	U.debounce(str(self, "_check_for_conditions"), check_for_conditions)
# ------------------------------------------------

# ------------------------------------------------
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return
	
	U.debounce(str(self, "_check_for_conditions"), check_for_conditions)
# ------------------------------------------------

	
# ------------------------------------------------
func check_for_conditions() -> void:
	if !is_node_ready() or room_config.is_empty() or current_location.is_empty():return
	var power_distribution:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].power_distribution
	var is_overheated:bool = power_distribution.heating == 0
	var is_ventilated:bool = power_distribution.ventilation > 0
	
	if camera_settings.type == 	CAMERA.TYPE.FLOOR_SELECT:
		main_viewport_texture_material_duplicate.set_shader_parameter("enable_horizontal", false)
		main_viewport_texture_material_duplicate.set_shader_parameter("enable_vertical", false)
		return
	
	if is_overheated:
		main_viewport_texture_material_duplicate.set_shader_parameter("enable_horizontal", true)		
		main_viewport_texture_material_duplicate.set_shader_parameter("enable_vertical", false)
		return
	
	if !is_ventilated:
		main_viewport_texture_material_duplicate.set_shader_parameter("enable_horizontal", true)
		main_viewport_texture_material_duplicate.set_shader_parameter("enable_vertical", true)
		return
	
	main_viewport_texture_material_duplicate.set_shader_parameter("enable_horizontal", false)
	main_viewport_texture_material_duplicate.set_shader_parameter("enable_vertical", false)
# ------------------------------------------------

# ------------------------------------------------
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
		
	match camera_settings.type:
		# --------------------
		CAMERA.TYPE.FLOOR_SELECT:			
			transition()
			enable_overview(true)
			enable_wing(false)
			set_shader_strength(0)
		# --------------------	
		CAMERA.TYPE.WING_SELECT:	
			transition()
			enable_wing(true)			
			enable_overview(false)
			set_shader_strength(1)
		# --------------------		
		CAMERA.TYPE.ROOM_SELECT:
			transition()
			enable_wing(true)			
			enable_overview(false)
			set_shader_strength(0)
# ------------------------------------------------

# ------------------------------------------------
func set_shader_strength(strength:int) -> void:
	var new_amount:float
	match strength:
		0:
			new_amount = 6.0
		1: 
			new_amount = 3.0
	
	MaterialRect.material = material_rect_duplicate
	U.tween_range(material_rect_duplicate.get_shader_parameter("zoom"), new_amount, 0.5, func(val:float) -> void:
		material_rect_duplicate.set_shader_parameter("zoom", val)
	)	

	U.debounce(str(self.name, "_animate_wing"), animate_wing)
# ------------------------------------------------

# ------------------------------------------------
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	U.debounce(str(self.name, "_animate_wing"), animate_wing)
	U.debounce(str(self, "_check_for_conditions"), check_for_conditions)
# ------------------------------------------------

# ------------------------------------------------
func on_nuke_is_triggered_update() -> void:
	if !is_node_ready():return
	for child in NukeSplashContainer.get_children():
		child.queue_free()

	BGColorRect.color = Color(1, 0, 0, 0.5) if nuke_is_triggered else Color(0.184, 0.193, 0.212) 	
	material_rect_duplicate.set_shader_parameter("line_color", Color.ORANGE_RED)	
	material_rect_duplicate.set_shader_parameter("angle", 0.5 if nuke_is_triggered else 0 )	
	material_rect_duplicate.set_shader_parameter("speed", 5 if nuke_is_triggered else 0.2 )	

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
			await shift_vertically(previous_floor > current_location.floor, 0.25, current_location)
			GBL.remove_from_animation_queue(self)
			
		if previous_ring != current_location.ring:
			GBL.add_to_animation_queue(self)
			var previous_location:Dictionary = {"floor": current_location.floor, "ring": previous_ring, "room": current_location.room}
			await shift_horizontally(previous_ring > current_location.ring, 0.25, previous_location, current_location)
			GBL.remove_from_animation_queue(self)
			
		previous_floor = current_location.floor
		previous_ring = current_location.ring
# ------------------------------------------------

# ------------------------------------------------
func on_process_update(delta: float, _time_passed:float) -> void:
	if !is_node_ready() or !is_visible_in_tree() or nuke_is_triggered:return
	var hue := fmod(_time_passed * 0.01, 1.0)  # Adjust 0.1 to control speed
	var color := Color.from_hsv(hue, 1.0, 1.0)
	material_rect_duplicate.set_shader_parameter("line_color", color)
# ------------------------------------------------

# ------------------------------------------------
func on_audio_data_update(new_val:Dictionary) -> void:
	if !is_node_ready() or !is_visible_in_tree() or new_val.is_empty()  or nuke_is_triggered:return
	var new_audio_data:Array = new_val.data
	var music_position:float = new_val.pos
	var bass_level:float = new_audio_data[10]
	var normalized:float = clamp((bass_level - 0.5) / 0.1, 0.1, 1)
	material_rect_duplicate.set_shader_parameter("glow_strength", normalized + 0.5)
# ------------------------------------------------
