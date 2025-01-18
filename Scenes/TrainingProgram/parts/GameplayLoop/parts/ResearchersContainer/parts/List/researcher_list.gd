extends PanelContainer

@onready var SCPItemList:VBoxContainer = $MarginContainer/PanelContainer/VBoxContainer/SCPItemList

var hired_lead_researchers_arr:Array = []

const ResearcherBtn:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResearchersContainer/parts/List/ResearcherBtn/ResearcherBtn.tscn")

var onSelect:Callable = func(_researcher_details:Dictionary):pass

var active_index:int = -1 : 
	set(val):
		active_index = val
		on_active_index_update()

# --------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)

func _ready() -> void:
	on_active_index_update()
# --------------------------------

# --------------------------------
func reset() -> void:
	active_index = -1
# --------------------------------

# --------------------------------
func on_hired_lead_researchers_arr_update(new_val:Array = hired_lead_researchers_arr) -> void:
	hired_lead_researchers_arr = new_val
	if !is_node_ready():return
	
	reset()
	
	for index in hired_lead_researchers_arr.size():
		var data:Array = hired_lead_researchers_arr[index]
		var new_btn:Control = ResearcherBtn.instantiate()
		new_btn.is_active = false
		new_btn.researcher_id  = data
		new_btn.onClick = func(researcher_details:Dictionary) -> void:
			active_index = -1 if researcher_details.is_empty() else index
			onSelect.call({"details": researcher_details, "raw": data})
		SCPItemList.add_child(new_btn)
# --------------------------------

# --------------------------------
func on_active_index_update() -> void:
	if !is_node_ready():return
	for index in SCPItemList.get_child_count():
		var node:Control = SCPItemList.get_child(index)
		node.is_active = active_index == index
# --------------------------------
