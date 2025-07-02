@tool
extends CardDrawerClass

@onready var ListContainer:HBoxContainer = $MarginContainer/MarginContainer/VBoxContainer/ListContainer
@onready var SpecBonusLabel:Label = $MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxContainer/SpecBonusLabel
@onready var TraitBonusLabel:Label = $MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxContainer/TraitBonusLabel
@onready var AppliedBonusLabel:Label = $MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/AppliedBonusLabel
@onready var TotalBonusLabel:Label = $MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/TotalBonusLabel

@export var list:Array = [] : 
	set(val):
		list = val
		on_list_update()

@export var	morale_val:int = 0

var room_details:Dictionary = {}
var room_config:Dictionary = {}
var current_location:Dictionary = {}
var use_location:Dictionary = {}
var preview_mode:bool = false
var is_researched:bool = true

const ResourceItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResourceContainer/parts/ResourceItem/ResourceItem.tscn")

# -----------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)

func _ready() -> void:
	super._ready()
	on_list_update()
# -----------------------------

# -----------------------------
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	U.debounce(str(self.name, "_update_nodes"), on_list_update, 0.1)

func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	U.debounce(str(self.name, "_update_nodes"), on_list_update, 0.1)
	
func get_is_activated() -> bool:
	if !use_location.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
		return false if extract_data.room.is_empty() else extract_data.room.is_activated		
		
	return false	
# -----------------------------

# -----------------------------
func on_list_update() -> void:
	if !is_node_ready() or room_config.is_empty() or current_location.is_empty():return
	
	for node in [ListContainer ]:
		for child in node.get_children():
			child.queue_free()
		
	if list.is_empty():return
	
	for item in list:
		var new_node:Control = ResourceItemPreload.instantiate()
		var base_value:int = int(item.title)
		var base_amount:int = 0 if !get_is_activated() else room_details.currencies[item.ref]
		
		new_node.no_bg = true
		new_node.display_at_bottom = true
		new_node.actual_val = base_amount
		new_node.title = str(base_amount) if is_researched else "?"
		new_node.use_second_val = true


		new_node.icon = item.icon
		new_node.icon_size = Vector2(20, 20)
		
		new_node.is_hoverable = false
		
		ListContainer.add_child(new_node)
# -----------------------------
	
