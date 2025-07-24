@tool
extends Control

@onready var IconPanel:PanelContainer = $MarginContainer/HBoxContainer/IconPanel
@onready var Icon:Control = $MarginContainer/HBoxContainer/IconPanel/MarginContainer/SVGIcon

@onready var TitlePanel:PanelContainer = $MarginContainer/HBoxContainer/TitlePanel
@onready var TitleLabel:Label = $MarginContainer/HBoxContainer/TitlePanel/MarginContainer/HBoxContainer/MarginContainer/HBoxContainer2/TitleLabel

@onready var EnergyPanel:PanelContainer = $MarginContainer/HBoxContainer/EnergyPanel
@onready var EnergyIcon:Control = $MarginContainer/HBoxContainer/EnergyPanel/MarginContainer/HBoxContainer/SVGIcon
@onready var EnergyCostLabel:Label = $MarginContainer/HBoxContainer/EnergyPanel/MarginContainer/HBoxContainer/EnergyCostLabel

@onready var CostPanel:PanelContainer = $MarginContainer/HBoxContainer/CostPanel
@onready var CostIcon:Control = $MarginContainer/HBoxContainer/CostPanel/MarginContainer/HBoxContainer/CostIcon
@onready var CostLabel:Label = $MarginContainer/HBoxContainer/CostPanel/MarginContainer/HBoxContainer/CostLabel

@onready var CheckboxPanel:PanelContainer = $MarginContainer/HBoxContainer/CheckboxPanel
@onready var CheckboxIcon:Control = $MarginContainer/HBoxContainer/CheckboxPanel/MarginContainer/HBoxContainer/CheckBtn

@export var title:String = "TITLE" : 
	set(val):
		title = val
		on_title_update()
		
@export var is_disabled:bool = false : 
	set(val):
		is_disabled = val
		on_is_disabled_update()
		
@export var use_alt:bool = false : 
	set(val):
		use_alt = val
		on_use_alt_update()
				
@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()

@export var icon:SVGS.TYPE = SVGS.TYPE.PLUS : 
	set(val):
		icon = val
		on_icon_update()
	
@export var hide_icon:bool = false : 
	set(val):
		hide_icon = val
		on_hide_icon_update()
		
@export var energy_cost:int = 0 : 
	set(val):
		energy_cost = val
		on_cost_update()

@export var show_energy_cost:bool = false : 
	set(val):
		show_energy_cost = val
		on_show_energy_cost_update()
		
@export var is_checked:bool = false : 
	set(val):
		is_checked = val
		on_is_checked_update()
		
@export var show_checked_panel:bool = false : 
	set(val):
		show_checked_panel = val
		is_show_checked_panel_update()
		
@export var cost_val:int = 0 : 
	set(val):
		cost_val = val
		on_cost_val_update()

@export var show_cost:bool = false : 
	set(val):
		show_cost = val
		on_show_cost_update()
				
@export var fill:bool = false : 
	set(val):
		fill = val
		on_fill_update()		
		
	
@export var hint_icon:SVGS.TYPE = SVGS.TYPE.INFO
@export var hint_title:String = ""
@export var hint_description:String = ""
@export var allow_hint:bool = true		
		
const LabelSettingsPreload:LabelSettings = preload("res://Fonts/font_1_black.tres")
const CostLabelSettingsPreload:LabelSettings = preload("res://Fonts/font_2_16_black.tres")

var onClick:Callable = func():pass

# directly access, do not remove
var index:int
var ref_data:Dictionary = {"type": null, "data": null}

# ------------------------------------------------------------------------------
func _ready() -> void:
	on_is_selected_update()
	on_is_disabled_update()
	on_use_alt_update()
	on_hide_icon_update()
	on_icon_update()
	on_title_update()
	on_cost_update()
	on_is_checked_update()	
	is_show_checked_panel_update()
	on_fill_update()
	on_cost_val_update()
	on_show_cost_update()
	update_all()	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_is_selected_update() -> void:
	U.debounce(str(self, "_update_all"), update_all)

func on_is_disabled_update() -> void:
	U.debounce(str(self, "_update_all"), update_all)

func on_use_alt_update() -> void:
	U.debounce(str(self, "_update_all"), update_all)
	
func on_fill_update() -> void:
	if !is_node_ready():return
	TitlePanel.size_flags_horizontal = Control.SIZE_EXPAND_FILL if fill else Control.SIZE_SHRINK_BEGIN
	$".".size_flags_horizontal = Control.SIZE_EXPAND_FILL if fill else Control.SIZE_SHRINK_BEGIN
	
func on_show_energy_cost_update() -> void:
	if !is_node_ready():return
	EnergyPanel.show() if show_energy_cost else EnergyPanel.hide()

func on_cost_update() -> void:
	if !is_node_ready():return
	EnergyCostLabel.text = str(energy_cost)

func on_is_checked_update() -> void:
	if !is_node_ready():return
	CheckboxIcon.icon = SVGS.TYPE.CHECKBOX if is_checked else SVGS.TYPE.EMPTY_CHECKBOX

func on_cost_val_update() -> void:
	if !is_node_ready():return
	CostLabel.text = str(cost_val)
	
func on_show_cost_update() -> void:
	if !is_node_ready():return
	CostPanel.show() if show_cost else CostPanel.hide()

func is_show_checked_panel_update() -> void:
	if !is_node_ready():return
	CheckboxPanel.show() if show_checked_panel else CheckboxPanel.hide()
	
func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = str(title)

func update_all() -> void:
	update_font_color()
	on_panel_color_update()
	
func update_font_color() -> void:
	if !is_node_ready():return
	var label_duplicate:LabelSettings = LabelSettingsPreload.duplicate()
	var energy_label_duplicate:LabelSettings = CostLabelSettingsPreload.duplicate()
	var use_color:Color = COLORS.disabled_color if is_disabled else COLORS.primary_black

	#if use_alt:
		#use_color = Color.WHITE
		
	use_color.a = 1 if is_selected else 0.7
				
	label_duplicate.font_color = use_color
	energy_label_duplicate.font_color = use_color
	
	TitleLabel.label_settings = label_duplicate	
	EnergyCostLabel.label_settings = energy_label_duplicate
	CostLabel.label_settings = energy_label_duplicate
	
	for node in [Icon, CheckboxIcon, EnergyIcon, CostIcon]:
		node.icon_color = use_color


func on_panel_color_update() -> void:
	if !is_node_ready():return
	var new_stylebox:StyleBoxFlat = TitlePanel.get_theme_stylebox('panel').duplicate()	
	var use_color:Color = COLORS.primary_black if is_disabled else COLORS.primary_color 

	if use_alt:
		use_color = use_color.lightened(1.0)

	use_color.a = 1 if is_selected else 0.7		

	new_stylebox.bg_color = use_color
	
	for panel in [IconPanel, TitlePanel, EnergyPanel, CheckboxPanel, CostPanel]:
		panel.add_theme_stylebox_override("panel", new_stylebox)

func on_icon_update() -> void:
	if !is_node_ready():return
	Icon.icon = icon

func on_hide_icon_update() -> void:
	if !is_node_ready():return
	IconPanel.hide() if hide_icon else IconPanel.show()
	
func get_hint() -> Dictionary:
	if !allow_hint:
		return {}
	
	return {
		"icon": hint_icon,
		"title": hint_title,
		"description": hint_description
	}
# ------------------------------------------------------------------------------
