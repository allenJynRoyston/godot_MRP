extends PanelContainer

@onready var LogoScreen:PanelContainer = $LogoScreen
@onready var TitleScreen:PanelContainer = $TitleScreen

const GameplayLoopPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/GameplayLoop.tscn")

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

	var quickload_res:Dictionary = load_quickload()
	var has_quicksave:bool = false if DEBUG.get_val(DEBUG.NEW_QUICKSAVE_FILE) else quickload_res.success 
	var restore_data:Dictionary = quickload_res.filedata.data if has_quicksave else {}
	var no_save:bool = restore_data.is_empty() 
	if no_save:
		print("No QUICKSAVE available: creating new one.")	

	# skip and load the last game 
	if DEBUG.get_val(DEBUG.APP_SKIP_TITLESCREEN) and !load_first_game:
		load_first_game = true
		# same as continue OR if blank start a new game
		start_game(restore_data)
		return

	# start logo screen
	LogoScreen.show()
	LogoScreen.start(fast_start)
	await LogoScreen.finished
	
	# start gamescreen
	TitleScreen.completed_scenarios = completed_scenarios
	TitleScreen.disable_story = false
	TitleScreen.disable_scenario = false
	TitleScreen.has_quicksave = has_quicksave
	TitleScreen.quickload_data = quickload_res
	TitleScreen.start(fast_start)
	var res:Dictionary = await TitleScreen.wait_for_input
	match res.action:
		"story":
			start_game({}, 0)
		"scenario": 
			start_game({}, res.props.ref)
		"continue":
			start_game(restore_data, restore_data.scenario_ref)
		"quit":
			on_quit.emit()

	
func unpause() -> void:
	TitleScreen.BtnControls.on_item_index_update()		
	if GameplayLoopNode != null:
		pass
		#GameplayLoopNode.
# ---------------------------------------------


# ---------------------------------------------
func start_game(filedata:Dictionary, scenario_ref:int = 0) -> void:
	GameplayLoopNode = GameplayLoopPreload.instantiate()
	GameplayLoopNode.onEndGame = on_end_game	
	GameplayLoopNode.onExitGame = on_exit_game
	GameplayLoopNode.hide()
	add_child(GameplayLoopNode)
	
	# iterate through completed scenarios to build the awarded_rooms
	var awarded_rooms:Array = []
	for ref in completed_scenarios:
		var list:Array = SCENARIO_UTIL.get_awarded_rooms(ref)
		for room in list:
			if room not in awarded_rooms:
				awarded_rooms.push_back(room)
	
	# and add any that's in the current scenario:
	var list:Array = SCENARIO_UTIL.get_awarded_rooms(scenario_ref)
	for room in list:
		if room not in awarded_rooms:
			awarded_rooms.push_back(room)
			
	await U.tick()
	GameplayLoopNode.start({
		"filedata": filedata,
		"scenario_ref": scenario_ref,
		"awarded_rooms": awarded_rooms
	})
	
	LogoScreen.hide()
	TitleScreen.hide()


func on_exit_game(exit_game:bool) -> void:
	GameplayLoopNode.queue_free()
	await U.set_timeout(0.3)
	# quit game
	if exit_game:
		on_quit.emit()
		return
	# else, reset game
	start()		
	

func on_end_game(scenario_ref:int, scenario_data:Dictionary, win_state:bool) -> void:
	# if scenario win...
	if win_state:
		# remove quicksave
		FS.clear_file(FS.FILE.QUICK_SAVE)
		# calculate any rewards here...
		if scenario_ref not in completed_scenarios:
			completed_scenarios.push_back(scenario_ref)
		save_settings()
	# then clear
	GameplayLoopNode.queue_free()
	
	# restart
	await U.set_timeout(0.3)
	start()	
# ---------------------------------------------

# ---------------------------------------------
func load_quickload() -> Dictionary:
	return FS.load_file(FS.FILE.QUICK_SAVE)

func save_settings() -> Dictionary:
	var save_data:Dictionary = {
		"completed_scenarios": completed_scenarios
	}	
	FS.save_file(FS.FILE.PERSISTANT, save_data)
	return save_data

func load_settings() -> void:
	var res:Dictionary = FS.load_file(FS.FILE.PERSISTANT)
	var restore_data:Dictionary = res.filedata.data
	var no_save:bool = restore_data.is_empty() or DEBUG.get_val(DEBUG.NEW_PERSISTANT_FILE)
	if no_save:
		print("No PERSISTANT_FILE available: creating new one.")
		
	completed_scenarios = restore_data.completed_scenarios if !no_save else completed_scenarios
# ---------------------------------------------
