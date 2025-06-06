extends PanelContainer

@onready var MousePointer:TextureRect = $Control/MousePointer
@onready var Output:TextureRect = $Control/Output

@onready var Gamelayer:SubViewport = $GameLayer
@onready var DoorScene:PanelContainer = $GameLayer/DoorScene
@onready var OSNode:PanelContainer = $GameLayer/OS

@onready var TitleSplash:PanelContainer = $GameLayer/TitleSplash
@onready var TransitionScreen:Control = $GameLayer/TransitionScreen

@onready var Camera3d:Camera3D = $"3dViewport/Node3D/Camera3D"

enum LAYER {DOOR_LAYER, OS_lAYER, GAMEPLAY_LAYER}

const mouse_cursor:CompressedTexture2D = preload("res://Media/mouse/icons8-select-cursor-24.png")
const mouse_busy:CompressedTexture2D = preload("res://Media/mouse/icons8-hourglass-24.png")
const mouse_pointer:CompressedTexture2D = preload("res://Media/mouse/icons8-click-24.png")

# GAMEPLAY OPTIONS
@export_category("DEBUG OPTIONS")
@export var is_production_build:bool = false
@export var start_at_fullscreen:bool = false

# DEFAULTS
@export_category("DEBUG SAVE FILES")
@export var new_progress_file:bool = false
@export var new_system_file:bool = false 
@export var new_persistant_file:bool = false
@export var new_quicksave_file:bool = false

@export_category("PROGRESS DEBUG")
@export var debug_story_progress:bool = false
@export var story_progress:int = 0

# SKIPS
@export_category("DEBUG START")
@export var skip_splash:bool = false
@export var skip_intro:bool = false 
@export var skip_office_intro:bool = false

# INTRODUCTION
@export_category("DEBUG INTRO SCREEN")
@export var intro_skip_logo:bool = false
@export var intro_skip_title:bool = false
@export var intro_skip_sequence:bool = false
@export var intro_skip_start_at:bool = false

# OS
@export_category("DEBUG OS")
@export var os_skip_boot:bool = false
@export var os_skip_to_game:bool = false
@export var os_app_fast_load:bool = false

# INTRODUCTION
@export_category("APP")
@export var app_skip_titlescreen:bool = false
@export var app_skip_loading_screen:bool = false

@export_category("DEBUG GAMEPLAYLOOP")
@export var skip_setup_progress:bool = false
@export var start_at_ring_level:bool = false
@export var skip_objectives:bool = false
@export var max_energy:bool = true
@export var all_personnel:bool = false
@export var researchers_per_room:int = 3
@export var researchers_by_default:int = 5

@export_category("RESEARCHERS DEBUG")
@export var xp_needed_for_promotion:int = 0

# DEFAULT RESOLUTION IS MAX WIDTH/HEIGHT
var resolution:Vector2i = DisplayServer.screen_get_size()
var is_animating:bool = false


var current_layer:LAYER : 
	set(val):
		current_layer = val
		on_current_layer_update()

# ------------------------------------------------------------------------------
# SETUP GAME RESOLUTION
func _init() -> void:
	if FileAccess.file_exists("user://config.json"):
		var file = FileAccess.open("user://config.json", FileAccess.READ)
		var result = JSON.parse_string(file.get_as_text())
		if result is Dictionary:
			resolution = Vector2(result.resolution_width, result.resolution_height)
	else:
		GBL.save_resolution(DisplayServer.screen_get_size())
	
	GBL.subscribe_to_process(self)
	GBL.register_node(REFS.OS_ROOT, self)	
	GBL.subscribe_to_control_input(self)	
	GBL.subscribe_to_mouse_icons(self)
# ------------------------------------------------------------------------------

# -----------------------------------	
func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)
	GBL.unregister_node(REFS.OS_ROOT)
	GBL.unregister_node(REFS.GAMELAYER_SUBVIEWPORT)
	GBL.unsubscribe_to_mouse_icons(self)
	GBL.unsubscribe_to_control_input(self)	
# -----------------------------------		

