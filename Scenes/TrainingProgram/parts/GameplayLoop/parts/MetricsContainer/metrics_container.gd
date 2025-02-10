@tool
extends GameContainer

@onready var HumePanel:PanelContainer = $BottomContainer/MarginContainer/VBoxContainer/HumePanel
@onready var MarkerLabel:Label = $BottomContainer/MarginContainer/VBoxContainer/MarkerLabel

@onready var MetricsPanel:HBoxContainer = $TopContainer/VBoxContainer/HBoxContainer/MetricsPanel
@onready var FloorPanel:HBoxContainer = $TopContainer/VBoxContainer/HBoxContainer/FloorPanel
@onready var WingPanel:Control = $TopContainer/VBoxContainer/HBoxContainer/WingPanel

@onready var FloorMetric:Control = $TopContainer/VBoxContainer/HBoxContainer/FloorPanel/FloorMetric
@onready var WingMetric:Control = $TopContainer/VBoxContainer/HBoxContainer/FloorPanel/WingMetric

@onready var MoraleNode:Control = $TopContainer/VBoxContainer/HBoxContainer/MetricsPanel/Morale
@onready var SafeteyNode:Control = $TopContainer/VBoxContainer/HBoxContainer/MetricsPanel/Safety
@onready var ReadinessNode:Control = $TopContainer/VBoxContainer/HBoxContainer/MetricsPanel/Readiness

@onready var MetricsSCP:Control = $TopContainer/VBoxContainer/HBoxContainer/WingPanel/MetricsSCP
@onready var MetricsRoom:Control = $TopContainer/VBoxContainer/HBoxContainer/WingPanel/MetricsRoom
@onready var MetricsResearcherContainer:Control = $TopContainer/VBoxContainer/HBoxContainer/WingPanel/ResearcherContainer

const MetricsItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/MetricsContainer/parts/MetricItem.tscn")

var previous_floor:int = -1
var previous_wing:int = -1
var previous_location:Dictionary = {}
const label_settings:LabelSettings = preload("res://Fonts/game/label_small.tres")

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	update_details_panel()
# -----------------------------------------------

# --------------------------------------------------------
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return	
	update_metrics_labels()
	update_details_panel()
	update_marker()

func on_camera_settings_update(new_val:Dictionary) -> void:
	super.on_camera_settings_update(new_val)
	update_panels()
	
func on_purchased_facility_arr_update(new_val:Array) -> void:
	super.on_purchased_facility_arr_update(new_val)
	update_panels()

func on_resources_data_update(new_val:Dictionary) -> void:
	super.on_resources_data_update(new_val)
	update_panels()

func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	super.on_hired_lead_researchers_arr_update(new_val)
	update_details_panel()

func on_current_location_update(new_val:Dictionary) -> void:
	super.on_current_location_update(new_val)
	if !U.dictionaries_equal(previous_location, current_location):
		previous_location = new_val.duplicate(true)
		update_panels()
		update_metrics_labels()
		update_details_panel()
		update_marker()
# -----------------------------------------------

# -----------------------------------------------
func update_marker() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return
	var floor_config:Dictionary = room_config.floor[current_location.floor]
	var ring_config:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]
	
	var status_text:String = "NORMAL"
	
	if floor_config.in_lockdown:
		status_text = "LOCKDOWN"
		FloorMetric.status = "LOCKDOWN"
	else:				
		match ring_config.emergency_mode:
			ROOM.EMERGENCY_MODES.DANGER:
				status_text = "DANGER"
			ROOM.EMERGENCY_MODES.WARNING:
				status_text = "WARNING"
			ROOM.EMERGENCY_MODES.CAUTION:
				status_text = "CAUTION"
	
	MarkerLabel.text = "FLOOR: %s   WING: %s   %s"  % [current_location.floor, current_location.ring, status_text]
	
	FloorMetric.value = current_location.floor
	FloorMetric.status = "POWERED" if floor_config.is_powered else "NOT POWERED"

	WingMetric.value = current_location.ring
	WingMetric.status = status_text
	
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
	MetricsRoom.modulate = Color(1, 1, 1, 0.7 if room_extract.room.is_empty() else 1)
	if !room_extract.room.is_empty():
		var details:Dictionary   = room_extract.room.details
		
		MetricsRoom.header = "%s" % [details.shortname]
		MetricsRoom.status = "UNDER CONSTRUCTION" if room_extract.room.under_construction else "ACTIVE" if room_extract.room.is_activated else "INACTIVE"
		var is_activated = room_extract.room.is_activated		
		
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
	MetricsSCP.modulate = Color(1, 1, 1, 0.7 if room_extract.scp.is_empty() else 1)
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
		new_node.modulate = Color(1, 1, 1, 0.7)
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
	match camera_settings.type:
		CAMERA.TYPE.ROOM_SELECT:
			FloorPanel.hide()
			WingPanel.show()
		CAMERA.TYPE.FLOOR_SELECT:
			FloorPanel.show()
			WingPanel.hide()
			
	var can_show:bool = camera_settings.type == CAMERA.TYPE.ROOM_SELECT
	var show_metrics:bool = true #ROOM_UTIL.get_count(ROOM.TYPE.HR_DEPARTMENT, purchased_facility_arr) > 0
	var show_hume:bool = true #ROOM_UTIL.get_count(ROOM.TYPE.HUME_DETECTOR, purchased_facility_arr) > 0
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
