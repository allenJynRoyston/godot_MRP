@tool
extends GameContainer

@onready var CheckBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/CheckBtn
@onready var ContainBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ContainBtn

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	CheckBtn.onClick = func() -> void:
		get_parent().store_data = {"some": "data"}
	
	ContainBtn.onClick = func() -> void:
		get_parent().item_select_data = {"some": "data"}
# --------------------------------------------------------------------------------------------------		
