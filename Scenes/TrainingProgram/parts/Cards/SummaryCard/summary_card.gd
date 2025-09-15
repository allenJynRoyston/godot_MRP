extends PanelContainer

# INFOCONTAINER
@onready var CardMargin:MarginContainer = $MarginContainer
@onready var InfoContainer:PanelContainer = $MarginContainer/VBoxContainer/InfoContainer
@onready var ImageTextureRect:TextureRect = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect
@onready var ConstructionCostTag:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/HBoxContainer/ConstructionCostPanel/MarginContainer/HBoxContainer/ConstructionLabel
@onready var SidePanel:VBoxContainer = $Control/SidePanel
@onready var SummaryGrid:PanelContainer = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/SummaryGrid

# sidepanel
@onready var NamePanel:PanelContainer = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/NamePanel
@onready var NameTag:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/NamePanel/MarginContainer/HBoxContainer/NameTag
@onready var LvlTag:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/NamePanel/MarginContainer/HBoxContainer/LvlTag

# cost
@onready var CostPanel:PanelContainer = $Control/SidePanel/CostPanel
@onready var CostLabel:Label = $Control/SidePanel/CostPanel/MarginContainer/HBoxContainer/CostLabel

# temp
@onready var TempPanel:PanelContainer = $Control/SidePanel/TempPanel
@onready var TempIcon:Control = $Control/SidePanel/TempPanel/MarginContainer/HBoxContainer/TempIcon
@onready var TempLabel:Label = $Control/SidePanel/TempPanel/MarginContainer/HBoxContainer/TempLabel

# pollution
@onready var PollutionPanel:PanelContainer = $Control/SidePanel/PollutionPanel
@onready var PollutionLabel:Label = $Control/SidePanel/PollutionPanel/MarginContainer/HBoxContainer/PollutionLabel

# energy
@onready var EnergyPanel:PanelContainer = $Control/SidePanel/EnergyPanel
@onready var EnergyCostLabel:Label = $Control/SidePanel/EnergyPanel/MarginContainer/HBoxContainer/EnergyCostLabel

# status
@onready var StatusOverlay:PanelContainer = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/StatusOverlay
@onready var StatusLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/StatusOverlay/CenterContainer/StatusLabel

# Description 
@onready var DescriptionLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/Description/MarginContainer/VBoxContainer/DescriptionLabel
@onready var QuoteLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/Description/MarginContainer/VBoxContainer/QuoteLabel

# modules
@onready var ModuleContainer:VBoxContainer = $MarginContainer/VBoxContainer/ModuleContainer
@onready var ModuleComponent:PanelContainer = $MarginContainer/VBoxContainer/ModuleContainer/ModuleComponent

# programs
@onready var ProgramContainer:VBoxContainer = $MarginContainer/VBoxContainer/ProgramContainer
@onready var ProgramComponent:PanelContainer = $MarginContainer/VBoxContainer/ProgramContainer/ProgramComponent

# containment
@onready var ContainmentContainer:VBoxContainer = $MarginContainer/VBoxContainer/ContainmentContainer
@onready var ContainmentComponent:PanelContainer = $MarginContainer/VBoxContainer/ContainmentContainer/ContainmentComponent

# passive list effects
@onready var RoomEffects:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/RoomEffects
@onready var RoomEffectLabel:RichTextLabel = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/RoomEffects/MarginContainer/VBoxContainer/RoomEffectLabel

#
@onready var PreviewPanel:PanelContainer = $PreviewControl/PreviewPanel
@onready var PreviewText:RichTextLabel = $PreviewControl/PreviewPanel/MarginContainer/PanelContainer/MarginContainer/RoomPreviewText

@onready var namepanel_stylebox:StyleBoxFlat = NamePanel.get("theme_override_styles/panel").duplicate()
@onready var infocontainer_stylebox:StyleBoxFlat = InfoContainer.get("theme_override_styles/panel").duplicate()

@export var hide_card:bool = false 
		
@export var show_modules:bool = false : 
	set(val):
		show_modules = val
		U.debounce(str(self, "_on_update"), on_update)	

@export var show_module_preview:bool = false : 
	set(val):
		show_module_preview = val
		U.debounce(str(self, "_on_update"), on_update)	
		
@export var show_programs:bool = false : 
	set(val):
		show_programs = val
		U.debounce(str(self, "_on_update"), on_update)	
		
@export var preview_mode:bool = false : 
	set(val):
		preview_mode = val
		on_preview_mode_update()
		
@export var show_sidebar:bool = true : 
	set(val):
		show_sidebar = val
		U.debounce(str(self, "_on_update"), on_update)	
		
@export var ignore_benefits:bool = false : 
	set(val):
		ignore_benefits = val
		U.debounce(str(self, "_on_update"), on_update)	

const NormalFont:FontFile = preload("res://Fonts/PixelOperator.ttf")
const BoldFont:FontFile = preload("res://Fonts/PixelOperator-Bold.ttf")
		
