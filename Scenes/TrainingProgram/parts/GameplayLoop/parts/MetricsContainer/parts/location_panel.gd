extends PanelContainer

@onready var FloorLabel:Label = $MarginContainer/HBoxContainer/HBoxContainer/FloorLabel
@onready var WingLabel:Label = $MarginContainer/HBoxContainer/HBoxContainer2/WingLabel
@onready var RoomLabel:Label = $MarginContainer/HBoxContainer/HBoxContainer3/RoomLabel

var current_location:Dictionary = {}

func _ready() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)

func on_current_location_update(new_val:Dictionary) -> void:	
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	FloorLabel.text = "%s" % [current_location.floor]
	WingLabel.text = "%s" % [current_location.ring]
	RoomLabel.text = "%s" % [current_location.room]
