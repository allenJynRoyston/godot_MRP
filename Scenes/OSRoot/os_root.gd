extends PanelContainer

@onready var MousePointer:TextureRect = $Control/MousePointer
@onready var Output:TextureRect = $Control/Output

@onready var Background:TextureRect = $GameLayer/BG
@onready var DoorScene:PanelContainer = $GameLayer/DoorScene
@onready var OSNode:PanelContainer = $GameLayer/OS


@onready var Camera3d:Camera3D = $"3dViewport/Node3D/Camera3D"

enum LAYER {STARTUP, INTRO_LAYER, DOOR_LAYER, OS_lAYER, GAMEPLAY_LAYER}

const mouse_cursor:CompressedTexture2D = preload("res://Media/mouse/icons8-select-cursor-24.png")
const mouse_busy:CompressedTexture2D = preload("res://Media/mouse/icons8-hourglass-24.png")
const mouse_pointer:CompressedTexture2D = preload("res://Media/mouse/icons8-click-24.png")

# DEFAULTS
@export var skip_intro:bool = false 

# DEFAULT RESOLUTION IS MAX WIDTH/HEIGHT
var resolution:Vector2i = DisplayServer.screen_get_size()
var is_animating:bool = false


var current_layer:LAYER = LAYER.STARTUP : 
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
	GBL.unsubscribe_to_mouse_icons(self)
	GBL.unsubscribe_to_control_input(self)	
# -----------------------------------		

# -----------------------------------	
func _ready() -> void:
	Background.hide()
	
	if !Engine.is_editor_hint():
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# ENABLE FOR DESKTOP PC 
	# start full screen
	on_fullscreen_update(resolution)
	toggle_fullscreen()
	
	# start at debug	
	#on_fullscreen_update(Vector2(1280, 720))	
	#on_current_layer_update()
	
	reset()
	
	DoorScene.on_login = func():
		start_os_layer()		
# -----------------------------------	

# -----------------------------------	
func reset() -> void:
	await U.set_timeout(1.2)
	if !skip_intro:
		await play_door()	
	else:
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
	await U.tick()
	for node in [OSNode]:
		node.visible = true
		node.set_process(true)
		node.set_physics_process(true)
		node.start()
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
			
		
	var fov_val:float = 0
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
	match current_layer:
		# -----------
		LAYER.STARTUP:
			print("startup")
			for node in [DoorScene, OSNode, Background]:
				node.hide()
		# -----------
		LAYER.DOOR_LAYER:
			print("door")
			for node in [DoorScene, OSNode, Background]:
				if node == DoorScene:
					node.show()
				else: 
					node.hide()
		# -----------
		LAYER.OS_lAYER:
			for node in [DoorScene, OSNode, Background]:
				if node == OSNode or node == Background:
					node.show() 
				else: 
					node.hide()		
# -----------------------------------	

# -----------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or is_animating:return
	var key:String = input_data.key
	match key:
		"R":
			reset()
		"F":
			toggle_fullscreen()
# -----------------------------------		
	
# -----------------------------------	
func on_process_update(delta: float) -> void:
	var mouse_pos:Vector2 = get_global_mouse_position()
	GBL.mouse_pos = mouse_pos
	MousePointer.position = mouse_pos - Vector2(4, 0)
# -----------------------------------	
