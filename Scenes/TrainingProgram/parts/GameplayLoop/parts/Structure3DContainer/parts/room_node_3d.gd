extends Node3D

@onready var PreviewCamera:Camera3D = $PreviewCamera
@onready var MainMesh:MeshInstance3D = $RoomNode/MainMesh
@onready var MeshOutline:MeshInstance3D = $RoomNode/MeshOutline

@onready var RoomNode:Node3D = $RoomNode
@onready var FrontLeftPanel:Sprite3D = $RoomNode/MainMesh/FrontLeftPanel
@onready var FrontRightPanel:Sprite3D = $RoomNode/MainMesh/FrontRightPanel
@onready var InsidePanel:Sprite3D = $RoomNode/MainMesh/InsidePanel

@onready var FrontLeftPanelLabel:Label = $RoomNode/FrontLeftPanelViewport/PanelContainer/MarginContainer/VBoxContainer/Label
@onready var FrontLeftPanelLabel2:Label = $RoomNode/FrontLeftPanelViewport/PanelContainer/MarginContainer/VBoxContainer/Label2
@onready var TopPanelLabel:Label = $RoomNode/TopPanelViewport/PanelContainer/MarginContainer/Label
@onready var TopPanelLabel2:Label = $RoomNode/TopPanelViewport/PanelContainer/MarginContainer/Label2
@onready var InsideTextureRect:TextureRect = $RoomNode/InsideViewport/PanelContainer/TextureRect

enum STATES { NONE, ACTIVE, INACTIVE, UNAVAILABLE }

enum SIDES {LEFT, RIGHT, NEUTRAL}

enum APPLY_TEXTURE { NONE, BUILT, UNDER_CONSTRUCTION }

const RoomMaterialActive:StandardMaterial3D = preload("res://Materials/RoomMaterialActive.tres")
const RoomMaterialInactive:StandardMaterial3D = preload("res://Materials/RoomMaterialInactive.tres")
const RoomMaterialUnderConstruction:StandardMaterial3D = preload("res://Materials/RoomMaterialUnderConstruction.tres")
#const RoomMaterialUnavailable:StandardMaterial3D = preload("res://Materials/RoomMaterialUnavailable.tres")
#const RoomMaterialActiveUnavailable:StandardMaterial3D = preload("res://Materials/RoomMaterialActiveUnavailable.tres")
#const RoomMaterialUnderConstruction:StandardMaterial3D = preload("res://Materials/RoomMaterialUnderConstruction.tres")
const RoomMaterialBuilt:StandardMaterial3D = preload("res://Materials/RoomMaterialBuilt.tres")

@export var show_internal:bool = false : 
	set(val):
		show_internal = val
		on_show_internal_update()

@export var current_state:STATES = STATES.NONE : 
	set(val):
		current_state = val
		on_current_state_update()
		
@export var show_side:SIDES = SIDES.NEUTRAL : 
	set(val):
		show_side = val
		on_show_side_update()

@export var apply_texture:APPLY_TEXTURE = APPLY_TEXTURE.NONE : 
	set(val):
		apply_texture = val
		on_apply_texture_update()

@export var ref_index:int  = -1 : 
	set(val):
		ref_index = val
		on_ref_index_update()
		
@export var opacity:float  = 1.0 

var onBlur:Callable = func(_room_data:Dictionary):pass
var onFocus:Callable = func():pass

var assigned_floor:int = 0
var assigned_wing:int = 0
var previous_floor:int = -1

var room_data:Dictionary = {} 


var default_position:Dictionary = {}
var unavailable_rooms:Array = []
var current_location:Dictionary = {} 
var room_config:Dictionary = {} 
var previous_show_side:SIDES
var is_focused:bool = false : 
	set(val):
		is_focused = val
		on_is_focused_update()

var current_ref:String
var room_ref:String 
var is_unavailable:bool = false
var previous_room:int 
var sister_nodes:Array = []

# ---------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_unavailable_rooms(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	GBL.subscribe_to_control_input(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_unavailable_rooms(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	GBL.unsubscribe_to_control_input(self)

func _ready() -> void:
	default_position["room_node_rotation"] = RoomNode.rotation
	default_position["room_node_position"] = RoomNode.position
	
	on_current_state_update()
	on_show_side_update()
	on_show_internal_update()
	on_ref_index_update()
	on_apply_texture_update()
	build_room_details()
	
# ---------------------------------------------------

# ---------------------------------------------------
func on_current_state_update() -> void:
	if !is_node_ready():return
	var new_color:Color = Color.WHITE
	var mesh_outline:StandardMaterial3D = MeshOutline.get_surface_override_material(0).duplicate()

	match current_state:
		STATES.NONE:
			new_color = Color.TRANSPARENT
		STATES.ACTIVE:
			new_color = Color(1, 1, 1, 1) if !is_unavailable else  Color(0.66, 0, 0, 1)
		STATES.INACTIVE:
			new_color = Color(0, 0, 0, 1)
		STATES.UNAVAILABLE:
			new_color = Color(0.66, 0, 0, 1)
	
	mesh_outline.albedo_color = new_color
	MeshOutline.set_surface_override_material(0, mesh_outline)
# ---------------------------------------------------

