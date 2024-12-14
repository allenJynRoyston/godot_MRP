@tool
extends GameContainer

@onready var CloseBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer2/CloseBtn
@onready var GridItemContainer:GridContainer = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer

#@onready var NextBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/NextBtn
#@onready var PreviousBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/PreviousBtn
#@onready var SubmitBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer2/SubmitBtn
#@onready var BackBtn:Control = $Back

signal user_response

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	CloseBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.BACK})
		
	
	for index in GridItemContainer.get_child_count():
		var node:Control = GridItemContainer.get_child(index)
		node.onClick = func() -> void:
			user_response.emit({"action": ACTION.NEXT, "data": {}})

# --------------------------------------------------------------------------------------------------		
