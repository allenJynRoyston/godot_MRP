extends Control

@onready var RenderSubviewport:SubViewport = $SubViewport

@onready var SceneTextureRect:TextureRect = $TextureRect
@onready var TransitionRect:TextureRect = $TransitionRect
@onready var FloorInstance:Node3D = $SubViewport/Node3D/FloorInstance
@onready var FloorInstanceContainer:Node3D = $SubViewport/Node3D/FloorInstanceContainer

const TransparencyShaderPreload:ShaderMaterial = preload("res://Shader/Spatial/Transparency.tres")
const RoomMaterialActive:StandardMaterial3D = preload("res://Materials/RoomMaterialUnderConstruction.tres")
const RoomMaterialInactive:StandardMaterial3D = preload("res://Materials/RoomMaterialInactive.tres")

var camera_settings:Dictionary = {} 
var current_location:Dictionary = {} 


# ------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)

func _ready() -> void:	
	build_floors()
# ------------------------------------------------

# ------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	U.debounce(str(self.name, "_update_mesh"), update_mesh)
# ------------------------------------------------

# -----------------------------------------------			
func on_camera_settings_update(new_val:Dictionary) -> void: 
	camera_settings = new_val
	if !is_node_ready() or current_location.is_empty():return
	U.debounce(str(self.name, "_update_mesh"), update_mesh)
# -----------------------------------------------			

# ------------------------------------------------
func build_floors() -> void:
	for n in range(7):
		var floor_duplicate:Node3D = FloorInstance.duplicate()
		floor_duplicate.show()
		floor_duplicate.position.y = n * -10
		FloorInstanceContainer.add_child(floor_duplicate)
	FloorInstance.queue_free()
# ------------------------------------------------

# ------------------------------------------------
func update_mesh() -> void:	
	if !is_node_ready() or current_location.is_empty() or camera_settings.is_empty() or FloorInstanceContainer.get_child_count() == 0:return	

	for floor_index in FloorInstanceContainer.get_child_count():
		var floor_node:Node3D = FloorInstanceContainer.get_child(floor_index)
		for ring_index in floor_node.get_child_count():
			var child:MeshInstance3D = floor_node.get_child(ring_index)
			var mesh_duplicate = child.mesh.duplicate()
			if camera_settings.is_locked:
				mesh_duplicate.material = TransparencyShaderPreload.duplicate()	
				var material_copy:StandardMaterial3D = RoomMaterialActive.duplicate() if floor_index == current_location.floor else RoomMaterialInactive.duplicate()
				material_copy.albedo_color = material_copy.albedo_color.lerp(Color(0, 0, 0), 0.5)
				mesh_duplicate.material = material_copy	
			else:
				if floor_index < current_location.floor:
					mesh_duplicate.material = TransparencyShaderPreload.duplicate()		
				else:					
					var material_copy:StandardMaterial3D = RoomMaterialActive.duplicate() if floor_index == current_location.floor and ring_index == current_location.ring else RoomMaterialInactive.duplicate()
					material_copy.albedo_color = material_copy.albedo_color.lerp(Color(0, 0, 0), 0.5)
					mesh_duplicate.material = material_copy		
			child.mesh = mesh_duplicate	

# ------------------------------------------------
