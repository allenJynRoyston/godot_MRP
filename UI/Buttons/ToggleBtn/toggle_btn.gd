@tool
extends BtnBase

@onready var IconBtn:Control = $MarginContainer/HBoxContainer/IconBtn
@onready var BtnLabel:Label = $MarginContainer/HBoxContainer/Label
@onready var Margin:MarginContainer = $MarginContainer

@export var icon_active:SVGS.TYPE = SVGS.TYPE.PLUS : 
	set(val):
		icon_active = val
		on_is_toggled_update()
		
@export var icon_inactive:SVGS.TYPE = SVGS.TYPE.MINUS : 
	set(val):
		icon_inactive = val
		on_is_toggled_update()		

@export var static_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE)  : 
	set(val): 
		static_color = val
		update_color(static_color)
		
@export var active_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE)  :
	set(val): 
		active_color = val
		on_focus()
		
@export var inactive_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.INACTIVE)  :
	set(val): 
		inactive_color = val
		on_focus()

@export var title:String = "" : 
	set(val): 
		title = val
		on_title_update()
		

@export var is_toggled:bool = false : 
	set(val):
		is_toggled = val
		on_is_toggled_update()

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	if is_hoverable:
		on_focus(false)
	else:
		update_color(static_color)

	on_title_update()
	on_is_toggled_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_color(new_color:Color) -> void:
	if is_node_ready():
		IconBtn.static_color = new_color
		
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if is_node_ready():
		update_color(active_color if state else inactive_color)

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	super.on_mouse_click(node, btn, on_hover)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_title_update() -> void:
	if is_node_ready():
		if title.is_empty():
			BtnLabel.hide()
			Margin.add_theme_constant_override("margin_right", 5)
			return
		BtnLabel.show()
		Margin.add_theme_constant_override("margin_right", 10)
		BtnLabel.text = title

func on_is_toggled_update() -> void:
	if is_node_ready():
		IconBtn.icon = icon_active if is_toggled else icon_inactive
# ------------------------------------------------------------------------------
