extends Control

@onready var ConstructionIcon:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ConstructionIcon
@onready var StatusIcon:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/StatusIcon
@onready var NameLabel:Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NameLabel
@onready var ListContainer:Control = $PanelContainer/MarginContainer/VBoxContainer/ListContainer
@onready var DownArrowIcon:Control = $PanelContainer/Control/DownArrowIcon

@onready var name_label_settings:LabelSettings = NameLabel.get("label_settings").duplicate()

@export var show_resource_reason:bool = false : 
	set(val):
		show_resource_reason = val
		on_show_resource_reason_update()

@export var index:int = -1 : 
	set(val):
		index = val
		on_index_update()
		
@export var fade:bool = false : 
	set(val):
		fade = val
		on_fade_update()

@export var ignore_current_location:bool = false

const VibeItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/HeaderControl/parts/VibeItem/VibeItem.tscn")
const EcoItemPreload:PackedScene = preload("res://UI/EconItem/EconItem.tscn")
const fade_int:float = 5

var room_config:Dictionary = {}
var current_location:Dictionary = {}
var offset:Vector2
var name_str:String
var shifted_val:int = 5
var is_room_empty:bool 

var previous_ring:int
var previous_floor:int

# --------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	GBL.subscribe_to_process(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	GBL.unsubscribe_to_process(self)

func _ready() -> void:
	NameLabel.set("label_settings", name_label_settings)
	
	#on_fade_update()
	hide()
	await U.tick()
	on_index_update()
	on_show_resource_reason_update()
	
# --------------------------------------------

# --------------------------------------------
func on_show_resource_reason_update() -> void:
	if !is_node_ready():return
	pass
# --------------------------------------------

# --------------------------------------------	
func on_fade_update() -> void:
	if !is_node_ready():return
	
	if !fade:
		update_node()
	
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 0 if fade else 1), 0.1)
	U.tween_range(fade_int if fade else 0.0, fade_int if !fade else 0.0, 0.3, func(val:float) -> void:
		offset.x = val
	) 			
# --------------------------------------------

# --------------------------------------------
func on_index_update() -> void:
	await U.tick()
	U.debounce(str(self.name, "_nametag_update_node"), func():update_node())
# --------------------------------------------

# --------------------------------------------
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if current_location.is_empty():return
	
	if previous_ring != current_location.ring or previous_floor != current_location.floor:
		previous_ring = current_location.ring 
		previous_floor = current_location.floor

		U.debounce(str(self.name, "_nametag_update_node"), func():update_node())

func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	await U.tick()
	U.debounce(str(self.name, "_nametag_update_node"), func():update_node())

# --------------------------------------------

# --------------------------------------------
func shift_string_backward(text: String, shift: int = 5) -> String:
	var result:String = ""
	for char in text:
		if char == " ":
			result += " "  # Keep spaces unchanged
		else:
			result += char(char.unicode_at(0) - shift)  # Convert back to character
	return result
# --------------------------------------------

# --------------------------------------------
func update_node(shift_val:int = 10) -> void:
	if !is_node_ready() or room_config.is_empty() or current_location.is_empty() or index == -1:return
	shifted_val = shift_val
	
	# clear list
	for child in ListContainer.get_children():
		child.queue_free()
	
	# get location
	var use_location:Dictionary = current_location.duplicate()
	use_location.room = index
	
	# hide/show currency icons
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(use_location)
	is_room_empty = room_extract.room.is_empty()
	self.modulate = Color(1, 1, 1, 1 if !is_room_empty or !fade else 0)
	
	if is_room_empty:
		hide()
		return
	
	var room_details:Dictionary = ROOM_UTIL.return_data(room_extract.room.details.ref)
	var room_level_config:Dictionary = GAME_UTIL.get_room_level_config(use_location)
	var is_under_construction:bool = ROOM_UTIL.is_under_construction(use_location)
	var currencies:Dictionary = room_level_config.currencies
	var metrics:Dictionary = room_level_config.metrics
	var is_activated:bool = room_extract.room.is_activated

	for ref in currencies:
		var amount:int = currencies[ref]
		if amount != 0:
			var new_node:Control = EcoItemPreload.instantiate()
			var resource_details:Dictionary = RESOURCE_UTIL.return_currency(ref)
			new_node.amount = amount
			new_node.icon = resource_details.icon
			ListContainer.add_child(new_node)

	for ref in metrics:
		var amount:int = metrics[ref]
		if amount != 0:
			var new_node:Control = VibeItemPreload.instantiate()
			var resource_details:Dictionary = RESOURCE_UTIL.return_metric(ref)
			new_node.value = amount
			new_node.metric = ref
			new_node.invert_color = true
			new_node.big_numbers = true
			ListContainer.add_child(new_node)
				
	
	name_label_settings.font_size = 12 #16 if room_details.is_core else 12
	name_label_settings.font_color = Color.RED if is_under_construction or (!is_under_construction and !is_activated) else Color.BLACK
	ConstructionIcon.show() if is_under_construction else ConstructionIcon.hide()
	StatusIcon.show() if !is_under_construction else StatusIcon.hide()
	StatusIcon.icon_color = Color.DARK_GREEN if is_activated else Color.DARK_RED
	await U.set_timeout(0.7)
	name_str = room_extract.room.details.shortname if !is_room_empty else ""
	show()
	
# --------------------------------------------

# -------------------------------------------- update location
func on_process_update(delta:float, _time_passed:float) -> void:
	if !is_node_ready() or !is_visible_in_tree() or index == -1:return
	var tag_pos:Vector2 = GBL.find_node(REFS.WING_RENDER).get_room_position(index) * GBL.game_resolution 
	self.global_position = tag_pos - Vector2(self.size.x/2, self.size.y + 40)
	DownArrowIcon.position = Vector2(self.size.x/2 - DownArrowIcon.size.x/2, self.size.y - 8)

func _physics_process(delta: float) -> void:
	if !is_node_ready() or !is_visible_in_tree() or index == -1:return
	if shifted_val > 0:
		shifted_val -= 1		
		NameLabel.text = shift_string_backward(name_str, shifted_val)
	self.size = Vector2(1, 1)	
# --------------------------------------------
