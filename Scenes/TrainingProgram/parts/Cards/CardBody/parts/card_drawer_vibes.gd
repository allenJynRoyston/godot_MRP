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

@export var hollow:bool = false : 
	set(val):
		hollow = val
		on_hollow_update()

var use_location:Dictionary = {}
var is_researched:bool = true
var preview_mode:bool = false
var room_config:Dictionary = {}

var OrangePanelPreload:StyleBoxFlat = preload("res://Styles/OrangePanel.tres").duplicate()

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
	
func on_hollow_update() -> void:
	if !is_node_ready():return
	
	for node in [VibeMorale, VibeReadiness, VibeSafety]:
		node.invert_color = !hollow
	
	$".".set('theme_override_styles/panel', null if hollow else OrangePanelPreload)	
# -------------------------------


func on_metrics_update() -> void:
	if !is_node_ready():return
	for ref in metrics:
		var item:Dictionary = metrics[ref]
		var amount:int = item.amount
		var bonus_amount:int = item.bonus_amount
		match ref:
			RESOURCE.METRICS.MORALE:
				VibeMorale.value = amount + bonus_amount
				VibeMorale.show() if (amount + bonus_amount != 0) else VibeMorale.hide()
			RESOURCE.METRICS.SAFETY:
				VibeSafety.value = amount + bonus_amount
				VibeSafety.show() if (amount + bonus_amount != 0) else VibeSafety.hide()
			RESOURCE.METRICS.READINESS:
				VibeReadiness.value = amount + bonus_amount
				VibeReadiness.show() if (amount + bonus_amount != 0) else VibeReadiness.hide()
