extends PanelContainer

@onready var List:HBoxContainer = $MarginContainer2/VBoxContainer/List

@export var personnel_capacity:Dictionary :
	set(val):
		personnel_capacity = val
		on_personnel_capacity_update()
		
const PersonnelItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/HeaderControl/parts/PersonnelItem/PersonnelItem.tscn")
		
		
func _ready() -> void:
	on_personnel_capacity_update()

func on_personnel_capacity_update() -> void:
	if !is_node_ready():return
	
	for node in List.get_children():
		node.queue_free()
		
	for key in personnel_capacity:
		var amount:int = personnel_capacity[key]
		if amount != 0:
			var new_node:Control = PersonnelItemPreload.instantiate()
			new_node.title = RESEARCHER_UTIL.return_specialization_data(key).name
			new_node.value = RESEARCHER_UTIL.get_spec_count(key)
			new_node.max_val = RESEARCHER_UTIL.get_spec_capacity_count(key)
			new_node.capacity_val = amount
			new_node.capacity_only = true
			List.add_child(new_node)
