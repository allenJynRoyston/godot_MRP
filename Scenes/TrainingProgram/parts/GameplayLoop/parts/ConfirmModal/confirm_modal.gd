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
		
var confirm_only:bool = false : 
	set(val):
		confirm_only = val
		on_confirm_only_update()
		
var cancel_only:bool = false : 
	set(val):
		cancel_only = val
		on_cancel_only_update()

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
func on_is_showing_update() -> void:
	super.on_is_showing_update()
	if !is_showing:
		await U.set_timeout(0.5)
		confirm_only = false
		cancel_only = false
		
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
func on_cancel_only_update() -> void:
	if !is_node_ready():return
	if cancel_only:
		AcceptBtn.hide()
	else:
		AcceptBtn.show()
		
func on_confirm_only_update() -> void:
	if !is_node_ready():return
	if confirm_only:
		BackBtn.hide()
	else:
		BackBtn.show()
# --------------------------------------------------------------------------------------------------		


# --------------------------------------------------------------------------------------------------		
func on_control_input_update(input_data:Dictionary) -> void:
	if is_visible_in_tree():
		var key:String = input_data.key
		var keycode:int = input_data.keycode
		
		match key:
			"E":
				user_response.emit({"action": ACTION.NEXT})
			"B":
				if BackBtn.is_visible():
					user_response.emit({"action": ACTION.BACK})
					
			"ENTER":
				user_response.emit({"action": ACTION.NEXT})
			"BACK":
				if BackBtn.is_visible():
					user_response.emit({"action": ACTION.BACK})
# --------------------------------------------------------------------------------------------------		
	
