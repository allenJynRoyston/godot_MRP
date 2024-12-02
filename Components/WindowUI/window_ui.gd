@tool
extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var BodyPanel:PanelContainer = $MarginContainer/VBoxContainer/Body
@onready var Header:PanelContainer = $MarginContainer/VBoxContainer/Header

@export var enable_close_btn : bool : 
	set(val):
		enable_close_btn = val
		on_header_update()		
		
@export var enable_max_btn : bool : 
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

@export var use_editor_position:bool = false 

@export var window_position:Vector2 = Vector2(10, 10) : 
	set(val):
		window_position = val
		on_window_position_update()

var window_offset:Vector2 = Vector2() : 
	set(val):
		window_offset = val
		on_window_position_update()
		


var is_dragging:bool = false
var drag_start_pos:Vector2

# ------------------------------------------------
func _ready() -> void:
	super._ready()
	on_header_update()
	on_window_size_update()
	if use_editor_position:
		window_position = position
	on_window_position_update()
	on_window_is_active_update()
	on_focus()
	
	Header.drag_start = func() -> void:
		if !is_draggable: return
		is_dragging = true
		drag_start_pos = GBL.mouse_pos - window_offset
	Header.drag_end = func() -> void:
		if !is_draggable: return
		is_dragging = false
# ------------------------------------------------	

# ------------------------------------------------	
func on_window_size_update() -> void:
	custom_minimum_size = window_size
# ------------------------------------------------	

# ------------------------------------------------	
func on_window_position_update() -> void:
	position = window_position + window_offset
	if global_position.x < 0:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = 0
# ------------------------------------------------	
	
# ------------------------------------------------
func on_header_update() -> void:
	if is_node_ready():
		Header.enable_close_btn = enable_close_btn
		Header.enable_max_btn = enable_max_btn
		Header.window_label = window_label
# ------------------------------------------------

# ------------------------------------------------
func on_window_is_active_update() -> void:
	on_focus(window_is_active)
# ------------------------------------------------	

# ------------------------------------------------
func on_focus(state:bool = false) -> void:	
	if is_node_ready():
		Header.is_focused = (state or window_is_active)
		
		for node in [RootPanel]:
			var root_stylebox = node.get_theme_stylebox('panel').duplicate()
			root_stylebox.border_color = "00f647" if (state or window_is_active) else Color.TRANSPARENT
			node.add_theme_stylebox_override("panel", root_stylebox)

		for node in [BodyPanel]:
			var root_stylebox = node.get_theme_stylebox('panel').duplicate()
			root_stylebox.border_color = "00f647" if (state or window_is_active) else "004115"
			node.add_theme_stylebox_override("panel", root_stylebox)
# ------------------------------------------------

# ------------------------------------------------
func _process(delta: float) -> void:
	super._process(delta)
	if !is_dragging: return
	
	window_offset = GBL.mouse_pos - drag_start_pos 
# ------------------------------------------------	
	
