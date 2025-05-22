@tool
extends MouseInteractions

@onready var CardBody:Control = $CardBody
@onready var OutputTextureRect:TextureRect = $CardBody/TextureRect
#front
@onready var CardDrawerImage:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage
@onready var CardDrawerDesignation:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer3/CardDrawerDesignation
@onready var CardDrawerName:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer3/CardDrawerName
@onready var CardDrawerItemClass:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerItemClass
@onready var CardDrawerDescription:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerDescription
@onready var CardDrawerEffect:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerEffect
@onready var CardDrawerAssigned:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerAssigned
# back
@onready var CardDrawerVibes:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerVibes
@onready var CardDrawerPairsWith:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerPairsWith
@onready var CardDrawerCurrency:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerCurrency

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
		for node in [CardDrawerDesignation, CardDrawerItemClass, CardDrawerDescription, CardDrawerEffect, CardDrawerAssigned, CardDrawerName]:
			node.content = "-"
		return
		
	var scp_details:Dictionary = SCP_UTIL.return_data(ref)
	var spec_name:String = str(RESEARCHER_UTIL.return_specialization_data(scp_details.pairs_with.specilization).name)
	var trait_name:String = str(RESEARCHER_UTIL.return_trait_data(scp_details.pairs_with.trait).name)
	var bonus_str:String = "%s or %s" % [spec_name, trait_name]
	var currency_list:Array = []
	var has_spec_bonus:bool = false
	var has_trait_bonus:bool = false
	var morale_val:int = 0	
	
	if !use_location.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
		morale_val = extract_data.ring_config.metrics[RESOURCE.METRICS.MORALE]
		if !extract_data.scp.is_empty():
			has_spec_bonus = extract_data.scp.pairs_with.specilization
			has_trait_bonus = extract_data.scp.pairs_with.trait
	

	for key in scp_details.currencies:
		var resource_details:Dictionary = RESOURCE_UTIL.return_currency(key)
		var amount:int = scp_details.currencies[key]
		
		# apply bonus
		if !use_location.is_empty():
			amount = GAME_UTIL.apply_scp_pair_and_morale_bonus(use_location, amount)
		currency_list.push_back({"icon": resource_details.icon, "title": str(amount)})		
	
	# -----------
	CardDrawerDesignation.content = scp_details.name
	CardDrawerName.content = scp_details.nickname
	CardDrawerDescription.content = scp_details.description
	CardDrawerEffect.content = scp_details.effects.description
	CardDrawerImage.img_src = scp_details.img_src
	CardDrawerImage.use_static = false	
	CardDrawerVibes.metrics = scp_details.metrics
	# -----------
	CardDrawerPairsWith.spec_name = spec_name
	CardDrawerPairsWith.trait_name = trait_name
	CardDrawerPairsWith.has_spec = has_spec_bonus
	CardDrawerPairsWith.has_trait = has_trait_bonus
	# -----------
	CardDrawerCurrency.spec_name = spec_name
	CardDrawerCurrency.trait_name = trait_name
	CardDrawerCurrency.has_spec_bonus = has_spec_bonus
	CardDrawerCurrency.has_trait_bonus = has_trait_bonus
	CardDrawerCurrency.morale_val = morale_val
	CardDrawerCurrency.list = currency_list
	CardDrawerCurrency.update_labels()


	match scp_details.item_class:
		SCP_UTIL.ITEM_CLASS.SAFE:
			CardDrawerItemClass.content = "SAFE"
		SCP_UTIL.ITEM_CLASS.EUCLID:
			CardDrawerItemClass.content = "EUCLID"
		SCP_UTIL.ITEM_CLASS.KETER:
			CardDrawerItemClass.content = "KETER"
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
