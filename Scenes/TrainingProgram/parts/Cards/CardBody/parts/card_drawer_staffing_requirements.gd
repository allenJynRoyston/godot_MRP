@tool
extends CardDrawerClass

@onready var ListContainer:HBoxContainer = $MarginContainer/MarginContainer/ListContainer

@onready var Staff:Control = $MarginContainer/MarginContainer/ListContainer/Staff
@onready var Technicians:Control = $MarginContainer/MarginContainer/ListContainer/Technician
@onready var Security:Control = $MarginContainer/MarginContainer/ListContainer/Security
@onready var DClass:Control = $MarginContainer/MarginContainer/ListContainer/DClass

var current_location:Dictionary
var room_config:Dictionary

var required_personnel:Array = [] : 
	set(val):
		required_personnel = val
		on_required_personnel_update()

func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_room_config(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)	
	SUBSCRIBE.unsubscribe_to_room_config(self)

func _ready() -> void:
	super._ready()

func clear() -> void:
	for node in [Staff, Technicians, Security, DClass]:
		node.is_faded = true

func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	U.debounce(str(self, '_update_node'), on_required_personnel_update)
	
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	U.debounce(str(self, '_update_node'), on_required_personnel_update)

func on_required_personnel_update() -> void:
	if !is_node_ready() or  current_location.is_empty() or room_config.is_empty():return
	var ring_config:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]
	
	
	for node in [Staff, Technicians, Security, DClass]:
		node.is_faded = true
		node.is_negative = false
		
	for key in required_personnel:
		match key:
			RESOURCE.PERSONNEL.STAFF:
				Staff.is_faded = false
				Staff.is_negative = !ring_config.personnel[RESOURCE.PERSONNEL.STAFF]
			RESOURCE.PERSONNEL.TECHNICIANS:
				Technicians.is_faded = false
				Technicians.is_negative = !ring_config.personnel[RESOURCE.PERSONNEL.TECHNICIANS]
			RESOURCE.PERSONNEL.SECURITY:
				Security.is_faded = false
				Security.is_negative = !ring_config.personnel[RESOURCE.PERSONNEL.SECURITY]
			RESOURCE.PERSONNEL.DCLASS:
				DClass.is_faded = false
				DClass.is_negative = !ring_config.personnel[RESOURCE.PERSONNEL.DCLASS]
