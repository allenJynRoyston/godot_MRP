extends Control

@onready var RootPanel:PanelContainer = $PanelContainer
@onready var MarginPanel:MarginContainer = $PanelContainer/MarginContainer

@onready var Economy:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Economy
@onready var Personnel:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Personnel

var current_location:Dictionary = {}
var camera_settings:Dictionary = {}
var room_config:Dictionary = {}
var control_pos:Dictionary = {}
var resources_data:Dictionary = {}

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)	
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	SUBSCRIBE.subscribe_to_resources_data(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)

func _ready() -> void:	
	await U.tick()
	
	control_pos[RootPanel] = {
		"show": 0,
		"hide": -MarginPanel.size.y
	}
		
	reveal(false, true)
	update.call_deferred()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reveal(state:bool, instant:bool = false) -> void:
	if control_pos.is_empty():return
	
	var new_pos:int = control_pos[RootPanel].show if state else control_pos[RootPanel].hide
	
	if instant:
		RootPanel.position.y = new_pos
		return
	
	await U.tween_node_property(RootPanel, "position:y", new_pos)
# --------------------------------------------------------------------------------------------------

# -----------------------------------------------	
func on_resources_data_update(new_val:Dictionary) -> void:
	resources_data = new_val
	if !is_node_ready() or new_val.is_empty():return
	U.debounce(str(self.name, "_update"), update)
# -----------------------------------------------	

# -----------------------------------------------	
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if !is_node_ready() or new_val.is_empty():return
	U.debounce(str(self.name, "_update"), update)
# -----------------------------------------------			

# ----------------------------------------------			
func on_room_config_update(new_val:Dictionary) -> void: 
	room_config = new_val
	if !is_node_ready() or new_val.is_empty():return
	U.debounce(str(self.name, "_update"), update)
# -----------------------------------------------			

# -----------------------------------------------			
func on_camera_settings_update(new_val:Dictionary) -> void:
	camera_settings = new_val
	if !is_node_ready() or new_val.is_empty():return
	U.debounce(str(self.name, "_update"), update)
# -----------------------------------------------			
	
# -----------------------------------------------
func update() -> void:
	if !is_node_ready() or camera_settings.is_empty() or current_location.is_empty() or room_config.is_empty() or resources_data.is_empty():return
	var summary_data:Dictionary = {}
	
	## update everything else
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			summary_data = GAME_UTIL.get_floor_summary(current_location)
		CAMERA.TYPE.WING_SELECT:
			summary_data = GAME_UTIL.get_ring_summary(current_location)	
		CAMERA.TYPE.ROOM_SELECT:
			summary_data = GAME_UTIL.get_room_summary(current_location)
		_:
			summary_data = GAME_UTIL.get_floor_summary(current_location)
			
	# update amounts
	Economy.money_val = resources_data[RESOURCE.CURRENCY.MONEY].amount
	Economy.research_val = resources_data[RESOURCE.CURRENCY.SCIENCE].amount
	Economy.material_val = resources_data[RESOURCE.CURRENCY.MATERIAL].amount
	Economy.core_val = resources_data[RESOURCE.CURRENCY.CORE].amount	
	
	# update income
	Economy.money_income = summary_data.currency_diff[RESOURCE.CURRENCY.MONEY] + resources_data[RESOURCE.CURRENCY.MONEY].diff
	Economy.researcher_income = summary_data.currency_diff[RESOURCE.CURRENCY.SCIENCE] + resources_data[RESOURCE.CURRENCY.SCIENCE].diff	
	Economy.material_income = summary_data.currency_diff[RESOURCE.CURRENCY.MATERIAL] + resources_data[RESOURCE.CURRENCY.MATERIAL].diff
	Economy.core_income = summary_data.currency_diff[RESOURCE.CURRENCY.CORE]	+ resources_data[RESOURCE.CURRENCY.CORE].diff

	#
	Personnel.admin_count = RESEARCHER_UTIL.get_spec_available_count(RESEARCHER.SPECIALIZATION.ADMIN)
	Personnel.researcher_count = RESEARCHER_UTIL.get_spec_available_count(RESEARCHER.SPECIALIZATION.RESEARCHER)
	Personnel.security_count = RESEARCHER_UTIL.get_spec_available_count(RESEARCHER.SPECIALIZATION.SECURITY)
	Personnel.dclass_count = RESEARCHER_UTIL.get_spec_available_count(RESEARCHER.SPECIALIZATION.DCLASS)
	
	Personnel.admin_max_count = RESEARCHER_UTIL.get_spec_capacity_count(RESEARCHER.SPECIALIZATION.ADMIN)
	Personnel.researcher_max_count = RESEARCHER_UTIL.get_spec_capacity_count(RESEARCHER.SPECIALIZATION.RESEARCHER)
	Personnel.security_max_count = RESEARCHER_UTIL.get_spec_capacity_count(RESEARCHER.SPECIALIZATION.SECURITY)
	Personnel.dclass_max_count = RESEARCHER_UTIL.get_spec_capacity_count(RESEARCHER.SPECIALIZATION.DCLASS)	

# -----------------------------------------------
