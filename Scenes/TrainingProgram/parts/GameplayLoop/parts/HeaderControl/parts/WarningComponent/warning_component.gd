extends PanelContainer

@onready var Header:PanelContainer = $VBoxContainer/Header
@onready var header_stylebox_copy:StyleBoxFlat = Header.get('theme_override_styles/panel').duplicate()

@onready var TempIcon:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/TempIcon
@onready var SanityIcon:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/SanityIcon
@onready var PollutionIcon:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/PollutionIcon
@onready var EmergencyIcon:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/EmergencyIcon
@onready var EmptyLabel:Label = $VBoxContainer/Content/MarginContainer/EmptyLabel

@export var flashing:bool = false
var room_config:Dictionary
var current_location:Dictionary

const tutorial_notes:Array = [
	"Lets me know when something isn't right, like extreme temperature or certain dangers."
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
	EmptyLabel.hide()
	update_node()
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
	var monitor:Dictionary = ring_level_config.monitor
		
	TempIcon.show() if absi(monitor.temp) >= 2 else TempIcon.hide()
	TempIcon.icon = SVGS.TYPE.HIGH_TEMP if monitor.temp >= 0 else SVGS.TYPE.LOW_TEMP
	TempIcon.icon_color = Color.RED if absi(monitor.temp) == 3 else Color.BLACK
	
	SanityIcon.show() if absi(monitor.reality) >= 2 else SanityIcon.hide()
	SanityIcon.icon_color = Color.RED if absi(monitor.reality) == 3 else Color.BLACK
	
	PollutionIcon.show() if absi(monitor.pollution) >= 2 else PollutionIcon.hide()
	PollutionIcon.icon_color = Color.RED if absi(monitor.pollution) == 3 else Color.BLACK	
	
	EmergencyIcon.show() if ring_level_config.emergency_mode != ROOM.EMERGENCY_MODES.NORMAL else EmergencyIcon.hide()
	EmergencyIcon.icon_color = Color.RED if ring_level_config.emergency_mode == ROOM.EMERGENCY_MODES.DANGER else Color.BLACK
	
	flashing = absi(monitor.temp) == 3 or absi(monitor.reality) == 3 or absi(monitor.pollution) == 3 or ring_level_config.emergency_mode == ROOM.EMERGENCY_MODES.DANGER
	
	# IS EMPTY
	var is_empty:bool = true
	for key in monitor:
		var amount:int = absi(monitor[key])
		if amount >= 2:
			is_empty = false
			break

	EmptyLabel.show() if is_empty else EmptyLabel.hide()	
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
