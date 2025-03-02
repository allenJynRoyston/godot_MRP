@tool
extends VBoxContainer

@onready var TitleLabel:Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TitleLabel
@onready var ResourceGrid:GridContainer = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/ResourceGrid

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

@export var title:String = "TITLE" : 
	set(val):
		title = val
		on_title_update()
		
@export var list:Array = [] : 
	set(val):
		list = val
		on_list_update()

# --------------------
func _ready() -> void:	
	on_title_update()
	on_list_update()
# --------------------

# --------------------
func clear_list() -> void:
	if !is_node_ready() or Engine.is_editor_hint():return
	for child in ResourceGrid.get_children():
		child.free()
# --------------------

# --------------------
func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = " %s" % [title]

func on_list_update() -> void:
	if !is_node_ready():return
	clear_list()
	for item in list:
		var btn_node:Control = TextBtnPreload.instantiate()
		btn_node.is_hoverable = false
		btn_node.panel_color = Color.TRANSPARENT
		btn_node.title = "%s%s" % ["+" if item.amount > 0 else "", item.amount]
		btn_node.icon = item.resource.icon
		ResourceGrid.add_child(btn_node)
# --------------------
