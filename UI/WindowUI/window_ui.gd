@tool
extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var BodyPanel:PanelContainer = $MarginContainer/VBoxContainer/Body
@onready var Header:PanelContainer = $MarginContainer/VBoxContainer/Header

@export var enable_header : bool  = true: 
	set(val):
		enable_header = val
		on_enable_header_update()
		
@export var enable_close_btn : bool = true : 
	set(val):
		enable_close_btn = val
		on_header_update()		
		
@export var enable_max_btn : bool = true : 
	set(val):
		enable_max_btn = val
		on_header_update()

@export var window_is_active:bool = false : 
	set(val):
		window_is_active = val
		on_window_is_active_update()

@export var window_label:String = "" : 
	set(val):
		window_label = val
		on_header_update()
		
@export var window_size:Vector2 = Vector2(200, 0) : 
	set(val):
		window_size = val
		on_window_size_update()

@export var window_position:Vector2 = Vector2(10, 10) : 
	set(val):
		window_position = val
		on_window_position_update()
		
@export var freeze_inputs:bool = false : 
	set(val):
		freeze_inputs = val
		on_freeze_inputs_update()
		
@export var freeze_content_input:bool = false : 
	set(val):
		freeze_content_input = val
		on_freeze_content_input_update()		

@export var header_icon : SVGS.TYPE  = SVGS.TYPE.DOT : 
	set(val):
		header_icon = val
		on_header_icon_update()

@export var is_draggable:bool = true 

var in_fullscreen_mode:bool = false : 
	set(val):
		in_fullscreen_mode = val
		on_in_fullscreen_mode_update()	

var window_offset:Vector2 = Vector2() : 
	set(val):
		window_offset = val
		on_window_position_update()

var is_dragging:bool = false
var drag_start_pos:Vector2 = Vector2(0, 0)

var onClick:Callable = func(node:Control, btn:int, on_hover:bool) -> void:pass
var onClickRelease:Callable = func(node:Control, btn:int, on_hover:bool) -> void:pass
var onFocus:Callable = func(node:Control) -> void:pass
var onBlur:Callable = func(node:Control) -> void:pass
var onDragStart:Callable = func(node:Control) -> void:pass
var onDragEnd:Callable = func(new_offset:Vector2, node:Control) -> void:pass
var onMaxBtn:Callable = func(node:Control) -> void:pass
var onCloseBtn:Callable = func(node:Control) -> void:pass

# ------------------------------------------------
func _ready() -> void:
	super._ready()
	on_header_update()
	on_header_icon_update()
	on_window_size_update()
	on_window_position_update()
	on_window_is_active_update()
	on_enable_header_update()
	on_freeze_inputs_update()
	on_freeze_content_input_update()
	on_in_fullscreen_mode_update()
	on_focus()
	
	Header.onMaxBtn = func() -> void:
		onMaxBtn.call(self)
		
	Header.onCloseBtn = func() -> void:
		onCloseBtn.call(self)
	
	Header.onDragStart = func() -> void:
		if !is_draggable or !is_focused: return
		is_dragging = true
		drag_start_pos = GBL.mouse_pos - window_offset
		onDragStart.call(self)
		
	Header.onDragEnd = func() -> void:
		if !is_draggable or !is_focused: return
		is_dragging = false
		onDragEnd.call(window_offset, self)
# ------------------------------------------------	

# ------------------------------------------------	
func on_window_size_update() -> void:
	custom_minimum_size = window_size
	size = window_size
# ------------------------------------------------	

# ------------------------------------------------	
func on_in_fullscreen_mode_update() -> void:
	Header.show_min_btn = in_fullscreen_mode
# ------------------------------------------------	
	
# ------------------------------------------------	
func on_window_position_update() -> void:
	position = window_position + window_offset
	
	if global_position.x < 0:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = 0
# ------------------------------------------------	

# --------------------------------------	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:	
	onClick.call(node, btn, on_hover)
# --------------------------------------		

# --------------------------------------		
func on_mouse_release(node:Control, btn:int, on_hover:bool) -> void:	
	onClickRelease.call(node, btn, on_hover)
# --------------------------------------			

# ------------------------------------------------
func on_header_update() -> void:
	if is_node_ready():
		Header.enable_close_btn = enable_close_btn
		Header.enable_max_btn = enable_max_btn
		Header.window_label = window_label
# ------------------------------------------------

# ------------------------------------------------
func on_header_icon_update() -> void:
	if is_node_ready():
		Header.icon = header_icon
# ------------------------------------------------	

# ------------------------------------------------
func on_freeze_inputs_update() -> void:
	modulate = Color(0, 0, 1, 1) if freeze_inputs else Color(1, 1, 1, 1)
# ------------------------------------------------	

# ------------------------------------------------
func on_freeze_content_input_update() -> void:
	if is_node_ready() and "freeze_inputs" in BodyPanel:		
		BodyPanel.freeze_inputs = freeze_content_input
# ------------------------------------------------		

# ------------------------------------------------
func on_window_is_active_update() -> void:
	on_focus(window_is_active)
# ------------------------------------------------	

# ------------------------------------------------	
func on_enable_header_update() -> void:
	if is_node_ready():
		Header.show() if enable_header else Header.hide()
# ------------------------------------------------		

# ------------------------------------------------
func on_focus(state:bool = false) -> void:
	if Engine.is_editor_hint():
		return 
			
	onFocus.call(self) if state else onBlur.call(self)
	
	if is_node_ready():
		is_focused = state

		Header.force_focus = (state or window_is_active)
		
		for node in [RootPanel]:
			var new_stylebox:StyleBox = node.get_theme_stylebox('panel').duplicate()
			new_stylebox.border_color = COLOR_REF.get_window_color(COLORS.WINDOW.ACTIVE) if (state or window_is_active) else COLOR_REF.get_window_color(COLORS.WINDOW.INACTIVE)
			node.add_theme_stylebox_override("panel", new_stylebox)
#
		#for node in [BodyPanel]:
			#var root_stylebox:StyleBoxFlat = node.get_theme_stylebox('panel').duplicate()
			#root_stylebox.border_color = "00f647" if (state or window_is_active) else "004115"
			#node.add_theme_stylebox_override("panel", root_stylebox)
# ------------------------------------------------

# ------------------------------------------------
func on_process_update(delta: float) -> void:		
	super.on_process_update(delta)
		
	if !is_dragging: 
		# not sure why this works but it does
		window_offset = window_offset
		return
	
	window_offset = GBL.mouse_pos - drag_start_pos 
# ------------------------------------------------	
	
