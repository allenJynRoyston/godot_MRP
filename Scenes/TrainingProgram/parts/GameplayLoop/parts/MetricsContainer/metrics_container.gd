@tool
extends GameContainer

@onready var HumePanel:PanelContainer = $BottomContainer/MarginContainer/VBoxContainer/HumePanel
@onready var MetricsPanel:HBoxContainer = $TopContainer/VBoxContainer/BreakdownPanel/MetricsPanel
@onready var BreakdownPanel:HBoxContainer = $TopContainer/VBoxContainer/BreakdownPanel
@onready var StatusLabel:Label = $PanelContainer/VBoxContainer/StatusLabel

#@onready var ReadinessLabel:Label = $TopContainer/VBoxContainer/BreakdownPanel/MetricsPanel/Readiness/VBoxContainer/PanelContainer/MarginContainer/ReadinessLabel
#@onready var SafetyLabel:Label = $TopContainer/VBoxContainer/BreakdownPanel/MetricsPanel/Safety/VBoxContainer/PanelContainer/MarginContainer/SafetyLabel
#@onready var MoraleLabel:Label = $TopContainer/VBoxContainer/BreakdownPanel/MetricsPanel/Morale/VBoxContainer/PanelContainer/MarginContainer/MoraleLabel

#@onready var ConfigBonusContainer:PanelContainer = $PanelContainer/VBoxContainer/ConfigBonus
@onready var MetricsSCP:Control = $TopContainer/VBoxContainer/BreakdownPanel/MetricsSCP
@onready var MetricsRoom:Control = $TopContainer/VBoxContainer/BreakdownPanel/MetricsRoom
@onready var MetricsResearcherContainer:Control = $TopContainer/VBoxContainer/BreakdownPanel/ResearcherContainer

const MetricsItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/MetricsContainer/parts/MetricItem.tscn")

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
func update_details_panel() -> void:	
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty() or resources_data.is_empty():return

	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var researchers:Array = room_extract.researchers

	# ------------------------------------------		
	MetricsRoom.modulate = Color(1, 1, 1, 0.4 if room_extract.room.is_empty() else 1)
	if !room_extract.room.is_empty():
		var details:Dictionary   = room_extract.room.details
		
		MetricsRoom.header = "%s" % [details.name]
		MetricsRoom.status = "UNDER CONSTRUCTION" if room_extract.room.under_construction else "ACTIVE" if room_extract.room.is_activated else "INACTIVE"
		is_activated = room_extract.room.is_activated		
		
		var effects_list:Array = ROOM_UTIL.return_wing_effects_list(room_extract)
		if effects_list.size() > 0:
			var items:Array = []
			for item in effects_list:
				var amount_str:String = ""
				for n in abs(item.amount):
					amount_str += "+" if item.amount > 0 else "-"
				items.push_back({"title": "%s %s" % [item.resource_data.name, amount_str]})
			MetricsRoom.items = items
				
		else:
			MetricsRoom.items = [{"title": "NO BONUS"}]			
	else:
		MetricsRoom.header = "EMPTY"
		MetricsRoom.status = "N/A"
		MetricsRoom.items = [{"title": "NO BONUS"}]			
	# ------------------------------------------
	#
	# ------------------------------------------
	MetricsSCP.modulate = Color(1, 1, 1, 0.4 if room_extract.scp.is_empty() else 1)
	if !room_extract.scp.is_empty():
		var details:Dictionary = room_extract.scp.details

		MetricsSCP.header = "%s" % [details.name]
		var status_label := "CONTAINED"
		
		if room_extract.scp.is_transfer:
			status_label = "TRANSFERING"
		
		if !room_extract.scp.testing.is_empty():
			status_label = "ACCESSING" if room_extract.scp.testing.is_accessing else "TESTING"
		MetricsSCP.status = "KETER" #status_label
		
		var effects_list:Array = SCP_UTIL.return_wing_effects_list(room_extract)
		if effects_list.size() > 0:
			var items:Array = []
			for item in effects_list:
				var amount_str:String = ""
				for n in abs(item.amount):
					amount_str += "+" if item.amount > 0 else "-"
				items.push_back({"title": "%s %s" % [item.resource_data.name, amount_str]})
			MetricsSCP.items = items
				
		else:
			MetricsSCP.items = [{"title": "NO BONUS"}]			
	else:
		MetricsSCP.header = "EMPTY"
		MetricsSCP.status = "N/A"
		MetricsSCP.items = [{"title": "NO BONUS"}]			
	# ------------------------------------------
	#
	# ------------------------------------------
	for child in MetricsResearcherContainer.get_children():
		child.queue_free()
				
	if !researchers.is_empty():
		for researcher in researchers:
			var new_node:Control = MetricsItemPreload.instantiate()
			new_node.type = 2
			new_node.header = "%s" % [researcher.name]
			new_node.status = "NORMAL"
				
			var effects_list:Array = RESEARCHER_UTIL.return_wing_effects_list(researcher)
			if effects_list.size() > 0:
				var items:Array = []
				for item in effects_list:
					var amount_str:String = ""
					for n in abs(item.amount):
						amount_str += "+" if item.amount > 0 else "-"
					items.push_back({"title": "%s %s" % [item.resource_data.name, amount_str]})
				new_node.items = items
			else:
				new_node.items = [{"title": "NO BONUS"}]			

			effects_list += RESEARCHER_UTIL.return_wing_effects_list(researcher)
			MetricsResearcherContainer.add_child(new_node)
	else:
		var new_node:Control = MetricsItemPreload.instantiate()
		new_node.modulate = Color(1, 1, 1, 0.4)
		new_node.type = 2
		new_node.header = "NONE"
		new_node.status = "N/A"
		new_node.items = [{"title": "NO BONUS"}]			
		MetricsResearcherContainer.add_child(new_node)
		
	var InfoNode:Control = GBL.find_node(REFS.INFO_CONTAINER)
	
	await U.tick()
	InfoNode.add_theme_constant_override("margin_top", MetricsResearcherContainer.size.y + 20)
