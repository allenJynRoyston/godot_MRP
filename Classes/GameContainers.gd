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
		

var resources_data:Dictionary = {} 
var facility_room_data:Array = [] 
var bookmarked_rooms:Array = [] 
var lead_researchers_data:Array = [] 
var current_location:Dictionary = {} 
var progress_data:Dictionary = {}
var action_queue_data:Array = [] 
var room_config:Dictionary = {} 
var researcher_hire_list:Array = [] 
var tier_unlocked:Dictionary = {}

var animation_speed:float = 0.0 if !Engine.is_editor_hint() else 0.3

const is_container:bool = true

signal user_response

# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_progress_data(self)
	SUBSCRIBE.subscribe_to_action_queue_data(self)
	SUBSCRIBE.subscribe_to_bookmarked_rooms(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_researcher_hire_list(self)
	SUBSCRIBE.subscribe_to_lead_researchers_data(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_tier_unlocked(self)
	
	GBL.subscribe_to_control_input(self)
	GBL.subscribe_to_process(self)
	freeze_inputs = false	
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_progress_data(self)
	SUBSCRIBE.unsubscribe_to_action_queue_data(self)
	SUBSCRIBE.unsubscribe_to_bookmarked_rooms(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_researcher_hire_list(self)
	SUBSCRIBE.unsubscribe_to_lead_researchers_data(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_tier_unlocked(self)

	GBL.unsubscribe_to_control_input(self)
	GBL.unsubscribe_to_process(self)

func _ready() -> void:
	if Engine.is_editor_hint():
		is_showing = true
	on_freeze_inputs_update()
	on_is_showing_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_resources_data_update(new_val:Dictionary) -> void:
	resources_data = new_val
func on_progress_data_update(new_val:Dictionary) -> void:
	progress_data = new_val
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
func on_action_queue_data_update(new_val:Array) -> void:
	action_queue_data = new_val
func on_bookmarked_rooms_update(new_val:Array) -> void:
	bookmarked_rooms = new_val
func on_researcher_hire_list_update(new_val:Array) -> void:
	researcher_hire_list = new_val
func on_lead_researchers_data_update(new_val:Array) -> void:
	lead_researchers_data = new_val
func on_tier_unlocked_update(new_val:Dictionary) -> void:
	tier_unlocked = new_val
	
	
func on_reset() -> void:pass
func on_freeze_inputs_update() -> void:pass
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
