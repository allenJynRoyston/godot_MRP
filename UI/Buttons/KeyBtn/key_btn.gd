@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."
@onready var ProgressBarPanel:ProgressBar = $VBoxContainer/PanelContainer2/ProgressBar

@onready var TitleHeader:Label = $VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/TitleHeader
@onready var KeyLabel:Label = $VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/KeyLabel
@onready var SmallKeyLabel:Label = $VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/MarginContainer/SmallKeyLabel
@onready var SvgIcon:Control = $VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/SVGIcon


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
		
@export var primary_color:Color = COLORS.primary_color : 
	set(val):
		primary_color = val
		on_panel_color_update()		
		
@export var is_flashing:bool = false 

@export var hide_icon_panel:bool = false : 
	set(val):
		hide_icon_panel = val
		on_hide_icon_panel_update()

var stylebox_copy:StyleBoxFlat
var is_pressed:bool = false
var btn_delay:float = 0.2

var is_hovered:bool = false

var get_disable:Callable = func() -> bool:
	return false

var get_icon:Callable = func() -> SVGS.TYPE:
	return icon

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
	#on_has_new_update()
	on_assigned_key_update()
	
	on_panel_color_update()
	on_is_disabled_updated()
	on_hide_icon_panel_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_color(new_color:Color) -> void:
	if !is_node_ready():return

func on_focus(state:bool = is_focused) -> void:
	if !is_disabled:	
		super.on_focus(state)
		on_panel_color_update()
	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if !is_node_ready() or !is_visible_in_tree() or !is_hoverable or is_disabled:return
	super.on_mouse_click(node, btn, on_hover)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_assigned_key_update() -> void:
	if !is_node_ready():return
	if assigned_key.length() > 1:
		KeyLabel.text = assigned_key.substr(0, 1) 
		SmallKeyLabel.text = assigned_key.substr(1) 
		SmallKeyLabel.show()
	else:
		KeyLabel.text = assigned_key 
		SmallKeyLabel.hide() 

func on_is_disabled_updated() -> void:
	modulate.a = 0.5 if is_disabled else 1
	
func on_panel_color_update() -> void:
	if !is_node_ready():return
	#var stylebox_copy = StyleBoxFlat.new()
	#stylebox_copy.bg_color = primary_color
	#stylebox_copy.corner_radius_bottom_left = 5
	#stylebox_copy.corner_radius_bottom_right = 5
	#stylebox_copy.corner_radius_top_left = 5
	#stylebox_copy.corner_radius_top_right = 5
	#
	#stylebox_copy.border_width_bottom = 2
	#stylebox_copy.border_width_left = 2
	#stylebox_copy.border_width_right = 2
	#stylebox_copy.border_width_top = 2
	#stylebox_copy.border_color = Color.WHITE if is_focused else Color.BLACK
		#
	#RootPanel.add_theme_stylebox_override("panel", stylebox_copy)
		

func on_title_update() -> void:
	if !is_node_ready():return
	TitleHeader.text = title

func on_icon_update() -> void:
	if !is_node_ready():return
	SvgIcon.icon = icon	
	
func on_hide_icon_panel_update() -> void:
	if !is_node_ready():return
	SvgIcon.show() if !hide_icon_panel else SvgIcon.hide()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var is_active_key_pressed:bool = false
func on_control_input_update(input_data:Dictionary) -> void:
	is_active_key_pressed = false
	if !is_node_ready() or !is_visible_in_tree() or !is_hoverable or is_disabled:return
	if input_data.key == assigned_key:
		is_active_key_pressed = true
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_control_input_release_update() -> void:
	if !is_node_ready():return
	if is_active_key_pressed:
		if ProgressBarPanel.value == 1:
			onClick.call()		
		
		btn_press_duration = 0
		is_active_key_pressed = false
		ProgressBarPanel.value = 0
# ------------------------------------------------------------------------------	

# --------------------------------		
const speed:float = 5.0
const btn_press_required_duration:float = 0.05
var time:float = 0
var btn_press_duration:float = 0

func _process(delta: float) -> void:
	if is_active_key_pressed and !is_disabled:
		btn_press_duration += delta
		var normalized_value = btn_press_duration / btn_press_required_duration
		if normalized_value > 1:
			normalized_value = 1

		ProgressBarPanel.value = normalized_value		
		
	if !is_flashing:return
	time += delta
	var value := (sin(time * speed) + 1.2) / 2.0  # Oscillates smoothly between 0 and 1
	#var stylebox_copy = StyleBoxFlat.new()
	#stylebox_copy.bg_color = Color(1 - value, 1, 1 - value)
	#RootPanel.add_theme_stylebox_override("panel", stylebox_copy)
# --------------------------------
