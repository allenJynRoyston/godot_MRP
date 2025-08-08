@tool
extends PanelContainer

@onready var ListContainer:VBoxContainer = $MarginContainer/MarginContainer/ListContainer

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
		
	var tally:Dictionary = {}
	for ref in [RESEARCHER.SPECIALIZATION.ADMIN, RESEARCHER.SPECIALIZATION.RESEARCHER, RESEARCHER.SPECIALIZATION.SECURITY, RESEARCHER.SPECIALIZATION.DCLASS]:
		tally[ref] = RESEARCHER_UTIL.get_spec_available_count(ref)

	for ref in required_staffing:
		var new_node:Control = ResourceItemPreload.instantiate()
		var staff_data:Dictionary = RESEARCHER_UTIL.return_specialization_data(ref)
		tally[ref] -= 1
		new_node.no_bg = true
		new_node.is_negative = tally[ref] < 0
		new_node.title = staff_data.name
		new_node.icon = SVGS.TYPE.STAFF
		ListContainer.add_child(new_node)		