var preview_mode_ref:int = -1:
	set(val):
		preview_mode_ref = val
		on_preview_mode_ref_update()

var use_location:Dictionary : 
	set(val):
		use_location = val
		on_use_location_update()

var room_config:Dictionary
var base_states:Dictionary
var hired_lead_researchers:Array
var preview_passive:int = -1

# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)

func _ready() -> void:
	InfoContainer.set("theme_override_styles/panel", infocontainer_stylebox)
	NamePanel.set("theme_override_styles/panel", namepanel_stylebox)
	on_modules_only_update()
	on_preview_mode_update()
	on_preview_mode_ref_update()
	
	ModuleComponent.onUpdate = func(_ref_data:Dictionary, _node:Control) -> void:
		preview_passive = _ref_data.data.ref
		PreviewPanel.global_position = _node.global_position - Vector2(205, 0)
		var effect_details:Dictionary = ROOM.return_effect(_ref_data.data.ref)
		var room_level_config:Dictionary = GAME_UTIL.get_room_level_config()	
		PreviewText.text = U.build_effect_string(effect_details, true, room_level_config.department_props.operator, true)
		PreviewPanel.size = Vector2(1, 1)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_preview_mode_ref_update() -> void:
	U.debounce(str(self, "_on_update"), on_update)
	
func on_preview_mode_update() -> void:
	U.debounce(str(self, "_on_update"), on_update)
	
func on_modules_only_update() -> void:
	U.debounce(str(self, "_on_update"), on_update)
	
func on_use_location_update() -> void:
	U.debounce(str(self, "_on_update"), on_update)
	
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	U.debounce(str(self, "_on_update"), on_update)

func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	hired_lead_researchers = new_val
	U.debounce(str(self, "_on_update"), on_update)
# ------------------------------------------------------------------------------

