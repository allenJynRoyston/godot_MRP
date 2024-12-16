@tool
extends BtnBase

@export var active_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE) if !Engine.is_editor_hint() else Color.WHITE :
	set(val): 
		active_color = val
		on_focus()
		
@export var inactive_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.INACTIVE) if !Engine.is_editor_hint() else Color.WHITE  :
	set(val): 
		inactive_color = val
		on_focus()


# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	if is_hoverable:
		on_focus(false)
# ------------------------------------------------------------------------------

## ------------------------------------------------------------------------------
#func on_focus(state:bool = is_focused) -> void:
	#super.on_focus(state)
#
#func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	#super.on_mouse_click(node, btn, on_hover)
## ------------------------------------------------------------------------------
#
