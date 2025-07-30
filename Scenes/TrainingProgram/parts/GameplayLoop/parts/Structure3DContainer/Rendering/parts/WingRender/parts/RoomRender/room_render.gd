@tool
extends Node3D

@onready var RoomRender:MeshInstance3D = $RoomRender

@export var raise:bool = false : 
	set(val):
		raise = val
		on_raise_update()
		
func _ready() -> void:
	on_raise_update()
	
func on_raise_update() -> void:
	if !is_node_ready():return
	await U.tween_node_property(RoomRender, "position:y", 16 if raise else 0)
