extends Node

# ------------------------------------------------------------------------------
# MOUSE POSITIONS
var mouse_pos := Vector2(0, 0) : 
	set(val): 
		mouse_pos = val;
		for node in mouse_pos_subscriptions:
			if "on_mouse_pos_update" in node:
				node.on_mouse_pos_update(mouse_pos)
		
var mouse_pos_subscriptions:Array[Control] = []

func subscribe_to_mouse_pos(node:Control) -> void:
	if node not in mouse_pos_subscriptions: 
		mouse_pos_subscriptions.push_back(node)
# ------------------------------------------------------------------------------
