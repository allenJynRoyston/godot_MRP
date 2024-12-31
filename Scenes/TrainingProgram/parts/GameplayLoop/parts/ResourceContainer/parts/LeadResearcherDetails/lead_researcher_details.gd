extends PanelContainer

var gameplay_node:Control

@onready var List:VBoxContainer = $VBoxContainer/HBoxContainer/IncomeContainer/List
@onready var ProfileCard:PanelContainer = $Control/ProfileCard

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

func _init() -> void:
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)

func _ready() -> void:
	ProfileCard.hide()
	gameplay_node = GBL.find_node(REFS.GAMEPLAY_LOOP)

var hired_lead_researchers_arr:Array = [] 

var focus_arr:Array = [] : 
	set(val):
		focus_arr = val
		on_focus_arr_update()

func on_hired_lead_researchers_arr_update(new_val:Array = hired_lead_researchers_arr) -> void:
	hired_lead_researchers_arr = new_val
	if !is_node_ready():return
	
	for node in List.get_children():
		node.queue_free()
	
	for index in hired_lead_researchers_arr.size():
		var researcher:Array = hired_lead_researchers_arr[index]
		var item:Dictionary = RESEARCHER_UTIL.get_user_object(researcher)
		var new_node:Control = TextBtnPreload.instantiate()
		new_node.title = item.name
		new_node.icon = SVGS.TYPE.DRS
		new_node.onBlur = func(node:Control) -> void:
			focus_arr.erase(index)
			focus_arr = focus_arr
		new_node.onFocus = func(node:Control) -> void:
			focus_arr.push_back(index)
			focus_arr = focus_arr

		List.add_child(new_node)

func on_focus_arr_update() -> void:
	if !is_node_ready():return
	if !focus_arr.is_empty():
		var index:int = focus_arr[0]
		var card_position:Vector2 = List.get_child(index).position
		ProfileCard.position.y = card_position.y
		ProfileCard.data = RESEARCHER_UTIL.get_user_object(hired_lead_researchers_arr[index])
		ProfileCard.size = Vector2(0, 0)
		ProfileCard.show()


func _on_visibility_changed() -> void:
	if !is_node_ready():return
	if !visible:
		ProfileCard.hide()
