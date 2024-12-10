extends PanelContainer

signal wait_for_input

@export var delay:float = 0.7

func _ready() -> void:
	hide()
