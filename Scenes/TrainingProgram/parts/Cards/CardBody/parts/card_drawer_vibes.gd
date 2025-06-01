@tool
extends CardDrawerClass

@onready var ListContainer:HBoxContainer = $MarginContainer/MarginContainer/ListContainer

@onready var VibeMorale:Control = $MarginContainer/MarginContainer/HBoxContainer/VibeMorale
@onready var VibeSafety:Control = $MarginContainer/MarginContainer/HBoxContainer/VibeSafety
@onready var VibeReadiness:Control = $MarginContainer/MarginContainer/HBoxContainer/VibeReadiness

@export var metrics:Dictionary = {} : 
	set(val):
		metrics = val
		on_metrics_update()

var is_researched:bool = true

const ResourceItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResourceContainer/parts/ResourceItem/ResourceItem.tscn")

func _ready() -> void:
	super._ready()
	on_metrics_update()
	
func on_metrics_update() -> void:
	if !is_node_ready():return
	
	for key in metrics:
		var resource_details:Dictionary = RESOURCE_UTIL.return_metric(key)
		var amount:int = metrics[key]
		match key:
			RESOURCE.METRICS.MORALE:
				VibeMorale.value = amount
			RESOURCE.METRICS.SAFETY:
				VibeSafety.value = amount
			RESOURCE.METRICS.READINESS:
				VibeReadiness.value = amount
