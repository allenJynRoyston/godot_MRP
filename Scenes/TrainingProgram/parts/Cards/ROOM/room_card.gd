@tool
extends MouseInteractions

# --------
@onready var CardBody:Control = $CardBody
@onready var OutputTextureRect:TextureRect = $CardBody/TextureRect
@onready var Front:Control = $CardBody/SubViewport/Control/CardBody/Front
@onready var Back:Control = $CardBody/SubViewport/Control/CardBody/Back

# --------
@onready var CostPanel:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/VBoxContainer/CardDrawerImage/CostPanel
@onready var AtFullCapacity:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/VBoxContainer/CardDrawerImage/AtFullCapacity
@onready var InactivePanel:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/VBoxContainer/CardDrawerImage/InactivePanel

#front
@onready var CardDrawerImage:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/VBoxContainer/CardDrawerImage
@onready var CardDrawerName:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/VBoxContainer/HBoxContainer2/CardDrawerName
@onready var CardDrawerLevel:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/VBoxContainer/HBoxContainer2/CardDrawerLevel

@onready var CurrencyContainer:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CurrencyContainer
@onready var CardDrawerCurrency:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CurrencyContainer/CardDrawerCurrency

@onready var PersonnelCapacityContainer:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/PersonnelCapacity
@onready var CardDrawerPersonnelCapacity:PanelContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/PersonnelCapacity/CardDrawerPersonnelCapacity

@onready var VibesContainer:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/VibesContainer
@onready var CardDrawerVibes:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/VibesContainer/CardDrawerVibes

@onready var EffectContainer:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/EffectContainer
@onready var EffectDescription:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/EffectContainer/EffectDescription

@onready var ContainmentTypeContainer:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ContainmentTypes
@onready var ContainmentDescription:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ContainmentTypes/ContainmentDescription

# back
@onready var CardDrawerDescription:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerDescription

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
@export var show_cost:bool = false
@export var show_research_cost:bool = false
	

const BlackAndWhiteShader:ShaderMaterial = preload("res://Shader/BlackAndWhite/template.tres")

var room_config:Dictionary
var index:int = -1
var use_location:Dictionary = {}
var current_metrics:Dictionary = {}
var default_border_color:Color 
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass

var resources_data:Dictionary = {}

signal flip_complete


# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_resources_data(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	

func _ready() -> void:
	super._ready()

	on_ref_update()
	on_reveal_update()
	on_is_active_update()
	on_is_selected_update()
	on_is_deselected_update()
	
	Front.show()
	Back.hide()
	AtFullCapacity.hide()
	CostPanel.hide()
	
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
func on_resources_data_update(new_val:Dictionary) -> void:
	resources_data = new_val
	
