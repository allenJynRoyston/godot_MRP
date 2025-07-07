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
		
@export var is_disabled:bool = false : 
	set(val):
		is_disabled = val
		on_is_disabled_update()		
		
@export var is_hollow:bool = false : 
	set(val):
		is_hollow = val
		on_is_hollow_update()				
		
@export var COLOR_A:Color = Color(1.0, 0.75, 0.2)
@export var COLOR_B:Color =  Color(0, 0, 0)

@export var COLOR_A_DISABLED:Color = Color.RED
@export var COLOR_B_DISABLED:Color = Color.BLACK

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
	super.on_focus(state)
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)	

func on_is_disabled_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self, "_update_color"), update_colors)

func on_is_selected_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self, "_update_color"), update_colors)
	
func on_is_hollow_update() -> void:
	if !is_node_ready():return	
	U.debounce(str(self, "_update_color"), update_colors)

func update_colors() -> void:
	var alpha:float = 1 if is_selected else 0.8
	var flat_stylebox_copy:StyleBoxFlat = RootPanel.get('theme_override_styles/panel').duplicate()	
	
	var use_color_a:Color = COLOR_A if !is_disabled else COLOR_A_DISABLED
	var use_color_b:Color = COLOR_B if !is_disabled else COLOR_B_DISABLED
	
	var txt_color:Color = Color(use_color_b.r, use_color_b.g, use_color_b.b, alpha) if is_selected else Color(use_color_a.r, use_color_a.g, use_color_a.b, alpha)
	var bg_color:Color = Color(use_color_b.r, use_color_b.g, use_color_b.b, alpha) if !is_selected else Color(use_color_a.r, use_color_a.g, use_color_a.b, alpha)
	var label_settings_copy:LabelSettings = TitleLabel.label_settings.duplicate()
	
	if !is_hollow:
		flat_stylebox_copy.bg_color = bg_color
		flat_stylebox_copy.border_color = COLOR_A if !is_selected else COLOR_B
		label_settings_copy.font_color = txt_color
		label_settings_copy.outline_color = Color(txt_color.r, txt_color.g, txt_color.b, 0.5)
		
	else:
		flat_stylebox_copy.bg_color = COLOR_B
		flat_stylebox_copy.border_color = COLOR_A if is_selected else COLOR_B
		flat_stylebox_copy.border_width_left = 2
		flat_stylebox_copy.border_width_right = 2
		flat_stylebox_copy.border_width_top = 2
		flat_stylebox_copy.border_width_bottom = 2
		label_settings_copy.font_color = COLOR_A
		label_settings_copy.outline_color = Color(COLOR_A.r, COLOR_A.g, COLOR_A.b, 0.5)
		modulate = Color(1, 1, 1, 1 if is_selected else 0.5)

		
	IconBtn.static_color = txt_color
	TitleLabel.label_settings = label_settings_copy
	RootPanel.add_theme_stylebox_override("panel", flat_stylebox_copy)	

# ------------------------------------------------------------------------------
