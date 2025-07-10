extends GameContainer

@onready var MainPanel:PanelContainer = $Control/PanelContainer
@onready var MainMargin:MarginContainer = $Control/PanelContainer/MarginContainer

@onready var DetectorPanel:PanelContainer = $Control/PanelContainer/DetectorPanel
@onready var Gradiant:TextureRect = $Control/PanelContainer/DetectorPanel/Gradiant

@onready var ObjectiveList:VBoxContainer = $Control/PanelContainer/MarginContainer/VBoxContainer/ObjectiveList

const ObjectiveItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ObjectivesContainer/parts/ObjectiveItem.tscn")
const delay:float = 0.3

var current_day:int 
var is_setup:bool = false

signal wait_for_complete

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.MARKED_OBJECTIVES, self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.MARKED_OBJECTIVES)
	
func _ready() -> void:
	super._ready()	
	Gradiant.modulate = Color(1, 1, 1, 0)
	
	DetectorPanel.onFocus = func() -> void:
		if control_pos.is_empty():return
		fade_in_gradiant(true)

	DetectorPanel.onBlur = func() -> void:
		if control_pos.is_empty():return
		fade_in_gradiant(false)
	
	await U.tick()
	
	control_pos[MainPanel] = {
		"show": 0, 
		"hide": -MainMargin.size.x
	}	
	
	MainPanel.position.x = control_pos[MainPanel].hide
	on_reset()
	
func on_reset() -> void:
	for child in ObjectiveList.get_children():
		child.queue_free()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_room_config_update(new_val:Dictionary) -> void:
	super.on_room_config_update(new_val)
	if !is_node_ready():return

	for index in bookmarked_objectives.size():
		var objective:Dictionary = bookmarked_objectives[index]		
		var btn:Control = ObjectiveList.get_child(index)
		btn.you_have = objective.count_str.call(objective.you_have.call())
		btn.is_completed = objective.is_completed.call()
		btn._ready()
	
# --------------------------------------------------------------------------------------------------	

	
# --------------------------------------------------------------------------------------------------	
func on_bookmarked_objectives_update(new_val:Array) -> void:
	super.on_bookmarked_objectives_update(new_val)
	if !is_node_ready():return
	on_reset()
	for objective in new_val:
		var new_btn:Control = ObjectiveItemPreload.instantiate()
		new_btn.is_naked = true
		new_btn.is_expired = false
		new_btn.is_upcoming = false
		new_btn.is_optional = objective.is_optional
		new_btn.content = objective.title
		new_btn.you_have = objective.count_str.call(objective.you_have.call())
		new_btn.is_completed = objective.is_completed.call()
		ObjectiveList.add_child(new_btn)		
	
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------	
func fade_in_gradiant(state:bool) -> void:
	U.tween_node_property(Gradiant, "modulate", Color(1, 1, 1, 1 if state else 0))
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos() -> void:	
	await U.tick()

	control_pos[MainPanel] = {
		"show": 0, 
		"hide": -MainMargin.size.x
	}	
	
	on_is_showing_update(true)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func show_details(state:bool) -> void:
	fade_in_gradiant(state)
	
	for child in ObjectiveList.get_children():
		for item in child.get_items():
			item.show_details = state
# --------------------------------------------------------------------------------------------------	

# -----------------------------------------------
func on_is_showing_update(skip_animation:bool = false) -> void:	
	super.on_is_showing_update()	
	if !is_node_ready() or control_pos.is_empty():return
	var duration:float = 0 if skip_animation else 0.7

	U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].show if is_showing else control_pos[MainPanel].hide, duration)	
# -----------------------------------------------	
