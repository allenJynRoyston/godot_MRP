@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."
@onready var IconBtn:Control = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/IconBtn
@onready var IndicatorBtn:Control = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/NewIndicatorBtn

@onready var TitleHeader:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/TitleHeader
@onready var KeyLabel:Label = $VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/KeyLabel

@export var title:String = "" : 
	set(val): 
		title = val
		on_title_update()

@export var assigned_key:String = "X" : 
	set(val):
		assigned_key = val
		on_assigned_key_update()

@export var icon:SVGS.TYPE = SVGS.TYPE.BUILD : 
	set(val):
		icon = val
		on_icon_update()
		
@export var panel_color:Color = Color(0.169, 0.169, 0.169) : 
	set(val):
		panel_color = val
		on_panel_color_update()		
	
@export var text_active_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE) :
	set(val): 
		text_active_color = val
		on_focus()
		
@export var text_inactive_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.INACTIVE) :
	set(val): 
		text_inactive_color = val
		on_focus()

@export var is_disabled:bool = false : 
	set(val):
		is_disabled = val
		on_is_disabled_updated()
		
@export var has_new:bool = false : 
	set(val):
		has_new = val
		on_has_new_update()		

var is_hovered:bool = false

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.subscribe_to_control_input(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unsubscribe_to_control_input(self)

func _ready() -> void:
	super._ready()
	if is_hoverable:
		on_focus(false)

	on_icon_update()
	on_title_update()
	on_has_new_update()
	on_assigned_key_update()
	
	on_panel_color_update()
	on_is_disabled_updated()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_color(new_color:Color) -> void:
	if !is_node_ready():return

func on_focus(state:bool = is_focused) -> void:
	if !is_disabled:	
		super.on_focus(state)
		on_panel_color_update()
	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if !is_disabled and is_visible_in_tree():
		super.on_mouse_click(node, btn, on_hover)
		
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_assigned_key_update() -> void:
	if !is_node_ready():return
	KeyLabel.text = assigned_key
	
func on_has_new_update() -> void:
	if !is_node_ready():return
	if !has_new:
		IndicatorBtn.hide()
	else:
		IndicatorBtn.show()
		# pulse on and off
		
func on_is_disabled_updated() -> void:
	modulate = Color(1, 0, 0, 1) if is_disabled else Color(1, 1, 1, 1)
	
func on_panel_color_update() -> void:
	if !is_node_ready():return
	var new_stylebox:StyleBoxFlat = StyleBoxFlat.new()
	new_stylebox.bg_color = panel_color
	new_stylebox.corner_radius_bottom_left = 5
	new_stylebox.corner_radius_bottom_right = 5
	new_stylebox.corner_radius_top_left = 5
	new_stylebox.corner_radius_top_right = 5
	
	new_stylebox.border_width_bottom = 2
	new_stylebox.border_width_left = 2
	new_stylebox.border_width_right = 2
	new_stylebox.border_width_top = 2
	new_stylebox.border_color = Color.WHITE if is_focused else Color.BLACK
		
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)
		

func on_title_update() -> void:
	if !is_node_ready():return
	TitleHeader.text = title

func on_icon_update() -> void:
	if !is_node_ready():return
	IconBtn.icon = icon	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or !is_hoverable or is_disabled:return
	var key:String = input_data.key
	if key == assigned_key and is_visible_in_tree():
		onClick.call()
# ------------------------------------------------------------------------------
