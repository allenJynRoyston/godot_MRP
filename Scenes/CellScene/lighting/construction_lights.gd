@tool
extends Node3D

@onready var SpinLightMesh:MeshInstance3D = $SpinLightMesh
@onready var Spotlight:SpotLight3D = $SpotLight3D

@export var spin_speed:float = 0.2
@export var blink_speed:float = 1.0

func _ready() -> void:
	pass

var time: float = 0.0
var is_light_on: bool = true

func _process(delta: float) -> void:
	if !is_node_ready() or !is_visible_in_tree():
		return

	time += delta

	# Rotate the mesh
	SpinLightMesh.rotate_y(spin_speed * delta)

	# Blink logic (square wave)
	if time >= blink_speed:
		time = 0.0
		is_light_on = !is_light_on  # Toggle light on/off

	# Apply light state
	Spotlight.light_energy = 1.0 if is_light_on else 0.0
