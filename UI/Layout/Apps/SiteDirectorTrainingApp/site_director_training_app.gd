extends PanelContainer

@onready var WindowUI:PanelContainer = $WindowUI

var onCloseBtn:Callable = func(node:Control) -> void:pass
var onMaxBtn:Callable = func(node:Control) -> void:pass	

# ------------------------------------------------------------------------------
func _ready() -> void:
	after_ready.call_deferred()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func after_ready():
	var container_node:Control = GBL.find_node(REFS.OS_LAYOUT)
	var center_position:Vector2 = (container_node.size - WindowUI.window_size)/2
	WindowUI.window_position = center_position
	
	WindowUI.onCloseBtn = onCloseBtn
	WindowUI.onMaxBtn = onMaxBtn	
# ------------------------------------------------------------------------------	
