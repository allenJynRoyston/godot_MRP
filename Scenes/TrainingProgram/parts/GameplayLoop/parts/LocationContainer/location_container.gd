@tool
extends GameContainer

@onready var FloorLabel:Label = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/FloorLabel
@onready var WingLabel:Label = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WingLabel
#@onready var FloorListContainer:HBoxContainer = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/Floors/FloorListContainer
#@onready var RingListContainer:HBoxContainer = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/Rings/RingListContainer
#@onready var RoomListContainer:HBoxContainer = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/Rooms/RoomListContainer

#var floor_selected:int = 0 : 
	#set(val):
		#floor_selected = val
		#on_floor_selected_updated()
		#
#var ring_selected:int = 0 : 
	#set(val):
		#ring_selected = val
		#on_ring_selected_updated()
#
#var room_selected:int = 0 : 
	#set(val):
		#room_selected = val
		#on_room_selected_updated()
		
var onRoomSelected:Callable = func(_data:Dictionary) -> void:pass

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	#on_floor_selected_updated()
	#on_ring_selected_updated()
	#on_room_selected_updated()	
	
	#for index in FloorListContainer.get_child_count():
		#var node:Control = FloorListContainer.get_child(index)
		#node.floor = index
		#node.onClick = func() -> void:
			#floor_selected = index
			#
	#for index in RingListContainer.get_child_count():
		#var node:Control = RingListContainer.get_child(index)
		#node.onClick = func() -> void:
			#ring_selected = index			
			#
	#for index in RoomListContainer.get_child_count():
		#var node:Control = RoomListContainer.get_child(index)
		#node.room = index + 1
		#node.onClick = func() -> void:
			#room_selected = index
	
	#after_ready.call_deferred()
	
	
#func after_ready() -> void:
	#on_change()
# -----------------------------------------------

# -----------------------------------------------
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if !is_node_ready():return
	FloorLabel.text = "F%s" % [current_location.floor]
	WingLabel.text = "WING %s" % [current_location.ring]
	# -----------------------------------------------
