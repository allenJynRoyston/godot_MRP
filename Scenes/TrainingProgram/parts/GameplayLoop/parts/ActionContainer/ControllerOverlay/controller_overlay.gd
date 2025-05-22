@tool
extends Control

@onready var LeftIconBtn:BtnBase = $PanelContainer/MarginContainer/HBoxContainer/IconBtn
@onready var RightIconBtn:BtnBase = $PanelContainer/MarginContainer/HBoxContainer/IconBtn2
@onready var UpIconBtn:BtnBase = $PanelContainer/MarginContainer/VBoxContainer/IconBtn
@onready var DownIconBtn:BtnBase = $PanelContainer/MarginContainer/VBoxContainer/IconBtn2

@onready var FloorLabel:Label = $PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/FloorLabel
@onready var RingLabel:Label = $PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/RingLabel

@export var show_directional:bool = false : 
	set(val):
		show_directional = val
		on_show_directionals_update()

var current_location:Dictionary
var previous_floor:int
var previous_ring:int

func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	GBL.subscribe_to_control_input(self)

	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	GBL.unsubscribe_to_control_input(self)

func _ready() -> void:
	on_show_directionals_update()


func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	
	if previous_floor == current_location.floor and previous_ring == current_location.ring:return
	previous_floor = current_location.floor
	previous_ring = current_location.ring
	
	FloorLabel.text = str(current_location.floor)
	RingLabel.text = str(current_location.ring)
	FloorLabel.modulate = Color(1, 1, 1,  0.75)
	RingLabel.modulate = Color(1, 1, 1, 0.75)
	
	U.debounce(str(self.name, "_fade_out"), fade_out, 0.5)
	
	
func fade_out ()-> void:
	U.tween_node_property(FloorLabel, "modulate", Color(1, 1, 1, 0), 0.1)
	U.tween_node_property(RingLabel, "modulate", Color(1, 1, 1, 0), 0.1)	

func on_show_directionals_update() -> void:
	if !is_node_ready():return
	for btn in [LeftIconBtn, RightIconBtn, UpIconBtn, DownIconBtn]:
		btn.modulate = Color(1, 1, 1, 1 if show_directional else 0)

func press_btn(node:Control) -> void:
	node.static_color = Color(1.0, 1, 1, 1)
	for btn in [LeftIconBtn, RightIconBtn, UpIconBtn, DownIconBtn]:
		btn.static_color = Color(1, 1, 1, 1 if node == btn else 0.5) 
	
	U.debounce(str(self.name, "_tween_icon_color"), tween_icon_color.bind(node), 0.3)

func tween_icon_color(node) -> void:
	U.tween_node_property(node, "static_color", Color(1, 1, 1, 0.5), 0.1, 0.1)


func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or !is_visible_in_tree():return	
	var key:String = input_data.key
	
	match key:
		"W":
			press_btn(UpIconBtn)
		"S":
			press_btn(DownIconBtn)
		"A":
			press_btn(LeftIconBtn)
		"D":
			press_btn(RightIconBtn)			
