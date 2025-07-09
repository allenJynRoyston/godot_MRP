@tool
extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var SvgIcon:Control = $VBoxContainer/SVGIcon
@onready var AmountLabel:Label = $VBoxContainer/PanelContainer/AmountLabel
@onready var BurnLabel:Label = $VBoxContainer/PanelContainer/BurnLabel

@onready var primary_color:Color = COLORS.primary_black  
@onready var negative_color:Color = COLORS.disabled_color  
		

@export var icon:SVGS.TYPE = SVGS.TYPE.DOT : 
	set(val):
		icon = val
		on_icon_update()
		
@export var amount:int : 
	set(val):
		amount = val
		on_update_amount()
		
@export var max_amount:int = -1: 
	set(val):
		max_amount = val
		on_max_amount_amount()
					
@export var burn_val:String = "" : 
	set(val):
		burn_val = val
		on_burn_val_amount()		
		
@export var is_negative: bool = false : 
	set(val):
		is_negative = val
		on_is_negative_update()
		
@export var icon_size:Vector2 = Vector2(20, 20) : 
	set(val):
		icon_size = val
		on_icon_size_update()


# --------------------------------------
func _ready() -> void:
	on_update_amount()
	on_is_negative_update()
	on_icon_size_update()
	on_icon_update()
	on_burn_val_amount()
	on_max_amount_amount()

func on_icon_update() -> void:
	if !is_node_ready():return
	SvgIcon.icon = 	icon

func on_icon_size_update() -> void:
	if !is_node_ready():return	
	SvgIcon.icon_size = icon_size

func on_burn_val_amount() -> void:
	if !is_node_ready():return
	BurnLabel.text = str(burn_val)


func on_update_amount() -> void:
	if !is_node_ready():return	
	U.debounce( str(self, "_update_all"), update)

func on_max_amount_amount() -> void:
	if !is_node_ready():return	
	U.debounce( str(self, "_update_all"), update)
	

func on_is_negative_update() -> void:
	if !is_node_ready():return
	U.debounce( str(self, "_update_all"), update)
	
func update() -> void:
	var label_settings_copy:LabelSettings = AmountLabel.label_settings.duplicate()
	var use_color:Color = negative_color if is_negative else primary_color
	label_settings_copy.font_color = use_color
	
	SvgIcon.icon_color = use_color
	AmountLabel.label_settings = label_settings_copy
	
	AmountLabel.text = str(amount) if max_amount < 0 else str(amount, "/", max_amount)
# --------------------------------------
