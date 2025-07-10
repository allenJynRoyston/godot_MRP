@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."

@onready var CostAndCooldownContainer:PanelContainer = $MarginContainer/HBoxContainer/CostAndCooldown
@onready var CostLabel:Label = $MarginContainer/HBoxContainer/CostAndCooldown/MarginContainer/HBoxContainer/CostLabel
@onready var IconBtn:Control = $MarginContainer/HBoxContainer/CostAndCooldown/MarginContainer/HBoxContainer/SVGIcon
@onready var NameLabel:Label = $MarginContainer/HBoxContainer/Name/MarginContainer/HBoxContainer/NameLabel
@onready var Checkbox:Control = $MarginContainer/HBoxContainer/Name/MarginContainer/HBoxContainer/CheckBox

@export var panel_color:Color = Color("0e0e0ecb") : 
	set(val):
		panel_color = val
		on_panel_color_update()		

@export var cost:int : 
	set(val):
		cost = val
		on_cost_update()

@export var ability_name:String = "" : 
	set(val): 
		ability_name = val
		on_ability_name_update()

@export var preview_mode:bool = false
@export var abl_lvl:int = 0 :
	set(val):
		abl_lvl = val
		on_abl_lvl_update()
@export var required_lvl:int = 0

var room_config:Dictionary = {}
var scp_data:Dictionary = {}
var base_states:Dictionary = {} 
var use_location:Dictionary = {} : 
	set(val):
		use_location = val
		on_base_states_update()

var lvl_locked:bool = false
var is_active:bool = false 
var scp_needed:bool = false
var not_enough_energy = false

var border_color:Color

var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()

# directly access, do not remove
var type:String 
var room_ref:int
var ability_data:Dictionary = {} : 
	set(val):
		ability_data = val
		on_ability_data_update()
var ability_index:int

const LabelSettingsPreload:LabelSettings = preload("res://Fonts/font_1_black.tres")

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	SUBSCRIBE.subscribe_to_scp_data(self)

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.subscribe_to_room_config(self)	
	SUBSCRIBE.unsubscribe_to_base_states(self)
	SUBSCRIBE.unsubscribe_to_scp_data(self)
	
func _ready() -> void:
	super._ready()
	on_is_selected_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_all() -> void:
	# check for level lock
	lvl_locked = abl_lvl < ability_data.lvl_required	
	

	if !use_location.is_empty():
		# check if scp is required for passive to be used
		if "scp_required" in ability_data and ability_data.scp_required:
			var has_scp:bool = false
			for ref in scp_data:
				if scp_data[ref].location == use_location:
					has_scp = true
					break
			scp_needed = ability_data.scp_required and !has_scp 
		
		# check if active
		var ability_uid:String = str(room_ref, ability_index)	
		var designation:String = U.location_to_designation(use_location)
		is_active = base_states.room[designation].passives_enabled[ability_uid] if ability_uid in base_states.room[designation].passives_enabled else false	
		
		
		# check if it has enough energy to work
		if !is_active: 
			var energy:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].energy
			var energy_left:int = energy.available - energy.used
			not_enough_energy = energy_left < ability_data.energy_cost
		
	update_font_color()
	on_panel_color_update()
	update_text()	
	
func on_is_selected_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self.name, "_update_all"), update_all)

func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	U.debounce(str(self.name, "_update_all"), update_all)

func on_base_states_update(new_val:Dictionary = base_states) -> void:
	base_states = new_val
	U.debounce(str(self.name, "_update_all"), update_all)
	
func on_scp_data_update(new_val:Dictionary) -> void:
	scp_data = new_val
	U.debounce(str(self.name, "_update_all"), update_all)
	
func on_abl_lvl_update() -> void:
	U.debounce(str(self.name, "_update_all"), update_all)
	
func on_ability_data_update() -> void:
	U.debounce(str(self.name, "_update_all"), update_all)

func on_ability_name_update() -> void:
	if !is_node_ready():return
	NameLabel.text = str(ability_name)

func on_cost_update() -> void:
	if !is_node_ready():return
	CostLabel.text = str(cost) if cost >= 0 else " "	

func update_font_color() -> void:
	if !is_node_ready():return
	var label_duplicate:LabelSettings = LabelSettingsPreload.duplicate()
	var use_color:Color = COLORS.primary_black 
	var altered:bool = false
	
	if !preview_mode:
		if lvl_locked and !altered:
			use_color = COLORS.disabled_color
			altered = true
		if is_disabled:
			use_color = COLORS.disabled_color
			altered = true
	
	use_color.a = 1 if is_selected else 0.7
	
				
	label_duplicate.font_color = use_color
	for node in [NameLabel, CostLabel]:
		node.label_settings = label_duplicate	
	IconBtn.icon_color = use_color

func on_panel_color_update() -> void:
	if !is_node_ready():return
	var new_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()	
	var use_color:Color = COLORS.primary_color 
	var altered:bool = false

	if !preview_mode:
		if lvl_locked and !altered:
			use_color = COLORS.primary_black
			altered = true
		if is_disabled:
			use_color = COLORS.primary_black
			altered = true
		
	use_color.a = 1 if is_selected else 0.7		
		
	new_stylebox.bg_color = use_color
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)	
	
func update_text() -> void:
	if !is_node_ready():return

	if preview_mode:
		ability_name = ability_data.name
		hint_title = ability_data.name
		hint_icon = SVGS.TYPE.ENERGY
		hint_description = ability_data.description
		IconBtn.icon = SVGS.TYPE.LOCK
		cost = ability_data.lvl_required
		Checkbox.is_checked = false
		return
	else:
		if is_disabled:
			ability_name = "UNAVAILABLE"
			hint_description = "Room must be active to use this ability."
			IconBtn.icon = SVGS.TYPE.LOCK
			cost = ability_data.lvl_required
			Checkbox.is_checked = false
			Checkbox.hide()
			CostLabel.hide()
			return
		
		Checkbox.show()
		CostLabel.show()
			
		if lvl_locked:
			ability_name = "LVL %s REQUIRED" % [ability_data.lvl_required]
			hint_description = "Level requirement must be higher to use this module."
			IconBtn.icon = SVGS.TYPE.LOCK
			cost = ability_data.lvl_required
			Checkbox.is_checked = false
			return
		if not_enough_energy:
			ability_name = ability_data.name
			hint_description = "Not enough energy to enable this module."
			IconBtn.icon = SVGS.TYPE.ENERGY
			cost = ability_data.energy_cost
			Checkbox.is_checked = false
			return			
		if scp_needed:
			ability_name = ability_data.name
			hint_description = "[UNABLE TO USE] Object in containment required."
			IconBtn.icon = SVGS.TYPE.CONTAIN
			cost = -1
			Checkbox.is_checked = false
			return

			
	ability_name = ability_data.name
	hint_title = ability_data.name
	hint_icon = SVGS.TYPE.ENERGY
	hint_description = ability_data.description
	IconBtn.icon = SVGS.TYPE.ENERGY
	cost = ability_data.energy_cost
	Checkbox.is_checked = is_active
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func is_clickable() -> bool:
	return !lvl_locked and !scp_needed and !not_enough_energy
# ------------------------------------------------------------------------------
	

# ------------------------------------------------------------------------------	
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if !is_node_ready():return
	update_font_color()
	on_panel_color_update()
# ------------------------------------------------------------------------------
