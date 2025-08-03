extends Node
class_name SubscribeWrapper

var room_config:Dictionary 
var scp_data:Dictionary
var progress_data:Dictionary
var base_states:Dictionary
var camera_settings:Dictionary
var current_location:Dictionary
var gameplay_conditionals:Dictionary
var resources_data:Dictionary 
var shop_unlock_purchases:Array 
var researcher_hire_list:Array
var timeline_array:Array
var purchased_facility_arr:Array 
var purchased_base_arr:Array
var purchased_research_arr:Array 
var bookmarked_rooms:Array 
var unavailable_rooms:Array 
var hired_lead_researchers_arr:Array
var awarded_rooms:Array
var hints_unlocked:Array
var notes:Array 

var previous_floor:int = -1
var previous_ring:int = -1


func _init() -> void:
	SUBSCRIBE.subscribe_to_progress_data(self)
	SUBSCRIBE.subscribe_to_timeline_array(self)
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_shop_unlock_purchases(self)
	SUBSCRIBE.subscribe_to_researcher_hire_list(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_purchased_research_arr(self)
	SUBSCRIBE.subscribe_to_purchased_base_arr(self)
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)
	SUBSCRIBE.subscribe_to_current_location(self)	
	SUBSCRIBE.subscribe_to_scp_data(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	SUBSCRIBE.subscribe_to_gameplay_conditionals(self)
	SUBSCRIBE.subscribe_to_awarded_room(self)
	SUBSCRIBE.subscribe_to_hints_unlocked(self)
	SUBSCRIBE.subscribe_to_notes(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_progress_data(self)
	SUBSCRIBE.unsubscribe_to_timeline_array(self)
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_shop_unlock_purchases(self)
	SUBSCRIBE.unsubscribe_to_researcher_hire_list(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_purchased_research_arr(self)
	SUBSCRIBE.unsubscribe_to_purchased_base_arr(self)
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_scp_data(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)
	SUBSCRIBE.unsubscribe_to_gameplay_conditionals(self)
	SUBSCRIBE.unsubscribe_to_awarded_room(self)
	SUBSCRIBE.unsubscribe_to_hints_unlocked(self)
	SUBSCRIBE.unsubscribe_to_notes(self)
	
func on_resources_data_update(new_val:Dictionary) -> void:
	resources_data = new_val
	
func on_progress_data_update(new_val:Dictionary) -> void:
	progress_data = new_val
	
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if current_location.is_empty():return
	if previous_floor != current_location.floor:
		previous_floor = current_location.floor
		if !is_node_ready():return
		on_floor_changed()
		
	if previous_ring != current_location.ring:
		previous_ring = current_location.ring
		if !is_node_ready():return
		on_ring_changed()
	
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	
func on_timeline_array_update(new_val:Array) -> void:
	timeline_array = new_val
	
func on_bookmarked_rooms_update(new_val:Array) -> void:
	bookmarked_rooms = new_val
	
func on_researcher_hire_list_update(new_val:Array) -> void:
	researcher_hire_list = new_val
	
func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	hired_lead_researchers_arr = new_val
	
func on_shop_unlock_purchases_update(new_val:Array) -> void:
	shop_unlock_purchases = new_val
	
func on_purchased_research_arr_update(new_val:Array) -> void:
	purchased_research_arr = new_val
	
func on_hints_unlocked_update(new_val:Array) -> void:
	hints_unlocked = new_val	
	
func on_camera_settings_update(new_val:Dictionary) -> void:
	camera_settings = new_val
	
func on_purchased_base_arr_update(new_val:Array) -> void:
	purchased_base_arr = new_val	

func on_gameplay_conditionals_update(new_val:Dictionary) -> void:
	gameplay_conditionals = new_val
	
func on_purchased_facility_arr_update(new_val:Array) -> void:
	purchased_facility_arr = new_val
	
func on_scp_data_update(new_val:Dictionary) -> void:
	scp_data = new_val
	
func on_base_states_update(new_val:Dictionary) -> void:
	base_states = new_val	

func on_awarded_rooms_update(new_val:Array) -> void:
	awarded_rooms = new_val

func on_notes_update(new_val:Array) -> void:
	notes = new_val
	
func on_floor_changed() -> void:pass
func on_ring_changed() -> void:pass
func on_room_changed() -> void:pass
