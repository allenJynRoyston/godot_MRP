extends Control

@onready var RootPanel:PanelContainer = $PanelContainer
@onready var MarginPanel:MarginContainer = $PanelContainer/MarginContainer

@onready var WarningComponent:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/WarningComponent
@onready var EnergyComponent:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/EnergyComponent
@onready var MtfComponent:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/MTFComponent

var current_location:Dictionary = {}
var camera_settings:Dictionary = {}
var room_config:Dictionary = {}
var control_pos:Dictionary = {}

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_process(self)
	SUBSCRIBE.subscribe_to_room_config(self)	
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)
	
func _ready() -> void:	
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
	
	if state:
		show()
	

	if instant:
		RootPanel.position.y = new_pos
		return
	
	await U.tween_node_property(RootPanel, "position:y", new_pos)
	
	if !state:
		hide()
# --------------------------------------------------------------------------------------------------


# -----------------------------------------------	
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	U.debounce(str(self.name, "_update"), update)
# -----------------------------------------------			

# ----------------------------------------------			
func on_room_config_update(new_val:Dictionary) -> void: 
	room_config = new_val
	U.debounce(str(self.name, "_update"), update)
# -----------------------------------------------			

# -----------------------------------------------			
func on_camera_settings_update(new_val:Dictionary) -> void:
	camera_settings = new_val
	U.debounce(str(self.name, "_update"), update)
# -----------------------------------------------			

# -----------------------------------------------
func update() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty() or camera_settings.is_empty():return
	var base_config_data:Dictionary = room_config.base
	var floor_config_data:Dictionary = room_config.floor[current_location.floor]
	var ring_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]	
	var room_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].room[current_location.room]	
	var mtf:Array = ring_config_data.mtf
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
	
	# warning
	#print( ring_config_data.has_containment_breach  )
	WarningComponent.flashing = !ring_config_data.is_ventilated or ring_config_data.is_overheated or ring_config_data.emergency_mode != ROOM.EMERGENCY_MODES.NORMAL 

	# energy
	EnergyComponent.amount = ring_config_data.energy.available - ring_config_data.energy.used
	EnergyComponent.max_amount = ring_config_data.energy.available
	EnergyComponent.flashing = EnergyComponent.amount == 0
	
	# mtf
	MtfComponent.mtf = mtf
# -----------------------------------------------
