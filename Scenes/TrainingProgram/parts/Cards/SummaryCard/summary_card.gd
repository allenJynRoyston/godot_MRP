extends PanelContainer

# INFOCONTAINER
@onready var CardMargin:MarginContainer = $MarginContainer
@onready var InfoContainer:PanelContainer = $MarginContainer/VBoxContainer/InfoContainer
@onready var ImageTextureRect:TextureRect = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect
@onready var NameTag:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/NamePanel/MarginContainer/HBoxContainer/NameTag
@onready var LvlTag:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/NamePanel/MarginContainer/HBoxContainer/LvlTag
@onready var ConstructionCostTag:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/HBoxContainer/ConstructionCostPanel/MarginContainer/HBoxContainer/ConstructionLabel

# cost
@onready var ConstructionCostPanel:PanelContainer = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/HBoxContainer/ConstructionCostPanel
@onready var TempIcon:Control = $Control/SidePanel/TempPanel/MarginContainer/HBoxContainer/TempIcon
@onready var TempLabel:Label = $Control/SidePanel/TempPanel/MarginContainer/HBoxContainer/TempLabel
@onready var PollutionLabel:Label = $Control/SidePanel/PollutionPanel/MarginContainer/HBoxContainer/PollutionLabel
@onready var EnergyCostLabel:Label = $Control/SidePanel/LevelAndEnergyPanel/MarginContainer/HBoxContainer/EnergyCostLabel
@onready var SidePanel:VBoxContainer = $Control/SidePanel

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
@onready var DescriptionLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/Description/PanelContainer2/MarginContainer/DescriptionLabel

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
@onready var ScpContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/SCPContainer
@onready var ScpImage:TextureRect = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/ScpImage
@onready var ScpTitleLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/SCPContainer/PanelContainer2/MarginContainer/VBoxContainer/ScpTitleLabel
@onready var ScpEffectLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/SCPContainer/PanelContainer2/MarginContainer/VBoxContainer/ScpEffectLabel


# modules
@onready var ModuleContainer:VBoxContainer = $MarginContainer/VBoxContainer/ModuleContainer
@onready var ModuleComponent:PanelContainer = $MarginContainer/VBoxContainer/ModuleContainer/ModuleComponent

# programs
@onready var ProgramContainer:VBoxContainer = $MarginContainer/VBoxContainer/ProgramContainer
@onready var ProgramComponent:PanelContainer = $MarginContainer/VBoxContainer/ProgramContainer/ProgramComponent

# containment
@onready var ContainmentContainer:VBoxContainer = $MarginContainer/VBoxContainer/ContainmentContainer
@onready var ContainmentComponent:PanelContainer = $MarginContainer/VBoxContainer/ContainmentContainer/ContainmentComponent

@onready var node_list:Array = [StatusOverlay, ModuleContainer, ProgramContainer, ScpContainer, ContainmentContainer]

@export var modules_only:bool = false 

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

