@tool
extends Node


# ------------------------------------------------------------	
var camera_settings_subscriptions:Array = []

var camera_settings:Dictionary = {} : 
	set(val):
		camera_settings = val
		for node in camera_settings_subscriptions:
			if "on_camera_settings_update" in node:
				node.on_camera_settings_update.call(camera_settings)

func subscribe_to_camera_settings(node:Node) -> void:
	if node not in camera_settings_subscriptions:
		camera_settings_subscriptions.push_back(node)
		if "on_camera_settings_update" in node:
			node.on_camera_settings_update.call(camera_settings)

func unsubscribe_to_camera_settings(node:Node) -> void:
	camera_settings_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var suppress_click_subscriptions:Array = []

var suppress_click:bool = false : 
	set(val):
		suppress_click = val
		for node in suppress_click_subscriptions:
			if "on_suppress_click_update" in node:
				node.on_suppress_click_update.call(suppress_click)

func subscribe_to_suppress_click(node:Node) -> void:
	if node not in suppress_click_subscriptions:
		suppress_click_subscriptions.push_back(node)
		if "on_suppress_click_update" in node:
			node.on_suppress_click_update.call(suppress_click)

func unsubscribe_to_suppress_click(node:Node) -> void:
	suppress_click_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var tier_unlocked_subscriptions:Array = []

var tier_unlocked:Dictionary = {} : 
	set(val):
		tier_unlocked = val
		for node in tier_unlocked_subscriptions:
			if "on_tier_unlocked_update" in node:
				node.on_tier_unlocked_update.call(tier_unlocked)

func subscribe_to_tier_unlocked(node:Node) -> void:
	if node not in tier_unlocked_subscriptions:
		tier_unlocked_subscriptions.push_back(node)
		if "on_tier_unlocked_update" in node:
			node.on_tier_unlocked_update.call(tier_unlocked)
			
func unsubscribe_to_tier_unlocked(node:Node) -> void:
	tier_unlocked_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------
var progress_data_subscriptions:Array = []

var progress_data:Dictionary = {} : 
	set(val):
		progress_data = val
		for node in progress_data_subscriptions:
			if "on_progress_data_update" in node:
				node.on_progress_data_update.call(progress_data)

func subscribe_to_progress_data(node:Node) -> void:
	if node not in progress_data_subscriptions:
		progress_data_subscriptions.push_back(node)
		if "on_progress_data_update" in node:
			node.on_progress_data_update.call(progress_data)
			
func unsubscribe_to_progress_data(node:Node) -> void:
	progress_data_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------
var resources_data_subscriptions:Array = []

var resources_data:Dictionary = {} : 
	set(val):
		resources_data = val
		for node in resources_data_subscriptions:
			if "on_resources_data_update" in node:
				node.on_resources_data_update.call(resources_data)

func subscribe_to_resources_data(node:Node) -> void:
	if node not in resources_data_subscriptions:
		resources_data_subscriptions.push_back(node)
		if "on_resources_data_update" in node:
			node.on_resources_data_update.call(resources_data)
	
func unsubscribe_to_resources_data(node:Node) -> void:
	resources_data_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var action_queue_data_subscriptions:Array = []

var action_queue_data:Array = [] : 
	set(val):
		action_queue_data = val
		for node in action_queue_data_subscriptions:
			if "on_action_queue_data_update" in node:
				node.on_action_queue_data_update.call(action_queue_data)

func subscribe_to_action_queue_data(node:Node) -> void:
	if node not in action_queue_data_subscriptions:
		action_queue_data_subscriptions.push_back(node)
		if "on_action_queue_data_update" in node:
			node.on_action_queue_data_update.call(action_queue_data)
				
func unsubscribe_to_action_queue_data(node:Node) -> void:
	action_queue_data_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var purchased_research_list_subscriptions:Array = []

var purchased_research_arr:Array = [] : 
	set(val):
		purchased_research_arr = val
		for node in purchased_research_list_subscriptions:
			if "on_purchased_research_arr_update" in node:
				node.on_purchased_research_arr_update.call(purchased_research_arr)

