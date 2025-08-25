extends Node3D

const material_prop:String = "surface_material_override/0"

@onready var Inner:Node3D = $Inner
@onready var Outshell:Node3D = $Outershell
@onready var DebugLighting:DirectionalLight3D = $DebugLighting

#building
@onready var Building:Node3D = $Inner/Building
@onready var BuildingMesh:MeshInstance3D = $Inner/Building/MeshInstance3D

# ventilation
@onready var FanBladeMesh:MeshInstance3D = $Inner/Ventilation/FanBlades

# ac
@onready var AC:Node3D = $Inner/AC
@onready var AC1Mesh:MeshInstance3D = $Inner/AC/AC1
@onready var AC2Mesh:MeshInstance3D = $Inner/AC/AC2

# heating
@onready var Heating:Node3D = $Inner/Heating
@onready var HeatingMesh:MeshInstance3D = $Inner/Heating/MeshInstance3D

# powergrid
@onready var PowerGrid:Node3D = $Inner/PowerGrid
@onready var PowerGridMesh:MeshInstance3D = $Inner/PowerGrid/Grid

# sra
@onready var SRA:Node3D = $Inner/SRA
@onready var SRA1:MeshInstance3D = $Inner/SRA/SRA1
@onready var SRA2:MeshInstance3D = $Inner/SRA/SRA2
@onready var SRA3:MeshInstance3D = $Inner/SRA/SRA3
@onready var SRA4:MeshInstance3D = $Inner/SRA/SRA4

# other
@onready var Billboards:Node3D = $Inner/Billboards
#@onready var EditLighting:Node3D = $Inner/EditLighting

# materials
@onready var BuildingMaterialOriginal:StandardMaterial3D = BuildingMesh.get(material_prop)
@onready var BuildingMaterialCopy:StandardMaterial3D = BuildingMesh.get(material_prop).duplicate(true)
@onready var ACMaterialCopy:StandardMaterial3D = AC1Mesh.get(material_prop).duplicate(true)
@onready var HeatingMaterialCopy:StandardMaterial3D = HeatingMesh.get(material_prop).duplicate(true)
@onready var PowerGridMaterialCopy:StandardMaterial3D = PowerGridMesh.get(material_prop).duplicate(true)
@onready var FanBladeMaterialCopy:StandardMaterial3D = FanBladeMesh.get(material_prop).duplicate(true)
@onready var SRAMaterialCopy:StandardMaterial3D = SRA1.get(material_prop).duplicate(true)

@export var show_outershell:bool = false : 
	set(val):
		show_outershell = val
		on_show_outershell_update()
		
@export var in_edit_mode:bool = false : 
	set(val):
		in_edit_mode = val
		on_in_edit_mode_update()
		
@export var edit_cooling:bool = false : 
	set(val):
		edit_cooling = val
		on_edit_cooling_update()
				
@export var edit_heating:bool = false : 
	set(val):
		edit_heating = val
		on_edit_heating_update()
			
		
@export var edit_powergrid:bool = false : 
	set(val):
		edit_powergrid = val
		on_edit_powergrid_update()
		

@export var edit_ventilation:bool = false : 
	set(val):
		edit_ventilation = val
		on_edit_ventilation_update()
		
@export var edit_sra:bool = false : 
	set(val):
		edit_sra = val		
		on_edit_sra_update()
				
@export_range(0, 4, 1) var heating_val:int = 1 : 
	set(val):
		heating_val = val
		update_heating_mesh()
		

@export_range(0, 4, 1) var cooling_val:int = 1 : 
	set(val):
		cooling_val = val
		update_cooling_mesh()
		
@export_range(0, 4, 1) var power_val:int = 1 : 
	set(val):
		power_val = val
		update_powergrid_mesh()		
		
@export_range(0, 4, 1) var sra_val:int = 1 : 
	set(val):
		sra_val = val
		update_sra_mesh()		
		
@export_range(0, 4, 1) var ventilation_val:int = 1 : 
	set(val):
		ventilation_val = val
		update_ventilation_mesh()				
		
