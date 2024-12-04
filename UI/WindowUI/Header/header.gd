@tool
extends MouseInteractions

@onready var LabelContainer:PanelContainer = $HBoxContainer/LabelContainer
@onready var FocusContainer:PanelContainer = $HBoxContainer/FocusContainer
@onready var BtnContainer:PanelContainer = $HBoxContainer/BtnContainer
@onready var CloseBtnContainer:PanelContainer = $HBoxContainer/BtnContainer/MarginContainer/HBoxContainer/CrossBtnContainer
@onready var MaxBtnContainer:PanelContainer = $HBoxContainer/BtnContainer/MarginContainer/HBoxContainer/MaxBtnContainer

@onready var WindowLabel:Label = $HBoxContainer/LabelContainer/MarginContainer/Label
@onready var MaxBtn:Button = $HBoxContainer/BtnContainer/MarginContainer/HBoxContainer/MaxBtnContainer/MarginContainer/PanelContainer/Button
@onready var CloseBtn:Button = $HBoxContainer/BtnContainer/MarginContainer/HBoxContainer/CrossBtnContainer/MarginContainer/PanelContainer/Button

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
		
@onready var is_focused:bool = false : 
	set(val):
		is_focused = val
		on_is_focused_updated()
	

var onDragStart:Callable = func():pass
var onDragEnd:Callable = func():pass
var onCloseBtn:Callable = func():pass
var onMaxBtn:Callable = func():pass

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	on_btn_update()
	on_window_label_update()
	on_is_focused_updated()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_window_label_update() -> void:
	if is_node_ready():
		WindowLabel.text = window_label
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_is_focused_updated() -> void:
	for node in [WindowLabel]:
		var new_label_setting:LabelSettings = node.label_settings.duplicate()
		new_label_setting.font_color = "00f647" if is_focused else "004115"
		node.label_settings = new_label_setting
		
	for node in [MaxBtn, CloseBtn]:
		var new_stylebox:StyleBoxFlat = node.get_theme_stylebox('normal').duplicate()
		new_stylebox.bg_color = "00f647" if is_focused else "004115"
		node.add_theme_stylebox_override("normal", new_stylebox)
	
	for node in [LabelContainer, FocusContainer, BtnContainer]:
		var new_stylebox:StyleBoxFlat = node.get_theme_stylebox('panel').duplicate()
		new_stylebox.border_color = "00f647" if is_focused else "004115"
		node.add_theme_stylebox_override("panel", new_stylebox)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_btn_update():
	if is_node_ready():
		CloseBtnContainer.show() if enable_close_btn else CloseBtnContainer.hide()
		MaxBtnContainer.show() if enable_max_btn else MaxBtnContainer.hide()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_mouse_click(node:Control, btn:int, is_focused:bool) -> void:
	if is_focused:
		onDragStart.call()
	
func on_mouse_release(btn:int, is_focused:bool) -> void:
	onDragEnd.call()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_max_btn_pressed() -> void:
	onMaxBtn.call()

func on_close_btn_pressed() -> void:
	onCloseBtn.call()
# --------------------------------------------------------------------------------------------------
