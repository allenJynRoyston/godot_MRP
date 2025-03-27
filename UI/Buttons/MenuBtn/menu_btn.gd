@tool
extends BtnBase

@onready var OuterPanel:PanelContainer = $"."
@onready var InnerPanel:PanelContainer = $MarginContainer/InnerPanel
@onready var InnerPanelMarginContainer:MarginContainer = $MarginContainer/InnerPanel/MarginContainer

@onready var BtnLabel:Label = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/BtnLabel

@onready var EnergyPanel:HBoxContainer = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/EnergyPanel
@onready var EnergyAmountLabel:Label = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/EnergyPanel/EnergyAmountLabel
@onready var EnergyIconBtn:Control = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/EnergyPanel/EnergyIconBtn

@onready var SciencePanel:HBoxContainer = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/SciencePanel
@onready var ScienceAmountLabel:Label = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/SciencePanel/ScienceAmountLabel
@onready var ScienceIconBtn:Control = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/SciencePanel/ScienceIconBtn

@onready var CooldownPanel:PanelContainer = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/CooldownPanel
@onready var CooldownLabel:Label = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/CooldownPanel/MarginContainer/HBoxContainer/CooldownLabel

@onready var TogglePanel:PanelContainer = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/TogglePanel
@onready var Checkbox:BtnBase = $MarginContainer/InnerPanel/MarginContainer/HBoxContainer/TogglePanel/MarginContainer/HBoxContainer/CheckBox

@export var title:String = "" : 
	set(val): 
		title = val
		on_title_update()

@export var cooldown_duration:int = -1 : 
	set(val):
		cooldown_duration = val
		on_cooldown_duration_update()
		
@export var energy_cost:int = -1 : 
	set(val):
		energy_cost = val
		on_energy_cost_update()
		
@export var science_cost:int = -1 : 
	set(val):
		science_cost = val
		on_science_cost_update()

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
		
@export var is_empty:bool = false : 
	set(val):
		is_empty = val
		on_is_empty_update()

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	if is_hoverable:
		on_focus(false)
	else:
		update_color(btn_color)

	on_title_update()
	on_energy_cost_update()
	on_science_cost_update()
	on_is_disabled_updated()
	on_is_selected_update()
	on_cooldown_duration_update()
	on_is_togglable_update()
	on_is_checked_update()
	on_is_empty_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_color(new_color:Color = btn_color) -> void:
	if !is_node_ready():return
	new_color = btn_color if !is_disabled else Color(1, 0.204, 0)
	new_color = new_color if (is_focused or is_selected) else new_color.darkened(0.3)
	
	var new_stylebox:StyleBoxFlat = InnerPanel.get_theme_stylebox('panel').duplicate()
	new_stylebox.border_color = new_color if is_selected else Color.BLACK
	InnerPanel.add_theme_stylebox_override("panel", new_stylebox)	
	
	for panel in [CooldownPanel, TogglePanel]:
		var new_stylebox_cost:StyleBoxFlat = panel.get_theme_stylebox('panel').duplicate()
		new_stylebox_cost.bg_color = new_color if is_selected else new_color.darkened(0.3)
		new_stylebox_cost.corner_radius_bottom_left = 0 if is_selected else 5
		new_stylebox_cost.corner_radius_bottom_right = 0 if is_selected else 5
		new_stylebox_cost.corner_radius_top_left = 0 if is_selected else 5
		new_stylebox_cost.corner_radius_top_right = 0 if is_selected else 5
		panel.add_theme_stylebox_override("panel", new_stylebox_cost)		
	
	var label_settings:LabelSettings = BtnLabel.label_settings.duplicate()
	label_settings.font_color = new_color
	BtnLabel.label_settings = label_settings
	
	EnergyIconBtn.static_color = new_color	
	ScienceIconBtn.static_color = new_color
	
		
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
	if !is_node_ready() or is_empty:return
	TogglePanel.show() if is_togglable else TogglePanel.hide()
	

func on_is_checked_update() -> void:
	if !is_node_ready():return
	Checkbox.is_checked = is_checked

func on_cooldown_duration_update() -> void:
	if !is_node_ready():return
	if cooldown_duration == -1:
		CooldownPanel.hide()
		return
	CooldownLabel.show()
	CooldownLabel.text = "RDY" if cooldown_duration == 0 else str(cooldown_duration)

func on_energy_cost_update() -> void:
	if !is_node_ready():return
	if energy_cost == -1:
		EnergyPanel.hide()
		return
	EnergyPanel.show()
	EnergyAmountLabel.text = str(absi(energy_cost))
	
func on_science_cost_update() -> void:
	if !is_node_ready():return
	if science_cost == -1:
		SciencePanel.hide()
		return	
	SciencePanel.show()
	ScienceAmountLabel.text = str(absi(science_cost))
	
func on_is_empty_update() -> void:
	if !is_node_ready():return
	if is_empty:
		TogglePanel.hide()
		EnergyPanel.hide()
		CooldownPanel.hide()
		SciencePanel.hide()

func on_title_update() -> void:
	if !is_node_ready():return
	BtnLabel.text = title
# ------------------------------------------------------------------------------
