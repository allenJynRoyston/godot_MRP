@tool
extends MouseInteractions

@onready var RootPanel:Control = $"."
@onready var IconBtn:BtnBase = $Control/PanelContainer/IconBtn

@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()

var onClick:Callable = func():pass
var onDismiss:Callable = func():pass
		

func _ready() -> void:
	super._ready()
	on_is_selected_update()
	on_focus()

# --------------------------------------
func on_is_selected_update() -> void:
	if !is_node_ready():return
	IconBtn.show() if is_selected else IconBtn.hide()

	var dupe_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
	dupe_stylebox.border_color = Color.BLUE if is_selected else (Color.BLACK if !is_focused else Color.WHITE)
	RootPanel.add_theme_stylebox_override('panel', dupe_stylebox)	
# --------------------------------------	


# --------------------------------------	
func on_focus(state:bool = false) -> void:
	if !is_node_ready():return
	
	if !is_selected:
		var dupe_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
		dupe_stylebox.border_color = Color.BLACK if !state else Color.WHITE
		RootPanel.add_theme_stylebox_override('panel', dupe_stylebox)
		
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
# --------------------------------------	

# --------------------------------------	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover:
		onClick.call()
	else:
		onDismiss.call()
# --------------------------------------		
