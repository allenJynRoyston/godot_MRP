@tool
extends PanelContainer

@onready var TitleBtn:BtnBase = $MarginContainer/VBoxContainer/HBoxContainer/TitleBtn
@onready var CancelBtn:BtnBase = $MarginContainer/VBoxContainer/HBoxContainer/CancelBtn

@onready var RequirementContainer:VBoxContainer = $MarginContainer/VBoxContainer/RequirementContainer
@onready var ProgressBarUI:ProgressBar = $MarginContainer/VBoxContainer/VBoxContainer/ProgressBar
@onready var DaysLeftLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/DaysLeft
@onready var RequirementGrid:GridContainer = $MarginContainer/VBoxContainer/RequirementContainer/RequirementGrid

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var onClick:Callable = func():pass
var onCancel:Callable = func():pass

# --------------------------------------------------
var room_data:Dictionary = {}

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
func _ready() -> void:
	on_data_update()	
	
	TitleBtn.onClick = func() -> void:
		onClick.call()
	
	CancelBtn.onClick = func() -> void:
		onCancel.call()
	

# --------------------------------------------------

# --------------------------------------------------
func animate_and_complete() -> void:	
	await U.set_timeout(0.5)
	print(room_data.name + ' animate and remove from action queue list...')
	queue_free()
# --------------------------------------------------	

# --------------------------------------------------
func on_data_update() -> void:
	if is_node_ready() and !data.is_empty():
		match data.action:
			ACTION.BUILD:
				room_data = ROOM_UTIL.return_data(data.data.id)
				TitleBtn.icon = SVGS.TYPE.BUILD
				TitleBtn.title = "Build %s" % [room_data.name]
				DaysLeftLabel.text = "%s days left until complete" % [data.build_time - data.days_in_queue]
				ProgressBarUI.value = (data.days_in_queue*1.0 / data.build_time*1.0)
				requirements = ROOM_UTIL.return_requirements(data.data.id) 
	

func on_requirements_update() -> void:
	if is_node_ready():
		for child in RequirementGrid.get_children():
			child.queue_free()
		
		for item in requirements:
			var new_btn:BtnBase = TextBtnPreload.instantiate()
			new_btn.title = str(item.amount)
			new_btn.icon = item.icon
			new_btn.is_hoverable = false
			new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			RequirementGrid.add_child(new_btn)
# --------------------------------------------------