# -----------------------------------------------bb-------------------------------	
func on_update() -> void:
	if !is_node_ready() or room_config.is_empty() or use_location.is_empty():return
	var room_details:Dictionary = ROOM_UTIL.return_data_via_location(use_location)
	var scp_details:Dictionary = ROOM_UTIL.return_scp_data_via_location(use_location)

	# set defaults
	StatusOverlay.hide()
	PreviewPanel.hide()
	RoomEffectLabel.text = ""
	SummaryGrid.room_id = use_location.room

	# preview data...
	if preview_mode and preview_mode_ref != -1:
		var preview_data:Dictionary = ROOM_UTIL.return_data(preview_mode_ref)		
		var adjacent_rooms_refs:Array = ROOM_UTIL.find_refs_of_adjuacent_rooms(use_location)
		
		if !ignore_benefits:
			for ref in adjacent_rooms_refs:
				var adjacent_room_details:Dictionary = ROOM_UTIL.return_data(ref)
				var utility_props:Dictionary = adjacent_room_details.utility_props
				if !utility_props.is_empty() and !preview_data.department_props.is_empty():
					if utility_props.has("level"):
						preview_data.department_props.level += utility_props.level
					if utility_props.has("metric"):
						preview_data.department_props.metric.append( utility_props.metric )
					if utility_props.has("currency"):
						preview_data.department_props.currency.append( utility_props.currency )
					if utility_props.has("effects"):
						preview_data.department_props.effects.append( utility_props.effects )
							
		# shape for preview
		fill( preview_data, {}, true )
		return
	
	# no room, hide and end...
	if room_details.is_empty():
		infocontainer_stylebox.bg_color = Color.DARK_CYAN
		namepanel_stylebox.bg_color = Color.DARK_CYAN	
		NameTag.text = "EMPTY"	
		DescriptionLabel.text = "Space is empty."
		LvlTag.text = ""
		
		RoomEffects.hide()
		SidePanel.hide()
		QuoteLabel.hide()
		RoomEffectLabel.hide()
		return
	
	# hide card, show modules only
	if hide_card:		
		SidePanel.hide()
		InfoContainer.hide()		

		# passives
		if room_details.passive_abilities.call().is_empty() or !show_modules:
			ModuleContainer.hide()
			ModuleComponent.room_details = {}
		else:
			ModuleContainer.show()
			ModuleComponent.use_location = use_location		
			ModuleComponent.room_details = room_details
		
		# assign programs
		if room_details.abilities.call().is_empty() or !show_programs:
			ProgramContainer.hide()
			ProgramComponent.room_details = {}
		else:
			ProgramContainer.show()
			ProgramComponent.use_location = use_location			
			ProgramComponent.room_details = room_details	
		
		# show preview	
		PreviewPanel.show() if show_module_preview else PreviewPanel.hide()
				
		return
	
	# else fill data
	fill(room_details, scp_details, false)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func fill(room_details:Dictionary, scp_details:Dictionary = {}, is_preview:bool = false) -> void:
	var room_level_config:Dictionary = GAME_UTIL.get_room_level_config()		
	var is_under_construction:bool = false if is_preview else ROOM_UTIL.is_under_construction(use_location) 
	var is_activated:bool = true if is_preview else ROOM_UTIL.is_room_activated(use_location)
	var can_contain:bool = ROOM_UTIL.room_can_contain(use_location)
	var final_effect_string:String = ""
	
	# assign details	
	SidePanel.show() if show_sidebar else SidePanel.hide()
	InfoContainer.show()
	DescriptionLabel.show()
	QuoteLabel.show()
	RoomEffectLabel.show()
	RoomEffects.hide()

	# basics
	DescriptionLabel.text = room_details.description
	QuoteLabel.text = '"%s"' % room_details.quote

	# fill image
	SummaryGrid.preview_mode = preview_mode
	SummaryGrid.show()
	ImageTextureRect.hide()
	ImageTextureRect.texture = null
		
	# energy
	EnergyCostLabel.text = str(room_details.required_energy)
	EnergyPanel.show() if room_details.required_energy > 0 else EnergyPanel.hide()
	
	# cost
	CostLabel.text = str(room_details.costs.purchase)
	CostPanel.show() if room_details.costs.purchase > 0 and is_preview else CostPanel.hide()
	
	# pollution
	PollutionLabel.text = str(room_details.environmental.pollution)
	PollutionPanel.show() if room_details.environmental.pollution else PollutionPanel.hide()
	
	# temp
	TempLabel.text = str(room_details.environmental.temp)
	TempIcon.icon = SVGS.TYPE.LOW_TEMP if room_details.environmental.temp < 0 else SVGS.TYPE.HIGH_TEMP	
	TempPanel.show() if room_details.environmental.temp != 0 else TempPanel.hide()

	#------------------ IF CONTAINMENT CELL ...
	if can_contain:
		final_effect_string += U.build_scp_string(scp_details.name) if !scp_details.is_empty() else U.build_scp_string("None")
	
	#------------------ IF UTILITY...
	if !room_level_config.utility_props.is_empty():
		# set defaults
		RoomEffects.hide()
		infocontainer_stylebox.bg_color = Color.WHITE
		namepanel_stylebox.bg_color = Color.WHITE
		
		# update name/level tag
		LvlTag.text = room_details.shortname
		LvlTag.custom_minimum_size.x = 100
		
		# build utility string
		final_effect_string += U.build_utility_props_string(room_details.utility_props)

	# ---------------- IF DEPARTMENT...
	if !room_level_config.department_props.is_empty():
		# set defaults
		infocontainer_stylebox.bg_color = COLORS.primary_color
		namepanel_stylebox.bg_color = COLORS.primary_color

		# determine which department prop to use; room_level or room_detail
		var department_props: Dictionary = room_level_config.department_props if !is_preview else room_details.department_props
		# this is correct - use room_details for the level and room_level_config.department_props.bonus to get their real impact
		var amount:int = room_details.department_props.level + department_props.bonus 

		# add level to summary		
		if !department_props.currency.is_empty() or !department_props.metric.is_empty():
			if !final_effect_string.is_empty():
				final_effect_string += "\n\n"
			final_effect_string += U.build_department_prop_string(department_props, amount)			
			final_effect_string += " (current level: [b]%s[/b])." % room_level_config.department_props.level
		
		# get effects
		if !department_props.effects.is_empty():
			if !final_effect_string.is_empty():
				final_effect_string += "\n\n"
			final_effect_string += U.build_department_effect_string(department_props, use_location, is_preview)

		# update level tag
		LvlTag.text = "LVL %s" % room_level_config.department_props.level
		LvlTag.custom_minimum_size.x = 60
		
	# update texts
	NameTag.text = room_details.name
	RoomEffectLabel.text = final_effect_string
	RoomEffects.hide() if RoomEffectLabel.text.is_empty() else RoomEffects.show()
	

	# under construction
	if is_under_construction:
		StatusLabel.text = "UNDER CONSTRUCTION"
		StatusOverlay.show()
		return

	# is activated
	if !is_activated:
		StatusLabel.text = "INACTIVE"
		StatusOverlay.show()
		return	
# ------------------------------------------------------------------------------
	
# ------------------------------------------------------------------------------
func deselect_btns() -> void:
	for node in [ModuleComponent, ProgramComponent, ContainmentComponent]:
		for btn in node.get_btns():
			btn.is_selected = false
			
	PreviewPanel.hide()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_program_btns() -> Array:
	var btn_list:Array = []
	
	#for node in [ProgramComponent]:
		#if node.is_visible_in_tree():
			#for btn in node.get_btns():
				#btn_list.push_back(btn)
	##
	return btn_list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_module_btns() -> Array:
	var btn_list:Array = []
	
	for node in [ModuleComponent]:
		if node.is_visible_in_tree():
			for btn in node.get_btns():
				btn_list.push_back(btn)
	#
	return btn_list
# ------------------------------------------------------------------------------
				

# ------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if !is_node_ready():return
	SidePanel.position.x = CardMargin.size.x - 5
# ------------------------------------------------------------------------------
	
