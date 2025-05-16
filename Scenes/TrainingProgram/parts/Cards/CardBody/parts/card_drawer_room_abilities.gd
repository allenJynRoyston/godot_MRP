@tool
extends CardDrawerClass

@onready var BusyPanel:MarginContainer = $BusyPanel
@onready var AbilityList:VBoxContainer = $MarginContainer/MarginContainer/AbilityList

@export var room_details:Dictionary = {} : 
	set(val):
		room_details = val
		on_room_details_update()
		
@export var ability_type:ABILITY_TYPE = ABILITY_TYPE.ACTIVE 

enum ABILITY_TYPE {ACTIVE, PASSIVE}

		
const RoomAbilityBtnPreload:PackedScene = preload("res://UI/Buttons/RoomAbilityBtn/RoomAbilityBtn.tscn")		
const RoomPassiveAbilityBtnPreload:PackedScene = preload("res://UI/Buttons/RoomPassiveAbilityBtn/RoomPassiveAbilityBtn.tscn")

var preview_mode:bool = false
var use_location:Dictionary = {}
var onLock:Callable = func() -> void:pass
var onUnlock:Callable = func() -> void:pass

func _ready() -> void:
	super._ready()
	BusyPanel.hide()

func clear() -> void:
	for node in AbilityList.get_children():
		node.queue_free()

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
				
				btn_node.room_ref = room_details.ref
				btn_node.ability_index = ability_index
				btn_node.ability_name = ability.name
				btn_node.use_location = use_location
				btn_node.panel_color = border_color
				
				btn_node.is_unknown = ability.lvl_required >= 1 if !preview_mode else false
				btn_node.cost = ability.science_cost
				btn_node.ability_data = ability

				btn_node.onClick = func() -> void:
					if preview_mode or !is_visible_in_tree():return
					if btn_node.on_cooldown or btn_node.is_unavailable or btn_node.is_unknown:return
					
					var ActionContainerNode:Control = GBL.find_node(REFS.ACTION_CONTAINER)
					if ActionContainerNode.is_visible_in_tree():
						# first, disables btns in the card
						onLock.call()
						# then disables the btn controls
						await ActionContainerNode.BtnControls.reveal(false)	
						# perform the ability
						await GAME_UTIL.use_active_ability(ability, room_details.ref, ability_index, use_location)
						# unlocks
						onUnlock.call()
						ActionContainerNode.BtnControls.reveal(true)	
						return
				
					GAME_UTIL.use_active_ability(ability, room_details.room_ref, ability_index, use_location)
					
				AbilityList.add_child(btn_node)

			
	if ability_type == ABILITY_TYPE.PASSIVE:
		if "passive_abilities" in room_details:
			var passive_abilities:Array = room_details.passive_abilities.call()
			for ability_index in passive_abilities.size():
				var ability:Dictionary = passive_abilities[ability_index]
				var btn_node:Control = RoomPassiveAbilityBtnPreload.instantiate()
				
				btn_node.room_ref = room_details.ref
				btn_node.ability_index = ability_index
				btn_node.ability_name = ability.name
				btn_node.use_location = use_location
				btn_node.panel_color = border_color

				
				btn_node.is_unknown = ability.lvl_required >= 1 if !preview_mode else false
				btn_node.cost = ability.energy_cost
				btn_node.ability_data = ability			
				
				btn_node.onClick = func() -> void:
					if preview_mode or !is_visible_in_tree():return
					GAME_UTIL.toggle_passive_ability(room_details.ref, ability_index, use_location)					
						
				AbilityList.add_child(btn_node)


func lock_btns(state:bool) -> void:
	BusyPanel.show() if state else BusyPanel.hide()
	for btn in AbilityList.get_children():
		btn.is_hoverable = !state


func get_btns() -> Array:	
	return AbilityList.get_children()
