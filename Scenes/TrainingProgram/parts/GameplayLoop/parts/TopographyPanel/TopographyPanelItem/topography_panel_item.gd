@tool
extends PanelContainer

@onready var HeaderPanel:PanelContainer = $VBoxContainer/Header
@onready var PanelTitle:Label = $VBoxContainer/Header/MarginContainer/Label

@onready var panel_stylebox:StyleBoxFlat = HeaderPanel.get("theme_override_styles/panel").duplicate()
@onready var title_label_copy:LabelSettings = PanelTitle.get("label_settings").duplicate()

@export var active_str:String = "" : 
	set(val):
		active_str = val
		on_title_str_update()
		
@export var inactive_str:String = "" : 
	set(val):
		inactive_str = val
		on_title_str_update()	

@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
		
func _ready() -> void:
	HeaderPanel.set("theme_override_styles/panel", panel_stylebox)
	PanelTitle.set("label_settings", title_label_copy)
	on_is_selected_update()

func on_title_str_update() -> void:
	if !is_node_ready():return
	PanelTitle.text = active_str if is_selected else inactive_str

func on_is_selected_update() -> void:
	if !is_node_ready():return
	#SelectedIcon.show() if is_selected else SelectedIcon.hide()
	panel_stylebox.bg_color = COLORS.primary_black if !is_selected else COLORS.primary_color 
	title_label_copy.font_color = COLORS.primary_black if is_selected else COLORS.primary_color 
	on_title_str_update()
	
