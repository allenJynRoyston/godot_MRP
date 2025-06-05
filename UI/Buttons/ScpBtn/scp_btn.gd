@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."

@onready var IconBtn:BtnBase = $MarginContainer/HBoxContainer/CostAndCooldown/MarginContainer/HBoxContainer/IconBtn
@onready var LvlLabel:Label = $MarginContainer/HBoxContainer/CostAndCooldown/MarginContainer/HBoxContainer/Label
@onready var NameLabel:Label = $MarginContainer/HBoxContainer/Name/MarginContainer/HBoxContainer/VBoxContainer/NameLabel

@export var panel_color:Color = Color("0e0e0ecb") : 
	set(val):
		panel_color = val
		on_panel_color_update()		

var use_location:Dictionary = {} : 
	set(val):
		use_location = val
		on_use_location_update()

var scp_ref:int = -1 : 
	set(val):
		scp_ref = val
		on_scp_ref_update()

var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()

var scp_data:Dictionary = {}

var is_available:bool = true

const LabelSettingsPreload:LabelSettings = preload("res://Scenes/TrainingProgram/parts/Cards/RoomMiniCard/SmallContentFont.tres")

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_scp_data(self)
	

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_scp_data(self)

func _ready() -> void:
	super._ready()	
	on_scp_data_update()
	update_all()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_scp_ref_update() -> void:
	if !is_node_ready():return
	update_all()
	
func on_use_location_update() -> void:
	if !is_node_ready():return
	on_scp_data_update()
	
func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val
	if !is_node_ready():return
	for ref in scp_data:
		var entry:Dictionary = scp_data[ref]
		if entry.location == use_location:
			is_available = false
			scp_ref = ref
			return
	# is empty
	is_available = true		
	scp_ref = -1
			
	
func on_is_selected_update() -> void:
	if !is_node_ready():return
	var panel_color:Color = Color.BLACK if !is_selected else Color.WHITE
	
	var new_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()	
	new_stylebox.bg_color = panel_color
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)

func update_all() -> void:
	update_font_color()
	on_panel_color_update()
	update_text()	

func update_font_color() -> void:
	if !is_node_ready():return
	var label_duplicate:LabelSettings = LabelSettingsPreload.duplicate()
	var new_color:Color = Color.WHITE
	
	if is_available:
		new_color = Color(0.561, 1.0, 0.0)
		
	label_duplicate.font_color = new_color
	for node in [NameLabel]:
		node.label_settings = label_duplicate	
		
	IconBtn.static_color = new_color
	
	
func on_panel_color_update() -> void:
	if !is_node_ready():return
	#var new_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
	#var new_color:Color = panel_color
			#
	#new_stylebox.bg_color = new_color
	#RootPanel.add_theme_stylebox_override("panel", new_stylebox)	
	
func update_text() -> void:
	if !is_node_ready():return
	if scp_ref == -1:
		NameLabel.text = "ASSIGN OBJECT"
		return
	
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	NameLabel.text = "%s" % [scp_details.name]
	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if !is_node_ready():return
	update_font_color()
	on_panel_color_update()
# ------------------------------------------------------------------------------
