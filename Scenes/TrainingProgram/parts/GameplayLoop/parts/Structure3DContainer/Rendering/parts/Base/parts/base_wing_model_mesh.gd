extends Node3D

@onready var Lid:MeshInstance3D = $Lid
@onready var Billboard:Node3D = $Lid/Billboard
@onready var Spotlight:SpotLight3D = $SpotLight3D
@onready var FloorLabel:Label3D = $Lid/Billboard/FloorLabel
@onready var WingLabel:Label3D = $Lid/Billboard/WingLabel

@onready var VentilationMesh:MeshInstance3D = $Ventilation
@onready var ACMesh:MeshInstance3D = $ACUnit
@onready var PowerGrid:MeshInstance3D = $PowerGrid
@onready var FanBladeMesh:MeshInstance3D = $ACUnit/FanBlades
@onready var HeatingMesh:MeshInstance3D = $HeatingVents
@onready var SRAMesh:MeshInstance3D = $SRA
@onready var LidMesh:MeshInstance3D = $Lid

@onready var FrostParticles:GPUParticles3D = $Ventilation/FrostParticles
@onready var HeatParticles:GPUParticles3D = $HeatingVents/HeatParticles

@onready var VentilationMeshMaterial:StandardMaterial3D = VentilationMesh.get("surface_material_override/0").duplicate(true)
@onready var ACMeshMaterial:StandardMaterial3D = ACMesh.get("surface_material_override/0").duplicate(true)
@onready var PowerGridMaterial:StandardMaterial3D = PowerGrid.get("surface_material_override/0").duplicate(true)
@onready var HeatingMeshMaterial:StandardMaterial3D = HeatingMesh.get("surface_material_override/0").duplicate(true)
@onready var FanBladeMeshMaterial:StandardMaterial3D = FanBladeMesh.get("surface_material_override/0").duplicate(true)
@onready var SRAMeshMaterial:StandardMaterial3D = SRAMesh.get("surface_material_override/0").duplicate(true)
@onready var LidMeshMaterial:StandardMaterial3D = LidMesh.get("surface_material_override/0").duplicate(true)

var fan_speed:int = 0
var assign_location:Dictionary : 
	set(val):
		assign_location = val
		on_assign_location_update()

func _ready() -> void:
	# set surface overrides
	VentilationMesh.set_surface_override_material(0, VentilationMeshMaterial)
	ACMesh.set_surface_override_material(0, ACMeshMaterial)
	PowerGrid.set_surface_override_material(0, PowerGridMaterial)
	HeatingMesh.set_surface_override_material(0, HeatingMeshMaterial)
	FanBladeMesh.set_surface_override_material(0, FanBladeMeshMaterial)
	SRAMesh.set_surface_override_material(0, SRAMeshMaterial)
	LidMesh.set_surface_override_material(0, LidMeshMaterial)
	
	# set defaults
	Spotlight.hide()
	LidMeshMaterial.proximity_fade_enabled = false
	for material in [VentilationMeshMaterial, FanBladeMeshMaterial, SRAMeshMaterial, ACMeshMaterial, PowerGridMaterial, HeatingMeshMaterial]:
		material.albedo_color = Color.WHITE	
		
func remove_shell(state:bool) -> void:
	if state:
		LidMeshMaterial.proximity_fade_enabled = true
	
	if !state:
		Billboard.show()
		Spotlight.hide()

	U.tween_node_property(Lid, "position:x", -60 if state else -28.5, 0.7, 0, Tween.TRANS_SINE)
	U.tween_range(LidMeshMaterial.proximity_fade_distance, 400 if state else 0, 0.7, 
		func(new_val:float) -> void:
			LidMeshMaterial.proximity_fade_distance = new_val
	)

	if state:
		Billboard.hide()
		Spotlight.show()
		
	if !state:
		LidMeshMaterial.proximity_fade_enabled = false

func highligh_item(item: Dictionary, power_distribution:Dictionary) -> void:
	match item.prop:
		# ------------
		"heating":
			HeatParticles.emitting = power_distribution[item.prop] > 1
			HeatParticles.amount = power_distribution[item.prop] * 20
						
			HeatingMeshMaterial.albedo_color = Color.RED.darkened(1 - power_distribution[item.prop] * 0.25) if power_distribution[item.prop] > 1 else Color.BLACK
		# ------------
		"cooling":
			FrostParticles.emitting = power_distribution[item.prop] > 1
			FrostParticles.amount = power_distribution[item.prop] * 250
			FrostParticles.speed_scale = power_distribution[item.prop]
			
			VentilationMeshMaterial.albedo_color = Color.BLUE.darkened(1 - power_distribution[item.prop] * 0.25) if power_distribution[item.prop] > 1 else Color.BLACK			
		# ------------
		"ventilation":
			FanBladeMeshMaterial.albedo_color = Color.GREEN.darkened(1 - power_distribution[item.prop] * 0.25)  if power_distribution[item.prop] > 1 else Color.BLACK
			ACMeshMaterial.albedo_color = Color.GREEN.darkened(1 - power_distribution[item.prop] * 0.25)  if power_distribution[item.prop] > 1 else Color.BLACK
			fan_speed = power_distribution[item.prop] 
		# ------------
		"sra":
			SRAMeshMaterial.albedo_color = Color.PURPLE.darkened(1 - power_distribution[item.prop] * 0.25)  if power_distribution[item.prop] > 1 else Color.DARK_GRAY
		# ------------
		"energy":
			PowerGridMaterial.albedo_color = Color.ORANGE.darkened(1 - power_distribution[item.prop] * 0.25)  if power_distribution[item.prop] > 1 else Color.DARK_GRAY

func on_assign_location_update() -> void:
	if !is_node_ready():return
	FloorLabel.text = str(assign_location.floor)
	WingLabel.text = str(assign_location.ring)
	
	

func _process(delta: float) -> void:
	FanBladeMesh.rotate_x( (fan_speed - 1 + 0.2) * (delta*2))  # 2 radians/sec (~114.6 deg/sec)
