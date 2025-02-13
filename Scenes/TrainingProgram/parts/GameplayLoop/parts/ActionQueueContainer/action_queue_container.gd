@tool
extends GameContainer

@onready var ListContainer:VBoxContainer = $PanelContainer/MarginContainer/ListScrollContainer/ListContainer
@onready var ListScrollContainer:ScrollContainer = $PanelContainer/MarginContainer/ListScrollContainer

const ActionQueueItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ActionQueueContainer/parts/ActionQueueItem/ActionQueueItem.tscn")

var uid_refs:Dictionary = {}
var current_day:int 

signal wait_for_complete

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.ACTION_QUEUE_CONTAINER, self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.ACTION_QUEUE_CONTAINER)
	
func _ready() -> void:
	super._ready()	
	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_reset() -> void:
	for child in ListContainer.get_children():
		child.queue_free()
	uid_refs = {}
	
	for index in range(1, 100):
		var item_node:Control = ActionQueueItemPreload.instantiate()
		item_node.index = index
		ListContainer.add_child(item_node)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_progress_data_update(new_val:Dictionary) -> void:
	progress_data = new_val
	if !is_node_ready():return	
	var item_node:Control = ListContainer.get_child(progress_data.day)
	U.tween_node_property(ListScrollContainer, "scroll_vertical", progress_data.day * (item_node.size.y + 10), 0.3)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_action_queue_data_update(new_val:Array = action_queue_data) -> void:
	action_queue_data = new_val	
	if !is_node_ready():return

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
