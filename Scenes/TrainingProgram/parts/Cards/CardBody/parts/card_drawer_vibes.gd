@tool
extends CardDrawerClass

@onready var ListContainer:HBoxContainer = $MarginContainer/MarginContainer/ListContainer

@onready var MoraleLabel:Label = $MarginContainer/MarginContainer/HBoxContainer/Morale/Label
@onready var SafetyLabel:Label = $MarginContainer/MarginContainer/HBoxContainer/Safety/Label
@onready var ReadinessLabel:Label = $MarginContainer/MarginContainer/HBoxContainer/Readiness/Label

@export var metrics:Dictionary = {} : 
	set(val):
		metrics = val
		on_metrics_update()

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
				MoraleLabel.text = "%s%s" % ["+" if amount > 0 else "", amount]
			RESOURCE.METRICS.SAFETY:
				SafetyLabel.text = "%s%s" % ["+" if amount > 0 else "", amount]
			RESOURCE.METRICS.READINESS:
				ReadinessLabel.text = "%s%s" % ["+" if amount > 0 else "", amount]
