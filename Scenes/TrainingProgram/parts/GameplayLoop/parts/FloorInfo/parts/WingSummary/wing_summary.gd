extends PanelContainer

@onready var MainPanel:PanelContainer = $"."
@onready var DetailsPanel:PanelContainer = $VBoxContainer/DetailsPanel
@onready var IconBtn:BtnBase = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/HBoxContainer/IconBtn
@onready var TitleLabel:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/HBoxContainer/TitleLabel
@onready var StatusLabel:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/PanelContainer/HBoxContainer/StatusLabel

@export var assigned_wing:int = -1

var previous_show_details:bool 

var always_show_details:bool = false

var show_details:bool = false : 
	set(val):
		previous_show_details = show_details
		show_details = val
		on_show_details_update()

var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()
		
var current_location:Dictionary = {}

# -----------------------------------------------
func _ready() -> void:
	on_show_details_update()
	TitleLabel.text = "WING %s" % [assigned_wing]

func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	
func _exit_tree() -> void: 
	SUBSCRIBE.unsubscribe_to_current_location(self)
# -----------------------------------------------

# -----------------------------------------------
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	is_active = current_location.ring == assigned_wing
	if is_active:
		show_details = true
	else:
		show_details = always_show_details
# -----------------------------------------------

# -----------------------------------------------	
func toggle_details() -> void:
	always_show_details = !always_show_details
# -----------------------------------------------		

# -----------------------------------------------
func on_show_details_update() -> void:
	if !is_node_ready():return
	DetailsPanel.show() if show_details else DetailsPanel.hide()
# -----------------------------------------------

# -----------------------------------------------
func on_is_active_update() -> void:
	if !is_node_ready():return
	
	IconBtn.show() if is_active else IconBtn.hide()
	
	var new_stylebox:StyleBoxFlat = MainPanel.get_theme_stylebox("panel").duplicate()
	new_stylebox.bg_color = "ffbe61" if is_active else "8a8a8a"
	MainPanel.add_theme_stylebox_override("panel", new_stylebox)	
# -----------------------------------------------
