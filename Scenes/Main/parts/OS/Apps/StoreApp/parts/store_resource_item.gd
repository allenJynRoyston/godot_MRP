@tool
extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var HeaderLabel:Label = $MarginContainer/VBoxContainer/HeaderLabel

@onready var MoneyLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer/MoneyLabel
@onready var ScienceLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/PanelContainer/ScienceLabel
@onready var MaterialLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer3/PanelContainer/MaterialLabel
@onready var CoreLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer4/PanelContainer/CoreLabel

@onready var MoneyBurnLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer/MoneyBurnLabel
@onready var ScienceBurnLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/PanelContainer/ScienceBurnLabel
@onready var MaterialBurnLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer3/PanelContainer/MaterialBurnLabel
@onready var CoreBurnLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer4/PanelContainer/CoreBurnLabel

@onready var MoneyIcon:Control = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MoneyIcon
@onready var ScienceIcon:Control = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/ScienceIcon
@onready var MaterialIcon:Control = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer3/MaterialIcon
@onready var CoreIcon:Control = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer4/CoreIcon

@export var header:String = "" : 
	set(val):
		header = val
		on_header_update()

@export var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()
		
@export var money_val:int = 0 : 
	set(val):
		money_val = val
		on_money_val_update()

@export var science_val:int = 0 : 
	set(val):
		science_val = val
		on_science_val_update()
		
@export var material_val:int = 0 : 
	set(val):
		material_val = val
		on_material_val_update()
		
@export var core_val:int = 0 : 
	set(val):
		core_val = val
		on_core_val_update()

const OrangePanelStylebox:StyleBoxFlat = preload("res://Styles/OrangePanel.tres")
const BlackPanelStylebox:StyleBoxFlat = preload("res://Styles/BlackPanel.tres")
const BlackFontLabelSetting:LabelSettings = preload("res://Fonts/font_2_black.tres")
const WhiteFontLabelSetting:LabelSettings = preload("res://Fonts/font_2_16_white.tres")

# -----------------------------------------------
func _ready() -> void:
	on_header_update()
	on_is_active_update()
	on_money_val_update()
	on_science_val_update()
	on_material_val_update()
	on_core_val_update()
# -----------------------------------------------

# -----------------------------------------------
func on_is_active_update() -> void:
	if !is_node_ready():return
	RootPanel.set("theme_override_styles/panel", OrangePanelStylebox if is_active else BlackPanelStylebox)
	
	for node in [HeaderLabel, MoneyLabel, ScienceLabel, MaterialLabel, CoreLabel]:
		node.label_settings = BlackFontLabelSetting if is_active else WhiteFontLabelSetting
	
	for node in [MoneyIcon, ScienceIcon, MaterialIcon, CoreIcon]:
		node.icon_color = COLORS.primary_black if is_active else COLORS.primary_white
		
	for node in [MoneyBurnLabel, ScienceBurnLabel, MaterialBurnLabel, CoreBurnLabel]:
		var new_label_settings:LabelSettings = BlackFontLabelSetting if is_active else WhiteFontLabelSetting
		node.label_settings = new_label_settings

func on_header_update() -> void:
	if !is_node_ready():return
	HeaderLabel.text = str(header)
	
func on_money_val_update() -> void:
	if !is_node_ready():return
	MoneyLabel.text = str(money_val)

func on_science_val_update() -> void:
	if !is_node_ready():return
	ScienceLabel.text = str(science_val)
	
func on_material_val_update() -> void:	
	if !is_node_ready():return
	MaterialLabel.text = str(material_val)	
	
func on_core_val_update() -> void:
	if !is_node_ready():return
	CoreLabel.text = str(core_val)	
# -----------------------------------------------	
