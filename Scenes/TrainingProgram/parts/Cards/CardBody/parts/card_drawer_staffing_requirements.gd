@tool
extends PanelContainer

@onready var ListContainer:HBoxContainer = $MarginContainer/MarginContainer/ListContainer

const ResourceItemPreload:PackedScene = preload("res://UI/ResourceItem/ResourceItem.tscn")

var current_location:Dictionary
var room_config:Dictionary

var required_staffing:Array = [] : 
	set(val):
		required_staffing = val
		on_required_staffing_update()


func on_required_staffing_update() -> void:
	if !is_node_ready():return
	
	for node in ListContainer.get_children():
		node.queue_free()
		
	for ref in required_staffing:
		var new_node:Control = ResourceItemPreload.instantiate()
		var staff_data:Dictionary = RESEARCHER_UTIL.return_specialization_data(ref)
		new_node.no_bg = true
		new_node.title = staff_data.shortname
		new_node.icon = SVGS.TYPE.STAFF
		ListContainer.add_child(new_node)		
