extends Control

@onready var NodeContainer:Node3D = $SubViewport/RoomColumn/NodeContainer
@onready var Column1:Node3D = $SubViewport/RoomColumn/NodeContainer/column1
@onready var Column2:Node3D = $SubViewport/RoomColumn/NodeContainer/column2
@onready var Column3:Node3D = $SubViewport/RoomColumn/NodeContainer/column3

@onready var FloorMesh:MeshInstance3D = $SubViewport/RoomColumn/FloorMesh

@onready var ControlPanelViewport:SubViewport = $ControlSubViewport
@onready var ControlPanelContainer:Control = $ControlSubViewport/ControlPanelContainer

@onready var ControlMenuViewport:SubViewport = $ControlMenuSubviewport
@onready var ControlMenuContainer:Control = $ControlMenuSubviewport/ControlMenuContainer
@onready var ControlMenuList:VBoxContainer = $ControlMenuSubviewport/ControlMenuContainer/MarginContainer/VBoxContainer/ControlMenuList

@onready var NoPowerLights:Node3D = $SubViewport/RoomColumn/NoPowerLights
@onready var Spotlights:Node3D = $SubViewport/RoomColumn/Spotlights
@onready var NormalLights:Node3D = $SubViewport/RoomColumn/NormalLights
@onready var EmergencyLights:Node3D = $SubViewport/RoomColumn/EmergencyLights

@onready var RoomNameLabel:Label = $ControlSubViewport/ControlPanelContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/RoomNameLabel
@onready var RoomStatusLabel:Label = $ControlSubViewport/ControlPanelContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/RoomStatusLabel

@onready var CursorLabelSprite:Sprite3D = $SubViewport/RoomColumn/MainCamera/CursorLabelSprite
@onready var CursorMenuSprite:Sprite3D = $SubViewport/RoomColumn/MainCamera/CursorMenuSprite

#@onready var SpriteLayer:Node3D = $SubViewport/RoomColumn/SpriteLayer
#@onready var CursorSprite:Sprite3D = $SubViewport/RoomColumn/SpriteLayer/CursorSprite
@onready var LeftWallLabel:Label3D = $SubViewport/RoomColumn/LeftWallLabel

@onready var StatusLabel:Label3D = $SubViewport/RoomColumn/MainCamera/StatusLabel
@onready var MainCamera:Camera3D = $SubViewport/RoomColumn/MainCamera
@onready var AccentLights:DirectionalLight3D = $SubViewport/RoomColumn/MainCamera/AccentLights

@export var assigned_location:Dictionary = {} : 
	set(val):
		assigned_location = val
		on_assigned_location_update()

enum MENU_TYPE {SCP, ROOM, RESEARCHER}


var designation:String
var node_location:Vector3 
var current_location:Dictionary = {} 
var resources_data:Dictionary = {} 
var previous_floor:int = -1
var previous_ring:int = -1
var is_setup:bool = false
var node_refs:Dictionary = {}
var node_ref_positions:Dictionary = {}
var camera_size_arr:Array = [20, 24, 28, 32, 36]
var current_camera_size:int = 0 
var freeze_input:bool = false 
var room_config:Dictionary = {}
var menu_index:int = 0
var menu_actions:Array = []
var show_menu:bool = false : 
	set(val):
		if show_menu != val:
			show_menu = val
			on_show_menu_update()
var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()
var current_menu_type:MENU_TYPE = MENU_TYPE.ROOM : 
	set(val):
		if current_menu_type != val:
			current_menu_type = val		
			on_current_menu_type_update()
		
const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var in_lockdown:bool = false : 
	set(val):
		in_lockdown = val
		on_in_lockdown_update()

var is_powered:bool = false : 
	set(val):
		is_powered = val
		on_is_powered_update()

var base_states:Dictionary = {}

signal menu_response

# --------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	GBL.subscribe_to_mouse_input(self)	
	GBL.subscribe_to_control_input(self)
	GBL.register_node(REFS.ROOM_NODES, self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)
	GBL.unsubscribe_to_mouse_input(self)
	GBL.unsubscribe_to_control_input(self)
	GBL.unregister_node(REFS.ROOM_NODES)

