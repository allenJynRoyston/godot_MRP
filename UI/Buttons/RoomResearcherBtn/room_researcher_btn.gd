@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."

@onready var IconBtn:BtnBase = $MarginContainer/HBoxContainer/CostAndCooldown/MarginContainer/HBoxContainer/IconBtn
@onready var LvlLabel:Label = $MarginContainer/HBoxContainer/CostAndCooldown/MarginContainer/HBoxContainer/Label

@onready var NameLabel:Label = $MarginContainer/HBoxContainer/Name/MarginContainer/HBoxContainer/VBoxContainer/NameLabel
@onready var SpecLabel:Label = $MarginContainer/HBoxContainer/Name/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Spec
@onready var TraitLabel:Label = $MarginContainer/HBoxContainer/Name/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Trait
#
@export var panel_color:Color = Color("0e0e0ecb") : 
	set(val):
		panel_color = val
		on_panel_color_update()		

var use_location:Dictionary = {}

var hired_lead_researchers:Array = []

var researcher:Dictionary = {} : 
	set(val):
		researcher = val
		on_researcher_update()

var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()

var is_available:bool = true
var has_pairing:bool = false

const LabelSettingsPreload:LabelSettings = preload("res://Scenes/TrainingProgram/parts/Cards/RoomMiniCard/SmallContentFont.tres")

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)

func _ready() -> void:
	super._ready()	
	on_hired_lead_researchers_arr_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_hired_lead_researchers_arr_update(new_val:Array = hired_lead_researchers) -> void:
	hired_lead_researchers = new_val
	var filtered:Array = hired_lead_researchers.filter(func(x): 
		var researcher_data:Dictionary = RESEARCHER_UTIL.get_user_object(x) 
		return !researcher_data.props.assigned_to_room.is_empty() and (use_location == researcher_data.props.assigned_to_room) 
	)
	if index >= 0 and index < filtered.size():
		var researcher_data:Dictionary = RESEARCHER_UTIL.get_user_object(filtered[index])
		researcher = researcher_data
	else:
		researcher = {}

func on_researcher_update() -> void:
	if !is_node_ready():return
	is_available = researcher.is_empty()
	
	if !researcher.is_empty() and !researcher.props.assigned_to_room.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details(researcher.props.assigned_to_room)
		#if !has_pairing:
			#has_pairing = ROOM_UTIL.check_for_room_pair(extract_data.room.details.ref, researcher)	
	#
	update_all()

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

	
func update_text() -> void:
	if !is_node_ready():return
	
	if researcher.is_empty():
		IconBtn.icon = SVGS.TYPE.PLUS
		LvlLabel.hide()
		NameLabel.text = "ASSIGN RESEARCHER"
		
		hint_title = "ASSIGN RESEARCHER"
		hint_icon = SVGS.TYPE.PLUS
		hint_description = "Assigning a researcher to this room will increase its level."
		return
	
	IconBtn.icon = SVGS.TYPE.ASSIGN
	LvlLabel.text = str(researcher.level)
	LvlLabel.show()
	
	NameLabel.text = ("%s, %s" % [researcher.name, researcher.specialization.details.name])
	SpecLabel.text = "" if researcher.is_empty() else researcher.specialization.details.name	
	TraitLabel.text = "" if researcher.is_empty() else researcher.trait.details.name
	
	hint_title = "RESEARCHER"
	hint_icon = SVGS.TYPE.DRS if has_pairing else SVGS.TYPE.DRS
	hint_description = ("Researcher %s, %s specialist." % [researcher.name, researcher.specialization.details.name])
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if !is_node_ready():return
	update_font_color()
	on_panel_color_update()
# ------------------------------------------------------------------------------
