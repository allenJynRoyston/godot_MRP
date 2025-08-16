extends Control

@onready var VisulizerPanel:PanelContainer = $VisulizerPanel
@onready var VisulizerMargin:MarginContainer = $VisulizerPanel/MarginContainer

@onready var FloorVisualizer:VBoxContainer = $VisulizerPanel/MarginContainer/VBoxContainer/HBoxContainer/FloorVisualizer
@onready var WingVisualizer:HBoxContainer = $VisulizerPanel/MarginContainer/VBoxContainer/HBoxContainer/WingVisualizer
@onready var RoomVisualizer:VBoxContainer = $VisulizerPanel/MarginContainer/VBoxContainer/HBoxContainer/RoomVisualizer

@onready var SectorLabel:Label = $VisulizerPanel/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/SectorLabel


var room_visualizer_nodes:Array = []

var current_location:Dictionary = {}
var camera_settings:Dictionary = {}
var control_pos:Dictionary = {}

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)

	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)

func _ready() -> void:
	var os_settings:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].os_settings
	
	for HBoxNode in RoomVisualizer.get_children():
		for child in HBoxNode.get_children():
			room_visualizer_nodes.push_back(child)
			
	await U.tick()
	
	control_pos[VisulizerPanel] = {
		"show": 0,
		"hide": -VisulizerMargin.size.y
	}
	
	
	reveal(false, true)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reveal(state:bool, instant:bool = false) -> void:
	if control_pos.is_empty():return
	
	var new_pos_visualizer:int = control_pos[VisulizerPanel].show if state else control_pos[VisulizerPanel].hide

	if instant:
		VisulizerPanel.position.y = new_pos_visualizer
		return
	
	await U.tween_node_property(VisulizerPanel, "position:y", new_pos_visualizer)
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
		
	SectorLabel.text = str("SECTOR ", new_val.floor, U.ring_to_str(new_val.ring))
# -----------------------------------------------			

# ----------------------------------------------			
func on_camera_settings_update(new_val:Dictionary) -> void: 
	if !is_node_ready() or new_val.is_empty():return
	#var nodes:Array = [FloorVisualizer, WingVisualizer, RoomVisualizer]
#
	#match new_val.type:
		#CAMERA.TYPE.FLOOR_SELECT:
			#ModeLabel.text = "OVEERSEER MODE"
					#
		#CAMERA.TYPE.WING_SELECT:
			#ModeLabel.text = "FLOOR MANAGER MODE"
			#
		#CAMERA.TYPE.ROOM_SELECT:
			#ModeLabel.text = "ROOM MANAGER MODE"
# -----------------------------------------------			
