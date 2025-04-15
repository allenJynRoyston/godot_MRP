@tool
extends PanelContainer

@onready var IconBtn:Control = $MarginContainer/CenterContainer/VBoxContainer/IconBtn
@onready var LoadingLabel:Label = $MarginContainer/CenterContainer/VBoxContainer/Label

signal on_complete

var delay:float = 2.0
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
	show()
	if !fast_boot:
		await U.set_timeout(delay)
	hide()
	await U.set_timeout(0.3)
	on_complete.emit()
