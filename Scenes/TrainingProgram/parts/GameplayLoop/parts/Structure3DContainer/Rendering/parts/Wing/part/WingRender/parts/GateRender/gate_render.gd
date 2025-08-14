@tool
extends Node3D

@onready var Flap1:MeshInstance3D = $Flap1
@onready var Flap2:MeshInstance3D = $Flap2
@onready var Flap3:MeshInstance3D = $Flap3
@onready var Flap4:MeshInstance3D = $Flap4

@onready var SafetyGate:MeshInstance3D = $SafetyGate
@onready var ConstructionMesh:CSGBox3D = $ConstructionMesh
@onready var ConstructionOmniLight:OmniLight3D = $ConstructionMesh/OmniLight3D
@onready var ConstructionLights:Node3D = $ConstructionMesh/ConstructionLights
@onready var ParticleEmitter:GPUParticles3D = $ConstructionMesh/GPUParticles3D

@export var open_flaps:bool = false : 
	set(val):
		open_flaps = val
		on_open_flaps_update()
		
@export var raise_gate:bool = false : 
	set(val):
		raise_gate = val
		on_raise_gate_update()		
		
var raise_gates_complete:bool = false

var animation_speed:float = 1.0
		
func _ready() -> void:	
	on_open_flaps_update()
	on_raise_gate_update()
	
func on_open_flaps_update() -> void:
	if !is_node_ready():return
	
	if open_flaps:
		if animation_speed == 0:
			Flap1.position.x = -13 if open_flaps else -4
			Flap2.position.x =  13 if open_flaps else 4
			Flap3.position.z = -13 if open_flaps else -4
			Flap4.position.z =  13 if open_flaps else 4
		else:
			U.tween_node_property(Flap1, "position:x", -13 if open_flaps else -4)
			await U.tween_node_property(Flap2, "position:x", 13 if open_flaps else 4)
			U.tween_node_property(Flap3, "position:z", -13 if open_flaps else -4)
			await U.tween_node_property(Flap4, "position:z", 13 if open_flaps else 4)	
		
	else:
		if animation_speed == 0:
			Flap1.position.x = -13 if open_flaps else -4
			Flap2.position.x =  13 if open_flaps else 4
			Flap3.position.z = -13 if open_flaps else -4
			Flap4.position.z =  13 if open_flaps else -4
		else:
			U.tween_node_property(Flap3, "position:z", -13 if open_flaps else -4)
			await U.tween_node_property(Flap4, "position:z", 13 if open_flaps else 4)	
			U.tween_node_property(Flap1, "position:x", -13 if open_flaps else -4)
			await U.tween_node_property(Flap2, "position:x", 13 if open_flaps else 4)		
		
func on_raise_gate_update() -> void:
	if !is_node_ready():return
	if !raise_gate:
		ParticleEmitter.hide()
		ConstructionOmniLight.hide()
		ConstructionLights.hide()
		raise_gates_complete = false
	
	if animation_speed == 0:
		SafetyGate.position.y = 2 if raise_gate else -1
		ConstructionMesh.position.y =  0 if raise_gate else -15
	
	else:
		await U.tween_node_property(SafetyGate, "position:y", 2 if raise_gate else -1, animation_speed)
		await U.set_timeout(0.2)
		await U.tween_node_property(ConstructionMesh, "position:y", 0 if raise_gate else -15, animation_speed)
		await U.set_timeout(0.5)
		
	if raise_gate:
		ParticleEmitter.show()
		ConstructionOmniLight.show()
		ConstructionLights.show()
		raise_gates_complete = true


# Base attenuation settings
const start_base_attenuation:float = 1.0
const end_base_attenuation:float = 4.0  # Gets dimmer over time
const cooldown_duration:float = 4.0

# Flash intensity
const min_intensity:float = -1.5
const max_intensity:float = -0.8

# Flash timing
const min_flash_duration:float = 0.05
const max_flash_duration:float = 0.2
const min_gap:float = 0.2
const max_gap:float = 2.0

# Cooldown tracking
var current_cooldown:float = 0.0
var base_attenuation:float = start_base_attenuation

# Light control
var flash_timer:float = 0.0
var gap_timer:float = 0.0
var is_flashing:bool = false
var current_attenuation:float = 1.0
var attenuation_lerp_speed:float = 1.0  # Speed of fading toward base

func _process(delta: float) -> void:
	if raise_gate and raise_gates_complete:
		# Update base attenuation as cooldown builds
		current_cooldown = min(current_cooldown + delta, cooldown_duration)
		var t:float = current_cooldown / cooldown_duration
		base_attenuation = lerp(start_base_attenuation, end_base_attenuation, t)

		if is_flashing:
			ParticleEmitter.emitting = true
			flash_timer -= delta
			if flash_timer <= 0.0:
				is_flashing = false
				gap_timer = randf_range(min_gap, max_gap)
		else:
			gap_timer -= delta
			if gap_timer <= 0.0:
				ParticleEmitter.emitting = false
				is_flashing = true
				flash_timer = randf_range(min_flash_duration, max_flash_duration)
				current_attenuation = randf_range(min_intensity, max_intensity)

		# 🔄 Smoothly fade toward base attenuation when not flashing
		if !is_flashing:
			current_attenuation = lerp(current_attenuation, base_attenuation, delta * attenuation_lerp_speed)

		# Apply to light
		ConstructionOmniLight.omni_attenuation = current_attenuation				
		return
