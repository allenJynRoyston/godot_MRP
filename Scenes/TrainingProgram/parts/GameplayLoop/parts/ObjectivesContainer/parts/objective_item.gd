@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."
@onready var ContentLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/ContentLabel
@onready var IconBtn:Control = $MarginContainer/HBoxContainer/SVGIcon

@export var is_naked:bool = false : 
	set(val):
		is_naked = val
		on_is_naked_update()
		

var content:String = "Objective"
var you_have:String = ""
var is_optional:bool = false
var is_completed:bool = false
var is_expired:bool = false
var is_upcoming:bool = false
var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()


var bookmarked_objectives:Array = []
var stylebox_copy:StyleBoxFlat
var use_color:Color = COLORS.primary_color

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_bookmarked_objectives(self)

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_bookmarked_objectives(self)
	

func _ready() -> void:
	super._ready()
	var you_have_str:String = "Objective complete" if is_expired else you_have
	stylebox_copy = RootPanel.get_theme_stylebox('panel').duplicate()		


	ContentLabel.text = "Upcoming..." if is_upcoming else ("OPTIONAL: \r%s" % content) if is_optional else content
	IconBtn.icon = SVGS.TYPE.CLEAR if is_expired else (SVGS.TYPE.CHECKBOX if is_completed else SVGS.TYPE.EMPTY_CHECKBOX)
	
	#use_color = Color.GREEN
	#
	#if !is_completed:
		#use_color = Color(0.337, 0.275, 1.0)
	#if is_expired:
		#use_color = Color(0.337, 0.275, 1.0).lightened(0.5)
	#if is_optional:
		#use_color = Color(1.0, 0.694, 0.0)
		
	hint_title = "HINT"
	hint_description = "" if is_upcoming else you_have_str
	hint_icon = SVGS.TYPE.INFO
	
	if is_hoverable:
		on_focus(false)	
	
	on_is_selected_update()
	on_bookmarked_objectives_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_bookmarked_objectives_update(new_val:Array = bookmarked_objectives) -> void:
	bookmarked_objectives = new_val
	
func on_is_naked_update() -> void:
	if !is_node_ready():return	
	on_is_selected_update()

func on_is_selected_update() -> void:
	var new_stylebox:StyleBoxFlat = stylebox_copy.duplicate()	
	var text_color:Color = COLORS.primary_black if !is_naked else Color.WHITE
	var content_label_settings:LabelSettings = ContentLabel.label_settings.duplicate()
	
	new_stylebox.bg_color = use_color if !is_naked else Color.TRANSPARENT
	new_stylebox.shadow_color = stylebox_copy.shadow_color if !is_naked else Color.TRANSPARENT
	
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)
	IconBtn.icon_color = text_color
	
	content_label_settings.font_color = text_color
	ContentLabel.label_settings = content_label_settings
	
	modulate.a = 1 if is_naked else (1 if is_selected else 0.7)
# ------------------------------------------------------------------------------
