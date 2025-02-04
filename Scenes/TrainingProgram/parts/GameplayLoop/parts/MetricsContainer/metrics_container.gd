@tool
extends GameContainer

@onready var HumePanel:PanelContainer = $PanelContainer/VBoxContainer/HumePanel
@onready var MetricsPanel:HBoxContainer = $PanelContainer/VBoxContainer/MetricsPanel
@onready var DetailsPanel:HBoxContainer = $PanelContainer/VBoxContainer/Details
@onready var StatusLabel:Label = $PanelContainer/VBoxContainer/StatusLabel


@onready var ReadinessLabel:Label = $PanelContainer/VBoxContainer/MetricsPanel/Readiness/VBoxContainer/PanelContainer/MarginContainer/ReadinessLabel
@onready var SafetyLabel:Label = $PanelContainer/VBoxContainer/MetricsPanel/Safety/VBoxContainer/PanelContainer/MarginContainer/SafetyLabel
@onready var MoraleLabel:Label = $PanelContainer/VBoxContainer/MetricsPanel/Morale/VBoxContainer/PanelContainer/MarginContainer/MoraleLabel

@onready var RoomNameLabel:Label = $PanelContainer/VBoxContainer/Details/RoomContainer/MarginContainer/VBoxContainer/HBoxContainer/RoomNameLabel
@onready var RoomStatusLabel:Label = $PanelContainer/VBoxContainer/Details/RoomContainer/MarginContainer/VBoxContainer/HBoxContainer/RoomStatusLabel
@onready var RoomEffectsList:HBoxContainer = $PanelContainer/VBoxContainer/Details/RoomContainer/MarginContainer/VBoxContainer/RoomEffectsList

@onready var SCPContainer:Control = $PanelContainer/VBoxContainer/Details/ScpContainer
@onready var SCPNameLabel:Label = $PanelContainer/VBoxContainer/Details/ScpContainer/MarginContainer/VBoxContainer/HBoxContainer2/SCPLabel
@onready var SCPStatusLabel:Label = $PanelContainer/VBoxContainer/Details/ScpContainer/MarginContainer/VBoxContainer/HBoxContainer2/SCPStatusLabel

@onready var SCPEffectsList:HBoxContainer = $PanelContainer/VBoxContainer/Details/ScpContainer/MarginContainer/VBoxContainer/SCPEffectsList

@onready var SCPResearcherLabel:Label = $PanelContainer/VBoxContainer/Details/ScpContainer/MarginContainer/VBoxContainer/SCPResearcherLabel

var in_lockdown:bool = false
var is_powered:bool = false

const label_settings:LabelSettings = preload("res://Fonts/game/label_small.tres")

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	update_details_panel()
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
	update_metrics_labels()
	update_details_panel()


func on_in_lockdown_update() -> void:
	update_status_label()

func on_is_powered_update() -> void:
	update_status_label()


func on_camera_settings_update(new_val:Dictionary) -> void:
	super.on_camera_settings_update(new_val)
	update_panels()
	
func on_purchased_facility_arr_update(new_val:Array) -> void:
	super.on_purchased_facility_arr_update(new_val)
	update_panels()

func on_resources_data_update(new_val:Dictionary) -> void:
	super.on_resources_data_update(new_val)
	update_panels()
	
func on_base_states_update(new_val:Dictionary = base_states) -> void:
	super.on_base_states_update(new_val)
	update_status_label()

func on_current_location_update(new_val:Dictionary) -> void:
	super.on_current_location_update(new_val)
	update_status_label()
	update_panels()
	update_metrics_labels()
	update_details_panel()
# -----------------------------------------------

# -----------------------------------------------
func create_effect_label(text:String) -> Label:
	var new_label:Label = Label.new()
	new_label.label_settings = label_settings
	new_label.text = text
	new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return new_label
# -----------------------------------------------

