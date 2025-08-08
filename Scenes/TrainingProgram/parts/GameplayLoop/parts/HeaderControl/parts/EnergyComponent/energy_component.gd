extends PanelContainer

@onready var Energy:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/Energy
@onready var Header:PanelContainer = $VBoxContainer/Header
@onready var header_stylebox_copy:StyleBoxFlat = Header.get('theme_override_styles/panel').duplicate()

@export var amount:int : 
	set(val):
		amount = val
		on_amount_update()
		
@export var max_amount:int : 
	set(val):
		max_amount = val
		on_max_amount_update()
		
@export var flashing:bool = false

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_process(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)
	
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
func on_process_update(delta: float, time_passed:float) -> void:
	if !is_node_ready():
		return

	# Oscillates between 0 and 1
	var t:float = (sin(time_passed * 5.0) + 1.0) / 2.0
	
	# Blend between black and red
	header_stylebox_copy.bg_color = COLORS.primary_black.lerp(COLORS.disabled_color, t) if flashing else COLORS.primary_black
# -----------------------------------------------