func subscribe_to_purchased_research_arr(node:Node) -> void:
	if node not in purchased_research_list_subscriptions:
		purchased_research_list_subscriptions.push_back(node)
		if "on_purchased_research_arr_update" in node:
			node.on_purchased_research_arr_update.call(purchased_research_arr)

func unsubscribe_to_purchased_research_arr(node:Node) -> void:
	purchased_research_list_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var purchased_facility_arr_subscriptions:Array = []

var purchased_facility_arr:Array = [] : 
	set(val):
		purchased_facility_arr = val
		for node in purchased_facility_arr_subscriptions:
			if "on_purchased_facility_arr_update" in node:
				node.on_purchased_facility_arr_update.call(purchased_facility_arr)

func subscribe_to_purchased_facility_arr(node:Node) -> void:
	if node not in purchased_facility_arr_subscriptions:
		purchased_facility_arr_subscriptions.push_back(node)
		if "on_purchased_facility_arr_update" in node:
			node.on_purchased_facility_arr_update.call(purchased_facility_arr)

func unsubscribe_to_purchased_facility_arr(node:Node) -> void:
	purchased_facility_arr_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var purchased_base_arr_subscriptions:Array = []

var purchased_base_arr:Array = [] : 
	set(val):
		purchased_base_arr = val
		for node in purchased_base_arr_subscriptions:
			if "on_purchased_base_arr_update" in node:
				node.on_purchased_base_arr_update.call(purchased_base_arr)

func subscribe_to_purchased_base_arr(node:Node) -> void:
	if node not in purchased_base_arr_subscriptions:
		purchased_base_arr_subscriptions.push_back(node)
		if "on_purchased_base_arr_update" in node:
			node.on_purchased_base_arr_update.call(purchased_base_arr)

func unsubscribe_to_purchased_base_arr(node:Node) -> void:
	purchased_base_arr_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var hired_lead_researchers_arr_subscriptions:Array = []

var hired_lead_researchers_arr:Array = [] : 
	set(val):
		hired_lead_researchers_arr = val
		for node in hired_lead_researchers_arr_subscriptions:
			if "on_hired_lead_researchers_arr_update" in node:
				node.on_hired_lead_researchers_arr_update.call(hired_lead_researchers_arr)

func subscribe_to_hired_lead_researchers_arr(node:Node) -> void:
	if node not in hired_lead_researchers_arr_subscriptions:
		hired_lead_researchers_arr_subscriptions.push_back(node)
		if "on_hired_lead_researchers_arr_update" in node:
			node.on_hired_lead_researchers_arr_update.call(hired_lead_researchers_arr)
				
func unsubscribe_to_hired_lead_researchers_arr(node:Node) -> void:
	hired_lead_researchers_arr_subscriptions.erase(node)
# ------------------------------------------------------------	


# ------------------------------------------------------------	
var current_location_subscriptions:Array = []

var current_location:Dictionary = {} : 
	set(val):
		current_location = val
		for node in current_location_subscriptions:
			if "on_current_location_update" in node:
				node.on_current_location_update.call(current_location)

func subscribe_to_current_location(node:Node) -> void:
	if node not in current_location_subscriptions:
		current_location_subscriptions.push_back(node)
		if "on_current_location_update" in node:
			node.on_current_location_update.call(current_location)
			
func unsubscribe_to_current_location(node:Node) -> void:
	current_location_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var built_rooms_subscriptions:Array = []

var built_rooms:Array = [] : 
	set(val):
		built_rooms = val
		for node in built_rooms_subscriptions:
			if "on_built_rooms_update" in node:
				node.on_built_rooms_update.call(built_rooms)

func subscribe_to_built_rooms(node:Node) -> void:
	if node not in built_rooms_subscriptions:
		built_rooms_subscriptions.push_back(node)
		if "on_built_rooms_update" in node:
			node.on_built_rooms_update.call(built_rooms)
				
func unsubscribe_to_built_rooms(node:Node) -> void:
	built_rooms_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var under_construction_rooms_subscriptions:Array = []

