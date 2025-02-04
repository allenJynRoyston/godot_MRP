extends Node3D

@onready var SpriteLayer:Node3D = $SpriteLayer
@onready var ControlSubViewport:SubViewport = $ControlSubViewport
@onready var ControlPanelContainer:PanelContainer = $ControlSubViewport/ControlPanelContainer
@onready var ControlMenuSubViewport:SubViewport = $ControlMenuSubViewport
@onready var ControlMenuContainer:PanelContainer = $ControlMenuSubViewport/ControlMenuContainer
@onready var ControlMenuList:VBoxContainer = $ControlMenuSubViewport/ControlMenuContainer/MarginContainer/VBoxContainer/ControlMenuList

@onready var FloorScene:Node3D = $FloorScene
@onready var FloorInstance:MeshInstance3D = $FloorScene/FloorInstance
@onready var FloorInstanceContainer:Node3D = $FloorScene/FloorInstanceContainer

@onready var RoomScene:Node3D = $RoomScene
@onready var RoomInstance:MeshInstance3D = $RoomScene/RoomInstance
@onready var RoomColumnContainer:Node3D = $RoomScene/RoomColumnContainer
@onready var CursorLabel:Label = $ControlSubViewport/ControlPanelContainer/MarginContainer/VBoxContainer/CursorLabel
#
@onready var ActiveCamera:Camera3D = $CameraContainers/ActiveCamera
@onready var FloorPlaceholderCamera:Camera3D = $CameraContainers/FloorPlaceholderCamera
@onready var RoomPlaceholderCamera:Camera3D = $CameraContainers/RoomPlaceholderCamera

@onready var RoomNodeSprite:Sprite3D = $RoomScene/RoomNodeContainer/Sprite3D
@onready var RoomNode:Control = $RoomScene/RoomNodeContainer/Sprite3D/SubViewport/RoomNode
@onready var SCPList:VBoxContainer = $ControlSubViewport/ControlPanelContainer/MarginContainer/VBoxContainer/SCPList

@onready var ControlLayerSprite:Sprite3D = $SpriteLayer/ControlLayerSprite
@onready var ControlMenuSprite:Sprite3D = $SpriteLayer/ControlMenuSprite

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")
const RoomMaterialActive:StandardMaterial3D = preload("res://Materials/RoomMaterialUnderConstruction.tres")
const RoomMaterialInactive:StandardMaterial3D = preload("res://Materials/RoomMaterialInactive.tres")
#const RoomMaterialUnavailable:StandardMaterial3D = preload("res://Materials/RoomMaterialUnavailable.tres")
#const RoomMaterialActiveUnavailable:StandardMaterial3D = preload("res://Materials/RoomMaterialActiveUnavailable.tres")
#const RoomMaterialUnderConstruction:StandardMaterial3D = preload("res://Materials/RoomMaterialUnderConstruction.tres")
#const RoomMaterialBuilt:StandardMaterial3D = preload("res://Materials/RoomMaterialBuilt.tres")

var room_config:Dictionary = {}
var camera_settings:Dictionary = {} 
var current_location:Dictionary = {} 
var setup_complete:bool = false
var previous_grid_size:Vector2
var previous_location_data:String = "" 
var previous_floor:int = -1
var previous_ring:int = -1
var room_nodes:Dictionary = {}

var menu_index:int = 0
var menu_actions:Array = []
var show_menu:bool = false : 
	set(val):
		show_menu = val
		on_show_menu_update()

var freeze_input:bool = false 
var default_positions:Dictionary = {}
var previous_camera_type:int = -1 

signal animate_next_complete
signal menu_response