# -----------------------------------	
func _ready() -> void:
	
	GBL.register_node(REFS.GAMELAYER_SUBVIEWPORT, Gamelayer)
	# IS PRODUCTION
	DEBUG.assign(DEBUG.IS_PRODUCTION_BUILD, is_production_build)		
	
	# options
	DEBUG.assign(DEBUG.START_AT_FULLSCREEN, start_at_fullscreen)
	
	# save files
	DEBUG.assign(DEBUG.NEW_PROGRESS_FILE, new_progress_file)	
	DEBUG.assign(DEBUG.NEW_SYSTEM_FILE, new_system_file)
	DEBUG.assign(DEBUG.NEW_PERSISTANT_FILE, new_persistant_file)
	DEBUG.assign(DEBUG.NEW_QUICKSAVE_FILE, new_quicksave_file)

	# progress 
	DEBUG.assign(DEBUG.DEBUG_STORY_PROGRESS, debug_story_progress)
	DEBUG.assign(DEBUG.STORY_PROGRESS_VAL, story_progress)

	# skips
	DEBUG.assign(DEBUG.SKIP_SPLASH, skip_splash)	
	DEBUG.assign(DEBUG.SKIP_INTRO, skip_intro)
	DEBUG.assign(DEBUG.SKIP_OFFICE_INTRO, skip_office_intro)
	
	# intro
	DEBUG.assign(DEBUG.INTRO_SKIP_LOGO, intro_skip_logo)
	DEBUG.assign(DEBUG.INTRO_SKIP_TITLE, intro_skip_title)	
	DEBUG.assign(DEBUG.INTRO_SKIP_SEQUENCE, intro_skip_sequence)
	DEBUG.assign(DEBUG.INTRO_SKIP_STARTAT, intro_skip_start_at)
	
	# os
	DEBUG.assign(DEBUG.OS_SKIP_TO_GAME, os_skip_to_game)	
	DEBUG.assign(DEBUG.OS_SKIP_BOOT, os_skip_boot)
	DEBUG.assign(DEBUG.OS_APP_FAST_LOAD, os_app_fast_load)
	
	# app
	DEBUG.assign(DEBUG.APP_SKIP_LOADING_SCREEN, app_skip_titlescreen)	
	DEBUG.assign(DEBUG.APP_SKIP_TITLESCREEN, app_skip_loading_screen)	
	
	# gameplayloop
	DEBUG.assign(DEBUG.GAMEPLAY_SKIP_SETUP_PROGRSS, skip_setup_progress)	
	DEBUG.assign(DEBUG.GAMEPLAY_START_AT_RING_LEVEL, start_at_ring_level)	
	DEBUG.assign(DEBUG.GAMEPLAY_SKIP_OBJECTIVES, skip_objectives)
	DEBUG.assign(DEBUG.GAMEPLAY_MAX_ENERGY, max_energy)
	DEBUG.assign(DEBUG.GAMEPLAY_ALL_PERSONNEL, all_personnel)	
	DEBUG.assign(DEBUG.GAMEPLAY_RESEARCHERS_PER_ROOM, researchers_per_room if !is_production_build else 1)
	DEBUG.assign(DEBUG.GAMEPLAY_RESEARCHERS_BY_DEFAULT, researchers_by_default if !is_production_build else 0)
	
	# researchers
	DEBUG.assign(DEBUG.RESEARCHER_XP_REQUIRED_FOR_PROMOTION, xp_needed_for_promotion if !is_production_build else 10)	
	

	DoorScene.onLogin = func() -> void:
		start_os_layer()
	
	OSNode.onBack = func() -> void:
		current_layer = LAYER.DOOR_LAYER
	
	#if !Engine.is_editor_hint():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	MousePointer.hide()


	if start_at_fullscreen:
		on_fullscreen_update(resolution)
		toggle_fullscreen()
	else:		
		on_fullscreen_update(Vector2(1280, 720))	
	
	
	await TitleSplash.start(0.2 if DEBUG.get_val(DEBUG.SKIP_SPLASH) else 3.0)
	
	reset()
# -----------------------------------	

