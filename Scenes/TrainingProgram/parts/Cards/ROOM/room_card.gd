@tool
extends MouseInteractions

@onready var OutputTextureRect:TextureRect = $CardBody/TextureRect

@onready var CardBody:Control = $CardBody
@onready var Front:Control = $CardBody/SubViewport/Control/CardBody/Front
@onready var Back:Control = $CardBody/SubViewport/Control/CardBody/Back

#front
@onready var CardDrawerImage:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage
@onready var CardDrawerName:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerName
@onready var CardDrawerStaffingRequirements:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerStaffingRequirements
@onready var CardDrawerDescription:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerDescription

# back
@onready var CardDrawerPairsWith:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerPairsWith
@onready var CardDrawerCurrency:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerCurrency
@onready var CardDrawerVibes:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerVibes

@export var ref:int = -1: 
	set(val):
		ref = val
		on_ref_update()

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

@export var card_border_color:Color = Color(0.408, 0.42, 1.0) : 
	set(val):
		card_border_color = val
		on_is_selected_update()
	

const BlackAndWhiteShader:ShaderMaterial = preload("res://Shader/BlackAndWhite/template.tres")

var index:int = -1
var use_location:Dictionary = {}
var current_metrics:Dictionary = {}
var default_border_color:Color 
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass

signal flip_complete

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	on_ref_update()
	on_reveal_update()
	on_is_active_update()
	on_is_selected_update()
	on_is_deselected_update()
	
	Front.show()
	Back.hide()
	
	
	default_border_color = CardDrawerName.border_color

	#on_show_assigned_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_flip_update() -> void:
	if !is_node_ready():return
	CardBody.flip = flip
	await CardBody.flip_complete
	flip_complete.emit()
	on_ref_update()

func on_is_active_update() -> void:
	if !is_node_ready():return

func on_show_checkbox_update() -> void:
	if !is_node_ready():return

func on_is_selected_update() -> void:
	if !is_node_ready():return
	CardBody.border_color = card_border_color if is_selected else card_border_color.darkened(0.1)

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
	
	if ref == -1:
		CardDrawerImage.use_static = true
		CardDrawerName.content = "-"
		CardDrawerDescription.content = "-"
		CardDrawerImage.img_src = "-"
		CardDrawerDescription.content = "-"
		CardDrawerCurrency.list = []
		CardDrawerVibes.metrics = {}
		CardDrawerStaffingRequirements.clear()
		CardDrawerPairsWith.clear()
		return
	
	var room_details:Dictionary = ROOM_UTIL.return_data(ref)
	var is_locked:bool = false
	var is_activated:bool = true
	var currency_list:Array = []
	var spec_name:String = str(RESEARCHER_UTIL.return_specialization_data(room_details.pairs_with.specilization).name)
	var trait_name:String = str(RESEARCHER_UTIL.return_trait_data(room_details.pairs_with.trait).name)
	var bonus_str:String = "%s or %s" % [spec_name, trait_name]	
	var has_spec_bonus:bool = false
	var has_trait_bonus:bool = false
	var morale_val:int = 0
	
	if !use_location.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
		morale_val = extract_data.ring_config.metrics[RESOURCE.METRICS.MORALE]
		is_activated = extract_data.is_activated
		#has_spec_bonus = extract_data.room.pairs_with.specilization
		#has_trait_bonus = extract_data.room.pairs_with.trait

	for key in room_details.currencies:
		var resource_details:Dictionary = RESOURCE_UTIL.return_currency(key)
		var amount:int = room_details.currencies[key]
		
		# apply bonus
		if !use_location.is_empty():
			amount = GAME_UTIL.apply_pair_and_morale_bonus(use_location, amount)
		currency_list.push_back({"icon": resource_details.icon, "title": str(amount)})	

	for node in [CardBody]:
		node.border_color = default_border_color if is_activated else Color.RED


	# -----------
	CardDrawerName.content = "%s" % [room_details.name if !is_locked else "[REDACTED]"] if is_activated else "%s (INACTIVE)" % [room_details.name]
	CardDrawerDescription.content = room_details.description if !is_locked else "[REDACTED]"
	CardDrawerStaffingRequirements.required_personnel = room_details.required_personnel
	CardDrawerImage.img_src = room_details.img_src if !is_locked else ""
	CardDrawerImage.use_static = !is_activated
	CardDrawerCurrency.list = currency_list
	CardDrawerVibes.metrics = room_details.metrics	
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
