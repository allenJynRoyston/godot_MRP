@tool
extends Node3D

@onready var SpinLightMesh:MeshInstance3D = $SpinLightMesh

@export var spin_speed:float = 0.2

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if !is_node_ready() or !is_visible_in_tree():return
	SpinLightMesh.rotate_y(spin_speed)