# -----------------------------------	
func reset() -> void:
	if !DEBUG.get_val(DEBUG.SKIP_INTRO):
		await play_door()	
	else:
		current_layer = LAYER.DOOR_LAYER	
		await U.tick()
		DoorScene.fastfoward()
		await U.tick()
		if skip_office_intro:
			start_os_layer()
# -----------------------------------		

# -----------------------------------		
func play_door() -> void:
	current_layer = LAYER.DOOR_LAYER	
	await U.tick()
	DoorScene.start()
# -----------------------------------			

# -----------------------------------		
func start_os_layer() -> void:
	current_layer = LAYER.OS_lAYER		

	if !OSNode.has_started:
		OSNode.start()	
	else:
		OSNode.resume()
		
	await U.tick()
	OSNode.show()
# -----------------------------------

# -----------------------------------	
func on_mouse_icon_update(mouse_icon:GBL.MOUSE_ICON) -> void:
	if is_node_ready():
		match mouse_icon:
			GBL.MOUSE_ICON.CURSOR:
				MousePointer.texture = mouse_cursor
			GBL.MOUSE_ICON.BUSY:
				MousePointer.texture = mouse_busy
			GBL.MOUSE_ICON.POINTER:
				MousePointer.texture = mouse_pointer
# -----------------------------------	

# -----------------------------------
func get_max_resolution():
	var display_index = DisplayServer.window_get_current_screen()
	return DisplayServer.screen_get_size(display_index)
# -----------------------------------

# -----------------------------------	
func toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		on_fullscreen_update(Vector2(1280, 720))
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)	
		on_fullscreen_update( get_max_resolution() )
# -----------------------------------	

# -----------------------------------	
func on_fullscreen_update(use_resolution:Vector2i) -> void:
	for node in get_children():
		if node is SubViewport:
			node.size = use_resolution	

	# start children nodes
	var screen_size = DisplayServer.screen_get_size()
	var window_position = (screen_size - use_resolution) / 2
	DisplayServer.window_set_size(use_resolution)
	DisplayServer.window_set_position(window_position, DisplayServer.get_primary_screen())			
	
	GBL.trigger_fullscreen_prechange()
	await U.tick()
	
	# set as reference
	GBL.game_resolution = use_resolution
	
	match DisplayServer.window_get_mode():
		DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			Output.stretch_mode = TextureRect.STRETCH_SCALE
			Output.size = screen_size
			Output.custom_minimum_size = screen_size
			GBL.update_fullscreen_mode(true)
		DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
			Output.stretch_mode = TextureRect.STRETCH_KEEP
			GBL.update_fullscreen_mode(false)
			
		
	var fov_val:float = 46.6

	if use_resolution.x == 1280:
		fov_val = 32.0
	if use_resolution.x == 1920:
		fov_val = 46.6
	Camera3d.fov = fov_val + 1
	
	is_animating = true
	await U.tween_node_property(Camera3d, "fov", fov_val, 0.3, 0, Tween.TRANS_SPRING)			
	is_animating = false
# -----------------------------------	

# -----------------------------------
func on_current_layer_update() -> void:
	if !is_node_ready():return
	#TransitionScreen.start()
	
	match current_layer:
		# -----------
		LAYER.DOOR_LAYER:
			for node in [DoorScene, OSNode]:
				if node == DoorScene:
					node.show()
					node.set_process(true)
					node.set_physics_process(true)
					node.switch_to()
				else: 
					node.hide()
					node.set_process(false)
					node.set_physics_process(false)
		# -----------
		LAYER.OS_lAYER:
			for node in [DoorScene, OSNode]:
				if node == OSNode:
					node.show() 
					node.set_process(true)
					node.set_physics_process(true)
				else: 
					node.hide()		
					node.set_process(false)
					node.set_physics_process(false)	
# -----------------------------------	

# -----------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or is_animating:return
	var key:String = input_data.key
	#match key:
		#"R":
			#reset()
		#"F":
			#toggle_fullscreen()
# -----------------------------------		
	
# -----------------------------------	
func on_process_update(delta: float) -> void:
	var mouse_pos:Vector2 = get_global_mouse_position()
	GBL.mouse_pos = mouse_pos
	MousePointer.position = mouse_pos - Vector2(4, 0)
# -----------------------------------	
