@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."
@onready var IconBtnLeft:Control = $MarginContainer/HBoxContainer/IconBtnLeft
@onready var IconBtnRight:Control = $MarginContainer/HBoxContainer/IconBtnRight
@onready var BtnLabel:Label = $MarginContainer/HBoxContainer/Label

enum SIDE {LEFT, RIGHT}

@export var icon:SVGS.TYPE = SVGS.TYPE.DOT : 
	set(val):
		icon = val
		on_icon_update()
		
@export var icon_placement:SIDE = SIDE.LEFT : 
	set(val):
		icon_placement = val
		on_icon_placement_update()

@export var panel_color:Color = Color("0e0e0ecb") : 
	set(val):
		panel_color = val
		on_panel_color_update()		

@export var static_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE)   : 
	set(val): 
		static_color = val
		update_color(static_color)
		
@export var active_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE) :
	set(val): 
		active_color = val
		on_focus()
		
@export var inactive_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.INACTIVE) :
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
	on_icon_placement_update()
	on_panel_color_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_color(new_color:Color) -> void:
	if is_node_ready():
		IconBtnLeft.static_color = new_color
		IconBtnRight.static_color = new_color
		
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if is_node_ready():
		update_color(active_color if state else inactive_color)

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	super.on_mouse_click(node, btn, on_hover)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_panel_color_update() -> void:
	if !is_node_ready():return
	var new_stylebox:StyleBoxFlat = StyleBoxFlat.new()
	new_stylebox.bg_color = panel_color
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)
		
func on_icon_placement_update() -> void:
	if !is_node_ready():return
	match icon_placement:
		SIDE.LEFT:
			IconBtnRight.hide()
			IconBtnLeft.show()
		SIDE.RIGHT:
			IconBtnRight.show()
			IconBtnLeft.hide()
	
func on_title_update() -> void:
	if !is_node_ready():return
	BtnLabel.text = title

func on_icon_update() -> void:
	if !is_node_ready():return
	IconBtnLeft.icon = icon
	IconBtnRight.icon = icon
# ------------------------------------------------------------------------------
