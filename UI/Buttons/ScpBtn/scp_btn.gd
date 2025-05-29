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

var use_location:Dictionary = {}

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
	
func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val
	if !is_node_ready() or scp_data.is_empty():return
	for ref in scp_data.ref:
		var entry:Dictionary = scp_data.ref[ref]
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
		NameLabel.text = "CONTAIN..."
		return
	
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	NameLabel.text = "%s (%s)" % [scp_details.name, scp_details.nickname]
	
	
	#if researcher.is_empty():
		#IconBtn.icon = SVGS.TYPE.ASSIGN
		#LvlLabel.hide()
		#NameLabel.text = "ADD RESEARCHER"
		#
		#hint_title = "ASSIGN RESEARCHER"
		#hint_icon = SVGS.TYPE.ASSIGN
		#hint_description = "Assigning a researcher to this room will increase its level."
		#return
	#
	#var spec:String = "" if researcher.is_empty() else RESEARCHER_UTIL.return_specialization_data(researcher.specializations[0]).shortname	
	#var traits:String = ""
	#
	#for ref in researcher.traits:
		#traits += str(RESEARCHER_UTIL.return_trait_data(ref).name, " , ")
	#traits = traits.left(traits.length() - 3)
	#
	
	#IconBtn.icon = SVGS.TYPE.PLUS
	#LvlLabel.text = str(researcher.level)
	#LvlLabel.show()
	#
	#NameLabel.text = ("%s, %s" % [researcher.name, spec])
	#SpecLabel.text = spec
	#TraitLabel.text = traits
	#
	#hint_title = "RESEARCHER"
	#hint_icon = SVGS.TYPE.DRS if has_pairing else SVGS.TYPE.DRS
	#hint_description = ("Researcher %s, %s specialist." % [researcher.name, spec])
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if !is_node_ready():return
	update_font_color()
	on_panel_color_update()
# ------------------------------------------------------------------------------
