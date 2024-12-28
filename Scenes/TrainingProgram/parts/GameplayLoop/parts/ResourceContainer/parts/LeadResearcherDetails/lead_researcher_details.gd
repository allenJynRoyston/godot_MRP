extends PanelContainer

var gameplay_node:Control

@onready var List:VBoxContainer = $VBoxContainer/HBoxContainer/IncomeContainer/List

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

func _init() -> void:
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)

func _ready() -> void:
	gameplay_node = GBL.find_node(REFS.GAMEPLAY_LOOP)


var hired_lead_researchers_arr:Array = [] 

func on_hired_lead_researchers_arr_update(new_val:Array = hired_lead_researchers_arr) -> void:
	hired_lead_researchers_arr = new_val
	if !is_node_ready():return
	
	for node in List.get_children():
		node.queue_free()
	
	for researcher in hired_lead_researchers_arr:
		var item:Dictionary = RESEARCHER_UTIL.get_user_object(researcher)
		var new_node:Control = TextBtnPreload.instantiate()
		new_node.title = item.name
		new_node.icon = SVGS.TYPE.DRS
		List.add_child(new_node)