func _ready() -> void:
	on_label_control_subpanel_rect_changed()
	on_menu_control_subpanel_rect_changed()
	on_in_lockdown_update()
	on_assigned_location_update()
	on_is_active_update()
	
	on_show_menu_update(true)
	on_current_menu_type_update()
# --------------------------------------------------------

# --------------------------------------------------------
func on_assigned_location_update(new_val:Dictionary = assigned_location) -> void:
	if !is_node_ready() or assigned_location.is_empty():return
	
	update_refs()
	check_lockdown_state()
	check_is_powered_state()
# --------------------------------------------------------

# --------------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if current_location.is_empty():return
	if designation != U.location_to_designation(current_location):
		designation = U.location_to_designation(current_location)

		menu_index = 0
		current_menu_type = MENU_TYPE.ROOM
		on_assigned_location_update()
# --------------------------------------------------------

# --------------------------------------------------------
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return
	on_assigned_location_update()
# --------------------------------------------------------

# --------------------------------------------------------
func check_lockdown_state() -> void:
	if room_config.is_empty() or current_location.is_empty():return
	in_lockdown = room_config.floor[current_location.floor].in_lockdown
# --------------------------------------------------------

# --------------------------------------------------------
func check_is_powered_state() -> void:
	if room_config.is_empty() or current_location.is_empty():return
	is_powered = room_config.floor[current_location.floor].is_powered
# --------------------------------------------------------

# --------------------------------------------------------
func update_refs() -> void:
	#LeftWallLabel.text = "FLOOR %s WING %s" % [assigned_location.floor, assigned_location.ring]
	for child in NodeContainer.get_children():
		for node in child.get_children():
			node.update_refs(assigned_location.floor, assigned_location.ring)

	for child in NodeContainer.get_children():
		for node in child.get_children():
			node_refs[node.name] = node
			node_ref_positions[node.name] = node.position
			node.onBlur = func(room_data:Dictionary) -> void:
				pass
			node.onFocus = func(room_data:Dictionary) -> void:
				RoomNameLabel.text = "EMPTY" if room_data.is_empty() else room_data.name				
				RoomStatusLabel.text = "inactive"
				node_location = node.global_position
				CursorLabelSprite.global_position = node.global_position - Vector3(0, -2, 0)
				CursorLabelSprite.position.z = -2
				

	var material_copy:StandardMaterial3D = FloorMesh.mesh.material
	match assigned_location.ring:
		0:
			material_copy.albedo_color = Color(0.318, 0.268, 0.108)
		1:
			material_copy.albedo_color = Color(0.108, 0.301, 0.349)
		2:
			material_copy.albedo_color = Color(0.153, 0.313, 0.197)
		3:
			material_copy.albedo_color = Color(0.401, 0.177, 0.347)
	FloorMesh.mesh.material = material_copy
# --------------------------------------------------------

# --------------------------------------------------------
func on_is_active_update() -> void:
	if !is_node_ready() or current_location.is_empty():return
	reset_node(current_location.room, is_active)
# --------------------------------------------------------

# --------------------------------------------------------
func reset_node(room:int, state:bool) -> void:
	var node:Node3D = node_refs[str(room)]		
	U.tween_node_property(node, "position:y", 2.5 if state else 0)
	node.show_internal = state
# --------------------------------------------------------	

# --------------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
	if !is_node_ready():return
# --------------------------------------------------------

# --------------------------------------------------------
func return_menu_config() -> Dictionary:
	return {
		"show_menu": show_menu,
		"current_menu_type": current_menu_type,
		"menu_index": menu_index
	}
# --------------------------------------------------------

# --------------------------------------------------------
func restore_menu_config(config:Dictionary) -> void:
	menu_index = config.menu_index
	show_menu = config.show_menu
	current_menu_type = config.current_menu_type	
# --------------------------------------------------------

# --------------------------------------------------------
func find_node_by_room(room_index:int) -> Node3D:
	return node_refs[str(room_index)]
# --------------------------------------------------------

# --------------------------------------------------------
func find_ui_position_of_room(room_index:int) -> Vector2:
	#camera: Camera3D, world_position: Vector3, control: Control
	var RoomNode:Node3D = find_node_by_room(room_index)
	var viewport := MainCamera.get_viewport()
	var screen_position := MainCamera.unproject_position(RoomNode.position)

	# Convert screen position to Control node's local space
	return screen_position 
