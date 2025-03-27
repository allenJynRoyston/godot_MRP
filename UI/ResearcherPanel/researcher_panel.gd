extends SubscribeWrapper

@onready var ResourceItem:Control = $MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItem

func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	super.on_hired_lead_researchers_arr_update(new_val)
	if !is_node_ready():return
	print(new_val)
	ResourceItem.title = "%s/%s" % [1, 3]