# ------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	SUBSCRIBE.subscribe_to_unavailable_rooms(self)
	SUBSCRIBE.subscribe_to_under_construction_rooms(self)
	SUBSCRIBE.subscribe_to_built_rooms(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	GBL.subscribe_to_process(self)
	GBL.subscribe_to_control_input(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)	
	SUBSCRIBE.unsubscribe_to_unavailable_rooms(self)
	SUBSCRIBE.unsubscribe_to_under_construction_rooms(self)
	SUBSCRIBE.unsubscribe_to_built_rooms(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	GBL.unsubscribe_to_process(self)
	GBL.unsubscribe_to_control_input(self)	
	
func _ready() -> void:
	_on_panel_container_item_rect_changed()
	on_show_menu_update()
	assign_room_node_location(0, 0, false)
# ------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return
	if !setup_complete:
		setup_complete = true
		build_floors()
	update_floor_content_labels()
# --------------------------------------------------------------------------------------------------

# ------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	update_cameras()
	update_floor_content_labels()
# ------------------------------------------------

# ------------------------------------------------
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
	if previous_camera_type != camera_settings.type:
		previous_camera_type = camera_settings.type
		await update_cameras()
		
		GBL.add_to_animation_queue(self)
		
		match camera_settings.type:
			CAMERA.TYPE.FLOOR_SELECT:
				await U.tween_node_property(ActiveCamera, "size", 0, 0.3 )
				await U.set_timeout(0.3)
				ActiveCamera.rotation = FloorPlaceholderCamera.rotation
				ActiveCamera.position = FloorPlaceholderCamera.position
				await U.tween_node_property(ActiveCamera, "size", FloorPlaceholderCamera.size, 0.3)	
							
			CAMERA.TYPE.ROOM_SELECT:
				await U.tween_node_property(ActiveCamera, "size", 0, 0.3 )
				await U.set_timeout(0.3)
				ActiveCamera.rotation = RoomPlaceholderCamera.rotation
				ActiveCamera.position = RoomPlaceholderCamera.position
				await U.tween_node_property(ActiveCamera, "size", RoomPlaceholderCamera.size, 0.3)	

			
		GBL.remove_from_animation_queue(self)
# ------------------------------------------------

# ------------------------------------------------
func update_floor_content_labels() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return 
	var floor_data:Dictionary = room_config.floor[current_location.floor]
	for child in SCPList.get_children():
		child.queue_free()
	
	for ref in floor_data.scp_refs:
		var scp_details:Dictionary = SCP_UTIL.return_data(ref)
		var new_node:Control = TextBtnPreload.instantiate()
		new_node.is_hoverable = false
		new_node.title = scp_details.name
		SCPList.add_child(new_node)
# ------------------------------------------------

# ------------------------------------------------
func on_show_menu_update() -> void:
	if show_menu:
		menu_index = 0
		menu_actions = []
		
		menu_actions.push_back({
			"title": "INVESTIGATE",
			"onSelect": func() -> void:
				show_menu = false
				menu_response.emit({"action": ACTION.STRUCTURE.GOTO_FLOOR})
		})
		
		if room_config.floor[current_location.floor].is_powered:
			menu_actions.push_back({
					"title": "UPGRADE",
					"onSelect": func() -> void:
						menu_response.emit({"action": ACTION.STRUCTURE.OPEN_STORE}),
			})
			
			menu_actions.push_back({
				"title": "INITIATE LOCKDOWN" if !room_config.floor[current_location.floor].in_lockdown else "REMOVE LOCKDOWN",
				"onSelect": func() -> void:
					menu_response.emit({"action": ACTION.STRUCTURE.LOCKDOWN})
					on_back()
			})
			
		else:
			menu_actions.push_back({
					"title": "ACTIVATE FLOOR",
					"onSelect": func():
						menu_response.emit({"action": ACTION.STRUCTURE.ACTIVATE_FLOOR})
			})

		menu_actions.push_back({
			"title": "BACK", 
			"onSelect": func() -> void:
				on_back()
		})
		
		for child in ControlMenuList.get_children():
			child.queue_free()
		
		for index in menu_actions.size():
			var item:Dictionary = menu_actions[index]
			var new_btn:BtnBase = TextBtnPreload.instantiate()
			new_btn.is_hoverable = false
			new_btn.title = item.title
			new_btn.icon = SVGS.TYPE.MEDIA_PLAY if index == menu_index else SVGS.TYPE.NONE
			new_btn.onFocus = func(node:Control) -> void:
				pass
			new_btn.onClick = func(node:Control) -> void:
				pass
			ControlMenuList.add_child(new_btn)	
			
	GBL.add_to_animation_queue(self)
	if show_menu:
		await U.tween_node_property(ControlLayerSprite, "rotation_degrees:y", -90 if show_menu else 0, 0.2)
		await U.tween_node_property(ControlMenuSprite, "rotation_degrees:y", 0 if show_menu else 90, 0.2)	
	else:
		await U.tween_node_property(ControlMenuSprite, "rotation_degrees:y", 0 if show_menu else 90, 0.2)
		await U.tween_node_property(ControlLayerSprite, "rotation_degrees:y", -90 if show_menu else 0, 0.2)
	if !show_menu:
		menu_actions = []
		for child in ControlMenuList.get_children():
			child.queue_free()			
	GBL.remove_from_animation_queue(self)	
# ------------------------------------------------

# ------------------------------------------------
func update_menu_index(inc:int) -> void:
	menu_index = U.min_max(menu_index + inc, 0, menu_actions.size() - 1) 
	for index in ControlMenuList.get_child_count():
		var btn_node:BtnBase = ControlMenuList.get_child(index)
		btn_node.icon = SVGS.TYPE.MEDIA_PLAY if index == menu_index else SVGS.TYPE.NONE
# ------------------------------------------------

# ------------------------------------------------
func assign_room_node_location(floor_val:int, ring_val:int, animate:bool) -> void:
	GBL.add_to_animation_queue(self)
	
	if animate:
		U.tween_node_property(ActiveCamera, "size", 1, 0.2)
		await U.tween_node_property(RoomNodeSprite, "scale:x", 0, 0.2)

		
	RoomNode.assigned_location = {"floor": floor_val, "ring": ring_val}
	
	if animate:
		await U.set_timeout(0.1)
		U.tween_node_property(ActiveCamera, "size", RoomPlaceholderCamera.size, 0.2)
		await U.tween_node_property(RoomNodeSprite, "scale:x", 1, 0.2)
	
	if !animate:
		await U.tick()
		
	GBL.remove_from_animation_queue(self)	
	animate_next_complete.emit()
# ------------------------------------------------

# ------------------------------------------------
func update_cameras() -> void:
	if !is_node_ready() or camera_settings.is_empty() or FloorInstanceContainer.get_child_count() == 0:return	

	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			CursorLabel.text = ">> FLOOR %s" % [current_location.floor]
			if previous_floor != current_location.floor:
				previous_floor = current_location.floor
				assign_room_node_location(current_location.floor, current_location.ring, false)
				for index in FloorInstanceContainer.get_child_count():
					var floor_node:MeshInstance3D = FloorInstanceContainer.get_child(index)
					var mesh_duplicate = floor_node.mesh.duplicate()
					var material_copy:StandardMaterial3D = RoomMaterialActive.duplicate() if index == current_location.floor else RoomMaterialInactive.duplicate()
					material_copy.albedo_color = material_copy.albedo_color.lerp(Color(0, 0, 0), 0.5)
					mesh_duplicate.material = material_copy		
					floor_node.mesh = mesh_duplicate	
					

				GBL.add_to_animation_queue(self)
				await U.tween_node_property(SpriteLayer, "position", FloorInstanceContainer.get_child(current_location.floor).position, 0.2)	
				GBL.remove_from_animation_queue(self)			
		
		CAMERA.TYPE.ROOM_SELECT:
			if previous_ring != current_location.ring or previous_floor != current_location.floor:
				previous_ring = current_location.ring
				previous_floor = current_location.floor
				assign_room_node_location(current_location.floor, current_location.ring, true)
				
# ------------------------------------------------

# ------------------------------------------------
func build_floors() -> void:
	for n in range(room_config.floor.size() ):
		var floor_duplicate:MeshInstance3D = FloorInstance.duplicate()
		floor_duplicate.show()
		floor_duplicate.position.y = n * -10
		FloorInstanceContainer.add_child(floor_duplicate)
# ------------------------------------------------

# ------------------------------------------------
func on_process_update(delta: float) -> void:	
	if !is_node_ready():return
# ------------------------------------------------

# ------------------------------------------------
func _on_panel_container_item_rect_changed() -> void:
	if !is_node_ready():return
	await U.tick()
	ControlSubViewport.size = ControlPanelContainer.size
# ------------------------------------------------

# ------------------------------------------------
func _on_control_menu_container_item_rect_changed() -> void:
	if !is_node_ready():return
	await U.tick()
	ControlMenuSubViewport.size = ControlMenuContainer.size
# ------------------------------------------------

# ------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	var GameplayNode:Control = GBL.find_node(REFS.GAMEPLAY_LOOP) # 
	
	if !is_visible_in_tree() or current_location.is_empty() or GBL.has_animation_in_queue() or !show_menu or freeze_input or GameplayNode.is_occupied():return
	
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
# ------------------------------------------------	

# ------------------------------------------------	
func on_select() -> void:
	menu_actions[menu_index].onSelect.call()

func on_back() -> void:
	menu_response.emit({"action": ACTION.STRUCTURE.BACK})
# ------------------------------------------------	
