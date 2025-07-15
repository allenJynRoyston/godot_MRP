extends MouseInteractions

# card
@onready var CardBody:Control = $CardBody
@onready var CardControlBody:PanelContainer = $CardBody/SubViewport/Control/CardBody
@onready var CardBodySubviewport:SubViewport = $CardBody/SubViewport

# drawer items
@onready var Required:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/MarginContainer/VBoxContainer/Required
@onready var ObjectiveItemList:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/MarginContainer/VBoxContainer/Required/ObjectiveItemList

@onready var Optional:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/MarginContainer/VBoxContainer/Optional
@onready var OptionalObjectiveItemList:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/MarginContainer/VBoxContainer/Optional/OptionalObjectiveItemList

# 
@onready var CompleteContainer:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/MarginContainer/VBoxContainer/Complete
@onready var CompleteByObjective:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/MarginContainer/VBoxContainer/Complete/CompleteByObjective

# title/next/back buttons
@onready var TitleLabel:Label = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerTitle/HBoxContainer/TitleLabel
@onready var PrevIcon:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerTitle/HBoxContainer/PrevIcon
@onready var NextIcon:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerTitle/HBoxContainer/NextIcon

@export var is_upcoming:bool = false
@export var is_expired:bool = false

@export var title:String = "" : 
	set(val):
		title = val
		on_title_update()
		
@export var at_end:bool = false : 
	set(val):
		at_end = val
		update_btns()
		
@export var at_start:bool = false : 
	set(val):
		at_start = val
		update_btns()
		
@export var complete_by_day:int = 0 : 
	set(val):
		complete_by_day = val
		on_completed_by_day_update()
		
@export var show_completed_by:bool = true : 
	set(val):
		show_completed_by = val
		on_show_completed_by_update()

const ObjectiveItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ObjectivesContainer/parts/ObjectiveItem.tscn")


var objectives:Dictionary = {} : 
	set(val):
		objectives = val
		on_objectives_update()
		
signal objectives_updated

# ------------------------------------------------------------------------------
func _ready() -> void:
	on_show_completed_by_update()
	on_completed_by_day_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_objectives_update() -> void:
	if !is_node_ready():return
	for node in [ObjectiveItemList, OptionalObjectiveItemList]:
		for child in node.get_children():
			child.queue_free()
	
	for index in objectives.list.size():
		var objective:Dictionary = objectives.list[index]
		var new_btn:Control = ObjectiveItemPreload.instantiate()
		var is_optional:bool = objective.is_optional
		
		new_btn.index = index
		new_btn.is_naked = false
		new_btn.is_optional = is_optional
		new_btn.is_expired = is_expired
		new_btn.is_upcoming = is_upcoming
		new_btn.content = "???" if is_upcoming else objective.title
		new_btn.you_have = objective.count_str.call(objective.you_have.call())
		new_btn.is_completed = true if is_expired else (false if is_upcoming else objective.is_completed.call())
		
		if is_optional:
			OptionalObjectiveItemList.add_child(new_btn)
		else:
			ObjectiveItemList.add_child(new_btn)	
			
	await U.tick()
	Optional.show() if (OptionalObjectiveItemList.get_child_count() > 0 and !is_upcoming) else Optional.hide()
	objectives_updated.emit()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_completed_by_day_update() -> void:
	if !is_node_ready():return
	CompleteByObjective.content = "COMPLETE OBJECTIVES\rBY DAY %s." % complete_by_day
	CompleteByObjective.hint_title = "HINT"
	CompleteByObjective.hint_description = "Objectives must be completed by day %s." % complete_by_day

func on_show_completed_by_update() -> void:
	if !is_node_ready():return
	CompleteContainer.show() if show_completed_by else CompleteContainer.hide()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_btns() -> void:
	if !is_node_ready():return	
	PrevIcon.icon_color.a = 0.5 if at_start else 1
	NextIcon.icon_color.a = 0.5 if at_end else 1
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_title_update() -> void:
	if !is_node_ready():return	
	TitleLabel.text = title
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func set_selected_node(node:Control) -> void:
	CompleteByObjective.is_selected = node == CompleteByObjective
	
	for NodeItem in [OptionalObjectiveItemList, ObjectiveItemList]:
		for n in NodeItem.get_children():
			n.is_selected =  n == node	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_buttons() -> Array:
	var arr:Array = []
	for node in [ObjectiveItemList, OptionalObjectiveItemList]:
		for btn in node.get_children():
			arr.push_back(btn)
	
	if CompleteByObjective.is_visible_in_tree():
		arr.push_back(CompleteByObjective)
		
	return arr
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if !is_node_ready():return
	CardBodySubviewport.size = CardControlBody.size
# ------------------------------------------------------------------------------
	
