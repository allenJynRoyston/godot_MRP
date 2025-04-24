@tool
extends CardDrawerClass

@onready var ContainedEffect:Control = $MarginContainer/MarginContainer/VBoxContainer/ContainedEffect
@onready var ContainedPanel:PanelContainer = $MarginContainer/MarginContainer/VBoxContainer/ContainedEffect/PanelContainer
@onready var ContainedDescription:Label = $MarginContainer/MarginContainer/VBoxContainer/ContainedEffect/PanelContainer/MarginContainer/DescriptionLabel

var effects:Dictionary = {} : 
	set(val):
		effects = val
		on_effects_update()

func _ready() -> void:
	super._ready()

func on_effects_update() -> void:
	if !is_node_ready():return	
	ContainedDescription.text = effects.description
