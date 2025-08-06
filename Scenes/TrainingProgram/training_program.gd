extends PanelContainer

@onready var LogoScreen:PanelContainer = $LogoScreen
@onready var TitleScreen:PanelContainer = $TitleScreen
@onready var FailState:PanelContainer = $FailState
@onready var TransitionScreen:Control = $TransitionScreen

const GameplayLoopPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/GameplayLoop.tscn")

# options
var fast_start:bool = false
var options:Dictionary = {} 

var after_setup_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.after_setup
var checkpoint_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.restore_checkpoint
var 	quicksave_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.quicksaves		

var has_after_setup:bool = !after_setup_data.is_empty()
var has_checkpoint_data:bool = !checkpoint_data.is_empty()
var has_quicksave_data:bool = !quicksave_data.is_empty()

# control
var GameplayLoopNode:Control

# signals
var onQuit:Callable = func() -> void:pass

# ---------------------------------------------
func _ready() -> void:
	pass
# ---------------------------------------------

# ---------------------------------------------
func start() -> void:	
	var story_progress:Dictionary = GBL.active_user_profile.story_progress
	var savedata:Dictionary = quicksave_data if !quicksave_data.is_empty() else {}

	# play music
	OS_AUDIO.play(OS_AUDIO.TRACK.GAME_TRACK_THREE, OS_AUDIO.CHANNEL.MAIN)

	# ... DEBUG, JUMP STRAIGHT TO GAME WITH MOST CURRENT QUICKSAVE, 
	if DEBUG.get_val(DEBUG.APP_SKIP_TITLESCREEN):
		if has_quicksave_data:
			GBL.loaded_gameplay_data = quicksave_data		
			start_game(quicksave_data)
			return
		if has_checkpoint_data:
			GBL.loaded_gameplay_data = checkpoint_data		
			start_game(checkpoint_data)
			return			
		if has_after_setup:
			GBL.loaded_gameplay_data = after_setup_data		
			start_game(after_setup_data)
			return	

		GBL.loaded_gameplay_data = {}		
		start_game({})
		return

	# start logo screen
	await transition_node(LogoScreen, true)			
	
	LogoScreen.start(fast_start)
	await LogoScreen.finished
	
	# start gamescreen
	TitleScreen.is_tutorial = options.is_tutorial if "is_tutorial" in options else false
	await TitleScreen.activate()
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
	# play music
	await OS_AUDIO.fade_out(OS_AUDIO.CHANNEL.MAIN, 1.0)
		
	GameplayLoopNode = GameplayLoopPreload.instantiate()
	
	var os_setting:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].os_setting
	var starting_data:Dictionary = OS_STORE.calc_starting_data()
		
	# set parameters
	GameplayLoopNode.options = options
	GameplayLoopNode.starting_data = starting_data
	
	# set events
	GameplayLoopNode.onGameOver = on_game_over	
	GameplayLoopNode.onExitGame = on_exit_game
	
	# set loaded data
	GBL.loaded_gameplay_data = filedata
		
	# fade out
	add_child(GameplayLoopNode)	
	transition_node(TitleScreen, false)		
	await transition_node(LogoScreen, false)	
	await U.set_timeout(0.3)
	
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
	GBL.find_node(REFS.AUDIO).fade_out(2.0)
	
	
	match action:
		"QUIT":
			onQuit.call()		

		"BACK_TO_TITLE": 
			transition_node(FailState, false)		
			await transition_node(TitleScreen, true)
					
		"START_NEW_GAME":
			GBL.active_user_profile.story_progress.on_chapter = 0
			GBL.update_and_save_user_profile()
			start_game({})
			
		"START_FROM_AFTER_SETUP":
			GBL.active_user_profile.story_progress.on_chapter = after_setup_data.on_chapter
			GBL.update_and_save_user_profile()
			start_game(after_setup_data)			
			
		"START_FROM_CHECKPOINT":
			GBL.active_user_profile.story_progress.on_chapter = checkpoint_data.on_chapter
			GBL.update_and_save_user_profile()
			start_game(checkpoint_data)
			
		"START_FROM_QUICKSAVE":
			GBL.active_user_profile.story_progress.on_chapter = quicksave_data.on_chapter
			GBL.update_and_save_user_profile()
			start_game(quicksave_data)


		
