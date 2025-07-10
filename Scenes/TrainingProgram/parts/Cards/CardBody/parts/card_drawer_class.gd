@tool
extends Control
class_name CardDrawerClass

@onready var RootPanel:PanelContainer = $"."
@onready var TitleLabel:Label = $MarginContainer/VBoxContainer/Label

@export var title:String = "TITLE LABEL": 
	set(val):
		title = val
		on_title_update()

@export var is_left_side:bool = false :
	set(val):
		is_left_side = val
		on_is_left_side_update()
		on_title_update()

@export var border_color:Color = Color(1.0, 0.108, 0.485) : 
	set(val):
		border_color = val
		on_border_color_update()
				
func _ready() -> void:
	on_is_left_side_update()
	on_title_update()
	on_border_color_update()

func on_is_left_side_update() -> void:
	if !is_node_ready():return
	TitleLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT if is_left_side else HORIZONTAL_ALIGNMENT_RIGHT

func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = str(" ", title) if is_left_side else str(title, " ")

func on_border_color_update() -> void:
	if !is_node_ready():return
	#var panel_stylebox:StyleBoxFlat = RootPanel.get('theme_override_styles/panel').duplicate()
	#panel_stylebox.border_color = border_color
	#RootPanel.set('theme_override_styles/panel', panel_stylebox)
