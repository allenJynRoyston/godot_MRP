extends PanelContainer

var gameplay_node:Control

@onready var List:VBoxContainer = $VBoxContainer/HBoxContainer/IncomeContainer/List

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

func _ready() -> void:
	gameplay_node = GBL.find_node(REFS.GAMEPLAY_LOOP)


var lead_researchers_data:Array = [] 

func on_lead_researchers_data_update(new_val:Array = lead_researchers_data) -> void:
	lead_researchers_data = new_val
	if !is_node_ready():return
	
	for node in List.get_children():
		node.queue_free()
	
	for researcher in lead_researchers_data:
		var item:Dictionary = RESEARCHER_UTIL.get_user_object(researcher)
		var new_node:Control = TextBtnPreload.instantiate()
		new_node.title = item.name
		new_node.icon = SVGS.TYPE.DRS
		List.add_child(new_node)
