extends PanelContainer

@onready var ItemContainer:VBoxContainer = $MarginContainer/VBoxContainer

const VListItemScene:PackedScene = preload("res://UI/VList/parts/VListItem.tscn")

var data:Array = [] : 
	set(val):
		data = val
		on_data_update()
		
var hide_selected:bool = false

var on_data_changed:Callable = func(new_data:Array) -> void:pass
var on_item_focus_change:Callable = func(state:bool, date:Dictionary) -> void:pass
var on_list_focus_change:Callable = func(state:bool) -> void:pass

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
		new_node.hide_selected = hide_selected
		new_node.on_item_focus_change = on_item_focus_change
		new_node.on_list_focus_change = on_list_focus_change
		new_node.on_opened_changed = func(state:bool) -> void:
			data[index].opened = state
			on_data_changed.call(data.duplicate(true))
			
		ItemContainer.add_child(new_node)
