extends SubscribeWrapper

@onready var ResourceItem:Control = $MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItem

func on_room_config_update(new_val:Dictionary) -> void:
	super.on_room_config_update(new_val)
	U.debounce("update_energy_panel", update_nodes)

func on_ring_changed() -> void:
	U.debounce("update_energy_panel", update_nodes)

func on_floor_changed() -> void:
	U.debounce("update_energy_panel", update_nodes)

func update_nodes() -> void:
	if room_config.is_empty():return
	var energy:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].energy
	if energy.is_empty():return
	var available:int = energy.available
	var used:int = energy.used
	ResourceItem.title = "%s/%s" % [available - used, available]	
	ResourceItem.is_negative = available == used
