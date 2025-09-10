extends Control

@onready var VisulizerPanel:PanelContainer = $"."
@onready var VisulizerMargin:MarginContainer = $MarginContainer

@onready var SectorLabel:Label = $MarginContainer/VBoxContainer/Location/HeaderHBox/Header/MarginContainer/SectorLabel

@onready var FloorVisualizer:VBoxContainer = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/FloorVisualizer
@onready var WingVisualizer:HBoxContainer = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/WingVisualizer
@onready var RoomVisualizer:VBoxContainer = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/RoomVisualizer

@onready var FloorLabel:Label = $MarginContainer/VBoxContainer/Location/Floor/FloorLabel
@onready var WingLabel:Label = $MarginContainer/VBoxContainer/Location/Wing/WingLabel
@onready var RoomLabel:Label = $MarginContainer/VBoxContainer/Location/Room/RoomLabel

var room_visualizer_nodes:Array = []
var current_location:Dictionary = {}
var camera_settings:Dictionary = {}
var control_pos:Dictionary = {}

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)

func _ready() -> void:
	for HBoxNode in RoomVisualizer.get_children():
		for child in HBoxNode.get_children():
			room_visualizer_nodes.push_back(child)
# --------------------------------------------------------------------------------------------------


# -----------------------------------------------	
func on_current_location_update(new_val:Dictionary) -> void:
	if !is_node_ready() or new_val.is_empty():return
	
	for index in FloorVisualizer.get_child_count():
		var IconBtn:Control = FloorVisualizer.get_child(index)
		IconBtn.static_color = Color(1, 1, 1, 1 if index == new_val.floor else 0.75)
		
	for index in WingVisualizer.get_child_count():
		var IconBtn:Control = WingVisualizer.get_child(index)
		IconBtn.static_color = Color(1, 1, 1, 1 if index == new_val.ring else 0.75)

	for index in room_visualizer_nodes.size():
		var IconBtn:Control = room_visualizer_nodes[index]
		IconBtn.static_color = Color(1, 1, 1, 1 if index == new_val.room else 0.75)
	
	FloorLabel.text = str(new_val.floor)
	WingLabel.text = U.ring_to_str(new_val.ring)
	RoomLabel.text = str(new_val.room)
	# find which "dominiate" departments are here and give it that labbel if it applies	
	var department_counts:int = ROOM_UTIL.department_count(new_val)
	var department_refs:Array = ROOM_UTIL.get_departments(new_val)
	var department_string:String = ""
	for i in range(department_refs.size()):
		var room_details: Dictionary = ROOM_UTIL.return_data(department_refs[i].ref)
		department_string += room_details.name
		if i < department_refs.size() - 1:
			department_string += "\n"
	
	SectorLabel.text = "EMPTY" if department_counts == 0 else department_string
# -----------------------------------------------			
