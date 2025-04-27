@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."

@onready var CooldownLabel:Label = $MarginContainer/HBoxContainer/PanelContainer/CooldownLabel
@onready var CostLabel:Label = $MarginContainer/HBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/CostLabel
@onready var IconBtn:BtnBase = $MarginContainer/HBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/IconBtn
@onready var NameLabel:Label = $MarginContainer/HBoxContainer/PanelContainer2/MarginContainer/NameLabel

@export var panel_color:Color = Color("0e0e0ecb") : 
	set(val):
		panel_color = val
		on_panel_color_update()		

@export var cooldown_val:int = 0: 
	set(val):
		cooldown_val = val
		on_cooldown_val_update()

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
		on_panel_color_update()
		
@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
		on_panel_color_update()
		
@export var is_unavailable:bool = false : 
	set(val):
		is_unavailable = val
		on_is_unavailable_update()
		
@export var is_unknown:bool = false : 
	set(val):
		is_unknown = val
		on_is_unknown_update()		


var base_states:Dictionary = {} 
var use_location:Dictionary = {} : 
	set(val):
		use_location = val
		on_base_states_update()

# directly access, do not remove
var type:String 
var room_ref:int
var ability_data:Dictionary = {}
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

	on_cooldown_val_update()
	on_ability_name_update()
	on_cooldown_update()
	on_cost_update()
	on_is_selected_update()
	on_panel_color_update()
	on_is_disabled_updated()
	on_is_unavailable_update()
	on_is_unknown_update()
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
		
	on_cooldown = base_states.room[designation].ability_on_cooldown[ability_uid] > 0
	cooldown_val = base_states.room[designation].ability_on_cooldown[ability_uid]
	
func on_is_unknown_update() -> void:
	on_cooldown_val_update()
	on_ability_name_update()
	on_cost_update()
	
func on_cooldown_val_update() -> void:
	if !is_node_ready():return
	CooldownLabel.text = str(cooldown_val) if !is_unknown else "?"

func on_ability_name_update() -> void:
	if !is_node_ready():return
	NameLabel.text = str(ability_name)  if !is_unknown else "???"

func on_cost_update() -> void:
	if !is_node_ready():return
	CostLabel.text = str(cost) if !is_unknown else "?"
	IconBtn.hide() if is_unknown else IconBtn.show()

func on_cooldown_update() -> void:
	if !is_node_ready():return
	update_font_color()
	
func on_is_selected_update() -> void:
	if !is_node_ready():return
	update_font_color()

func on_is_unavailable_update() -> void:
	if !is_node_ready():return
	update_font_color()
	on_panel_color_update()


func update_font_color() -> void:
	var label_duplicate:LabelSettings = LabelSettingsPreload.duplicate()
	var new_color:Color = Color.LIGHT_GRAY
	
	if is_selected:
		new_color = Color.WHITE	
	if on_cooldown:
		new_color = Color.RED
	if is_disabled:
		new_color = Color.RED
	if is_unavailable:
		new_color = Color.DARK_GRAY
		
	if is_focused:
		new_color = new_color.lightened(0.2)
		
	label_duplicate.font_color = new_color
	for node in [CooldownLabel, NameLabel, CostLabel]:
		node.label_settings = label_duplicate	
		
	IconBtn.static_color = new_color		
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if !is_node_ready():return
	update_font_color()
	on_panel_color_update()
	
func on_panel_color_update() -> void:
	if !is_node_ready():return
	var new_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
	var new_color:Color = panel_color
	
	if is_selected:
		new_color = panel_color.darkened(0.2)
	if is_focused:
		new_color = panel_color.darkened(0.2)
	if on_cooldown:
		new_color = Color.RED
	if is_disabled:
		new_color = Color.RED
	if is_unavailable:
		new_color = Color.DARK_GRAY		
			
	new_stylebox.bg_color = new_color
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)
# ------------------------------------------------------------------------------
