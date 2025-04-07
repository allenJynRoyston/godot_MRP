extends GameContainer

@onready var MainPanel:MarginContainer = $Control/MarginContainer
@onready var DetectorPanel:PanelContainer = $Control/DetectorPanel

@onready var Gradiant:TextureRect = $Control/DetectorPanel/Gradiant
@onready var DayLabel:Label = $Control/MarginContainer/VBoxContainer/DayLabel
@onready var ListContainer:VBoxContainer = $Control/MarginContainer/VBoxContainer/MarginContainer/ListScrollContainer/ListContainer
@onready var ListScrollContainer:ScrollContainer = $Control/MarginContainer/VBoxContainer/MarginContainer/ListScrollContainer

const TimelineItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/TimelineContainer/parts/TimelineItem/TimelineItem.tscn")
const delay:float = 0.3

var uid_refs:Dictionary = {}
var current_day:int 
var is_setup:bool = false


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
	
	DetectorPanel.onFocus = func() -> void:
		if control_pos.is_empty():return
		U.tween_node_property(Gradiant, "position:x", control_pos[Gradiant].show)
	DetectorPanel.onBlur = func() -> void:
		if control_pos.is_empty():return
		U.tween_node_property(Gradiant, "position:x", control_pos[Gradiant].hide)		
		

	
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
func activate() -> void:
	show()
	await U.tick()
	
	control_pos_default[Gradiant] = Gradiant.position
	control_pos_default[MainPanel] = MainPanel.position
	control_pos_default[DetectorPanel] = DetectorPanel.position
	
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos() -> void:	
	await U.tick()
	var h_diff:int = (1080 - 720) # difference between 1080 and 720 resolution - gives you 360
	var y_diff =  (0 if !GBL.is_fullscreen else h_diff) if !initalized_at_fullscreen else (0 if GBL.is_fullscreen else -h_diff)
	
	control_pos[Gradiant] = {
		"show": control_pos_default[Gradiant].x, 
		"hide": control_pos_default[Gradiant].x - Gradiant.size.x
	}
	
	control_pos[MainPanel] = {
		"show": control_pos_default[MainPanel].x, 
		"hide": control_pos_default[MainPanel].x + MainPanel.size.x
	}	
	
	control_pos[DetectorPanel] = {
		"show": control_pos_default[DetectorPanel].x, 
		"hide": control_pos_default[DetectorPanel].x + DetectorPanel.size.x
	}		
	
	on_is_showing_update(true)
# --------------------------------------------------------------------------------------------------	

# -----------------------------------------------
func on_is_showing_update(skip_animation:bool = false) -> void:	
	super.on_is_showing_update()	
	if !is_node_ready() or control_pos.is_empty():return

	U.tween_node_property(Gradiant, "position:x", control_pos[Gradiant].show if is_showing else control_pos[Gradiant].hide, 0 if skip_animation else 0.3)	
	U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].show if is_showing else control_pos[MainPanel].hide, 0 if skip_animation else 0.7)	
# -----------------------------------------------	


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
	
		
	DayLabel.text = "DAY %s" % [progress_data.day]

	U.tween_node_property(ListScrollContainer, "scroll_vertical", new_pos, delay, 0.5)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_timeline_array_update(new_val:Array = timeline_array) -> void:
	timeline_array = new_val	
	if !is_node_ready():return
# --------------------------------------------------------------------------------------------------	
