@tool
extends GameContainer

@onready var HumePanel:PanelContainer = $PanelContainer/VBoxContainer/HumePanel
@onready var MetricsPanel:HBoxContainer = $PanelContainer/VBoxContainer/MetricsPanel
@onready var StatusLabel:Label = $PanelContainer/VBoxContainer/StatusLabel

var in_lockdown:bool = false
var is_powered:bool = false

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	HumePanel.hide()
	MetricsPanel.hide()
# -----------------------------------------------

# --------------------------------------------------------
func check_lockdown_state() -> void:
	if room_config.is_empty() or current_location.is_empty():return
	in_lockdown = room_config.floor[current_location.floor].in_lockdown
# --------------------------------------------------------

# --------------------------------------------------------
func check_is_powered_state() -> void:
	if room_config.is_empty() or current_location.is_empty():return
	is_powered = room_config.floor[current_location.floor].is_powered
# --------------------------------------------------------

# --------------------------------------------------------
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return
	update_status_label()

func on_purchased_facility_arr_update(new_val:Array) -> void:
	super.on_purchased_facility_arr_update(new_val)
	update_panels()

func on_in_lockdown_update() -> void:
	update_status_label()
	
func on_is_powered_update() -> void:
	update_status_label()
	
func on_base_states_update(new_val:Dictionary = base_states) -> void:
	super.on_base_states_update(new_val)
	if !is_node_ready():return
	update_status_label()

func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if !is_node_ready():return
	update_status_label()
	update_panels()
# -----------------------------------------------

# -----------------------------------------------
func update_panels() -> void:
	if !is_node_ready() or current_location.is_empty():return
	var show_metrics:bool = ROOM_UTIL.get_count(ROOM.TYPE.HR_DEPARTMENT, purchased_facility_arr) > 0
	var show_hume:bool = ROOM_UTIL.get_count(ROOM.TYPE.HUME_DETECTOR, purchased_facility_arr) > 0

	MetricsPanel.show() if show_metrics else MetricsPanel.hide()
	HumePanel.show()if show_hume else HumePanel.hide()
# -----------------------------------------------

# -----------------------------------------------
func update_status_label() -> void:
	if base_states.is_empty():return
	check_lockdown_state()
	check_is_powered_state()
	
	var status_label:String = "NO ISSUES"
	
	if !is_powered:
		status_label = "NOT POWERED"
		
	if base_states.status_effects.in_brownout:
		status_label = "BROWNOUT"
	
	if in_lockdown:
		status_label = "LOCKDOWN"
		
	StatusLabel.text = status_label 	
# -----------------------------------------------
