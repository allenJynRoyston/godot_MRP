@tool
extends Node3D

@onready var OmniSource:OmniLight3D = $OmniLight3D
@onready var Cone:SpotLight3D = $OmniLight3D/Cone
@onready var ReverseShadow:SpotLight3D = $OmniLight3D/Cone/ReverseShadow
@onready var Godray:SpotLight3D = $OmniLight3D/Cone/Godray

@export var light_color:Color = Color.WHITE :
	set(val):
		light_color = val
		on_light_color_update()
		
@export var godray_color:Color = Color.WHITE : 		
	set(val):
		godray_color = val
		on_godray_color_update()
		
@export var godray_energy:float = 0.2 : 		
	set(val):
		godray_energy = val
		on_godray_energy_update()
				
@export var spot_range:float = 4.0 : 
	set(val):
		spot_range = val
		on_spot_range_update()
		
@export var spot_energy:float = 4.0 : 
	set(val):
		spot_energy = val
		on_spot_energy_update()		
		
@export var omni_range:float = 4.0 : 
	set(val):
		omni_range = val
		on_omni_range_update()
		
@export var disable_reverse_shadow:bool = false : 
	set(val):
		disable_reverse_shadow = val
		on_disable_reverse_shadow_update()
		

@export var enable_debug:bool = false		
		
func _ready() -> void:
	on_light_color_update()
	on_godray_color_update()
	on_spot_range_update()
	on_spot_energy_update()
	on_godray_energy_update()
	on_omni_range_update()
	on_disable_reverse_shadow_update()


func on_spot_range_update() -> void:
	if !is_node_ready():return
	for light in [Godray, ReverseShadow, Cone]:
		light.spot_range = spot_range
		
func on_spot_energy_update() -> void:
	if !is_node_ready():return
	for light in [ReverseShadow, Cone]:
		light.light_energy = spot_energy
	
func on_light_color_update() -> void:
	if !is_node_ready():return
	for light in [Godray, OmniSource, Cone]:
		light.light_color = light_color	
		
func on_omni_range_update() -> void:
	if !is_node_ready():return
	OmniSource.omni_range = omni_range

func on_godray_color_update() -> void:
	if !is_node_ready():return
	Godray.light_color = godray_color
	
func on_godray_energy_update() -> void:
	if !is_node_ready():return
	Godray.light_energy = godray_energy

func on_disable_reverse_shadow_update() -> void:
	if !is_node_ready():return
	ReverseShadow.hide() if disable_reverse_shadow else ReverseShadow.show()
