@tool
extends PanelContainer

@onready var RootPanel:Control = $"."
@onready var RootMargin:MarginContainer = $MarginContainer
@onready var Icon:Control = $MarginContainer/HBoxContainer/SVGIcon
@onready var TabLabel:Label = $MarginContainer/HBoxContainer/Label

@onready var stylebox_duplicate:StyleBoxFlat = RootPanel.get("theme_override_styles/panel").duplicate()

@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
		
@export var tab_title:String = "" : 
	set(val):
		tab_title = val
		on_tab_title_update()		
		
func _ready() -> void:
	on_is_selected_update()
	on_tab_title_update()
	RootPanel.set("theme_override_styles/panel", stylebox_duplicate)

func on_tab_title_update() -> void:
	if !is_node_ready():return
	TabLabel.text = tab_title

func on_is_selected_update() -> void:
	if !is_node_ready():return
	Icon.show() if is_selected else Icon.hide()
	var stylebox_color:Color =  Color.GREEN if is_selected else Color.DARK_GREEN
	stylebox_color.a = 1.0 if is_selected else 0.9
	stylebox_duplicate.bg_color = stylebox_color
	
	U.tween_range(RootMargin.get('theme_override_constants/margin_top'), 10 if is_selected else 0, 0.1, 
		func(val:float):
			RootMargin.set('theme_override_constants/margin_top', val)
	)
	
	modulate.a = 1.0 
