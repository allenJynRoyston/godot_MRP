extends PanelContainer

@onready var SCPItemList:VBoxContainer = $MarginContainer/PanelContainer/VBoxContainer/SCPItemList

enum LIST_TYPE {CONTAINED, AVAILABLE}

const SCPListItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ContainmentContainer/parts/SCPList/SCPListItem/SCPListItem.tscn")

var scp_data:Dictionary = {} 

var list_type:LIST_TYPE = LIST_TYPE.AVAILABLE : 
	set(val):
		list_type = val
		on_list_type_update()

var onUpdate:Callable = func(data:Dictionary):pass

# --------------------------------------------------------------------------------------------------		
func _init() -> void:
	SUBSCRIBE.subscribe_to_scp_data(self)

func _exit_tree() -> void: 
	SUBSCRIBE.unsubscribe_to_scp_data(self)

func _ready() -> void:
	on_list_type_update()
# --------------------------------------------------------------------------------------------------		
	
# --------------------------------------------------------------------------------------------------		
func on_list_type_update() -> void:
	if !is_node_ready():return
	on_scp_data_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val
	if !is_node_ready() or scp_data.is_empty():return
	
	for child in SCPItemList.get_children():
		child.queue_free()
		
	match list_type:
		LIST_TYPE.AVAILABLE:
			for index in scp_data.available_list.size():
				var data:Dictionary = scp_data.available_list[index]
				var new_item:Control = SCPListItemPreload.instantiate()
				new_item.data = data
				new_item.is_active = false
				new_item.onClick = func() -> void:
					on_toggle_active(index)
				
				SCPItemList.add_child(new_item)
		LIST_TYPE.CONTAINED:
			pass
# --------------------------------------------------------------------------------------------------		

func on_toggle_active(active_index:int) -> void:
	for index in SCPItemList.get_child_count():
		var node:Control = SCPItemList.get_child(index)
		if active_index == index:
			node.is_active = !node.is_active
			var data:Dictionary = scp_data.available_list[active_index]
			onUpdate.call(SCP_UTIL.return_data(data.id) if node.is_active else {})
		else:
			node.is_active = false
	
