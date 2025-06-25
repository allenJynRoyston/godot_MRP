@tool
extends MouseInteractions

@onready var OutputTextureRect:TextureRect = $CardBody/TextureRect

@onready var CardBody:Control = $CardBody
@onready var Front:Control = $CardBody/SubViewport/Control/CardBody/Front
@onready var Back:Control = $CardBody/SubViewport/Control/CardBody/Back
@onready var InactivePanel:Control = $CardBody/SubViewport/Control/CardBody/InactivePanel

#front
@onready var CardDrawerImage:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage
@onready var CardDrawerLevel:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer2/CardDrawerLevel
@onready var CardDrawerName:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer2/CardDrawerName
@onready var CardDrawerStaffingRequirements:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerStaffingRequirements
@onready var CardDrawerPairsWith:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerPairsWith

# back
@onready var CardDrawerCurrency:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerCurrency
@onready var CardDrawerVibes:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerVibes
@onready var CardDrawerDescription:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerDescription

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
		
@export var preview_mode:bool = false
	

const BlackAndWhiteShader:ShaderMaterial = preload("res://Shader/BlackAndWhite/template.tres")

var room_config:Dictionary
var index:int = -1
var use_location:Dictionary = {}
var current_metrics:Dictionary = {}
var default_border_color:Color 
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass

signal flip_complete


# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)

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
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_flip_update() -> void:
	if !is_node_ready():return
	CardBody.flip = flip
	await CardBody.flip_complete
	flip_complete.emit()
	on_ref_update()

func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
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
	if !is_node_ready() or room_config.is_empty():return	
	
	if ref == -1:
		CardDrawerImage.use_static = true
		CardDrawerName.content = "-"
		CardDrawerDescription.content = "-"
		CardDrawerImage.img_src = "-"
		CardDrawerCurrency.list = []
		CardDrawerVibes.metrics = {}
		CardDrawerStaffingRequirements.clear()
		CardDrawerPairsWith.clear()
		return
	
	var room_details:Dictionary = ROOM_UTIL.return_data(ref)
	var is_activated:bool = true
	var morale_val:int = GAME_UTIL.get_metric_val(use_location, RESOURCE.METRICS.MORALE)
	var metrics:Dictionary = room_details.metrics
	var currency_list:Array = []

	# if location is provided, return extract data
	if !use_location.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
		if !extract_data.room.is_empty():
			is_activated = extract_data.room.is_activated
			metrics = extract_data.room.metrics
			currency_list = extract_data.room.currency_list
	
	
	# else, use just the room details
	else:
		for ref in room_details.currencies:
			var resource_details:Dictionary = RESOURCE_UTIL.return_currency(ref)
			var amount:int = room_details.currencies[ref]
			# apply bonus
			currency_list.push_back({"ref": ref, "icon": resource_details.icon, "title": str(amount)})			


	for node in [CardBody]:
		node.border_color = default_border_color if is_activated else Color.RED

	var abl_lvl:int = 0
	if !use_location.is_empty():
		var ring_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring]	
		var room_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
		abl_lvl = (room_config_data.abl_lvl + ring_config_data.abl_lvl)

	# -----------
	InactivePanel.show() if !is_activated else InactivePanel.hide()
	CardDrawerLevel.content = str(abl_lvl)
	CardDrawerName.content = "%s" % [room_details.name] if is_activated else "%s (INACTIVE)" % [room_details.name]
	#CardDrawerStaffingRequirements.required_personnel = room_details.required_personnel
	CardDrawerImage.img_src = room_details.img_src
	CardDrawerImage.use_static = !is_activated
	CardDrawerDescription.content = room_details.description
	# -----------
	#CardDrawerPairsWith.spec_name = RESEARCHER_UTIL.return_specialization_data(room_details.requires_specialization).name 
	# -----------
	CardDrawerVibes.preview_mode = preview_mode	
	CardDrawerVibes.use_location = use_location
	CardDrawerVibes.metrics = metrics

	CardDrawerCurrency.preview_mode = preview_mode
	CardDrawerCurrency.room_details = room_details	
	CardDrawerCurrency.use_location = use_location
	CardDrawerCurrency.list = currency_list	
	CardDrawerCurrency.morale_val = morale_val
	CardDrawerCurrency.list = currency_list
	
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
