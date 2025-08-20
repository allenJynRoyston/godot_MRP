extends PanelContainer

# --------------------------------------------
@onready var Morale:PanelContainer = $VBoxContainer/Content/MarginContainer/HBoxContainer/Morale
@onready var Safety:PanelContainer = $VBoxContainer/Content/MarginContainer/HBoxContainer/Safety
@onready var Readiness:PanelContainer = $VBoxContainer/Content/MarginContainer/HBoxContainer/Readiness

@export var offset_morale:int = 0 : 
	set(val):
		offset_morale = val
		update_node()

@export var offset_safety:int = 0 : 
	set(val):
		offset_safety = val
		update_node()
		
@export var offset_readiness:int = 0 : 
	set(val):
		offset_readiness = val	
		update_node()

var base_states:Dictionary

const tutorial_notes:Array = [
	"There are three main vibes to keep track of: morale, safety and readiness.",
	"I think they're used in events, or possible trigger certain events?",
]
# --------------------------------------------

# --------------------------------------------
func _notification(what):
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			if is_visible_in_tree():
				SUBSCRIBE.add_note_node(self)
			else:
				SUBSCRIBE.remove_note_node(self)

func _init() -> void:
	SUBSCRIBE.subscribe_to_base_states(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_base_states(self)

func _ready() -> void:
	update_node()
# --------------------------------------------

# --------------------------------------------
func on_base_states_update(new_val:Dictionary) -> void:
	base_states = new_val	
	U.debounce(str(self, "_update_node"), update_node)
# --------------------------------------------	

# --------------------------------------------	
func update_node() -> void:
	if !is_node_ready() or base_states.is_empty():return
	var metrics:Dictionary = GAME_UTIL.get_metrics()
	
	# update vibes
	Morale.value = metrics[RESOURCE.METRICS.MORALE]
	Safety.value = metrics[RESOURCE.METRICS.SAFETY]
	Readiness.value = metrics[RESOURCE.METRICS.READINESS]
	
	Morale.offset_amount = offset_morale
	Safety.offset_amount = offset_safety
	Readiness.offset_amount = offset_readiness
# --------------------------------------------	
