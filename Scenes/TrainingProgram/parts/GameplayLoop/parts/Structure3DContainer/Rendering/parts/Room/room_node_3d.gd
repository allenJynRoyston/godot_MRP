extends Node3D

@onready var PreviewCamera:Camera3D = $PreviewCamera
@onready var MainMesh:MeshInstance3D = $RoomNode/MainMesh
@onready var MeshOutline:MeshInstance3D = $RoomNode/MeshOutline
#@onready var NameLabel:Label3D = $RoomNode/NameLabel

@onready var RoomNode:Node3D = $RoomNode
@onready var RoomNumberLabel:Label3D = $RoomNode/MainMesh/DoorMesh/RoomNumberLabel
@onready var DoorLabel:Label3D = $RoomNode/MainMesh/DoorMesh/DoorLabel

@onready var ActivationIndicator:MeshInstance3D = $RoomNode/MainMesh/ActivationIndicator
@onready var ActivationIndicatorLight:OmniLight3D = $RoomNode/MainMesh/ActivationIndicator/ActivationIndicatorLight
@onready var ActivationIndicatorPulseLight:SpotLight3D = $RoomNode/MainMesh/ActivationIndicator/ActivationIndicatorPulseLight

@onready var ScpIndicator:MeshInstance3D = $RoomNode/MainMesh/ScpIndicator
@onready var ScpIndicatorLight:OmniLight3D = $RoomNode/MainMesh/ScpIndicator/Light

enum STATES { NONE, ACTIVE, INACTIVE, UNAVAILABLE }

enum SIDES {LEFT, RIGHT, NEUTRAL}

enum APPLY_TEXTURE { NONE, BUILT, UNDER_CONSTRUCTION }

const RoomMaterialBuilt:StandardMaterial3D = preload("res://Materials/RoomMaterialBuilt.tres")

@export var room_number:int = -1

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

var enable_focus:bool = false : 
	set(val):
		enable_focus = val
		on_is_focused_update()

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
	#on_apply_texture_update()
	on_is_pulsing_update()
	build_room_details()
# ---------------------------------------------------

func get_marker() -> MeshInstance3D:
	return $Node3D/Marker

# ---------------------------------------------------
func on_is_pulsing_update() -> void:
	if !is_pulsing:
		ActivationIndicatorPulseLight.hide() 
# ---------------------------------------------------

# ---------------------------------------------------
func on_current_state_update() -> void:
	if !is_node_ready():return
	var new_color:Color = Color.WHITE
	var mesh_outline:StandardMaterial3D = MeshOutline.get_surface_override_material(0).duplicate()
	#NameLabel.hide()
	
	match current_state:
		STATES.NONE:
			new_color = Color.TRANSPARENT
		STATES.ACTIVE:
			new_color = Color(1, 1, 1, 1) if !is_unavailable else  Color(0.66, 0, 0, 1)
			#NameLabel.show()
		STATES.INACTIVE:
			new_color = Color(0, 0, 0, 0)
		STATES.UNAVAILABLE:
			new_color = Color(0.66, 0, 0, 1)
	
	mesh_outline.albedo_color = new_color
	MeshOutline.set_surface_override_material(0, mesh_outline)
# ---------------------------------------------------

## ---------------------------------------------------
#func on_apply_texture_update() -> void:
	#if !is_node_ready():return
	#var mesh_duplicate = MainMesh.mesh.duplicate()
	#var material_copy = RoomMaterialBuilt.duplicate() 
	#
	#match apply_texture:
		#APPLY_TEXTURE.UNDER_CONSTRUCTION:			
			#material_copy.albedo_color = Color.PALE_GOLDENROD
		#APPLY_TEXTURE.BUILT:
			#material_copy.albedo_color = Color.RED
#
#
	#if material_copy != null:
		#mesh_duplicate.material = material_copy		
		#MainMesh.mesh = mesh_duplicate	
## ---------------------------------------------------


# ---------------------------------------------------
func on_show_internal_update() -> void:
	if !is_node_ready():return
	MainMesh.mesh.flip_faces = show_internal
	#FrontLeftPanel.show() if !show_internal else FrontLeftPanel.hide()
	#FrontRightPanel.show() if !show_internal else FrontRightPanel.hide()
	#TopPanelLabel.show() if !show_internal else TopPanelLabel.hide()
	#ActiveBox.show() if !show_internal else ActiveBox.hide()
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
	if current_location.is_empty():return
	var check_ref:String = U.location_to_designation(current_location)
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
	if room_config.is_empty() or current_location.is_empty() or ref_index == -1 or room_ref == "":return
	var data:Dictionary = room_config.floor[assigned_floor].ring[assigned_wing].room[ref_index]
	var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": assigned_floor, "ring": assigned_wing, "room": ref_index})
	var mesh_duplicate = MainMesh.mesh.duplicate()
	var material_copy = RoomMaterialBuilt.duplicate() 
	material_copy.albedo_color = Color.SLATE_GRAY

	RoomNumberLabel.text = "%s" % [room_number]	
	#NameLabel.text = "EMPTY" if extract_data.is_room_empty else extract_data.room.details.name
	
	var scp_color:Color = Color(0.511, 0.002, 0.717)
	var room_color:Color = Color(0, 0.529, 1)
	var special_color:Color = Color(0, 0, 0)

	if extract_data.is_room_empty:
		DoorLabel.text = "EMPTY"
		ActivationIndicatorLight.omni_attenuation = 1.0
		ActivationIndicatorLight.light_color = Color.TRANSPARENT
	else:
		DoorLabel.text = extract_data.room.details.shortname		
		#match extract_data.room_category:
			#ROOM.CATEGORY.CONTAINMENT_CELL:
				#material_copy.albedo_color = special_color if extract_data.is_directors_office else scp_color
			#ROOM.CATEGORY.FACILITY:
				#material_copy.albedo_color = special_color if extract_data.is_directors_office else room_color
		ActivationIndicatorLight.omni_attenuation = 6.5
		ActivationIndicatorLight.light_color = Color.GREEN if extract_data.is_activated else Color.ORANGE_RED
	
	if extract_data.is_scp_empty:
		ScpIndicatorLight.omni_attenuation = 0.0
		ScpIndicatorLight.light_color = Color.TRANSPARENT
		is_pulsing = false
	else:
		DoorLabel.text = extract_data.scp.details.name
		ScpIndicatorLight.show()
		ScpIndicatorLight.omni_attenuation = 6.5
		ScpIndicatorLight.light_color = Color.MEDIUM_PURPLE
		is_pulsing = true

		

	mesh_duplicate.material = material_copy		
	MainMesh.mesh = mesh_duplicate			
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_is_focused_update() -> void:
	if !enable_focus:
		current_state = STATES.INACTIVE
		return
		
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

	if is_pulsing:
		# Increment time
		time_elapsed += delta

		# Calculate the sine wave value
		sine_value = sin(2.0 * PI * frequency * time_elapsed + offset)

		# Scale sine wave to range between 0 and 1
		sine_value = (sine_value + 1.0) / 2.0
		
		binary_value = round(sine_value)
		
		if binary_value == 0:
			ActivationIndicatorPulseLight.hide()
		if binary_value == 1:
			ActivationIndicatorPulseLight.show()
# ---------------------------------------------------
