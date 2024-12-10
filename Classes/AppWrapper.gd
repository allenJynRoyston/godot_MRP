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
var in_fullscreen:bool = false
var previously_loaded:bool = false

var default_setup:Dictionary = {}

# ------------------------------------------------------------------------------
func _ready() -> void:	
	after_ready.call_deferred()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func after_ready():
	var container_node:Control = GBL.find_node(REFS.OS_LAYOUT)	
	if in_fullscreen:
		WindowUI.window_size = GBL.game_resolution - Vector2(0, 35)
		WindowUI.is_draggable = false
		WindowUI.window_position = Vector2(0, 35)
		WindowUI.enable_header = false
		WindowUI.enable_close_btn = false
		WindowUI.enable_max_btn = false
		
	else:
		var center_position:Vector2 = (container_node.size - WindowUI.size)/2 + offset
		WindowUI.window_position = center_position

	
	WindowUI.in_fullscreen_mode = in_fullscreen
	bind_events()
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
