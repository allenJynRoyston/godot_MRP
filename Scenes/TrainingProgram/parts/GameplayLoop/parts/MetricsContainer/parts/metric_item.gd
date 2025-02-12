@tool
extends PanelContainer

@onready var TitleHeader:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/TitleHeader
@onready var TitleContent:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/HBoxContainer/TitleContent

@onready var StatusHeader:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/StatusHeader
@onready var StatusContent:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/StatusContent

@onready var IconBtn:BtnBase = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/HBoxContainer/IconBtn
@onready var ListContainer:VBoxContainer = $VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/List

enum TYPE {SCP, ROOM, RESEARCHER}

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")
const label_settings:LabelSettings = preload("res://Fonts/game/label_small.tres")

@export var type:TYPE :
	set(val):
		type = val
		on_type_update()

@export var header:String = "TITLE" : 
	set(val):
		header = val
		on_header_update()
		

@export var status:String = "" : 
	set(val):
		status = val
		on_status_update()		

@export var items:Array = [] : 
	set(val):
		items = val
		on_items_update()		
		
@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_updated()

# ------------------------------
func _ready() -> void:
	on_header_update()
	on_items_update()
	on_type_update()
	on_status_update()	
	on_is_selected_updated()
# ------------------------------

# ------------------------------	
func on_header_update() -> void:
	if !is_node_ready():return
	TitleContent.text = header
# ------------------------------

# ------------------------------
func on_status_update() -> void:
	if !is_node_ready():return
	StatusContent.text = status
# ------------------------------
	
# ------------------------------
func on_type_update() -> void:
	if !is_node_ready():return
	var new_stylebox:StyleBoxFlat = StyleBoxFlat.new()
	new_stylebox.corner_radius_bottom_left = 5
	new_stylebox.corner_radius_bottom_right = 5
	new_stylebox.corner_radius_top_left = 5
	new_stylebox.corner_radius_top_right = 5
	
	match type:
		TYPE.SCP:
			TitleHeader.text = "DESIGNATION"
			StatusHeader.text = "ITEM CLASS:"
			new_stylebox.bg_color = Color(0.455, 0.002, 0.713)
		TYPE.ROOM:
			TitleHeader.text = "ROOM"
			StatusHeader.text = "STATUS:"
			new_stylebox.bg_color = Color(0, 0.529, 1)			
		TYPE.RESEARCHER:
			TitleHeader.text = "RESEARCHER"
			StatusHeader.text = "VITALS:"
			new_stylebox.bg_color = Color(1, 0.34, 0.307)
			
	add_theme_stylebox_override("panel", new_stylebox)
# ------------------------------

# ------------------------------
func on_is_selected_updated() -> void:
	if !is_node_ready():return	
	IconBtn.hide() if !is_selected else IconBtn.show()
# ------------------------------

# ------------------------------
func on_items_update() -> void:
	if !is_node_ready():return

	for child in ListContainer.get_children():
		child.queue_free()

	for item in items:
		var new_label:Label = Label.new()
		new_label.label_settings = label_settings		
		new_label.text = item.title
		
		ListContainer.add_child(new_label)
# ------------------------------		
