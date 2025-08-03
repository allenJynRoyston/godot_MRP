@tool
extends Node3D

@onready var RoomRender:MeshInstance3D = $Room/RoomRender

@onready var ParticleEmitter:GPUParticles3D = $Room/RoomRender/GPUParticles3D
@onready var ConstructionOmniLight:OmniLight3D = $Room/RoomRender/OmniLight3D

@onready var SafetyGate:MeshInstance3D = $Barrier/SafetyGate
@onready var SafetyLights:Node3D = $Barrier/SafetyGate/SafetyLights

@onready var Flap1:MeshInstance3D = $Gate/Flap1
@onready var Flap2:MeshInstance3D = $Gate/Flap2
@onready var Flap3:MeshInstance3D = $Gate/Flap3
@onready var Flap4:MeshInstance3D = $Gate/Flap4

@export var room_type:int
		
@export var under_construction:bool = false 
@export var build_room:bool = false 	

@export var skip_animation:bool = false

const RoomRenderUnderConstructionMaterial:BaseMaterial3D = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/Structure3DContainer/Rendering/parts/WingRender/parts/RoomRender/textures/RoomRender_UnderConstruction.tres")
const RoomRenderBuiltMaterial:BaseMaterial3D = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/Structure3DContainer/Rendering/parts/WingRender/parts/RoomRender/textures/RoomRender_Built.tres")

var current_location:Dictionary
var camera_settings:Dictionary
var room_config:Dictionary

var use_omni_light:bool = false
var room_is_activated:bool = false
var assigned_location:Dictionary = {} : 
	set(val):
		assigned_location = val
		on_assigned_location_update()

# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)

func _ready() -> void:
	reset_to_default()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func reset_to_default() -> void:	
	SafetyLights.hide()
	on_under_construction_update(false, true)

func set_build_room(state:bool) -> void:
	await on_build_room_update()

func set_under_construction(state:bool) -> void:
	await on_under_construction_update(state)	

func set_texture(material:BaseMaterial3D) -> void:
	var mesh_duplicate:Mesh = RoomRender.mesh.duplicate()
	mesh_duplicate.surface_set_material(0, material.duplicate())
	RoomRender.mesh = mesh_duplicate	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func cancel_construction() -> void:
	await on_under_construction_update(false, false)
	under_construction = false
	build_room = false
	
func destroy_room() -> void:
	# set room render into place
	await U.tween_node_property(RoomRender, "position:y", -10.0)
	under_construction = false
	build_room = false
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_under_construction_update(state:bool, force_skip:bool = false, ignore_room_render:bool = false) -> void:
	under_construction = state
	if !is_node_ready():return
	var animation_speed:float = 0 if skip_animation or force_skip else 0.3
	
	# set texture
	set_texture(RoomRenderUnderConstructionMaterial)	
	
	# position room render
	if !ignore_room_render:
		RoomRender.position.y = 7.0

	# no animation
	if animation_speed == 0:
		if !ignore_room_render:
			RoomRender.show() if state else RoomRender.hide()
		SafetyLights.show() if state else SafetyLights.hide()
		Flap1.position.x = -13 if state else -4
		Flap2.position.x =  13 if state else 4
		Flap3.position.z = -13 if state else -4
		Flap4.position.z =  13 if state else 4
		SafetyGate.position.y = 0 if state else -1.3
		await U.tick()
		return
	
	# else animate...
	if state:
		if !ignore_room_render:
			RoomRender.show()
		SafetyLights.show()
		await U.tween_node_property(SafetyGate, "position:y", 1, animation_speed)
		for node in [ParticleEmitter, ConstructionOmniLight]:
			node.show()
	
	U.tween_node_property(Flap1, "position:x", -13 if state else -4, animation_speed)
	await U.tween_node_property(Flap2, "position:x", 13 if state else 4, animation_speed)
	U.tween_node_property(Flap3, "position:z", -13 if state else -4, animation_speed)
	await U.tween_node_property(Flap4, "position:z", 13 if state else 4, animation_speed)
	
	if !state:
		await U.tween_node_property(SafetyGate, "position:y", -1.3, animation_speed)		
		SafetyLights.hide()
		if !ignore_room_render:
			RoomRender.hide()
		for node in [ParticleEmitter, ConstructionOmniLight]:
			node.hide()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_build_room_update(force_skip:bool = false) -> void:
	build_room = true
	# already built, ignore	
	if !is_node_ready():return
	var animation_speed:float = 0 if skip_animation or force_skip else 0.3
	
	# no animation
	if animation_speed == 0:
		RoomRender.show() 
		RoomRender.position.y = 7.0
		
		# hide lights/emitters
		for node in [ParticleEmitter, ConstructionOmniLight]:
			node.hide()
			
		# set texture
		set_texture(RoomRenderBuiltMaterial)
		
		await U.tick()
		
	
	if under_construction:
		# set room render into place
		await U.tween_node_property(RoomRender, "position:y", -10.0, animation_speed)

		# hide construction and barrier
		await on_under_construction_update(false, force_skip, true)		
		
		# set texture
		set_texture(RoomRenderBuiltMaterial)
		
		# animate in
		RoomRender.show()
		await U.tween_node_property(RoomRender, "position:y", 7.0, animation_speed)

		for node in [ParticleEmitter, ConstructionOmniLight]:
			node.hide()	
		
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
	
	match camera_settings.type:
		# ----------------------
		CAMERA.TYPE.WING_SELECT:
			if under_construction:
				ConstructionOmniLight.show()
		# ----------------------
		CAMERA.TYPE.ROOM_SELECT:
			if under_construction:
				ConstructionOmniLight.hide()

func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if !is_node_ready() or room_config.is_empty():return
	U.debounce(str(self, "_update_room_data"), update_room_data)
	
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return
	U.debounce(str(self, "_update_room_data"), update_room_data)

func on_assigned_location_update() -> void:
	U.debounce(str(self, "_update_room_data"), update_room_data)
	
func update_room_data() -> void:
	if !is_node_ready() or room_config.is_empty() or current_location.is_empty() or assigned_location.is_empty():return
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(assigned_location)
	room_is_activated = ROOM_UTIL.is_room_activated(assigned_location)
	if room_is_activated:
		print('room update: ', room_extract)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var time:float = 0
var speed:float = 5.0
func _process(delta: float) -> void:
	if under_construction:
		time += delta
		var value:float = 3.0 + (8.0 - 3.0) * ((sin(time * speed) + 1.2) / 2.0)
		ConstructionOmniLight.light_energy = value
# ------------------------------------------------------------------------------
