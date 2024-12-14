extends MouseInteractions
class_name BtnBase

var onClick:Callable = func():pass
var onFocus:Callable = func(node:Control) -> void:pass
var onBlur:Callable = func(node:Control) -> void:pass

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	if is_hoverable:
		on_focus(false)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func _exit_tree() -> void:
	super._exit_tree()
	if !Engine.is_editor_hint() and is_hoverable and is_focused:		
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:	
	if !is_node_ready():return	
	is_focused = state
	onFocus.call(self) if state else onBlur.call(self)	
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
		
	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT:
		onClick.call()

func on_mouse_dbl_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
# ------------------------------------------------------------------------------
