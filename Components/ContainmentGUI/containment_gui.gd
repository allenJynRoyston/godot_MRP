extends ControlPanel

@onready var WindowUI:Control = $WindowUI
@onready var AvailableVbox:VBoxContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VBoxContainer/VBoxContainer/AvailableVbox
@onready var ActiveVBox:VBoxContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VBoxContainer/VBoxContainer/ActiveVBox

const AvailableContainmentItemScene:PackedScene = preload("res://Components/ContainmentGUI/parts/AvailableContainmentItem.tscn")
const ActiveContainmentItemScene:PackedScene = preload("res://Components/ContainmentGUI/parts/ActiveContainmentItem.tscn")

var section:int = 0 : 
	set(val): 
		section = val		
		on_section_update()
		
@onready var section_arr:Array = [AvailableVbox, ActiveVBox]

var inspect_mode:bool = true

var selected:int = 0 : 
	set(val):
		selected = val
		on_selected_update()

var selected_arr:Array = [] : 
	set(val):
		selected_arr = val
		on_selected_arr_update()

var resources:Dictionary = {} : 
	set(val): 
		resources = val		
		on_data_update()

var resources_copy:Dictionary = {}
		
signal input_response
		
# -----------------------------------	
func _ready() -> void:
	RootPanel = $"."
	super._ready()
	on_data_update()
	
	WindowUI.onDragEnd = func(new_offset:Vector2, node:Control) -> void:
		var GameplayNode = GBL.find_node(REFS.GAMEPLAY_LOOP)
		if GameplayNode != null:
			var window_offset = GameplayNode.window_offsets.duplicate()
			window_offset[self.name] = new_offset
			GameplayNode.window_offsets = window_offset	
# -----------------------------------

# -----------------------------------
func on_is_active_updated() -> void:
	WindowUI.window_is_active = is_active
# -----------------------------------	

# -----------------------------------		
func on_window_offset_update() -> void:
	WindowUI.window_offset = window_offset
# -----------------------------------		
	
# -----------------------------------
func on_active() -> void:
	on_section_update()
# -----------------------------------	

# -----------------------------------
func on_inactive() -> void:
	selected_arr = []
	
	if selected == -1: return
	for index in section_arr[section].get_children().size():
		var node:Control = section_arr[section].get_child(index)
		node.is_active = false
		if "is_selected" in node:
			node.is_selected = false
# -----------------------------------		

# -----------------------------------
func on_selected_arr_update() -> void:
	for index in AvailableVbox.get_children().size():
		var node:Control = AvailableVbox.get_child(index)
		node.is_selected = index in selected_arr
			
func on_selected_update() -> void:
	if selected == -1: return
	for node in [AvailableVbox, ActiveVBox]:
		for child in node.get_children():
			child.is_active = false
	
	for index in section_arr[section].get_children().size():
		var node:Control = section_arr[section].get_child(index)
		node.is_active = index == selected


func on_section_update() -> void:
	selected = -1 if section_arr[section].get_child_count() == 0 else 0
# -----------------------------------	

# -----------------------------------	
func on_data_update(_previous_state:Dictionary = data) -> void:
	if data.is_empty() or resources.is_empty():return

	for node in [AvailableVbox, ActiveVBox]:
		for child in node.get_children():
			child.queue_free()
	
	for available in data.available:
		var new_node:Control = AvailableContainmentItemScene.instantiate()
		new_node.data = available
		new_node.resources = resources
		AvailableVbox.add_child(new_node)
	
	for active in data.active:
		var new_node:Control = ActiveContainmentItemScene.instantiate()
		new_node.data = active
		ActiveVBox.add_child(new_node)
# -----------------------------------	

## -----------------------------------	
#func update_active_items(resource_copy:Dictionary) -> void:
	#for child in AvailableVbox.get_children():
		#child.resources = resource_copy
## -----------------------------------		

# -----------------------------------	
func check_if_enough() -> bool:
	#check_resources()
	
	var i:Dictionary = data.available[selected]
	var required_resources:Array = C.get_reference_data(i.item).required_resources
	for item in required_resources:
		var key:int = item[0]
		var amount:int = item[1]
		if (resources_copy[key].total - resources_copy[key].utilized) < amount:
			print("Not enough resources to build.")
			return false
		
	return true
# -----------------------------------		
	

## -----------------------------------	
#func check_resources() -> void:
	#resources_copy = resources.duplicate(true)
	#
	#for selected in selected_arr:
		#var i:Dictionary = data.available[selected]
		#var required_resources:Array = C.get_reference_data(i.item).required_resources
		#for item in required_resources:
			#var key:int = item[0]
			#var amount:int = item[1]
			#if (resources_copy[key].total - resources_copy[key].utilized) >= amount:
				#resources_copy[key].utilized += amount
#
	#update_active_items(resources_copy)
## -----------------------------------	

# -----------------------------------	
func on_key_input(keycode:int) -> void:
	match keycode:
		# spacebar 
		32: 
			if section == 0 and !inspect_mode:
				if data.available.size() == 0:
					input_response.emit({"selected": []})
					return
				input_response.emit({"selected": selected_arr})
		# e btn
		69: 
			# inspect mode
			if inspect_mode: 				
				var list_size:int = section_arr[section].get_children().size()
				if list_size > 0:					
					print("inspect: ", section_arr[section].get_child(selected).data)
				return
				
			# build mode
			if section == 0:				
				if selected not in selected_arr:
					if check_if_enough():
						selected_arr.push_back(selected)
						selected_arr = selected_arr
				else: 
					selected_arr = selected_arr.filter(func(item): return item != selected)
				#check_resources()
		65: 
			var new_section = section_arr.size() - 1 if section - 1 < 0 else section - 1
			var list_size:int = section_arr[new_section].get_children().size()
			if list_size > 0:
				section = new_section
		# d 
		68: 
			var new_section = (section + 1) % section_arr.size()
			var list_size:int = section_arr[new_section].get_children().size()
			if list_size > 0:			
				section = new_section
		# w btn
		87: 
			var list_size:int = section_arr[section].get_children().size()
			if list_size > 0 and selected != -1:
				selected = list_size - 1 if selected - 1 < 0 else selected - 1
		# s btn
		83: 
			var list_size:int = section_arr[section].get_children().size()
			if list_size > 0 and selected != -1:
				selected = (selected + 1) % list_size
# -----------------------------------		
