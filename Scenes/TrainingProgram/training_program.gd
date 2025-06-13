extends PanelContainer

@onready var LogoScreen:PanelContainer = $LogoScreen
@onready var TitleScreen:PanelContainer = $TitleScreen
@onready var WinConditionScreen:PanelContainer = $WinConditionScreen
@onready var TransitionScreen:Control = $TransitionScreen

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
	for node in [LogoScreen, TitleScreen, WinConditionScreen]:
		node.modulate = Color(1, 1, 1, 0)
		node.hide()
# ---------------------------------------------

# ---------------------------------------------
func start() -> void:	
	var story_progress:Dictionary = GBL.active_user_profile.story_progress
	var quicksaves:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.quicksaves
	var has_savedata = false if quicksaves.is_empty() or story_progress.current_story_val not in quicksaves else true	
	var savedata:Dictionary = quicksaves[story_progress.current_story_val] if has_savedata else {}
	
	# ... DEBUG, JUMP STRAIGHT TO GAME WITH MOST CURRENT SAVE DATA, IF ONE DOESN'T EXIST LOADS EMPTY DATA
	if DEBUG.get_val(DEBUG.APP_SKIP_TITLESCREEN):
		GBL.loaded_gameplay_data = savedata		
		start_game(savedata)
		return

	# start logo screen
	await transition_node(LogoScreen, true)			
	
	LogoScreen.start(fast_start)
	await LogoScreen.finished
	
	# start gamescreen
	TitleScreen.is_tutorial = options.is_tutorial if "is_tutorial" in options else false
	TitleScreen.show()			
	TitleScreen.start(fast_start)
	await transition_node(TitleScreen, true)			
	
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
	GameplayLoopNode.onGameOver = on_game_over	
	GameplayLoopNode.onExitGame = on_exit_game
	
	GBL.loaded_gameplay_data = filedata
		
	# fade out
	transition_node(TitleScreen, false)		
	await transition_node(LogoScreen, false)	
	
	add_child(GameplayLoopNode)
	GameplayLoopNode.start()	


func transition_node(node:Control, fade_in:bool, duration:float = 1.0) -> void:
	if fade_in:
		node.show()
			
	U.tween_node_property(node, "modulate", Color(1, 1, 1, 1 if fade_in else 0), duration)
	
	TransitionScreen.show()
	await TransitionScreen.start()
	TransitionScreen.hide()
	
	if !fade_in:
		node.hide()


func on_exit_game(exit_game:bool) -> void:
	await transition_node(GameplayLoopNode, 1.0)
	GameplayLoopNode.queue_free()

	# quit game
	if exit_game:
		on_quit.emit()
		return
	# else, reset game
	start()		


func on_game_over() -> void:
	# then clear
	await transition_node(GameplayLoopNode, 1.0)
	GameplayLoopNode.queue_free()
	
	# set win condition screen
	WinConditionScreen.modulate = Color(1, 1, 1, 0)
	WinConditionScreen.show()
			
	# show win condition and start
	await transition_node(WinConditionScreen, 1.0)
	
	WinConditionScreen.start()
	var action:String = await WinConditionScreen.wait_for_response
	
	await transition_node(WinConditionScreen, 0)
	
	match action:
		"RETRY":
			var story_progress:Dictionary = GBL.active_user_profile.story_progress
			var checkpoint:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.restore_checkpoint
			start_game({} if checkpoint.is_empty() else checkpoint)
		"RESTART": 
			start_game({})
		"QUIT":
			on_quit.emit()
# ---------------------------------------------
