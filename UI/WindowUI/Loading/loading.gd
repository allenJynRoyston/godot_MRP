@tool
extends PanelContainer

@onready var IconBtn:Control = $MarginContainer/CenterContainer/VBoxContainer/IconBtn
@onready var LoadingLabel:Label = $MarginContainer/CenterContainer/VBoxContainer/Label

signal on_complete

@export var delay:float = 0.7
@export var loading_text:String = "Loading..." : 
	set(val):
		loading_text = val
		on_loading_text_update()

func _ready() -> void:
	on_loading_text_update()

func on_loading_text_update() -> void:
	if is_node_ready():
		LoadingLabel.text = loading_text

func start(fast_boot:bool = false) -> void:
	if !fast_boot:
		await U.set_timeout(delay)
	hide()
	await U.set_timeout(0.2)
	on_complete.emit()
	queue_free()
