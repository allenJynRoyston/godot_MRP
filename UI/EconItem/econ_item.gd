extends PanelContainer

@onready var RootPanel:PanelContainer = $"."

@onready var Vertical:VBoxContainer = $VBoxContainer
@onready var VSvgIcon:Control = $VBoxContainer/SVGIcon
@onready var VAmountLabel:Label = $VBoxContainer/PanelContainer/AmountLabel
@onready var VBurnLabel:Label = $VBoxContainer/PanelContainer/BurnLabel

@onready var Horizontal:HBoxContainer = $HBoxContainer
@onready var HSvgIcon:Control = $HBoxContainer/SVGIcon
@onready var HAmountLabel:Label = $HBoxContainer/PanelContainer/HBoxContainer/AmountLabel
@onready var HBonusAmountLabel:Label = $HBoxContainer/PanelContainer/HBoxContainer/BonusAmountLabel
@onready var HBurnLabel:Label = $HBoxContainer/PanelContainer/BurnLabel

@onready var primary_color:Color = COLORS.primary_black  
@onready var negative_color:Color = COLORS.disabled_color  
		
@export var horizontal_mode:bool = false : 
	set(val):
		horizontal_mode = val
		on_horizontal_mode_update()

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

@export var bonus_amount:int = 0 : 
	set(val):
		bonus_amount = val
		on_bonus_amount_update()		
					
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

@export var invert_colors:bool = false : 
	set(val):
		invert_colors = val
		on_invert_colors_update()

# --------------------------------------
func _ready() -> void:
	on_update_amount()
	on_is_negative_update()
	on_icon_size_update()
	on_icon_update()
	on_burn_val_amount()
	on_max_amount_amount()
	on_invert_colors_update()
	on_horizontal_mode_update()
	on_bonus_amount_update()

func on_horizontal_mode_update() -> void:
	if !is_node_ready():return
	Vertical.hide() if horizontal_mode else Vertical.show()
	Horizontal.show() if horizontal_mode else Horizontal.hide()
	
func on_icon_update() -> void:
	if !is_node_ready():return
	VSvgIcon.icon = icon
	HSvgIcon.icon = icon

func on_icon_size_update() -> void:
	if !is_node_ready():return	
	VSvgIcon.icon_size = icon_size
	HSvgIcon.icon_size = icon_size

func on_burn_val_amount() -> void:
	if !is_node_ready():return
	VBurnLabel.text = str(burn_val)
	HBurnLabel.text = str(burn_val)
	
func on_bonus_amount_update() -> void:
	if !is_node_ready():return
	HBonusAmountLabel.text = "%s%s" % ["+" if bonus_amount > 0 else "-", bonus_amount]	
	HBonusAmountLabel.hide() if bonus_amount == 0 else HBonusAmountLabel.show()

func on_invert_colors_update() -> void:
	if !is_node_ready():return
	U.debounce( str(self, "_update_all"), update)
	
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
	var label_settings_copy:LabelSettings = VAmountLabel.label_settings.duplicate()
	var use_color:Color = negative_color if is_negative else (primary_color if !invert_colors else Color.WHITE)
	label_settings_copy.font_color = use_color
	
	VSvgIcon.icon_color = use_color
	HSvgIcon.icon_color = use_color
	
	HBonusAmountLabel.label_settings = label_settings_copy	
	HAmountLabel.label_settings = label_settings_copy	
	HAmountLabel.text = str(amount) if max_amount < 0 else str(amount, "/", max_amount)	
	
	VAmountLabel.label_settings = label_settings_copy	
	VAmountLabel.text = str(amount) if max_amount < 0 else str(amount, "/", max_amount)
# --------------------------------------