# ------------------------------------------------------------------------------	
func on_update() -> void:
	if !is_node_ready() or room_config.is_empty() or base_states.is_empty():return
	if preview_mode and preview_mode_ref != -1:
		ConstructionCostPanel.show()
		LvlTag.hide()
		
		# hide all nodes
		for node in node_list:
			node.hide()
		InfoContainer.show()
		var preview_data:Dictionary = {}
		var room_details:Dictionary = ROOM_UTIL.return_data(preview_mode_ref)
		
		# get baseline of currency list
		var currency_list:Dictionary = {}
		for ref in [RESOURCE.CURRENCY.MONEY, RESOURCE.CURRENCY.SCIENCE, RESOURCE.CURRENCY.MATERIAL, RESOURCE.CURRENCY.CORE]:
			var resource_details:Dictionary = RESOURCE_UTIL.return_currency(ref)
			currency_list[ref] = {
				"icon": resource_details.icon, 
				"amount": 0,
				"bonus_amount": 0
			}		
			
		# ... then get all currency from room
		for ref in room_details.currencies:
			var amount:int = room_details.currencies[ref]
			currency_list[ref].amount += amount

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
		preview_data.currency_list = currency_list
		preview_data.metrics = metrics
		preview_data.is_under_construction = false
		preview_data.is_activated = true
		preview_data.abl_lvl = 0
		preview_data.max_upgrade_lvl = 0

		fill(preview_data)
		show()		
		return
	
	
	if use_location.is_empty():return
	var extract_room_data:Dictionary = GAME_UTIL.extract_room_details()
	var room_details:Dictionary = extract_room_data.room
	var scp_details:Dictionary = extract_room_data.scp
	
	# no room
	if extract_room_data.room.is_empty():
		hide()
		return
	
	# hide all nodes
	ConstructionCostPanel.hide()
	LvlTag.show()
	for node in node_list:
		node.hide()
	
	
	# show
	show()
	
	if modules_only:
		SidePanel.hide()
		InfoContainer.hide()
		ModuleComponent.room_details = {}
		
		# show containment
		ContainmentContainer.show() if room_details.details.can_contain else ContainmentContainer.hide()
		ContainmentComponent.use_location = use_location				
		ContainmentComponent.room_details = room_details.details
		
		# passives
		if room_details.details.passive_abilities.call().is_empty():
			ModuleContainer.hide()
			ModuleComponent.room_details = {}
		else:
			ModuleContainer.show()
			ModuleComponent.use_location = use_location		
			ModuleComponent.room_details = room_details.details
		
		# assign programs
		if room_details.details.abilities.call().is_empty():
			ProgramContainer.hide()
			ProgramComponent.room_details = {}
		else:
			ProgramContainer.show()
			ProgramComponent.use_location = use_location			
			ProgramComponent.room_details = room_details.details	
		return

	fill(room_details, scp_details)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func fill(room_details:Dictionary, scp_details:Dictionary = {}) -> void:
	var metrics:Dictionary = room_details.metrics
	var currency_list:Dictionary = room_details.currency_list	
	var is_under_construction:bool = room_details.is_under_construction
	var is_activated:bool = room_details.is_activated	
	var lvl:int = room_details.abl_lvl 
	var max_upgrade_lvl:int = room_details.max_upgrade_lvl 
	var at_max_level:bool = lvl >= max_upgrade_lvl
	var can_contain:bool = room_details.details.can_contain		
	var personnel_capacity:Dictionary = room_details.details.personnel_capacity	
	var required_staffing:Array = room_details.details.required_staffing
	var room_config_level:Dictionary = GAME_UTIL.get_room_level_config(use_location)
	var room_level_currencies:Dictionary = room_config_level.currencies
	
	# added bonus levels to currencies
	for key in currency_list:
		currency_list[key].amount = currency_list[key].amount + room_level_currencies[key]
	
	
	# assign details
	SidePanel.show()
	InfoContainer.show()
	NameTag.text = room_details.details.name if scp_details.is_empty() else str(room_details.details.name, "\n(", scp_details.details.name, ")")
	LvlTag.text = "LVL %s" % [lvl if !at_max_level else "★"]
	DescriptionLabel.text = room_details.details.description
	EnergyCostLabel.text = str(room_details.details.required_energy)
	ConstructionCostTag.text = str(room_details.details.costs.purchase)
	ImageTextureRect.texture = CACHE.fetch_image(room_details.details.img_src) 

	# staffing
	var show_required_staffing:bool = required_staffing.size() > 0 
	RequiredStaffPanel.required_staffing = required_staffing
	RequiredStaffingContainer.show() if show_required_staffing else RequiredStaffingContainer.hide()
	#
	# economy
	var show_economy:bool = false
	for ref in currency_list:
		var item:Dictionary = currency_list[ref] 
		if (item.amount + item.bonus_amount) != 0:
			show_economy = true
			break
	
	#EconomyPanel.use_location = use_location	
	EconomyPanel.list = room_details.currency_list	
	EconomyContainer.show() if show_economy else EconomyContainer.hide()
	
		# vibe
	var show_metrics:bool = false
	for ref in metrics:
		var item:Dictionary = metrics[ref]
		if (item.amount + item.bonus_amount) != 0:
			show_metrics = true
			break
			
	VibePanel.metrics = metrics
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
	var program_list: Array = room_details.details.abilities.call()
	program_list_as_string = "\n".join(program_list.map(func(i): return i.name))
	HasProgramLabel.text = program_list_as_string
	HasProgramsContainer.hide() if room_details.details.abilities.call().is_empty() else HasProgramsContainer.show()

	# effect
	EffectLabel.text = room_details.details.effect.description if !room_details.details.effect.is_empty() else ""
	EffectContainer.show() if !room_details.details.effect.is_empty() else EffectContainer.hide()
	
	# influence 
	InfluenceContainer.show() if room_details.details.influence.effect != null else InfluenceContainer.hide()
	InfluenceLabel.text = room_details.details.influence.effect.description if room_details.details.influence.effect != null else ""
	
	# type 
	ContainmentTypeLabel.text= SCP_UTIL.get_containment_type_str(room_details.details.containment_properties) if !room_details.details.is_empty() else ""
	ContainmentTypeContainer.show() if !room_details.details.containment_properties.is_empty() else ContainmentTypeContainer.hide()
	
	# scp
	#ScpTitleLabel.text = "NOTHING" if scp_details.is_empty() else str(scp_details.details.name, "\n(", scp_details.details.nickname, ")")
	ScpImage.texture = null if scp_details.is_empty() else CACHE.fetch_image(scp_details.details.img_src)	
	ScpEffectLabel.text = "" if scp_details.is_empty() else "No effect." if scp_details.details.effect.is_empty() else scp_details.details.effect.description

	ScpImage.hide() if scp_details.is_empty() else ScpImage.show()
	ScpEffectLabel.hide() if scp_details.is_empty() else ScpEffectLabel.show()
	ScpContainer.show() if can_contain and !scp_details.is_empty() else ScpContainer.hide()
	
	# environmental
	PollutionLabel.text = str(room_details.details.environmental.pollution)
	TempLabel.text = str(room_details.details.environmental.temp)
	TempIcon.icon = SVGS.TYPE.LOW_TEMP if room_details.details.environmental.temp < 0 else SVGS.TYPE.HIGH_TEMP
	
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
func get_ability_btns() -> Array:
	var btn_list:Array = []
	
	for node in [ModuleComponent, ProgramComponent, ContainmentComponent]:
		if node.is_visible_in_tree():
			for btn in node.get_btns():
				btn_list.push_back(btn)
	#
	return btn_list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_starting_btn_index() -> int:
	var abilty_btns:Array = get_ability_btns()
	return 0
# ------------------------------------------------------------------------------
		
# ------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if !is_node_ready():return
	SidePanel.position.x = CardMargin.size.x - 5
	#CardBodySubviewport.size = CardControlBody.size
# ------------------------------------------------------------------------------
	
