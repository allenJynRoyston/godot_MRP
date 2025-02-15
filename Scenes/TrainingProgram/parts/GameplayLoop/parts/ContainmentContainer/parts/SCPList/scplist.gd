extends PanelContainer

@onready var SCPItemList:VBoxContainer = $MarginContainer/PanelContainer/VBoxContainer/SCPItemList

enum LIST_TYPE {CONTAINED, AVAILABLE}

const SCPListItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ContainmentContainer/parts/SCPList/SCPListItem/SCPListItem.tscn")

var previous_scp_data:Dictionary = {}
var scp_data:Dictionary = {} 

var list_type:LIST_TYPE = LIST_TYPE.AVAILABLE : 
	set(val):
		previous_type = list_type
		list_type = val
		on_list_type_update()

var onUpdate:Callable = func(data:Dictionary):pass
var previous_type:LIST_TYPE
var active_index:int = -1 

var filter_for_data:Dictionary = {} : 
	set(val):
		filter_for_data = val
		on_filter_for_data_update()

# --------------------------------------------------------------------------------------------------		
func _init() -> void:
	SUBSCRIBE.subscribe_to_scp_data(self)

func _exit_tree() -> void: 
	SUBSCRIBE.unsubscribe_to_scp_data(self)

func _ready() -> void:
	clear_list()
	on_list_type_update()
	on_filter_for_data_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_reset() -> void:
	active_index = -1
	for index in SCPItemList.get_child_count():
		var node:Control = SCPItemList.get_child(index)
		node.is_active = false
	onUpdate.call({})
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_list_type_update() -> void:
	if !is_node_ready():return
	if previous_type != list_type:
		on_reset()
		
	on_scp_data_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_filter_for_data_update() -> void:
	if !is_node_ready():return
	#on_scp_data_update()
# --------------------------------------------------------------------------------------------------		
	
# --------------------------------------------------------------------------------------------------		
func clear_list() -> void:
	for child in SCPItemList.get_children():
		child.queue_free()	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	previous_scp_data = scp_data
	scp_data = new_val
	if !is_node_ready():return
	
	clear_list()
	var room_whitelist:int = -1
	
	if !filter_for_data.is_empty():
		room_whitelist = filter_for_data.ref

	if scp_data.is_empty():
		return

	match list_type:
		LIST_TYPE.AVAILABLE:
			for index in scp_data.available_list.size():
				var data:Dictionary = scp_data.available_list[index]
				var new_item:Control = SCPListItemPreload.instantiate()
				var scp_details:Dictionary = SCP_UTIL.return_data(data.ref)
				var is_available:bool = true if room_whitelist == -1 else room_whitelist in scp_details.containment_requirements
	
				new_item.data = data
				new_item.is_active = active_index == index
				new_item.onClick = func() -> void:
					on_toggle_active_active(index)
				
				SCPItemList.add_child(new_item)
		LIST_TYPE.CONTAINED:
			for index in scp_data.contained_list.size():
				var data:Dictionary = scp_data.contained_list[index]
				var new_item:Control = SCPListItemPreload.instantiate()
				new_item.data = data
				new_item.is_active = active_index == index
				new_item.onClick = func() -> void:
					on_toggle_contained_active(index)
				
				SCPItemList.add_child(new_item)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_toggle_active_active(new_active_index:int) -> void:
	active_index = new_active_index
	for index in SCPItemList.get_child_count():
		var node:Control = SCPItemList.get_child(index)
		if active_index == index:
			node.is_active = !node.is_active
			var data:Dictionary = scp_data.available_list[active_index]
			onUpdate.call(SCP_UTIL.return_data(data.ref) if node.is_active else {})
			
			if scp_data.available_list[active_index].is_new:
				scp_data.available_list[active_index].is_new = !scp_data.available_list[active_index].is_new
				SUBSCRIBE.scp_data = scp_data
		else:
			node.is_active = false
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_toggle_contained_active(active_index:int) -> void:
	for index in SCPItemList.get_child_count():
		var node:Control = SCPItemList.get_child(index)
		if active_index == index:
			node.is_active = !node.is_active
			var data:Dictionary = scp_data.contained_list[active_index]
			onUpdate.call(SCP_UTIL.return_data(data.ref) if node.is_active else {})
		else:
			node.is_active = false
# --------------------------------------------------------------------------------------------------		
	
