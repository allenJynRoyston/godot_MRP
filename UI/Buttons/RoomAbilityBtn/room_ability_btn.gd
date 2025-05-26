@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."

@onready var CostAndCooldownContainer:PanelContainer = $MarginContainer/HBoxContainer/CostAndCooldown
@onready var CostLabel:Label = $MarginContainer/HBoxContainer/CostAndCooldown/MarginContainer/HBoxContainer/CostLabel
@onready var IconBtn:BtnBase = $MarginContainer/HBoxContainer/CostAndCooldown/MarginContainer/HBoxContainer/IconBtn
@onready var NameLabel:Label = $MarginContainer/HBoxContainer/Name/MarginContainer/NameLabel

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

@export var on_cooldown:bool = false : 
	set(val):
		on_cooldown = val
		on_cooldown_update()	
		
@export var preview_mode:bool = false
@export var abl_lvl:int = 0 :
	set(val):
		abl_lvl = val
		on_abl_lvl_update()
		
@export var required_lvl:int = 0

var cooldown_val:int = 0
var base_states:Dictionary = {} 
var use_location:Dictionary = {} : 
	set(val):
		use_location = val
		on_base_states_update()
		
var lvl_locked:bool = false : 
	set(val):
		lvl_locked = val
		on_lvl_locked_update()

# directly access, do not remove
var ability_index:int
var type:String 
var room_ref:int
var ability_data:Dictionary = {} : 
	set(val):
		ability_data = val
		on_ability_data_update()
	
const LabelSettingsPreload:LabelSettings = preload("res://Scenes/TrainingProgram/parts/Cards/RoomMiniCard/SmallContentFont.tres")

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_base_states(self)

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_base_states(self)
	
func _ready() -> void:
	super._ready()
	on_base_states_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_base_states_update(new_val:Dictionary = base_states) -> void:
	base_states = new_val
	if !is_node_ready() or use_location.is_empty():return
	var designation:String = U.location_to_designation(use_location)
	var ability_uid:String = str(room_ref, ability_index)	
	if ability_uid not in base_states.room[designation].ability_on_cooldown:
		on_cooldown = false
		return
		
	cooldown_val = base_states.room[designation].ability_on_cooldown[ability_uid]		
	on_cooldown = base_states.room[designation].ability_on_cooldown[ability_uid] > 0
	

func update_all() -> void:
	update_font_color()
	on_panel_color_update()
	update_text()	

func on_is_disabled_updated() -> void:
	U.debounce(str(self.name, "_update_all"), update_all)

func on_lvl_locked_update() -> void:
	U.debounce(str(self.name, "_update_all"), update_all)

func on_cooldown_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self.name, "_update_all"), update_all)

func on_ability_data_update() -> void:
	if ability_data.is_empty():return
	U.debounce(str(self.name, "_update_all"), update_all)

func on_ability_name_update() -> void:
	if !is_node_ready():return
	NameLabel.text = str(ability_name)

func on_cost_update() -> void:
	if !is_node_ready():return
	CostLabel.text = str(cost)

func on_abl_lvl_update() -> void:
	if ability_data.is_empty():return	
	lvl_locked = abl_lvl < ability_data.lvl_required	
	U.debounce(str(self.name, "_update_all"), update_all)
	
func update_font_color() -> void:
	if !is_node_ready():return
	var label_duplicate:LabelSettings = LabelSettingsPreload.duplicate()
	var new_color:Color = Color.WHITE	
	
	if !preview_mode:
		if on_cooldown:
			new_color = Color.SKY_BLUE		
		if lvl_locked:
			new_color = Color.WEB_GRAY
	
	
	label_duplicate.font_color = new_color
	for node in [NameLabel, CostLabel]:
		node.label_settings = label_duplicate	
		
	IconBtn.static_color = new_color		
	
func on_panel_color_update() -> void:
	if !is_node_ready():return
	var new_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
	var new_color:Color = panel_color
	
	if !preview_mode:
		if on_cooldown:
			new_color = panel_color		
		if lvl_locked:
			new_color = panel_color


	new_stylebox.bg_color = new_color
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)
	
func update_text() -> void:
	if !is_node_ready():return
	
	if preview_mode:
		ability_name = ability_data.name
		hint_title = ability_data.name
		hint_icon = SVGS.TYPE.RESEARCH
		hint_description = ability_data.description
		IconBtn.icon = SVGS.TYPE.LOCK
		cost = ability_data.lvl_required
		return
	else:
		if lvl_locked:
			ability_name = "LVL %s REQUIRED" % [ability_data.lvl_required]
			hint_description = "Level requirement must be higher to use this program."
			IconBtn.icon = SVGS.TYPE.LOCK
			cost = ability_data.lvl_required
			return
		
		if on_cooldown:
			ability_name = ability_data.name
			hint_description = "Program on cooldown for %s %s." % [cooldown_val, "days" if cooldown_val > 1 else "day"]
			IconBtn.icon = SVGS.TYPE.FROZEN
			cost = cooldown_val
			return
	
		
	ability_name = ability_data.name
	hint_title = ability_data.name
	hint_icon = SVGS.TYPE.RESEARCH
	hint_description = ability_data.description
	IconBtn.icon = SVGS.TYPE.RESEARCH
	cost = ability_data.science_cost
	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if !is_node_ready():return
	#modulate = Color(1, 1, 1, 1 if state else 0.5)
# ------------------------------------------------------------------------------
