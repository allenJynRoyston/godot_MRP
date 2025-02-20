extends GameContainer

@onready var MainPanel:Control = $Control/MarginContainer
@onready var HumePanel:PanelContainer = $Control/MarginContainer/VBoxContainer/HumePanel
@onready var MetricsPanel:HBoxContainer = $Control/MarginContainer/VBoxContainer/MetricsPanel
@onready var MoraleNode:Control = $Control/MarginContainer/VBoxContainer/MetricsPanel/Morale
@onready var SafeteyNode:Control = $Control/MarginContainer/VBoxContainer/MetricsPanel/Safety
@onready var ReadinessNode:Control = $Control/MarginContainer/VBoxContainer/MetricsPanel/Readiness
@onready var StatusLabel:Label = $Control/MarginContainer/VBoxContainer/StatusLabel

const label_settings:LabelSettings = preload("res://Fonts/game/label_small.tres")

var previous_floor:int = -1
var previous_wing:int = -1
var previous_location:Dictionary = {}

var restore_pos:int 

var metrics_tween_pos_val:float = 0
var researcher_tween_pos_val:float = 0

var researcher_pos_locked:bool = false
var metrics_pos_locked:bool = false

# -----------------------------------------------
func _ready() -> void:
	super._ready()
# -----------------------------------------------

# -----------------------------------------------
func on_is_showing_update() -> void:	
	super.on_is_showing_update()
	U.tween_node_property(MainPanel, "position:y", 0 if is_showing else -MainPanel.size.y - 20, 0.7)
# -----------------------------------------------	

# --------------------------------------------------------
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return	
	update_metrics_labels()
	update_status()
	
func on_purchased_facility_arr_update(new_val:Array) -> void:
	super.on_purchased_facility_arr_update(new_val)	

func on_resources_data_update(new_val:Dictionary) -> void:
	super.on_resources_data_update(new_val)	

func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	super.on_hired_lead_researchers_arr_update(new_val)


func on_current_location_update(new_val:Dictionary) -> void:
	super.on_current_location_update(new_val)
	if !U.dictionaries_equal(previous_location, current_location):
		previous_location = new_val.duplicate(true)
		update_metrics_labels()
		update_status()
# -----------------------------------------------

# -----------------------------------------------
func update_status() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return
	var floor_config:Dictionary = room_config.floor[current_location.floor]
	var ring_config:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]
	
	var status_text:String = "NORMAL"
	
	if floor_config.in_lockdown:
		status_text = "LOCKDOWN"
		#FloorMetric.status = "LOCKDOWN"
	else:				
		match ring_config.emergency_mode:
			ROOM.EMERGENCY_MODES.DANGER:
				status_text = "DANGER"
			ROOM.EMERGENCY_MODES.WARNING:
				status_text = "WARNING"
			ROOM.EMERGENCY_MODES.CAUTION:
				status_text = "CAUTION"
	
	StatusLabel.text = "%s"  % [status_text]
# -----------------------------------------------	

# -----------------------------------------------
func merge_metric_data(arr:Array) -> Array:
	var dict:Dictionary = {}
	for item in arr:
		if item.resource_data.ref not in dict:
			dict[item.resource_data.ref] = item
		dict[item.resource_data.ref].amount += item.amount
	
	var return_as_list:Array = []
	for key in dict:
		return_as_list.push_back(dict[key])
	return return_as_list
# -----------------------------------------------	

# -----------------------------------------------
func update_metrics_labels() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return
	var ring_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]
	
	for key in ring_data.metrics:
		var amount:int = ring_data.metrics[key]
		match key:
			RESOURCE.BASE_METRICS.MORALE:
				MoraleNode.value = amount
			RESOURCE.BASE_METRICS.READINESS:
				ReadinessNode.value = amount
			RESOURCE.BASE_METRICS.SAFETY:
				SafeteyNode.value = amount
# -----------------------------------------------
