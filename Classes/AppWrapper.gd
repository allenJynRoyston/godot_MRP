extends PanelContainer
class_name AppWrapper 

var onClick:Callable = func(node:Control, window_node:Control, btn:int, is_hover:bool) -> void:pass
var onClickRelease:Callable = func(node:Control, window_node:Control, btn:int, is_hover:bool) -> void:pass
var onCloseBtn:Callable = func(node:Control, window_node:Control) -> void:pass
var onMaxBtn:Callable = func(node:Control, window_node:Control) -> void:pass	
var onDragStart:Callable = func(node:Control, window_node:Control) -> void:pass
var onDragEnd:Callable = func(new_offset:Vector2, node:Control, window_node:Control) -> void:pass		
var onFocus:Callable = func(node:Control, window_node:Control) -> void:pass
var onBlur:Callable = func(node:Control, window_node:Control) -> void:pass

var WindowUI:PanelContainer 
var app_props:Dictionary = {}
var app_events:Dictionary = {}
var offset:Vector2 = Vector2(0, 0)
var default_size:Vector2 
var in_fullscreen:bool = false
var fast_load:bool = false

var default_setup:Dictionary = {}
var is_windows:bool = DisplayServer.get_name() == "Windows"

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_fullscreen(self)
	
func _exit_tree() -> void:
	GBL.unsubscribe_to_fullscreen(self)
	
func _ready() -> void:		
	after_ready.call_deferred()
	default_size = WindowUI.size
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func after_ready():
	resize()
	bind_events()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	resize()
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
func on_minification() -> void:
	in_fullscreen = false
	resize()
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
func on_max() -> void:
	in_fullscreen = true
	resize()
# ------------------------------------------------------------------------------			

# ------------------------------------------------------------------------------	
func resize() -> void:
	var container_node:Control = GBL.find_node(REFS.OS_LAYOUT)	
	if in_fullscreen:
		var is_windowed_mode:bool = DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		var spacing:int = 35 if is_windows else 68
		WindowUI.window_size = GBL.find_node(REFS.OS_LAYOUT).size - Vector2(4, (spacing if is_windowed_mode else 35) + 4)
		WindowUI.window_position = Vector2(0, 35)

	else:
		var center_position:Vector2 = (container_node.size - default_size)/2 + offset
		WindowUI.window_position = center_position
		WindowUI.window_size = default_size
			
	WindowUI.in_fullscreen_mode = in_fullscreen
	WindowUI.enable_header = !in_fullscreen
	WindowUI.enable_close_btn = !in_fullscreen
	WindowUI.enable_max_btn = !in_fullscreen
	WindowUI.is_draggable = !in_fullscreen
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func bind_events() -> void:
	WindowUI.onClick = func(node:Control, btn:int, is_hovered:bool) -> void:
		onClick.call(self, node, btn, is_hovered)
		
	WindowUI.onClickRelease = func(node:Control, btn:int, is_hovered:bool) -> void:
		onClickRelease.call(self, node, btn, is_hovered)
	
	WindowUI.onCloseBtn = func(node:Control) -> void:
		onCloseBtn.call(self, node)
		
	WindowUI.onMaxBtn = func(node:Control) -> void:
		onMaxBtn.call(self, node)	
		
	WindowUI.onDragStart = func(node:Control) -> void:
		onDragStart.call(self, node)	
		
	WindowUI.onDragEnd = func(new_offset:Vector2, node:Control) -> void:
		onDragEnd.call(new_offset, self, node)	
		
	WindowUI.onFocus = func(node:Control) -> void:
		onFocus.call(self, node)	
		
	WindowUI.onBlur = func(node:Control) -> void:
		onBlur.call(self, node)		
# ------------------------------------------------------------------------------		
