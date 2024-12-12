@tool
extends GameContainer

@onready var CheckBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/CheckBtn

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	CheckBtn.onClick = func():
		is_showing = !is_showing
# --------------------------------------------------------------------------------------------------		
