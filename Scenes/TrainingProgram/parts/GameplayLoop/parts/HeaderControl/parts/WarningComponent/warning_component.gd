extends PanelContainer

@onready var Header:PanelContainer = $VBoxContainer/Header
@onready var header_stylebox_copy:StyleBoxFlat = Header.get('theme_override_styles/panel').duplicate()

@export var flashing:bool = false

# -----------------------------------------------
func _init() -> void:
	GBL.subscribe_to_process(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)

func _notification(what):
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			if is_visible_in_tree():
				SUBSCRIBE.add_note_node(self)
			else:
				SUBSCRIBE.remove_note_node(self)

func _ready() -> void:
	Header.set('theme_override_styles/panel', header_stylebox_copy)	
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
