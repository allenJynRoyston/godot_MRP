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

@onready var RoomNameLabel:Label = $ControlSubViewport/ControlPanelContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/RoomNameLabel
@onready var RoomStatusLabel:Label = $ControlSubViewport/ControlPanelContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/RoomStatusLabel

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

var current_location:Dictionary = {} 
var resources_data:Dictionary = {} 

var previous_floor:int = -1
var previous_ring:int = -1

var is_setup:bool = false
var node_refs:Dictionary = {}
var node_ref_positions:Dictionary = {}

var camera_size_arr:Array = [20, 24, 28, 32, 36]
var current_camera_size:int = 0 

var menu_index:int = 0
var menu_actions:Array = []
var show_menu:bool = false : 
	set(val):
		if show_menu != val:
			show_menu = val
			on_show_menu_update()
		
var freeze_input:bool = false 

var room_config:Dictionary = {}
var room_config_data:Dictionary = {}
var can_purchase:bool
var room_under_construction:bool 
var has_room:bool
var has_scp_in_room:bool
var room_details:Dictionary 
var is_activated:bool
var is_disabled:bool 
var scp_data:Dictionary 
var can_store_scp:bool
var scp_details:Dictionary

var no_scp_data:bool 
var is_transfer:bool 
var is_contained:bool 
		
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

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)
	GBL.unsubscribe_to_mouse_input(self)
	GBL.unsubscribe_to_control_input(self)

func _ready() -> void:
	on_label_control_subpanel_rect_changed()
	on_menu_control_subpanel_rect_changed()
	on_in_lockdown_update()
	on_assigned_location_update()
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
	
	room_config_data = room_config.floor[assigned_location.floor].ring[assigned_location.ring].room[current_location.room]
	can_purchase = room_config_data.build_data.is_empty() and room_config_data.room_data.is_empty()
	room_under_construction = !room_config_data.build_data.is_empty()
	has_room = !room_config_data.room_data.is_empty()
	has_scp_in_room = false	

	# has room check
	room_details = room_config_data.room_data.get_room_details.call() if has_room else {}
	is_activated = room_config_data.room_data.get_is_activated.call() if has_room else false
	is_disabled = (!RESOURCE_UTIL.check_if_have_enough(ROOM_UTIL.return_activation_cost(room_config_data.room_data.ref), resources_data) if !is_activated else false) if has_room else false
	scp_data = room_config_data.scp_data if has_room else {}	
	can_store_scp = room_details.can_contain if has_room else false
	scp_details = (room_config_data.scp_data.get_scp_details.call() if !scp_data.is_empty() else {}) if has_room else {}
	
	# can store scp check
	no_scp_data = scp_data.is_empty() if can_store_scp else true
	is_transfer = (false if no_scp_data else room_config_data.scp_data.is_transfer) if can_store_scp else false
	is_contained = (false if no_scp_data else room_config_data.scp_data.is_contained) if can_store_scp else false
	
	on_assigned_location_update()
	on_show_menu_update()
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
	LeftWallLabel.text = "FLOOR %s WING %s" % [assigned_location.floor, assigned_location.ring]
	for child in NodeContainer.get_children():
		for node in child.get_children():
			node.update_refs(assigned_location.floor, assigned_location.ring)

	for child in NodeContainer.get_children():
		for node in child.get_children():
			node_refs[node.name] = node
			node_ref_positions[node.name] = node.position

			node.onBlur = func(room_data:Dictionary) -> void:
				if node.position.y != 0:
					U.tween_node_property(node, "position:y", 0)
					node.show_internal = false
				
			node.onFocus = func(room_data:Dictionary) -> void:
				if node.position.y != 2.5:
					U.tween_node_property(node, "position:y", 2.5)
				RoomNameLabel.text = "EMPTY" if room_data.is_empty() else room_data.name				
				RoomStatusLabel.text = "inactive"
				CursorMenuSprite.global_position = node.global_position - Vector3(9, -4, 0) 
				CursorMenuSprite.position.z = -2

				
	
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

# ------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
	if !is_node_ready():return
# ------------------------------------------------