# -----------------------------------------------
func _ready() -> void:
	on_show_outershell_update()
	on_in_edit_mode_update()
	update_cooling_mesh()
	update_heating_mesh()
	update_powergrid_mesh()
	update_ventilation_mesh()
	update_sra_mesh()
	
	on_edit_cooling_update()
	on_edit_heating_update()
	on_edit_powergrid_update()
	on_edit_ventilation_update()
	on_edit_sra_update()
	
	DebugLighting.hide()	
# -----------------------------------------------

# --------------------------------------------------------
func set_to_build_mode(state:bool) -> void:
	BuildingMaterialCopy.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED if state else BaseMaterial3D.SHADING_MODE_PER_PIXEL
	BuildingMaterialCopy.albedo_color = Color.CORNFLOWER_BLUE if state else BuildingMaterialOriginal.albedo_color
	BuildingMesh.set(material_prop, BuildingMaterialCopy )	
# --------------------------------------------------------	

# -----------------------------------------------
func on_show_outershell_update() -> void:
	if !is_node_ready():return
	Outshell.show() if show_outershell else Outshell.hide()
	Inner.show() if !show_outershell else Inner.hide()

# -----------------------------------------------
func on_in_edit_mode_update() -> void:
	if !is_node_ready():return
	
	HeatingMaterialCopy.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED	if in_edit_mode else BaseMaterial3D.SHADING_MODE_PER_PIXEL
	ACMaterialCopy.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED if in_edit_mode else BaseMaterial3D.SHADING_MODE_PER_PIXEL
	PowerGridMaterialCopy.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED if in_edit_mode else BaseMaterial3D.SHADING_MODE_PER_PIXEL
	FanBladeMaterialCopy.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED if in_edit_mode else BaseMaterial3D.SHADING_MODE_PER_PIXEL
	SRAMaterialCopy.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED if in_edit_mode else BaseMaterial3D.SHADING_MODE_PER_PIXEL
	
	BuildingMaterialCopy.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED if in_edit_mode else BaseMaterial3D.SHADING_MODE_PER_PIXEL
	BuildingMaterialCopy.albedo_color = Color.BLACK if in_edit_mode else BuildingMaterialOriginal.albedo_color
	BuildingMesh.set(material_prop, BuildingMaterialCopy )	
		
	update_cooling_mesh()
	update_heating_mesh()
	update_powergrid_mesh()
	update_ventilation_mesh()
	update_sra_mesh()
# -----------------------------------------------

func on_edit_cooling_update() -> void:
	if !is_node_ready():return
	await U.tick()
	U.tween_node_property(AC1Mesh, "position:z", -55 if in_edit_mode and edit_cooling else -61, 0.3, 0, Tween.TRANS_SINE)
	U.tween_node_property(AC2Mesh, "position:x", 55 if in_edit_mode and edit_cooling else 61, 0.3, 0, Tween.TRANS_SINE)	
	
func on_edit_heating_update() -> void:
	if !is_node_ready():return
	await U.tick()
	U.tween_node_property(HeatingMesh, "position:y", -18 if in_edit_mode and edit_heating else -19, 0.3, 0, Tween.TRANS_SINE)	
	
func on_edit_powergrid_update() -> void:
	if !is_node_ready():return
	await U.tick()
	U.tween_node_property(PowerGridMesh, "position:y", -10 if in_edit_mode and edit_powergrid else -11, 0.3, 0, Tween.TRANS_SINE)	
	
func on_edit_ventilation_update() -> void:
	if !is_node_ready():return
	await U.tick()
	U.tween_node_property(FanBladeMesh, "position:y", -1 if in_edit_mode and edit_ventilation else -2, 0.3, 0, Tween.TRANS_SINE)
	
	
