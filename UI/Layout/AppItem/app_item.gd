@tool
extends MouseInteractions

@onready var IconButton:IconBtn = $VBoxContainer/CenterContainer/IconBtn
@onready var AppLabel:Label = $VBoxContainer/PanelContainer/MarginContainer/Label

@export var title:String = "Application" : 
	set(val):
		title = val
		on_title_update()

@export var icon:int = SVGS.DOT : 
	set(val):
		icon = val
		on_icon_update()

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

var init_pos:Vector2 = Vector2()

var pos_offset:Vector2 = Vector2() : 
	set(val):
		pos_offset = val
		on_position_update()

var can_release:bool = true
var is_dragging:bool = false
var drag_start_pos:Vector2 = Vector2(0, 0)
var is_selectable:bool = true : 
	set(val):
		is_selectable = val
		if !val:
			is_dragging = false
		on_focus()

var onClick:Callable = func(node:Node, btn:int, is_focused:bool) -> void:pass
var onDragStart:Callable = func(node:Node) -> void:pass
var onDragEnd:Callable = func(new_offset:Vector2, node:Control) -> void:pass		
var onFocus:Callable = func(node:Control) -> void:pass
var onBlur:Callable = func(node:Control) -> void:pass
var onDblClick:Callable = func(data:Dictionary) -> void:pass
var onRightClick:Callable = func() -> void:pass


# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	after_ready.call_deferred()

func after_ready():
	init_pos = position

	on_focus(false)
	on_title_update()
	on_icon_update()
	on_data_update()
	on_position_update()	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_data_update() -> void:
	if is_node_ready() and !data.is_empty():
		title = data.title
		icon = data.icon
		
func on_title_update() -> void:
	if is_node_ready():
		AppLabel.text = title

func on_icon_update() -> void:
	if is_node_ready():		
		IconButton.icon = icon
		
func on_position_update() -> void:
	position = pos_offset + init_pos

	if global_position.x < 0:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = 0	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:
	onFocus.call(self) if state else onBlur.call(self)
	
	if !is_selectable: 
		update_color(false)
		return	
	update_color(is_focused)
	
func update_color(state:bool) -> void:
	#var shader_material:ShaderMaterial = IconImage.material.duplicate()	
	#shader_material.set_shader_parameter("tint_color", Color(0, 0.965, 0.278, 1) if state else Color(0, 0.529, 0.278, 1))
	#IconImage.material = shader_material
	
	var label_setting:LabelSettings = AppLabel.label_settings.duplicate()
	label_setting.font_color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if state else COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE)
	AppLabel.label_settings = label_setting
	
	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover:
		if !is_draggable or !is_focused or !is_selectable: return
		onClick.call(self, btn, on_hover)
		if !is_dragging:
			is_dragging = true
			drag_start_pos = GBL.mouse_pos - pos_offset
			onDragStart.call(self)

func on_mouse_release(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover:
		if !is_draggable or !is_focused or !is_selectable: return
		if is_dragging:
			onDragEnd.call(pos_offset, self)
			is_dragging = false

func on_mouse_dbl_click(btn:int, on_hover:bool) -> void:
	if !is_selectable: return
	if on_hover and btn == MOUSE_BUTTON_LEFT:
		onDblClick.call(data)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func _process(delta: float) -> void:		
	super._process(delta)
		
	if !is_dragging: 
		pos_offset = pos_offset
		return
	#
	pos_offset = GBL.mouse_pos - drag_start_pos 
# ------------------------------------------------------------------------------
	
