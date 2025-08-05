@tool
extends CardDrawerClass

@onready var ListContainer:HBoxContainer = $MarginContainer/MarginContainer/VBoxContainer/ListContainer
@export var list:Dictionary = {} : 
	set(val):
		list = val
		on_list_update()

@export var hollow:bool = false : 
	set(val):
		hollow = val
		on_hollow_update()
		
var room_details:Dictionary = {}
var room_config:Dictionary = {}
var current_location:Dictionary = {}
var use_location:Dictionary = {}
var preview_mode:bool = false
var is_researched:bool = true

const EconItemPreload:PackedScene = preload("res://UI/EconItem/EconItem.tscn")
var OrangePanelPreload:StyleBoxFlat = preload("res://Styles/OrangePanel.tres").duplicate()

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
func on_hollow_update() -> void:
	if !is_node_ready():return
	$".".set('theme_override_styles/panel', null if hollow else OrangePanelPreload)	
	
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	U.debounce(str(self.name, "_update_nodes"), on_list_update)

func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	U.debounce(str(self.name, "_update_nodes"), on_list_update)
	
func get_is_activated() -> bool:
	if !use_location.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
		return false if extract_data.room.is_empty() else extract_data.room.is_activated		
		
	return false	
# -----------------------------

# -----------------------------
func on_list_update() -> void:
	if !is_node_ready():return
		
	for node in [ListContainer]:
		for child in node.get_children():
			child.queue_free()
		
	if list.is_empty():return
	

	for ref in list:
		var item:Dictionary = list[ref]
		# gets the amount of just the room, but the room_config contains values of any passives and bonuses also applied
		var amount:int = item.amount #if !preview_mode else room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].currencies[item.ref]
		var bonus_amount:int = item.bonus_amount
		
		if (amount + bonus_amount) != 0:		
			var new_node:Control = EconItemPreload.instantiate()
			new_node.amount = amount + bonus_amount
			new_node.bonus_amount = 0
			new_node.is_negative = amount < 0
			new_node.icon = item.icon
			new_node.icon_size = Vector2(20, 20)
			new_node.invert_colors = true
			new_node.horizontal_mode = true
			
			ListContainer.add_child(new_node)
# -----------------------------
	
