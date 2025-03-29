@tool
extends Control

@onready var NameLabel:Label = $PanelContainer2/MarginContainer2/VBoxContainer/HBoxContainer2/HBoxContainer2/NameLabel
@onready var LvlLabel:Label = $PanelContainer2/LvlIndicator/Control/LvlLabel
@onready var DotIcon:BtnBase = $PanelContainer2/ActivatedIndicator/IconBtn
@onready var EnergyIndicatorControl:Control = $PanelContainer2/EnergyIndicator/Control

func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	GBL.subscribe_to_process(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	GBL.unsubscribe_to_process(self)

@export var index:int = -1 : 
	set(val):
		index = val
		on_index_update()
		
@export var fade:bool = false : 
	set(val):
		fade = val
		on_fade_update()

@export var ignore_current_location:bool = false

const fade_int:float = 10

var room_config:Dictionary = {}
var current_location:Dictionary = {}
var offset:Vector2
var name_str:String
var lvl_str:String
var shifted_val:int = 5
var original_position:Vector2

func _ready() -> void:
	original_position = self.global_position
	on_fade_update()
	on_index_update()
	
func on_fade_update() -> void:
	if !is_node_ready():return
	
	if !fade:
		update_node()
	
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 0 if fade else 1), 0.3)
	U.tween_range(fade_int if fade else 0.0, fade_int if !fade else 0.0, 0.3, func(val:float) -> void:
		offset.x = val
	) 			

func on_index_update() -> void:
	await U.tick()
	U.debounce(str(self.name, "_nametag_update_node"), func():update_node())

func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if !ignore_current_location:
		await U.tick()
		U.debounce(str(self.name, "_nametag_update_node"), func():update_node())

func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	await U.tick()
	U.debounce(str(self.name, "_nametag_update_node"), func():update_node())
	
func update_node(shift_val:int = 10) -> void:
	if !is_node_ready() or room_config.is_empty() or current_location.is_empty() or index == -1:return
	shifted_val = shift_val
	
	var use_location:Dictionary = current_location.duplicate()
	use_location.room = index
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(use_location)		
	var ability_lvl:int = GAME_UTIL.get_ability_level(use_location)

	name_str = room_extract.room.details.shortname if !room_extract.is_room_empty else "EMPTY"
	lvl_str = str(ability_lvl) if !room_extract.is_room_empty else "0"

	
	var label_setting_copy:LabelSettings = NameLabel.label_settings.duplicate()
	label_setting_copy.font_color = Color(0.7, 0.3, 0.3, 1) if !room_extract.is_activated else Color(1, 1, 1, 1)
	NameLabel.label_settings = label_setting_copy
	DotIcon.static_color = Color(1, 0, 0, 1) if !room_extract.is_activated else Color(0, 1, 0, 1)
	self.size.x = 1
	await U.tick()
	EnergyIndicatorControl.position.x = self.size.x - 30

func shift_string_backward(text: String, shift: int = 5) -> String:
	var result:String = ""
	for char in text:
		if char == " ":
			result += " "  # Keep spaces unchanged
		else:
			result += char(char.unicode_at(0) - shift)  # Convert back to character
	return result

func on_process_update(delta:float) -> void:
	if !is_node_ready() or !is_visible_in_tree() or index == -1:return
	var tag_pos:Vector2 = GBL.find_node(REFS.ROOM_NODES).get_room_position(index) * GBL.game_resolution
	self.global_position = tag_pos + Vector2(30, 40) + offset

func _physics_process(delta: float) -> void:
	if !is_node_ready() or !is_visible_in_tree() or index == -1:return
	
	if shifted_val > 0:
		shifted_val -= 1		
		NameLabel.text = shift_string_backward(name_str, shifted_val)
		LvlLabel.text = shift_string_backward(lvl_str, shifted_val)
