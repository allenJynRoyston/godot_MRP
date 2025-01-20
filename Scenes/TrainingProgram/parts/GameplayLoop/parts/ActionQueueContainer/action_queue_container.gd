@tool
extends GameContainer

@onready var SubviewPanelContainer:PanelContainer = $SubViewport/PanelContainer
@onready var ListContainer:VBoxContainer = $SubViewport/PanelContainer/MarginContainer/ListContainer

const ActionQueueItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ActionQueueContainer/parts/ActionQueueItem/ActionQueueItem.tscn")

var max_height:int : 
	set(val): 
		max_height = val
		on_max_height_update()

var uid_refs:Dictionary = {}

signal wait_for_complete

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_reset() -> void:
	for child in ListContainer.get_children():
		child.queue_free()
	uid_refs = {}
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_max_height_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		Subviewport.get_child(0).size.y = max_height - 1
		Subviewport.size = Subviewport.get_child(0).size
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_action_queue_data_update(new_val:Array = action_queue_data) -> void:
	action_queue_data = new_val	
	if !is_node_ready():return
	
	for item_data in action_queue_data:
		# create new item if it hasn't been added
		if item_data.uid not in uid_refs:
			var new_node:Control = ActionQueueItemPreload.instantiate()
			new_node.data = item_data
			new_node.onClick = func() -> void:
				if "location" in item_data:
					get_parent().goto_location(item_data.location)
			new_node.onCancel = func() -> void:
				get_parent().cancel_action_queue(item_data)
			ListContainer.add_child(new_node)
				
			uid_refs[item_data.uid] = new_node
		# ...else update it
		else:
			uid_refs[item_data.uid].data = item_data

func on_queue_list_update() -> void:
	pass
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func remove_from_queue(list:Array) -> void:
	for item_data in list:
		if item_data.uid in uid_refs:
			var action_queue_item:Control = uid_refs[item_data.uid]
			await action_queue_item.animate_and_complete()
			action_queue_item.queue_free()
			uid_refs.erase(item_data.uid)
	
	wait_for_complete.emit()
# --------------------------------------------------------------------------------------------------				
