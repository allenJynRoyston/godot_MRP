@tool
extends MouseInteractions

@onready var IconBtn:Control = $IconBtn 
@onready var ItemLabel:Label = $ItemLabel

@export var icon:SVGS.TYPE = SVGS.TYPE.DOT : 
	set(val):
		icon = val
		on_icon_update()
		
@export var title:String = ""	: 
	set(val):
		title = val
		on_title_update()	
		on_title_update()
		
		
var onClick:Callable = func():pass
var onDismiss:Callable = func():pass
		
# --------------------------------------
func _ready() -> void:
	super._ready()
	on_icon_update()

func on_icon_update() -> void:
	if is_node_ready():
		IconBtn.icon = 	icon

func on_title_update() -> void:
	if is_node_ready():
		ItemLabel.text = title
# --------------------------------------

# --------------------------------------	
func on_focus(state:bool) -> void:
	if !is_node_ready():return
	IconBtn.static_color = COLOR_UTIL.get_window_color(COLORS.WINDOW.ACTIVE) if state else COLOR_UTIL.get_window_color(COLORS.WINDOW.INACTIVE)
	
	var label_setting:LabelSettings = ItemLabel.label_settings.duplicate()
	label_setting.font_color = COLOR_UTIL.get_window_color(COLORS.WINDOW.ACTIVE) if state else COLOR_UTIL.get_window_color(COLORS.WINDOW.INACTIVE)
	ItemLabel.label_settings = label_setting
		
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
