extends PanelContainer

@onready var Energy:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/Energy
@onready var Header:PanelContainer = $VBoxContainer/Header
@onready var header_stylebox_copy:StyleBoxFlat = Header.get('theme_override_styles/panel').duplicate()

var amount:int : 
	set(val):
		amount = val
		on_amount_update()
		
var max_amount:int : 
	set(val):
		max_amount = val
		on_max_amount_update()
		
var flashing:bool = false

var room_config:Dictionary
var current_location:Dictionary

const tutorial_notes:Array = [
	"Power is required for rooms and modules.",
	"I can get more by building certain rooms or upgrading the wing via Engineering.",
]


# -----------------------------------------------
func _init() -> void:
	GBL.subscribe_to_process(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_current_location(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)	

func _notification(what):
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			if is_visible_in_tree():
				SUBSCRIBE.add_note_node(self)
			else:
				SUBSCRIBE.remove_note_node(self)

func _ready() -> void:
	Header.set('theme_override_styles/panel', header_stylebox_copy)	
# --------------------------------------------------------------------------------------------------

# -----------------------------------------------	
func on_amount_update() -> void:
	Energy.amount = amount
# -----------------------------------------------			

# ----------------------------------------------			
func on_max_amount_update() -> void: 
	Energy.max_amount = max_amount
# -----------------------------------------------			

# -----------------------------------------------			
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val	
	U.debounce(str(self, "_update_node"), update_node)

func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	U.debounce(str(self, "_update_node"), update_node)
	
func update_node() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return
	var ring_level_config:Dictionary = GAME_UTIL.get_ring_level_config()
	amount = ring_level_config.energy.available - ring_level_config.energy.used
	max_amount = ring_level_config.energy.available
	flashing = amount <= 0
	Energy.is_negative = amount <= 0
# -----------------------------------------------			

# -----------------------------------------------
func on_process_update(delta: float, time_passed:float) -> void:
	if !is_node_ready():
		return

	# Oscillates between 0 and 1
	var t:float = (sin(time_passed * 5.0) + 1.0) / 2.0
	
	# Blend between black and red
	header_stylebox_copy.bg_color = COLORS.primary_black.lerp(COLORS.disabled_color, t) if flashing else COLORS.primary_black
# -----------------------------------------------