# --------------------------------------------------------

# --------------------------------------------------------
func on_current_menu_type_update() -> void:
	if !is_node_ready():return 
	
	var new_stylebox = StyleBoxFlat.new()
	match current_menu_type:
		MENU_TYPE.ROOM:	
			new_stylebox.bg_color = Color.BLUE
		MENU_TYPE.SCP:
			new_stylebox.bg_color = Color.PURPLE
		MENU_TYPE.RESEARCHER:
			new_stylebox.bg_color = Color.RED
				
	ControlMenuContainer.add_theme_stylebox_override("panel", new_stylebox)
		
	on_show_menu_update()
# --------------------------------------------------------

# --------------------------------------------------------
func on_show_menu_update(setup:bool = false) -> void:
	if is_node_ready() and setup:
		U.tween_node_property(CursorMenuSprite, "rotation_degrees:y", 0 if show_menu else 90)
		return
	
	if current_location.is_empty(): return	
	var node:Node3D = find_node_by_room(current_location.room)
	node.show_internal = show_menu
	
	if show_menu:
		var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
		var is_testing:bool = !room_extract.scp.testing.is_empty() if !room_extract.scp.is_empty() else false
		menu_actions = []
		
		menu_actions.push_back({
			"title": "BACK", 
			"onSelect": func() -> void:
				menu_response.emit({"action": ACTION.ROOM_NODE.BACK})
		})		
		
		match current_menu_type:
			# ------------------
			MENU_TYPE.ROOM:								
				var room_is_empty:bool = room_extract.room.is_empty()
				
				if room_is_empty:
					menu_actions.push_back({
						"title": "CONSTRUCT ROOM...",
						"is_disabled": is_testing, 
						"onSelect": func() -> void:
							menu_response.emit({"action": ACTION.ROOM_NODE.OPEN_STORE})
					})							
				
				else:
					if room_extract.room.under_construction:
						menu_actions.push_back({
							"title": "CANCEL CONSTRUCTION",
							"onSelect": func() -> void:
								menu_response.emit({"action": ACTION.ROOM_NODE.CANCEL_CONSTRUCTION})
						})		

					else:
						if !room_extract.room.is_activated:
							menu_actions.push_back({
								"title": "ACTIVATE ROOM",
								"is_disabled": !room_extract.room.can_activate or is_testing,
								"onSelect": func() -> void:
									menu_response.emit({"action": ACTION.ROOM_NODE.ACTIVATE_ROOM, "room_details": room_extract.room.details})
							})		
						else:
							menu_actions.push_back({
								"title": "DEACTIVATE ROOM",
								"is_disabled": is_testing,
								"onSelect": func() -> void:
									menu_response.emit({"action": ACTION.ROOM_NODE.DEACTIVATE_ROOM, "room_details": room_extract.room.details})
							})		
													
						menu_actions.push_back({
							"title": "DESTROY ROOM",
							"is_disabled": is_testing,
							"onSelect": func() -> void:
								menu_response.emit({"action": ACTION.ROOM_NODE.RESET_ROOM})
						})		
			# ------------------
			
			# ------------------
			MENU_TYPE.RESEARCHER:
				menu_actions.push_back({
					"title": "ASSIGN RESEARCHER...",
					"is_disabled": is_testing,
					"onSelect": func() -> void:
						menu_response.emit({"action": ACTION.ROOM_NODE.ASSIGN_RESEARCHER})
				})		
				
				if room_extract.researchers.size() > 0:
					for researcher in room_extract.researchers:
						menu_actions.push_back({
							"title": "REMOVE %s" % [researcher.name],
							"is_disabled": is_testing,
							"onSelect": func() -> void:
								menu_response.emit({"action": ACTION.ROOM_NODE.UNASSIGN_RESEARCHER, "researcher": researcher, "room_details": room_extract.room.details if !room_extract.room.is_empty() else {}})
						})
			# ------------------
			
			# ------------------
			MENU_TYPE.SCP:
				var is_scp_empty:bool = room_extract.scp.is_empty()

				if is_scp_empty:
					menu_actions.push_back({
						"title": "ASSIGN SCP...",
						"onSelect": func() -> void:
							menu_response.emit({"action": ACTION.ROOM_NODE.CONTAIN_SCP})
					})		
				else:
					if room_extract.scp.is_transfer:
						menu_actions.push_back({
							"title": "CANCEL CONTAINMENT" if !room_extract.scp.is_contained else "CANCEL TRANSFER" ,
							"is_disabled": is_testing,
							"onSelect": func() -> void:
								menu_response.emit({"action": ACTION.ROOM_NODE.CANCEL_CONTAIN_SCP if !room_extract.scp.is_contained else ACTION.ROOM_NODE.CANCEL_TRANSFER_SCP})
						})		
					else:
						menu_actions.push_back({
							"title": "TRANSFER TO...",
							"is_disabled": is_testing,
							"onSelect": func() -> void:
								menu_response.emit({"action": ACTION.ROOM_NODE.TRANSFER_SCP})
						})	
						
						var testing:Dictionary = room_extract.scp.testing
						var can_test:bool = room_extract.researchers.size() > 0  
						
						if testing.is_empty():
							menu_actions.push_back({
								"title": "START TESTING",
								"is_disabled": !can_test,
								"onSelect": func() -> void:
									if can_test:
										menu_response.emit({"action": ACTION.ROOM_NODE.START_TESTING})
							})		
						else:
							menu_actions.push_back({
								"title": "END TESTING",
								"onSelect": func() -> void:
									menu_response.emit({"action": ACTION.ROOM_NODE.STOP_TESTING})
							})		
		
		for child in ControlMenuList.get_children():
			child.queue_free()
		
		# keeps place in menu, unless it's over the menu action size
		menu_index = U.min_max(menu_index, 0, menu_actions.size() - 1)
		
		for index in menu_actions.size():
			var item:Dictionary = menu_actions[index]
			var new_btn:BtnBase = TextBtnPreload.instantiate()
			var is_disabled:bool = item.is_disabled if "is_disabled" in item else false
			new_btn.is_hoverable = false
			new_btn.title = item.title
			new_btn.is_disabled = is_disabled
			new_btn.icon = SVGS.TYPE.MEDIA_PLAY if index == menu_index else SVGS.TYPE.NONE
			new_btn.onFocus = func(node:Control) -> void:
				pass
			new_btn.onClick = func(node:Control) -> void:
				pass
			ControlMenuList.add_child(new_btn)
	

	#U.tween_node_property(AccentLights, "rotation:y", 3 if show_menu else 5)	
	GBL.add_to_animation_queue(self)	
	
	if show_menu:
		CursorMenuSprite.global_position = node_location - Vector3(10, -6, 0) 
		CursorMenuSprite.position.z = -2
					
	await U.tween_node_property(CursorMenuSprite, "rotation_degrees:y", 0 if show_menu else 90)
	GBL.remove_from_animation_queue(self)	
	
	if !show_menu:
		for child in ControlMenuList.get_children():
			child.queue_free()		

