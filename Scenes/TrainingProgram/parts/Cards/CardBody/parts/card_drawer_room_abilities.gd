@tool
extends CardDrawerClass

enum ABILITY_TYPE {ACTIVE, PASSIVE}

@onready var AbilityList:VBoxContainer = $MarginContainer/MarginContainer/AbilityList

@export var room_details:Dictionary = {} : 
	set(val):
		room_details = val
		on_room_details_update()
		
@export var ability_type:ABILITY_TYPE = ABILITY_TYPE.ACTIVE 
		
const RoomAbilityBtnPreload:PackedScene = preload("res://UI/Buttons/RoomAbilityBtn/RoomAbilityBtn.tscn")		
const RoomPassiveAbilityBtnPreload:PackedScene = preload("res://UI/Buttons/RoomPassiveAbilityBtn/RoomPassiveAbilityBtn.tscn")

var onUseAbility:Callable = func():pass

func _ready() -> void:
	super._ready()

func on_room_details_update() -> void:
	if !is_node_ready() or room_details.is_empty():return
	
	for node in AbilityList.get_children():
		node.queue_free()

	if ability_type == ABILITY_TYPE.ACTIVE :
		if "abilities" in room_details:
			var abilities:Array = room_details.abilities.call()
			for ability_index in abilities.size():
				var ability:Dictionary = abilities[ability_index]
				var btn_node:Control = RoomAbilityBtnPreload.instantiate()
				
				btn_node.ability_name = ability.name
				
				btn_node.level = ability.lvl_required
				btn_node.cost = ability.science_cost
				btn_node.ability_data = ability

				btn_node.onClick = func() -> void:
					onUseAbility.call({"type": "active", "ability": ability})
					
				AbilityList.add_child(btn_node)
		else:
			pass
			
	if ability_type == ABILITY_TYPE.PASSIVE:
		if "passive_abilities" in room_details:
			var passive_abilities:Array = room_details.passive_abilities.call()
			for ability_index in passive_abilities.size():
				var ability:Dictionary = passive_abilities[ability_index]
				var btn_node:Control = RoomPassiveAbilityBtnPreload.instantiate()
				
				btn_node.room_ref = room_details.ref
				btn_node.ability_index = ability_index
				btn_node.ability_name = ability.name
				
				btn_node.level = 0
				btn_node.cost = 0
				btn_node.ability_data = ability			
				
				btn_node.onClick = func() -> void:
					onUseAbility.call({"type": "passive", "ability": ability, "ability_index": ability_index})
						
				AbilityList.add_child(btn_node)
		else:
			pass
			#PassiveAbilities.hide()

func get_btns() -> Array:	
	return AbilityList.get_children()
