@tool
extends Node

# ------------------------------------------------------------	
var music_data_subscriptions:Array = []

var music_data:Dictionary = {} : 
	set(val): 
		music_data = val
		on_music_data_update()
		
func on_music_data_update() -> void:
	for node in music_data_subscriptions:
		if "on_music_data_update" in node:
			node.on_music_data_update.call( music_data )

func subscribe_to_music_player(node:Control) -> void:
	if node not in music_data_subscriptions:
		music_data_subscriptions.push_back(node)
		
func unsubscribe_to_music_player(node:Control) -> void:
	music_data_subscriptions.erase(node)
# ------------------------------------------------------------	


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
var shop_unlock_purchases_subscriptions:Array = []

var shop_unlock_purchases:Array = [] : 
	set(val):
		shop_unlock_purchases = val
		for node in shop_unlock_purchases_subscriptions:
			if "on_shop_unlock_purchases_update" in node:
				node.on_shop_unlock_purchases_update.call(shop_unlock_purchases)

func subscribe_to_shop_unlock_purchases(node:Node) -> void:
	if node not in shop_unlock_purchases_subscriptions:
		shop_unlock_purchases_subscriptions.push_back(node)
		if "on_shop_unlock_purchases_update" in node:
			node.on_shop_unlock_purchases_update.call(shop_unlock_purchases)
			
func unsubscribe_to_shop_unlock_purchases(node:Node) -> void:
	shop_unlock_purchases_subscriptions.erase(node)
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
var previous_current_location:Dictionary = {}

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
var bookmarked_objectives_subscriptions:Array = []

var bookmarked_objectives:Array = [] : 
	set(val):
		bookmarked_objectives = val
		for node in bookmarked_objectives_subscriptions:
			if "on_bookmarked_objectives_update" in node:
				node.on_bookmarked_objectives_update.call(bookmarked_objectives)

func subscribe_to_bookmarked_objectives(node:Node) -> void:
	if node not in bookmarked_objectives_subscriptions:
		bookmarked_objectives_subscriptions.push_back(node)
		if "on_bookmarked_objectives_update" in node:
			node.on_bookmarked_objectives_update.call(bookmarked_objectives)
				
func unsubscribe_to_bookmarked_objectives(node:Node) -> void:
	bookmarked_objectives_subscriptions.erase(node)
# ------------------------------------------------------------	



# ------------------------------------------------------------	
var awarded_rooms_subscriptions:Array = []

var awarded_rooms:Array = [] : 
	set(val):
		awarded_rooms = val
		for node in awarded_rooms_subscriptions:
			if "on_awarded_rooms_update" in node:
				node.on_awarded_rooms_update.call(awarded_rooms)

func subscribe_to_awarded_room(node:Node) -> void:
	if node not in awarded_rooms_subscriptions:
		awarded_rooms_subscriptions.push_back(node)
		if "on_awarded_rooms_update" in node:
			node.on_awarded_rooms_update.call(awarded_rooms)	
			
func unsubscribe_to_awarded_room(node:Node) -> void:
	awarded_rooms_subscriptions.erase(node)
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
var base_states_subscriptions:Array = [] 

var base_states:Dictionary = {} : 
	set(val):
		base_states = val
		for node in base_states_subscriptions:
			if "on_base_states_update" in node:
				node.on_base_states_update.call(base_states)

func subscribe_to_base_states(node:Node) -> void:
	if node not in base_states_subscriptions:
		base_states_subscriptions.push_back(node)
		if "on_base_states_update" in node:
			node.on_base_states_update.call(base_states)
			
func unsubscribe_to_base_states(node:Node) -> void:
	base_states_subscriptions.erase(node)
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

# ------------------------------------------------------------	
var menu_context_subscriptions:Array = []

var menu_context:Dictionary = {} :
	set(val):
		menu_context = val 
		for node in menu_context_subscriptions:
			if "on_menu_context_update" in node:
				node.on_menu_context_update.call(menu_context)	

func subscribe_to_menu_context(node:Node) -> void:
	if node not in menu_context_subscriptions:
		menu_context_subscriptions.push_back(node)
		if "on_menu_context_update" in node:
			node.on_menu_context_update.call(menu_context)
			
func unsubscribe_to_menu_context(node:Node) -> void:
	menu_context_subscriptions.erase(node)				
# ------------------------------------------------------------	
	
# ------------------------------------------------------------	
var timeline_array_subscriptions:Array = []

var timeline_array:Array = [] :
	set(val):
		timeline_array = val 
		for node in timeline_array_subscriptions:
			if "on_timeline_array_update" in node:
				node.on_timeline_array_update.call( timeline_array)	

func subscribe_to_timeline_array(node:Node) -> void:
	if node not in timeline_array_subscriptions:
		timeline_array_subscriptions.push_back(node)
		if "on_timeline_array_update" in node:
			node.on_timeline_array_update.call( timeline_array)
			
func unsubscribe_to_timeline_array(node:Node) -> void:
	timeline_array_subscriptions.erase(node)				
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var gameplay_conditionals_subscriptions:Array = []

var gameplay_conditionals:Dictionary = {} :
	set(val):
		gameplay_conditionals = val 
		for node in gameplay_conditionals_subscriptions:
			if "on_gameplay_conditionals_update" in node:
				node.on_gameplay_conditionals_update.call( gameplay_conditionals)	

func subscribe_to_gameplay_conditionals(node:Node) -> void:
	if node not in gameplay_conditionals_subscriptions:
		gameplay_conditionals_subscriptions.push_back(node)
		if "on_gameplay_conditionals_update" in node:
			node.on_gameplay_conditionals_update.call( gameplay_conditionals)
			
func unsubscribe_to_gameplay_conditionals(node:Node) -> void:
	gameplay_conditionals_subscriptions.erase(node)
# ------------------------------------------------------------	

# ------------------------------------------------------------	
var audio_data_subscriptions:Array = []

var audio_data:Dictionary = {} :
	set(val):
		audio_data = val 
		for node in audio_data_subscriptions:
			if "on_audio_data_update" in node:
				node.on_audio_data_update.call( audio_data )
				
func subscribe_to_audio_data(node:Node) -> void:
	if node not in audio_data_subscriptions:
		audio_data_subscriptions.push_back(node)
		if "on_audio_data_update" in node:
			node.on_audio_data_update.call( audio_data )
			
func unsubscribe_to_audio_data(node:Node) -> void:
	audio_data_subscriptions.erase(node)				
# ------------------------------------------------------------	
# ------------------------------------------------------------	
var hints_unlocked_subscriptions:Array = []

var hints_unlocked:Array = [] :
	set(val):
		hints_unlocked = val 
		for node in hints_unlocked_subscriptions:
			if "on_hints_unlocked_update" in node:
				node.on_hints_unlocked_update.call( hints_unlocked )
				
func subscribe_to_hints_unlocked(node:Node) -> void:
	if node not in hints_unlocked_subscriptions:
		hints_unlocked_subscriptions.push_back(node)
		if "on_hints_unlocked_update" in node:
			node.on_hints_unlocked_update.call( hints_unlocked )
			
func unsubscribe_to_hints_unlocked(node:Node) -> void:
	hints_unlocked_subscriptions.erase(node)				
# ------------------------------------------------------------	
