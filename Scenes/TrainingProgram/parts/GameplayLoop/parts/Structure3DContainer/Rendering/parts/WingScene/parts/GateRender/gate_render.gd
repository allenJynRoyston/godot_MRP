@tool
extends Node3D

@onready var Flap1:MeshInstance3D = $Flap1
@onready var Flap2:MeshInstance3D = $Flap2
@onready var Flap3:MeshInstance3D = $Flap3
@onready var Flap4:MeshInstance3D = $Flap4

@onready var SafetyGate:MeshInstance3D = $SafetyGate

@export var open_flaps:bool = false : 
	set(val):
		open_flaps = val
		on_open_flaps_update()
		
@export var raise_gate:bool = false : 
	set(val):
		raise_gate = val
		on_raise_gate_update()		
		
func _ready() -> void:
	on_open_flaps_update()
	on_raise_gate_update()
	
func on_open_flaps_update() -> void:
	if !is_node_ready():return
	
	if open_flaps:
		U.tween_node_property(Flap1, "position:x", -13 if open_flaps else -4)
		await U.tween_node_property(Flap2, "position:x", 13 if open_flaps else 4)
		U.tween_node_property(Flap3, "position:z", -13 if open_flaps else -4)
		await U.tween_node_property(Flap4, "position:z", 13 if open_flaps else 4)	
		
	else:
		U.tween_node_property(Flap3, "position:z", -13 if open_flaps else -4)
		await U.tween_node_property(Flap4, "position:z", 13 if open_flaps else 4)	
		U.tween_node_property(Flap1, "position:x", -13 if open_flaps else -4)
		await U.tween_node_property(Flap2, "position:x", 13 if open_flaps else 4)		
		
func on_raise_gate_update() -> void:
	if !is_node_ready():return
	await U.tween_node_property(SafetyGate, "position:y", 2 if raise_gate else -1)
