extends PanelContainer

@onready var HeaderLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer2/HeaderLabel
@onready var NoteList:VBoxContainer = $MarginContainer/VBoxContainer/NoteList

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")
const IconBtnPreload:PackedScene = preload("res://UI/Buttons/IconBtn/IconBtn.tscn")

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

func _ready() -> void:
	on_data_update()

func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	HeaderLabel.text = data.header
	
	for child in NoteList.get_children():
		child.queue_free()
	
	for item in data.list:
		var text_btn_node:Control = TextBtnPreload.instantiate() 
		var icon_node:Control = IconBtnPreload.instantiate()
		var new_hbox:HBoxContainer = HBoxContainer.new()
		
		icon_node.icon = SVGS.TYPE.CHECKBOX if item.is_checked else SVGS.TYPE.EMPTY_CHECKBOX
		icon_node.is_hoverable = false 
		icon_node.static_color = Color.WHITE if item.is_checked else Color.RED
		
		text_btn_node.panel_color = Color.TRANSPARENT
		text_btn_node.is_hoverable = false
		text_btn_node.icon = item.icon
		text_btn_node.title = item.text
		text_btn_node.static_color = Color.WHITE if item.is_checked else Color.RED
		
		new_hbox.add_child(icon_node)
		new_hbox.add_child(text_btn_node)

		NoteList.add_child(new_hbox)
