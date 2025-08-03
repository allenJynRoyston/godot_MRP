extends PanelContainer

@onready var List:VBoxContainer = $MarginContainer/List


@export var room_details:Dictionary = {} : 
	set(val):
		room_details = val
		on_room_details_update()

@export var ability_type:ABILITY_TYPE = ABILITY_TYPE.ACTIVE 

enum ABILITY_TYPE {ACTIVE, PASSIVE}

const SummaryBtnPreload:PackedScene = preload("res://UI/Buttons/SummaryBtn/SummaryBtn.tscn")

var preview_mode:bool = false
var previous_room:int = -1
var previous_ring:int = -1
var cooldown_val:int = 0
var redraw:bool = false
var NodeList:Array = []

var previous_location:Dictionary = {}
var room_config:Dictionary = {} 
var base_states:Dictionary = {} 
var resources_data:Dictionary = {}
var scp_data:Dictionary = {}
var use_location:Dictionary = {} : 
	set(val):
		use_location = val
		on_use_location_update()		
		
var onLock:Callable = func() -> void:pass
var onUnlock:Callable = func() -> void:pass



# -----------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_scp_data(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_scp_data(self)
	
# -----------------------------------------------------------
func clear() -> void:
	for node in List.get_children():
		node.free()

func on_room_details_update() -> void:
	if !is_node_ready() or room_details.is_empty():return
	U.debounce(str(self, "_build_list"), build_list)

func on_use_location_update() -> void:
	if !is_node_ready() or use_location.is_empty():return
	U.debounce(str(self, "_build_list"), build_list)
	U.debounce(str(self, "_update_node"), update_node)
	
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	U.debounce(str(self, "_update_node"), update_node)

func on_base_states_update(new_val:Dictionary = base_states) -> void:
	base_states = new_val
	U.debounce(str(self, "_update_node"), update_node)	

func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
	U.debounce(str(self, "_update_node"), update_node)

func on_scp_data_update(new_val:Dictionary) -> void:
	scp_data = new_val
	U.debounce(str(self, "_update_node"), update_node)

var previous_room_ref:int = -1
func build_list() -> void:	
	if use_location.is_empty() or room_details.is_empty():return
	if previous_room != use_location.room or previous_ring != use_location.ring or room_details.ref != previous_room_ref:
		previous_room = use_location.room
		previous_ring = use_location.ring
		previous_room_ref = room_details.ref
		redraw = true	
		NodeList = []

		match ability_type:
			ABILITY_TYPE.ACTIVE :
				if "abilities" in room_details:
					var abilities:Array = room_details.abilities.call()
					for ability_index in abilities.size():
						var new_btn:Control = SummaryBtnPreload.instantiate()
						new_btn.index = ability_index
						new_btn.ref_data = {"type": "room", "data": abilities}
						new_btn.onClick = func() -> void:pass
						NodeList.push_back(new_btn)
						
			ABILITY_TYPE.PASSIVE :
				if "passive_abilities" in room_details:
					var passive_abilities:Array = room_details.passive_abilities.call()
					for ability_index in passive_abilities.size():
						var new_btn:Control = SummaryBtnPreload.instantiate()
						new_btn.index = ability_index
						new_btn.ref_data = {"type": "passive_ability", "data": passive_abilities}
						new_btn.onClick = func() -> void:pass
						NodeList.push_back(new_btn)
						
		U.debounce(str(self, "_update_node"), update_node)	

