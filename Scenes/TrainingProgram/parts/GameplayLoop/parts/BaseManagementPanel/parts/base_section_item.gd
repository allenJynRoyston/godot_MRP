@tool
extends VBoxContainer

@onready var ColorBlock:ColorRect = $ColorRect
@onready var AmountLabel:Label = $ColorRect/MarginContainer/AmountLabel
@onready var SelectorIcon:Control = $SVGIcon

@export var block_color:Color = Color.WHITE : 
	set(val):
		block_color = val
		on_block_color_update()

@export var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()
		
@export var amount_val:int = 0 : 
	set(val):		
		amount_val = val
		on_amount_val_update()
		
func _ready() -> void:
	on_is_active_update()
	on_amount_val_update()
	on_block_color_update()
	
func on_is_active_update() -> void:
	if !is_node_ready():return
	SelectorIcon.show() if is_active else SelectorIcon.hide()
	on_block_color_update()
	
func on_amount_val_update() -> void:
	if !is_node_ready():return
	AmountLabel.text = str(amount_val)
	
func on_block_color_update() -> void:
	if !is_node_ready():return
	ColorBlock.color = block_color if is_active else Color.DIM_GRAY
