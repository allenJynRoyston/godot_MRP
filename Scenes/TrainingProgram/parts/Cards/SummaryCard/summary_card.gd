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

# staffing / activation
@onready var RequiredStaffingContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/RequiredStaffingContainer
@onready var RequiredStaffPanel:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/RequiredStaffingContainer/PanelContainer2/MarginContainer/RequiredStaffPanel

# economy
@onready var EconomyContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/EconContainer
@onready var EconomyPanel:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/EconContainer/PanelContainer2/MarginContainer/EconomyPanel

# vibes
@onready var VibeContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/VibeContainer
@onready var VibePanel:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/VibeContainer/PanelContainer2/VibePanel

# effect
@onready var EffectContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/EffectContainer
@onready var EffectLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/EffectContainer/PanelContainer2/MarginContainer/EffectLabel

# influence
@onready var InfluenceContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/InfluenceContainer
@onready var InfluenceLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/InfluenceContainer/PanelContainer2/MarginContainer/InfluenceLabel

# Description 
@onready var DescriptionLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/Description/PanelContainer/MarginContainer/DescriptionLabel

# priority
@onready var DepartmentPriorityContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/DepartmentPriorityContainer
@onready var DepartmentPriorityLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/DepartmentPriorityContainer/PanelContainer2/MarginContainer/DepartmentPriorityLabel

# has programs
@onready var HasProgramsContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/HasProgramsContainer
@onready var HasProgramLabel:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/HasProgramsContainer/PanelContainer2/MarginContainer/HasProgramLabel

# capacity
@onready var CapacityContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/CapacityContainer
@onready var CapacityPanel:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/CapacityContainer/PanelContainer2/MarginContainer/CapacityPanel

# containment type
@onready var ContainmentTypeContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ContainmentTypeContainer
@onready var ContainmentTypeLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ContainmentTypeContainer/PanelContainer2/MarginContainer/ContainmentTypeLabel

# scpcontainer
@onready var ScpContainer:HBoxContainer = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/SCPContainer
@onready var ScpNameLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/SCPContainer/PanelContainer2/MarginContainer/VBoxContainer/ScpNameLabel

@onready var ScpEffectContainer:HBoxContainer = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/SCPEffectContainer
@onready var ScpEffectLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/SCPEffectContainer/PanelContainer2/MarginContainer/VBoxContainer/ScpEffectLabel

@onready var ScpInfluenceContainer:HBoxContainer = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/SCPInfluenceContainer
@onready var ScpInfluenceLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/SCPInfluenceContainer/PanelContainer2/MarginContainer/VBoxContainer/ScpInfluenceLabel

# modules
@onready var ModuleContainer:VBoxContainer = $MarginContainer/VBoxContainer/ModuleContainer
@onready var ModuleComponent:PanelContainer = $MarginContainer/VBoxContainer/ModuleContainer/ModuleComponent

# programs
@onready var ProgramContainer:VBoxContainer = $MarginContainer/VBoxContainer/ProgramContainer
@onready var ProgramComponent:PanelContainer = $MarginContainer/VBoxContainer/ProgramContainer/ProgramComponent

# containment
@onready var ContainmentContainer:VBoxContainer = $MarginContainer/VBoxContainer/ContainmentContainer
@onready var ContainmentComponent:PanelContainer = $MarginContainer/VBoxContainer/ContainmentContainer/ContainmentComponent

@onready var node_list:Array = [StatusOverlay, ModuleContainer, ProgramContainer, ScpContainer, ScpEffectContainer, ScpInfluenceContainer, ContainmentContainer]

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
	SUBSCRIBE.subscribe_to_base_states(self)
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)
	
	
func _ready() -> void:
	on_modules_only_update()
	on_preview_mode_update()
	on_preview_mode_ref_update()
	for node in [VibePanel, EconomyPanel, CapacityPanel]:
		node.hollow = true
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

func on_base_states_update(new_val:Dictionary) -> void:
	base_states = new_val
	U.debounce(str(self, "_on_update"), on_update)	

func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	hired_lead_researchers = new_val
	U.debounce(str(self, "_on_update"), on_update)
# ------------------------------------------------------------------------------