func update_node() -> void:
	if !is_node_ready() or room_config.is_empty() or room_details.is_empty() or base_states.is_empty() or resources_data.is_empty() or use_location.is_empty():return
	var ActionContainerNode:Control = GBL.find_node(REFS.ACTION_CONTAINER)
	var is_activated:bool = ROOM_UTIL.is_room_activated(use_location) 
	var abl_lvl:int =  ROOM_UTIL.get_room_ability_level(use_location)
	var use_list:Array = List.get_children()
	
	
	for index in NodeList.size():
		var SummaryBtnNode:Control = NodeList[index]

		match ability_type:
			ABILITY_TYPE.ACTIVE:
				var abilities:Array = room_details.abilities.call()	
				if abilities.size() > index:
					var ability:Dictionary = abilities[index]
					var designation:String = U.location_to_designation(use_location)
					var ability_uid:String = str(room_details.ref, index)	
					var on_cooldown:bool = false
					var at_level_threshold:bool = ability.lvl_required <= abl_lvl
					var cooldown_val:int = 0
					
					if ability_uid in base_states.room[designation].ability_on_cooldown:
						cooldown_val = base_states.room[designation].ability_on_cooldown[ability_uid]		
						on_cooldown = base_states.room[designation].ability_on_cooldown[ability_uid] > 0

					SummaryBtnNode.ref_data = {
						"type": 'active_ability', 
						"data": ability,
						"is_disabled": !is_activated or !at_level_threshold
					}
					
					SummaryBtnNode.hint_title = "HINT"
					SummaryBtnNode.hint_icon =  SVGS.TYPE.FROZEN if on_cooldown else SVGS.TYPE.CONVERSATION
					if !at_level_threshold:
						SummaryBtnNode.hint_description = "Requires upgrade (room level too low)."
					else:					
						SummaryBtnNode.hint_description = "Requires activation" if !is_activated else ability.description if !on_cooldown else "%s (on cooldown for %s days)." % [ability.description, cooldown_val]
					
					SummaryBtnNode.is_disabled = !is_activated or !at_level_threshold
					SummaryBtnNode.use_alt = on_cooldown
					SummaryBtnNode.title = "UNAVAILABLE" if !is_activated else ability.name if !on_cooldown else 'COOLDOWN (%s)' % [cooldown_val]
					SummaryBtnNode.icon =  SVGS.TYPE.LOCK if !is_activated else SVGS.TYPE.FROZEN if on_cooldown else SVGS.TYPE.MEDIA_PLAY
					SummaryBtnNode.onClick = func() -> void:
						if preview_mode or !is_visible_in_tree():return
						if ActionContainerNode.is_visible_in_tree():
							onLock.call()
							await ActionContainerNode.before_use()
							await GAME_UTIL.use_active_ability(ability, room_details.ref, index, use_location)
							onUnlock.call()
							ActionContainerNode.after_use()
							return
					
						GAME_UTIL.use_active_ability(ability, room_details.room_ref, index, use_location)
							
			ABILITY_TYPE.PASSIVE:
				var abilities:Array = room_details.passive_abilities.call()	
				if abilities.size() > index:
					var ability:Dictionary = abilities[index]
					var scp_needed:bool = false
					var designation:String = U.location_to_designation(use_location)
					var ability_uid:String = str(room_details.ref, index)	
					var is_active = base_states.room[designation].passives_enabled[ability_uid] if ability_uid in base_states.room[designation].passives_enabled else false	
					var at_level_threshold:bool = ability.lvl_required <= abl_lvl
					
					# check if scp is required for passive to be used
					if "scp_required" in ability and ability.scp_required:
						var has_scp:bool = false
						for ref in scp_data:
							if scp_data[ref].location == use_location:
								has_scp = true
								break
						scp_needed = ability.scp_required and !has_scp 				
					
					# check if it has enough energy to work
					var not_enough_energy:bool = false
					if !is_active: 
						var energy:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].energy
						var energy_left:int = energy.available - energy.used
						not_enough_energy = energy_left < ability.energy_cost
					
					SummaryBtnNode.ref_data = {
						"type": 'passive_ability', 
						"data": ability,
						"is_disabled": !is_activated or !at_level_threshold
					}				
					
					SummaryBtnNode.hint_title = "HINT"
					SummaryBtnNode.hint_icon =  SVGS.TYPE.ENERGY
					if !at_level_threshold:
						SummaryBtnNode.hint_description = "Requires upgrade (room level too low)."
					else:
						SummaryBtnNode.hint_description = "Requires activation" if !is_activated else ability.description if !not_enough_energy else "%s (not enough energy)." % [ability.description]

					SummaryBtnNode.is_disabled = !is_activated or not_enough_energy or !at_level_threshold
					SummaryBtnNode.title = "UNAVAILABLE" if !is_activated else ability.name
					SummaryBtnNode.icon = SVGS.TYPE.LOCK if !is_activated else SVGS.TYPE.DELETE if not_enough_energy or scp_needed else SVGS.TYPE.DELETE
					
					SummaryBtnNode.show_checked_panel = true
					SummaryBtnNode.is_checked = is_active
					
					SummaryBtnNode.show_energy_cost = is_activated
					SummaryBtnNode.energy_cost = ability.energy_cost
					
					SummaryBtnNode.hide_icon = true
					
					SummaryBtnNode.onClick = func() -> void:
						if preview_mode or !is_visible_in_tree():return
						GAME_UTIL.toggle_passive_ability(room_details.ref, index, use_location)
						if ActionContainerNode.is_visible_in_tree():
							ActionContainerNode.after_use_passive_ability.call()
					
		if redraw:
			List.add_child(SummaryBtnNode)
	
	redraw = false
	for node in List.get_children():
		if node not in NodeList:
			node.free()
		

func lock_btns(state:bool) -> void:
	if !is_node_ready():return


func get_btns() -> Array:	
	var btn_list:Array = []
	for item in List.get_children():
		if item.is_visible_in_tree():
			btn_list.push_back(item)
	return btn_list
