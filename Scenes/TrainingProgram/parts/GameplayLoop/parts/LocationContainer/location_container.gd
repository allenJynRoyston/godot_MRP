@tool
extends GameContainer

@onready var FloorItemContainer:VBoxContainer = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/FloorItemContainer
@onready var RingListContainer:VBoxContainer = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2/RingListContainer
@onready var RoomListContainer:VBoxContainer = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer3/RoomListContainer

var floor_selected:int = 0 : 
	set(val):
		floor_selected = val
		on_floor_selected_updated()
		
var ring_selected:int = 0 : 
	set(val):
		ring_selected = val
		on_ring_selected_updated()

var room_selected:int = 0 : 
	set(val):
		room_selected = val
		on_room_selected_updated()
		
var onRoomSelected:Callable = func(_data:Dictionary) -> void:pass

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	on_floor_selected_updated()
	on_ring_selected_updated()
	on_room_selected_updated()	
	
	for index in FloorItemContainer.get_child_count():
		var node:Control = FloorItemContainer.get_child(index)
		node.floor = index + 1
		node.onClick = func() -> void:
			floor_selected = index
			
	for index in RingListContainer.get_child_count():
		var node:Control = RingListContainer.get_child(index)
		node.onClick = func() -> void:
			ring_selected = index			
			
	for index in RoomListContainer.get_child_count():
		var node:Control = RoomListContainer.get_child(index)
		node.room = index + 1
		node.onClick = func() -> void:
			room_selected = index
	
	after_ready.call_deferred()
	
	
func after_ready() -> void:
	on_change()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func goto_location(data:Dictionary) -> void:
	floor_selected = data.floor
	ring_selected = data.ring
	room_selected = data.room
	
func on_floor_selected_updated() -> void:
	for index in FloorItemContainer.get_child_count():
		var node:Control = FloorItemContainer.get_child(index)
		node.is_selected = floor_selected == index
	on_change()
	
func on_ring_selected_updated() -> void:
	for index in RingListContainer.get_child_count():
		var node:Control = RingListContainer.get_child(index)
		node.is_selected = ring_selected == index
	on_change()
		
func on_room_selected_updated() -> void:
	for index in RoomListContainer.get_child_count():
		var node:Control = RoomListContainer.get_child(index)
		node.is_selected = room_selected == index
	on_change()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------
func on_change() -> void:
	onRoomSelected.call({
		"floor":  floor_selected,
		"ring": ring_selected,
		"room": room_selected
	})
# --------------------------------------------------------------------------------------------------	