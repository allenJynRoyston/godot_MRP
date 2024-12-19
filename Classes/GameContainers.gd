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
		
var progress_data:Dictionary = {} : 
	set(val):
		progress_data = val
		on_progress_data_update()

var resources_data:Dictionary = {} : 
	set(val):
		resources_data = val	
		on_resources_data_update()

var facility_room_data:Array = [] : 
	set(val):
		facility_room_data = val
		on_facility_room_data_update()

var action_queue_data:Array = [] : 
	set(val):
		action_queue_data = val	
		on_action_queue_data_update()

var current_location:Dictionary = {} : 
	set(val):
		current_location = val
		on_current_location_update()
		
var room_config:Dictionary = {} : 
	set(val):
		room_config = val
		on_room_config_update()

var animation_speed:float = 0.0 if !Engine.is_editor_hint() else 0.3
var structure_node:Control

const is_container:bool = true

signal user_response

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)
	GBL.subscribe_to_process(self)
	freeze_inputs = false	
	
func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)
	GBL.unsubscribe_to_process(self)

func _ready() -> void:
	if Engine.is_editor_hint():
		is_showing = true
	on_freeze_inputs_update()
	on_is_showing_update()
	
	on_resources_data_update()
	on_action_queue_data_update()
	on_facility_room_data_update()
	on_progress_data_update()
	on_current_location_update()
	on_room_config_update()
	
	structure_node = GBL.find_node(REFS.STRUCTURE_3D)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_resources_data_update() -> void:pass
func on_action_queue_data_update() -> void:pass
func on_facility_room_data_update() -> void:pass
func on_progress_data_update() -> void:pass
func on_reset() -> void:pass
func on_freeze_inputs_update() -> void:pass
func on_current_location_update() -> void:pass
func on_room_config_update() -> void:pass
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
func _on_subviewport_child_changed() -> void:
	if Subviewport != null and Subviewport.get_child_count() > 0:
		Subviewport.size = Subviewport.get_child(0).size
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:pass
# ------------------------------------------------------------------------------
#endregion