var under_construction_rooms:Array = [] : 
	set(val):
		under_construction_rooms = val
		for node in under_construction_rooms_subscriptions:
			if "on_under_construction_rooms_update" in node:
				node.on_under_construction_rooms_update.call(under_construction_rooms)

func subscribe_to_under_construction_rooms(node:Node) -> void:
	if node not in under_construction_rooms_subscriptions:
		under_construction_rooms_subscriptions.push_back(node)
		if "on_under_construction_rooms_update" in node:
			node.on_under_construction_rooms_update.call(under_construction_rooms)
				
func unsubscribe_to_under_construction_rooms(node:Node) -> void:
	under_construction_rooms_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var unavailable_rooms_subscriptions:Array = []

var unavailable_rooms:Array = [] : 
	set(val):
		unavailable_rooms = val
		for node in unavailable_rooms_subscriptions:
			if "on_unavailable_rooms_update" in node:
				node.on_unavailable_rooms_update.call(unavailable_rooms)

func subscribe_to_unavailable_rooms(node:Node) -> void:
	if node not in unavailable_rooms_subscriptions:
		unavailable_rooms_subscriptions.push_back(node)
		if "on_unavailable_rooms_update" in node:
			node.on_unavailable_rooms_update.call(unavailable_rooms)
				
func unsubscribe_to_unavailable_rooms(node:Node) -> void:
	unavailable_rooms_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var bookmarked_rooms_subscriptions:Array = []

var bookmarked_rooms:Array = [] : 
	set(val):
		bookmarked_rooms = val
		for node in bookmarked_rooms_subscriptions:
			if "on_bookmarked_rooms_update" in node:
				node.on_bookmarked_rooms_update.call(bookmarked_rooms)

func subscribe_to_bookmarked_rooms(node:Node) -> void:
	if node not in bookmarked_rooms_subscriptions:
		bookmarked_rooms_subscriptions.push_back(node)
		if "on_bookmarked_rooms_update" in node:
			node.on_bookmarked_rooms_update.call(bookmarked_rooms)
				
func unsubscribe_to_bookmarked_rooms(node:Node) -> void:
	bookmarked_rooms_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var researcher_hire_list_subscriptions:Array = []

var researcher_hire_list:Array = [] : 
	set(val):
		researcher_hire_list = val
		for node in researcher_hire_list_subscriptions:
			if "on_researcher_hire_list_update" in node:
				node.on_researcher_hire_list_update.call(researcher_hire_list)

func subscribe_to_researcher_hire_list(node:Node) -> void:
	if node not in researcher_hire_list_subscriptions:
		researcher_hire_list_subscriptions.push_back(node)
		if "on_researcher_hire_list_update" in node:
			node.on_researcher_hire_list_update.call(researcher_hire_list)	
			
func unsubscribe_to_researcher_hire_list(node:Node) -> void:
	researcher_hire_list_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var room_config_subscriptions:Array = [] 

var room_config:Dictionary = {} : 
	set(val):
		room_config = val
		for node in room_config_subscriptions:
			if "on_room_config_update" in node:
				node.on_room_config_update.call(room_config)

func subscribe_to_room_config(node:Node) -> void:
	if node not in room_config_subscriptions:
		room_config_subscriptions.push_back(node)
		if "on_room_config_update" in node:
			node.on_room_config_update.call(room_config)
			
func unsubscribe_to_room_config(node:Node) -> void:
	room_config_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var scp_data_subscriptions:Array = []

var scp_data:Dictionary = {} : 
	set(val):
		scp_data = val 
		for node in scp_data_subscriptions:
			if "on_scp_data_update" in node:
				node.on_scp_data_update.call(scp_data)
				
func subscribe_to_scp_data(node:Node) -> void:
	if node not in scp_data_subscriptions:
		scp_data_subscriptions.push_back(node)
		if "on_scp_data_update" in node:
			node.on_scp_data_update.call(scp_data)
			
func unsubscribe_to_scp_data(node:Node) -> void:
	room_config_subscriptions.erase(node)				
# ------------------------------------------------------------	
