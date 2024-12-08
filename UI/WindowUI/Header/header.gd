@tool
extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var LabelContainer:PanelContainer = $HBoxContainer/LabelContainer
@onready var FocusContainer:PanelContainer = $HBoxContainer/FocusContainer
@onready var BtnContainer:PanelContainer = $HBoxContainer/BtnContainer

@onready var WindowLabel:Label = $HBoxContainer/LabelContainer/MarginContainer/HBoxContainer/Label
@onready var IconButton:Control = $HBoxContainer/LabelContainer/MarginContainer/HBoxContainer/IconBtn
@onready var MaxBtn:Control = $HBoxContainer/BtnContainer/HBoxContainer/MaxBtn
@onready var CloseBtn:Control = $HBoxContainer/BtnContainer/HBoxContainer/CloseBtn

@export var enable_max_btn: bool : 
	set(val):
		enable_max_btn = val
		on_btn_update()
		
@export var enable_close_btn: bool : 
	set(val):
		enable_close_btn = val
		on_btn_update()
		
@export var window_label:String = "" : 
	set(val):
		window_label = val
		on_window_label_update()
		
@onready var force_focus:bool = false : 
	set(val):
		force_focus = val
		on_force_focus_updated()
		
@onready var icon:SVGS.TYPE = SVGS.TYPE.DOT : 
	set(val):
		icon = val
		on_icon_update()

var show_min_btn:bool = false : 
	set(val): 
		show_min_btn = val
		on_show_min_btn_update()

var onDragStart:Callable = func():pass
var onDragEnd:Callable = func():pass
var onCloseBtn:Callable = func():pass
var onMaxBtn:Callable = func():pass

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	on_btn_update()
	on_window_label_update()
	on_icon_update()	
	on_show_min_btn_update()
	on_force_focus_updated(false)
	
	MaxBtn.onClick = func():
		onMaxBtn.call()
	
	CloseBtn.onClick = func():
		onCloseBtn.call()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_show_min_btn_update() -> void:
	MaxBtn.icon = SVGS.TYPE.MINUS if show_min_btn else SVGS.TYPE.PLUS
	
func on_window_label_update() -> void:
	if is_node_ready():
		WindowLabel.text = window_label

func on_icon_update() -> void:
	if is_node_ready():
		IconButton.icon = icon
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_force_focus_updated(state:bool = force_focus) -> void:
	if Engine.is_editor_hint():
		return 
			
	for node in [WindowLabel]:
		var new_label_setting:LabelSettings = node.label_settings.duplicate()
		new_label_setting.font_color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if state else COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE)
		node.label_settings = new_label_setting
		
	for node in [MaxBtn, CloseBtn]:
		pass
		#var new_stylebox:StyleBoxFlat = node.get_theme_stylebox('normal').duplicate()
		#new_stylebox.bg_color = "00f647" if is_focused else "004115"
		#node.add_theme_stylebox_override("normal", new_stylebox)
	

	for node in [RootPanel]:
		var new_stylebox:StyleBox = node.get_theme_stylebox('panel').duplicate()
		new_stylebox.border_color = COLOR_REF.get_window_color(COLORS.WINDOW.ACTIVE) if state else COLOR_REF.get_window_color(COLORS.WINDOW.INACTIVE)
		node.add_theme_stylebox_override("panel", new_stylebox)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_btn_update():
	if is_node_ready():
		CloseBtn.show() if enable_close_btn else CloseBtn.hide()
		MaxBtn.show() if enable_max_btn else MaxBtn.hide()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_mouse_click(node:Control, btn:int, is_focused:bool) -> void:
	if is_focused:
		onDragStart.call()
	
func on_mouse_release(node:Control, btn:int, is_focused:bool) -> void:
	onDragEnd.call()
# --------------------------------------------------------------------------------------------------
