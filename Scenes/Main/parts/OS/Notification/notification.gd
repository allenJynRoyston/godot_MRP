@tool
extends PanelContainer
class_name Notification

enum TYPE {WARNING, CAUTION, INFO}

@onready var IconBtn:Control = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/IconBtn
@onready var OkayBtn:Control = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/OkayBtn
@onready var NotificationLabel:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/NotificationLabel
@onready var TitleLabel:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TitleLabel

@onready var CustomButtonContainer:HBoxContainer = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/CustomButtonContainer

const TextButtonPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

signal resolve

# ------------------------------------------------
func _ready() -> void:
	on_data_update()
	OkayBtn.onClick = func():
		resolve.emit({})
# ------------------------------------------------

# ------------------------------------------------
func on_data_update() -> void:
	if data.is_empty():
		hide()
		return
	
	show()
	
	for child in CustomButtonContainer.get_children():
		child.queue_free()
	
	if "type" in data:
		match data.type:
			TYPE.INFO:
				IconBtn.icon = SVGS.TYPE.INFO			
			TYPE.WARNING:
				IconBtn.icon = SVGS.TYPE.WARNING
			TYPE.CAUTION:
				IconBtn.icon = SVGS.TYPE.CAUTION
	else:
		IconBtn.icon = SVGS.TYPE.INFO
			
	if "buttons" in data:
		OkayBtn.hide()
		for item in data.buttons:
			var show:bool = true
			if "show" in item:
				show = item.show
			if show:
				var new_button:Control = TextButtonPreload.instantiate()
				new_button.title = item.title
				new_button.onClick = func() -> void:
					item.onClick.call()
					resolve.emit({})
				CustomButtonContainer.add_child(new_button)
	else:
		OkayBtn.show()
		
	
	TitleLabel.text = data.title if "title" in data else "Notification"
	NotificationLabel.text = data.message if "message" in data else ""
			
# ------------------------------------------------
