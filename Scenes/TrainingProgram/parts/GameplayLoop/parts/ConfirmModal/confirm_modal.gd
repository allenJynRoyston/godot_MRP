@tool
extends GameContainer

@onready var AcceptBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/AcceptBtn
@onready var BackBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/BackBtn

signal user_response

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	AcceptBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.NEXT})
	BackBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.BACK})
# --------------------------------------------------------------------------------------------------		
