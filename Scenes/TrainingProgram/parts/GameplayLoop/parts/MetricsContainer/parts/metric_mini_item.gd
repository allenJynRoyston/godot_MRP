@tool
extends PanelContainer

@onready var TitleAmount:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/TitleHeader
@onready var TotalAmount:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/HBoxContainer/TotalAmount
@onready var ContextAmount:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/HBoxContainer/ContextAmount
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
		
@export var context_value:int = -100 : 
	set(val):
		context_value = val
		on_context_value_update()
		
func _ready() -> void:
	on_header_update()
	on_value_update()
	on_status_update()
	on_context_value_update()

func on_value_update() -> void:
	if !is_node_ready():return
	TotalAmount.text = str(value)

func on_status_update() -> void:
	if !is_node_ready():return
	StatusLabel.text = status

func on_header_update() -> void:
	if !is_node_ready():return
	TitleAmount.text = header

func on_context_value_update() -> void:
	if !is_node_ready():return
	if context_value == -100:
		ContextAmount.hide()
	else:
		ContextAmount.show()
		ContextAmount.text = str(context_value)
