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
		
var GameplayNode:Control 

var resources_data:Dictionary = {} 
var purchased_facility_arr:Array = [] 
var purchased_base_arr:Array = []
var bookmarked_rooms:Array = [] 
var bookmarked_objectives:Array = []
var hired_lead_researchers_arr:Array = [] 
var current_location:Dictionary = {} 
var progress_data:Dictionary = {}
var timeline_array:Array = [] 
var room_config:Dictionary = {} 
var researcher_hire_list:Array = [] 
var shop_unlock_purchases:Array = []
var purchased_research_arr:Array = []
var suppress_click:bool = false 
var camera_settings:Dictionary = {}
var scp_data:Dictionary = {}
var base_states:Dictionary = {}
var gameplay_conditionals:Dictionary

var control_pos_default:Dictionary
var control_pos:Dictionary
var animation_speed:float = 0.0 if !Engine.is_editor_hint() else 0.3
var initalized_at_fullscreen:bool
var unavailable_rooms:Array = []

const is_container:bool = true

signal user_response
signal hide_complete

# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_progress_data(self)
	SUBSCRIBE.subscribe_to_timeline_array(self)
	SUBSCRIBE.subscribe_to_bookmarked_rooms(self)
	SUBSCRIBE.subscribe_to_bookmarked_objectives(self)	
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_researcher_hire_list(self)
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_shop_unlock_purchases(self)
	SUBSCRIBE.subscribe_to_purchased_research_arr(self)
	SUBSCRIBE.subscribe_to_suppress_click(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	SUBSCRIBE.subscribe_to_purchased_base_arr(self)
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	SUBSCRIBE.subscribe_to_scp_data(self)
	SUBSCRIBE.subscribe_to_gameplay_conditionals(self)
	SUBSCRIBE.subscribe_to_unavailable_rooms(self)
	
	GBL.subscribe_to_control_input(self)
	GBL.subscribe_to_process(self)
	GBL.subscribe_to_fullscreen(self)
	freeze_inputs = false	
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_progress_data(self)
	SUBSCRIBE.unsubscribe_to_timeline_array(self)
	SUBSCRIBE.unsubscribe_to_bookmarked_rooms(self)
	SUBSCRIBE.unsubscribe_to_bookmarked_objectives(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_researcher_hire_list(self)
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_shop_unlock_purchases(self)
	SUBSCRIBE.unsubscribe_to_purchased_research_arr(self)
	SUBSCRIBE.unsubscribe_to_suppress_click(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)
	SUBSCRIBE.unsubscribe_to_purchased_base_arr(self)
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)
	SUBSCRIBE.unsubscribe_to_scp_data(self)
	SUBSCRIBE.unsubscribe_to_gameplay_conditionals(self)
	SUBSCRIBE.unsubscribe_to_unavailable_rooms(self)

	GBL.unsubscribe_to_control_input(self)
	GBL.unsubscribe_to_process(self)
	GBL.unsubscribe_to_fullscreen(self)

func _ready() -> void:
	if Engine.is_editor_hint():
		is_showing = true
	on_freeze_inputs_update()
	on_is_showing_update()
	GameplayNode = GBL.find_node(REFS.GAMEPLAY_LOOP) 
	GBL.initalized_at_fullscreen = GBL.is_fullscreen

func activate() -> void:
	pass

func on_fullscreen_update(state:bool):pass
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
func on_timeline_array_update(new_val:Array) -> void:
	timeline_array = new_val
func on_bookmarked_rooms_update(new_val:Array) -> void:
	bookmarked_rooms = new_val
func on_bookmarked_objectives_update(new_val:Array) -> void:
	bookmarked_objectives = new_val	
func on_researcher_hire_list_update(new_val:Array) -> void:
	researcher_hire_list = new_val
func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	hired_lead_researchers_arr = new_val
func on_shop_unlock_purchases_update(new_val:Array) -> void:
	shop_unlock_purchases = new_val
func on_purchased_research_arr_update(new_val:Array) -> void:
	purchased_research_arr = new_val
func on_suppress_click_update(new_val:bool) -> void:
	suppress_click = new_val
func on_camera_settings_update(new_val:Dictionary) -> void:
	camera_settings = new_val
func on_purchased_base_arr_update(new_val:Array) -> void:
	purchased_base_arr = new_val	
func on_purchased_facility_arr_update(new_val:Array) -> void:
	purchased_facility_arr = new_val
func on_scp_data_update(new_val:Dictionary) -> void:
	scp_data = new_val
func on_base_states_update(new_val:Dictionary) -> void:
	base_states = new_val
func on_gameplay_conditionals_update(new_val:Dictionary) -> void:
	gameplay_conditionals = new_val
func on_unavailable_rooms_update(new_val:Array) -> void:
	unavailable_rooms = new_val
	
func on_reset() -> void:pass
func on_freeze_inputs_update() -> void:pass
# ------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_is_showing_update() -> void:	
	freeze_inputs = !is_showing
	show() if is_showing else hide()
	
func tween_percent() -> void:
	var tween:Tween = create_tween()
	if is_showing:
		#show()
		tween.tween_method(set_percent, 0.0, 1.0, animation_speed)
	else:
		tween.tween_method(set_percent, 1.0, 0.0, animation_speed)
		await tween.finished
		#if !Engine.is_editor_hint():
			#hide()

func set_percent(percentage: float) -> void:
	TextureRectNode.material.set_shader_parameter('percentage', percentage)
# --------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func _on_subviewport_child_changed() -> void:
	if Subviewport != null and Subviewport.get_child_count() > 0:
		await U.tick()
		if Vector2i(Subviewport.size) != Vector2i(Subviewport.get_child(0).size):
			Subviewport.size = Subviewport.get_child(0).size
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:pass
# ------------------------------------------------------------------------------
#endregion
