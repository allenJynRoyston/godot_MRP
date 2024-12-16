extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var ItemLabel:Label = $MarginContainer/HBoxContainer/Label
@onready var IconButton:Control = $MarginContainer/HBoxContainer/IconBtn
@onready var CloseButton:Control = $MarginContainer/HBoxContainer/HBoxContainer/PanelContainer/MarginContainer2/CloseBtn
@onready var MinButton:Control = $MarginContainer/HBoxContainer/HBoxContainer/MinBtnContainer/MarginContainer2/MinBtn

@onready var MinButtonContainer:PanelContainer = $MarginContainer/HBoxContainer/HBoxContainer/MinBtnContainer

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

var focus_busy:bool = false

@export var show_min_button:bool = false : 
	set(val):
		show_min_button = val
		on_show_min_button_update()

# --------------------------------------	
func _ready() -> void:
	super._ready()
	on_data_update()
	on_show_min_button_update()
	on_focus(false)
	
	MinButton.onClick = func() -> void:		
		data.onMinimize.call()
	
	MinButton.onFocus = func(node:Control) -> void:
		focus_busy = true
	
	MinButton.onBlur = func(node:Control) -> void:
		focus_busy = false	
	
	CloseButton.onClick = func() -> void:
		data.onClose.call()
		
	CloseButton.onFocus = func(node:Control) -> void:
		focus_busy = true
	
	CloseButton.onBlur = func(node:Control) -> void:
		focus_busy = false
# --------------------------------------	

# --------------------------------------	
func on_show_min_button_update() -> void:	
	if is_node_ready():
		MinButtonContainer.show() if show_min_button else MinButtonContainer.hide()
# --------------------------------------	

# --------------------------------------	
func on_data_update() -> void:
	if is_node_ready() and !data.is_empty():
		ItemLabel.text = data.title
		IconButton.icon = data.icon
# --------------------------------------	

# --------------------------------------	
func on_focus(state:bool) -> void:
	#var label_setting:LabelSettings = ItemLabel.label_settings.duplicate()
	#label_setting.font_color = COLOR_UTIL.get_text_color(COLORS.TEXT.DARK) if state else COLOR_UTIL.get_text_color(COLORS.TEXT.LIGHT)
	#ItemLabel.label_settings = label_setting
	
	var new_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()	
	new_stylebox.bg_color = COLOR_UTIL.get_window_color(COLORS.WINDOW.INACTIVE) if state else COLOR_UTIL.get_window_color(COLORS.WINDOW.SHADING)
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT and !focus_busy:
		data.onClick.call()
# --------------------------------------		
