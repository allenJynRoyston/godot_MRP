extends PanelContainer

@onready var Admin:PanelContainer = $VBoxContainer/Content/MarginContainer/HBoxContainer/Admin
@onready var Researcher:PanelContainer = $VBoxContainer/Content/MarginContainer/HBoxContainer/Researchers
@onready var Security:PanelContainer = $VBoxContainer/Content/MarginContainer/HBoxContainer/Security
@onready var DClass:PanelContainer = $VBoxContainer/Content/MarginContainer/HBoxContainer/DClass

@onready var Header:PanelContainer = $VBoxContainer/Header
@onready var header_stylebox_copy:StyleBoxFlat = Header.get('theme_override_styles/panel').duplicate()

# ----------------------------------------------
@export var admin_count:int :
	set(val):
		admin_count = val
		on_admin_update()
		
@export var researcher_count:int :
	set(val):
		researcher_count = val
		on_researcher_update()
		
@export var security_count:int :
	set(val):
		security_count = val
		on_security_update()
		
@export var dclass_count:int :
	set(val):
		dclass_count = val
		on_dclass_update()
		
@export var admin_max_count:int :
	set(val):
		admin_max_count = val
		on_admin_update()
		
@export var researcher_max_count:int :
	set(val):
		researcher_max_count = val
		on_researcher_update()
		
@export var security_max_count:int :
	set(val):
		security_max_count = val
		on_security_update()

@export var dclass_max_count:int :
	set(val):
		dclass_max_count = val
		on_dclass_update()
# ----------------------------------------------

# ----------------------------------------------
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
	
	on_admin_update()
	on_researcher_update()
	on_security_update()
	on_dclass_update()
# ----------------------------------------------

# ----------------------------------------------
func on_admin_update() -> void:
	if !is_node_ready():return
	Admin.value = admin_count
	Admin.max_val = admin_max_count
	
func on_researcher_update() -> void:
	if !is_node_ready():return
	Researcher.value = researcher_count
	Researcher.max_val = researcher_max_count
	
func on_security_update() -> void:
	if !is_node_ready():return
	Security.value = security_count
	Security.max_val = security_max_count	

func on_dclass_update() -> void:
	if !is_node_ready():return	
	DClass.value = dclass_count
	DClass.max_val = dclass_max_count	
# ----------------------------------------------

# -----------------------------------------------
func on_process_update(delta: float, time_passed:float) -> void:
	if !is_node_ready():
		return

	# Oscillates between 0 and 1
	var t:float = (sin(time_passed * 5.0) + 1.0) / 2.0
	var count:int = admin_count + researcher_count + security_count + dclass_count
	
	# Blend between black and red
	header_stylebox_copy.bg_color = COLORS.primary_black.lerp(COLORS.disabled_color, t) if count < 3 else COLORS.primary_black
# -----------------------------------------------
