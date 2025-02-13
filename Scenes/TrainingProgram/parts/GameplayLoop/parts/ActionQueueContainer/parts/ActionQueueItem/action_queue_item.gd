extends BtnBase

@onready var TitleLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/TitleLabel
@onready var DescriptionLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/DescriptionLabel
@onready var DayLabel:Label = $MarginContainer/HBoxContainer/PanelContainer/DayLabel

var suppress_click:bool = false 
var progress_data:Dictionary = {}
var alpha_map:Dictionary = {}
var forecast_amount:int = 3 : 
	set(val):
		forecast_amount = val
		on_forecast_amount_update()
var action_queue_data:Array = []
var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()
		

# --------------------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_action_queue_data(self)
	SUBSCRIBE.subscribe_to_progress_data(self)
	SUBSCRIBE.subscribe_to_suppress_click(self)

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_action_queue_data(self)
	SUBSCRIBE.unsubscribe_to_suppress_click(self)
	SUBSCRIBE.unsubscribe_to_progress_data(self)
# --------------------------------------------------

# --------------------------------------------------
func _ready() -> void:
	super._ready()
	DayLabel.text = str(index)
	on_forecast_amount_update()
# --------------------------------------------------

# --------------------------------------------------
func on_forecast_amount_update() -> void:
	var amount:float = 1.0
	for key in range(1, forecast_amount + 1):
		alpha_map[key] = amount
		amount -= 0.2
	
	if progress_data.is_empty():return
	on_progress_data_update()
# --------------------------------------------------	

# --------------------------------------------------
func on_action_queue_data_update(new_val:Array) -> void:
	action_queue_data = new_val
	var filtered:Array = action_queue_data.filter(func(i): return i.completed_at == index)
	if filtered.size() > 0:
		data = filtered[0]
	else:
		data = {}
# --------------------------------------------------

# --------------------------------------------------
func on_data_update() -> void:
	if !is_node_ready():
		return 
	
	if data.is_empty():
		for node in [TitleLabel, DescriptionLabel]:
			node.text = ""
		return		
	
	TitleLabel.text = data.title
	DescriptionLabel.text = data.description	
# --------------------------------------------------

# --------------------------------------------------
func on_suppress_click_update(new_val:bool) -> void:
	suppress_click = new_val
# --------------------------------------------------

# --------------------------------------------------
func get_alpha() -> float:
	return alpha_map.get(index - progress_data.day, 0.0)
# --------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_progress_data_update(new_val:Dictionary = progress_data) -> void:
	progress_data = new_val
	if !is_node_ready():return
	modulate = Color(1, 1, 1, get_alpha())
# --------------------------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if !is_node_ready() or progress_data.is_empty() or modulate.a == 0:return
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1 if state else get_alpha()))
	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	super.on_mouse_click(node, btn, on_hover)
	if data.is_empty() or data.location.is_empty():return
	SUBSCRIBE.current_location = data.location
# ------------------------------------------------------------------------------
