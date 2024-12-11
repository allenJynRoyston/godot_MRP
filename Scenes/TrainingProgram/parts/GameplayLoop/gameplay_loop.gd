extends PanelContainer

func _ready() -> void:
	hide()
	set_process(false)
	set_physics_process(false)	
	
func start(game_data:Dictionary = {}) -> void:
	show()
	set_process(true)
	set_physics_process(true)	
	
	if game_data.is_empty():
		start_new_game()
	else:
		restore_game()

func start_new_game() -> void:
	print('new')

func restore_game() -> void:
	print('restore')
