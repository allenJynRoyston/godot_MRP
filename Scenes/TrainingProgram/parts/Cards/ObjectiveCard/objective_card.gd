extends MouseInteractions

# card
@onready var CardBody:Control = $CardBody
@onready var CardControlBody:PanelContainer = $CardBody/SubViewport/Control/CardBody
@onready var CardBodySubviewport:SubViewport = $CardBody/SubViewport

# drawer items
@onready var ObjectiveItemList:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/MarginContainer/VBoxContainer/ObjectiveItemList
@onready var OptionalObjectiveItemList:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/MarginContainer/VBoxContainer/OptionalObjectiveItemList
@onready var OptionalSeperator:HSeparator = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/MarginContainer/VBoxContainer/OptionalSeperator

# title/next/back buttons
@onready var CardDrawerTitle:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerTitle
@onready var BackBtn:BtnBase = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerTitle/HBoxContainer/BackBtn
@onready var NextBtn:BtnBase = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerTitle/HBoxContainer/NextBtn


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
		
var objectives:Dictionary = {} : 
	set(val):
		objectives = val
		on_objectives_update()
		
const ObjectiveItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ObjectivesContainer/parts/ObjectiveItem.tscn")

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
		new_btn.show_bookmark = false
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
		
	print(OptionalObjectiveItemList.get_child_count())
	OptionalSeperator.show() if OptionalObjectiveItemList.get_child_count() > 0 and !is_upcoming else OptionalSeperator.hide()

	await U.tick()
	CardControlBody.size.y = 0
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_btns() -> void:
	if !is_node_ready():return	
	BackBtn.static_color = Color(1, 1, 1, 0.5 if at_start else 1)
	NextBtn.static_color = Color(1, 1, 1, 0.5 if at_end else 1)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_title_update() -> void:
	if !is_node_ready():return	
	CardDrawerTitle.content = title
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_buttons() -> Array:
	var arr:Array = []
	for node in [OptionalObjectiveItemList, ObjectiveItemList]:
		for btn in node.get_children():
			arr.append(btn)
	return arr
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if !is_node_ready():return
	CardBodySubviewport.size = CardControlBody.size
# ------------------------------------------------------------------------------
	
