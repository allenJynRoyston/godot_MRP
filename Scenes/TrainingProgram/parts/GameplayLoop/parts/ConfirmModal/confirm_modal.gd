@tool
extends GameContainer

@onready var TitleLabel:Label = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/VBoxContainer/TitleLabel
@onready var SubLabel:Label = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/VBoxContainer/SubLabel
@onready var AcceptBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/AcceptBtn
@onready var BackBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/BackBtn

var title:String = "" : 
	set(val):
		title = val
		on_title_update()
		
var subtitle:String = "" : 
	set(val):
		subtitle = val
		on_subtitle_update()

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
		
	on_title_update()
	on_subtitle_update()

func set_text(new_title:String = "", new_subtitle:String = "") -> void:
	title = new_title
	subtitle = new_subtitle
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title
	TitleLabel.hide() if title.is_empty() else TitleLabel.show()
		
func on_subtitle_update() -> void:
	if !is_node_ready():return
	SubLabel.text = subtitle	
	SubLabel.hide() if subtitle.is_empty() else SubLabel.show()
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
	
