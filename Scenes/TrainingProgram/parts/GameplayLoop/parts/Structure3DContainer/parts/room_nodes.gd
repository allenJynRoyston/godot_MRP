extends Control

@onready var NodeContainer:Node3D = $SubViewport/RoomColumn/NodeContainer
@onready var Column1:Node3D = $SubViewport/RoomColumn/NodeContainer/column1
@onready var Column2:Node3D = $SubViewport/RoomColumn/NodeContainer/column2
@onready var Column3:Node3D = $SubViewport/RoomColumn/NodeContainer/column3

@onready var ControlPanelViewport:SubViewport = $ControlSubViewport
@onready var ControlPanelContainer:Control = $ControlSubViewport/ControlPanelContainer
@onready var CursorLabel:Label = $ControlSubViewport/ControlPanelContainer/MarginContainer/VBoxContainer/CursorLabel

@onready var ControlMenuViewport:SubViewport = $ControlMenuSubviewport
@onready var ControlMenuContainer:Control = $ControlMenuSubviewport/ControlMenuContainer
@onready var ControlMenuList:VBoxContainer = $ControlMenuSubviewport/ControlMenuContainer/MarginContainer/VBoxContainer/ControlMenuList

@onready var NoPowerLights:Node3D = $SubViewport/RoomColumn/NoPowerLights
@onready var Spotlights:Node3D = $SubViewport/RoomColumn/Spotlights
@onready var NormalLights:Node3D = $SubViewport/RoomColumn/NormalLights
@onready var EmergencyLights:Node3D = $SubViewport/RoomColumn/EmergencyLights

@onready var SpriteLayer:Node3D = $SubViewport/RoomColumn/SpriteLayer
@onready var CursorSprite:Sprite3D = $SubViewport/RoomColumn/SpriteLayer/CursorSprite
@onready var MenuSprite:Sprite3D = $SubViewport/RoomColumn/SpriteLayer/CursorSprite/MenuSprite
@onready var LeftWallLabel:Label3D = $SubViewport/RoomColumn/LeftWallLabel

@onready var StatusLabel:Label3D = $SubViewport/RoomColumn/MainCamera/StatusLabel
@onready var MainCamera:Camera3D = $SubViewport/RoomColumn/MainCamera


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
		show_menu = val
		on_show_menu_update()
		
var freeze_input:bool = false 
var room_config:Dictionary = {}

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var in_lockdown:bool = false : 
	set(val):
		in_lockdown = val
		on_in_lockdown_update()

var is_powered:bool = false : 
	set(val):
		is_powered = val
		on_is_powered_update()

signal menu_response

# --------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	GBL.subscribe_to_mouse_input(self)	
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	GBL.unsubscribe_to_mouse_input(self)
	GBL.unsubscribe_to_control_input(self)

func _ready() -> void:
	on_show_menu_update()
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
	LeftWallLabel.text = "FLOOR %s WING %s" % [assigned_location.floor, assigned_location.ring]
	for child in NodeContainer.get_children():
		for node in child.get_children():
			node.update_refs(assigned_location.floor, assigned_location.ring)
	
	for child in NodeContainer.get_children():
		for node in child.get_children():
			node_refs[node.name] = node
			node_ref_positions[node.name] = node.position
			node.onFocus = func(room_data:Dictionary) -> void:
				CursorSprite.global_position = node.global_position + Vector3(-6.5, 6, -4)
				CursorLabel.text = "EMPTY" if room_data.is_empty() else room_data.name
# --------------------------------------------------------

# ------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
	if !is_node_ready():return
# ------------------------------------------------


# ------------------------------------------------
func on_show_menu_update() -> void:
	if show_menu:
		if is_powered:
			menu_index = 0
			menu_actions = []
			
			var room_config_data:Dictionary = room_config.floor[assigned_location.floor].ring[assigned_location.ring].room[current_location.room]
			var can_purchase:bool = room_config_data.build_data.is_empty() and room_config_data.room_data.is_empty()
			var room_under_construction:bool = !room_config_data.build_data.is_empty()
			var room_can_be_cleared:bool = !room_config_data.room_data.is_empty()

			# ------------------- CONVERT, CANCEL OR REMOVE ROOM
			if can_purchase:
				menu_actions.push_back({
					"title": "CONVERT ROOM",
					"onSelect": func() -> void:
						menu_response.emit({"action": ACTION.ROOM_NODE.OPEN_STORE})
				})
			
			if room_under_construction:
				menu_actions.push_back({
					"title": "CANCEL CONSTRUCTION",
					"onSelect": func() -> void:
						menu_response.emit({"action": ACTION.ROOM_NODE.CANCEL_CONSTRUCTION})
				})
			
			if room_can_be_cleared:
				menu_actions.push_back({
					"title": "REMOVE ROOM",
					"onSelect": func() -> void:
						menu_response.emit({"action": ACTION.ROOM_NODE.RESET_ROOM})
				})
			# -------------------
			
			# -------------------
			if !room_config_data.room_data.is_empty():
				var room_details:Dictionary = ROOM_UTIL.return_data(room_config_data.room_data.ref)
				var can_be_activated:bool = "activation_cost" in room_details
				var can_store_scp:bool = room_details.can_contain
				var is_activated:bool = room_config_data.room_data.get_is_activated.call()
				#var is_scp_empty:bool = room_config.scp_data.is_empty()
				
				if can_be_activated:
					var is_disabled:bool = !RESOURCE_UTIL.check_if_have_enough(ROOM_UTIL.return_activation_cost(room_config_data.room_data.ref), resources_data) if !is_activated else false
				
					menu_actions.push_back({
						"title": "DEACTIVATED ROOM" if is_activated else "ACTIVATED ROOM",
						"is_disabled": is_disabled,
						"onSelect": func() -> void:
							if !is_disabled:
								menu_response.emit({
									"action": ACTION.ROOM_NODE.ACTIVATE_ROOM if !is_activated else ACTION.ROOM_NODE.DEACTIVATE_ROOM
								})
							pass
					})
					
			# -------------------
		
		# -------------------
		menu_actions.push_back({
			"title": "BACK", 
			"onSelect": func() -> void:
				menu_response.emit({"action": ACTION.ROOM_NODE.BACK})
		})
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
	
	else:
		for child in ControlMenuList.get_children():
			child.queue_free()		
		
	
	GBL.add_to_animation_queue(self)
	await U.tween_node_property(CursorSprite, "rotation_degrees:y", 270 if !show_menu else 175, 0.2 if show_menu else 0)
	GBL.remove_from_animation_queue(self)	
# ------------------------------------------------

# ------------------------------------------------
func on_is_powered_update() -> void:
	if !is_node_ready():return
	check_for_lighting_system()
	
	StatusLabel.text = "NOT POWERED" if !is_powered else ""
# ------------------------------------------------

# --------------------------------------------------------
func on_in_lockdown_update() -> void:
	if !is_node_ready():return
	check_for_lighting_system()
# --------------------------------------------------------

# --------------------------------------------------------
func check_for_lighting_system() -> void:
	if in_lockdown:
		NormalLights.hide() 
		NoPowerLights.hide() 
		EmergencyLights.show() 
		Spotlights.show() 
	else:
		EmergencyLights.hide() 
		Spotlights.hide() 
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
	if !is_node_ready() or GBL.has_animation_in_queue() or !show_menu or freeze_input:return
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
	if !is_node_ready():return
	
	if in_lockdown:
		for child in Spotlights.get_children():
			child.find_child("Spotlight").rotate_x(0.1)
			child.find_child("Spotlight").rotate_y(0.01)
# --------------------------------------------------------
