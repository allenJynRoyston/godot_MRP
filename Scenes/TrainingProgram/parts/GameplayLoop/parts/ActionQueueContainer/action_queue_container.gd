@tool
extends GameContainer

@onready var SubviewPanelContainer:PanelContainer = $SubViewport/PanelContainer
@onready var ListContainer:VBoxContainer = $SubViewport/PanelContainer/MarginContainer/ListContainer

const ActionQueueItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ActionQueueContainer/parts/ActionQueueItem/ActionQueueItem.tscn")

var max_height:int : 
	set(val): 
		max_height = val
		on_max_height_update()

var action_queue_data:Array = [] : 
	set(val):
		action_queue_data = val
		on_action_queue_data_update()

var progress_data:Dictionary = {} : 
	set(val):
		progress_data = val
		
		
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
func on_action_queue_data_update() -> void:	
	for item_data in action_queue_data:
		if item_data.data.uid not in uid_refs:
			var new_node:Control = ActionQueueItemPreload.instantiate()
			ListContainer.add_child(new_node)
			new_node.data = item_data
			new_node.onClick = func() -> void:
				get_parent().goto_location(item_data.location)
			uid_refs[item_data.data.uid] = new_node
		else:
			uid_refs[item_data.data.uid].data = item_data

func on_queue_list_update() -> void:
	pass
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func remove_from_queue(remove_data:Array) -> void:
	for item_data in remove_data:
		if item_data.data.uid in uid_refs:
			await uid_refs[item_data.data.uid].animate_and_complete()
	
	wait_for_complete.emit()
# --------------------------------------------------------------------------------------------------				
