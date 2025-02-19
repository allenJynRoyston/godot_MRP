extends PanelContainer

@onready var ListContainer:VBoxContainer = $MarginContainer/ListContainer

const ToastItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ToastContainer/parts/ToastItem.tscn")

func add(content:String) -> void:
	var new_toast:Control = ToastItemPreload.instantiate()
	new_toast.content = content
	ListContainer.add_child(new_toast)