func on_ref_update() -> void:
	if !is_node_ready() or room_config.is_empty():return	
	if ref == -1:
		InactivePanel.hide()
		CostPanel.hide()
		AtFullCapacity.hide()
		
		CardBody.border_color = Color.TRANSPARENT
		CardBody.modulate = Color(1, 1, 1, 0.2)
		
		CardDrawerImage.use_static = true
		CardDrawerName.content = "-"
		CardDrawerDescription.content = "-"
		CardDrawerImage.img_src = "-"
		CardDrawerCurrency.list = []
		CardDrawerVibes.metrics = {}
		
		CardDrawerCurrency.hide()
		CardDrawerVibes.hide()
		PersonnelCapacityContainer.hide()
		return
	
	var room_details:Dictionary = ROOM_UTIL.return_data(ref)
	var is_activated:bool = preview_mode
	var metrics:Dictionary = room_details.metrics
	var personnel_capacity:Dictionary = room_details.personnel_capacity
	var currency_list:Array = []

	# has location
	if use_location.is_empty() or preview_mode:
		for ref in room_details.currencies:
			var resource_details:Dictionary = RESOURCE_UTIL.return_currency(ref)
			var amount:int = room_details.currencies[ref]
			# apply bonus
			currency_list.push_back({"ref": ref, "icon": resource_details.icon, "title": str(amount)})					
		

	# if location is provided, return extract data
	else:
		var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
		if !extract_data.room.is_empty():
			is_activated = extract_data.room.is_activated
			metrics = extract_data.room.metrics
			currency_list = extract_data.room.currency_list
			
	CardBody.border_color = default_border_color if is_activated else COLORS.disabled_color
	CardBody.modulate = Color(1, 1, 1, 1)
	
	var abl_lvl:int = 0
	if !use_location.is_empty():
		var ring_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring]	
		var room_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
		abl_lvl = (room_config_data.abl_lvl + ring_config_data.abl_lvl)

	var hide_currency:bool = true
	for item in currency_list:
		var amount:int = int(item.title) if is_activated else 0
		if amount != 0:
			hide_currency = false
			break
			
	var hide_metrics:bool = true 
	for key in metrics:
		var amount:int = metrics[key] if is_activated else 0
		if amount != 0:
			hide_metrics = false
			break
			
	var hide_personnel_capacity:bool = true
	for key in personnel_capacity:
		var amount:int = personnel_capacity[key] if is_activated else 0
		if amount != 0:
			hide_personnel_capacity = false
			break
			
	# -----------
	CardDrawerLevel.content = str(abl_lvl)
	CardDrawerName.content = "%s" % [room_details.name] if is_activated else "%s (INACTIVE)" % [room_details.name]
	CardDrawerImage.img_src = room_details.img_src
	CardDrawerImage.use_static = !is_activated
	CardDrawerDescription.content = room_details.description
	
	# -----------
	CardDrawerVibes.preview_mode = preview_mode	
	CardDrawerVibes.use_location = use_location
	CardDrawerVibes.metrics = metrics
	CardDrawerVibes.show()
	VibesContainer.hide() if hide_metrics else VibesContainer.show()
	
	# -----------
	CardDrawerCurrency.preview_mode = preview_mode
	CardDrawerCurrency.room_details = room_details	
	CardDrawerCurrency.use_location = use_location
	CardDrawerCurrency.list = currency_list	
	CardDrawerCurrency.show()
	CurrencyContainer.hide() if hide_currency else CurrencyContainer.show()

	# -----------
	EffectDescription.content = room_details.effect.description if !room_details.effect.is_empty() else ""
	EffectContainer.show() if !room_details.effect.is_empty() else EffectContainer.hide()
	
	ContainmentDescription.content = SCP_UTIL.get_containment_type_str(room_details.containment_properties) if !room_details.is_empty() else ""
	ContainmentTypeContainer.show() if !room_details.containment_properties.is_empty() else ContainmentTypeContainer.hide()

	# -----------	
	PersonnelCapacityContainer.hide() if hide_personnel_capacity else PersonnelCapacityContainer.show()
	CardDrawerPersonnelCapacity.personnel_capacity = personnel_capacity
	# panels
	InactivePanel.show() if (!is_activated and !preview_mode) else InactivePanel.hide()
	CostPanel.hide()
	
	# show cost panel
	if show_cost or show_research_cost:
		var can_afford:bool = resources_data[RESOURCE.CURRENCY.MONEY].amount >= room_details.costs.purchase
		var use_color:Color = Color.WHITE if can_afford else COLORS.disabled_color
		var at_capacity:bool = ROOM_UTIL.at_own_limit(room_details.ref)
		
		CostPanel.show() if !at_capacity else CostPanel.hide()
		AtFullCapacity.show() if at_capacity else AtFullCapacity.hide()
		
		CostPanel.title = "CONSTRUCTION COST"
		CostPanel.amount = str(room_details.costs.purchase) if room_details.costs.purchase > 0 else 0
		CostPanel.icon = SVGS.TYPE.MONEY
		CostPanel.use_color = use_color
	
	# researcher panel
	if show_research_cost:
		var can_afford:bool = resources_data[RESOURCE.CURRENCY.SCIENCE].amount >= room_details.costs.unlock
		var use_color:Color = Color.WHITE if can_afford else COLORS.disabled_color
		
		CostPanel.show()
		CostPanel.title = "RESEARCH COST"
		CostPanel.amount = str(room_details.costs.unlock) if room_details.costs.unlock > 0 else 0
		CostPanel.icon = SVGS.TYPE.RESEARCH
		CostPanel.use_color = use_color
	


# ------------------------------------------------------------------------------
	
# ------------------------------------------------------------------------------
#func on_focus(state:bool = is_focused) -> void:	
	#if !is_node_ready():return	
	#is_focused = state
	#onFocus.call(self) if state else onBlur.call(self)	
	#if state:
		#GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	#else:
		#GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
#
#func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	#if on_hover and btn == MOUSE_BUTTON_LEFT:		
		#onClick.call()
# ------------------------------------------------------------------------------
