@tool
extends MouseInteractions

@onready var RootContainer:PanelContainer = $SubViewport/SCPCard
@onready var CardTextureRect:TextureRect = $VBoxContainer/TextureRect
@onready var ImageTextureRect:TextureRect = $SubViewport/SCPCard/Front/Image
@onready var Front:VBoxContainer = $SubViewport/SCPCard/Front
@onready var Back:VBoxContainer = $SubViewport/SCPCard/Back

@onready var SelectedCheckbox:BtnBase = $SubViewport/SCPCard/Front/Image/MarginContainer/VBoxContainer/HBoxContainer/SelectedCheckbox
@onready var NicknameLabel:Label = $SubViewport/SCPCard/Front/Image/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/NicknameLabel
@onready var DesignationLabel:Label = $SubViewport/SCPCard/Front/Image/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/DesignationLabel
@onready var ItemClassLabel:Label = $SubViewport/SCPCard/Front/Image/MarginContainer/VBoxContainer/ItemClass/ItemClassLabel
@onready var QuoteLabel:Label = $SubViewport/SCPCard/Front/MarginContainer/VBoxContainer/Quote/QuoteLabel

@onready var Morale:Control = $SubViewport/SCPCard/Front/MarginContainer/VBoxContainer/VBoxContainer/Metrics/Morale
@onready var Safety:Control = $SubViewport/SCPCard/Front/MarginContainer/VBoxContainer/VBoxContainer/Metrics/Safety
@onready var Readiness:Control = $SubViewport/SCPCard/Front/MarginContainer/VBoxContainer/VBoxContainer/Metrics/Readiness

@onready var ContainedEffect:VBoxContainer = $SubViewport/SCPCard/Front/MarginContainer/VBoxContainer/ContainedEffect
@onready var UnContainedEffect:VBoxContainer = $SubViewport/SCPCard/Front/MarginContainer/VBoxContainer/UncontainedEffect
@onready var ContainedDescriptionLabel:Label  = $SubViewport/SCPCard/Front/MarginContainer/VBoxContainer/ContainedEffect/PanelContainer4/MarginContainer/DescriptionLabel
@onready var UncontainedDescriptionLabel:Label = $SubViewport/SCPCard/Front/MarginContainer/VBoxContainer/UncontainedEffect/PanelContainer4/MarginContainer/DescriptionLabel

@onready var BenefitsGridContainer:GridContainer = $SubViewport/SCPCard/Front/MarginContainer/VBoxContainer/Rewards/GridContainer

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
		
		
const BlackAndWhiteShader:ShaderMaterial = preload("res://Shader/BlackAndWhite/template.tres")
const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var index:int = -1
var use_location:Dictionary = {}
var current_metrics:Dictionary = {}
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	Front.show()
	Back.hide()

	on_ref_update()
	on_reveal_update()
	on_is_active_update()
	on_is_selected_update()
	on_is_deselected_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_flip_update() -> void:
	if !is_node_ready():return
	CardTextureRect.pivot_offset = self.size/2
	await U.tween_node_property(CardTextureRect, "scale:x", 0, 0.1)
	await U.set_timeout(0.2)
	Front.hide() if flip else Front.show()
	Back.show() if flip else Back.hide()
	U.tween_node_property(CardTextureRect, "scale:x", 1, 0.1)

func on_is_active_update() -> void:
	if !is_node_ready():return
	var dup_stylebox:StyleBoxFlat = RootContainer.get_theme_stylebox('panel').duplicate()
	dup_stylebox.border_color = Color.WHITE if is_active else Color.BLACK
	RootContainer.add_theme_stylebox_override('panel', dup_stylebox)

func on_show_checkbox_update() -> void:
	if !is_node_ready():return
	SelectedCheckbox.show() if show_checkbox else SelectedCheckbox.hide()

func on_is_selected_update() -> void:
	if !is_node_ready():return
	SelectedCheckbox.icon = SVGS.TYPE.CHECKBOX if is_selected else SVGS.TYPE.EMPTY_CHECKBOX
	SelectedCheckbox.static_color = Color.GREEN if is_selected else Color.DIM_GRAY

func on_is_deselected_update() -> void:
	if !is_node_ready():return
	CardTextureRect.material = BlackAndWhiteShader if is_deselected else null

func on_reveal_update() -> void:
	if !is_node_ready():return
	await U.tween_node_property(CardTextureRect, "modulate", Color(1, 1, 1, 1) if reveal else Color(1, 1, 1, 0))
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_ref_update() -> void:
	if !is_node_ready() or ref not in SCP_UTIL.reference_data:return	
	for child in BenefitsGridContainer.get_children():
		child.queue_free()	
	
	var scp_data:Dictionary = SCP_UTIL.return_data(ref)
	var rewards:Array = SCP_UTIL.return_ongoing_containment_rewards(ref)
	
	for ref in scp_data.effects.metrics:
		var amount:int = scp_data.effects.metrics[ref]
		match ref:
			RESOURCE.BASE_METRICS.MORALE:
				Morale.value = amount
				if RESOURCE.BASE_METRICS.MORALE in current_metrics:
					Morale.is_negative = current_metrics[RESOURCE.BASE_METRICS.MORALE] < amount
			RESOURCE.BASE_METRICS.SAFETY:
				Safety.value = amount
				if RESOURCE.BASE_METRICS.SAFETY in current_metrics:
					Safety.is_negative = current_metrics[RESOURCE.BASE_METRICS.SAFETY] < amount
			RESOURCE.BASE_METRICS.READINESS:
				Readiness.value = amount
				if RESOURCE.BASE_METRICS.READINESS in current_metrics:
					Readiness.is_negative = current_metrics[RESOURCE.BASE_METRICS.READINESS] < amount
	

	var passes_metric_check:bool = SCP_UTIL.passes_metric_check(ref, use_location)

			
	ContainedEffect.modulate = Color(1, 1, 1, 1 if passes_metric_check else 0.5)
	UnContainedEffect.modulate = Color(1, 1, 1, 0.5 if passes_metric_check else 1.0)

	ImageTextureRect.texture = CACHE.fetch_image(scp_data.img_src)
	DesignationLabel.text = scp_data.name
	NicknameLabel.text = '"%s"' % [scp_data.nickname]
	ItemClassLabel.text = scp_data.item_class
	QuoteLabel.text = '"%s"' % scp_data.quote
	ContainedDescriptionLabel.text = scp_data.effects.contained.description
	UncontainedDescriptionLabel.text = scp_data.effects.uncontained.description

	for reward in rewards:
		var btn_node:BtnBase = TextBtnPreload.instantiate()
		btn_node.title = reward.resource.name
		btn_node.icon = reward.resource.icon
		btn_node.is_hoverable = false
		BenefitsGridContainer.add_child(btn_node)
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
