@tool
extends PanelContainer

@onready var ContentList:VBoxContainer = $VBoxContainer/ContentList

@export var show_content:bool = false : 
	set(val):
		show_content = val
		on_show_content_update()
		
func on_show_content_update() -> void:
	if !is_node_ready():return
	ContentList.show() if show_content else ContentList.hide()
