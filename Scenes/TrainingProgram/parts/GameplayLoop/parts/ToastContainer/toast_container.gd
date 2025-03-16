extends GameContainer

@onready var ListContainer:VBoxContainer = $MarginContainer/ListContainer

const ToastItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ToastContainer/parts/ToastItem.tscn")

func _init() -> void:
	super._init()
	GBL.register_node(REFS.ACTION_CONTAINER, self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.ACTION_CONTAINER)
	
func _ready() -> void:
	super._ready()

func add(content:String) -> void:
	var new_toast:Control = ToastItemPreload.instantiate()
	new_toast.content = content
	ListContainer.add_child(new_toast)
