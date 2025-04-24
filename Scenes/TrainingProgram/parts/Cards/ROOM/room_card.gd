@tool
extends MouseInteractions

@onready var OutputTextureRect:TextureRect = $CardBody/TextureRect

@onready var CardBody:Control = $CardBody
#front
@onready var CardDrawerImage:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage
@onready var CardDrawerName:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerName
@onready var CardDrawerActivationRequirements:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerActivationRequirements
@onready var CardDrawerDescription:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerDescription

# back
@onready var CardDrawerResearcherPref:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerResearcherPref
@onready var CardDrawerMetrics:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerMetrics
@onready var CardDrawerRewards:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerRewards
@onready var CardDrawerActiveAbilities:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerActiveAbilities
@onready var CardDrawerPassiveAbilities:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerPassiveAbilities


@export var ref:int = -1: 
	set(val):
		ref = val
		on_ref_update()

@export var flip:bool = false : 
	set(val):
		flip = val
		on_flip_update()

#@export var show_assigned:bool = false : 
	#set(val):
		#show_assigned = val
		#on_show_assigned_update()
		
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
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass
var onUseAbility:Callable = func(_ability:Dictionary):pass

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	on_ref_update()
	on_reveal_update()
	on_is_active_update()
	on_is_selected_update()
	on_is_deselected_update()
	
	CardDrawerActiveAbilities.onUseAbility = onUseAbility
	#on_show_assigned_update()
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

#func on_show_assigned_update() -> void:
	#if !is_node_ready():return
	#CardDrawerAssigned.show() if show_assigned else CardDrawerAssigned.hide()

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
		CardDrawerRewards.content = "-"
	
		CardDrawerMetrics.list = []
		CardDrawerActivationRequirements.list = []

		return
	
	var room_details:Dictionary = ROOM_UTIL.return_data(ref)
	var is_locked:bool = false
	var is_activated:bool = true
	if !use_location.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
		is_activated = extract_data.is_activated		
	

	CardDrawerActiveAbilities.room_details = room_details
	CardDrawerPassiveAbilities.room_details = room_details

	CardDrawerName.content = "%s" % [room_details.name if !is_locked else "[REDACTED]"] if is_activated else "%s (INACTIVE)" % [room_details.name]
	CardDrawerDescription.content = room_details.description if !is_locked else "(Viewable with AQUISITION DEPARTMENT.)"
	CardDrawerImage.img_src = room_details.img_src if !is_locked else ""
	CardDrawerImage.use_static = !is_activated

	
	var level_with_details:Dictionary = ROOM_UTIL.return_levels_with_details(room_details.ref)
	if level_with_details.is_empty():
		CardDrawerResearcherPref.content = "None"
	else:
		var spec_str:String = level_with_details.specilization.name
		var trait_str:String = level_with_details.trait.name
		CardDrawerResearcherPref.content = "%s or %s" % [spec_str, trait_str]
	
	

	CardDrawerActivationRequirements.list = room_details.resource_requirements.map(func(x):  
		var resource_details:Dictionary = RESOURCE_UTIL.return_personnel(x)
		return {"icon": resource_details.icon, "title": resource_details.name}
	)

	
	CardDrawerMetrics.list = [
		{"icon": SVGS.TYPE.PLUS, "title": "MORALE" },
		{"icon": SVGS.TYPE.PLUS, "title": "SAFETY" },
		{"icon": SVGS.TYPE.PLUS, "title": "READINESS" },
	]

# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_ability_btns() -> Array:
	await U.tick()
	var btn_list:Array = []
	for node in [CardDrawerActiveAbilities, CardDrawerPassiveAbilities]:
		for btn in node.get_btns():
			btn_list.push_back(btn)
	return btn_list
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