func on_edit_sra_update() -> void:
	if !is_node_ready():return
	await U.tick()
	U.tween_node_property(SRA1, "position:x", -58 if in_edit_mode and edit_sra else -54, 0.3, 0, Tween.TRANS_SINE)
	U.tween_node_property(SRA2, "position:z", 58 if in_edit_mode and edit_sra else 54, 0.3, 0, Tween.TRANS_SINE)
	U.tween_node_property(SRA3, "position:x", -58 if in_edit_mode and edit_sra else -54, 0.3, 0, Tween.TRANS_SINE)
	U.tween_node_property(SRA4, "position:z", 58 if in_edit_mode and edit_sra else 54, 0.3, 0, Tween.TRANS_SINE)	
	
# -----------------------------------------------
func update_heating_mesh() -> void:
	if !is_node_ready():return	
	if !in_edit_mode:
		HeatingMesh.hide()
		return
	
	
	HeatingMaterialCopy.albedo_color = Color.RED.lightened(1 - ((heating_val - 1) * 0.2)) if in_edit_mode else Color.DARK_GRAY
	HeatingMesh.set(material_prop, HeatingMaterialCopy )
	HeatingMesh.show()
	

# -----------------------------------------------

# -----------------------------------------------
func update_cooling_mesh() -> void:
	if !is_node_ready():return
	ACMaterialCopy.albedo_color = Color.BLUE.lightened(1 - ((cooling_val -1) * 0.2)) if in_edit_mode else Color.DARK_GRAY
	for node in [AC1Mesh, AC2Mesh]:	
		node.set(material_prop, ACMaterialCopy) 
# -----------------------------------------------

# -----------------------------------------------
func update_powergrid_mesh() -> void:
	if !is_node_ready():return
	if !in_edit_mode:
		PowerGridMesh.hide()
		return
	
	PowerGridMaterialCopy.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	PowerGridMaterialCopy.albedo_color = Color.ORANGE.lightened(1 - ((power_val - 1) * 0.2)) if in_edit_mode else Color.DARK_GRAY
	PowerGridMesh.set(material_prop, PowerGridMaterialCopy)
	PowerGridMesh.show()
# -----------------------------------------------

# -----------------------------------------------
func update_ventilation_mesh() -> void:
	if !is_node_ready():return
	
	FanBladeMaterialCopy.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	FanBladeMaterialCopy.albedo_color = Color.GREEN_YELLOW.lightened(1 - ((ventilation_val - 1) * 0.2)) if in_edit_mode else Color.DARK_GRAY
	FanBladeMesh.set(material_prop, FanBladeMaterialCopy)
# -----------------------------------------------

# -----------------------------------------------
func update_sra_mesh() -> void:
	if !is_node_ready():return
	
	SRAMaterialCopy.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	SRAMaterialCopy.albedo_color = Color.PLUM.lightened(1 - ((sra_val - 1) * 0.2)) if in_edit_mode else Color.DARK_GRAY
	for node in [SRA1, SRA2, SRA3, SRA4]:	
		node.set(material_prop, SRAMaterialCopy) 
# -----------------------------------------------

# -----------------------------------------------
func highligh_item(item: Dictionary, power_distribution:Dictionary) -> void:
	const energy_levels:Array = [0, 5, 10, 15]

	edit_heating = false
	edit_cooling = false
	edit_ventilation = false
	edit_sra = false
	edit_powergrid = false

	match item.prop:
		# ------------
		"heating":
			edit_heating = true
			heating_val = power_distribution[item.prop] 
		# ------------
		"cooling":
			edit_cooling = true
			cooling_val = power_distribution[item.prop] 
		# ------------
		"ventilation":
			edit_ventilation = true
			ventilation_val = power_distribution[item.prop] 
		# ------------
		"sra":
			edit_sra = true
			sra_val = power_distribution[item.prop] 
		# ------------
		"energy":
			edit_powergrid = true
			power_val = power_distribution[item.prop] 
# -----------------------------------------------

# -----------------------------------------------	
func _process(delta: float) -> void:
	if !is_node_ready():return
	FanBladeMesh.rotate_y( (ventilation_val - 1 + 0.2) * (delta*2))
# -----------------------------------------------