# --------------------------------------------------------

# ------------------------------------------------
func on_is_powered_update() -> void:
	if !is_node_ready():return
	check_for_lighting_system()
# ------------------------------------------------

# --------------------------------------------------------
func on_in_lockdown_update() -> void:
	if !is_node_ready():return
	check_for_lighting_system()
# --------------------------------------------------------

# --------------------------------------------------------
func on_base_states_update(new_val:Dictionary = base_states) -> void:
	if !is_node_ready():return
	base_states = new_val
	check_for_lighting_system()
# --------------------------------------------------------

# --------------------------------------------------------
func update_status_label() -> void:
	if base_states.is_empty():return
	var status_label:String = ""
	
	# NOT USED CURRENTLY, NOT SURE WHAT TO USE HERE
		
	StatusLabel.text = status_label 
# --------------------------------------------------------

# --------------------------------------------------------
func check_for_lighting_system() -> void:
	if base_states.is_empty():return
	
	if in_lockdown:
		NormalLights.hide() 
		NoPowerLights.hide() 
		EmergencyLights.show() 
		Spotlights.show() 
	else:
		EmergencyLights.hide() 
		Spotlights.hide() 
		
		if base_states.status_effects.in_brownout:
			NoPowerLights.hide() if is_powered else NoPowerLights.show()
			NormalLights.show() if is_powered else NormalLights.hide()	
		
		else:
			NoPowerLights.hide() if is_powered else NoPowerLights.show()
			NormalLights.show() if is_powered else NormalLights.hide()	
