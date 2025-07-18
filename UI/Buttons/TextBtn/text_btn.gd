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
	
	
var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
	
	
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
	on_is_disabled_updated()
	on_is_selected_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_color(new_color:Color) -> void:
	if !is_node_ready():return
	IconBtnLeft.static_color = new_color
	IconBtnRight.static_color = new_color
	BtnLabel.modulate = new_color

func is_active(state:bool) -> void:
	if !is_node_ready():return
	update_color(active_color if state else inactive_color)

func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if !is_node_ready():return
	update_color(active_color if state else inactive_color)

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	super.on_mouse_click(node, btn, on_hover)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_is_selected_update() -> void:
	if !is_node_ready():return
	var m:Color = self.modulate
	var sc:Color = IconBtnLeft.static_color
	modulate.a = 1 if is_selected else 0.5
	await U.tick()
	IconBtnLeft.static_color = Color(sc.r, sc.g, sc.b,  1 if is_selected else 0.5)
	IconBtnRight.static_color = Color(sc.r, sc.g, sc.b,  1 if is_selected else 0.5)


	
func on_is_disabled_updated() -> void:
	modulate = Color(1, 0, 0) if is_disabled else Color(1, 1, 1)
	
func on_panel_color_update() -> void:
	if !is_node_ready():return
	var new_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
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
