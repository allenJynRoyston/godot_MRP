@tool
extends MouseInteractions

@onready var OutputTextureRect:TextureRect = $CardBody/TextureRect

@onready var CardBody:Control = $CardBody
#front
@onready var CardDrawerImage:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage
@onready var CardDrawerName:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/CardDrawerName
@onready var CardDrawerLevel:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/CardDrawerLevel
@onready var CardDrawerSpec:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer2/CardDrawerSpec
@onready var CardDrawerTrait:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer2/CardDrawerTrait
@onready var CardDrawerDescription:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerDescription

# back
@onready var CardDrawerMetrics:Control = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/CardDrawerMetrics
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
		CardDrawerLevel.content = "-"
		CardDrawerDescription.content = "-"
		CardDrawerImage.img_src = "-"
		CardDrawerSpec.content = "-"
		CardDrawerTrait.content = "-"
		return
	
	var room_details:Dictionary = ROOM_UTIL.return_data(ref)
	var is_locked:bool = false
	var own_aquistions:bool = ROOM_UTIL.owns_and_is_active(ROOM.TYPE.AQUISITION_DEPARTMENT)
	
	CardDrawerActiveAbilities.room_details = room_details
	
	#
	CardDrawerName.content = "%s" % [room_details.name if !is_locked else "[REDACTED]"]
	CardDrawerDescription.content = room_details.description if !is_locked else "(Viewable with AQUISITION DEPARTMENT.)"
	CardDrawerImage.img_src = room_details.img_src if !is_locked else ""
	CardDrawerImage.use_static = false
	#
	#for node in [MetricsList, ResourceGrid, SyncList, ActiveAbilitiesList, PassiveAbilitiesList]:
		#for child in node.get_children():
			#child.queue_free()
	
	for item in ROOM_UTIL.return_pairs_with_details(room_details.ref):
		pass
		#var btn_node:Control = TextBtnPreload.instantiate()
		#btn_node.is_hoverable = false
		#btn_node.title = item.name
		#btn_node.icon = item.icon
		#btn_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#SyncList.add_child(btn_node)
	
	
	
	var is_activated:bool = true
	var operating_costs:Array = ROOM_UTIL.return_operating_cost(ref)	
	var resource_list:Array = operating_costs.filter(func(i):return i.type == "amount") if is_activated else []
	var metric_list:Array = operating_costs.filter(func(i):return i.type == "metrics") if is_activated else []
	
	#ResourceGrid.columns = U.min_max(resource_list.size(), 1, 2)
	
	for item in resource_list:
		pass
		#var new_btn:Control = TextBtnPreload.instantiate()
		#new_btn.is_hoverable = false
		#new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#new_btn.icon = item.resource.icon
		#new_btn.title = "%s%s" % ["+" if item.amount > 0 else "", item.amount]
		#ResourceGrid.add_child(new_btn)
		
	for item in metric_list:
		if item.type == "metrics":
			pass

			#var new_btn:Control = TextBtnPreload.instantiate()
			#new_btn.is_hoverable = false
			#new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			#new_btn.icon = item.resource.icon
			#new_btn.title = "%s%s %s" % ["+" if item.amount > 0 else "", item.amount, item.resource.name]
			#MetricsList.add_child(new_btn)		
			
	## TODO FIND MORE RELIABLE WAY TO GET THE NUMBERS HERE
	#var activation_effects:Array = [] #ROOM_UTIL.return_activation_effect(item.ref)		
	#Effects.hide() if is_locked or activation_effects.is_empty() else Effects.show()
	#for item in activation_effects:
		#var btn_node:Control = TextBtnPreload.instantiate()
		#btn_node.is_hoverable = false
		#btn_node.title = "%s%s [%s] [%s]" % ["+" if item.amount > 0 else "", item.amount, item.resource.name, str(item.type).to_upper()]
		#btn_node.icon = item.resource.icon
		#EffectsList.add_child(btn_node)
	#
	#var spec_preferences:Array = ROOM_UTIL.return_room_speclization_preferences(ref)
	#Syncs.hide() if is_locked or spec_preferences.is_empty() else Syncs.show()
	#for item in spec_preferences:
		#var btn_node:Control = TextBtnPreload.instantiate()
		#btn_node.is_hoverable = false		
		#btn_node.title = "%s" % [item.details.name]
		#btn_node.icon = item.details.icon
		#SyncList.add_child(btn_node)

# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_ability_btns() -> Array:
	await U.tick()
	var btn_list:Array = []
	for btn in CardDrawerActiveAbilities.get_btns():
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
