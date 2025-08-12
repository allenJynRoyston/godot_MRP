@tool
extends PanelContainer

@onready var ActiveControl:Control = $ActiveControl
@onready var TitleLabel:Label = $MarginContainer/VBoxContainer/MarginContainer/Header/TitleLabel
@onready var LevelLabel:Label = $MarginContainer/VBoxContainer/MarginContainer/Header/LevelLabel
@onready var TotalLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/Total/PanelContainer/MarginContainer/TotalVal
@onready var Items:HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/Items
@onready var ColorBlock:ColorRect = $MarginContainer/VBoxContainer/HBoxContainer/Control/ColorRect

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

		
@export var values:Array = [0, 1, 2, 3] : 
	set(val):
		values = val
		on_values_update()

@export var make_selectable:bool = false : 
	set(val):
		make_selectable = val
		on_make_selectable_update()

# ------------------------------------------------------
func _ready() -> void:
	on_title_update()
	on_active_level_update()
	on_color_update()
	on_values_update()
	on_make_selectable_update()
# ------------------------------------------------------

# ------------------------------------------------------
func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title

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
	LevelLabel.text = str("LVL ", active_level)

func on_color_update() -> void:
	if !is_node_ready():return
	ColorBlock.color = color
	for node in Items.get_children():
		node.block_color = color.darkened(0.3)
		

func on_make_selectable_update() -> void:
	if !is_node_ready():return
	ActiveControl.show() if make_selectable else ActiveControl.hide()	

# ------------------------------------------------------	