# -----------------------------------------------

# -----------------------------------------------
func update_panels() -> void:
	if !is_node_ready() or current_location.is_empty() or camera_settings.is_empty():return
	var can_show:bool = camera_settings.type == CAMERA.TYPE.ROOM_SELECT
	var show_metrics:bool = true #ROOM_UTIL.get_count(ROOM.TYPE.HR_DEPARTMENT, purchased_facility_arr) > 0
	var show_hume:bool = true #ROOM_UTIL.get_count(ROOM.TYPE.HUME_DETECTOR, purchased_facility_arr) > 0

	#ConfigBonusContainer.hide() #if can_show else ConfigBonusContainer.hide()
	#MetricsPanel.show() if can_show and show_metrics else MetricsPanel.hide()
	#HumePanel.show() if can_show and show_hume else HumePanel.hide()
	
	## show details when on wing level
	#DetailsPanel.show() if can_show else DetailsPanel.hide()
	#
	## show status label when on floor level
	#StatusLabel.hide() if can_show else StatusLabel.show()

# -----------------------------------------------

# -----------------------------------------------
func update_metrics_labels() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return
	var ring_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]
	
	#for key in ring_data.metrics:
		#var amount:int = ring_data.metrics[key]
		#match key:
			#RESOURCE.BASE_METRICS.MORALE:
				#MoraleLabel.text = str(amount)
			#RESOURCE.BASE_METRICS.READINESS:
				#ReadinessLabel.text = str(amount) 
			#RESOURCE.BASE_METRICS.SAFETY:
				#SafetyLabel.text = str(amount) 
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
		
	#StatusLabel.text = "%s | %s | %s" % ["F%s" % [current_location.floor], "W%s" % [current_location.ring], status_label] 	
# -----------------------------------------------
