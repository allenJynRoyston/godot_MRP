extends PanelContainer

@onready var TitleBtn:BtnBase = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ProgressBar/MarginContainer/HBoxContainer/TitleBtn
@onready var CancelBtn:BtnBase = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ProgressBar/MarginContainer/HBoxContainer/CancelBtn
@onready var NameLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Name

@onready var RequirementContainer:VBoxContainer = $MarginContainer/VBoxContainer/RequirementContainer
@onready var ProgressBarUI:ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ProgressBar
@onready var DaysLeftLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/DaysLeft
@onready var RequirementGrid:GridContainer = $MarginContainer/VBoxContainer/RequirementContainer/RequirementGrid

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var suppress_click:bool = false 
var onClick:Callable = func():pass
var onCancel:Callable = func():pass

# --------------------------------------------------
var item_data:Dictionary = {}

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()
		
var requirements:Array = [] : 
	set(val):
		requirements = val
		on_requirements_update()
# --------------------------------------------------

# --------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_suppress_click(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_suppress_click(self)
# --------------------------------------------------

# --------------------------------------------------
func _ready() -> void:
	on_data_update()	
	
	TitleBtn.onClick = func() -> void:
		if suppress_click: return
		onClick.call()
	
	CancelBtn.onClick = func() -> void:
		if suppress_click: return
		onCancel.call()
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
	
	TitleBtn.icon = title_btn.icon
	TitleBtn.title = data.description 
	
	NameLabel.text = title_btn.title
	
	DaysLeftLabel.text = "%s DAYS" % [count.completed_at - count.day]
	ProgressBarUI.value = (count.day*1.0 / count.completed_at*1.0)	
	

func on_requirements_update() -> void:
	if is_node_ready():
		for child in RequirementGrid.get_children():
			child.queue_free()
		
		for item in requirements:
			var new_btn:BtnBase = TextBtnPreload.instantiate()
			new_btn.title = str(item.amount)
			new_btn.icon = item.resource.icon
			new_btn.is_hoverable = false
			new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			RequirementGrid.add_child(new_btn)
# --------------------------------------------------
