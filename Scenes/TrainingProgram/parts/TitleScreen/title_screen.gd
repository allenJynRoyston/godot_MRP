extends PanelContainer

signal wait_for_input

@export var delay:float = 0.7

func _ready() -> void:
	hide()

func start(fast_boot:bool = false) -> void:
	show()
	if !fast_boot:
		await U.set_timeout(delay)
	hide()
	await U.set_timeout(0.2)
	hide()
