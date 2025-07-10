@tool
extends CardDrawerClass

@onready var ListContainer:HBoxContainer = $MarginContainer/MarginContainer/ListContainer

@export var list:Array = [] : 
	set(val):
		list = val
		on_list_update()

var researchers_per_room:int

const EconItemPreload:PackedScene = preload("res://UI/EconItem/EconItem.tscn")


func _ready() -> void:
	super._ready()
	on_list_update()
	
func on_list_update() -> void:
	if !is_node_ready():return
	for node in ListContainer.get_children():
		node.queue_free()
		
	if list.is_empty():return
	
	for item in list:
		var new_node:Control = EconItemPreload.instantiate()
		new_node.amount = int(item.title)
		new_node.icon = item.icon
		new_node.icon_size = Vector2(25, 25)
		new_node.is_negative = item.is_negative if "is_negative" in item else false
		
		ListContainer.add_child(new_node)
