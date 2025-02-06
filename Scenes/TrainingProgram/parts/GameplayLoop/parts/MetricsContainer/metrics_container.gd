@tool
extends GameContainer

@onready var HumePanel:PanelContainer = $HumePanel
@onready var MetricsPanel:HBoxContainer = $PanelContainer/VBoxContainer/MetricsPanel
@onready var DetailsPanel:HBoxContainer = $PanelContainer/VBoxContainer/Details
@onready var StatusLabel:Label = $PanelContainer/VBoxContainer/StatusLabel

@onready var ReadinessLabel:Label = $PanelContainer/VBoxContainer/MetricsPanel/Readiness/VBoxContainer/PanelContainer/MarginContainer/ReadinessLabel
@onready var SafetyLabel:Label = $PanelContainer/VBoxContainer/MetricsPanel/Safety/VBoxContainer/PanelContainer/MarginContainer/SafetyLabel
@onready var MoraleLabel:Label = $PanelContainer/VBoxContainer/MetricsPanel/Morale/VBoxContainer/PanelContainer/MarginContainer/MoraleLabel

@onready var ConfigBonusContainer:PanelContainer = $PanelContainer/VBoxContainer/ConfigBonus

@onready var RoomContainer:Control = $PanelContainer/VBoxContainer/Details/RoomContainer
@onready var RoomNameLabel:Label = $PanelContainer/VBoxContainer/Details/RoomContainer/VBoxContainer/MarginContainer/HBoxContainer/RoomNameLabel
@onready var RoomStatusLabel:Label = $PanelContainer/VBoxContainer/Details/RoomContainer/VBoxContainer/MarginContainer/HBoxContainer/RoomStatusLabel
@onready var RoomEffectsList:VBoxContainer = $PanelContainer/VBoxContainer/Details/RoomContainer/VBoxContainer/PanelContainer/MarginContainer2/RoomEffectsList

@onready var SCPContainer:Control = $PanelContainer/VBoxContainer/Details/ScpContainer
@onready var SCPNameLabel:Label = $PanelContainer/VBoxContainer/Details/ScpContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/SCPNameLabel
@onready var SCPStatusLabel:Label = $PanelContainer/VBoxContainer/Details/ScpContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/SCPStatusLabel
@onready var SCPEffectsList:VBoxContainer = $PanelContainer/VBoxContainer/Details/ScpContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/SCPEffectsList

@onready var ResearcherContainer:Control = $PanelContainer/VBoxContainer/Details/ResearcherContainer
@onready var ResearcherNameLabel:Label = $PanelContainer/VBoxContainer/Details/ResearcherContainer/VBoxContainer/MarginContainer/HBoxContainer/ResearcherNameLabel
@onready var ResearcherEffectsList:VBoxContainer = $PanelContainer/VBoxContainer/Details/ResearcherContainer/VBoxContainer/PanelContainer/MarginContainer2/ResearcherEffectsList
#@onready var SCPResearcherLabel:Label = $PanelContainer/VBoxContainer/Details/ScpContainer/MarginContainer/VBoxContainer/SCPResearcherLabel


var in_lockdown:bool = false
var is_powered:bool = false
var is_activated:bool = false

var previous_location:Dictionary = {}
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

func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	super.on_hired_lead_researchers_arr_update(new_val)
	update_details_panel()

func on_current_location_update(new_val:Dictionary) -> void:
	super.on_current_location_update(new_val)
	if !U.dictionaries_equal(previous_location, current_location):
		previous_location = new_val.duplicate(true)
		
		update_status_label()
		update_panels()
		update_metrics_labels()
		update_details_panel()
# -----------------------------------------------

# -----------------------------------------------
func create_effect_label(text:String) -> Label:
	var new_label:Label = Label.new().duplicate()
	var dup_label_settings:LabelSettings  = label_settings.duplicate()	
	dup_label_settings.font_color = Color.RED if (!is_powered or !is_activated) else Color.WHITE
	new_label.label_settings = dup_label_settings
	new_label.text = text
	new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return new_label
# -----------------------------------------------

