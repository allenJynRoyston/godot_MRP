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
func on_focus(state:bool = is_focused) -> void:
	is_focused = state
	if !is_node_ready():return	
	onFocus.call(self) if state else onBlur.call(self)
	if !Engine.is_editor_hint():
		GBL.change_mouse_icon(GBL.MOUSE_ICON.POINTER if state else GBL.MOUSE_ICON.CURSOR)
	


func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT:
		if !Engine.is_editor_hint():
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
		onClick.call()
# ------------------------------------------------------------------------------
