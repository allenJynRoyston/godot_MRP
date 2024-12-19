extends PanelContainer

var gameplay_node:Control

@onready var List:VBoxContainer = $VBoxContainer/HBoxContainer/IncomeContainer/List

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

func _ready() -> void:
	gameplay_node = GBL.find_node(REFS.GAMEPLAY_LOOP)
	on_lead_researchers_data_update()

var lead_researchers_data:Array = [] : 
	set(val):
		lead_researchers_data = val
		on_lead_researchers_data_update()

func on_lead_researchers_data_update() -> void:
	if !is_node_ready():return
	
	for node in List.get_children():
		node.queue_free()
	
	for item in lead_researchers_data:
		var new_node:Control = TextBtnPreload.instantiate()
		new_node.title = item.name
		new_node.icon = SVGS.TYPE.DRS
		List.add_child(new_node)