# -----------------------------------------------
func update_details_panel() -> void:	
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty() or resources_data.is_empty():return

	for node in [RoomEffectsList, SCPEffectsList, ResearcherEffectsList]:
		for child in node.get_children():
			child.queue_free()
			
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var researchers:Array = room_extract.researchers
	
	# ------------------------------------------		
	RoomContainer.modulate = Color(1, 1, 1, 0.4 if room_extract.room.is_empty() else 1)
	if !room_extract.room.is_empty():
		var details:Dictionary   = room_extract.room.details
		RoomNameLabel.text = "%s" % [details.name]
		RoomStatusLabel.text = "UNDER CONSTRUCTION" if room_extract.room.under_construction else "POWERED" if room_extract.room.is_activated else "NOT POWERED"
		is_activated = room_extract.room.is_activated		
		
		var effects_list:Array = ROOM_UTIL.return_effects(details.ref)
		if effects_list.size() > 0:
			for item in effects_list:
				RoomEffectsList.add_child( create_effect_label( "%s%s" % [item.resource_data.name, item.amount]) )
		else:
			RoomEffectsList.add_child( create_effect_label("NO BONUS") )	
	else:
		RoomNameLabel.text = "NOTHING BUILT"
		RoomEffectsList.add_child( create_effect_label("NO BONUS") )	
	# ------------------------------------------
	
	# ------------------------------------------
	SCPContainer.modulate = Color(1, 1, 1, 0.4 if room_extract.scp.is_empty() else 1)
	if !room_extract.scp.is_empty():
		var details:Dictionary = room_extract.scp.details

		SCPNameLabel.text = "%s" % [details.name]
		var status_label := "CONTAINED"
		
		if room_extract.scp.is_transfer:
			status_label = "TRANSFERING"
		
		if !room_extract.scp.testing.is_empty():
			status_label = "ACCESSING" if room_extract.scp.testing.is_accessing else "TESTING"
	
		if !room_extract.scp.is_transfer:
			var effects_list:Array = SCP_UTIL.return_effects(details.ref)
			if effects_list.size() > 0:
				for item in effects_list:
					SCPEffectsList.add_child( create_effect_label( "%s%s" % [item.resource_data.name, item.amount]) )
			else:
				SCPEffectsList.add_child( create_effect_label("NO BONUS") )		
		else:
			SCPEffectsList.add_child( create_effect_label("TRANSFERING..." if room_extract.scp.is_contained else "CONTAINING...")  )		
			
		SCPStatusLabel.text = status_label
	else:
		SCPNameLabel.text = "NO SCP"
		SCPEffectsList.add_child( create_effect_label("NO BONUS") )			
	# ------------------------------------------
	
	# ------------------------------------------
	ResearcherContainer.modulate = Color(1, 1, 1, 0.4 if researchers.is_empty() else 1)
	if !researchers.is_empty():
		if researchers.size() == 1:
			ResearcherNameLabel.text = "RESEARCHER %s" % [researchers[0].name]
		else:
			ResearcherNameLabel.text = "%s RESEARCHERS" % [researchers.size()]
		
		var effects_list:Array = []
		for researcher in researchers:
			effects_list += RESEARCHER_UTIL.return_effects(researcher)
			
		if effects_list.size() > 0:
			for item in effects_list:
				ResearcherEffectsList.add_child( create_effect_label( "%s%s" % [item.resource_data.name, item.amount]) )
		else:
			ResearcherEffectsList.add_child( create_effect_label("NO BONUS") )		
	else:
		ResearcherNameLabel.text = "NO RESEARCHER"
		ResearcherEffectsList.add_child( create_effect_label("NO BONUS") )						
	# ------------------------------------------

# -----------------------------------------------

# -----------------------------------------------
func update_panels() -> void:
	if !is_node_ready() or current_location.is_empty() or camera_settings.is_empty():return
	var can_show:bool = camera_settings.type == CAMERA.TYPE.ROOM_SELECT
	var show_metrics:bool = true #ROOM_UTIL.get_count(ROOM.TYPE.HR_DEPARTMENT, purchased_facility_arr) > 0
	var show_hume:bool = true #ROOM_UTIL.get_count(ROOM.TYPE.HUME_DETECTOR, purchased_facility_arr) > 0

	ConfigBonusContainer.hide() #if can_show else ConfigBonusContainer.hide()
	MetricsPanel.show() if can_show and show_metrics else MetricsPanel.hide()
	HumePanel.show() if can_show and show_hume else HumePanel.hide()
	
	# show details when on wing level
	DetailsPanel.show() if can_show else DetailsPanel.hide()
	
	# show status label when on floor level
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
				MoraleLabel.text = str(amount)
			RESOURCE.BASE_METRICS.READINESS:
				ReadinessLabel.text = str(amount) 
			RESOURCE.BASE_METRICS.SAFETY:
				SafetyLabel.text = str(amount) 
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
