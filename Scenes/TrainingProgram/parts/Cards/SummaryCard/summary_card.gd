extends PanelContainer

# INFOCONTAINER
@onready var CardMargin:MarginContainer = $MarginContainer
@onready var InfoContainer:PanelContainer = $MarginContainer/VBoxContainer/InfoContainer
@onready var ImageTextureRect:TextureRect = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect
@onready var NameTag:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/NamePanel/MarginContainer/HBoxContainer/NameTag
@onready var LvlTag:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/NamePanel/MarginContainer/HBoxContainer/LvlTag
@onready var ConstructionCostTag:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/HBoxContainer/ConstructionCostPanel/MarginContainer/HBoxContainer/ConstructionLabel

# sidepanel
@onready var SidePanel:VBoxContainer = $Control/SidePanel

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
@onready var QuoteLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/Quote/PanelContainer/MarginContainer/QuoteLabel

# modules
@onready var ModuleContainer:VBoxContainer = $MarginContainer/VBoxContainer/ModuleContainer
@onready var ModuleComponent:PanelContainer = $MarginContainer/VBoxContainer/ModuleContainer/ModuleComponent

# programs
@onready var ProgramContainer:VBoxContainer = $MarginContainer/VBoxContainer/ProgramContainer
@onready var ProgramComponent:PanelContainer = $MarginContainer/VBoxContainer/ProgramContainer/ProgramComponent

# containment
@onready var ContainmentContainer:VBoxContainer = $MarginContainer/VBoxContainer/ContainmentContainer
@onready var ContainmentComponent:PanelContainer = $MarginContainer/VBoxContainer/ContainmentContainer/ContainmentComponent

# room effect
@onready var RoomImpact:PanelContainer = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/RoomImpact
@onready var RoomImpactLabel:RichTextLabel = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/RoomImpact/MarginContainer/RoomImpactLabel

# passive list effects
@onready var RoomEffects:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/RoomEffects
@onready var RoomEffectLabel:RichTextLabel = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/RoomEffects/MarginContainer/RoomEffectLabel

@onready var node_list:Array = [StatusOverlay] 

@onready var infocontainer_stylebox:StyleBoxFlat = InfoContainer.get("theme_override_styles/panel").duplicate()

@export var hide_card:bool = false 
		
@export var show_modules:bool = false : 
	set(val):
		show_modules = val
		U.debounce(str(self, "_on_update"), on_update)	
		
@export var show_programs:bool = false : 
	set(val):
		show_programs = val
		U.debounce(str(self, "_on_update"), on_update)	
		
@export var preview_mode:bool = false : 
	set(val):
		preview_mode = val
		on_preview_mode_update()

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

# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	
	
