extends GameContainer

@onready var MainPanel:MarginContainer = $Control/MarginContainer
@onready var RoomLevelMetrics:Control = $Control/MarginContainer/VBoxContainer/RoomLevelMetrics
@onready var MetricsVBox:VBoxContainer = $Control/MarginContainer/VBoxContainer/RoomLevelMetrics/Room/MetricsVBox
@onready var MetricsSCP:Control = $Control/MarginContainer/VBoxContainer/RoomLevelMetrics/Room/MetricsVBox/MetricsSCP
@onready var MetricsRoom:Control = $Control/MarginContainer/VBoxContainer/RoomLevelMetrics/Room/MetricsVBox/MetricsRoom
@onready var ResearchersContainer:Control = $Control/MarginContainer/VBoxContainer/RoomLevelMetrics/Researchers
@onready var MetricsResearcherContainer:Control = $Control/MarginContainer/VBoxContainer/RoomLevelMetrics/Researchers/MetricsResearcherContainer
@onready var SwapBtnA:BtnBase = $Control/MarginContainer/VBoxContainer/RoomLevelMetrics/Room/SwapBtnA
@onready var SwapBtnB:BtnBase = $Control/MarginContainer/VBoxContainer/RoomLevelMetrics/Researchers/SwapBtnB

@onready var LocationPanel:Control = $MarginContainer/LocationPanel

const MetricsItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/MetricsContainer/parts/MetricItem.tscn")

var previous_location:Dictionary = {}
var metrics_tween_pos_val:float = 0
var researcher_tween_pos_val:float = 0
var researcher_pos_locked:bool = false
var metrics_pos_locked:bool = false

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	update_details_panel()

	modulate = Color(1, 1, 1, 0)
	await U.set_timeout(1.5)
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 1)	
	
	# get starting value for tween_pos_valtheme_override_constants/
	metrics_tween_pos_val = MetricsVBox.get_theme_constant('separation')
	researcher_tween_pos_val = MetricsResearcherContainer.get_theme_constant('separation')
	
	SwapBtnA.onClick = func():
		metrics_pos_locked = !metrics_pos_locked
		SwapBtnA.icon = SVGS.TYPE.LOCK if metrics_pos_locked else SVGS.TYPE.SWAP
	
	SwapBtnA.onFocus = func(_node:Control) -> void:		
		if !metrics_pos_locked:
			U.tween_range(metrics_tween_pos_val, 5, 0.3, func(val:float) -> void:
				metrics_tween_pos_val = val
				MetricsVBox.add_theme_constant_override('separation', val)
			)
	SwapBtnA.onBlur  = func(_node:Control) -> void:
		if !metrics_pos_locked:
			U.tween_range(metrics_tween_pos_val, -45, 0.3, func(val:float) -> void:
				metrics_tween_pos_val = val
				MetricsVBox.add_theme_constant_override('separation', val)
			)
		
	SwapBtnB.onClick = func():
		researcher_pos_locked = !researcher_pos_locked
		SwapBtnB.icon = SVGS.TYPE.LOCK if researcher_pos_locked else SVGS.TYPE.SWAP
	
	SwapBtnB.onFocus = func(_node:Control) -> void:		
		if !researcher_pos_locked:
			U.tween_range(researcher_tween_pos_val, 5, 0.3, func(val:float) -> void:
				researcher_tween_pos_val = val
				MetricsResearcherContainer.add_theme_constant_override('separation', val)
			)
	SwapBtnB.onBlur  = func(_node:Control) -> void:		
		if !researcher_pos_locked:
			U.tween_range(researcher_tween_pos_val, -45, 0.3, func(val:float) -> void:
				researcher_tween_pos_val = val
				MetricsResearcherContainer.add_theme_constant_override('separation', val)
			)
# -----------------------------------------------



# -----------------------------------------------
func on_is_showing_update() -> void:	
	if !is_node_ready() or camera_settings.is_empty():return	
	if camera_settings.type == CAMERA.TYPE.ROOM_SELECT and is_showing:
		U.tween_node_property(MainPanel, "position:x", 0, 0.7)
		#LocationPanel.show()
	else:
		U.tween_node_property(MainPanel, "position:x", -MainPanel.size.x - 20, 0.7)
		#LocationPanel.hide()
	
# -----------------------------------------------	

# --------------------------------------------------------
func on_camera_settings_update(new_val:Dictionary) -> void:
	super.on_camera_settings_update(new_val)
	on_is_showing_update()

func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return	
	update_details_panel()

func on_purchased_facility_arr_update(new_val:Array) -> void:
	super.on_purchased_facility_arr_update(new_val)	

func on_resources_data_update(new_val:Dictionary) -> void:
	super.on_resources_data_update(new_val)	

func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	super.on_hired_lead_researchers_arr_update(new_val)
	update_details_panel()

func on_current_location_update(new_val:Dictionary) -> void:
	super.on_current_location_update(new_val)
	if !U.dictionaries_equal(previous_location, current_location):
		previous_location = new_val.duplicate(true)
		update_details_panel()
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
	var room_category:int = room_extract.room_category
	var is_directors_office:bool = room_extract.is_directors_office

	# ------------------------------------------		
	# SPECIAL EXCEPTION FOR DIRECTORS OFFICE					
	MetricsResearcherContainer.hide() if is_directors_office else MetricsResearcherContainer.show()

	MetricsRoom.is_active = !room_extract.room.is_empty()
	if !room_extract.room.is_empty():
		var details:Dictionary   = room_extract.room.details
		
		MetricsRoom.header = "%s" % [details.shortname]
		MetricsRoom.status = "CONSTRUCTING" if room_extract.is_room_under_construction else "ACTIVE" if room_extract.room.is_activated else "INACTIVE"
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
	MetricsSCP.is_active = !room_extract.scp.is_empty()
	if !room_extract.scp.is_empty():
		SwapBtnA.show()
		MetricsSCP.show()		
		var details:Dictionary = room_extract.scp.details

		MetricsSCP.header = "%s" % [details.name]
		var status_label := "CONTAINED"
		
		if room_extract.scp.is_transfer:
			status_label = "TRANSFERING"
		
		#if !room_extract.scp.testing.is_empty():
			#status_label = "TESTING"
			
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
		SwapBtnA.hide()
		MetricsSCP.hide()
		MetricsSCP.header = "EMPTY"
		MetricsSCP.status = "N/A"
		MetricsSCP.items = [{"title": "NO BONUS"}]			
	# ------------------------------------------
	#
	# ------------------------------------------
	for child in MetricsResearcherContainer.get_children():
		child.queue_free()
	
	if !researchers.is_empty():
		for index in researchers.size():
			var researcher:Dictionary = researchers[index]
			var new_node:Control = MetricsItemPreload.instantiate()
			new_node.is_active = true
			new_node.type = 2
			new_node.header = "%s" % [researcher.name]
			new_node.status = "NORMAL"
			new_node.z_index = abs(index - researchers.size())
			new_node.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN if index == 0 else Control.SIZE_SHRINK_END
				
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
		new_node.is_active = false
		new_node.type = 2
		new_node.header = "NONE"
		new_node.status = "N/A"
		new_node.items = [{"title": "NO BONUS"}]			
		MetricsResearcherContainer.add_child(new_node)
		

	SwapBtnB.show() if researchers.size() > 1 else SwapBtnB.hide()
	ResearchersContainer.show() if researchers.size() > 0 else ResearchersContainer.hide()	
# -----------------------------------------------
