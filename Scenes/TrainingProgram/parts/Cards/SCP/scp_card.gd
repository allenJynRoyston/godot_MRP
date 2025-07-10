@tool
extends MouseInteractions

@onready var CardBody:Control = $CardBody
@onready var OutputTextureRect:TextureRect = $CardBody/TextureRect
#front
@onready var CardDrawerImage:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage
@onready var CardDrawerDesignation:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer3/CardDrawerDesignation
@onready var CardDrawerLevel:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/CardDrawerLevel
@onready var CardDrawerName:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/CardDrawerName
#@onready var CardDrawerItemClass:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer3/CardDrawerItemClass
@onready var CardDrawerAssigned:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerAssigned
@onready var CardDrawerVibes:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerVibes
@onready var CardDrawerCurrency:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerCurrency

# back
@onready var CardDrawerDescription:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerDescription

#@onready var CardDrawerEffect:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerEffect
#@onready var CardDrawerBreach:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerBreach
#@onready var CardDrawerNeutralize:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerNeutralize

#@onready var CardDrawerPairsWith:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerPairsWith
#@onready var CardDrawerCurrency:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerCurrency

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
		
@export var show_assigned_researcher:bool = false : 
	set(val):
		show_assigned_researcher = val
		on_show_assigned_researcher_update()
		
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

var scp_data:Dictionary = {}

var index:int = -1
var use_location:Dictionary = {}
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_scp_data(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_scp_data(self)	
	
func _ready() -> void:
	super._ready()

	on_ref_update()
	on_reveal_update()
	on_is_active_update()
	on_is_selected_update()
	on_is_deselected_update()
	on_show_assigned_update()
	on_scp_data_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val
	on_ref_update()

func on_flip_update() -> void:
	if !is_node_ready():return
	CardBody.flip = flip

func on_is_active_update() -> void:
	if !is_node_ready():return

func on_show_assigned_researcher_update() -> void:
	if !is_node_ready():return
	CardDrawerAssigned.show() if show_assigned_researcher else CardDrawerAssigned.hide()

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
		for node in [CardDrawerLevel, CardDrawerDesignation, CardDrawerDescription]:
			node.content = "-"
		return
		
	var scp_details:Dictionary = SCP_UTIL.return_data(ref)
	var currency_list:Array = []
	var has_spec_bonus:bool = false
	var has_trait_bonus:bool = false
	var morale_val:int = 0	
	var research_level:int = 0 if ref not in scp_data else scp_data[ref].level
	
	var hide_currency:bool = true
	for item in currency_list:
		var amount:int = int(item.title)
		if amount != 0:
			hide_currency = false
			break
			
	var hide_metrics:bool = true
	for key in scp_details.metrics:
		var amount:int = scp_details.metrics[key]
		if amount != 0:
			hide_metrics = false
			break	
	
	# -----------
	CardDrawerDesignation.content = scp_details.name
	CardDrawerName.content = scp_details.nickname
	CardDrawerDescription.content = scp_details.abstract.call(scp_details)
	CardDrawerImage.img_src = scp_details.img_src
	CardDrawerImage.use_static = false	
	CardDrawerLevel.content = str(research_level)
	
	CardDrawerVibes.preview_mode = false	
	CardDrawerVibes.use_location = use_location
	CardDrawerVibes.metrics = scp_details.metrics
	CardDrawerVibes.hide() if hide_metrics else CardDrawerVibes.show()

	CardDrawerCurrency.preview_mode = false
	CardDrawerCurrency.room_details = scp_details	
	CardDrawerCurrency.use_location = use_location
	CardDrawerCurrency.list = currency_list	
	CardDrawerCurrency.hide() if hide_currency else CardDrawerCurrency.show()
	#CardDrawerCurrency.morale_val = morale_val
	#CardDrawerCurrency.list = currency_list
	# -----------
	
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
