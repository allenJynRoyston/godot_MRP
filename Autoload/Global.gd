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

func unsubscribe_to_mouse_pos(node:Control) -> void:
	mouse_pos_subscriptions.erase(node)

func subscribe_to_mouse_pos(node:Control) -> void:
	if node not in mouse_pos_subscriptions: 
		mouse_pos_subscriptions.push_back(node)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var node_refs:Dictionary = {}

func register_node(key:int, node:Node) -> void:
	if key not in node_refs:
		node_refs[key] = node
		
func unregister_node(key:int) -> void:
	if key in node_refs:
		node_refs.erase(key)
		
func find_node(key:int) -> Node:
	return node_refs[key]
# ------------------------------------------------------------------------------
