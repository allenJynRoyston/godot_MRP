@tool
extends MouseInteractions

@onready var IconButton:Control = $VBoxContainer/CenterContainer/IconBtn
@onready var AppLabel:Label = $VBoxContainer/PanelContainer/MarginContainer/Label

@export var title:String = "Application" : 
	set(val):
		title = val
		on_title_update()

@export var icon:SVGS.TYPE = SVGS.TYPE.DOT : 
	set(val):
		icon = val
		on_icon_update()

@export var is_draggable:bool = true 

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

var init_pos:Vector2 = Vector2()
var pos_offset:Vector2 = Vector2() : 
	set(val):
		pos_offset = val
		on_position_update.call_deferred()

var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()

var onClick:Callable = func(node:Node, btn:int, is_focused:bool) -> void:pass	
var onFocus:Callable = func(node:Control) -> void:pass
var onBlur:Callable = func(node:Control) -> void:pass
#var onDblClick:Callable = func(node:Control, is_focused:bool, data:Dictionary) -> void:pass
#var onRightClick:Callable = func() -> void:pass


# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	after_ready.call_deferred()

func after_ready():
	init_pos = position

	on_focus(false)
	on_title_update()
	on_icon_update()
	on_data_update()
	on_position_update()	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_data_update() -> void:
	if is_node_ready() and !data.is_empty():
		title = data.title
		icon = data.icon
		
func on_title_update() -> void:
	if is_node_ready():
		AppLabel.text = title

func on_icon_update() -> void:
	if is_node_ready():		
		IconButton.icon = icon
		
func on_position_update() -> void:
	position = pos_offset + init_pos

	if global_position.x < 0:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = 0	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:
	onFocus.call(self) if state else onBlur.call(self)
	
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)	
	

func on_is_selected_update() -> void:
	if !is_node_ready(): return

	IconButton.static_color = Color.WHITE if is_selected else Color.LIGHT_SLATE_GRAY

	var label_setting:LabelSettings = AppLabel.label_settings.duplicate()
	label_setting.font_color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE) if is_selected else COLOR_UTIL.get_text_color(COLORS.TEXT.INACTIVE)
	AppLabel.label_settings = label_setting
	

#func on_mouse_dbl_click(node:Control, btn:int, on_hover:bool) -> void:
	#if on_hover and btn == MOUSE_BUTTON_LEFT:
		#onClick.call()
# ------------------------------------------------------------------------------
