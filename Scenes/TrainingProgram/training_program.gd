extends PanelContainer

@onready var LogoScreen:PanelContainer = $LogoScreen
@onready var TitleScreen:PanelContainer = $TitleScreen

const GameplayLoopPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/GameplayLoop.tscn")

# 
@export var new_permanent_file:bool = false
@export var skip_title_screen:bool = true

#export 

@export_category("Gameplay Loop")
@export var new_quicksave_file:bool = false
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
	
	var quickload_res:Dictionary = load_quickload()
	var has_quicksave:bool = false if new_quicksave_file else quickload_res.success 
	var quicksave_filedata:Dictionary = quickload_res.filedata.data if has_quicksave else {}
	# skip and load the last game 
	if skip_title_screen and !load_first_game:
		load_first_game = true
		# same as continue
		start_game(quicksave_filedata)
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
			start_game(quicksave_filedata, quicksave_filedata.scenario_ref)
		"quit":
			on_quit.emit()

	
func unpause() -> void:
	TitleScreen.BtnControls.on_item_index_update()		
	if GameplayLoopNode != null:
		pass
		#GameplayLoopNode.
# ---------------------------------------------


# ---------------------------------------------
func start_game(filedata:Dictionary, scenario_ref:int = -1) -> void:
	GameplayLoopNode = GameplayLoopPreload.instantiate()
	GameplayLoopNode.onEndGame = on_end_game	
	GameplayLoopNode.onExitGame = on_exit_game
	GameplayLoopNode.skip_progress_screen = skip_progress_screen 
	GameplayLoopNode.debug_energy = debug_energy
	GameplayLoopNode.debug_personnel = debug_personnel
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
	if scenario_ref != -1:
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
	if exit_game:
		on_quit.emit()
		return
	
	GameplayLoopNode.queue_free()
	

func on_end_game(scenario_ref:int, scenario_data:Dictionary, endgame_state:bool) -> void:
	if endgame_state:
		# remove quicksave
		FS.clear_file(FS.FILE.QUICK_SAVE)
		# calculate any rewards here...
		if scenario_ref not in completed_scenarios:
			completed_scenarios.push_back(scenario_ref)
		save_settings()
		
	GameplayLoopNode.queue_free()
	await U.set_timeout(1.0)
	start()	
# ---------------------------------------------

# ---------------------------------------------
func load_quickload() -> Dictionary:
	var res:Dictionary = FS.load_file(FS.FILE.QUICK_SAVE)
	return res

func save_settings() -> Dictionary:
	var save_data:Dictionary = {
		"completed_scenarios": completed_scenarios
	}	
	FS.save_file(FS.FILE.PERMANENT_FILE, save_data)
	print("Saved permanent file!")
	return save_data

func load_settings() -> void:
	var res:Dictionary = FS.load_file(FS.FILE.PERMANENT_FILE)
	var filedata:Dictionary = save_settings() if (!res.success or new_permanent_file) else res.filedata.data

	# remap save properties
	completed_scenarios = filedata.completed_scenarios
# ---------------------------------------------
