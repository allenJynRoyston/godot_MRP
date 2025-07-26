@tool
extends Node3D

@onready var FastSpotlight: Node3D = $FastSpotlight
@onready var SlowSpotlight: Node3D = $SlowSpotlight

@export var fast_speed:float = 5.0 
@export var slow_speed:float = 3.0

@export var siren_color_1:Color = Color.RED : 
	set(val):
		siren_color_1 = val
		on_siren_color_1_update()


@export var siren_color_2:Color = Color.BLUE : 
	set(val):
		siren_color_2 = val
		on_siren_color_2_update()

func _ready() -> void:
	on_siren_color_1_update()
	on_siren_color_2_update()
	
func on_siren_color_1_update() -> void:
	if !is_node_ready():return
	FastSpotlight.light_color = siren_color_1
	
func on_siren_color_2_update() -> void:
	if !is_node_ready():return
	SlowSpotlight.light_color = siren_color_2	

func _process(delta: float) -> void:
	if !is_node_ready():return
	# Rotate spotlights consistently using delta time
	if FastSpotlight:
		FastSpotlight.rotate_y(fast_speed * delta)
	if SlowSpotlight:
		SlowSpotlight.rotate_y(slow_speed * delta)
