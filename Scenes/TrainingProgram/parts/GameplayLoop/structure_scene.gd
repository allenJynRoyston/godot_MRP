extends Node3D

# ------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_process(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)
	
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_process_update(delta: float) -> void:
	$MeshInstance3D.rotate_y(0.01)
	$MeshInstance3D2.rotate_y(0.01)
# ------------------------------------------------
