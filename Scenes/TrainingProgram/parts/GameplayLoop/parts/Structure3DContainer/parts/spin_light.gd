extends Node3D

@onready var SpinLightMesh2:MeshInstance3D = $SpinLightMesh


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	SpinLightMesh2.rotate_y(0.1)
