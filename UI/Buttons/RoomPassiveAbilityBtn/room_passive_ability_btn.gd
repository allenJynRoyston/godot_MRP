@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."

@onready var CostAndCooldownContainer:PanelContainer = $MarginContainer/HBoxContainer/CostAndCooldown
@onready var CostLabel:Label = $MarginContainer/HBoxContainer/CostAndCooldown/MarginContainer/HBoxContainer/CostLabel
@onready var IconBtn:BtnBase = $MarginContainer/HBoxContainer/CostAndCooldown/MarginContainer/HBoxContainer/IconBtn
@onready var NameLabel:Label = $MarginContainer/HBoxContainer/Name/MarginContainer/HBoxContainer/NameLabel
@onready var Checkbox:BtnBase = $MarginContainer/HBoxContainer/Name/MarginContainer/HBoxContainer/CheckBox


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

var base_states:Dictionary = {} 
var use_location:Dictionary = {} : 
	set(val):
		use_location = val
		on_base_states_update()

var lvl_locked:bool = false : 
	set(val):
		lvl_locked = val
		on_lvl_locked_update()

var is_active:bool = false 
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
	on_is_selected_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_base_states_update(new_val:Dictionary = base_states) -> void:
	base_states = new_val
	if !is_node_ready() or use_location.is_empty():return
	var ability_uid:String = str(room_ref, ability_index)	
	var designation:String = U.location_to_designation(use_location)
	is_active = base_states.room[designation].passives_enabled[ability_uid] if ability_uid in base_states.room[designation].passives_enabled else false
	U.debounce(str(self.name, "_update_all"), update_all)
	
func on_is_selected_update() -> void:
	if !is_node_ready():return
	var panel_color:Color = Color.BLACK if !is_selected else Color.WHITE
	
	var new_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()	
	new_stylebox.bg_color = panel_color
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)

func update_all() -> void:
	update_font_color()
	on_panel_color_update()
	update_text()	

func on_lvl_locked_update() -> void:
	U.debounce(str(self.name, "_update_all"), update_all)
	
func on_abl_lvl_update() -> void:
	if ability_data.is_empty():return	
	lvl_locked = abl_lvl < ability_data.lvl_required	
	U.debounce(str(self.name, "_update_all"), update_all)
	
func on_ability_data_update() -> void:
	if ability_data.is_empty():return
	lvl_locked = abl_lvl < ability_data.lvl_required	
	U.debounce(str(self.name, "_update_all"), update_all)

func on_ability_name_update() -> void:
	if !is_node_ready():return
	NameLabel.text = str(ability_name)

func on_cost_update() -> void:
	if !is_node_ready():return
	CostLabel.text = str(cost)	

func update_font_color() -> void:
	if !is_node_ready():return
	var label_duplicate:LabelSettings = LabelSettingsPreload.duplicate()
	var new_color:Color = Color.LIGHT_GRAY
	
	if !preview_mode:
		if lvl_locked:
			new_color = Color.WEB_GRAY
		if is_active:
			new_color = Color.YELLOW
	
	label_duplicate.font_color = new_color
	for node in [NameLabel, CostLabel]:
		node.label_settings = label_duplicate	
		
	IconBtn.static_color = new_color
	
	
func on_panel_color_update() -> void:
	if !is_node_ready():return
	#border_color = panel_color
	
func update_text() -> void:
	if !is_node_ready():return
	
	if preview_mode:
		ability_name = ability_data.name
		hint_title = ability_data.name
		hint_icon = SVGS.TYPE.ENERGY
		hint_description = ability_data.description
		IconBtn.icon = SVGS.TYPE.LOCK
		cost = ability_data.lvl_required
		return
	else:
		if lvl_locked:
			ability_name = "LVL %s REQUIRED" % [ability_data.lvl_required]
			hint_description = "Level requirement must be higher to use this module."
			IconBtn.icon = SVGS.TYPE.LOCK
			cost = ability_data.lvl_required
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
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if !is_node_ready():return
	update_font_color()
	on_panel_color_update()
	

# ------------------------------------------------------------------------------
