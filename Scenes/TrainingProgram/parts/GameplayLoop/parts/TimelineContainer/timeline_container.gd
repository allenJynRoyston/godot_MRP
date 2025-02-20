extends GameContainer

@onready var MainPanel:MarginContainer = $Control/MarginContainer
@onready var Gradiant:TextureRect = $Control/DetectorPanel/Gradiant
@onready var DetectorPanel:PanelContainer = $Control/DetectorPanel
@onready var DayLabel:Label = $Control/MarginContainer/VBoxContainer/DayLabel
@onready var ListContainer:VBoxContainer = $Control/MarginContainer/VBoxContainer/ListScrollContainer/ListContainer
@onready var ListScrollContainer:ScrollContainer = $Control/MarginContainer/VBoxContainer/ListScrollContainer

const TimelineItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/TimelineContainer/parts/TimelineItem/TimelineItem.tscn")
const delay:float = 0.7

var uid_refs:Dictionary = {}
var current_day:int 
var is_setup:bool = false
var show_position:Dictionary = {}
var hide_position:Dictionary = {}
var restore_pos:int
signal wait_for_complete

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.TIMELINE, self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.TIMELINE)
	
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
	
	await U.set_timeout(1.0)	
	restore_pos = MainPanel.position.x
	on_progress_data_update.call_deferred()
	on_is_showing_update()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_reset() -> void:
	for child in ListContainer.get_children():
		child.queue_free()
	uid_refs = {}
	
	for index in range(1, 100):
		var item_node:Control = TimelineItemPreload.instantiate()
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
		await U.set_timeout(1.0)
		
	DayLabel.text = "DAY %s" % [progress_data.day]

	U.tween_node_property(ListScrollContainer, "scroll_vertical", new_pos, delay, 0.5)
# --------------------------------------------------------------------------------------------------	

# -----------------------------------------------
func on_is_showing_update() -> void:	
	super.on_is_showing_update()	
	if !is_setup:return
	U.tween_node_property(MainPanel, "position:x", restore_pos if is_showing else restore_pos + MainPanel.size.x, 0.7)	
# -----------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_timeline_array_update(new_val:Array = timeline_array) -> void:
	timeline_array = new_val	
	if !is_node_ready():return

func on_queue_list_update() -> void:
	pass
# --------------------------------------------------------------------------------------------------	
