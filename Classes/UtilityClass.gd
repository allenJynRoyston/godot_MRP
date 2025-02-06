extends Node
class_name UtilityWrapper

var room_config:Dictionary 
var scp_data:Dictionary
var progress_data:Dictionary
var camera_settings:Dictionary
var current_location:Dictionary
var base_states:Dictionary
var resources_data:Dictionary 
var tier_unlocked:Dictionary 
var researcher_hire_list:Array
var action_queue_data:Array
var purchased_facility_arr:Array 
var purchased_base_arr:Array
var purchased_research_arr:Array 
var bookmarked_rooms:Array 
var unavailable_rooms:Array 
var hired_lead_researchers_arr:Array	

func _init() -> void:
	SUBSCRIBE.subscribe_to_progress_data(self)
	SUBSCRIBE.subscribe_to_action_queue_data(self)
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_tier_unlocked(self)
	SUBSCRIBE.subscribe_to_researcher_hire_list(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_purchased_research_arr(self)
	SUBSCRIBE.subscribe_to_purchased_base_arr(self)
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)
	SUBSCRIBE.subscribe_to_current_location(self)	
	SUBSCRIBE.subscribe_to_scp_data(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_progress_data(self)
	SUBSCRIBE.unsubscribe_to_action_queue_data(self)
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_tier_unlocked(self)
	SUBSCRIBE.unsubscribe_to_researcher_hire_list(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_purchased_research_arr(self)
	SUBSCRIBE.unsubscribe_to_purchased_base_arr(self)
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_scp_data(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)
	
	
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
func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	hired_lead_researchers_arr = new_val
func on_tier_unlocked_update(new_val:Dictionary) -> void:
	tier_unlocked = new_val
func on_purchased_research_arr_update(new_val:Array) -> void:
	purchased_research_arr = new_val
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
