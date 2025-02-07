@tool
extends PanelContainer

@onready var TitleHeader:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/TitleHeader
@onready var TitleContent:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/TitleContent
@onready var StatusLabel:Label = $VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/StatusLabel

@export var header:String = "METRIC" :
	set(val):
		header = val
		on_header_update()
		
@export var value:int = 0 :
	set(val):
		value = val
		on_value_update()		
		
@export var status:String = "NORMAL" : 
	set(val):
		status = val
		on_status_update()
		
func _ready() -> void:
	on_header_update()
	on_value_update()
	on_status_update()

func on_header_update() -> void:
	if !is_node_ready():return
	TitleHeader.text = header

func on_value_update() -> void:
	if !is_node_ready():return
	TitleContent.text = str(value)

func on_status_update() -> void:
	if !is_node_ready():return
	StatusLabel.text = status
