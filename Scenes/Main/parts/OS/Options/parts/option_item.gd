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

var flat_stylebox_copy:StyleBoxFlat
var onClick:Callable = func() -> void:pass

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	if is_hoverable:
		on_focus(false)

	flat_stylebox_copy = RootPanel.get('theme_override_styles/panel').duplicate()


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
	if !is_node_ready():return
	var alpha:float = 1 if is_selected else 0.8
	var txt_color:Color = Color(1, 1, 1, alpha) if is_selected else Color(1.0, 0.75, 0.2, alpha)
	var bg_color:Color = Color(flat_stylebox_copy.bg_color.r, flat_stylebox_copy.bg_color.g, flat_stylebox_copy.bg_color.b, alpha)
	
	flat_stylebox_copy.bg_color = bg_color
	flat_stylebox_copy.border_color = Color.WHITE if is_selected else Color(1, 1, 1, 0.4)
	flat_stylebox_copy.corner_radius_bottom_left = 5
	flat_stylebox_copy.corner_radius_bottom_right = 5
	flat_stylebox_copy.corner_radius_top_left = 5
	flat_stylebox_copy.corner_radius_top_right = 5
	
	flat_stylebox_copy.border_width_bottom = 2
	flat_stylebox_copy.border_width_top = 2
	flat_stylebox_copy.border_width_left = 2
	flat_stylebox_copy.border_width_right = 2	
	
	IconBtn.static_color = txt_color
	var label_settings_copy:LabelSettings = TitleLabel.label_settings.duplicate()
	label_settings_copy.font_color = txt_color
	TitleLabel.label_settings = label_settings_copy

	RootPanel.add_theme_stylebox_override("panel", flat_stylebox_copy)
# ------------------------------------------------------------------------------
