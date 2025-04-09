@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."
@onready var AnimationPlayerNode:AnimationPlayer = $AnimationPlayer
@onready var SelectedIcon:BtnBase = $Control/SelectedIcon
@onready var IconPanel:Control = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer
@onready var IconBtn:Control = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/IconBtn
@onready var IndicatorBtn:Control = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/NewIndicatorBtn

@onready var TitleHeader:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/TitleHeader
@onready var KeyLabel:Label = $VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/KeyLabel

@export var assigned_key:String = "X" : 
	set(val):
		assigned_key = val
		on_assigned_key_update()
		
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

@export var hide_icon:bool = false : 
	set(val):
		hide_icon = val
		on_hide_icon_update()
		
@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()		

const empty_title:String = "NONE"

var default_icon:SVGS.TYPE = SVGS.TYPE.TARGET
var hint_description:String = "" 
var is_pressed:bool = false
var room_ref:int = -1 
var ability_index:int = -1 

var title:String = empty_title : 
	set(val): 
		title = val
		on_title_update()
		
var icon:SVGS.TYPE : 
	set(val):
		icon = val
		on_icon_update()		

var is_not_ready:bool = false : 
	set(val):
		is_not_ready = val
		on_is_not_ready_update()
		
var is_invalid:bool = false : 
	set(val):
		is_invalid = val
		on_is_invalid_update()

var get_invalid_func:Callable = func() -> bool: return false
var get_cooldown_duration:Callable = func() -> int:return 0
var get_not_ready_func:Callable = func() -> bool:return false
var get_icon_func:Callable = func() -> SVGS.TYPE:return icon

var base_states:Dictionary = {}
var room_config:Dictionary = {}
var current_location:Dictionary = {}

var onReset:Callable = func():pass

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.subscribe_to_control_input(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unsubscribe_to_control_input(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)

func _ready() -> void:
	super._ready()
	if is_hoverable:
		on_focus(false)

	on_icon_update()
	on_title_update()
	on_assigned_key_update()
	reset()
	
	on_panel_color_update()
	on_is_disabled_updated()
	on_hide_icon_update()
	on_is_selected_update()
	
func reset(clear:bool = false) -> void:
	if clear:
		onReset.call()
	
	title = empty_title
	hint_description = ""
	icon = SVGS.TYPE.NONE
	is_invalid = false
	is_not_ready = false

	onClick = func() -> void:pass
	onReset = func() -> void:pass
	get_cooldown_duration = func():return -1
	get_invalid_func = func():return false
	get_not_ready_func = func():return false
	get_icon_func = func():return SVGS.TYPE.NONE	

	on_icon_update()
	on_is_disabled_updated()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_base_states_update(new_val:Dictionary = base_states) -> void:
	base_states = new_val
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val	
	update_self()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_self() -> void:
	if !is_node_ready() or room_config.is_empty():return
	is_invalid = await get_invalid_func.call()
	is_not_ready = await get_not_ready_func.call()
	icon = await get_icon_func.call()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_hide_icon_update() -> void:
	if !is_node_ready():return
	IconPanel.show() if !hide_icon else IconPanel.hide()
	
func update_color(new_color:Color) -> void:
	if !is_node_ready():return

func on_focus(state:bool = is_focused) -> void:
	if !is_disabled:	
		super.on_focus(state)
		on_panel_color_update()
	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if !is_node_ready():return
	
	if is_invalid:
		reset(true)
		return
	
	if !is_hoverable or is_not_ready or is_disabled:
		return

	super.on_mouse_click(node, btn, on_hover)
	await U.tick()
	super.on_focus(true)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_is_selected_update() -> void:
	if !is_node_ready():return
	AnimationPlayerNode.play("pointing") if is_selected else AnimationPlayerNode.stop()
	SelectedIcon.show() if is_selected else SelectedIcon.hide()
	on_is_disabled_updated()

	var new_stylebox:StyleBoxFlat = RootPanel.get('theme_override_styles/panel').duplicate()
	new_stylebox.border_color = Color.WHITE if is_selected else Color.BLACK
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)


func on_assigned_key_update() -> void:
	if !is_node_ready():return
	KeyLabel.text = assigned_key

func on_is_not_ready_update() -> void:
	on_icon_update()
	on_is_disabled_updated()

func on_is_invalid_update() -> void:
	if is_invalid:
		title = "!RMV!"
	on_icon_update()
	on_is_disabled_updated()
	
func on_is_empty_update() -> void:
	on_is_disabled_updated()
		
func on_is_disabled_updated() -> void:	
	var alpha:float = 0.5 if title == empty_title else 1.0	
	if is_selected:
		modulate = Color(0, 0, 1, alpha) if (is_disabled or is_invalid or is_not_ready) else Color(1, 1, 1, alpha)
	else:
		modulate = Color(1, 0, 0, alpha) if (is_disabled or is_invalid or is_not_ready) else Color(1, 1, 1, alpha)
	
func on_panel_color_update() -> void:
	if !is_node_ready():return
	var new_stylebox:StyleBoxFlat = RootPanel.get('theme_override_styles/panel').duplicate()
	new_stylebox.border_color = Color.WHITE if is_focused else Color.BLACK
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)
		

func on_title_update() -> void:
	if !is_node_ready():return
	TitleHeader.text = title

func on_icon_update() -> void:
	if !is_node_ready():return	
	IconBtn.icon = SVGS.TYPE.DELETE if is_invalid else icon
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or !is_visible_in_tree():return
	var key:String = input_data.key
	if key == assigned_key and !is_pressed:		
		if is_invalid:
			reset(true)
			return
			
		if !is_hoverable or is_not_ready or is_disabled:
			return
		
		onClick.call()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_control_input_release_update() -> void:
	if !is_node_ready() or !is_visible_in_tree() or !is_hoverable or is_disabled:return
	is_pressed = false
# ------------------------------------------------------------------------------	
