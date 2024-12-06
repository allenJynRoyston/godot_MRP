extends Node

# ------------------------------------------------------------------------------
# MOUSE POSITIONS
var win_z_count:int = 0 

func get_next_window_z() -> int:
	win_z_count += 1
	return win_z_count
# ------------------------------------------------------------------------------

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
# NODE REFS
var node_refs:Dictionary = {}

func register_node(key:int, node:Node) -> void:
	if key not in node_refs:
		node_refs[key] = node
		
func unregister_node(key:int) -> void:
	node_refs.erase(key)
		
func find_node(key:int) -> Node:
	return node_refs[key] if key in node_refs else null
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# NODE REFS
var music_data_subscriptions:Array[Control] = []

var music_data:Dictionary = {} : 
	set(val): 
		music_data = val
		on_music_data_update()
		
func on_music_data_update() -> void:
	for node in music_data_subscriptions:
		if "on_music_data_update" in node:
			node.music_data = music_data

func subscribe_to_music_player(node:Control) -> void:
	if node not in music_data_subscriptions:
		music_data_subscriptions.push_back(node)
		
func unsubscribe_to_music_player(node:Control) -> void:
	music_data_subscriptions.erase(node)
# ------------------------------------------------------------------------------


# --------------------------------------	
var input_subscriptions:Array = []

func subscribe_to_input(node:Control) -> void:
	if node not in input_subscriptions:
		input_subscriptions.push_back(node)
		
func unsubscribe_to_input(node:Control) -> void:
	input_subscriptions.erase(node)
		
func _input(event) -> void:
	if event is InputEventMouseButton:
		for node in input_subscriptions:
			if "registered_click" in node:
				node.registered_click(event)
# --------------------------------------		
