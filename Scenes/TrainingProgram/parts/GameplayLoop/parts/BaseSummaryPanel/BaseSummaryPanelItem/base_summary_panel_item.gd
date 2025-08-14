@tool
extends PanelContainer

@onready var SelectedIcon:PanelContainer = $VBoxContainer/MarginContainer2/SVGIcon


@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
		
func on_is_selected_update() -> void:
	if !is_node_ready():return
	SelectedIcon.show() if is_selected else SelectedIcon.hide()
