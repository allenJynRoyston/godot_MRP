extends PanelContainer

@onready var FloorLabel:Label = $HBoxContainer/PanelContainer2/MarginContainer2/VBoxContainer/HBoxContainer2/HBoxContainer2/FloorLabel
@onready var RingLabel:Label = $HBoxContainer/PanelContainer3/MarginContainer2/VBoxContainer/HBoxContainer2/HBoxContainer2/RingLabel

var current_location:Dictionary = {}

func _ready() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)


func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	

func on_current_location_update(new_val:Dictionary) -> void:	
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	FloorLabel.text = "%s" % [current_location.floor]
	RingLabel.text = "%s" % [current_location.ring]
