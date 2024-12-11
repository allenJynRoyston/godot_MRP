@tool
extends MouseInteractions

@onready var TitleLabel:Label = $Label
@onready var IconButton:Control = $IconBtn
@onready var IsBusyButton:Control = $IsBusyBtn

@export var title:String = "Titlebar" : 
	set(val):
		title = val
		on_title_update()
		
@export var icon:SVGS.TYPE = SVGS.TYPE.THINKING : 
	set(val):
		icon = val
		on_icon_update()
		
var is_busy:bool = false : 
	set(val):
		is_busy = val
		on_is_busy_update()
		
var onClick:Callable = func():pass

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	on_focus(false)
	on_title_update()
	on_icon_update()
	on_is_busy_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_title_update() -> void:
	if is_node_ready():
		TitleLabel.text = title
		
func on_icon_update() -> void:
	if is_node_ready():
		IconButton.icon = icon
		
func on_is_busy_update() -> void:
	IsBusyButton.show() if is_busy else IsBusyButton.hide()	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:
	if is_node_ready() and !Engine.is_editor_hint():
		IconButton.static_color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if state else COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE)
		IsBusyButton.static_color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if state else COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE)
		
		var label_setting:LabelSettings = TitleLabel.label_settings.duplicate()
		label_setting.font_color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if state else COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE)
		TitleLabel.label_settings = label_setting
	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT:
		onClick.call()
# ------------------------------------------------------------------------------
