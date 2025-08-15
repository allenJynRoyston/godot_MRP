@tool
extends SubscribeWrapper

@onready var List:HBoxContainer = $VBoxContainer/List

func _ready() -> void:
	for node in List.get_children():
		node.show()

func on_current_location_update(new_val:Dictionary) -> void:
	if !is_node_ready() or new_val.is_empty(): return
	for index in List.get_child_count():
		var panel_node:Control = List.get_child(index)
		panel_node.show()
		panel_node.is_selected = new_val.ring == index
