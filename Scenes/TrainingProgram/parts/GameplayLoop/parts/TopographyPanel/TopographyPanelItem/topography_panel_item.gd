@tool
extends PanelContainer

@onready var Status:PanelContainer = $VBoxContainer/Status
@onready var StatusIcon:Control = $VBoxContainer/Status/MarginContainer/SVGIcon
@onready var SelectedIcon:PanelContainer = $VBoxContainer/MarginContainer2/SVGIcon
@onready var PanelTitle:Label = $VBoxContainer/Header/MarginContainer/Label

@onready var status_stylebox:StyleBoxFlat = Status.get("theme_override_styles/panel").duplicate()
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
	Status.set("theme_override_styles/panel", status_stylebox)
	PanelTitle.set("label_settings", title_label_copy)
	on_is_selected_update()

func on_title_str_update() -> void:
	if !is_node_ready():return
	PanelTitle.text = active_str if is_selected else inactive_str

func on_is_selected_update() -> void:
	if !is_node_ready():return
	SelectedIcon.show() if is_selected else SelectedIcon.hide()
	title_label_copy.font_color = COLORS.primary_color if !is_selected else COLORS.primary_white 
	status_stylebox.bg_color = COLORS.primary_color if is_selected else COLORS.primary_black 
	StatusIcon.icon_color = COLORS.primary_color if !is_selected else COLORS.primary_black 
	on_title_str_update()
	