# -----------------------------------------------
func update_details_panel() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty() or resources_data.is_empty():return
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location.floor, current_location.ring, current_location.room, room_config, resources_data)
	
	RoomNameLabel.text = "%s" % [room_extract.room.room_details.name if (room_extract.room.has_room or room_extract.room.room_under_construction) else "EMPTY"]
	RoomStatusLabel.text = "UNDER CONSTRUCTION" if room_extract.room.room_under_construction else "POWERED" if room_extract.room.is_activated else "NOT POWERED"
	
	for node in [RoomEffectsList, SCPEffectsList]:
		for child in node.get_children():
			child.queue_free()
		
	if room_extract.room.has_room:
		var effects_list:Array = ROOM_UTIL.return_effects(room_extract.room.room_details.ref)
		if effects_list.size() > 0:
			for item in effects_list:
				RoomEffectsList.add_child( create_effect_label( "%s%s" % [item.name, "+" if item.amount > 0 else "-"]) )
		else:
			RoomEffectsList.add_child( create_effect_label("NO EFFECT") )		
	else:
		RoomEffectsList.add_child( create_effect_label("NO EFFECT") )	

	SCPContainer.hide() if room_extract.scp.is_empty() else SCPContainer.show()
	
	if room_extract.scp.is_empty():return
	
	var scp_details:Dictionary = room_extract.scp.scp_details
	var effects_list:Array = SCP_UTIL.return_effects(room_extract.scp.scp_details.ref)
	if effects_list.size() > 0:
		for item in effects_list:
			SCPEffectsList.add_child( create_effect_label( "%s %s%s" % [item.name, "+" if item.amount > 0 else "", item.amount]) )
	else:
		SCPEffectsList.add_child( create_effect_label("NO EFFECT") )		

	SCPNameLabel.text = "%s" % [scp_details.name]
	var status_label := "CONTAINED"
	
	if room_extract.scp.is_transfer:
		status_label = "TRANSFERING"
	
	if !room_extract.scp.testing.is_empty():
		status_label = "ACCESSING" if room_extract.scp.testing.is_accessing else "TESTING"

	SCPStatusLabel.text = status_label

# -----------------------------------------------

# -----------------------------------------------
func update_panels() -> void:
	if !is_node_ready() or current_location.is_empty() or camera_settings.is_empty():return
	var can_show:bool = camera_settings.type == CAMERA.TYPE.ROOM_SELECT
	
	var show_metrics:bool = ROOM_UTIL.get_count(ROOM.TYPE.HR_DEPARTMENT, purchased_facility_arr) > 0
	var show_hume:bool = ROOM_UTIL.get_count(ROOM.TYPE.HUME_DETECTOR, purchased_facility_arr) > 0

	
	MetricsPanel.show() if can_show and show_metrics else MetricsPanel.hide()
	HumePanel.show() if can_show and show_hume else HumePanel.hide()
	DetailsPanel.show() if can_show else DetailsPanel.hide()
	StatusLabel.hide() if can_show else StatusLabel.show()
# -----------------------------------------------

# -----------------------------------------------
func update_metrics_labels() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return
	var ring_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]
	
	for key in ring_data.metrics:
		var amount:int = ring_data.metrics[key]
		match key:
			RESOURCE.BASE_METRICS.MORALE:
				MoraleLabel.text = str(amount) if ring_data.room_refs.size() > 0 else "-"
			RESOURCE.BASE_METRICS.READINESS:
				ReadinessLabel.text = str(amount) if ring_data.room_refs.size() > 0 else "-"
			RESOURCE.BASE_METRICS.SAFETY:
				SafetyLabel.text = str(amount) if ring_data.room_refs.size() > 0 else "-"
# -----------------------------------------------

# -----------------------------------------------
func update_status_label() -> void:
	if base_states.is_empty() or current_location.is_empty():return
	check_lockdown_state()
	check_is_powered_state()
	
	var status_label:String = "NO ISSUES"
	
	if !is_powered:
		status_label = "NOT POWERED"
		
	if base_states.status_effects.in_brownout:
		status_label = "BROWNOUT"
	
	if in_lockdown:
		status_label = "LOCKDOWN"
		
	StatusLabel.text = "%s | %s | %s" % ["F%s" % [current_location.floor], "W%s" % [current_location.ring], status_label] 	
# -----------------------------------------------
