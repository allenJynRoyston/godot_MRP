@tool
extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var HeaderLabel:Label = $MarginContainer/VBoxContainer/HeaderLabel

@onready var AdminLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/AdminLabel
@onready var AdminCountLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer/AdminCountLabel
@onready var AdminBurnLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer/AdminBurnLabel

@onready var ResearcherLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/ResearcherLabel
@onready var ResearcherCountLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/PanelContainer/ResearcherCountLabel
@onready var ResearcherBurnLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/PanelContainer/ResearcherBurnLabel

@onready var SecurityLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer3/SecurityLabel
@onready var SecurityCountLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer3/PanelContainer/SecurityCountLabel
@onready var SecurityBurnLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer3/PanelContainer/SecurityBurnLabel

@onready var DClassLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer4/DClassLabel
@onready var DClassCountLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer4/PanelContainer/DClassCountLabel
@onready var DClassBurnLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer4/PanelContainer/DClassBurnLabel

@export var header:String = "" : 
	set(val):
		header = val
		on_header_update()

@export var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()
		
@export var admin_val:int = 0 : 
	set(val):
		admin_val = val
		on_admin_val_update()

@export var researcher_val:int = 0 : 
	set(val):
		researcher_val = val
		on_researcher_val_update()
		
@export var security_val:int = 0 : 
	set(val):
		security_val = val
		on_security_val_update()
		
@export var dclass_val:int = 0 : 
	set(val):
		dclass_val = val
		on_dclass_val_update()

const OrangePanelStylebox:StyleBoxFlat = preload("res://Styles/OrangePanel.tres")
const BlackPanelStylebox:StyleBoxFlat = preload("res://Styles/BlackPanel.tres")
const BlackFontLabelSetting:LabelSettings = preload("res://Fonts/font_2_black.tres")
const WhiteFontLabelSetting:LabelSettings = preload("res://Fonts/font_2_16_white.tres")

# -----------------------------------------------
func _ready() -> void:
	on_header_update()
	on_is_active_update()
	on_admin_val_update()
	on_researcher_val_update()
	on_security_val_update()
	on_dclass_val_update()
# -----------------------------------------------

# -----------------------------------------------
func on_is_active_update() -> void:
	if !is_node_ready():return
	RootPanel.set("theme_override_styles/panel", OrangePanelStylebox if is_active else BlackPanelStylebox)
	
	for node in [HeaderLabel, AdminLabel, ResearcherLabel, SecurityLabel, DClassLabel, AdminCountLabel, ResearcherCountLabel, SecurityCountLabel, DClassCountLabel]:
		node.label_settings = BlackFontLabelSetting if is_active else WhiteFontLabelSetting
	
	for node in [AdminBurnLabel, ResearcherBurnLabel, SecurityBurnLabel, DClassBurnLabel]:
		var new_label_settings:LabelSettings = BlackFontLabelSetting if is_active else WhiteFontLabelSetting
		node.label_settings = new_label_settings

func on_header_update() -> void:
	if !is_node_ready():return
	HeaderLabel.text = str(header)
	
func on_admin_val_update() -> void:
	if !is_node_ready():return
	AdminCountLabel.text = str(admin_val)

func on_researcher_val_update() -> void:
	if !is_node_ready():return
	ResearcherCountLabel.text = str(researcher_val)
	
func on_security_val_update() -> void:	
	if !is_node_ready():return
	SecurityCountLabel.text = str(security_val)	
	
func on_dclass_val_update() -> void:
	if !is_node_ready():return
	DClassCountLabel.text = str(dclass_val)	
# -----------------------------------------------	
