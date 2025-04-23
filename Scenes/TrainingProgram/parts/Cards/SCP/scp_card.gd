@tool
extends MouseInteractions

@onready var OutputTextureRect:TextureRect = $CardBody/TextureRect

@onready var CardBody:Control = $CardBody
#front
@onready var CardDrawerImage:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage
@onready var CardDrawerDesignation:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer3/CardDrawerDesignation
@onready var CardDrawerLevel:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer3/CardDrawerLevel
@onready var CardDrawerNickname:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerNickname
@onready var CardDrawerItemClass:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerItemClass
@onready var CardDrawerSupplies:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerSupplies
@onready var CardDrawerRewards:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerRewards
@onready var CardDrawerAssigned:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerAssigned
@onready var CardDrawerSpec:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer2/CardDrawerSpec
@onready var CardDrawerTrait:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer2/CardDrawertrait
# back
@onready var CardDrawerContainmentInfo:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerContainmentInfo
@onready var CardDrawerRequired:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerRequired

@export var ref:int = -1: 
	set(val):
		ref = val
		on_ref_update()

@export var flip:bool = false : 
	set(val):
		flip = val
		on_flip_update()
		
@export var show_assigned:bool = false : 
	set(val):
		show_assigned = val
		on_show_assigned_update()
		
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
		
@export var card_border_color:Color = Color(0.408, 0.42, 1.0) : 
	set(val): 
		card_border_color = val 
		on_is_selected_update()

const BlackAndWhiteShader:ShaderMaterial = preload("res://Shader/BlackAndWhite/template.tres")

var index:int = -1
var use_location:Dictionary = {}
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	on_ref_update()
	on_reveal_update()
	on_is_active_update()
	on_is_selected_update()
	on_is_deselected_update()
	on_show_assigned_update()
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

func on_show_assigned_update() -> void:
	if !is_node_ready():return
	CardDrawerAssigned.show() if show_assigned else CardDrawerAssigned.hide()

func on_is_deselected_update() -> void:
	if !is_node_ready():return
	OutputTextureRect.material = BlackAndWhiteShader if is_deselected else null

func on_reveal_update() -> void:
	if !is_node_ready():return
	CardBody.reveal = reveal

# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_ref_update() -> void:
	if !is_node_ready():return	
	
	if ref not in SCP_UTIL.reference_data:
		CardDrawerImage.use_static = true
		for node in [CardDrawerDesignation, CardDrawerLevel, CardDrawerNickname, CardDrawerItemClass, CardDrawerRequired, CardDrawerSpec, CardDrawerTrait]:
			node.content = "-"
		return
		
	var scp_data:Dictionary = SCP_UTIL.return_data(ref)
	var rewards:Array = SCP_UTIL.return_ongoing_containment_rewards(ref)
	#var passes_metric_check:bool = SCP_UTIL.passes_metric_check(ref, use_location)
	#var metrics:Dictionary = {
		#"passes_metric_check": passes_metric_check,
	#}
	#
	#
	#for ref in scp_data.effects.metrics:
		#var needed:int = scp_data.effects.metrics[ref]
		#metrics[ref] = {
			#"needed": needed,
			#"current": 2
		#}
		
	var required_str:String = ""
	for ref in scp_data.required_for_containment.profession:
		required_str += str(RESEARCHER_UTIL.return_specialization_data(ref).name + " or ")
	for ref in scp_data.required_for_containment.traits:
		required_str += str(RESEARCHER_UTIL.return_trait_data(ref).name + " or ")
	required_str = required_str.left(required_str.length() - 4)

	CardDrawerDesignation.content = scp_data.name
	CardDrawerNickname.content = scp_data.nickname
	CardDrawerItemClass.content = scp_data.item_class
	
	CardDrawerImage.img_src = scp_data.img_src
	CardDrawerImage.use_static = false
	CardDrawerRewards.list = rewards.map(func(x): return {"icon": x.resource.icon, "title": str(x.amount)})
	
	#CardDrawerContainmentInfo.metrics = metrics
	CardDrawerContainmentInfo.effects = scp_data.effects
	CardDrawerRequired.content = required_str
	
	
	

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
