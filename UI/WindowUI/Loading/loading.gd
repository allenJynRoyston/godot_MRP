extends PanelContainer

@onready var LoadingLabel:Label = $MarginContainer/VBoxContainer/LoadingVBox/Label
@onready var LoadingvBox:VBoxContainer = $MarginContainer/VBoxContainer/LoadingVBox

@export var loading_text:String = "Loading..." : 
	set(val):
		loading_text = val
		on_loading_text_update()
		
func _ready() -> void:
	on_loading_text_update()
	LoadingvBox.modulate = Color(1, 1, 1, 0)
	
func start(fast:bool) -> void:
	await U.set_timeout(0.3)
	LoadingvBox.modulate = Color(1, 1, 1, 1)
	await U.set_timeout(1.0 if fast else 2.0)
	LoadingvBox.modulate = Color(1, 1, 1, 0)
	await U.set_timeout(0.3)
	queue_free()	

func on_loading_text_update() -> void:
	if !is_node_ready():return
	LoadingLabel.text = loading_text
	
