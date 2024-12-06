extends Control
class_name MouseInteractions

@export var is_hoverable:bool = true 

var root_node:Control 
var on_hover:bool = false
var mouse_pos:Vector2 = Vector2(0, 0)
var is_focused:bool = false

# --------------------------------------	
func _ready() -> void:
	if Engine.is_editor_hint():
		return 	
	if is_node_ready() and "subscribe_to_mouse_pos" in GBL:
		GBL.subscribe_to_mouse_pos(self)
	root_node = find_root(self)
	GBL.subscribe_to_input(self)
# --------------------------------------			

# --------------------------------------	
func _exit_tree() -> void:
	if Engine.is_editor_hint():
		return 	
	GBL.unsubscribe_to_mouse_pos(self)
	GBL.unsubscribe_to_input(self)
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
func _process(_delta:float) -> void:
	if Engine.is_editor_hint():
		return 
		
	if root_node != null and "freeze_inputs" in root_node:
		if root_node.freeze_inputs: 
			return
	
	if is_visible_in_tree() and is_hoverable:
		if get_global_rect().has_point(GBL.mouse_pos):
			if !on_hover:
				focus_event()
		else:
			if on_hover:
				blur_event()
	else:
		if on_hover:
			blur_event()
# --------------------------------------
