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
	
#var onClick:Callable = func(_data:Dictionary):pass

# --------------------------------------		
func on_data_update() -> void:
	if is_node_ready() and !data.is_empty():
		AttachmentLabel.text = data.title
# --------------------------------------	

## --------------------------------------	
#func on_focus(state:bool) -> void:
	#if !is_node_ready():return
	#IconButton.static_color = Color(1, 1, 1, 1 if state else 0.5)
	#
	#var label_setting:LabelSettings = AttachmentLabel.label_settings.duplicate()
	#label_setting.font_color = Color(1, 1, 1, 1 if state else 0.5)
	#AttachmentLabel.label_settings = label_setting
	#DownloadLabel.label_settings = label_setting
		#
	#if state:
		#GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	#else:
		#GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
## --------------------------------------	
#
## --------------------------------------	
#func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	#if on_hover:
		#onClick.call()
## --------------------------------------		