func _ready() -> void:
	on_modules_only_update()
	on_preview_mode_update()
	on_preview_mode_ref_update()
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
	var room_level_config:Dictionary = GAME_UTIL.get_room_level_config()	
	
	# hide all nodes
	for node in node_list:
		node.hide()	
		
	# preview data...
	if preview_mode and preview_mode_ref != -1:
		var preview_data:Dictionary = ROOM_UTIL.return_data(preview_mode_ref)		
		var adjacent_rooms_refs:Array = ROOM_UTIL.find_refs_of_adjuacent_rooms(use_location)

		for ref in adjacent_rooms_refs:
			var adjacent_room_details:Dictionary = ROOM_UTIL.return_data(ref)
			var utility_props:Dictionary = adjacent_room_details.utility_props
			if !utility_props.is_empty():
				if utility_props.has("level"):
					preview_data.department_properties.level += utility_props.level
				if utility_props.has("metric"):
					preview_data.department_properties.metric.append( utility_props.metric )
				if utility_props.has("currency"):
					preview_data.department_properties.currency.append( utility_props.currency )
				if utility_props.has("effect"):
					preview_data.department_properties.effects.append( utility_props.effect )
							
		# shape for preview
		fill( preview_data, {}, true )
		return
	
	# no room, hide and end...
	if room_details.is_empty():
		hide()
		return
	
	# hide card, show modules only
	if hide_card:		
		show()
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
		return
	
	# override and add department properties to room_details
	room_details.department_properties = room_level_config.department_properties
	
	# else fill data
	fill(room_details, scp_details, false)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func fill(room_details:Dictionary, scp_details:Dictionary = {}, is_preview:bool = false) -> void:
	var is_under_construction:bool = false if is_preview else ROOM_UTIL.is_under_construction(use_location) 
	var is_activated:bool = true if is_preview else ROOM_UTIL.is_room_activated(use_location)
	var can_contain:bool = ROOM_UTIL.room_can_contain(use_location)

	# assign details
	show()
	SidePanel.show()
	InfoContainer.show()

	# basics
	NameTag.text = room_details.name 
	QuoteLabel.text = '"%s"' % room_details.quote
	
	# fill image
	ImageTextureRect.texture = CACHE.fetch_image(room_details.img_src) 
	
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
	
	# add department properties
	if !room_details.department_properties.is_empty():
		RoomImpact.show()
		# add operator string		
		var department_properties:Dictionary = room_details.department_properties
		var has_no_production:bool = department_properties.metric.is_empty() and department_properties.currency.is_empty()
		var operator_string:String
		
		if !has_no_production:
			match department_properties.operator:
				ROOM.OPERATOR.ADD:
					operator_string = "[color='GREEN']%s[/color]" % ["PRODUCES"]
				ROOM.OPERATOR.SUBTRACT:
					operator_string = "[color='RED']%s[/color]" % ["EXPENDS"]
		
		# adds metrics
		var resource_string:String = "[color='ORANGE']"
		if !department_properties.metric.is_empty():
			for ref in department_properties.metric:
				var metric_details:Dictionary = RESOURCE_UTIL.return_metric(ref)
				resource_string += "%s / " % [metric_details.name]
			resource_string = resource_string.left(resource_string.length() - 3)
		resource_string += "[/color]"
		
		# add currency
		if !department_properties.currency.is_empty():
			if !department_properties.metric.is_empty():
				resource_string += " and "
			
			resource_string += "[color='PURPLE']"
			for ref in department_properties.currency:
				var currency_details:Dictionary = RESOURCE_UTIL.return_currency(ref)
				resource_string += "%s / " % [currency_details.name]
			resource_string = resource_string.left(resource_string.length() - 3)
			resource_string += "[/color]"		
		
		# then add it all as one string
		RoomImpactLabel.text = "This facility has no output." if has_no_production else "[b]%s  %s  %s[/b] every day." % [operator_string, department_properties.level, resource_string] 
		LvlTag.text = "LVL %s" % [room_details.department_properties.level]

		# get effects
		if department_properties.effects.is_empty():
			RoomEffects.hide()
		else:
			RoomEffects.show()

			var final_string:String = ""
			for index in department_properties.effects.size():
				var effect_details:Dictionary = ROOM.return_effect(department_properties.effects[index])
				var new_rich_label:RichTextLabel = RichTextLabel.new()
				var applies:bool = true if is_preview else effect_details.applies.call(room_config, use_location) 
				final_string += "[color=%s][b]PASSIVE %s:[/b][/color] %s \n" % [('WHITE' if applies else 'SLATE_GRAY') if !is_preview else "WHITE", "" if applies else "(INACTIVE)", effect_details.description.call(department_properties.operator)]				
				if index != department_properties.effects.size() - 1:
					final_string += "\n"
			RoomEffectLabel.text = final_string
	else:
		LvlTag.text = ""
		RoomEffects.hide()
		RoomImpact.hide()			
#
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
	pass
	#for node in [ModuleComponent, ProgramComponent, ContainmentComponent]:
		#for btn in node.get_btns():
			#btn.is_selected = false
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
	#CardBodySubviewport.size = CardControlBody.size
# ------------------------------------------------------------------------------
	
