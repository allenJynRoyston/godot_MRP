@tool
extends GameContainer

@onready var CheckBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/CheckBtn
@onready var ContainBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ContainBtn

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	var parentNode:Control = get_parent()
	
	CheckBtn.onClick = func() -> void:
		parentNode.current_shop_step = parentNode.SHOP_STEPS.START
	
	ContainBtn.onClick = func() -> void:
		parentNode.current_contain_step = parentNode.CONTAIN_STEPS.START
# --------------------------------------------------------------------------------------------------		
