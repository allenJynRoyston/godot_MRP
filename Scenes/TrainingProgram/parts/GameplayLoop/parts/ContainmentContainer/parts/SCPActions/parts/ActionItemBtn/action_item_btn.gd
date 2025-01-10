@tool
extends PanelContainer

@onready var TtleBtn:Control = $MarginContainer/VBoxContainer/HBoxContainer/TitleBtn
@onready var BulletpointItemContainer:VBoxContainer = $MarginContainer/VBoxContainer/BulletpointItemContainer

const BulletpointItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ContainmentContainer/parts/SCPActions/parts/BulletpointItem/BulletpointItem.tscn")

var data:Dictionary = {} : 
	set(val):
		data = val 
		on_data_update()

var onClick:Callable = func():pass

# --------------------------------------	
func _ready() -> void:
	on_data_update()
	
	TtleBtn.onClick = func() -> void:
		onClick.call()
# --------------------------------------		

# --------------------------------------		
func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	
	TtleBtn.title = data.title
	TtleBtn.icon = data.title_icon
	
	for child in BulletpointItemContainer.get_children():
		child.queue_free()
	
	if "bulletpoints" not in data or data.bulletpoints.size() == 0:
		BulletpointItemContainer.hide()
		return
		
	BulletpointItemContainer.show()
	for bulletpoint_data in data.bulletpoints:
		var new_bulletpoint:Control = BulletpointItemPreload.instantiate()
		new_bulletpoint.data = bulletpoint_data
		BulletpointItemContainer.add_child(new_bulletpoint)

# --------------------------------------		
