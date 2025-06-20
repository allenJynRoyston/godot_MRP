extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var ItemLabel:Label = $MarginContainer/HBoxContainer/Label
@onready var IconButton:Control = $MarginContainer/HBoxContainer/IconBtn
#@onready var CloseButton:Control = $MarginContainer/HBoxContainer/HBoxContainer/PanelContainer/MarginContainer2/CloseBtn
#@onready var MinButton:Control = $MarginContainer/HBoxContainer/HBoxContainer/MinBtnContainer/MarginContainer2/MinBtn

@onready var MinButtonContainer:PanelContainer = $MarginContainer/HBoxContainer/HBoxContainer/MinBtnContainer

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

var focus_busy:bool = false

var onClick:Callable = func():pass
var onMinimize:Callable = func():pass
var onClose:Callable = func():pass
var onFocus:Callable = func():pass

#@export var show_min_button:bool = false : 
	#set(val):
		#show_min_button = val
		#on_show_min_button_update()

# --------------------------------------	
func _ready() -> void:
	super._ready()
	on_data_update()
	#on_show_min_button_update()
	on_focus(false)
	
	IconButton.onClick = func() -> void:
		onClick.call()
	
# --------------------------------------	

## --------------------------------------	
#func on_show_min_button_update() -> void:	
	#if is_node_ready():
		#MinButtonContainer.show() if show_min_button else MinButtonContainer.hide()
## --------------------------------------	

# --------------------------------------	
func on_data_update() -> void:
	if is_node_ready() and !data.is_empty():
		ItemLabel.text = data.title
		IconButton.icon = data.icon
# --------------------------------------	

# --------------------------------------		
func get_buttons() -> Array:
	return [IconButton]
# --------------------------------------	
	
# --------------------------------------	
func on_focus(state:bool) -> void:
	var new_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()	
	
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)	

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT and !focus_busy:
		if "onClick" in data:
			data.onClick.call()
# --------------------------------------		
