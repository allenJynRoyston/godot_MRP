extends PanelContainer
class_name AppWrapper 

var onClick:Callable = func(node:Control, btn:int, is_hover:bool) -> void:pass
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

# ------------------------------------------------------------------------------
func _ready() -> void:
	after_ready.call_deferred()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func after_ready():
	var container_node:Control = GBL.find_node(REFS.OS_LAYOUT)
	var center_position:Vector2 = (container_node.size - WindowUI.window_size)/2 + offset
	WindowUI.window_position = center_position
	
	WindowUI.onClick = func (node:Control, btn:int, is_hovered:bool) -> void:
		print('here')
		# onClick.call(self, node, btn, is_hovered)
		
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
