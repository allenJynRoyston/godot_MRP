@tool
extends PanelContainer

@onready var CostLabel:Label = $MarginContainer/CardCostPanel/MarginContainer/VBoxContainer2/CostLabel
@onready var CostAmountLabel:Label = $MarginContainer/CardCostPanel/MarginContainer/VBoxContainer2/CostAmount
@onready var SVGIcon:Control = $MarginContainer/CardCostPanel/MarginContainer/VBoxContainer2/SVGIcon
@onready var InnerMargin:MarginContainer = $MarginContainer/CardCostPanel/MarginContainer

@export var title:String = "" : 
	set(val):
		title = val
		on_title_update()
		
@export var icon:SVGS.TYPE = SVGS.TYPE.NONE : 
	set(val):
		icon = val
		on_icon_update()
		
@export var use_color:Color = Color.WHITE : 
	set(val):
		use_color = val
		on_use_color_update()
		
@export var v_offset:int = 0 : 
	set(val):
		v_offset = val
		on_v_offset_update()
		
@export var amount:int : 
	set(val):
		amount = val
		on_amount_update()
		
func _ready() -> void:
	on_title_update()
	on_icon_update()
	on_amount_update()
	on_use_color_update()
	on_v_offset_update()
	
func on_title_update() -> void:
	if !is_node_ready():return
	CostLabel.text = title

func on_amount_update() -> void:
	if !is_node_ready():return
	CostAmountLabel.text = str(amount) if amount > 0 else "FREE"
	
func on_icon_update() -> void:
	if !is_node_ready():return
	SVGIcon.icon = icon
	
func on_v_offset_update() -> void:
	if !is_node_ready():return
	InnerMargin.set('theme_override_constants/margin_top', v_offset)

func on_use_color_update() -> void:
	if !is_node_ready():return	
	var title_label_setting_copy:LabelSettings = CostLabel.label_settings.duplicate()
	title_label_setting_copy.font_color = use_color
	CostLabel.label_settings = title_label_setting_copy
	
	var cost_label_setting_copy:LabelSettings = CostAmountLabel.label_settings.duplicate()
	cost_label_setting_copy.font_color = use_color
	CostAmountLabel.label_settings = cost_label_setting_copy
	
	SVGIcon.icon_color = use_color
