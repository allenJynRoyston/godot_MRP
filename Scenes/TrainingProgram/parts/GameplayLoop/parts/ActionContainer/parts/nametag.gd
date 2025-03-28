extends Control

@onready var NameLabel:Label = $PanelContainer2/MarginContainer2/VBoxContainer/HBoxContainer2/HBoxContainer2/NameLabel
@onready var LvlLabel:Label = $PanelContainer2/Control/LvlLabel
@onready var DotIcon:BtnBase = $PanelContainer2/Control3/IconBtn

func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	GBL.subscribe_to_process(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	GBL.unsubscribe_to_process(self)

var index:int = -1 : 
	set(val):
		index = val
		on_index_update()
		
var room_config:Dictionary = {}
var current_location:Dictionary = {}

var name_str:String
var lvl_str:String
var shifted_val:int = 5

func _ready() -> void:
	on_index_update()

func on_index_update() -> void:
	await U.tick()
	U.debounce(str(self.name, "_nametag_update_node"), update_node)

func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	await U.tick()
	U.debounce(str(self.name, "_nametag_update_node"), update_node)

func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	await U.tick()
	U.debounce(str(self.name, "_nametag_update_node"), update_node)
	
func update_node() -> void:
	if !is_node_ready() or room_config.is_empty() or current_location.is_empty():return
	shifted_val = 20
	
	var use_location:Dictionary = current_location.duplicate()
	use_location.room = index
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(use_location)		
	var ability_lvl:int = GAME_UTIL.get_ability_level(use_location)
	if room_extract.is_room_empty:
		hide()
		return
	
	show()
	name_str = room_extract.room.details.shortname if !room_extract.is_room_empty else ""
	lvl_str = str(ability_lvl) if !room_extract.is_room_empty else ""

	
	var label_setting_copy:LabelSettings = NameLabel.label_settings.duplicate()
	label_setting_copy.font_color = Color(0.7, 0.3, 0.3, 1) if !room_extract.is_activated else Color(1, 1, 1, 1)
	NameLabel.label_settings = label_setting_copy
	DotIcon.static_color = Color(1, 0, 0, 1) if !room_extract.is_activated else Color(0, 1, 0, 1)

func shift_string_backward(text: String, shift: int = 5) -> String:
	var result:String = ""
	for char in text:
		if char == " ":
			result += " "  # Keep spaces unchanged
		else:
			result += char(char.unicode_at(0) - shift)  # Convert back to character
	return result

func on_process_update(delta: float) -> void:
	if !is_node_ready() or index == -1:return
	var tag_pos:Vector2 = GBL.find_node(REFS.ROOM_NODES).get_room_position(index) * GBL.game_resolution
	self.global_position = tag_pos + Vector2(-25, 50)
	
	if shifted_val > 0:
		shifted_val -= 1		
		NameLabel.text = shift_string_backward(name_str, shifted_val)
		LvlLabel.text = shift_string_backward(lvl_str, shifted_val)