# ---------------------------------------------------
func on_apply_texture_update() -> void:
	if !is_node_ready():return
	var mesh_duplicate = MainMesh.mesh.duplicate()
	var material_copy
	
	match apply_texture:
		APPLY_TEXTURE.UNDER_CONSTRUCTION:
			material_copy = RoomMaterialUnderConstruction.duplicate() 
		APPLY_TEXTURE.BUILT:
			material_copy = RoomMaterialBuilt.duplicate() 
		_:
			material_copy = RoomMaterialInactive.duplicate() 

	if material_copy != null:
		mesh_duplicate.material = material_copy		
		MainMesh.mesh = mesh_duplicate	
# ---------------------------------------------------


# ---------------------------------------------------
func _on_panel_container_item_rect_changed() -> void:
	if !is_node_ready():return
	#await U.tick()
	#CursorViewport.size = CursorViewportPanel.size
# ---------------------------------------------------

# ---------------------------------------------------
func on_show_internal_update() -> void:
	if !is_node_ready():return
	MainMesh.mesh.flip_faces = show_internal
	FrontLeftPanel.show() if !show_internal else FrontLeftPanel.hide()
	FrontRightPanel.show() if !show_internal else FrontRightPanel.hide()
# ---------------------------------------------------

# ---------------------------------------------------
func on_ref_index_update() -> void:
	if !is_node_ready():return
	pass
# ---------------------------------------------------

# ---------------------------------------------------
func update_refs(floor:int, wing:int) -> void:
	assigned_wing = wing
	assigned_floor = floor

	room_ref = "%s%s%s" % [assigned_floor, assigned_wing, ref_index]
	FrontLeftPanelLabel.text = "ROOM %s" % [room_ref]
	build_room_details()
# ---------------------------------------------------
	
# --------------------------------------------------------------------------------------------------
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready():return
	build_room_details()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if !is_node_ready():return
	var check_ref:String = "%s%s%s" % [current_location.floor, current_location.ring, current_location.room]
	is_focused = room_ref == check_ref
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_unavailable_rooms_update(new_val:Array = unavailable_rooms) -> void:
	unavailable_rooms = new_val
	if !is_node_ready():return
	is_unavailable = room_ref in unavailable_rooms
	on_current_state_update()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func fade(complete_fade:bool = false) -> void:
	pass
	#tween_property(ContainerSprite, "scale", Vector3(1, 1, 1), 0.1)
	#tween_property(ContainerSprite, "modulate", Color(1, 1, 1, 0.75 if !complete_fade else 0), 0.1)
	#
func fade_restore() -> void:
	pass
	#tween_property(ContainerSprite, "modulate", Color(1, 1, 1, 1), 0.1)
	#tween_property(ContainerSprite, "scale", Vector3(1, 1, 1), 0.1)
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------	
func build_room_details() -> void:
	if room_config.is_empty() or ref_index == -1 or room_ref == "":return
	var data:Dictionary = room_config.floor[assigned_floor].ring[assigned_wing].room[ref_index]

	if !data.build_data.is_empty():
		#print("build data:", room_ref, assigned_wing)
		room_data = ROOM_UTIL.return_data(data.build_data.ref)
		TopPanelLabel.text = room_data.name	
		TopPanelLabel2.text = "CONSTRUCTING"
		apply_texture = APPLY_TEXTURE.UNDER_CONSTRUCTION
	
	elif !data.room_data.is_empty():
		room_data = ROOM_UTIL.return_data(data.room_data.ref)
		TopPanelLabel.text = room_data.name	
		TopPanelLabel2.text = ""
		apply_texture = APPLY_TEXTURE.BUILT
	
	else:
		room_data = {}
		TopPanelLabel.text = "EMPTY"
		TopPanelLabel2.text = ""
		apply_texture = APPLY_TEXTURE.NONE
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_is_focused_update() -> void:
	var new_state:int = STATES.ACTIVE if is_focused else STATES.INACTIVE
	
	if current_state != new_state:
		current_state = new_state
		current_state = STATES.ACTIVE if is_focused else STATES.INACTIVE
		
	if !is_focused:
		show_side = SIDES.NEUTRAL
		onBlur.call()
	else:
		onFocus.call(room_data)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_show_side_update() -> void:
	if !is_node_ready() or default_position.is_empty():return
	
	if previous_show_side != show_side:
		previous_show_side = show_side
		match show_side:
			SIDES.NEUTRAL:
				tween_property(RoomNode, "rotation", default_position.room_node_rotation, 0.3)
					
			SIDES.LEFT:
				tween_property(RoomNode, "rotation_degrees:y", 45, 0.3)
					
			SIDES.RIGHT:
				tween_property(RoomNode, "rotation_degrees:y", -45, 0.3)
# ------------------------------------------------
			
# ------------------------------------------------
func tween_property(node:Node3D, property:String, new_val, duration:float = 0.3) -> void:
	var tween_pos:Tween = create_tween()
	tween_pos.tween_property(node, property, new_val, duration).set_trans(Tween.TRANS_SINE)
	await tween_pos.finished
# ------------------------------------------------

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready():return
	var key:String = input_data.key
	var keycode:int = input_data.keycode

	if is_focused:
		match key:
			"TL":
				show_side = SIDES.NEUTRAL if show_side == SIDES.LEFT else SIDES.LEFT
			"TR":
				show_side = SIDES.NEUTRAL if show_side == SIDES.RIGHT else SIDES.RIGHT			
			"SPACEBAR":
				show_side = SIDES.NEUTRAL
				show_internal = !show_internal
			
# --------------------------------------------------------------------------------------------------	


# ---------------------------------------------------
func _process(delta: float) -> void:
	pass
# ---------------------------------------------------
