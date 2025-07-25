@tool
extends PanelContainer

@onready var Margin:MarginContainer = $MarginContainer

@onready var TallContainer:VBoxContainer = $MarginContainer/Tall
@onready var CostLabel:Label = $MarginContainer/Tall/Label
@onready var IconBtn:Control = $MarginContainer/Tall/SVGIcon
@onready var AmountLabel:Label = $MarginContainer/Tall/MarginContainer/AmountLabel

@onready var SmallContainer:VBoxContainer = $MarginContainer/Small
@onready var SmallIcon:Control = $MarginContainer/Small/HBoxContainer/SVGIcon
@onready var SmallAmountLabel:Label = $MarginContainer/Small/HBoxContainer/MarginContainer/AmountLabel

@export var icon:SVGS.TYPE = SVGS.TYPE.MONEY : 
	set(val):
		icon = val
		on_icon_update()
		
@export var title:String = "TITLE" : 
	set(val):
		title = val
		on_title_update()
		
@export var amount:int = 0 : 
	set(val):
		amount = val
		on_amount_update()
		
@export var is_negative:bool = false : 
	set(val):
		is_negative = val
		on_is_negative_update()
		
@export var small:bool = false : 
	set(val):
		small = val
		on_small_update()
		
func _ready() -> void:
	on_icon_update()
	on_title_update()
	on_amount_update()
	on_is_negative_update()
	on_small_update()
	
func on_icon_update() -> void:
	if !is_node_ready():return
	for node in [IconBtn, SmallIcon]:
		node.icon = icon

func on_amount_update() -> void:
	if !is_node_ready():return
	for node in [SmallAmountLabel, AmountLabel]:	
		node.text = str(amount)
	
func on_title_update() -> void:
	if !is_node_ready():return
	CostLabel.text = title

func on_is_negative_update() -> void:
	if !is_node_ready():return
	update_colors()

func on_small_update() -> void:
	if !is_node_ready():return
	TallContainer.show() if !small else TallContainer.hide()
	SmallContainer.show() if small else SmallContainer.hide()
	Margin.set("theme_override_constants/margin_top", 10 if small else 15)

func update_colors() -> void:
	var alpha:float = self.modulate.a
	var new_color:Color = COLORS.primary_black if !is_negative else Color.RED
	var mixed_color:Color = Color(new_color.r, new_color.g, new_color.b, alpha)
	
	for node in [SmallAmountLabel, AmountLabel]:
		var label_settings_copy:LabelSettings = node.label_settings.duplicate()
		label_settings_copy.font_color = mixed_color
		node.label_settings = label_settings_copy
	
	for node in [IconBtn, SmallIcon]:
		node.icon_color = mixed_color	
