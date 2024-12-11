extends MouseInteractions

@onready var IconButton:Control = $MarginContainer/VBoxContainer/HBoxContainer/IconBtn
@onready var DownloadLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var AttachmentLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/AttachmentLabel

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

func _ready() -> void:
	super._ready()
	on_data_update()
	on_focus(false)

# --------------------------------------		
func on_data_update() -> void:
	if is_node_ready() and !data.is_empty():
		AttachmentLabel.text = data.title
# --------------------------------------	

# --------------------------------------	
func on_focus(state:bool) -> void:
	if is_node_ready():
		IconButton.static_color = COLOR_REF.get_window_color(COLORS.WINDOW.ACTIVE) if state else COLOR_REF.get_window_color(COLORS.WINDOW.INACTIVE)
		
		var label_setting:LabelSettings = AttachmentLabel.label_settings.duplicate()
		label_setting.font_color = COLOR_REF.get_window_color(COLORS.WINDOW.ACTIVE) if state else COLOR_REF.get_window_color(COLORS.WINDOW.INACTIVE)
		AttachmentLabel.label_settings = label_setting
		DownloadLabel.label_settings = label_setting
		
		if !Engine.is_editor_hint():
			GBL.change_mouse_icon(GBL.MOUSE_ICON.POINTER if state else GBL.MOUSE_ICON.CURSOR)		
# --------------------------------------	

# --------------------------------------	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and "onClick" in data:
		data.onClick.call(data)
# --------------------------------------		
