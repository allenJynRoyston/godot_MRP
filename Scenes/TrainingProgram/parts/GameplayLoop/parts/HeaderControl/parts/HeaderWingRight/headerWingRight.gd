extends Control

@onready var RootPanel:PanelContainer = $PanelContainer
@onready var MarginPanel:MarginContainer = $PanelContainer/MarginContainer

@onready var EnergyContainer:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/Energy
@onready var Energy:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/Energy/MarginContainer/VBoxContainer/HBoxContainer/Energy
@onready var EnergyTag:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/Energy/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/EnergyTag

@onready var MTFContainer:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/Personnel
@onready var MTF1:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/HBoxContainer/MTF1
@onready var MTF2:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/HBoxContainer/MTF2
@onready var MTF3:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/HBoxContainer/MTF3

@onready var MTF1Tag:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/MTF1Tag
@onready var MTF2Tag:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/MTF2Tag
@onready var MTF3Tag:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/MTF3Tag

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
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return
	var base_config_data:Dictionary = room_config.base
	var floor_config_data:Dictionary = room_config.floor[current_location.floor]
	var ring_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]	
	var room_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].room[current_location.room]	
	var summary_data:Dictionary = {}
	
	
	MTFContainer.show() if ROOM_UTIL.owns_and_is_active(ROOM.REF.HQ) else MTFContainer.hide()
	
	
	## update everything else
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			summary_data = GAME_UTIL.get_floor_summary(current_location)
		CAMERA.TYPE.WING_SELECT:
			summary_data = GAME_UTIL.get_ring_summary(current_location)	
		CAMERA.TYPE.ROOM_SELECT:
			summary_data = GAME_UTIL.get_room_summary(current_location)

			#
	# energy
	Energy.amount = ring_config_data.energy.available - ring_config_data.energy.used
	Energy.max_amount = ring_config_data.energy.available
	EnergyTag.val = str(-summary_data.energy_diff)			

	# update specilists
	#Personnel.hide() if camera_settings.type == CAMERA.TYPE.FLOOR_SELECT else Personnel.show()	
	MTF1.is_negative = !ring_config_data.personnel[RESOURCE.PERSONNEL.STAFF]
	MTF2.is_negative = !ring_config_data.personnel[RESOURCE.PERSONNEL.TECHNICIANS]
	MTF3.is_negative = !ring_config_data.personnel[RESOURCE.PERSONNEL.SECURITY]

	# update tags
	MTF1Tag.val = str(summary_data.personnel_diff[RESOURCE.PERSONNEL.STAFF])
	MTF2Tag.val = str(summary_data.personnel_diff[RESOURCE.PERSONNEL.TECHNICIANS])
	MTF3Tag.val = str(summary_data.personnel_diff[RESOURCE.PERSONNEL.SECURITY])	
# -----------------------------------------------
