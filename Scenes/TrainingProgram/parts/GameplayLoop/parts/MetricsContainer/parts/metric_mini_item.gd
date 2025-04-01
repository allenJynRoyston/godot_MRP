@tool
extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var IconBtn:BtnBase = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/HBoxContainer/IconBtn
@onready var IconBtn2:BtnBase = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/HBoxContainer/IconBtn2
@onready var TitleHeader:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/TitleHeader
@onready var TotalAmount:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/HBoxContainer/HBoxContainer/TotalAmount
@onready var ContextAmount:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/HBoxContainer/HBoxContainer/ContextAmount
@onready var StatusLabel:Label = $VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/StatusLabel

@export var assigned_metric:RESOURCE.BASE_METRICS : 
	set(val):
		assigned_metric = val
		on_assigned_metric_update()
		
@export var value:int = 0 :
	set(val):
		value = U.min_max(val, -5, 5)
		on_value_update()		
		
@export var context_value:int = -100 : 
	set(val):
		context_value = val
		on_context_value_update()
		
@export var is_negative:bool = false : 
	set(val):
		is_negative = val
		update_stylebox()	

var progress_data:Dictionary
var current_bg_color:Color 
var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()
		

func _init() -> void:
	SUBSCRIBE.subscribe_to_progress_data(self)
	GBL.subscribe_to_process(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_progress_data(self)
	GBL.unsubscribe_to_process(self)

func _ready() -> void:
	on_assigned_metric_update()
	on_value_update()
	on_status_update()
	on_context_value_update()
	on_progress_data_update()

func on_assigned_metric_update() -> void:
	if !is_node_ready():return
	match assigned_metric:
		RESOURCE.BASE_METRICS.MORALE:
			TitleHeader.text = "MORALE"
		RESOURCE.BASE_METRICS.SAFETY:
			TitleHeader.text = "SAFETY"
		RESOURCE.BASE_METRICS.READINESS:
			TitleHeader.text = "READINESS"
	
func on_progress_data_update(new_val:Dictionary = progress_data) -> void:
	progress_data = new_val		

func on_value_update() -> void:
	if !is_node_ready():return
	TotalAmount.text = str(value)
	
	match assigned_metric:
		RESOURCE.BASE_METRICS.MORALE:
			StatusLabel.text = RESOURCE_UTIL.return_morale_data(value).title
		RESOURCE.BASE_METRICS.SAFETY:
			StatusLabel.text = RESOURCE_UTIL.return_safety_data(value).title
		RESOURCE.BASE_METRICS.READINESS:
			StatusLabel.text = RESOURCE_UTIL.return_readiness_data(value).title


func on_status_update() -> void:
	if !is_node_ready():return
	pass

func on_is_active_update() -> void:
	if !is_node_ready():return
	IconBtn.show() if is_active else IconBtn.hide()
	IconBtn2.show() if is_active else IconBtn2.hide()

func on_context_value_update() -> void:
	if !is_node_ready():return
	if context_value == -100:
		ContextAmount.hide()
	else:
		ContextAmount.show()
		ContextAmount.text = str(context_value)

# -----------------------------------
func update_stylebox() -> void:
	if !is_node_ready():return
	var label_settings:LabelSettings = TotalAmount.label_settings.duplicate()
	label_settings.font_color = Color.RED if is_negative else Color.WHITE
	TotalAmount.label_settings = label_settings
# -----------------------------------


const FREQUENCY: float = 0.5   # Oscillation frequency in Hz
var time_elapsed: float = 0.0  # Time tracker

func on_process_update(delta: float) -> void:
	if !is_node_ready(): return

	#if is_active and value != 0:		
		#var new_stylebox: StyleBoxFlat = RootPanel.get_theme_stylebox('panel')
		#var bg_color:Color = current_bg_color
#
		## Increment time for smooth animation
		#time_elapsed += delta  
#
		## Compute sine wave value smoothly
		#var sine_value = sin(2.0 * PI * FREQUENCY * time_elapsed) * 0.5 + 0.5  # Map to 0-1 range
#
		## Apply the sine wave to darkening (no need for binary_value)
		#bg_color = bg_color.darkened(sine_value * 0.5)  # Reduce max darkening effect
#
		## Update stylebox color
		#new_stylebox.bg_color = bg_color
		#RootPanel.add_theme_stylebox_override("panel", new_stylebox)
