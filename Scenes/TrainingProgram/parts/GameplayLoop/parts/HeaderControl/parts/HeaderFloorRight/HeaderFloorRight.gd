extends Control

@onready var RootPanel:PanelContainer = $PanelContainer
@onready var MarginPanel:MarginContainer = $PanelContainer/MarginContainer

@onready var Personnel:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/Personnel

var current_location:Dictionary = {}
var camera_settings:Dictionary = {}
var room_config:Dictionary = {}
var control_pos:Dictionary = {}

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)	
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)
	

func _ready() -> void:	
	await U.tick()
	
	control_pos[RootPanel] = {
		"show": 0,
		"hide": -MarginPanel.size.y
	}
		
	reveal(false, true)
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
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return
	
	#Personnel.show() if ROOM_UTIL.owns_and_is_active(ROOM.REF.HQ) else Personnel.hide()
	
	Personnel.admin_count = RESEARCHER_UTIL.get_spec_count(RESEARCHER.SPECIALIZATION.ADMIN)
	Personnel.researcher_count = RESEARCHER_UTIL.get_spec_count(RESEARCHER.SPECIALIZATION.RESEARCHER)
	Personnel.security_count = RESEARCHER_UTIL.get_spec_count(RESEARCHER.SPECIALIZATION.SECURITY)
	Personnel.dclass_count = RESEARCHER_UTIL.get_spec_count(RESEARCHER.SPECIALIZATION.DCLASS)
	
	Personnel.admin_max_count = RESEARCHER_UTIL.get_spec_capacity_count(RESEARCHER.SPECIALIZATION.ADMIN)
	Personnel.researcher_max_count = RESEARCHER_UTIL.get_spec_capacity_count(RESEARCHER.SPECIALIZATION.RESEARCHER)
	Personnel.security_max_count = RESEARCHER_UTIL.get_spec_capacity_count(RESEARCHER.SPECIALIZATION.SECURITY)
	Personnel.dclass_max_count = RESEARCHER_UTIL.get_spec_capacity_count(RESEARCHER.SPECIALIZATION.DCLASS)
# -----------------------------------------------
