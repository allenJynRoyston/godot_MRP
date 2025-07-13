@tool
extends Control

@onready var LeftIconBtn:BtnBase = $PanelContainer/CenterContainer/MarginContainer/HBoxContainer/IconBtn
@onready var RightIconBtn:BtnBase = $PanelContainer/CenterContainer/MarginContainer/HBoxContainer/IconBtn2
@onready var UpIconBtn:BtnBase = $PanelContainer/CenterContainer/MarginContainer/VBoxContainer/IconBtn
@onready var DownIconBtn:BtnBase = $PanelContainer/CenterContainer/MarginContainer/VBoxContainer/IconBtn2

@onready var FloorLabel:Label = $PanelContainer/CenterContainer/MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/FloorLabel
@onready var RingLabel:Label = $PanelContainer/CenterContainer/MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/RingLabel

@export var show_directional:bool = false : 
	set(val):
		show_directional = val
		on_show_directionals_update()

var current_location:Dictionary
var previous_floor:int
var previous_ring:int

var txt_tween_1:Tween 
var txt_tween_2:Tween 
var icon_tween:Tween 

func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	GBL.subscribe_to_control_input(self)

	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	GBL.unsubscribe_to_control_input(self)

func _ready() -> void:
	on_show_directionals_update()
	fade_out()


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
	
	if txt_tween_1.is_running():
		txt_tween_1.stop()
		txt_tween_2.stop()	
	
	U.debounce(str(self.name, "_fade_out"), fade_out, 0.5)
	
	
func fade_out ()-> void:
	txt_tween_1 = create_tween()
	txt_tween_2 = create_tween()
	
	tween_node_property(txt_tween_1, FloorLabel, "modulate", Color(1, 1, 1, 0), 0.2)
	tween_node_property(txt_tween_2, RingLabel, "modulate", Color(1, 1, 1, 0), 0.2)	
	

func on_show_directionals_update() -> void:
	if !is_node_ready():return
	for btn in [LeftIconBtn, RightIconBtn, UpIconBtn, DownIconBtn]:
		btn.modulate = Color(1, 1, 1, 1 if show_directional else 0)

func press_btn(node:Control) -> void:
	node.static_color = Color(1.0, 1, 1, 1)
	for btn in [LeftIconBtn, RightIconBtn, UpIconBtn, DownIconBtn]:
		btn.static_color = Color(1, 1, 1, 1 if node == btn else 0.5) 
	if icon_tween != null and icon_tween.is_running():
		icon_tween.stop()
	U.debounce(str(self.name, "_tween_icon_color"), tween_icon_color.bind(node), 0.1)

func tween_icon_color(node) -> void:
	icon_tween = create_tween()
	tween_node_property(icon_tween, node, "static_color", Color(1, 1, 1, 0.5), 0.2, 0.1)

# --------------------------------------------------------------------------------------------------		
func tween_node_property(tween:Tween, node:Node, prop:String, new_val, duration:float = 0.3, delay:float = 0, trans:int = Tween.TRANS_QUAD) -> void:
	if duration == 0:
		duration = 0.02
		
	tween.tween_property(node, prop, new_val, duration).set_trans(trans).set_delay(delay)
	await tween.finished
# --------------------------------------------------------------------------------------------------		


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
