extends PanelContainer

@onready var OSNode:PanelContainer = $GameLayer/OS
@onready var MousePointer:TextureRect = $Control/MousePointer
@onready var Output:TextureRect = $Control/Output
@onready var IntroAndTitleScreen:PanelContainer = $GameLayer/IntroAndTitleScreen
@onready var Camera3d:Camera3D = $"3dViewport/Node3D/Camera3D"


const mouse_cursor:CompressedTexture2D = preload("res://Media/mouse/icons8-select-cursor-24.png")
const mouse_busy:CompressedTexture2D = preload("res://Media/mouse/icons8-hourglass-24.png")
const mouse_pointer:CompressedTexture2D = preload("res://Media/mouse/icons8-click-24.png")

# DEFAULT RESOLUTION IS MAX WIDTH/HEIGHT
var resolution:Vector2i = DisplayServer.screen_get_size()
var is_animating:bool = false


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
	if !Engine.is_editor_hint():
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# ENABLE FOR DESKTOP PC 
	on_fullscreen_update(resolution)
	#print("resolution: ", resolution)

	# ENABLE FOR MACBOOK 
	#on_fullscreen_update(Vector2(1280, 720))
	reset()
# -----------------------------------	

# -----------------------------------	
func reset() -> void:
	await play_intro()
	start_gameplay()
# -----------------------------------		

# -----------------------------------		
func play_intro() -> void:
	IntroAndTitleScreen.start()
	await IntroAndTitleScreen.on_finish
	await U.set_timeout(0.3)
# -----------------------------------		

# -----------------------------------		
func start_gameplay() -> void:
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
		on_fullscreen_update(resolution)
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
