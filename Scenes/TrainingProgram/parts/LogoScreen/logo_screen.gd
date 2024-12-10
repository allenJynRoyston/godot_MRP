extends PanelContainer

signal finished

@export var delay:float = 0.7

func _ready() -> void:
	hide()

func start(fast_boot:bool = false) -> void:
	show()
	if !fast_boot:
		await U.set_timeout(delay)
	hide()
	await U.set_timeout(0.2)
	finished.emit()
	hide()