# -----------------------------------------------bb-------------------------------	
func on_update() -> void:
	if !is_node_ready() or room_config.is_empty() or base_states.is_empty() or use_location.is_empty():return
	if preview_mode and preview_mode_ref != -1:
		# hide all nodes
		for node in node_list:
			node.hide()

		var preview_data:Dictionary = {}
		var room_level_config:Dictionary = GAME_UTIL.get_room_level_config()
		var room_details:Dictionary = ROOM_UTIL.return_data(preview_mode_ref)
		var influenced_data:Dictionary = ROOM_UTIL.get_influenced_data()
		
		# get baseline of currency list
		var currency_list:Dictionary = {}
		for ref in [RESOURCE.CURRENCY.MONEY, RESOURCE.CURRENCY.SCIENCE, RESOURCE.CURRENCY.MATERIAL, RESOURCE.CURRENCY.CORE]:
			var resource_details:Dictionary = RESOURCE_UTIL.return_currency(ref)
			currency_list[ref] = {
				"icon": resource_details.icon, 
				# ... then get all currency from room
				"amount": room_details.currencies[ref] if room_details.currencies.has("ref") else 0,
				# ... add bonuses from influenced state
				"bonus_amount": influenced_data.currency_list[ref] if influenced_data.currency_list.has("ref") else 0
			}		
			

		# get baseline for metrics
		var metrics:Dictionary = {}
		for ref in [RESOURCE.METRICS.MORALE, RESOURCE.METRICS.SAFETY, RESOURCE.METRICS.READINESS]:
			var metric_data:Dictionary = RESOURCE_UTIL.return_metric(ref)
			metrics[ref] = {
				"metric_data": metric_data,
				"amount": 0, 
				"bonus_amount": 0
			}
			
		# ...then get all metrics from room/scp
		for dict in [room_details]:
			if "metrics" in dict:
				for ref in dict.metrics:
					var amount:int = dict.metrics[ref]
					metrics[ref].amount += amount		
		
		# shape for preview
		preview_data.details = ROOM_UTIL.return_data(preview_mode_ref)
		fill( ROOM_UTIL.return_data(preview_mode_ref), {}, true )
		show()		
		return
	
	#var extract_room_data:Dictionary = GAME_UTIL.extract_room_details()
	var is_room_empty:bool = ROOM_UTIL.is_room_empty()
	var is_scp_empty:bool = ROOM_UTIL.is_scp_empty()
	var room_details:Dictionary = ROOM_UTIL.return_data_via_location(use_location)
	var scp_details:Dictionary = ROOM_UTIL.return_scp_data_via_location(use_location)
	
	# no room
	if is_room_empty or room_details.is_empty():
		hide()
		return
	
	# hide all nodes
	CostPanel.hide()
	LvlTag.show()
	
	# fill image
	ImageTextureRect.texture = CACHE.fetch_image(room_details.img_src) 	
	for node in node_list:
		node.hide()
	
	# show
	show()
	
	if hide_card:
		SidePanel.hide()
		InfoContainer.hide()		
		ModuleComponent.room_details = {}
		
		# show containment
		ContainmentContainer.show() if room_details.can_contain else ContainmentContainer.hide()
		ContainmentComponent.use_location = use_location				
		ContainmentComponent.room_details = room_details
		
		
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
	
	fill(room_details, scp_details, false)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func fill(room_details:Dictionary, scp_details:Dictionary = {}, is_preview:bool = false) -> void:
	var currency_list:Dictionary = ROOM_UTIL.get_room_currency_list(use_location, is_preview)
	var metric_list:Dictionary = ROOM_UTIL.get_room_metric_list(use_location, is_preview)
	var is_room_empty:bool = ROOM_UTIL.is_room_empty(use_location)
	var is_under_construction:bool = false if is_preview else ROOM_UTIL.is_under_construction(use_location) 
	var is_activated:bool = true if is_preview else ROOM_UTIL.is_room_activated(use_location)
	var can_contain:bool = ROOM_UTIL.room_can_contain(use_location)
	var lvl:int = ROOM_UTIL.get_room_lvl(use_location)
	var max_upgrade_lvl:int = ROOM_UTIL.get_max_level( -1 if is_room_empty else room_details.ref ) 
	var at_max_level:bool = lvl >= max_upgrade_lvl
	var personnel_capacity:Dictionary = room_details.personnel_capacity	
	var required_staffing:Array = room_details.required_staffing
	
	# assign details
	SidePanel.show()
	InfoContainer.show()
	
	# basics
	NameTag.text = room_details.name #if scp_details.is_empty() else str(room_details.name, "\n(", scp_details.name, ")")
	LvlTag.text = "LVL %s" % [lvl if !at_max_level else "%s★" % lvl] if !is_preview else ""
	DescriptionLabel.text = '"%s"' % room_details.description
	
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

	# staffing
	var show_required_staffing:bool = required_staffing.size() > 0 
	RequiredStaffPanel.required_staffing = required_staffing
	RequiredStaffingContainer.show() if show_required_staffing else RequiredStaffingContainer.hide()
	
	# economy
	var show_economy:bool = false
	for ref in currency_list:
		var item:Dictionary = currency_list[ref] 
		if (item.amount + item.bonus_amount) != 0:
			show_economy = true
			break
	
	EconomyPanel.list = currency_list	
	EconomyContainer.show() if show_economy else EconomyContainer.hide()
	
	# vibe
	var show_metrics:bool = false
	for ref in metric_list:
		var item:Dictionary = metric_list[ref]
		if (item.amount + item.bonus_amount) != 0:
			show_metrics = true
			break

	VibePanel.metrics = metric_list
	VibeContainer.show() if show_metrics else VibeContainer.hide()
	
	# capacity
	var show_capacity:bool = false
	for key in personnel_capacity:
		if personnel_capacity[key] != 0:
			show_capacity = true
			break		
	CapacityPanel.personnel_capacity = personnel_capacity
	CapacityContainer.show() if show_capacity else CapacityContainer.hide()
	
	# program preview
	var program_list_as_string:String = ""
	var program_list: Array = room_details.abilities.call()
	program_list_as_string = "\n".join(program_list.map(func(i): return i.name))
	HasProgramLabel.text = program_list_as_string
	HasProgramsContainer.hide() #if room_details.abilities.call().is_empty() else HasProgramsContainer.show()
	#TODO : ADD A "BENEFITS FROM "ADMIN", "LOGISTICS", if the room can has a module/program

	# priority
	print("base_states.base.department_perk: ", base_states.base.department_perk)
	print("room_details.ref: ", room_details.ref)
	DepartmentPriorityContainer.show() if base_states.base.department_perk.has(room_details.ref) else DepartmentPriorityContainer.hide()
	if base_states.base.department_perk.has(room_details.ref) and base_states.base.department_perk[room_details.ref] == -1:
		DepartmentPriorityLabel.text = "No priority selected"
	else:
		DepartmentPriorityLabel.text = CONDITIONALS.return_data(room_details.ref).description
		
	# effect
	EffectLabel.text = room_details.effect.description if !room_details.effect.is_empty() else ""
	EffectContainer.show() if !room_details.effect.is_empty() else EffectContainer.hide()
	
	# influence 
	InfluenceContainer.show() if !room_details.influence.is_empty() else InfluenceContainer.hide()
	InfluenceLabel.text = room_details.influence.effect.description.call() if !room_details.influence.is_empty() else ""
	
	# type 
	ContainmentTypeLabel.text= SCP_UTIL.get_containment_type_str(room_details.containment_properties) if !room_details.is_empty() else ""
	ContainmentTypeContainer.show() if !room_details.containment_properties.is_empty() else ContainmentTypeContainer.hide()
	
	# scp
	ScpContainer.show() if !scp_details.is_empty() else ScpContainer.hide()
	ScpNameLabel.text = scp_details.name if !scp_details.is_empty() else ""
	
	# scp effect	
	ScpEffectContainer.show() if !scp_details.is_empty() and !scp_details.effect.is_empty() else ScpEffectContainer.hide()
	ScpEffectLabel.text = scp_details.effect.description if !scp_details.is_empty() and scp_details.effect.has("description") else ""
	
	# scp influence
	ScpInfluenceContainer.show() if !scp_details.is_empty() and !scp_details.influence.is_empty() else ScpInfluenceContainer.hide()
	ScpInfluenceLabel.text = scp_details.influence.effect.description.call() if !scp_details.is_empty() and !scp_details.influence.effect.is_empty() else ""
	
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
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_program_btns() -> Array:
	var btn_list:Array = []
	
	for node in [ProgramComponent]:
		if node.is_visible_in_tree():
			for btn in node.get_btns():
				btn_list.push_back(btn)
	#
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
	
