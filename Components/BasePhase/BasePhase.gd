extends ControlPanel

@onready var LevelLabel = $MarginContainer/VBoxContainer/LevelLabel
@onready var ListContainer = $MarginContainer/VBoxContainer/ListContainer
@onready var PurchaseContainer = $MarginContainer/VBoxContainer/PurchaseContainer
		
var list:Array[Array] = Buildables.get_type_arr()
var selected_vector := Vector2(0, 0)
var selected = Buildables.TYPE.NONE
		
signal input_response

# -----------------------------------
func _ready() -> void:
	RootPanel = $"."
	super._ready()
# -----------------------------------

# -----------------------------------
func on_active() -> void:
	assign_selected()
# -----------------------------------	

# -----------------------------------
func on_inactive() -> void:
	selected = Buildables.TYPE.NONE
	selected_vector = Vector2(0, 0)
# -----------------------------------	

# -----------------------------------
func on_data_update(_previous_state:Dictionary) -> void:
	if data.is_empty():
		return
	
	# TODO: add differntial check so you don't have to redraw every element that
	# gets replaced
	
	LevelLabel.text = "On level: %s" % [data.floor_selection]

	for node in [ListContainer, PurchaseContainer]:
		for child in node.get_children():
			child.queue_free()

	for type in data.built[data.floor_selection]:
		var newLabel = Label.new()
		newLabel.text = Buildables.return_type_name(type)
		ListContainer.add_child(newLabel)
		
	for item in data.purchase_list:
		if data.floor_selection == item.on_floor:
			var newLabel = Label.new()
			newLabel.text = Buildables.return_type_name(item.type)
			PurchaseContainer.add_child(newLabel)		
# -----------------------------------

# -----------------------------------
func is_valid_selection(test_vector:Vector2) -> bool:
	return list.size() > test_vector.y and list[test_vector.y].size() > test_vector.x
# -----------------------------------		

# -----------------------------------		
func assign_selected() -> void:
	selected = list[selected_vector.y][selected_vector.x]
	print( Buildables.return_type_name(selected) )
# -----------------------------------		

# -----------------------------------	
func finalize_purchase() -> void:
	for item in data.purchase_list:
		data.built[item.on_floor].push_back(item.type)
	data.purchase_list = []
# -----------------------------------	

# -----------------------------------
func on_key_input(keycode: int) -> void:
	match keycode: 
		# a btn
		65: 
			var max_x:int = list[selected_vector.y].size() - 1
			selected_vector.x = max_x if (selected_vector.x - 1 < 0) else selected_vector.x - 1
			assign_selected()
		# d btn
		68: 
			var max_x:int = list[selected_vector.y].size() - 1
			selected_vector.x = 0 if (selected_vector.x + 1 > max_x) else selected_vector.x + 1
			assign_selected()
		# w btn
		87: 			
			var max_y:int = list.size() - 1
			var new_y = max_y if (selected_vector.y - 1 < 0) else selected_vector.y - 1
			var test_vector := Vector2(selected_vector.x, new_y)
			if is_valid_selection(test_vector):
				selected_vector = test_vector
				assign_selected()
		# s btn
		83: 
			var max_y:int = list.size() - 1
			var new_y:int = 0 if (selected_vector.y + 1 > max_y) else selected_vector.y + 1
			var test_vector := Vector2(selected_vector.x, new_y)
			if is_valid_selection(test_vector):
				selected_vector = test_vector
				assign_selected()
		# e btn
		69: 
			if selected != Buildables.TYPE.NONE:
				data.purchase_list.push_back({
					"type": selected, 
					"on_floor": data.floor_selection
				})
		# back
		4194308:
			data.purchase_list.pop_back()
		# space	
		32:	
			finalize_purchase()
			# DO CHECKS FOR PRICE AND STUFF HERE
			input_response.emit({})

	# updates parent, which in turn updates this
	get_parent().base_phase_data = data
# -----------------------------------
