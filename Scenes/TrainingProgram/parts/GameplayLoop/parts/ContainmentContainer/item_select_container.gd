@tool
extends GameContainer

@onready var BackBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/BackBtn
@onready var NextBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/NextBtn

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	BackBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.BACK})
	
	NextBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.NEXT})
# --------------------------------------------------------------------------------------------------		
