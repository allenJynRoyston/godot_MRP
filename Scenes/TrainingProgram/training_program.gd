extends PanelContainer

@onready var LogoScreen:PanelContainer = $LogoScreen
@onready var TitleScreen:PanelContainer = $TitleScreen

const GameplayLoopPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/GameplayLoop.tscn")

var fast_start:bool = false

var skip_to_new_game:bool = true
var skip_main_menu:bool = false
var load_first_game:bool = false

var GameplayLoopNode:Control

signal on_quit

func _ready() -> void:
	hide()

# Called when the node enters the scene tree for the first time.
func start() -> void:	
	show()
	
	# skip and load the last game 
	if skip_to_new_game and !load_first_game:
		load_first_game = true
		# TODO change out 0 for saved scenario ref
		start_new_game(0, true)
		return

	# start logo screen
	LogoScreen.start(fast_start)
	await LogoScreen.finished
	
	# start gamescreen
	TitleScreen.start(fast_start)
	var res:Dictionary = await TitleScreen.wait_for_input
	match res.action:
		"new_game":
			start_new_game(0, false)
		"scenario": 
			start_new_game(0, false)
		"continue":
			start_new_game(0, true)
		"load":
			pass
		"quit":
			on_quit.emit()
				
		
func start_new_game(scenario_ref:int, continue_last_save:bool = false) -> void:
	GameplayLoopNode = GameplayLoopPreload.instantiate()
	GameplayLoopNode.hide()
	add_child(GameplayLoopNode)
	await U.tick()
	GameplayLoopNode.onEndGame = on_end_game
	GameplayLoopNode.start({
		"continue": continue_last_save,
		"scenario_ref": scenario_ref,
	})


func on_end_game(scenario_data:Dictionary, endgame_state:bool) -> void:
	# calculate any rewards here...
	print('calculate and rewards...')
	await U.set_timeout(1.0)
	print("continue...")
	GameplayLoopNode.queue_free()
	start()	
