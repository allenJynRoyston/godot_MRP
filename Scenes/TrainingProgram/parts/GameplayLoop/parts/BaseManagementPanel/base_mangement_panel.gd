extends SubscribeWrapper

@onready var FloorLabel:Label = $VBoxContainer/Content/MarginContainer/VBoxContainer/HBoxContainer/FloorLabel
@onready var RingLabel:Label = $VBoxContainer/Content/MarginContainer/VBoxContainer/HBoxContainer/RingLabel

func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val	
	U.debounce(str(self, "_update_node"), update_node)

func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	U.debounce(str(self, "_update_node"), update_node)
	
func update_node() -> void:
	if !is_node_ready() or current_location.is_empty():return
	FloorLabel.text = str(current_location.floor)
	RingLabel.text = str(current_location.ring)
