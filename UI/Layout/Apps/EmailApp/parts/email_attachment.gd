extends MouseInteractions

@onready var Icon:TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect
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

func on_data_update() -> void:
	if is_node_ready() and !data.is_empty():
		AttachmentLabel.text = data.title


# --------------------------------------	
func on_focus(state:bool) -> void:
	var shader_material:ShaderMaterial = Icon.material.duplicate()	
	shader_material.set_shader_parameter("tint_color", Color(0, 0.965, 0.278, 1) if state else Color(0, 0.529, 0.278, 1))
	Icon.material = shader_material
	
	var label_setting:LabelSettings = AttachmentLabel.label_settings.duplicate()
	label_setting.font_color = Color(0, 0.965, 0.278, 1) if state else Color(0, 0.529, 0.278, 1)
	AttachmentLabel.label_settings = label_setting
	DownloadLabel.label_settings = label_setting

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and "onClick" in data:
		data.onClick.call()
# --------------------------------------		
