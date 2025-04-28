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

const ResourceItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResourceContainer/parts/ResourceItem/ResourceItem.tscn")

func _ready() -> void:
	super._ready()
	on_list_update()
	update_labels()
	
func update_labels() -> void:
	if !is_node_ready():return
	
	if has_spec_bonus:
		SpecBonusLabel.show()
		SpecBonusLabel.text = str("%s bonus +%s" % [spec_name, 50], "%") if has_spec_bonus else "No bonus from %s" % [spec_name]
	else:
		SpecBonusLabel.hide()
	
	if has_trait_bonus:
		TraitBonusLabel.show()
		TraitBonusLabel.text =  str("%s bonus +%s" % [trait_name, 50], "%") 
	else:
		TraitBonusLabel.hide()
		
	var morale_amount:int = morale_val * 20		
	var total_amount:int = morale_amount
	if has_spec_bonus:
		total_amount += 50
	if has_trait_bonus:
		total_amount += 50
		
		
	MoraleBonusLabel.text =  str("%s bonus %s%s" % ["Morale", "+" if morale_val > 0 else "", morale_amount], "%")
	TotalBonusLabel.text = str("Applied bonus: %s%s" % ["+" if total_amount > 0 else "", total_amount], "%")


func on_list_update() -> void:
	if !is_node_ready():return
	for node in ListContainer.get_children():
		node.queue_free()
		
	if list.is_empty():return
	
	for item in list:
		var new_node:Control = ResourceItemPreload.instantiate()
		new_node.no_bg = true
		new_node.display_at_bottom = true
		new_node.title = str(item.title)
		new_node.icon = item.icon
		new_node.icon_size = Vector2(20, 20)
		
		new_node.is_hoverable = false
		
		ListContainer.add_child(new_node)
		
	
