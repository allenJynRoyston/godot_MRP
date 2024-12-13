@tool
extends GameContainer

@onready var BackBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/BackBtn

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	BackBtn.onClick = func() -> void:
		get_parent().item_select_data = {}
# --------------------------------------------------------------------------------------------------		
