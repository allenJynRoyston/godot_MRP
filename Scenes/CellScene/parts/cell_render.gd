extends Node3D

@onready var SceneCamera:Camera3D = $Camera3D
@onready var AmbientLighting:Node3D = $Lighting/AmbientLighting
@onready var EmergencyLighting:Node3D = $Lighting/EmergencyLighting
@onready var InterogationLighting:Node3D = $Lighting/InterogationLighting
@onready var LowLevelLighting:Node3D = $Lighting/LowLevelLighting
@onready var DustParticles:GPUParticles3D = $Camera3D/DustParticles

@onready var LookAtCamera:Camera3D = $LookAtCamera
@onready var LookAtCenter:Marker3D = $Structure/ShelfModel/TvMonitorModel/LookAtCenter
@onready var LookAtComputer:Marker3D = $Structure/Desk/ComputerModel/LookAtComputer
@onready var LookAtTerminal:Marker3D = $Structure/Desk2/ComputerModel/LookAtTerminal
@onready var LookAtExit:Marker3D = $Structure/LookAtExit

@export var enable_ambient_lighting:bool = false : 
	set(val):
		enable_ambient_lighting = val
		on_enable_ambient_lighting_update()

@export var enable_emergency_lighting:bool = false : 
	set(val):
		enable_emergency_lighting = val
		on_enable_emergency_lighting_update()
		
@export var enable_interogation_lighting:bool = false : 
	set(val):
		enable_interogation_lighting = val
		on_enable_interogation_lighting_update()		
		
@export var enable_lowlevel_lighting:bool = false : 
	set(val):
		enable_lowlevel_lighting = val
		on_enable_lowlevel_lighting_update()		

@export var enable_dust_particles:bool = false : 
	set(val):
		enable_dust_particles = val
		on_enable_dust_particles_update()		

func _ready() -> void:
	on_enable_ambient_lighting_update()	
	on_enable_emergency_lighting_update()
	on_enable_interogation_lighting_update()
	on_enable_lowlevel_lighting_update()
	on_enable_dust_particles_update()
		
func on_enable_ambient_lighting_update() -> void:
	if !is_node_ready():return
	AmbientLighting.show() if enable_ambient_lighting else AmbientLighting.hide()

func on_enable_emergency_lighting_update() -> void:
	if !is_node_ready():return
	EmergencyLighting.show() if enable_emergency_lighting else EmergencyLighting.hide()
	
func on_enable_interogation_lighting_update() -> void:
	if !is_node_ready():return
	InterogationLighting.show() if enable_interogation_lighting else InterogationLighting.hide()

func on_enable_lowlevel_lighting_update() -> void:
	if !is_node_ready():return
	LowLevelLighting.show() if enable_lowlevel_lighting else LowLevelLighting.hide()

func on_enable_dust_particles_update() -> void:
	if !is_node_ready():return
	DustParticles.show() if enable_dust_particles else DustParticles.hide()
	DustParticles.emitting = enable_dust_particles

func look_at_computer() -> void:	
	LookAtCamera.look_at(LookAtComputer.global_transform.origin, Vector3.UP)
	await U.tween_node_property(SceneCamera, "rotation_degrees", LookAtCamera.rotation_degrees, 0.5, 0, Tween.TRANS_CUBIC)	
	
func look_at_terminal() -> void:	
	LookAtCamera.look_at(LookAtTerminal.global_transform.origin, Vector3.UP)
	await U.tween_node_property(SceneCamera, "rotation_degrees", LookAtCamera.rotation_degrees, 0.5, 0, Tween.TRANS_CUBIC)	
	
func look_at_center() -> void:
	LookAtCamera.look_at(LookAtCenter.global_transform.origin, Vector3.UP)
	await U.tween_node_property(SceneCamera, "rotation_degrees", LookAtCamera.rotation_degrees, 0.5, 0, Tween.TRANS_CUBIC)	

func look_at_exit() -> void:
	LookAtCamera.look_at(LookAtExit.global_transform.origin, Vector3.UP)
	await U.tween_node_property(SceneCamera, "rotation_degrees", LookAtCamera.rotation_degrees, 0.5, 0, Tween.TRANS_CUBIC)	


func zoom(state:bool) -> void:
	U.tween_node_property(SceneCamera, "fov", 1 if state else 55, 0.7, 0, Tween.TRANS_CIRC)
	await U.set_timeout(0.6)
