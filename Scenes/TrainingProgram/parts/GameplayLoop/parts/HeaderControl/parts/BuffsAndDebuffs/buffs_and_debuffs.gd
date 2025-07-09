extends Control

@onready var RootPanel:PanelContainer = $PanelContainer
@onready var MarginPanel:MarginContainer = $PanelContainer/MarginContainer

@onready var FloorBuffsContainer:HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/FloorBuffsContainer
@onready var RingBuffsContainer:HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/RingBuffsContainer
@onready var RoomBuffContainer:HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/RoomBuffContainer

const BuffOrDebuffTag:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/HeaderControl/parts/BuffsAndDebuffs/BuffOrDebuffTag/BuffOrDebuffTag.tscn")

var current_location:Dictionary = {}
var room_config:Dictionary = {}
var control_pos:Dictionary = {}

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)	
	SUBSCRIBE.subscribe_to_current_location(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)


func _ready() -> void:	
	await U.tick()
	
	control_pos[RootPanel] = {
		"show": 0,
		"hide": -MarginPanel.size.y
	}
		
	reveal(false, true)
	update.call_deferred()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reveal(state:bool, instant:bool = false) -> void:
	if control_pos.is_empty():return
	
	var new_pos:int = control_pos[RootPanel].show if state else control_pos[RootPanel].hide
	
	if instant:
		RootPanel.position.y = new_pos
		return
	
	await U.tween_node_property(RootPanel, "position:y", new_pos)
# --------------------------------------------------------------------------------------------------

# -----------------------------------------------	
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if !is_node_ready() or new_val.is_empty():return
	U.debounce(str(self.name, "_update"), update)
# -----------------------------------------------			

# ----------------------------------------------			
func on_room_config_update(new_val:Dictionary) -> void: 
	room_config = new_val
	if !is_node_ready() or new_val.is_empty():return
	U.debounce(str(self.name, "_update"), update)
# -----------------------------------------------			


# -----------------------------------------------
func update() -> void:
	if !is_node_ready() or room_config.is_empty() or current_location.is_empty():return
	var base_config_data:Dictionary = room_config.base
	var floor_config_data:Dictionary = room_config.floor[current_location.floor]
	var ring_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]	
	var room_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].room[current_location.room]	
	var status_list:Array = []	
		
	for buff in base_config_data.buffs:
		status_list.push_back({
			"title": buff.data.name,
			"duration": buff.duration,
			"hint_description": buff.data.description,
			"type": BASE.TYPE.BUFF
		})
		
	for debuff in base_config_data.debuffs:
		status_list.push_back({
			"title": debuff.data.name,
			"duration": debuff.duration,
			"hint_description": debuff.data.description,
			"type": BASE.TYPE.DEBUFF
		})		
	
	# get buffs
	for buff in floor_config_data.buffs:
		status_list.push_back({
			"title": buff.data.name,
			"duration": buff.duration,
			"hint_description": buff.data.description,
			"type": BASE.TYPE.BUFF
		})
	
	for debuff in floor_config_data.debuffs:
		status_list.push_back({
			"title": debuff.data.name,
			"duration": debuff.duration,
			"hint_description": debuff.data.description,
			"type": BASE.TYPE.DEBUFF
		})
	
	
	for node in FloorBuffsContainer.get_children():
		node.queue_free()
	
	for item in status_list:
		var new_node:Control = BuffOrDebuffTag.instantiate()
		FloorBuffsContainer.add_child(new_node)	
		new_node.title = item.title
		new_node.duration = item.duration
		new_node.hint_description = item.hint_description
		new_node.type = item.type
# -----------------------------------------------
