extends PanelContainer

@onready var OSNode:PanelContainer = $GameLayer/OS
@onready var MousePointer:TextureRect = $GameLayer/MousePointer
@onready var FinalComposite:TextureRect = $Control/FinalComposite

const mouse_cursor:CompressedTexture2D = preload("res://Media/mouse/icons8-select-cursor-24.png")
const mouse_busy:CompressedTexture2D = preload("res://Media/mouse/icons8-hourglass-24.png")
const mouse_pointer:CompressedTexture2D = preload("res://Media/mouse/icons8-click-24.png")

# DEFAULT RESOLUTION IS MAX WIDTH/HEIGHT
var resolution:Vector2i = DisplayServer.screen_get_size()

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
	
	#on_fullscreen_update(resolution)
	# ENABLE FOR MACBOOK 
	#on_fullscreen_update(Vector2(1280, 720))
	
	
	toggle_fullscreen()

	activate_children.call_deferred()
# -----------------------------------		

# -----------------------------------	
func activate_children() -> void:
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
func toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		on_fullscreen_update(resolution * .75)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)	
		on_fullscreen_update(resolution)
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
			FinalComposite.stretch_mode = TextureRect.STRETCH_SCALE
			FinalComposite.size = screen_size
			FinalComposite.custom_minimum_size = screen_size
			GBL.update_fullscreen_mode(true)
		DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
			FinalComposite.stretch_mode = TextureRect.STRETCH_KEEP
			GBL.update_fullscreen_mode(false)
# -----------------------------------	

# -----------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	var key:String = input_data.key
	match key:
		"F":
			toggle_fullscreen()
# -----------------------------------		
	
# -----------------------------------	
func on_process_update(delta: float) -> void:
	var mouse_pos:Vector2 = get_global_mouse_position()
	GBL.mouse_pos = mouse_pos
	MousePointer.position = mouse_pos - Vector2(4, 0)
# -----------------------------------	
