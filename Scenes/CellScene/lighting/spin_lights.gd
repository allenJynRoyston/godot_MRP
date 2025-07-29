@tool
extends Node3D

@onready var OmniLight:OmniLight3D = $OmniLight3D
@onready var SpotOne:SpotLight3D = $OmniLight3D/SpotLight3D
@onready var SpotTwo:SpotLight3D = $OmniLight3D/SpotLight3D2

@onready var spin_speed:float = 0.2

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if !is_node_ready() or !is_visible_in_tree():return
	OmniLight.rotate_y(spin_speed)
