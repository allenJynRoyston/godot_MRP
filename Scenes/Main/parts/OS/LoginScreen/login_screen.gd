extends PanelContainer

signal is_complete


func start() -> void:
	show()
	await U.set_timeout(2.0)
	end()
	
func end() -> void:
	hide()
	await U.tick()
	is_complete.emit()
