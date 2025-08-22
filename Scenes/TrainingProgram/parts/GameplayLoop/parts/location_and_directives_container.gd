extends Control

@onready var Component:PanelContainer = $Component
@onready var ComponentMargin:MarginContainer = $Component/MarginContainer

@onready var Location:Control = $Component/MarginContainer/VBoxContainer/Location
@onready var Visualizer:Control = $Component/MarginContainer/VBoxContainer/Location/Visualizer
@onready var Directives:Control = $Component/MarginContainer/VBoxContainer/Directives

@onready var TempMonitor:Control = $Component/MarginContainer/VBoxContainer/Monitors/TempMonitor
@onready var PollutionMonitor:Control = $Component/MarginContainer/VBoxContainer/Monitors/PollutionMonitor

var control_pos:Dictionary
var room_config:Dictionary
var current_location:Dictionary

func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)

func _ready() -> void:
	self.modulate.a = 0
	Location.hide()
	Directives.hide()
	await U.tick()
	
	Location.show()
	
	await U.tick()
	control_pos[Component] = {
		"show": 0,
		"hide": -ComponentMargin.size.x
	}
	
	Component.position.x = control_pos[Component].hide

func reveal(state:bool) -> void:
	if state:
		self.modulate.a = 1
		show()

	await U.tween_node_property(Component, "position:x", control_pos[Component].show if state else control_pos[Component].hide, 0.3 if !state else 0.7, 0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	
	if !state:
		self.modulate.a = 0
		hide()

func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val	
	U.debounce(str(self, "_update_node"), update_node)

func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	U.debounce(str(self, "_update_node"), update_node)
	
func update_node() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return
	var monitor:Dictionary = GAME_UTIL.get_ring_level_config().monitor

	# monitors
	TempMonitor.slider_val = monitor.temp
	PollutionMonitor.slider_val = monitor.pollution
	#RealityMonitor.slider_val = monitor.reality
