extends PanelContainer

@onready var ItemContainer:VBoxContainer = $VBoxContainer

const VListItemScene:PackedScene = preload("res://UI/VList/parts/VListItem.tscn")

var data:Array = [] : 
	set(val):
		data = val
		on_data_update()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_data_update()

func on_data_update() -> void:
	for child in ItemContainer.get_children():
		child.queue_free()
	
	for index in data.size():
		var item = data[index]
		var new_node:Control = VListItemScene.instantiate()		
		new_node.data = item
		new_node.parent_index = index		
		ItemContainer.add_child(new_node)
