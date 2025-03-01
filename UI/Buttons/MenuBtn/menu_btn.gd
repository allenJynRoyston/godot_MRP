@tool
extends BtnBase

@onready var OuterPanel:PanelContainer = $"."
@onready var InnerPanel:PanelContainer = $MarginContainer/InnerPanel
@onready var InnerPanelMarginContainer:MarginContainer = $MarginContainer/InnerPanel/MarginContainer
@onready var CostPanel:PanelContainer = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/CostPanel
@onready var CostLabel:Label = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/CostPanel/MarginContainer/HBoxContainer/CostLabel 
@onready var IconBtn:Control = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/IconBtn
@onready var BtnLabel:Label = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/BtnLabel
@onready var Checkbox:BtnBase = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/CostPanel/MarginContainer/HBoxContainer/CheckBox

@export var title:String = "" : 
	set(val): 
		title = val
		on_title_update()

@export var cost:int = -1 : 
	set(val):
		cost = val
		on_cost_update()
		
@export var icon:SVGS.TYPE = SVGS.TYPE.DOT : 
	set(val):
		icon = val
		on_icon_update()
		
@export var btn_color:Color = Color(0, 0.965, 0.278) : 
	set(val): 
		btn_color = val
		update_color(btn_color)
		
@export var is_disabled:bool = false : 
	set(val):
		is_disabled = val
		on_is_disabled_updated()

@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()

@export var is_togglable:bool = false : 
	set(val):
		is_togglable = val
		on_is_togglable_update()
		
@export var is_checked:bool = false : 
	set(val):
		is_checked = val
		on_is_checked_update()		

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	if is_hoverable:
		on_focus(false)
	else:
		update_color(btn_color)

	on_icon_update()
	on_title_update()
	on_is_disabled_updated()
	on_is_selected_update()
	on_cost_update()
	on_is_togglable_update()
	on_is_checked_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_color(new_color:Color = btn_color) -> void:
	if !is_node_ready():return
	new_color = btn_color if !is_disabled else Color(1, 0.204, 0)
	new_color = new_color if (is_focused or is_selected) else new_color.darkened(0.3)
	
	var new_stylebox:StyleBoxFlat = InnerPanel.get_theme_stylebox('panel').duplicate()
	new_stylebox.border_color = new_color if is_selected else Color.BLACK
	InnerPanel.add_theme_stylebox_override("panel", new_stylebox)	
	
	var new_stylebox_cost:StyleBoxFlat = CostPanel.get_theme_stylebox('panel').duplicate()
	new_stylebox_cost.bg_color = new_color if is_selected else new_color.darkened(0.3)
	new_stylebox_cost.corner_radius_bottom_left = 0 if is_selected else 5
	new_stylebox_cost.corner_radius_bottom_right = 0 if is_selected else 5
	new_stylebox_cost.corner_radius_top_left = 0 if is_selected else 5
	new_stylebox_cost.corner_radius_top_right = 0 if is_selected else 5
	CostPanel.add_theme_stylebox_override("panel", new_stylebox_cost)		
	
	var label_settings:LabelSettings = BtnLabel.label_settings.duplicate()
	label_settings.font_color = new_color
	BtnLabel.label_settings = label_settings
	
	IconBtn.static_color = new_color	
	
		
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if !is_node_ready():return
	update_color()

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	super.on_mouse_click(node, btn, on_hover)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_is_selected_update() -> void:
	update_color()
	
func on_is_disabled_updated() -> void:
	update_color()

func on_is_togglable_update() -> void:
	if !is_node_ready():return
	Checkbox.show() if is_togglable else Checkbox.hide()

func on_is_checked_update() -> void:
	if !is_node_ready():return
	Checkbox.is_checked = is_checked

func on_cost_update() -> void:
	if !is_node_ready():return
	CostPanel.hide() if cost == -1 else CostPanel.show()
	CostLabel.text = str(cost)
	InnerPanelMarginContainer.add_theme_constant_override('margin_right', 5 if cost == -1 else 0)
	
func on_title_update() -> void:
	if !is_node_ready():return
	BtnLabel.text = title

func on_icon_update() -> void:
	if !is_node_ready():return
	IconBtn.icon = icon
	IconBtn.hide() if icon == SVGS.TYPE.NONE else IconBtn.show()
# ------------------------------------------------------------------------------
