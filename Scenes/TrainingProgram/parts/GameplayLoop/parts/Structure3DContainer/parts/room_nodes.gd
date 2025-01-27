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
@onready var Spotlights:Node3D = $SubViewport/RoomColumn/Spotlights
@onready var NormalLights:Node3D = $SubViewport/RoomColumn/NormalLights
@onready var EmergencyLights:Node3D = $SubViewport/RoomColumn/EmergencyLights

@onready var SpriteLayer:Node3D = $SubViewport/RoomColumn/SpriteLayer
@onready var CursorSprite:Sprite3D = $SubViewport/RoomColumn/SpriteLayer/CursorSprite
@onready var MenuSprite:Sprite3D = $SubViewport/RoomColumn/SpriteLayer/CursorSprite/MenuSprite

@onready var MainCamera:Camera3D = $SubViewport/RoomColumn/MainCamera

@export var assigned_wing:int = 0

var current_location:Dictionary = {} 

var previous_floor:int = -1
var previous_ring:int = -1

var is_setup:bool = false
var node_refs:Dictionary = {}
var node_ref_positions:Dictionary = {}

var camera_size_arr:Array = [20, 24, 28, 32, 36]
var current_camera_size:int = 0 

var show_menu:bool = false : 
	set(val):
		show_menu = val
		on_show_menu_update()
		

@export var has_containment_breach:bool = false : 
	set(val):
		has_containment_breach = val
		on_has_containment_breach_update()

# --------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	GBL.subscribe_to_mouse_input(self)	
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	GBL.unsubscribe_to_mouse_input(self)
	GBL.unsubscribe_to_control_input(self)

func _ready() -> void:
	on_current_location_update()
	on_show_menu_update()
	on_label_control_subpanel_rect_changed()
	on_menu_control_subpanel_rect_changed()
	on_has_containment_breach_update()
# --------------------------------------------------------

# --------------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	
	if !is_setup:
		is_setup = true
		update_refs(true)
	else:
		# wait for changes, assign new floor
		if previous_floor != current_location.floor or previous_ring != current_location.ring:
			previous_floor = current_location.floor
			previous_ring = current_location.ring
			
			#for node in [Column1, Column2, Column3]:
				#node.position.y = 0
			
			#tween_property(Column3, "position:y", -0.25)
			#tween_property(Column1, "position:y", 0.25)
			
			
			update_refs()
	
	on_has_containment_breach_update()
# --------------------------------------------------------

# --------------------------------------------------------
func update_refs(setup:bool = false) -> void:
	for child in NodeContainer.get_children():
		for node in child.get_children():
			node.update_refs(current_location.floor, assigned_wing)
	
	if setup:
		for child in NodeContainer.get_children():
			for node in child.get_children():
				node_refs[node.name] = node
				node_ref_positions[node.name] = node.position
				node.onFocus = func(room_data:Dictionary) -> void:
					CursorSprite.global_position = node.global_position + Vector3(-6.5, 6, -4)
					CursorLabel.text = "EMPTY" if room_data.is_empty() else room_data.name
				node.onBlur = func() -> void:
					pass
# --------------------------------------------------------

# --------------------------------------------------------
func on_show_menu_update() -> void:
	GBL.add_to_animation_queue(self)
	await tween_property(CursorSprite, "rotation_degrees:y", 270 if !show_menu else 175, 0.2 if show_menu else 0.2)
	GBL.remove_from_animation_queue(self)
# --------------------------------------------------------

# --------------------------------------------------------
func on_has_containment_breach_update() -> void:
	if !is_node_ready() or current_location.is_empty():return
	
	if current_location.ring != assigned_wing:
		NormalLights.hide()
		EmergencyLights.hide()
		Spotlights.hide()
		return
	else:
		NormalLights.show()
		EmergencyLights.show()
		Spotlights.show()
		
	for child in Spotlights.get_children():
		var OmniLightNode:OmniLight3D = child.find_child("OmniLight3D")
		var SpotlightNode:SpotLight3D = child.find_child("Spotlight")
		OmniLightNode.show() if has_containment_breach else OmniLightNode.hide()
		SpotlightNode.show() if has_containment_breach else SpotlightNode.hide()
		
	NormalLights.hide() if has_containment_breach else NormalLights.show()
	EmergencyLights.show() if has_containment_breach else EmergencyLights.hide()
# --------------------------------------------------------

# ------------------------------------------------
func tween_property(node:Node3D, property:String, new_val, duration:float = 0.3, delay:float = 0.3) -> void:
	var tween_pos:Tween = create_tween()
	tween_pos.tween_property(node, property, new_val, duration).set_trans(Tween.TRANS_SINE).set_delay(delay)
	await tween_pos.finished
# ------------------------------------------------

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
	if !is_node_ready() or GBL.has_animation_in_queue() or current_location.ring != assigned_wing:return
	match dir:
		#UP
		0: 
			current_camera_size = U.min_max(current_camera_size + 1, 0, camera_size_arr.size() -1)
		#DOWN
		1:
			current_camera_size = U.min_max(current_camera_size - 1, 0, camera_size_arr.size() -1)

	GBL.add_to_animation_queue(self)
	await tween_property(MainCamera, "size", camera_size_arr[current_camera_size], 0.3, 0)
	GBL.remove_from_animation_queue(self)
# --------------------------------------------------------

# --------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or GBL.has_animation_in_queue() or current_location.ring != assigned_wing:return
	var key:String = input_data.key
	var keycode:int = input_data.keycode

	match key:
		#"ENTER":
			#on_next_day()
		"BACKSPACE":
			show_menu = false
		"B":
			show_menu = false
		"E":
			show_menu = !show_menu
			#open_researchers()
		#"R":
			#open_recruit()
		#"C":
			#open_contain()
# --------------------------------------------------------

# --------------------------------------------------------
func _process(delta: float) -> void:
	if !is_node_ready():return
	
	if has_containment_breach:
		for child in Spotlights.get_children():
			child.find_child("Spotlight").rotate_x(0.1)
			child.find_child("Spotlight").rotate_y(0.01)
# --------------------------------------------------------
