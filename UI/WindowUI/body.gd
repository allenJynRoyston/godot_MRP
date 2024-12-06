extends Control

@export var freeze_inputs:bool = false : 
	set(val):
		freeze_inputs = val
		on_freeze_inputs_update()
		
# ------------------------------------------------		
func _ready() -> void:
	on_freeze_inputs_update()
# ------------------------------------------------	

# ------------------------------------------------
func on_freeze_inputs_update() -> void:
	if is_node_ready():
		modulate = Color(1, 1, 1, 0.7) if freeze_inputs else Color(1, 1, 1, 1)
# ------------------------------------------------	
