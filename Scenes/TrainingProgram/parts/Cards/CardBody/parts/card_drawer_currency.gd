@tool
extends CardDrawerClass

@onready var ListContainer:HBoxContainer = $MarginContainer/MarginContainer/VBoxContainer/ListContainer
@onready var SpecBonusLabel:Label = $MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxContainer/SpecBonusLabel
@onready var TraitBonusLabel:Label = $MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxContainer/TraitBonusLabel
@onready var MoraleBonusLabel:Label = $MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxContainer/MoraleBonusLabel
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
var use_location:Dictionary = {}

var is_researched:bool = true

const ResourceItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResourceContainer/parts/ResourceItem/ResourceItem.tscn")

func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	
func _ready() -> void:
	super._ready()
	on_list_update()
	
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	update_labels()
	on_list_update()
	
func update_labels() -> void:
	if !is_node_ready():return
	var morale_amount:int = morale_val * 20
	var total_amount:int = morale_amount	

	if has_spec_bonus:
		SpecBonusLabel.show()
		SpecBonusLabel.text = str("%s bonus +%s" % [spec_name, 100], "%") if has_spec_bonus else "No bonus from %s" % [spec_name]
		total_amount += 100
	else:
		SpecBonusLabel.hide()
	
	if has_trait_bonus:
		TraitBonusLabel.show()
		TraitBonusLabel.text =  str("%s bonus +%s" % [trait_name, 100], "%") 
		total_amount += 100
	else:
		TraitBonusLabel.hide()
	
	if morale_val != 0:
		MoraleBonusLabel.show() 
	else:
		MoraleBonusLabel.hide()

	MoraleBonusLabel.text =  str("%s bonus %s%s" % ["Morale", "+" if morale_val > 0 else "", morale_amount], "%")
	TotalBonusLabel.text = str("Applied bonus: %s%s" % ["+" if total_amount > 0 else "", total_amount], "%")


func on_list_update() -> void:
	if !is_node_ready() or room_config.is_empty():return
	for node in ListContainer.get_children():
		node.queue_free()
		
	if list.is_empty():return
	for item in list:
		var new_node:Control = ResourceItemPreload.instantiate()
		new_node.no_bg = true
		new_node.display_at_bottom = true
		# if a location is provided, it pulls for the total calculated in room_config
		if !use_location.is_empty():
			var currencies:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].currencies
			var applied_bonus:int = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room].applied_bonus
			new_node.title = str(currencies[item.ref]) if is_researched else "?"
		else:
			new_node.title = str(item.title) if is_researched else "?"
		new_node.icon = item.icon
		new_node.icon_size = Vector2(20, 20)
		
		new_node.is_hoverable = false
		
		ListContainer.add_child(new_node)
		
	
