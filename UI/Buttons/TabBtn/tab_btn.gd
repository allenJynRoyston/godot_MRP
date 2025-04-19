@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."
@onready var IconBtn:BtnBase = $VBoxContainer/IconBtn
@onready var TitleLabel:Label = $VBoxContainer/TitleLabel

@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()		

@export var title:String = "TAB TITLE" : 
	set(val): 
		title = val
		on_title_update()

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	on_focus(false)
	on_is_disabled_updated()
	on_is_selected_update()
	on_title_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title

func on_is_selected_update() -> void:
	if !is_node_ready():return
	IconBtn.icon = SVGS.TYPE.UP_ARROW
	IconBtn.show() if is_selected else IconBtn.hide()
	modulate = Color(1, 1, 1, 1 if is_selected else 0.5) 

func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if state:
		pass
		#IconBtn.icon = SVGS.TYPE.DOT
		#IconBtn.show() 
	else:
		on_is_selected_update()

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	super.on_mouse_click(node, btn, on_hover)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_is_disabled_updated() -> void:
	modulate = Color(1, 0, 0, 1) if is_disabled else Color(1, 1, 1, 1)	
# ------------------------------------------------------------------------------
