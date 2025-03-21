@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."
@onready var IconBtn:Control = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/IconBtn
@onready var IndicatorBtn:Control = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/NewIndicatorBtn

@onready var TitleHeader:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/TitleHeader
@onready var KeyLabel:Label = $VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/KeyLabel

@export var assigned_key:String = "X" : 
	set(val):
		assigned_key = val
		on_assigned_key_update()
		
@export var panel_color:Color = Color(0.169, 0.169, 0.169) : 
	set(val):
		panel_color = val
		on_panel_color_update()		
	
@export var text_active_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE) :
	set(val): 
		text_active_color = val
		on_focus()
		
@export var text_inactive_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.INACTIVE) :
	set(val): 
		text_inactive_color = val
		on_focus()

@export var is_disabled:bool = false : 
	set(val):
		is_disabled = val
		on_is_disabled_updated()

const default_icon:SVGS.TYPE = SVGS.TYPE.TARGET

var title:String = "" : 
	set(val): 
		title = val
		on_title_update()

var room_ref:int = -1 
var ability_index:int = -1 
		
var icon:SVGS.TYPE = SVGS.TYPE.BUILD : 
	set(val):
		icon = val
		on_icon_update()		

var is_hovered:bool = false

var get_disable:Callable = func() -> bool:
	return false

var get_icon:Callable = func() -> SVGS.TYPE:
	return icon

var is_invalid:bool = false : 
	set(val):
		is_invalid = val
		on_is_invalid_update()


var type:String
var ability:Dictionary = {}
var base_states:Dictionary = {}
var room_config:Dictionary = {}
var current_location:Dictionary = {}

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.subscribe_to_control_input(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unsubscribe_to_control_input(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)

func _ready() -> void:
	super._ready()
	if is_hoverable:
		on_focus(false)

	on_icon_update()
	on_title_update()
	on_assigned_key_update()
	
	on_panel_color_update()
	on_is_disabled_updated()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_base_states_update(new_val:Dictionary = base_states) -> void:
	base_states = new_val
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	update_self()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_self() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty() or ability.is_empty():return
	match type:
		'passive':
			update_passive_type()
		'active':
			update_active_type()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func update_active_type() -> void:
	var designation:String = str(current_location.floor, current_location.ring)
	var extract_wing_data:Dictionary = GAME_UTIL.extract_wing_details()  #TODO: replace this with current level	
	var abilities:Dictionary = extract_wing_data.abilities	

	if room_ref in abilities:
		var filtered:Array = abilities[room_ref].filter(func(ab): return ab.level == ability_index )
		is_invalid = filtered.size() == 0

		if !filtered.is_empty():
			var ring_ability_level:int = GAME_UTIL.get_ring_ability_level()
			var at_level_requirement:bool = ring_ability_level >= ability_index
			var cooldown_duration:int = 0
			if ability.name in base_states.ring[designation].ability_on_cooldown:
				cooldown_duration = base_states.ring[designation].ability_on_cooldown[ability.name]
			#TODO REPLACE WITH COOLDOWN INDICATOR?
			# TODO NEEDS TO VISIBLE SHOW WHEN A SKILL IS INACTIVE AND THE REASON
			icon = default_icon if cooldown_duration == 0 else SVGS.TYPE.NO_ELECTRICITY


	
func update_passive_type() -> void:
	var designation:String = str(current_location.floor, current_location.ring)
	var extract_wing_data:Dictionary = GAME_UTIL.extract_wing_details()
	var ability_uid:String = str(room_ref, ability_index)
	var passive_abilities:Dictionary = extract_wing_data.passive_abilities	
	
	if room_ref in passive_abilities:
		var filtered:Array = passive_abilities[room_ref].filter(func(ab): return ab.level == ability_index )
		is_invalid = filtered.is_empty()
		
		if is_invalid:
			return
		
		if ability_uid in base_states.ring[designation].passives_enabled:
			var is_active:bool = base_states.ring[designation].passives_enabled[ability_uid]
			var energy_cost:int = ability.energy_cost if "energy_cost" in ability else 1			
			var energy:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].energy
			var energy_remaining:int = energy.available - energy.used
			var has_enough:bool = energy_remaining - energy_cost >= 0

			is_invalid = !is_active and !has_enough

			icon = default_icon #if has_enough  else SVGS.TYPE.NO_ELECTRICITY
# ------------------------------------------------------------------------------	



# ------------------------------------------------------------------------------
func set_refs(_type:String, _room_ref:int, _ability_index:int) -> void:
	type = _type
	room_ref = _room_ref
	ability_index = _ability_index
	match type: 
		"active":
			ability = ROOM_UTIL.return_ability(room_ref, ability_index)
			icon = SVGS.TYPE.TARGET
		"passive":
			ability = ROOM_UTIL.return_passive_ability(room_ref, ability_index)
			
	title = ability.name


func update_color(new_color:Color) -> void:
	if !is_node_ready():return

func on_focus(state:bool = is_focused) -> void:
	if !is_disabled:	
		super.on_focus(state)
		on_panel_color_update()
	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if !is_node_ready() or !is_hoverable or is_disabled or is_invalid:return
	super.on_mouse_click(node, btn, on_hover)
		
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_assigned_key_update() -> void:
	if !is_node_ready():return
	KeyLabel.text = assigned_key
	
func on_is_invalid_update() -> void:
	on_icon_update()
	on_is_disabled_updated()
		
func on_is_disabled_updated() -> void:
	modulate = Color(1, 0, 0, 1) if is_disabled or is_invalid else Color(1, 1, 1, 1)
	
func on_panel_color_update() -> void:
	if !is_node_ready():return
	var new_stylebox:StyleBoxFlat = StyleBoxFlat.new()
	new_stylebox.bg_color = panel_color
	new_stylebox.corner_radius_bottom_left = 5
	new_stylebox.corner_radius_bottom_right = 5
	new_stylebox.corner_radius_top_left = 5
	new_stylebox.corner_radius_top_right = 5
	
	new_stylebox.border_width_bottom = 2
	new_stylebox.border_width_left = 2
	new_stylebox.border_width_right = 2
	new_stylebox.border_width_top = 2
	new_stylebox.border_color = Color.WHITE if is_focused else Color.BLACK
		
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)
		

func on_title_update() -> void:
	if !is_node_ready():return
	TitleHeader.text = title

func on_icon_update() -> void:
	if !is_node_ready():return	
	IconBtn.icon = SVGS.TYPE.DELETE if is_invalid else icon
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or !is_hoverable or is_disabled or is_invalid:return
	var key:String = input_data.key
	if key == assigned_key and is_visible_in_tree():
		onClick.call()
# ------------------------------------------------------------------------------