# ------------------------------------------------
func on_show_menu_update() -> void:
	if current_location.is_empty(): return
	var node:Node3D = node_refs[str(current_location.room)]		
	node.show_internal = show_menu
	
	if show_menu:
		menu_index = 0
		menu_actions = []
		menu_actions.push_back({
			"title": "BACK", 
			"onSelect": func() -> void:
				menu_response.emit({"action": ACTION.ROOM_NODE.BACK})
		})
				
		if is_powered:
			# ------------------- CONVERT, CANCEL OR REMOVE ROOM
			if can_purchase:
				menu_actions.push_back({
					"title": "CREATE ROOM...",
					"onSelect": func() -> void:
						menu_response.emit({"action": ACTION.ROOM_NODE.OPEN_STORE})
				})
			
			if room_under_construction:
				menu_actions.push_back({
					"title": "CANCEL CONSTRUCTION",
					"onSelect": func() -> void:
						menu_response.emit({"action": ACTION.ROOM_NODE.CANCEL_CONSTRUCTION})
				})
			# -------------------
			
			# -------------------
			if has_room:
				if !scp_details.is_empty():
					is_disabled = true 	
					has_scp_in_room = true

				menu_actions.push_back({
					"title": "DEACTIVATE ROOM" if is_activated else "ACTIVATE ROOM",
					"is_disabled": is_disabled,
					"onSelect": func() -> void:
						if is_disabled:return
						menu_response.emit({
							"action": ACTION.ROOM_NODE.ACTIVATE_ROOM if !is_activated else ACTION.ROOM_NODE.DEACTIVATE_ROOM
						})
				})				
								

				if can_store_scp:

					if is_transfer:
						menu_actions.push_back({
							"title": "CANCEL CONTAINMENT" if !is_contained else "CANCEL TRANSFER",
							"onSelect": func() -> void:
								menu_response.emit({
									"action": ACTION.ROOM_NODE.CANCEL_CONTAIN_SCP if !is_contained else ACTION.ROOM_NODE.CANCEL_TRANSFER_SCP
								})
						})
						
					
					menu_actions.push_back({
						"title": "CONTAIN SCP..." if no_scp_data else "TRANSFER %s" % [scp_details.name],
						"onSelect": func() -> void:
							menu_response.emit({
								"action": ACTION.ROOM_NODE.CONTAIN_SCP if no_scp_data else ACTION.ROOM_NODE.TRANSFER_SCP
							})
					})
						
					if is_contained:
						var has_researcher_attached:bool = !room_config_data.scp_data.get_researcher_details.call().is_empty()
						menu_actions.push_back({
							"title": "ASSIGN RESEARCHER" if !has_researcher_attached else "REMOVE RESEARCHER",
							"onSelect": func() -> void:
								menu_response.emit({
									"action": ACTION.ROOM_NODE.REMOVE_RESEARCHER if has_researcher_attached else ACTION.ROOM_NODE.ASSIGN_RESEARCHER
								})
						})
					
						if has_researcher_attached:
							var has_testing_details:bool = !room_config_data.scp_data.get_testing_details.call().is_empty()
							menu_actions.push_back({
								"title": "START TESTING" if !has_testing_details else "END TESTING",
								"onSelect": func() -> void:
									menu_response.emit({
										"action": ACTION.ROOM_NODE.STOP_TESTING if has_testing_details else ACTION.ROOM_NODE.START_TESTING
									})
							})						

			if has_room:
				menu_actions.push_back({
					"title": "DESTROY ROOM",
					"is_disabled": has_scp_in_room,
					"onSelect": func() -> void:
						if !has_scp_in_room:
							menu_response.emit({"action": ACTION.ROOM_NODE.RESET_ROOM})
				})
					
			# -------------------
		
		# -------------------

		#else:
			#menu_actions = [
				#{
					#"title": "INVESTIGATE",
					#"onSelect": func():
						#show_menu = false
						#menu_response.emit({"action": ACTION.STRUCTURE.GOTO_FLOOR}),
						#
				#},
				#{
					#"title": "ACTIVATE FLOOR",
					#"onSelect": func():
						#menu_response.emit({"action": ACTION.STRUCTURE.ACTIVATE_FLOOR}),
				#}
			#]
		
		
		for child in ControlMenuList.get_children():
			child.queue_free()
			
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
	

	GBL.add_to_animation_queue(self)
	await U.set_timeout(0.05)

	#CursorMenuSprite.offset.y = -(ControlMenuViewport.size.y/2) - 35

	#U.tween_node_property(AccentLights, "rotation:y", 3 if show_menu else 5)	
	await U.tween_node_property(CursorMenuSprite, "rotation_degrees:x", 0 if show_menu else 90)
	
	if !show_menu:
		for child in ControlMenuList.get_children():
			child.queue_free()		
			

	GBL.remove_from_animation_queue(self)	
# ------------------------------------------------

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
