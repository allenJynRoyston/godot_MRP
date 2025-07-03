extends PanelContainer

@onready var LogoScreen:PanelContainer = $LogoScreen
@onready var TitleScreen:PanelContainer = $TitleScreen
@onready var FailState:PanelContainer = $FailState
@onready var TransitionScreen:Control = $TransitionScreen

const GameplayLoopPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/GameplayLoop.tscn")

# options
var fast_start:bool = false
var options:Dictionary = {} 

var after_setup_data:Dictionary 
var checkpoint_data:Dictionary 
var 	quicksave_data:Dictionary


# control
var GameplayLoopNode:Control

# signals
var onQuit:Callable = func() -> void:pass

# ---------------------------------------------
func _ready() -> void:
	for node in [LogoScreen, TitleScreen, FailState]:
		node.modulate = Color(1, 1, 1, 0)
		node.hide()
		
	after_setup_data = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.after_setup
	checkpoint_data = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.restore_checkpoint
	quicksave_data = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.quicksaves			
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
	execute_action(res.action)
	

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
		onQuit.call()
		return
	# else, reset game
	start()		


func on_game_over() -> void:
	# then clear
	await transition_node(GameplayLoopNode, 1.0)
	GameplayLoopNode.queue_free()
	
	# set win condition screen
	FailState.modulate = Color(1, 1, 1, 0)
	FailState.show()
			
	# show win condition and start
	await transition_node(FailState, 1.0)
	
	FailState.start()
	var action:String = await FailState.wait_for_response
	
	await transition_node(FailState, 0)
#	
	execute_action(action)
# ---------------------------------------------


func execute_action(action:String) -> void:
	var story_progress:Dictionary = GBL.active_user_profile.story_progress
	
	match action:
		"START_NEW_GAME":
			GBL.active_user_profile.story_progress.current_story_val = 0
			GBL.loaded_gameplay_data = {}
			GBL.update_and_save_user_profile(GBL.active_user_profile)
			start_game({})
			
		"START_FROM_CHECKPOINT":
			GBL.active_user_profile.story_progress.current_story_val = checkpoint_data.current_story_val
			GBL.loaded_gameplay_data = checkpoint_data
			GBL.update_and_save_user_profile(GBL.active_user_profile)
			start_game(checkpoint_data)
			
		"START_FROM_QUICKSAVE":
			GBL.active_user_profile.story_progress.current_story_val = quicksave_data.current_story_val
			GBL.loaded_gameplay_data = quicksave_data
			GBL.update_and_save_user_profile(GBL.active_user_profile)
			start_game(quicksave_data)
			
		"START_FROM_AFTER_SETUP":
			GBL.active_user_profile.story_progress.current_story_val = after_setup_data.current_story_val
			GBL.loaded_gameplay_data = after_setup_data
			GBL.update_and_save_user_profile(GBL.active_user_profile)
			start_game(after_setup_data)

		"QUIT":
			onQuit.call()		

		"BACK_TO_TITLE": 
			transition_node(FailState, false)		
			await transition_node(TitleScreen, true)
		
