extends MouseInteractions

# card
@onready var CardBody:Control = $CardBody
@onready var CardControlBody:PanelContainer = $CardBody/SubViewport/Control/CardBody
@onready var CardBodySubviewport:SubViewport = $CardBody/SubViewport

# drawer items
@onready var ObjectiveItemList:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/MarginContainer/ObjectiveItemList

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
	
	for node in ObjectiveItemList.get_children():
		node.queue_free()
		
	for objective in objectives.list:
		var new_btn:Control = ObjectiveItemPreload.instantiate()
		new_btn.show_bookmark = false
		new_btn.is_naked = false
		new_btn.is_expired = is_expired
		new_btn.is_upcoming = is_upcoming
		new_btn.content = "???" if is_upcoming else objective.title
		new_btn.you_have = str(objective.you_have.call())
		new_btn.is_completed = true if is_expired else (false if is_upcoming else objective.is_completed.call())
		new_btn.onFocus = func(node:Control) -> void:
			for child in ObjectiveItemList.get_children():
				child.is_selected = child == node		
		
		ObjectiveItemList.add_child(new_btn)	
	
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
	return ObjectiveItemList.get_children()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:	
	if !is_node_ready():return	
	is_focused = state
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if !is_node_ready():return
	CardBodySubviewport.size = CardControlBody.size
# ------------------------------------------------------------------------------
	
