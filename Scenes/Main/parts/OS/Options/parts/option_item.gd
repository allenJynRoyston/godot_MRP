@tool
extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var TitleLabel:Label = $MarginContainer/HBoxContainer/Label
@onready var IconBtn:BtnBase = $MarginContainer/HBoxContainer/IconBtn

@export var title:String = "" : 
	set(val):
		title = val
		on_title_update()

@export var is_checked:bool = false : 
	set(val):
		is_checked = val
		on_is_checked_update()	
		
@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()		

@export var display_checkmark:bool = false : 
	set(val):
		display_checkmark = val
		on_display_checkmark_update()

var onClick:Callable = func() -> void:pass

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	if is_hoverable:
		on_focus(false)

	on_is_selected_update()
	on_title_update()
	on_is_checked_update()
	on_display_checkmark_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title

func on_is_checked_update() -> void:
	if !is_node_ready():return
	IconBtn.icon = SVGS.TYPE.CHECKBOX if is_checked else SVGS.TYPE.EMPTY_CHECKBOX

func on_display_checkmark_update() -> void:
	if !is_node_ready():return
	IconBtn.show() if display_checkmark else IconBtn.hide()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	\
func on_focus(state:bool = is_focused) -> void:
	#onFocus.call(self) if state else onBlur.call(self)
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)	
		
func on_is_selected_update() -> void:
	var new_stylebox:StyleBoxFlat = RootPanel.get('theme_override_styles/panel').duplicate()
	
	new_stylebox.bg_color = Color(0.632, 0.742, 0.878, 1) if is_selected else Color(0.162, 0.162, 0.162, 0.5)
	new_stylebox.border_color = Color.WHITE if is_selected else Color(1, 1, 1, 0.4)
	new_stylebox.corner_radius_bottom_left = 5
	new_stylebox.corner_radius_bottom_right = 5
	new_stylebox.corner_radius_top_left = 5
	new_stylebox.corner_radius_top_right = 5
	
	new_stylebox.border_width_bottom = 2
	new_stylebox.border_width_top = 2
	new_stylebox.border_width_left = 2
	new_stylebox.border_width_right = 2	
	
	IconBtn.static_color = Color.BLACK if is_selected else Color.WHITE

	RootPanel.add_theme_stylebox_override("panel", new_stylebox)
# ------------------------------------------------------------------------------
