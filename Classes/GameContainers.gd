@tool
extends Control
class_name GameContainer

@onready var TextureRectNode:TextureRect
@onready var Subviewport:SubViewport

var previous_freeze_state:bool

@export var freeze_inputs:bool = true : 
	set(val):
		previous_freeze_state = freeze_inputs
		freeze_inputs = val
		on_freeze_inputs_update()

@export var is_showing:bool = true : 
	set(val):
		is_showing = val
		on_is_showing_update()

const is_container:bool = true

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_process(self)
	
func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)

func _ready() -> void:
	on_freeze_inputs_update()
	on_is_showing_update(0)
# ------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_is_showing_update(speed:float = 0.7) -> void:
	if !is_showing:
		freeze_inputs = true
	else:
		freeze_inputs = previous_freeze_state
			
	if is_node_ready() and TextureRectNode != null:
		TextureRectNode.material.set_shader_parameter('angle_degrees', 0 if is_showing else 180)
		tween_percent(speed)
	
func tween_percent(speed) -> void:
	var tween:Tween = create_tween()
	if is_showing:
		tween.tween_method(set_percent, 0.0, 1.0, speed)
	else:
		tween.tween_method(set_percent, 1.0, 0.0, speed)

func set_percent(percentage: float) -> void:
	TextureRectNode.material.set_shader_parameter('percentage', percentage)
# --------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func on_freeze_inputs_update() -> void:
	pass
	
func _on_subviewport_child_changed() -> void:
	if Engine.is_editor_hint() and Subviewport != null:
		Subviewport.size = Subviewport.get_child(0).size
# ------------------------------------------------------------------------------	
