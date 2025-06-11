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
	
	
	var story_progress:Dictionary = GBL.active_user_profile.story_progress
	var quicksaves:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.quicksaves
	var has_savedata = false if quicksaves.is_empty() or story_progress.current_story_val not in quicksaves else true	
	var savedata:Dictionary = quicksaves[story_progress.current_story_val] if has_savedata else {}
	
	# ... DEBUG, JUMP STRAIGHT TO GAME WITH MOST CURRENT SAVE DATA, IF ONE DOESN'T EXIST LOADS EMPTY DATA
	if DEBUG.get_val(DEBUG.APP_SKIP_TITLESCREEN):
		GBL.loaded_gameplay_data = savedata		
		start_game(savedata)

	# start logo screen
	LogoScreen.show()
	LogoScreen.start(fast_start)
	await LogoScreen.finished
	
	# start gamescreen
	TitleScreen.is_tutorial = options.is_tutorial if "is_tutorial" in options else false
	TitleScreen.show()			
	TitleScreen.start(fast_start)
	var res:Dictionary = await TitleScreen.wait_for_input
	match res.action:
		"story":
			story_progress.current_story_val = 0
			GBL.update_and_save_user_profile(GBL.active_user_profile)
			start_game({})
		"continue":
			start_game(savedata)
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

	GBL.loaded_gameplay_data = filedata
	GameplayLoopNode.start()


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
