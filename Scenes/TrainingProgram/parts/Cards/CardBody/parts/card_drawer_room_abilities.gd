@tool
extends CardDrawerClass

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
var abl_lvl:int = 0 : 
	set(val):
		abl_lvl = val
		on_abl_lvl_update()
		
var onLock:Callable = func() -> void:pass
var onUnlock:Callable = func() -> void:pass

func _ready() -> void:
	super._ready()

func clear() -> void:
	for node in AbilityList.get_children():
		node.free()

func on_room_details_update() -> void:
	if !is_node_ready() or room_details.is_empty():return
	clear()
	
	if ability_type == ABILITY_TYPE.ACTIVE :
		if "abilities" in room_details:
			var abilities:Array = room_details.abilities.call()
			for ability_index in abilities.size():
				var ability:Dictionary = abilities[ability_index]
				var btn_node:Control = RoomAbilityBtnPreload.instantiate()
				var abl_lvl:int = 0
				if !use_location.is_empty():
					var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
					abl_lvl = extract_data.room.abl_lvl
				
				# set
				btn_node.room_ref = room_details.ref
				btn_node.ability_index = ability_index
				btn_node.use_location = use_location
				btn_node.panel_color = border_color
				btn_node.abl_lvl = abl_lvl
				btn_node.preview_mode = preview_mode
				
				# update this last
				btn_node.ability_data = ability
				
				btn_node.onClick = func() -> void:
					if preview_mode or !is_visible_in_tree() or !btn_node.is_clickable():return
					
					var ActionContainerNode:Control = GBL.find_node(REFS.ACTION_CONTAINER)
					if ActionContainerNode.is_visible_in_tree():
						# first, disables btns in the card
						onLock.call()
						# then disables the btn controls
						await ActionContainerNode.before_use_ability()
						# perform the ability
						await GAME_UTIL.use_active_ability(ability, room_details.ref, ability_index, use_location)
						# unlocks
						onUnlock.call()
						ActionContainerNode.after_use_ability()
						return
				
					GAME_UTIL.use_active_ability(ability, room_details.room_ref, ability_index, use_location)
					
				AbilityList.add_child(btn_node)

			
	if ability_type == ABILITY_TYPE.PASSIVE:
		if "passive_abilities" in room_details:
			var passive_abilities:Array = room_details.passive_abilities.call()
			for ability_index in passive_abilities.size():
				var ability:Dictionary = passive_abilities[ability_index]
				var btn_node:Control = RoomPassiveAbilityBtnPreload.instantiate()
				var abl_lvl:int = 10 if preview_mode else 0				
				if !use_location.is_empty():
					var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
					abl_lvl = extract_data.room.abl_lvl
				
				btn_node.room_ref = room_details.ref
				btn_node.ability_index = ability_index
				btn_node.ability_name = ability.name
				btn_node.use_location = use_location
				btn_node.panel_color = border_color
				btn_node.abl_lvl = abl_lvl
				btn_node.preview_mode = preview_mode

				btn_node.ability_data = ability			
				
				btn_node.onClick = func() -> void:
					if preview_mode or !is_visible_in_tree():return
					GAME_UTIL.toggle_passive_ability(room_details.ref, ability_index, use_location)
					var ActionContainerNode:Control = GBL.find_node(REFS.ACTION_CONTAINER)
					if ActionContainerNode.is_visible_in_tree():
						ActionContainerNode.after_use_passive_ability.call()
					
						
				AbilityList.add_child(btn_node)
	
	on_abl_lvl_update()
	
func on_abl_lvl_update() -> void:
	if !is_node_ready():return
	for child in AbilityList.get_children():
		child.abl_lvl = abl_lvl

func lock_btns(state:bool) -> void:
	for btn in AbilityList.get_children():
		btn.is_hoverable = !state


func get_btns() -> Array:	
	return AbilityList.get_children()
