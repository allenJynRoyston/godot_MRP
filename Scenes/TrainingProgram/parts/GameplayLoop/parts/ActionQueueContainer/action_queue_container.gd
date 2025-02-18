@tool
extends GameContainer

@onready var Gradiant:TextureRect = $Gradiant
@onready var DetectorPanel:PanelContainer = $DetectorPanel
@onready var MarginContainerUI:MarginContainer = $DetectorPanel/MarginContainer
@onready var ListContainer:VBoxContainer = $DetectorPanel/MarginContainer/ListScrollContainer/ListContainer
@onready var ListScrollContainer:ScrollContainer =$DetectorPanel/MarginContainer/ListScrollContainer

const ActionQueueItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ActionQueueContainer/parts/ActionQueueItem/ActionQueueItem.tscn")
const delay:float = 0.7

var uid_refs:Dictionary = {}
var current_day:int 
var is_setup:bool = false
var show_position:Dictionary = {}
var hide_position:Dictionary = {}

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
	show_position[Gradiant] = Gradiant.position
	hide_position[Gradiant] = Gradiant.position + Vector2(500, 0)
	
	DetectorPanel.onFocus = func() -> void:
		U.tween_node_property(Gradiant, "position:x", show_position[Gradiant].x)
	DetectorPanel.onBlur = func() -> void:
		U.tween_node_property(Gradiant, "position:x", hide_position[Gradiant].x)		
		
	# move into place
	U.tween_node_property(Gradiant, "position:x", hide_position[Gradiant].x, 0.02)	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_reset() -> void:
	for child in ListContainer.get_children():
		child.queue_free()
	uid_refs = {}
	
	for index in range(1, 100):
		var item_node:Control = ActionQueueItemPreload.instantiate()
		item_node.index = index
		item_node.delay = delay
		ListContainer.add_child(item_node)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_progress_data_update(new_val:Dictionary) -> void:
	progress_data = new_val
	if !is_node_ready():return	
	await U.tick()
	var item_node:Control = ListContainer.get_child(progress_data.day - 1)
	var new_pos:int = 0
	for index in ListContainer.get_child_count():
		if index < progress_data.day:
			var node:Control = ListContainer.get_child(index)
			new_pos += node.size.y + 10
	
	if !is_setup:
		is_setup = true
		ListScrollContainer.scroll_vertical = new_pos
		return
		
	U.tween_node_property(ListScrollContainer, "scroll_vertical", new_pos, delay, 0.5)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_is_showing_update() -> void:
	super.on_is_showing_update()
	show() if is_showing else hide()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_timeline_array_update(new_val:Array = timeline_array) -> void:
	timeline_array = new_val	
	if !is_node_ready():return

func on_queue_list_update() -> void:
	pass
# --------------------------------------------------------------------------------------------------	
