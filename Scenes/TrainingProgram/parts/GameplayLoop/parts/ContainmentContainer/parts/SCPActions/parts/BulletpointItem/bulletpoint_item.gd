extends VBoxContainer

@onready var HeaderLabel:Label = $HBoxContainer/HeaderLabel
@onready var PlacementList:VBoxContainer = $MarginContainer/PlacementList

const BulletpointListItem:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ContainmentContainer/parts/SCPActions/parts/BulletpointItem/BulletpointListItem/BulletpointListItem.tscn")

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

func _ready() -> void:
	on_data_update()

func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	
	HeaderLabel.text = data.header
	
	for child in PlacementList.get_children():
		child.queue_free()
		
	for list_data in data.list:
		var new_item:Control = BulletpointListItem.instantiate()
		new_item.data = list_data
		PlacementList.add_child(new_item)
	
	
