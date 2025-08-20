extends Control

@onready var Component:PanelContainer = $Component
@onready var ComponentMargin:MarginContainer = $Component/MarginContainer

@onready var Location:Control = $Component/MarginContainer/VBoxContainer/Location
@onready var BuffsAndDebuffs:Control = $Component/MarginContainer/VBoxContainer/BuffsAndDebuffs

var control_pos:Dictionary

func _ready() -> void:
	self.modulate.a = 0
	Location.hide()
	BuffsAndDebuffs.hide()
	await U.tick()
	
	Location.show()
	BuffsAndDebuffs.show()
	
	await U.tick()
	control_pos[Component] = {
		"show": 0,
		"hide": -ComponentMargin.size.x
	}
	
	Component.position.x = control_pos[Component].hide

func reveal(state:bool) -> void:
	if state:
		self.modulate.a = 1
		show()

	await U.tween_node_property(Component, "position:x", control_pos[Component].show if state else control_pos[Component].hide, 0.3 if !state else 0.7, 0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	
	if !state:
		self.modulate.a = 0
		hide()
