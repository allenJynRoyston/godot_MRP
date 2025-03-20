extends SubscribeWrapper

@onready var ResourceItemTech:Control = $MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItemTech
@onready var ResourceItemStaff:Control = $MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItemStaff
@onready var ResourceItemSecurity:Control = $MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItemSecurity
@onready var ResourceItemDClass:Control = $MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItemDClass

func on_room_config_update(new_val:Dictionary) -> void:
	super.on_room_config_update(new_val)
	U.debounce("update_resource_nodes", update_nodes)

func on_ring_changed() -> void:
	U.debounce("update_resource_nodes", update_nodes)


func update_nodes() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return
	var available_resources:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].available_resources
	for key in available_resources:
		var is_active:bool = available_resources[key]
		match key:
			RESOURCE.TYPE.TECHNICIANS:
				ResourceItemTech.title = "TCH"
				ResourceItemTech.is_negative = !is_active
			RESOURCE.TYPE.STAFF: 
				ResourceItemStaff.title = "STF"
				ResourceItemStaff.is_negative = !is_active
			RESOURCE.TYPE.SECURITY: 
				ResourceItemSecurity.title = "SEC"
				ResourceItemSecurity.is_negative = !is_active
			RESOURCE.TYPE.DCLASS: 
				ResourceItemDClass.title = "DCL"
				ResourceItemDClass.is_negative = !is_active	
