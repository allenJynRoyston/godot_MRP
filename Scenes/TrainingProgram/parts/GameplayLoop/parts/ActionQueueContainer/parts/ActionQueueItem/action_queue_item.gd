@tool
extends PanelContainer

@onready var TitleBtn:BtnBase = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/TitleBtn
@onready var CancelBtn:BtnBase = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/CancelBtn
@onready var NameLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Name

@onready var RequirementContainer:VBoxContainer = $MarginContainer/VBoxContainer/RequirementContainer
@onready var ProgressBarUI:ProgressBar = $MarginContainer/VBoxContainer/VBoxContainer/ProgressBar
@onready var DaysLeftLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/DaysLeft
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
	await U.set_timeout(0.5)
	print(item_data.name + ' animate and remove from action queue list...')
	queue_free()
# --------------------------------------------------	

# --------------------------------------------------
func on_suppress_click_update(new_val:bool) -> void:
	suppress_click = new_val
# --------------------------------------------------


# --------------------------------------------------
func on_data_update() -> void:
	if is_node_ready() and !data.is_empty():
		match data.action:
			ACTION.RESEARCH:
				item_data = RD_UTIL.return_data(data.data.id)
				TitleBtn.icon = SVGS.TYPE.RESEARCH
				requirements = RD_UTIL.return_build_cost(data.data.id) 
				TitleBtn.title = "RESEARCHING"
			ACTION.BUILD:
				item_data = ROOM_UTIL.return_data(data.data.id)
				TitleBtn.icon = SVGS.TYPE.BUILD
				requirements = ROOM_UTIL.return_build_cost(data.data.id) 
				TitleBtn.title = "BUILDING"
				
		NameLabel.text = "%s" % [item_data.name]
		DaysLeftLabel.text = "%s days left until complete" % [data.build_time - data.days_in_queue]
		ProgressBarUI.value = (data.days_in_queue*1.0 / data.build_time*1.0)

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
