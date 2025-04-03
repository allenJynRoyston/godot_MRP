extends PanelContainer

@onready var CapacityList:VBoxContainer = $VBoxContainer/HBoxContainer/Capacity/CapacityList
@onready var UtilizedList:VBoxContainer = $VBoxContainer/HBoxContainer/Utilized/UtilizedList

@onready var TotalCapacity:Label = $VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/TotalCapacity
@onready var TotalUtilized:Label = $VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer2/TotalUtilized
@onready var TotalAvailable:Label = $VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer4/TotalAvailable
@onready var TotalFree:Label = $VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer3/TotalFree

const DetailBtnPreload:PackedScene = preload("res://UI/Buttons/DetailBtn/DetailBtn.tscn")

var gameplay_node:Control
var resources_data:Dictionary = {}
var purchased_facility_arr:Array = [] 
var timeline_array:Array = []
var scp_data:Dictionary = {}
var room_config:Dictionary = {}
var base_states:Dictionary = {}

# --------------------------------------------------------------------------------------------------	
func _init() -> void:
	SUBSCRIBE.subscribe_to_scp_data(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.subscribe_to_timeline_array(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_scp_data(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.unsubscribe_to_timeline_array(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)
	
func _ready() -> void:
	gameplay_node = GBL.find_node(REFS.GAMEPLAY_LOOP)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
	if !is_node_ready():return
	#var rd:Dictionary = resources_data[RESOURCE.TYPE.DCLASS]
	#TotalCapacity.text = "%s" % [rd.capacity]
	#TotalUtilized.text = "%s" % [rd.utilized]
	#TotalAvailable.text = "%s" % [rd.amount + rd.utilized]
	#TotalFree.text = "%s" % [rd.amount]
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_timeline_array_update(new_val:Array = timeline_array) -> void:
	timeline_array = new_val
	if !is_node_ready():return
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_base_states_update(new_val:Dictionary = base_states) -> void:
	base_states = new_val
	if !is_node_ready():return
	build_list()
# --------------------------------------------------------------------------------------------------	
# --------------------------------------------------------------------------------------------------	
func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val
	if !is_node_ready():return
	build_list()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_purchased_facility_arr_update(new_val:Array = purchased_facility_arr) -> void:
	purchased_facility_arr = new_val
	if !is_node_ready():return
	build_list()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready():return
	build_list()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func traverse(callback:Callable) -> void:
	for floor_index in room_config.floor:
		for ring_index in room_config.floor[floor_index].ring:
			for room_index in room_config.floor[floor_index].ring[ring_index].room:	
				var room_config_data:Dictionary = room_config.floor[floor_index].ring[ring_index].room[room_index]
				var location:Dictionary = {
					"floor": floor_index,
					"ring": ring_index,
					"room": room_index
				}
				callback.call(room_config_data, location)
# --------------------------------------------------------------------------------------------------		

# -----------------------------------
func build_list() -> void:
	if room_config.is_empty() or scp_data.is_empty() or base_states.is_empty():return

	for node in [CapacityList, UtilizedList]:
		for child in node.get_children():
			child.queue_free()			
			
				
	for item in timeline_array:
		if "props" in item and "utilized_amounts" in item.props:
			for key in item.props.utilized_amounts:
				if key == RESOURCE.TYPE.STAFF:
					var details:Dictionary = SCP_UTIL.return_data(item.ref)
					var amount:int = item.props.utilized_amounts[key]
					var new_node:BtnBase = DetailBtnPreload.instantiate()
					new_node.title = "%s" % [details.name]
					new_node.icon = SVGS.TYPE.STAFF
					new_node.amount = "%s%s" % ["+" if amount >= 0 else "-", amount]
					
					new_node.onClick = func() -> void:
						SUBSCRIBE.current_location = item.location.duplicate()

					UtilizedList.add_child(new_node)
