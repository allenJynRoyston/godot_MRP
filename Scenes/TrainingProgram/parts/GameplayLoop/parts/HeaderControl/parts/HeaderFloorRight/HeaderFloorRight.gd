extends Control

@onready var RootPanel:PanelContainer = $PanelContainer
@onready var MarginPanel:MarginContainer = $PanelContainer/MarginContainer

@onready var Vibes:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/Vibes

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
	
	await U.tick()
	control_pos[RootPanel] = {
		"show": 0,
		"hide": -MarginPanel.size.y
	}
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
	var base_config_data:Dictionary = room_config.base
	var floor_config_data:Dictionary = room_config.floor[current_location.floor]
	var ring_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]	
	var room_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].room[current_location.room]	
	var current_vibe:Dictionary = GAME_UTIL.get_vibes_summary(current_location)	
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
			
	#Personnel.show() if ROOM_UTIL.owns_and_is_active(ROOM.REF.HQ) else Personnel.hide()
	# update vibes
	Vibes.morale_val = str(current_vibe[RESOURCE.METRICS.MORALE])
	Vibes.safety_val = str(current_vibe[RESOURCE.METRICS.SAFETY])
	Vibes.readiness_val = str(current_vibe[RESOURCE.METRICS.READINESS])		
	# update metrics
	Vibes.morale_tag_val = summary_data.metric_diff[RESOURCE.METRICS.MORALE]
	Vibes.safety_tag_val = summary_data.metric_diff[RESOURCE.METRICS.SAFETY]
	Vibes.readiness_tag_val = summary_data.metric_diff[RESOURCE.METRICS.READINESS]	

# -----------------------------------------------
