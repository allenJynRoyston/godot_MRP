@tool
extends Node

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

# ------------------------------------------------------------------------------
var resolution_nodes:Array = []
func save_resolution(val:Vector2i) -> void:
	var config_data:Dictionary = {
		"resolution_width": val.x,
		"resolution_height": val.y
	}
	var file = FileAccess.open("user://config.json", FileAccess.WRITE)
	# Store the JSON string in the file
	file.store_string(JSON.stringify(config_data))
	# Close the file after writing
	file.close()

func change_resolution(new_resolution:Vector2i) -> void:
	save_resolution(new_resolution)
	OS.set_restart_on_exit(true)
	get_tree().quit()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var fullscreen_nodes:Array[Control] = []
func subscribe_to_fullscreen(node:Control) -> void:
	if node not in fullscreen_nodes:
		fullscreen_nodes.push_back(node)

func unsubscribe_to_fullscreen(node:Control) -> void:
	fullscreen_nodes.erase(node)
	
func update_fullscreen_mode(state:bool) -> void:
	for node in fullscreen_nodes:
		if "on_fullscreen_update":
			node.on_fullscreen_update.call(state)
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# MOUSE POSITION
var mouse_pos := Vector2(0, 0) : 
	set(val): 
		mouse_pos = val;
		for node in mouse_pos_subscriptions:
			if "on_mouse_pos_update" in node:
				node.on_mouse_pos_update(mouse_pos)

var next_mouse_icon:MOUSE_ICON = MOUSE_ICON.CURSOR

var mouse_pos_subscriptions:Array[Control] = []

func unsubscribe_to_mouse_pos(node:Control) -> void:
	mouse_pos_subscriptions.erase(node)

func subscribe_to_mouse_pos(node:Control) -> void:
	if node not in mouse_pos_subscriptions: 
		mouse_pos_subscriptions.push_back(node)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# MOUSE ICON
enum MOUSE_ICON {CURSOR, BUSY, POINTER}
var mouse_icon_subscriptions:Array[Control] = []
var mouse_icon:MOUSE_ICON = MOUSE_ICON.CURSOR : 
	set(val):
		mouse_icon = val
		for node in mouse_icon_subscriptions:
			if "on_mouse_icon_update" in node:
				node.on_mouse_icon_update(mouse_icon)

func unsubscribe_to_mouse_icons(node:Control) -> void:
	mouse_icon_subscriptions.erase(node)

func subscribe_to_mouse_icons(node:Control) -> void:
	if node not in mouse_icon_subscriptions: 
		mouse_icon_subscriptions.push_back(node)

func change_mouse_icon(val:MOUSE_ICON) -> void:
	if mouse_icon == MOUSE_ICON.BUSY:
		next_mouse_icon = val
		return
	mouse_icon = val

func end_mouse_busy() -> void:
	mouse_icon = next_mouse_icon
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
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
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var control_input_subscriptions:Array = []
func subscribe_to_control_input(node:Control) -> void:
	if node not in control_input_subscriptions:
		control_input_subscriptions.push_back(node)
		
func unsubscribe_to_control_input(node:Control) -> void:
	control_input_subscriptions.erase(node)
		
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():
		for node in control_input_subscriptions:
			if "on_control_input_update" in node:
				var key:String = ""
				match event.keycode:
					4194309:
						key = "ENTER"
					4194308:
						key = "BACK"
					70:
						key = "F"
					53:
						key = "5"
					56:
						key = "8"
						
				node.on_control_input_update({"keycode": event.keycode, "key": key})
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# NODE REFS
var process_nodes:Array = []

func subscribe_to_process(node:Node) -> void:
	if node not in process_nodes:
		process_nodes.push_back(node)
		
func unsubscribe_to_process(node:Node) -> void:
	process_nodes.erase(node)
	
func _process(delta:float) -> void:
	for node in process_nodes:
		if "on_process_update" in node:
			node.on_process_update.call(delta)
# ------------------------------------------------------------------------------
