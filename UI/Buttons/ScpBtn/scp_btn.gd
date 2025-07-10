@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."

@onready var IconBtn:Control = $MarginContainer/HBoxContainer/CostAndCooldown/MarginContainer/HBoxContainer/SVGIcon
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

const LabelSettingsPreload:LabelSettings = preload("res://Fonts/font_1_black.tres")

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
	
func on_is_selected_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self.name, "_update_all"), update_all)

func on_is_disabled_updated() -> void:
	U.debounce(str(self.name, "_update_all"), update_all)
	
func on_scp_ref_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self.name, "_update_all"), update_all)
	
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
			

func update_all() -> void:
	update_font_color()
	on_panel_color_update()
	update_text()	
	

func update_font_color() -> void:
	if !is_node_ready():return
	var label_duplicate:LabelSettings = LabelSettingsPreload.duplicate()
	var use_color:Color = COLORS.primary_black 
	var altered:bool = false

	if is_disabled:
		use_color = COLORS.disabled_color
		altered = true
	
	use_color.a = 1 if is_selected else 0.7
	
				
	label_duplicate.font_color = use_color
	for node in [NameLabel]:
		node.label_settings = label_duplicate	
	IconBtn.icon_color = use_color

func on_panel_color_update() -> void:
	if !is_node_ready():return
	var new_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()	
	var use_color:Color = COLORS.primary_color 
	var altered:bool = false

	if is_disabled:
		use_color = COLORS.primary_black
		altered = true
		
	use_color.a = 1 if is_selected else 0.7		
		
	new_stylebox.bg_color = use_color
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)	
	
func update_text() -> void:
	if !is_node_ready():return
	
	if is_disabled:
		if scp_ref == -1:
			NameLabel.text = "UNAVAILABLE"
			IconBtn.icon = SVGS.TYPE.LOCK
			hint_description = "Room must be active to assign an object to containment."
			
		else:
			var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
			NameLabel.text = "%s (AT RISK)" % [scp_details.name]	
			IconBtn.icon = SVGS.TYPE.DANGER			
			hint_description = "Room not activated - risk of containment breach increased!"

		return

	if scp_ref == -1:
		NameLabel.text = "ASSIGN OBJECT"
		IconBtn.icon = SVGS.TYPE.PLUS		
		return
	
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	NameLabel.text = "%s" % [scp_details.name]
	IconBtn.icon = SVGS.TYPE.CONTAIN		

	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if !is_node_ready():return
	update_font_color()
	on_panel_color_update()
# ------------------------------------------------------------------------------
