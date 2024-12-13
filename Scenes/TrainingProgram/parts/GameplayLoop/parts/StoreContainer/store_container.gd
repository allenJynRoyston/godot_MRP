@tool
extends GameContainer

@onready var CloseBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer2/CloseBtn
@onready var GridItemContainer:GridContainer = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer

#@onready var NextBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/NextBtn
#@onready var PreviousBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/PreviousBtn
#@onready var SubmitBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer2/SubmitBtn
#@onready var BackBtn:Control = $Back

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	CloseBtn.onClick = func() -> void:
		get_parent().store_data = {}
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
	
	for node in GridItemContainer.get_children():
		node.onClick = func() -> void:
			get_parent().store_data = {}
			get_parent().add_to_action_queue({})
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
# --------------------------------------------------------------------------------------------------		
