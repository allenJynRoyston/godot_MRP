extends Control

@onready var SectorLabel:Label = $VBoxContainer/Content/MarginContainer/Label

var current_location:Dictionary

const tutorial_notes:Array = [
	"Current location."	
]

# -----------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	modulate.a = 0
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)	


func _ready() -> void:
	pass
	#modulate.a = 1

func _notification(what):
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			if is_visible_in_tree():
				SUBSCRIBE.add_note_node(self)
			else:
				SUBSCRIBE.remove_note_node(self)
# --------------------------------------------------------------------------------------------------

# -----------------------------------------------			
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	U.debounce(str(self, "_update_node"), update_node)
	
func update_node() -> void:
	if !is_node_ready() or current_location.is_empty():return
	SectorLabel.text = str(current_location.floor, U.ring_to_str(current_location.ring))
# -----------------------------------------------			
