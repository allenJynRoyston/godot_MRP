extends HBoxContainer

@onready var IconBtn:BtnBase = $IconBtn
@onready var ListLabel:Label = $ListLabel

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

func _ready() -> void:
	on_data_update()

func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	
	IconBtn.icon = data.icon
	ListLabel.text = data.text.call()
