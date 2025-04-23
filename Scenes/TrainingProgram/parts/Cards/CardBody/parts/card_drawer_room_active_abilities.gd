@tool
extends CardDrawerClass

@onready var AbilityList:VBoxContainer = $MarginContainer/MarginContainer/AbilityList

@export var room_details:Dictionary = {} : 
	set(val):
		room_details = val
		on_room_details_update()
		
const RoomAbilityBtnPreload:PackedScene = preload("res://UI/Buttons/RoomAbilityBtn/RoomAbilityBtn.tscn")		

func _ready() -> void:
	super._ready()

func on_room_details_update() -> void:
	if !is_node_ready() or room_details.is_empty():return
	
	#for node in AbilityList.get_children():
		#node.queue_free()
	##print(room_details)
#
	#if "abilities" in room_details:
		#var abilities:Array = room_details.abilities.call()
		#for ability_index in abilities.size():
			#var ability:Dictionary = abilities[ability_index]
			#var btn_node:Control = RoomAbilityBtnPreload.instantiate()
			#btn_node.ability_name = ability.name
			#btn_node.level = ability.lvl_required
			#btn_node.cost = ability.science_cost
			#btn_node.onFocus = func(_node:Control) -> void:
				#print("focused?")
			#btn_node.onBlur = func(_node:Control) -> void:
				#print("blur?")
			#btn_node.onClick = func() -> void:
				#print("clicked!")
			#AbilityList.add_child(btn_node)
			##ActiveAbilites.show()
	#else:
		#pass
		##ActiveAbilites.hide()
			#
	#if "passive_abilities" in room_details:
		#var passive_abilities:Array = room_details.passive_abilities.call()
		#for ability_index in passive_abilities.size():
			#var ability:Dictionary = passive_abilities[ability_index]
			#var btn_node:Control = RoomAbilityBtnPreload.instantiate()
			#AbilityList.add_child(btn_node)
			##var btn_node:Control = TextBtnPreload.instantiate()
			##btn_node.title = "Lvl-%s  %s" % [ability.lvl_required, ability.name]
			##btn_node.icon = SVGS.TYPE.NONE
			##PassiveAbilitiesList.add_child(btn_node)			
			##PassiveAbilities.show()
	#else:
		#pass
		##PassiveAbilities.hide()

func get_btns() -> Array:	
	return AbilityList.get_children()
