extends Control
class_name MouseInteractions

@export var is_draggable:bool = true 
@export var is_hoverable:bool = true 

var on_hover:bool = false

var mouse_pos:Vector2 = Vector2(0, 0)


# --------------------------------------	
func _ready() -> void:
	if is_node_ready() and "subscribe_to_mouse_pos" in GBL:
		GBL.subscribe_to_mouse_pos(self)
# --------------------------------------			

func _exit_tree() -> void:
	GBL.unsubscribe_to_mouse_pos(self)

# --------------------------------------	
func on_mouse_pos_update(new_mouse_pos:Vector2) -> void:
	mouse_pos = new_mouse_pos
# --------------------------------------		

# --------------------------------------	
func on_focus(state:bool) -> void:
	pass
# --------------------------------------	

# --------------------------------------	
func on_mouse_click(btn:int, on_hover:bool) -> void:
	pass
# --------------------------------------		

# --------------------------------------		
func on_mouse_release(btn:int, on_hover:bool) -> void:
	pass
# --------------------------------------			

# --------------------------------------		
func on_mouse_dbl_click(btn:int, on_hover:bool) -> void:
	pass
# --------------------------------------		

# --------------------------------------	
func focus_event() -> void:
	on_hover = true	
	on_focus(true)
# --------------------------------------		

# --------------------------------------	
func blur_event() -> void:
	on_hover = false
	on_focus(false)
# --------------------------------------		

# --------------------------------------		
func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			on_mouse_click(event.button_index, on_hover)
		if event.is_released():
			on_mouse_release(event.button_index, on_hover)
		if event.double_click:
			on_mouse_dbl_click(event.button_index, on_hover)
# --------------------------------------		

# --------------------------------------	
func _process(_delta:float) -> void:
	if is_visible_in_tree() and is_hoverable:
		if get_global_rect().has_point(mouse_pos):
			if !on_hover:
				focus_event()
		else:
			if on_hover:
				blur_event()
	else:
		if on_hover:
			blur_event()
# --------------------------------------
