extends PanelContainer

@onready var LogoScreen:PanelContainer = $LogoScreen
@onready var TitleScreen:PanelContainer = $TitleScreen
@onready var GameplayLoop:PanelContainer = $GameplayLoop

var fast_start:bool = false

var skip_to_new_game:bool = true

signal on_quit

func _ready() -> void:
	hide()

# Called when the node enters the scene tree for the first time.
func start() -> void:	
	show()
	if skip_to_new_game:
		start_new_game()
		return
	
	LogoScreen.start(fast_start)
	await LogoScreen.finished
	TitleScreen.start(fast_start)
	var res:Dictionary = await TitleScreen.wait_for_input
	TitleScreen.hide()
	match res.action:
		"new_game":
			start_new_game()
		"continue":
			pass
		"load":
			pass
		"quit":
			on_quit.emit()
				
		
func start_new_game() -> void:
	GameplayLoop.start({})
