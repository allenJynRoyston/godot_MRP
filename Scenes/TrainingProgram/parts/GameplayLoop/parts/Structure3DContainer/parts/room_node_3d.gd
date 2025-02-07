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

@onready var ActiveBox:MeshInstance3D = $RoomNode/Node3D/ActiveBox
@onready var ActivationLight:OmniLight3D = $RoomNode/Node3D/ActiveBox/ActivationLight
@onready var PulseEffectFX:SpotLight3D = $RoomNode/Node3D/ActiveBox/PulseEffectFX

@onready var ScpNotificationNode:MeshInstance3D = $RoomNode/Node3D/HasSCP
@onready var ScpNotificationNodeLight:OmniLight3D = $RoomNode/Node3D/HasSCP/ActivationLight
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

var is_pulsing:bool = false : 
	set(val):
		is_pulsing =  val
		on_is_pulsing_update()

var onBlur:Callable = func(_room_data:Dictionary):pass
var onFocus:Callable = func(_room_data:Dictionary):pass

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
	on_is_pulsing_update()
	build_room_details()
# ---------------------------------------------------

# ---------------------------------------------------
func on_is_pulsing_update() -> void:
	if !is_pulsing:
		PulseEffectFX.hide() 
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
			new_color = Color(0, 0, 0, 0)
		STATES.UNAVAILABLE:
			new_color = Color(0.66, 0, 0, 1)
	
	mesh_outline.albedo_color = new_color
	MeshOutline.set_surface_override_material(0, mesh_outline)
# ---------------------------------------------------

# ---------------------------------------------------
func on_apply_texture_update() -> void:
	if !is_node_ready():return
	var mesh_duplicate = MainMesh.mesh.duplicate()
	var material_copy = RoomMaterialBuilt.duplicate() 
	
	match apply_texture:
		APPLY_TEXTURE.UNDER_CONSTRUCTION:			
			material_copy.albedo_color = Color.PALE_GOLDENROD
		APPLY_TEXTURE.BUILT:
			material_copy.albedo_color = Color.RED
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
	#FrontLeftPanel.show() if !show_internal else FrontLeftPanel.hide()
	#FrontRightPanel.show() if !show_internal else FrontRightPanel.hide()
	TopPanelLabel.show() if !show_internal else TopPanelLabel.hide()
	ActiveBox.show() if !show_internal else ActiveBox.hide()
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
	FrontLeftPanelLabel.text = "%s" % [room_ref]	
	build_room_details()
	on_current_location_update()
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
	if !is_node_ready() or current_location.is_empty():return
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
func build_room_details() -> void:
	if room_config.is_empty() or ref_index == -1 or room_ref == "":return
	var data:Dictionary = room_config.floor[assigned_floor].ring[assigned_wing].room[ref_index]
	var extract_data:Dictionary = ROOM_UTIL.extract_room_details({"floor": assigned_floor, "ring": assigned_wing, "room": ref_index})
	var mesh_duplicate = MainMesh.mesh.duplicate()
	var material_copy = RoomMaterialBuilt.duplicate() 
	material_copy.albedo_color = Color.SLATE_GRAY

	if !extract_data.room.is_empty():
		#apply_texture = APPLY_TEXTURE.UNDER_CONSTRUCTION
		#print("build data:", room_ref, assigned_wing)
		#TopPanelLabel.text = room_data.name	
		#TopPanelLabel2.text = "CONSTRUCTING"
		material_copy.albedo_color = Color(0, 0.529, 1)
		ActivationLight.omni_attenuation = 6.5
		ActivationLight.light_color = Color.GREEN if extract_data.room.is_activated else Color.ORANGE_RED
	else:
		ActivationLight.omni_attenuation = 1.0
		ActivationLight.light_color = Color.TRANSPARENT
	
	if !extract_data.scp.is_empty():
		ScpNotificationNode.show()
		ScpNotificationNodeLight.omni_attenuation = 6.5
		ScpNotificationNodeLight.light_color = Color.MEDIUM_PURPLE
		is_pulsing = true
	else:
		ScpNotificationNodeLight.omni_attenuation = 0.0
		ScpNotificationNodeLight.light_color = Color.TRANSPARENT
		is_pulsing = false

		

	mesh_duplicate.material = material_copy		
	MainMesh.mesh = mesh_duplicate			
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_is_focused_update() -> void:
	var new_state:int = STATES.ACTIVE if is_focused else STATES.INACTIVE
	
	if current_state != new_state:
		current_state = new_state
		current_state = STATES.ACTIVE if is_focused else STATES.INACTIVE
		
	if !is_focused:
		show_side = SIDES.NEUTRAL
		onBlur.call(room_data)
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
				U.tween_node_property(RoomNode, "rotation", default_position.room_node_rotation, 0.3)
					
			SIDES.LEFT:
				U.tween_node_property(RoomNode, "rotation_degrees:y", 45, 0.3)
					
			SIDES.RIGHT:
				U.tween_node_property(RoomNode, "rotation_degrees:y", -45, 0.3)
# ------------------------------------------------

# ---------------------------------------------------
const frequency: float = 0.5    # Frequency of the sine wave (cycles per second)
const amplitude: float = 1.0    # Amplitude of the sine wave
const offset: float = 0.0       # Offset for the wave
var time_elapsed: float = 0.0  # Tracks the elapsed time
var sine_value: float = 0.0   # Current value of the sine wave
var binary_value: int = 0     # Rounded value of the sine wave (0 or 1)

func _process(delta: float) -> void:
	if !is_node_ready():return
	
	#ScpNotificationNode.rotate_y(0.1)
	
	if is_pulsing:
		# Increment time
		time_elapsed += delta

		# Calculate the sine wave value
		sine_value = sin(2.0 * PI * frequency * time_elapsed + offset)

		# Scale sine wave to range between 0 and 1
		sine_value = (sine_value + 1.0) / 2.0
		
		binary_value = round(sine_value)
		
		if binary_value == 0:
			PulseEffectFX.hide()
		if binary_value == 1:
			PulseEffectFX.show()
		

# ---------------------------------------------------
