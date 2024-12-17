@tool
extends Control
class_name GameContainer

@onready var TextureRectNode:TextureRect
@onready var Subviewport:SubViewport

@export var is_showing:bool = true : 
	set(val):
		is_showing = val
		on_is_showing_update()

@export var freeze_inputs:bool = false : 
	set(val):
		freeze_inputs = val
		on_freeze_inputs_update()

var animation_speed:float = 0.0 if !Engine.is_editor_hint() else 0.3

const is_container:bool = true

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_process(self)
	freeze_inputs = false	
	
func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)

func _ready() -> void:
	print(is_showing)
	if Engine.is_editor_hint():
		is_showing = true
	on_freeze_inputs_update()
	on_is_showing_update()
# ------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_is_showing_update() -> void:	
	if is_node_ready() and TextureRectNode != null:
		TextureRectNode.material.set_shader_parameter('angle_degrees', 0 if is_showing else 180)
		tween_percent()
		freeze_inputs = !is_showing
	
func tween_percent() -> void:
	var tween:Tween = create_tween()
	if is_showing:
		show()
		tween.tween_method(set_percent, 0.0, 1.0, animation_speed)
	else:
		tween.tween_method(set_percent, 1.0, 0.0, animation_speed)
		await tween.finished
		if !Engine.is_editor_hint():
			hide()

func set_percent(percentage: float) -> void:
	TextureRectNode.material.set_shader_parameter('percentage', percentage)
# --------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func on_reset():pass

func on_freeze_inputs_update() -> void:
	pass
	
func _on_subviewport_child_changed() -> void:
	if Subviewport != null:
		Subviewport.size = Subviewport.get_child(0).size
# ------------------------------------------------------------------------------	
