@tool
extends CardDrawerClass

@onready var ListContainer:HBoxContainer = $MarginContainer/MarginContainer/ListContainer

@export var list:Array = [] : 
	set(val):
		list = val
		on_list_update()

const ResourceItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResourceContainer/parts/ResourceItem/ResourceItem.tscn")


func _ready() -> void:
	super._ready()
	on_list_update()
	
func on_list_update() -> void:
	if !is_node_ready():return
	for node in ListContainer.get_children():
		node.queue_free()
		
	if list.is_empty():return
	
	for item in list:
		var new_node:Control = ResourceItemPreload.instantiate()
		new_node.no_bg = true
		new_node.display_at_bottom = true
		new_node.title = str(item.title)
		new_node.icon = item.icon
		new_node.icon_size = Vector2(20, 20)
		new_node.is_negative = item.is_negative if "is_negative" in item else false
		new_node.is_hoverable = false
		
		ListContainer.add_child(new_node)
