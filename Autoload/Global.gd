@tool
extends Node

# ------------------------------------------------------------------------------
var active_user_profile:Dictionary = {}
var loaded_gameplay_data:Dictionary = {}

func get_current_chapter() -> int:
	return active_user_profile.story_progress.on_chapter
	
func mark_messages_played(on_chapter:int) -> void:
	if on_chapter not in active_user_profile.story_progress.messages_played:
		active_user_profile.story_progress.messages_played.push_back(on_chapter)
	update_and_save_user_profile()
	
func has_message_been_played(on_chapter:int) -> bool:
	if "story_message" not in STORY.chapters[on_chapter]:
		return true
	return on_chapter in active_user_profile.story_progress.messages_played

func update_and_save_user_profile(_active_user_profile:Dictionary = active_user_profile) -> void:
	# save file...
	FS.save_file(FS.FILE.USER_PROFILE, _active_user_profile)	
	# then push to global space
	active_user_profile = _active_user_profile
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var animation_queue:Array = []
func add_to_animation_queue(node:Node) -> void:
	if node not in animation_queue:
		animation_queue.push_back(node)

func remove_from_animation_queue(node:Node) -> void:
	animation_queue.erase(node)

func has_animation_in_queue() -> bool:
	return animation_queue.size() > 0
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# NODE REFS
var direct_ref:Dictionary = {}
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
var is_fullscreen:bool 
var h_diff:int
var y_diff:int
var initalized_at_fullscreen:bool
var game_resolution:Vector2 : 
	set(val):
		game_resolution = val
		print("Resolution set to %s." % game_resolution)
		
var fullscreen_nodes:Array[Control] = []
func subscribe_to_fullscreen(node:Control) -> void:
	if node not in fullscreen_nodes:
		fullscreen_nodes.push_back(node)

func unsubscribe_to_fullscreen(node:Control) -> void:
	fullscreen_nodes.erase(node)
	
func update_fullscreen_mode(state:bool) -> void:
	is_fullscreen = state
	
	h_diff = (1080 - 720) # difference between 1080 and 720 resolution - gives you 360
	y_diff = (0 if !GBL.is_fullscreen else h_diff) if !initalized_at_fullscreen else (0 if GBL.is_fullscreen else -h_diff)	

	
	for node in fullscreen_nodes:
		if "on_fullscreen_update" in node:
			node.on_fullscreen_update.call(state)

func trigger_fullscreen_prechange() -> void:
	for node in fullscreen_nodes:
		if "before_fullscreen_update" in node:
			node.before_fullscreen_update.call()
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# MOUSE POSITION
var mouse_pos := Vector2(0, 0) : 
	set(val): 
		mouse_pos = val;
		for node in mouse_pos_subscriptions:
			if node != null and "on_mouse_pos_update" in node:
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
var mouse_input_wait:bool = false
func subscribe_to_mouse_input(node:Control) -> void:
	if node not in input_subscriptions:
		input_subscriptions.push_back(node)
		
func unsubscribe_to_mouse_input(node:Control) -> void:
	input_subscriptions.erase(node)
		
func _input(event:InputEvent) -> void:
	if event is InputEventGesture and event is not InputEventMagnifyGesture:
		for node in input_subscriptions:
			if node == null:
				return
			
			if event.delta.y > 0.1 and "on_mouse_scroll" in node and !mouse_input_wait:
				node.on_mouse_scroll(0)
				mouse_input_wait = true
				await U.set_timeout(0.3)
				mouse_input_wait = false	
			if event.delta.y < 0.1 and "on_mouse_scroll" in node and !mouse_input_wait:
				node.on_mouse_scroll(1)
				mouse_input_wait = true
				await U.set_timeout(0.3)
				mouse_input_wait = false	
				
	
	if event is InputEventMouseButton:
		for node in input_subscriptions:
			if node == null:
				input_subscriptions.erase(node)
				return

			if event.button_index == 4: 
				if "on_mouse_scroll" in node and !mouse_input_wait:
					node.on_mouse_scroll(0)
					mouse_input_wait = true
					await U.set_timeout(0.1)
					mouse_input_wait = false					
			if event.button_index == 5:
				if "on_mouse_scroll" in node and !mouse_input_wait:
					node.on_mouse_scroll(1)
					mouse_input_wait = true
					await U.set_timeout(0.1)
					mouse_input_wait = false
				
			if "registered_click" in node:
				node.registered_click(event)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var control_input_subscriptions:Array = []
var key_delay:float = 0.02
var key_on_cooldown:float = false
func subscribe_to_control_input(node:Node) -> void:
	if node not in control_input_subscriptions:
		control_input_subscriptions.push_back(node)
		
func unsubscribe_to_control_input(node:Node) -> void:
	control_input_subscriptions.erase(node)
		
func _unhandled_key_input(event: InputEvent) -> void:
	if key_on_cooldown:return
			
	if event.is_released():
		for node in control_input_subscriptions:
			if "on_control_input_release_update" in node:
				node.on_control_input_release_update()
		
	if event.is_pressed():
		for node in control_input_subscriptions:
			if "on_control_input_update" in node:
				var key:String = ""
				
				match event.keycode:
					# --------------
					48:
						key = "0"
					49:
						key = "1"
					50:
						key = "2"
					51:
						key = "3"
					52:
						key = "4"
					53:
						key = "5"
					56:
						key = "8"
					# --------------
					4194319: 
						key = "LEFT"
					4194321:
						key = "RIGHT"
					4194320:
						key = "UP"
					4194322:
						key = "DOWN"
					4194308: 
						key = "BACKSPACE"
					4194308: 
						key = "DELETE"
					4194306:
						key = "TAB"
					4194309:
						key = "ENTER"
					4194308:
						key = "BACK"
					4194325:
						key = "SHIFT"
					32:
						key = "SPACE"
					# --------------
					67:
						key = "C"
					66:
						key = "B"
					69:
						key = "E"
					70:
						key = "F"
					82:
						key = "R"
					# --------------
					71:
						key = "G"
					72:
						key = "H"
					73:
						key = "I"
					78:
						key = "N"
					79:
						key = "O"
					65:
						key = "A"
					68:
						key = "D"
					87:
						key = "W"
					88:
						key = "X"
					83:
						key = "S"
					84:
						key = "T"
					81:
						key = "TL"
					89: 
						key = "TR"
					91:
						key = "L1"
					93:
						key = "R1"
						
				node.on_control_input_update({"keycode": event.keycode, "key": key})
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func set_transition(state:bool) -> void:
	var TransitionScreen:Control = GBL.find_node(REFS.GAMEPLAY_LOOP).TransitionScreen
	if state:
		await TransitionScreen.start()
	else:
		await TransitionScreen.end()
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
	if Engine.is_editor_hint():return
		
	for node in process_nodes:
		if node == null:
			process_nodes.erase(node)
			return
		if "on_process_update" in node:
			node.on_process_update.call(delta)
# ------------------------------------------------------------------------------
