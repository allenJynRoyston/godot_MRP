extends Control

@onready var LocationPanel:PanelContainer = $LocationPanel
@onready var LocationMargin:MarginContainer = $LocationPanel/MarginContainer

@onready var LocationFloor:VBoxContainer = $LocationPanel/MarginContainer/Location/Floor
@onready var LocationWing:VBoxContainer = $LocationPanel/MarginContainer/Location/Wing
@onready var LocationRoom:VBoxContainer = $LocationPanel/MarginContainer/Location/Room

@onready var LocationFloorLabel:Label = $LocationPanel/MarginContainer/Location/Floor/CenterLabel2
@onready var LocationWingLabel:Label = $LocationPanel/MarginContainer/Location/Wing/CenterLabel2
@onready var LocationRoomLabel:Label = $LocationPanel/MarginContainer/Location/Room/CenterLabel2

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
	await U.tick()
	
	control_pos[LocationPanel] = {
		"show": 0,
		"hide": -LocationMargin.size.y
	}
	

	reveal(false, true)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reveal(state:bool, instant:bool = false) -> void:
	if control_pos.is_empty():return
	
	var new_pos_location:int = control_pos[LocationPanel].show if state else control_pos[LocationPanel].hide

	if instant:
		LocationPanel.position.y = new_pos_location
		return
	
	await U.tween_node_property(LocationPanel, "position:y", new_pos_location)
# --------------------------------------------------------------------------------------------------

# -----------------------------------------------	
func on_current_location_update(new_val:Dictionary) -> void:
	if !is_node_ready() or new_val.is_empty():return
	

	# update location label
	LocationFloorLabel.text = str(new_val.floor)
	LocationWingLabel.text = str(new_val.ring)
	LocationRoomLabel.text = str(new_val.room)
# -----------------------------------------------			
