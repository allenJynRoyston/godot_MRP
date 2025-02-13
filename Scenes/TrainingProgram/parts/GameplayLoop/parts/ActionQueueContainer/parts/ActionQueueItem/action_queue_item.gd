extends BtnBase

@onready var DayLabel:Label = $MarginContainer/HBoxContainer/PanelContainer/DayLabel
@onready var ListContainer:VBoxContainer = $MarginContainer/HBoxContainer/ListContainer

const ActionQueueListItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ActionQueueContainer/parts/ActionQueueItem/ActionQueueListItem.tscn")

var suppress_click:bool = false 
var progress_data:Dictionary = {}
var alpha_map:Dictionary = {}
var forecast_amount:int = 7 : 
	set(val):
		forecast_amount = val
		on_forecast_amount_update()
var timeline_array:Array = []
var items:Array = [] :
	set(val):
		items = val
		on_items_update()
var delay:float = 0.0 

# --------------------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_timeline_array(self)
	SUBSCRIBE.subscribe_to_progress_data(self)
	SUBSCRIBE.subscribe_to_suppress_click(self)

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_timeline_array(self)
	SUBSCRIBE.unsubscribe_to_suppress_click(self)
	SUBSCRIBE.unsubscribe_to_progress_data(self)
# --------------------------------------------------

# --------------------------------------------------
func _ready() -> void:
	super._ready()
	DayLabel.text = str(index)
	on_forecast_amount_update()
	on_items_update()
# --------------------------------------------------

# --------------------------------------------------
func on_forecast_amount_update() -> void:
	var amount:float = 1.0
	for key in range(0, forecast_amount + 1):
		alpha_map[key] = amount
		amount -= 0.1
	
	if progress_data.is_empty():return
	on_progress_data_update()
# --------------------------------------------------	

# --------------------------------------------------
func on_timeline_array_updates(new_val:Array) -> void:
	timeline_array = new_val
	items = timeline_array.filter(func(i): return i.completed_at == index)	
# --------------------------------------------------

# --------------------------------------------------
func on_items_update() -> void:
	if !is_node_ready():
		return 
	
	for child in ListContainer.get_children():
		child.queue_free()	
	
	for item in items:
		var list_item:Control = ActionQueueListItemPreload.instantiate()
		list_item.data = item
		ListContainer.add_child(list_item)
	
	if items.size() > 0:
		await U.tick()
		print(self.size)
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
	await U.set_timeout(delay)
	modulate = Color(1, 1, 1, get_alpha())
# --------------------------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if !is_node_ready() or progress_data.is_empty() or modulate.a == 0:return
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1 if state else get_alpha()))
	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	super.on_mouse_click(node, btn, on_hover)
	pass
# ------------------------------------------------------------------------------
