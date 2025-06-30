@tool
extends MouseInteractions

@onready var CardBody:Control = $CardBody
@onready var CardTextureRect:TextureRect = $CardBody/TextureRect

# status panel
@onready var StatusPanel:MarginContainer = $Status
@onready var StatusLabel:Label = $CardBody/SubViewport/Control/CardBody/StatusPanel/PanelContainer/CenterContainer/HBoxContainer/Label

# FRONT
@onready var FrontImage:PanelContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/FrontImage
@onready var FrontName:PanelContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/FrontName
@onready var FrontLevel:PanelContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/FrontLevel
@onready var AssignedTo:PanelContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/AssignedTo

# BACK
@onready var BackName:PanelContainer = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/BackName
@onready var Health:PanelContainer = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/HBoxContainer/Health
@onready var Sanity:PanelContainer = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/HBoxContainer/Sanity
@onready var BackImage:PanelContainer = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/BackImage
@onready var BackTrait:PanelContainer = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/HBoxContainer2/BackTrait
@onready var BackMood:PanelContainer = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/HBoxContainer2/BackMood

@export var card_border_color:Color = Color(0.0, 0.638, 0.337) : 
	set(val): 
		card_border_color = val 
		on_is_selected_update()

const BlackAndWhiteShader:ShaderMaterial = preload("res://Shader/BlackAndWhite/template.tres")
#const CardShader:ShaderMaterial = preload("res://CanvasShader/CardShader/CardShader.tres")

@export var uid:String = "": 
	set(val):
		uid = val
		on_uid_update()

@export var flip:bool = false : 
	set(val):
		flip = val
		on_flip_update()
		
@export var reveal:bool = false : 
	set(val):
		reveal = val
		on_reveal_update()		

@export var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()
		
@export var show_checkbox:bool = false : 
	set(val):
		show_checkbox = val
		on_show_checkbox_update()
		
@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
		
@export var is_deselected:bool = false : 
	set(val):
		is_deselected = val
		on_is_deselected_update()
		
@export var promotion_preview:bool = false : 
	set(val):
		promotion_preview = val
		on_promotion_preview_update()
		
@export var show_assigned:bool = false : 
	set(val):
		show_assigned = val
		on_show_assigned_update()
		
var researcher_details:Dictionary = {} : 
	set(val):
		researcher_details = val
		on_researcher_details_update()
		
const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var index:int = -1
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	StatusPanel.hide()

	on_uid_update()
	on_reveal_update()
	on_is_active_update()
	on_is_selected_update()
	on_is_deselected_update()
	on_show_assigned_update()
	on_researcher_details_update()
	
	await U.tick()
	CardTextureRect.pivot_offset = self.size/2
	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_flip_update() -> void:
	if !is_node_ready():return
	CardBody.flip = flip

func on_is_active_update() -> void:
	if !is_node_ready():return

func on_show_checkbox_update() -> void:
	if !is_node_ready():return

func on_is_selected_update() -> void:
	if !is_node_ready():return
	CardBody.border_color = card_border_color if is_selected else card_border_color.darkened(0.1)
	
func on_is_deselected_update() -> void:
	if !is_node_ready():return
	CardTextureRect.material = BlackAndWhiteShader if is_deselected else null

func on_reveal_update() -> void:
	if !is_node_ready():return
	CardBody.reveal = reveal

func on_show_assigned_update() -> void:
	if !is_node_ready():return
	#CardDrawerAssigned.show() if show_assigned else CardDrawerAssigned.hide()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_researcher_details_update() -> void:
	if !is_node_ready() or researcher_details.is_empty():return
	update_nodes(researcher_details)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_uid_update() -> void:
	if !is_node_ready():return		
	
	var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(uid)		
	
	if uid == "-1" or researcher_details.is_empty():
		FrontImage.use_static = true
		for node in [FrontName, BackName, FrontLevel, BackTrait, BackMood]:
			node.content = "-"
		return
	
	
	update_nodes(researcher_details)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_nodes(researcher_details:Dictionary) -> void:
	FrontImage.use_static = false
	
	for node in [FrontImage, BackImage]:
		node.img_src = researcher_details.img_src
		node.use_static = false
		node.title = "RESEARCHER %s" % researcher_details.name
		
	FrontName.content = researcher_details.name
	FrontLevel.content = str(researcher_details.level)

	if !researcher_details.props.assigned_to_room.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details(researcher_details.props.assigned_to_room)
		if extract_data.is_empty():return
		AssignedTo.content = extract_data.room.details.name
	else:
		AssignedTo.content = "None"

	print(researcher_details.mood.details)
	BackMood.content = researcher_details.mood.details.name
	BackTrait.content = researcher_details.trait.details.name
	
# ------------------------------------------------------------------------------
	
	
# ------------------------------------------------------------------------------
func on_promotion_preview_update() -> void:
	if !is_node_ready():return
	on_uid_update()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:	
	if !is_node_ready():return	
	is_focused = state
	onFocus.call(self) if state else onBlur.call(self)	
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)


func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT:		
		onClick.call()
# ------------------------------------------------------------------------------
