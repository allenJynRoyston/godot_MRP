extends ControlPanel

@onready var WindowUI = $WindowUI
@onready var LevelLabel = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VBoxContainer/LevelLabel
@onready var ListContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VBoxContainer/ListContainer
@onready var PurchaseContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VBoxContainer/PurchaseContainer

var GameplayLoop:Control
var list:Array[Array] = B.get_type_arr()
var selected_vector := Vector2(0, 0)
var selected = BUILDING_TYPE.NONE
var on_floor:int = 0:
	set(val):
		on_floor = val
		on_data_update()
		
signal input_response

# -----------------------------------
func _ready() -> void:
	RootPanel = $"."
	super._ready()
	after_ready.call_deferred()
# -----------------------------------

# -----------------------------------
func after_ready() -> void:
	GameplayLoop = GBL.find_node(REFS.GAMEPLAY_LOOP)
# -----------------------------------

# -----------------------------------
func on_active() -> void:
	assign_selected()
# -----------------------------------	

# -----------------------------------	
func on_is_active_updated() -> void:
	WindowUI.window_is_active = is_active
# -----------------------------------		

# -----------------------------------
func on_inactive() -> void:
	selected = BUILDING_TYPE.NONE
	selected_vector = Vector2(0, 0)
# -----------------------------------	

# -----------------------------------
func on_data_update(_previous_state:Dictionary = data) -> void:
	if data.is_empty():
		return
	
	# TODO: add differntial check so you don't have to redraw every element that
	# gets replaced
	
	LevelLabel.text = "On level: %s" % [on_floor]

	for node in [ListContainer, PurchaseContainer]:
		for child in node.get_children():
			child.queue_free()

	for item in data.built[on_floor]:
		var newLabel = Label.new()
		newLabel.text = B.return_type_name(item.type)
		ListContainer.add_child(newLabel)
		
	for item in data.purchase_list:
		if on_floor == item.on_floor:
			var newLabel = Label.new()
			newLabel.text = B.return_type_name(item.type)
			PurchaseContainer.add_child(newLabel)		
# -----------------------------------

# -----------------------------------
func is_valid_selection(test_vector:Vector2) -> bool:
	return list.size() > test_vector.y and list[test_vector.y].size() > test_vector.x
# -----------------------------------		

# -----------------------------------		
func assign_selected() -> void:
	selected = list[selected_vector.y][selected_vector.x]
# -----------------------------------		

# -----------------------------------	
func finalize_purchase() -> Dictionary:
	var results:Dictionary = U.calculate_building_costs(GameplayLoop.resource_data, data.purchase_list) 
	
	if results.can_afford:
		var purchased:Array = data.purchase_list.duplicate(true)
		return {"success": true, "purchased": purchased, "new_totals": results.new_totals}
	
	print("Cannot afford purchases: ", results.new_totals)
	return {"success": false}
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
			pass
			#if selected != BUILDING_TYPE.NONE:
				#data.purchase_list.push_back({
					#"type": selected, 
					#"on_floor": on_floor
				#})
		# back
		4194308:
			data.purchase_list.pop_back()
		# space	
		32:			
			if data.purchase_list.size() > 0:	
				var results:Dictionary = finalize_purchase()
				if results.success:
					input_response.emit(results)
			else:
				input_response.emit({})

	# updates parent, which in turn updates this
	GameplayLoop.base_data = data  
# -----------------------------------
