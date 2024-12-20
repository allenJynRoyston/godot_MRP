@tool
extends GameContainer

@onready var SubviewPanelContainer:PanelContainer = $SubViewport/PanelContainer
@onready var RoomStatusListContainer:VBoxContainer = $SubViewport/PanelContainer/MarginContainer/RoomStatusListContainer

@onready var RoomStatusItem1:Control = $SubViewport/PanelContainer/MarginContainer/RoomStatusListContainer/RoomStatusItem1
@onready var RoomStatusItem2:Control = $SubViewport/PanelContainer/MarginContainer/RoomStatusListContainer/RoomStatusItem2
@onready var RoomStatusItem3:Control = $SubViewport/PanelContainer/MarginContainer/RoomStatusListContainer/RoomStatusItem3
@onready var RoomStatusItem4:Control = $SubViewport/PanelContainer/MarginContainer/RoomStatusListContainer/RoomStatusItem4
@onready var RoomStatusItem5:Control = $SubViewport/PanelContainer/MarginContainer/RoomStatusListContainer/RoomStatusItem5
@onready var RoomStatusItem6:Control = $SubViewport/PanelContainer/MarginContainer/RoomStatusListContainer/RoomStatusItem6

var gameplay_node:Control

var max_height:int : 
	set(val): 
		max_height = val
		on_max_height_update()
		
var current_floor:int = 0 : 
	set(val): 
		if current_floor != val:
			update_room_states()
		current_floor = val
		
var current_ring:int = 0 : 
	set(val): 
		if current_ring != val:
			update_room_states()
		current_ring = val
		
var current_room:int = 0 : 
	set(val): 
		current_room = val
		highlight_current_room.call_deferred()
		
var room_nodes:Array[Control] = []
		
# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	gameplay_node = GBL.find_node(REFS.GAMEPLAY_LOOP)
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	room_nodes = [RoomStatusItem1, RoomStatusItem2, RoomStatusItem3, RoomStatusItem4, RoomStatusItem5, RoomStatusItem6]
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_room_config_update() -> void:
	update_room_states()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------		
func on_current_location_update() -> void:
	if !is_node_ready() or current_location.is_empty():return	
	current_floor = current_location.floor
	current_ring = current_location.ring
	current_room = current_location.room	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func update_room_states() -> void:
	if room_config.is_empty() or !is_node_ready():return
	await U.set_timeout(0.0)
	for index in room_config.floor[current_floor].ring[current_ring].room:
		var data = room_config.floor[current_floor].ring[current_ring].room[index]
		room_nodes[index].room_id = index
		room_nodes[index].designation = "%s-%s-%s" % [current_floor, current_ring, index] 
		room_nodes[index].data = data
		room_nodes[index].onClick = func() -> void:
			#GBL.find_node(REFS.GAMEPLAY_LOOP).current_camera_zoom = CAMERA.ZOOM.RM
			gameplay_node.goto_location({"floor": current_floor, "ring": current_ring, "room": index})
			
func highlight_current_room() -> void:
	if !is_node_ready():return
	await U.tick()
	for index in RoomStatusListContainer.get_child_count():
		room_nodes[index].is_highlighted = index == current_room	
		room_nodes[index].is_expanded = false
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------				
func on_max_height_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		Subviewport.get_child(0).size.y = max_height - 1
		Subviewport.size = Subviewport.get_child(0).size
# --------------------------------------------------------------------------------------------------					
