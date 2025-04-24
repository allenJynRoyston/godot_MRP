@tool
extends MouseInteractions

@onready var CardTextureRect:TextureRect = $CardBody/TextureRect

@onready var CardBody:Control = $CardBody

@onready var CardDrawerImage:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage
@onready var CardDrawerName:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/CardDrawerName
@onready var CardDrawerLevel:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/CardDrawerLevel
@onready var CardDrawerAssigned:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerAssigned
@onready var CardDrawerSpec:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer2/CardDrawerSpec
@onready var CardDrawerTraits:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer2/CardDrawertrait

@onready var CardDrawerImageBack:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerImage

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
		
#var researcher_details:Dictionary = {} : 
	#set(val):
		#researcher_details = val
		#on_researcher_details_update()
		
const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var index:int = -1
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	on_uid_update()
	on_reveal_update()
	on_is_active_update()
	on_is_selected_update()
	on_is_deselected_update()
	on_show_assigned_update()
	
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
	CardDrawerAssigned.show() if show_assigned else CardDrawerAssigned.hide()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_uid_update() -> void:
	if !is_node_ready():return		
	
	var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(uid)	
	
	if uid == "-1" or researcher_details.is_empty():
		CardDrawerImage.use_static = true
		for node in [CardDrawerName, CardDrawerLevel, CardDrawerSpec, CardDrawerTraits, CardDrawerAssigned]:
			node.content = "-"
		return
		
	CardDrawerImage.use_static = false
	CardDrawerImage.img_src = researcher_details.img_src
	CardDrawerImageBack.img_src = researcher_details.img_src
	CardDrawerName.content = researcher_details.name
	CardDrawerLevel.content = str(researcher_details.level)

	if !researcher_details.props.assigned_to_room.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details(researcher_details.props.assigned_to_room)
		if extract_data.is_empty():return
		CardDrawerAssigned.content = extract_data.room.details.name
	else:
		CardDrawerAssigned.content = "None"


	var spec_str:String = ""
	for spec_id in researcher_details.specializations:
		var dict:Dictionary = RESEARCHER_UTIL.return_specialization_data(spec_id)
		spec_str += dict.name + " / "
	spec_str = spec_str.left(spec_str.length() - 3)
	CardDrawerSpec.content = spec_str
	
	var trait_str:String = ""
	for trait_id in researcher_details.traits:
		var dict:Dictionary = RESEARCHER_UTIL.return_trait_data(trait_id)
		trait_str += dict.name + " / "
	trait_str = trait_str.left(trait_str.length() - 3)
	CardDrawerTraits.content = trait_str
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
