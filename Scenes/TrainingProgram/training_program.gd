extends PanelContainer

@onready var LogoScreen:PanelContainer = $LogoScreen
@onready var TitleScreen:PanelContainer = $TitleScreen

const GameplayLoopPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/GameplayLoop.tscn")

# options
var fast_start:bool = false
var options:Dictionary = {} 

# control
var GameplayLoopNode:Control

# signals
signal on_quit

# ---------------------------------------------
func _ready() -> void:
	hide()
# ---------------------------------------------

# ---------------------------------------------
func start() -> void:	
	show()
	
	# check if quicksave files exists
	var quickload_res:Dictionary = FS.load_file(FS.FILE.QUICK_SAVE)
	var has_quicksave:bool = false if DEBUG.get_val(DEBUG.NEW_QUICKSAVE_FILE) else quickload_res.success 
	var restore_data:Dictionary = quickload_res.filedata.data if has_quicksave else {}

	# ... if it does, and skip exists, 
	if DEBUG.get_val(DEBUG.APP_SKIP_TITLESCREEN):
		# same as continue OR if blank start a new game
		start_game(restore_data)
		return

	# start logo screen
	LogoScreen.show()
	LogoScreen.start(fast_start)
	await LogoScreen.finished
	
	# start gamescreen
	TitleScreen.is_tutorial = options.is_tutorial if "is_tutorial" in options else false
	TitleScreen.start(fast_start)
	var res:Dictionary = await TitleScreen.wait_for_input
	match res.action:
		"story":
			start_game({})
		"continue":
			start_game(restore_data)
		"quit":
			on_quit.emit()

func pause() -> void:
	hide()
	
func unpause() -> void:
	await U.set_timeout(0.3)
	show()

func force_save_and_quit() -> void:
	if GameplayLoopNode != null:
		await GameplayLoopNode.quicksave()
	else:
		await U.tick()
# ---------------------------------------------


# ---------------------------------------------
func start_game(filedata:Dictionary) -> void:
	GameplayLoopNode = GameplayLoopPreload.instantiate()
	GameplayLoopNode.options = options
	GameplayLoopNode.onEndGame = on_end_game	
	GameplayLoopNode.onExitGame = on_exit_game
	GameplayLoopNode.hide()
	LogoScreen.hide()
	TitleScreen.hide()
		
	add_child(GameplayLoopNode)
	await U.tick()

	GameplayLoopNode.start({ "filedata": filedata })


func on_exit_game(exit_game:bool) -> void:
	GameplayLoopNode.queue_free()
	await U.set_timeout(0.3)
	# quit game
	if exit_game:
		on_quit.emit()
		return
	# else, reset game
	start()		
	

func on_end_game(win_state:bool, save_data:Dictionary = {}) -> void:
	# if scenario win...
	if win_state:
		await update_progress(save_data)
		
	# then clear
	GameplayLoopNode.queue_free()
	
	# restart
	await U.set_timeout(0.3)
	start()
# ---------------------------------------------

# ---------------------------------------------
func update_progress(quicksave:Dictionary) -> void:
	var progress_data:Dictionary = FS.load_file(FS.FILE.PROGRESS).filedata.data
	
	# update story progress val
	progress_data.story_progress_val += 1
	# then update progress data
	FS.save_file(FS.FILE.PROGRESS, progress_data)
	
	await U.tick()
# ---------------------------------------------
