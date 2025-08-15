@tool
extends VBoxContainer

@onready var BlockPanel:PanelContainer = $PanelContainer
@onready var AmountLabel:Label = $PanelContainer/MarginContainer/AmountLabel
@onready var SelectorIcon:Control = $PanelContainer/MarginContainer/SVGIcon

@onready var amount_label_settings_copy:LabelSettings = AmountLabel.label_settings.duplicate()
@onready var block_panel_copy:StyleBoxFlat = BlockPanel.get("theme_override_styles/panel").duplicate()

@export var block_color:Color = Color.WHITE : 
	set(val):
		block_color = val
		on_block_color_update()

@export var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()
		
@export var amount_val:int = 0 : 
	set(val):		
		amount_val = val
		on_amount_val_update()
		
func _ready() -> void:
	on_is_active_update()
	on_amount_val_update()
	on_block_color_update()
	
	BlockPanel.set("theme_override_styles/panel", block_panel_copy)
	AmountLabel.label_settings = amount_label_settings_copy
	
func on_is_active_update() -> void:
	if !is_node_ready():return
	SelectorIcon.hide()
	#SelectorIcon.show() if is_active else SelectorIcon.hide()
	on_block_color_update()
	
func on_amount_val_update() -> void:
	if !is_node_ready():return
	AmountLabel.text = str(amount_val)
	
func on_block_color_update() -> void:
	if !is_node_ready():return
	block_panel_copy.bg_color = block_color if is_active else COLORS.primary_black
	amount_label_settings_copy.font_color = Color.WHITE if is_active else block_color
	
	BlockPanel.set("theme_override_styles/panel", block_panel_copy)
