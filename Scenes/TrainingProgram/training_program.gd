extends PanelContainer

@onready var LogoScreen:PanelContainer = $LogoScreen
@onready var TitleScreen:PanelContainer = $TitleScreen

const GameplayLoopPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/GameplayLoop.tscn")

# 
@export var new_save_file:bool = false
@export var skip_title_screen:bool = true

@export_category("Gameplay Loop")
@export var debug_mode:bool = false
@export var skip_progress_screen:bool = false
@export var debug_energy:bool = true
@export var debug_personnel:bool = false


# options
var fast_start:bool = false
var skip_main_menu:bool = false
var load_first_game:bool = false

# completed scenarios
var completed_scenarios:Array = []

# control
var GameplayLoopNode:Control

# signals
signal on_quit

# ---------------------------------------------
func _ready() -> void:
	hide()
	load_settings()
# ---------------------------------------------

# ---------------------------------------------
func start() -> void:	
	show()
	
	# skip and load the last game 
	if skip_title_screen and !load_first_game:
		load_first_game = true
		# TODO change out 0 for saved scenario ref
		start_new_game(-1, true)
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
			start_new_game(res.props.ref, false)
		"continue":
			start_new_game(0, true)
		"load":
			pass
		"quit":
			on_quit.emit()
# ---------------------------------------------

# ---------------------------------------------
func start_new_game(scenario_ref:int, continue_last_save:bool = false) -> void:
	GameplayLoopNode = GameplayLoopPreload.instantiate()
	GameplayLoopNode.onEndGame = on_end_game	
	GameplayLoopNode.debug_mode = debug_mode
	GameplayLoopNode.skip_progress_screen = skip_progress_screen 
	GameplayLoopNode.debug_energy = debug_energy
	GameplayLoopNode.debug_personnel = debug_personnel
	GameplayLoopNode.hide()
	add_child(GameplayLoopNode)
	
	await U.tick()
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
# ---------------------------------------------

# ---------------------------------------------
func save_settings() -> Dictionary:
	var save_data:Dictionary = {
		"completed_scenarios": completed_scenarios
	}	
	FS.save_file(FS.FILE.PERMANENT_FILE, save_data)
	return save_data

func load_settings() -> void:
	var res:Dictionary = FS.load_file(FS.FILE.PERMANENT_FILE)
	var filedata:Dictionary = save_settings() if !res.success or new_save_file else res.filedata

	# remap save properties
	completed_scenarios = filedata.data.completed_scenarios
# ---------------------------------------------
