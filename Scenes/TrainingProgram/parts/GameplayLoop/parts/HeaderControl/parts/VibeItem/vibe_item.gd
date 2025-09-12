@tool
extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var TitleLabel:Label = $MarginContainer/VBoxContainer/Title
@onready var ValueLabel:Label = $MarginContainer/VBoxContainer/Value

@onready var Offset:VBoxContainer = $MarginContainer/VBoxContainer/Offset
@onready var OffsetIcon:Control = $MarginContainer/VBoxContainer/Offset/MarginContainer2/OffsetIcon
@onready var OffsetAmountLabel:Label = $MarginContainer/VBoxContainer/Offset/AmountLabel

@onready var title_label_settings:LabelSettings = TitleLabel.get("label_settings").duplicate()
@onready var value_label_settings:LabelSettings = ValueLabel.get("label_settings").duplicate()
@onready var offset_amount_label_setting:LabelSettings = OffsetAmountLabel.get("label_settings").duplicate()

@export var value:int = 0 : 
	set(val):
		value = val
		U.debounce( str(self, "_update"), update_node )
		
@export var title:String = ""	: 
	set(val):
		title = val
		U.debounce( str(self, "_update"), update_node )
		
@export var invert_color:bool = false : 
	set(val):
		invert_color = val
		U.debounce( str(self, "_update"), update_node )
		
@export var is_disabled:bool = false : 
	set(val):
		is_disabled = val
		U.debounce( str(self, "_update"), update_node )
		
@export var big_numbers:bool = false : 
	set(val):
		big_numbers = val
		U.debounce( str(self, "_update"), update_node )

@export var offset_amount:int = 0: 
	set(val):
		offset_amount = val
		U.debounce( str(self, "_update"), update_node )

var hint_title:String = "HINT"
var hint_description:String = ""
var hint_icon:SVGS.TYPE = SVGS.TYPE.INFO

# --------------------------------------
func _ready() -> void:
	TitleLabel.set("label_settings", title_label_settings)
	ValueLabel.set("label_settings", value_label_settings) 
	OffsetAmountLabel.set("label_settings", offset_amount_label_setting)
	
	U.debounce( str(self, "_update"), update_node )
# --------------------------------------


# --------------------------------------
func update_node() -> void:
	if !is_node_ready():return
	ValueLabel.text = str(value)
	TitleLabel.text = title
	
	title_label_settings.font_color = Color.BLACK if invert_color else Color.WHITE if !is_disabled else Color.RED
	title_label_settings.outline_color = title_label_settings.font_color
	title_label_settings.outline_color.a = 0.2
	
	value_label_settings.font_size = 24 if big_numbers else 16
	value_label_settings.font_color = Color.RED if value < 0 or is_disabled else (Color.BLACK if invert_color else Color.WHITE)
	value_label_settings.outline_color = value_label_settings.font_color
	value_label_settings.outline_color.a = 0.2

	Offset.hide() if offset_amount == 0 else Offset.show()	
	OffsetAmountLabel.text = str( value + offset_amount )
	OffsetIcon.icon_color = Color.DARK_GREEN if (value + offset_amount) > value else Color.RED
	offset_amount_label_setting.font_color = OffsetIcon.icon_color
		
# --------------------------------------
