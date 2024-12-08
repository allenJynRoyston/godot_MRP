extends BtnBase

@onready var IconBtn:Control = $MarginContainer/HBoxContainer/IconBtn
@onready var BtnLabel:Label = $MarginContainer/HBoxContainer/Label

@export var icon:SVGS.TYPE = SVGS.TYPE.DOT : 
	set(val):
		icon = val
		on_icon_update()

@export var static_color:Color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if !Engine.is_editor_hint() else Color.WHITE  : 
	set(val): 
		static_color = val
		update_color(static_color)
		
@export var active_color:Color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if !Engine.is_editor_hint() else Color.WHITE :
	set(val): 
		active_color = val
		on_focus()
		
@export var inactive_color:Color = COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE) if !Engine.is_editor_hint() else Color.WHITE  :
	set(val): 
		inactive_color = val
		on_focus()

@export var title:String = "" : 
	set(val): 
		title = val
		on_title_update()

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	if is_hoverable:
		on_focus(false)
	else:
		update_color(static_color)

	on_icon_update()
	on_title_update()
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
		BtnLabel.text = title

func on_icon_update() -> void:
	if is_node_ready():
		IconBtn.icon = icon
# ------------------------------------------------------------------------------
