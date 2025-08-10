@tool
extends HBoxContainer

@onready var KeyLabel:Label = $ColorRect/MarginContainer/Label
@onready var ActionLabel:Label = $ColorRect2/MarginContainer/ActionLabel

@export var key_label:String = "" : 
	set(val):
		key_label = val
		on_key_label_update()
		
@export var action_label:String = "" : 
	set(val):
		action_label = val
		on_action_label_update()
		
@export var is_disabled:bool = false : 
	set(val):
		is_disabled = val
		on_is_disabled_update()


func _ready() -> void:
	on_key_label_update()
	on_action_label_update()
	on_is_disabled_update()

func on_key_label_update() -> void:
	if !is_node_ready():return
	KeyLabel.text = key_label	
	await U.tick()
	KeyLabel.size.x = 1	
	$ColorRect.custom_minimum_size.x = KeyLabel.size.x + 10
	


func on_action_label_update() -> void:
	if !is_node_ready():return	
	ActionLabel.text = action_label

	

func on_is_disabled_update() -> void:
	if !is_node_ready():return	
	modulate = Color(1, 0, 0, 1) if is_disabled else Color(1, 1, 1, 1)
