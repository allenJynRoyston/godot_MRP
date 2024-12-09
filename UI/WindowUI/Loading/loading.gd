extends PanelContainer

signal on_complete

@export var delay:float = 0.7

func start() -> void:
	await U.set_timeout(delay)
	on_complete.emit()
	queue_free()
