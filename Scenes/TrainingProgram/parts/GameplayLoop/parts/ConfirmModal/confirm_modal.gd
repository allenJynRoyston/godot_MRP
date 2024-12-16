@tool
extends GameContainer

@onready var AcceptBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/AcceptBtn
@onready var BackBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/BackBtn

signal user_response

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)
	
func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)

func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	AcceptBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.NEXT})
	BackBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.BACK})
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_control_input_update(input_data:Dictionary) -> void:
	if is_visible_in_tree():
		var key:String = input_data.key
		var keycode:int = input_data.keycode
		
		match key:
			"ENTER":
				user_response.emit({"action": ACTION.NEXT})
			"BACK":
				user_response.emit({"action": ACTION.BACK})
# --------------------------------------------------------------------------------------------------		
	
