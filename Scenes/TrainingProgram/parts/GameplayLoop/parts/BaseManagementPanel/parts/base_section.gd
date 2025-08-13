@tool
extends PanelContainer

@onready var ActiveControl:Control = $ActiveControl
@onready var TitleLabel:Label = $MarginContainer/VBoxContainer/MarginContainer/Header/TitleLabel
@onready var LevelLabel:Label = $MarginContainer/VBoxContainer/MarginContainer/Header/LevelLabel
@onready var TotalLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/Total/PanelContainer/MarginContainer/TotalVal
@onready var Items:HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/Items
@onready var ProgressBarItem:ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/Control/ProgressBar

@onready var ProgressBarFillStylebox:StyleBoxFlat = ProgressBarItem.get("theme_override_styles/fill").duplicate()
@onready var LabelSettingsCopy:LabelSettings = TitleLabel.get("label_settings").duplicate()

@export var title:String = "Section" : 
	set(val):
		title = val
		on_title_update()
		
@export var active_level:int = 1 : 
	set(val):
		active_level = U.min_max(val, 1, 4)
		on_active_level_update()
		
@export var color:Color = Color.REBECCA_PURPLE : 
	set(val):
		color = val
		on_color_update()
		
@export var is_disabled:bool = false : 
	set(val):
		is_disabled = val
		on_is_disabled_update()
		
@export var values:Array = [0, 1, 2, 3] : 
	set(val):
		values = val
		on_values_update()

@export var make_selectable:bool = false : 
	set(val):
		make_selectable = val
		on_make_selectable_update()
		
var animation_tween:Tween

# ------------------------------------------------------
func _ready() -> void:
	on_title_update()
	on_active_level_update()
	on_color_update()
	on_values_update()
	on_make_selectable_update()
	on_is_disabled_update()
	
	TitleLabel.set("label_settings", LabelSettingsCopy)
	LevelLabel.set("label_settings", LabelSettingsCopy)
	ProgressBarItem.set("theme_override_styles/fill", ProgressBarFillStylebox)
# ------------------------------------------------------

# ------------------------------------------------------
func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title if !is_disabled else "UNAVAILABLE"

func on_values_update() -> void:
	if !is_node_ready():return
	for index in Items.get_child_count():
		var node:Control = Items.get_child(index)
		node.amount_val = values[index]
		
func on_active_level_update() -> void:
	if !is_node_ready():return
	var total:int = 0
	
	for index in Items.get_child_count():
		var node:Control = Items.get_child(index)
		node.is_active = active_level > index 
		if node.is_active:
			total = node.amount_val

	TotalLabel.text = str(total)
	LevelLabel.text = str("LVL ", active_level - 1)
	
	custom_tween_node_property(animation_tween, ProgressBarItem, "value", ((active_level -1  * 1.0) / 4.0) + 0.1, 0.3, 0, Tween.TRANS_SINE )

func on_color_update() -> void:
	if !is_node_ready():return
	ProgressBarFillStylebox.bg_color = color
	for node in Items.get_children():
		node.block_color = color.darkened(0.3)
		

func on_make_selectable_update() -> void:
	if !is_node_ready():return
	ActiveControl.show() if make_selectable else ActiveControl.hide()	

func on_is_disabled_update() -> void:
	if !is_node_ready():return
	LabelSettingsCopy.font_color = COLORS.primary_black if !is_disabled else COLORS.disabled_color
	LabelSettingsCopy.outline_color = LabelSettingsCopy.font_color
	LabelSettingsCopy.outline_color.a = 0.2
	on_title_update()
		
# ------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func custom_tween_node_property(tween:Tween, node:Node, prop:String, new_val, duration:float = 0.3, delay:float = 0, trans:int = Tween.TRANS_QUAD, ease:int = Tween.EASE_IN_OUT) -> void:
	if animation_tween != null and animation_tween.is_running():
		animation_tween.stop()
		
	animation_tween = create_tween()

	animation_tween.tween_property(node, prop, new_val, duration).set_trans(trans).set_ease(ease).set_delay(delay)
	await animation_tween.finished
# --------------------------------------------------------------------------------------------------		
