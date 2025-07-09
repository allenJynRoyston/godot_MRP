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

var use_location:Dictionary = {}
var is_researched:bool = true
var preview_mode:bool = false
var room_config:Dictionary = {}

const ResourceItemPreload:PackedScene = preload("res://UI/ResourceItem/ResourceItem.tscn")

# -------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)

func _ready() -> void:
	super._ready()
	on_metrics_update()
# -------------------------------

# -------------------------------	
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	U.debounce(str(self.name, "_on_metrics_update"), on_metrics_update, 0.1)
	
func get_is_activated() -> bool:
	if !use_location.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
		return false if extract_data.room.is_empty() else extract_data.room.is_activated		
		
	return true		
# -------------------------------


func on_metrics_update() -> void:
	if !is_node_ready():return
	for key in metrics:
		var resource_details:Dictionary = RESOURCE_UTIL.return_metric(key)
		var amount:int = metrics[key] if (preview_mode or get_is_activated()) else 0
		match key:
			RESOURCE.METRICS.MORALE:
				VibeMorale.value = amount
			RESOURCE.METRICS.SAFETY:
				VibeSafety.value = amount
			RESOURCE.METRICS.READINESS:
				VibeReadiness.value = amount
