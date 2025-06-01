@tool
extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var TitleLabel:Label = $MarginContainer/VBoxContainer/Title
@onready var ValueLabel:Label = $MarginContainer/VBoxContainer/Value
@onready var AltLabel:Label = $Control/AltLabel

@export var metric:RESOURCE.METRICS : 
	set(val):
		metric = val
		on_metric_update()

@onready var value:int = 0 : 
	set(val):
		value = val
		on_value_update()
		
@onready var alt_value:int = 0 : 
	set(val):
		alt_value = val
		on_alt_value_update()

@onready var show_alt:bool = false : 
	set(val):
		show_alt = val
		on_show_alt_update()

var title:String = ""	: 
	set(val):
		title = val
		on_title_update()	

var onClick:Callable = func():pass
var onDismiss:Callable = func():pass

# --------------------------------------
func _ready() -> void:
	super._ready()
	on_title_update()
	on_value_update()
	on_alt_value_update()
	on_show_alt_update()
	on_metric_update()
	
	hint_icon = SVGS.TYPE.INFO
	hint_title = "HINT"
# --------------------------------------

# --------------------------------------
func on_metric_update() -> void:
	if !is_node_ready():return
	match metric:
		RESOURCE.METRICS.MORALE:
			title = 'MORALE'
			hint_description = "Morale description."

		RESOURCE.METRICS.SAFETY:
			title = 'SAFETY'
			hint_description = "Safety description."

		RESOURCE.METRICS.READINESS:
			title = 'READINESS'
			hint_description = "Readiness description."


func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title

func on_value_update() -> void:
	if !is_node_ready():return
	ValueLabel.text = str(value)
	update_vibe_color(ValueLabel, value)
	
func on_alt_value_update() -> void:
	if !is_node_ready():return
	AltLabel.text = str(alt_value)
	
func on_show_alt_update() -> void:
	if !is_node_ready():return
	AltLabel.show() if show_alt else AltLabel.hide()
# --------------------------------------

# --------------------------------------
func update_vibe_color(node:Control, val:int) -> void:
	var label_setting_copy:LabelSettings = node.label_settings.duplicate()
	label_setting_copy.font_color = Color.RED if val < 0 else Color.WHITE
	node.label_settings = label_setting_copy
# --------------------------------------

# --------------------------------------	
func on_focus(state:bool = false) -> void:
	if !is_node_ready():return
	ValueLabel.modulate = Color(1, 1, 1, 0.6 if state else 1)
		
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
# --------------------------------------	

# --------------------------------------	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover:
		onClick.call()
	else:
		onDismiss.call()
# --------------------------------------		
