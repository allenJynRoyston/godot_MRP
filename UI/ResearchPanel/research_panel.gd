extends SubscribeWrapper

@onready var ResourceItem:Control = $MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItem

func on_resources_data_update(new_val:Dictionary) -> void:
	resources_data = new_val
	if !is_node_ready():return
	ResourceItem.title = str(resources_data[RESOURCE.TYPE.MONEY].amount)
