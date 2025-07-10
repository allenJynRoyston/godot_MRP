@tool
extends Control

@onready var StageLabel:Label = $MarginContainer/HBoxContainer/StageLabel
@onready var Icon:Control = $MarginContainer/HBoxContainer/Control/SVGIcon

@export var title:String = "" : 
	set(val):
		title = val
		on_title_update()
	
@export var icon:SVGS.TYPE = SVGS.TYPE.MEDIA_PAUSE : 
	set(val):
		icon = val
		on_icon_update()	
	
func _ready() -> void:
	on_title_update()
	on_icon_update()
	
func on_title_update() -> void:
	if !is_node_ready():return
	StageLabel.text = str(title)
	
func on_icon_update() -> void:
	if !is_node_ready():return
	Icon.icon = icon
	
