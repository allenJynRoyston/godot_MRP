@tool
extends MouseInteractions

@onready var RootPanel:Control = $"."
@onready var IconButton:Control = $MarginContainer2/VBoxContainer/IconBtn
@onready var RunningButton:Control = $Control2/RunningBtn
@onready var AppLabel:Label = $MarginContainer2/VBoxContainer/Label

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

var is_running:bool = false : 
	set(val):
		is_running = val
		on_is_runnning_update()

var onFocus:Callable = func(node:Control) -> void:pass
var onBlur:Callable = func(node:Control) -> void:pass

var flat_stylebox_copy:StyleBoxFlat

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	hide()
	flat_stylebox_copy = RootPanel.get('theme_override_styles/panel').duplicate()	
	after_ready.call_deferred()

	

func after_ready():
	init_pos = position
	
	on_focus(false)
	on_title_update()
	on_icon_update()
	on_data_update()
	on_position_update()	
	on_is_runnning_update()
	
	
	await U.set_timeout(0.5)
	show()	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	title = data.title
	icon = data.icon
	hint_description = "Run application: %s" % data.title
	
		
func on_title_update() -> void:
	if !is_node_ready():return
	AppLabel.text = title

func on_icon_update() -> void:
	if !is_node_ready():return
	IconButton.icon = icon
		
func on_position_update() -> void:
	position = pos_offset + init_pos

	if global_position.x < 0:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = 0	

func on_is_runnning_update() -> void:
	if !is_node_ready():return
	RunningButton.show() if is_running else RunningButton.hide()
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
	var alpha:float = 1 if is_selected else 0.8
	var txt_color:Color = Color(1, 1, 1, alpha) if is_selected else Color(1.0, 0.75, 0.2, alpha)
	var bg_color:Color = Color(1, 1, 1, alpha) if is_selected else flat_stylebox_copy.bg_color
	
	# update icon
	IconButton.static_color = txt_color
	RunningButton.static_color = txt_color
	
	# update label
	var label_setting:LabelSettings = AppLabel.label_settings.duplicate()
	label_setting.font_color = txt_color
	AppLabel.label_settings = label_setting
	
	# update panel
	flat_stylebox_copy.border_color = bg_color
	RootPanel.set('theme_override_styles/panel', flat_stylebox_copy)

#func on_mouse_dbl_click(node:Control, btn:int, on_hover:bool) -> void:
	#if on_hover and btn == MOUSE_BUTTON_LEFT:
		#onClick.call()
# ------------------------------------------------------------------------------
