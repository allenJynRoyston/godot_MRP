extends Control
class_name MouseInteractions

@export var is_hoverable:bool = true : 
	set(val):
		is_hoverable = val
		on_is_hoverable_update()
		
@export var debug_me:bool = false

var root_node:Control 
var container_node:Control
var is_in_subviewport:bool = false
var on_hover:bool = false
var mouse_pos:Vector2 = Vector2(0, 0)
var is_focused:bool = false

# --------------------------------------	
func _init() -> void:
	if Engine.is_editor_hint():return 	
# --------------------------------------	

# --------------------------------------	
func _ready() -> void:
	root_node = find_root(self)
	is_in_subviewport = find_subviewport(self)
	GBL.subscribe_to_mouse_pos(self)
	GBL.subscribe_to_mouse_input(self)
	GBL.subscribe_to_process(self)	
	
	on_is_hoverable_update()
# --------------------------------------

# --------------------------------------	
func _exit_tree() -> void:
	if Engine.is_editor_hint():
		return 	
	GBL.unsubscribe_to_mouse_pos(self)
	GBL.unsubscribe_to_mouse_input(self)
	GBL.unsubscribe_to_process(self)	
# --------------------------------------	

# --------------------------------------	
func on_is_hoverable_update() -> void:
	pass
# --------------------------------------	

# --------------------------------------	
func on_mouse_pos_update(new_mouse_pos:Vector2) -> void:
	mouse_pos = new_mouse_pos
# --------------------------------------		

# --------------------------------------	
func on_focus(state:bool) -> void:
	pass
# --------------------------------------	

# --------------------------------------	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	pass
# --------------------------------------		

# --------------------------------------		
func on_mouse_release(node:Control, btn:int, on_hover:bool) -> void:
	pass
# --------------------------------------			

# --------------------------------------		
func on_mouse_dbl_click(node:Control, btn:int, on_hover:bool) -> void:
	pass
# --------------------------------------		

# --------------------------------------	
func focus_event() -> void:
	on_hover = true	
	is_focused = true
	on_focus(true)
# --------------------------------------		

# --------------------------------------	
func blur_event() -> void:
	on_hover = false
	is_focused = false
	on_focus(false)
# --------------------------------------		

# --------------------------------------
func find_root(node: Node) -> Node:
	while node.get_parent() != null:
		if "freeze_inputs" in node:
			return node
		node = node.get_parent()
	return null
# --------------------------------------	

# --------------------------------------
func find_subviewport(node: Node) -> bool:
	var in_subviewport:bool = false
	while node.get_parent() != null:
		if node is SubViewport:
			in_subviewport = true
			
		if "is_container" in node and in_subviewport:
			container_node = node
			return true
			break
			
		node = node.get_parent()
	return false
# --------------------------------------	

## --------------------------------------		
func registered_click(event:InputEventMouseButton) -> void:
	if root_node != null and "freeze_inputs" in root_node:
		if root_node.freeze_inputs: 
			return

	if event.is_pressed():
		on_mouse_click(self, event.button_index, on_hover)
	if event.is_released():
		on_mouse_release(self, event.button_index, on_hover)
	if event.double_click:
		on_mouse_dbl_click(self, event.button_index, on_hover)
## --------------------------------------		

# --------------------------------------	
func on_process_update(_delta:float) -> void:
	if Engine.is_editor_hint():
		return 
			
	if root_node != null and "freeze_inputs" in root_node:
		if root_node.freeze_inputs: 
			return
	
	if is_visible_in_tree() and is_hoverable:
		var margins:Vector2 = Vector2(0, 0)
		var check_position:Vector2 = get_global_rect().position
		var use_rect:Rect2 = get_global_rect()
		
		if is_in_subviewport:
			if container_node is MarginContainer:
				margins = Vector2(container_node.get_theme_constant('margin_left'), container_node.get_theme_constant('margin_top'))
			check_position = container_node.get_global_rect().position + get_global_rect().position
			
		use_rect.position = check_position + margins
			
		if use_rect.has_point(GBL.mouse_pos):
			if !on_hover:
				focus_event()
		else:
			if on_hover:
				blur_event()
	else:
		if on_hover:
			blur_event()
# --------------------------------------
