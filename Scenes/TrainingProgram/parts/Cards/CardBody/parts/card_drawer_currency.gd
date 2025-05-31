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

@export var spec_name:String = "" 
@export var trait_name:String = "" 
@export var	has_spec_bonus:bool = false 
@export var	has_trait_bonus:bool = false 
@export var	morale_val:int = 0

var room_config:Dictionary = {}
var current_location:Dictionary = {}
var use_location:Dictionary = {}
var preview_mode:bool = false
var is_researched:bool = true

const ResourceItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResourceContainer/parts/ResourceItem/ResourceItem.tscn")

func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)

func _ready() -> void:
	super._ready()
	on_list_update()

func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	U.debounce(str(self.name, "_update_nodes"), on_list_update, 0.1)

func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	U.debounce(str(self.name, "_update_nodes"), on_list_update, 0.1)
	
func on_list_update() -> void:
	if !is_node_ready() or room_config.is_empty() or current_location.is_empty():return
	for node in ListContainer.get_children():
		node.queue_free()
		
	if list.is_empty():return
	for item in list:
		var new_node:Control = ResourceItemPreload.instantiate()
		new_node.no_bg = true
		new_node.display_at_bottom = true
		new_node.actual_val = int(item.title)
		# if a location is provided, it pulls for the total calculated in room_config
		if !preview_mode:
			if !use_location.is_empty():
				var currencies:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].currencies
				var applied_bonus:int = int(room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].applied_bonus * 100)
				new_node.second_val = currencies[item.ref]
				AppliedBonusLabel.text =  str("%s %s %s%s" % ["Morale", "bonus" if applied_bonus > 0 else "debuff", "+" if applied_bonus > 0 else "", applied_bonus], "%") if applied_bonus != 0 else "No bonuses"
				new_node.use_second_val = applied_bonus != 0
			else:
				var floor_config_data:Dictionary = room_config.floor[current_location.floor]
				var ring_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]
				var room_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].room[current_location.room]
				var floor_morale_val:int = floor_config_data.metrics[RESOURCE.METRICS.MORALE]
				var ring_morale_val:int = ring_config_data.metrics[RESOURCE.METRICS.MORALE]
				var room_morale_val:int = room_config_data.metrics[RESOURCE.METRICS.MORALE]
				var total_morale_val:int = floor_morale_val + ring_morale_val + room_morale_val
				var res:Dictionary = GAME_UTIL.apply_morale_bonus(current_location, total_morale_val, int(item.title), room_config)
				var applied_bonus:int = int(res.applied_bonus * 100)
				
				AppliedBonusLabel.text = str("%s %s %s%s" % ["Morale", "bonus" if applied_bonus > 0 else "debuff", "+" if applied_bonus > 0 else "", applied_bonus], "%") if applied_bonus != 0 else "No bonuses"
				new_node.second_val = str(res.amount)
				new_node.use_second_val = applied_bonus != 0
		else:
			new_node.use_second_val = false


		new_node.title = str(item.title) if is_researched else "?"
		new_node.icon = item.icon
		new_node.icon_size = Vector2(20, 20)
		
		new_node.is_hoverable = false
		
		ListContainer.add_child(new_node)
		
	
