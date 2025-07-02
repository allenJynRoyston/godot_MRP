@tool
extends PanelContainer

@onready var CostLabel:Label = $MarginContainer/VBoxContainer/Label
@onready var IconBtn:BtnBase = $MarginContainer/VBoxContainer/IconBtn
@onready var AmountLabel:Label = $MarginContainer/VBoxContainer/AmountLabel


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
		
func _ready() -> void:
	on_icon_update()
	on_title_update()
	on_amount_update()
	on_is_negative_update()

func on_icon_update() -> void:
	if !is_node_ready():return
	IconBtn.icon = icon

func on_amount_update() -> void:
	if !is_node_ready():return
	AmountLabel.text = str(amount)
	
func on_title_update() -> void:
	if !is_node_ready():return
	CostLabel.text = title

func on_is_negative_update() -> void:
	if !is_node_ready():return
	var label_settings_copy:LabelSettings = AmountLabel.label_settings.duplicate()
	var new_color:Color = Color.WHITE if !is_negative else Color.RED
	
	label_settings_copy.font_color = new_color
	AmountLabel.label_settings = label_settings_copy
	
	IconBtn.static_color = new_color