# --------------------------------------------------------


# ------------------------------------------------
func on_label_control_subpanel_rect_changed() -> void:
	if !is_node_ready():return
	await U.tick()
	ControlPanelViewport.size = ControlPanelContainer.size
# ------------------------------------------------

# ------------------------------------------------
func on_menu_control_subpanel_rect_changed() -> void:
	if !is_node_ready():return
	await U.tick()
	ControlMenuViewport.size = ControlMenuContainer.size
# ------------------------------------------------

# --------------------------------------------------------
func on_mouse_scroll(dir:int) -> void:
	if !is_node_ready() or GBL.has_animation_in_queue():return
	match dir:
		#UP
		0: 
			current_camera_size = U.min_max(current_camera_size + 1, 0, camera_size_arr.size() -1)
		#DOWN
		1:
			current_camera_size = U.min_max(current_camera_size - 1, 0, camera_size_arr.size() -1)

	GBL.add_to_animation_queue(self)
	await U.tween_node_property(MainCamera, "size", camera_size_arr[current_camera_size], 0.3, 0)
	GBL.remove_from_animation_queue(self)
# --------------------------------------------------------

# ------------------------------------------------
func update_menu_index(inc:int) -> void:
	menu_index = U.min_max(menu_index + inc, 0, menu_actions.size() - 1) 
	for index in ControlMenuList.get_child_count():
		var btn_node:BtnBase = ControlMenuList.get_child(index)
		btn_node.icon = SVGS.TYPE.MEDIA_PLAY if index == menu_index else SVGS.TYPE.NONE
# ------------------------------------------------

# --------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	var GameplayNode:Control = GBL.find_node(REFS.GAMEPLAY_LOOP) # 
	if !is_node_ready() or GBL.has_animation_in_queue() or !show_menu or freeze_input or GameplayNode.is_occupied():return
	var key:String = input_data.key
	var keycode:int = input_data.keycode

	match key:
		"A":
			GBL.add_to_animation_queue(self)
			await U.tween_node_property(CursorMenuSprite, "rotation_degrees:y", 90, 0.2)
			current_menu_type = U.min_max(current_menu_type - 1, 0, 2)
			await U.tween_node_property(CursorMenuSprite, "rotation_degrees:y", 0, 0.2)
			GBL.remove_from_animation_queue(self)
		"D":
			GBL.add_to_animation_queue(self)
			await U.tween_node_property(CursorMenuSprite, "rotation_degrees:y", 90, 0.2)
			current_menu_type = U.min_max(current_menu_type + 1, 0, 2)
			await U.tween_node_property(CursorMenuSprite, "rotation_degrees:y", 0, 0.2)
			GBL.remove_from_animation_queue(self)
			
		"W":
			update_menu_index(-1)

		"S":
			update_menu_index(1)
		
		"E":
			on_select()
		
		"ENTER":
			on_select()
		
		"B":
			on_back()
		
		"BACK":
			on_back()
# --------------------------------------------------------

# --------------------------------------------------------
func on_select() -> void:
	menu_actions[menu_index].onSelect.call()

func on_back() -> void:
	menu_response.emit({"action": ACTION.ROOM_NODE.BACK})
# --------------------------------------------------------

# --------------------------------------------------------
func _process(delta: float) -> void:
	if !is_node_ready() or base_states.is_empty():return
	
	if base_states.status_effects.in_brownout:
		if U.generate_rand(0, 100) < 2:
			NoPowerLights.hide() if NoPowerLights.is_visible_in_tree() else NoPowerLights.show()
		if U.generate_rand(0, 100) < 3:
			NormalLights.hide() if NormalLights.is_visible_in_tree() else NormalLights.show()			
	
	if in_lockdown:
		for child in Spotlights.get_children():
			child.find_child("Spotlight").rotate_x(0.1)
			child.find_child("Spotlight").rotate_y(0.01)
# --------------------------------------------------------
