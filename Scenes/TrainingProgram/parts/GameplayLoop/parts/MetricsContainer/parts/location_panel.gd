@tool
extends PanelContainer

@onready var FloorLabel:Label = $MarginContainer/HBoxContainer/HBoxContainer/FloorLabel
@onready var WingLabel:Label = $MarginContainer/HBoxContainer/HBoxContainer2/WingLabel
@onready var RoomLabel:Label = $MarginContainer/HBoxContainer/RoomBox/RoomLabel
@onready var RoomBox:HBoxContainer = $MarginContainer/HBoxContainer/RoomBox

var current_location:Dictionary = {}

@export var hide_room:bool = false : 
	set(val):
		hide_room = val
		on_hide_room_update()

func _ready() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	on_hide_room_update()

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	
func on_hide_room_update() -> void:
	if !is_node_ready():return
	RoomBox.hide() if hide_room else RoomBox.show()

func on_current_location_update(new_val:Dictionary) -> void:	
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	FloorLabel.text = "%s" % [current_location.floor]
	WingLabel.text = "%s" % [current_location.ring]
	RoomLabel.text = "%s" % [current_location.room]
