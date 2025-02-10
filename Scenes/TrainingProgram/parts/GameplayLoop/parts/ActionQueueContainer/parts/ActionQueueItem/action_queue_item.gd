extends BtnBase

@onready var HeaderLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer2/MarginContainer/HBoxContainer/VBoxContainer2/HeaderLabel
@onready var StatusLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/MarginContainer2/VBoxContainer/StatusLabel
@onready var CountLabel:Label = $MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/CountLabel
@onready var ProgressBarUI:ProgressBar = $MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/ProgressBar

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var suppress_click:bool = false 

# --------------------------------------------------
var item_data:Dictionary = {}

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()
		
var requirements:Array = [] : 
	set(val):
		requirements = val
# --------------------------------------------------

# --------------------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_suppress_click(self)

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_suppress_click(self)
# --------------------------------------------------

# --------------------------------------------------
func _ready() -> void:
	super._ready()
	on_data_update()	
# --------------------------------------------------

# --------------------------------------------------
func animate_and_complete() -> void:	
	await U.set_timeout(0.2)
# --------------------------------------------------	

# --------------------------------------------------
func on_suppress_click_update(new_val:bool) -> void:
	suppress_click = new_val
# --------------------------------------------------

# --------------------------------------------------
func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	var title_btn:Dictionary = data.title_btn
	var count:Dictionary = data.count
	
	HeaderLabel.text = data.description 
	StatusLabel.text = title_btn.title
	CountLabel.text = "%s" % [count.completed_at - count.day]
	U.tween_node_property(ProgressBarUI, "value", (count.day*1.0 / count.completed_at*1.0), 0.3, 0.2)
# --------------------------------------------------


# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	super.on_mouse_click(node, btn, on_hover)
	print('clicked!')
# ------------------------------------------------------------------------------
