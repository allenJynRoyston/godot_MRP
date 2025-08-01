@tool
extends Node3D

@onready var SpinLightMesh:MeshInstance3D = $SpinLightMesh
@onready var Spotlight:SpotLight3D = $SpotLight3D

@export var blink_speed:float = 1.0


func _ready() -> void:
	pass

var time: float = 0.0
var is_light_on: bool = true

func _process(delta: float) -> void:
	if !is_node_ready() or !is_visible_in_tree():return
	var blink_offset:float = randf_range(0.9, 1.1)  # Random offset for blink timing
	
	time += delta

	# Blink logic (square wave)
	if time >= (blink_speed * blink_offset):
		time = 0.0
		is_light_on = !is_light_on  # Toggle light on/off

	# Apply light state
	Spotlight.light_energy = 3.0 if is_light_on else 0.0
