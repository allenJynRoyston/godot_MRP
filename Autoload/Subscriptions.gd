@tool
extends Node

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

func unsubscribe_to_purchased_research_arr(node:Node) -> void:
	purchased_research_list_subscriptions.erase(node)
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
	
func unsubscribe_to_action_queue_data(node:Node) -> void:
	action_queue_data_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var facility_room_data_subscriptions:Array = []

var facility_room_data:Array = [] : 
	set(val):
		facility_room_data = val
		for node in facility_room_data_subscriptions:
			if "on_facility_room_data_update" in node:
				node.on_facility_room_data_update.call(facility_room_data)

func subscribe_to_facility_room_data(node:Node) -> void:
	if node not in facility_room_data_subscriptions:
		facility_room_data_subscriptions.push_back(node)
	
func unsubscribe_to_facility_room_data(node:Node) -> void:
	facility_room_data_subscriptions.erase(node)
# ------------------------------------------------------------	


# ------------------------------------------------------------	
var lead_researchers_data_subscriptions:Array = []

var lead_researchers_data:Array = [] : 
	set(val):
		lead_researchers_data = val
		for node in lead_researchers_data_subscriptions:
			if "on_lead_researchers_data_update" in node:
				node.on_lead_researchers_data_update.call(lead_researchers_data)

func subscribe_to_lead_researchers_data(node:Node) -> void:
	if node not in lead_researchers_data_subscriptions:
		lead_researchers_data_subscriptions.push_back(node)
	
func unsubscribe_to_lead_researchers_data(node:Node) -> void:
	lead_researchers_data_subscriptions.erase(node)
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
	if node not in lead_researchers_data_subscriptions:
		current_location_subscriptions.push_back(node)
	
func unsubscribe_to_current_location(node:Node) -> void:
	current_location_subscriptions.erase(node)
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
	
func unsubscribe_to_room_config(node:Node) -> void:
	room_config_subscriptions.erase(node)
# ------------------------------------------------------------	
