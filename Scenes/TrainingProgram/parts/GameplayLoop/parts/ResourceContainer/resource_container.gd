extends GameContainer

@onready var HeaderContainer:PanelContainer = $PanelContainer
@onready var MarginControl:MarginContainer = $PanelContainer/MarginControl

@onready var LocationFloor:VBoxContainer = $PanelContainer/MarginControl/VBoxContainer2/Location/Floor
@onready var LocationWing:VBoxContainer = $PanelContainer/MarginControl/VBoxContainer2/Location/Wing
@onready var LocationRoom:VBoxContainer = $PanelContainer/MarginControl/VBoxContainer2/Location/Room

@onready var LocationFloorLabel:Label = $PanelContainer/MarginControl/VBoxContainer2/Location/Floor/CenterLabel2
@onready var LocationWingLabel:Label = $PanelContainer/MarginControl/VBoxContainer2/Location/Wing/CenterLabel2
@onready var LocationRoomLabel:Label = $PanelContainer/MarginControl/VBoxContainer2/Location/Room/CenterLabel2

@onready var FloorLabelContainer:HBoxContainer = $PanelContainer/MarginControl/VBoxContainer2/VBoxContainer/FloorLabelContainer
@onready var RingLabelContainer:HBoxContainer = $PanelContainer/MarginControl/VBoxContainer2/VBoxContainer/RingLabelContainer
@onready var RoomLabelContainer:HBoxContainer = $PanelContainer/MarginControl/VBoxContainer2/VBoxContainer/RoomLabelContainer

@onready var CurrencyMoney:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/HBoxContainer/Money
@onready var CurrencyMaterials:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/HBoxContainer/Materials
@onready var CurrencyResearch:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/HBoxContainer/Research
@onready var CurrencyCore:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/HBoxContainer/Core

@onready var CurrenyTag:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/CurrencyTag
@onready var MaterialTag:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/MaterialTag
@onready var ScienceTag:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/ScienceTag
@onready var CoreTag:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/CoreTag

@onready var VibesContainer:PanelContainer = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Vibes
@onready var VibeMorale:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Vibes/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VibeMorale
@onready var VibeSafety:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Vibes/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VibeSafety
@onready var VibeReadiness:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Vibes/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VibeReadiness

@onready var MoraleTag:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Vibes/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/MoraleTag
@onready var SafetyTag:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Vibes/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/SafetyTag
@onready var ReadinessTag:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Left/Vibes/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/ReadinessTag

@onready var EnergyContainer:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Right/Energy
@onready var Energy:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Right/Energy/MarginContainer/VBoxContainer/HBoxContainer/EnergyItem
@onready var EnergyTag:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Right/Energy/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/EnergyTag

@onready var Personnel:Container = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Right/Personnel
@onready var PersonnelStaff:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/HBoxContainer/Staff
@onready var PersonnelTechnicians:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/HBoxContainer/Technicians
@onready var PersonnelSecurity:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/HBoxContainer/Security
@onready var PersonnelDClass:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/HBoxContainer/DClass

@onready var StaffTag:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/StaffTag
@onready var TechTag:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/TechTag
@onready var SecTag:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/SecTag
@onready var DClassTag:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Right/Personnel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/DClassTag

# this button does not need to be linked; the listener is on the root level
@onready var TaskbarBtn:Control = $PanelContainer/MarginControl/VBoxContainer/HBoxContainer/Right/TaskbarBtn

# buff or debuff
const BuffOrDebuffTag:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResourceContainer/parts/BuffOrDebuffTag/BuffOrDebuffTag.tscn")
const LabelSettingsPreload:LabelSettings = preload("res://Scenes/TrainingProgram/parts/Cards/RoomMiniCard/SmallContentFont.tres")


var previous_location:Dictionary = {}

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.GAMEPLAY_HEADER, self)

func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.GAMEPLAY_HEADER)

func _ready() -> void:
	super._ready()
	
	GBL.direct_ref["MetricsContainer"] = VibesContainer
	GBL.direct_ref["LocationPanel"] = LocationFloor
	GBL.direct_ref["PersonnelPanel"] = Personnel
	GBL.direct_ref["EnergyPanel"] = EnergyContainer
	#
	GBL.direct_ref["CorePanel"] = CurrencyCore
	GBL.direct_ref["MaterialPanel"] = CurrencyMaterials
	GBL.direct_ref["SciencePanel"] = CurrencyResearch
	GBL.direct_ref["MoneyPanel"] = CurrencyMoney
	#
	GBL.direct_ref["MoralePanel"] = VibeMorale
	GBL.direct_ref["SafetyPanel"] = VibeSafety
	GBL.direct_ref["ReadinessPanel"] = VibeReadiness
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()
	
	control_pos_default[HeaderContainer] = HeaderContainer.position

	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func get_hint_buttons() -> Array:
	var btns:Array =  [CurrencyMoney, CurrencyMaterials, CurrencyResearch, CurrencyCore, VibeMorale, VibeSafety, VibeReadiness, Energy, PersonnelStaff, PersonnelTechnicians, PersonnelSecurity, PersonnelDClass]
	for node in [FloorLabelContainer, RingLabelContainer, RoomLabelContainer]:
		for child in node.get_children():
			btns.push_back(child)
	return btns
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos() -> void:	
	await U.tick()
	var h_diff:int = (1080 - 720) # difference between 1080 and 720 resolution - gives you 360
	var y_diff =  (0 if !GBL.is_fullscreen else h_diff) if !initalized_at_fullscreen else (0 if GBL.is_fullscreen else -h_diff)
	
	# for eelements in the top right
	control_pos[HeaderContainer] = {
		"show": control_pos_default[HeaderContainer].y, 
		"hide": control_pos_default[HeaderContainer].y - MarginControl.size.y
	}		
	
	on_is_showing_update(true)
# --------------------------------------------------------------------------------------------------	

# -----------------------------------------------
func on_is_showing_update(skip_animation:bool = false) -> void:	
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty():return
	U.tween_node_property(HeaderContainer, "position:y", control_pos[HeaderContainer].show if is_showing else control_pos[HeaderContainer].hide, 0 if skip_animation else 0.3)
# -----------------------------------------------	

# -----------------------------------------------	
func on_current_location_update(new_val:Dictionary) -> void:
	super.on_current_location_update(new_val)
	U.debounce(str(self.name, "_update_energy_panel"), update_panels)
# -----------------------------------------------			

# -----------------------------------------------			
func on_room_config_update(new_val:Dictionary) -> void:
	super.on_room_config_update(new_val)	
	U.debounce(str(self.name, "_update_energy_panel"), update_panels)
# -----------------------------------------------			

# ----------------------------------------------			
func on_camera_settings_update(new_val:Dictionary) -> void: 
	super.on_camera_settings_update(new_val)	
	U.debounce(str(self.name, "_update_energy_panel"), update_panels)
# -----------------------------------------------			

# -----------------------------------------------
func update_vibes(morale_val:int, safety_val:int, readiness_val:int) -> void:
	VibeMorale.value = morale_val
	VibeSafety.value = safety_val
	VibeReadiness.value = readiness_val


func update_status_container(status_list:Array, container:Control) -> void:
	# status
	for node in container.get_children():
		node.queue_free()
	
	for item in status_list:
		var new_node:Control = BuffOrDebuffTag.instantiate()
		container.add_child(new_node)	
		new_node.title = item.title
		new_node.duration = item.duration
		new_node.hint_description = item.hint_description
		new_node.type = item.type
# -----------------------------------------------


# -----------------------------------------------
func update_panels() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty() or camera_settings.is_empty():return
	
	var floor_config_data:Dictionary = room_config.floor[current_location.floor]
	var ring_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]	
	var room_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].room[current_location.room]	
	
	# update location label
	LocationFloorLabel.text = str(current_location.floor)
	LocationWingLabel.text = str(current_location.ring)
	LocationRoomLabel.text = str(current_location.room)
		
	# currency
	CurrencyMoney.title = "%s" % [resources_data[RESOURCE.CURRENCY.MONEY].amount]
	CurrencyMaterials.title = "%s" % [resources_data[RESOURCE.CURRENCY.MATERIAL].amount]
	CurrencyResearch.title = "%s" %  [resources_data[RESOURCE.CURRENCY.SCIENCE].amount]
	CurrencyCore.title = "%s" %  [resources_data[RESOURCE.CURRENCY.CORE].amount]
	
	# vibes
	VibesContainer.hide() if camera_settings.is_locked and camera_settings.type == CAMERA.TYPE.FLOOR_SELECT else VibesContainer.show()
	var floor_level_metrics:Dictionary = floor_config_data.metrics	
	var ring_level_metrics:Dictionary = ring_config_data.metrics
	var total_metrics:Dictionary = {}
	for dict in [floor_level_metrics, ring_level_metrics]:
		for ref in dict:
			if ref not in total_metrics:
				total_metrics[ref] = 0
			total_metrics[ref] += dict[ref]	
	update_vibes(total_metrics[RESOURCE.METRICS.MORALE], total_metrics[RESOURCE.METRICS.SAFETY], total_metrics[RESOURCE.METRICS.READINESS])
	
	# update buffs/debuffs/status
	for node in [FloorLabelContainer, RingLabelContainer, RoomLabelContainer]:
		for child in node.get_children():
			child.queue_free()				
	
	# floor status
	var status_list:Array = [
		{
			"title": "POWERED" if floor_config_data.is_powered else "NO POWER", 
			"duration": -1,
			"hint_description": "Wing is being supplied power." if floor_config_data.is_powered else "Wing has no power.",
			"type": BASE.TYPE.BUFF
		}
	]	
	
	# get buffs
	for buff in floor_config_data.buffs:
		status_list.push_back({
			"title": buff.data.name,
			"duration": buff.duration,
			"hint_description": buff.data.description,
			"type": BASE.TYPE.BUFF
		})
	
	for debuff in floor_config_data.debuffs:
		status_list.push_back({
			"title": debuff.data.name,
			"duration": debuff.duration,
			"hint_description": debuff.data.description,
			"type": BASE.TYPE.DEBUFF
		})
		
	update_status_container(status_list, FloorLabelContainer)	
	
			
	# energy
	EnergyContainer.hide() if camera_settings.is_locked and camera_settings.type == CAMERA.TYPE.FLOOR_SELECT else EnergyContainer.show()	
	Energy.title = "%s/%s" % [ring_config_data.energy.available - ring_config_data.energy.used, ring_config_data.energy.available]

	## personnel
	Personnel.hide() if camera_settings.is_locked and camera_settings.type == CAMERA.TYPE.FLOOR_SELECT else Personnel.show()	
	PersonnelStaff.is_negative = !ring_config_data.personnel[RESOURCE.PERSONNEL.STAFF]
	PersonnelTechnicians.is_negative = !ring_config_data.personnel[RESOURCE.PERSONNEL.TECHNICIANS]
	PersonnelSecurity.is_negative = !ring_config_data.personnel[RESOURCE.PERSONNEL.SECURITY]
	PersonnelDClass.is_negative = !ring_config_data.personnel[RESOURCE.PERSONNEL.DCLASS]	

	# update everything else
	match camera_settings.type:
		# -----------------------
		CAMERA.TYPE.FLOOR_SELECT:
			var summary_data:Dictionary = GAME_UTIL.get_floor_summary(current_location) if camera_settings.is_locked else GAME_UTIL.get_ring_summary(current_location)

			CurrenyTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.MONEY] 
			MaterialTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.MATERIAL] 
			ScienceTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.SCIENCE] 
			CoreTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.CORE]

			for node in [LocationFloor, LocationWing, LocationRoom, MoraleTag, SafetyTag, ReadinessTag, EnergyTag, StaffTag, TechTag, SecTag, DClassTag]:
				if node in [LocationFloor]:
					node.show()  
				else:
					node.hide()
		# -----------------------
		CAMERA.TYPE.WING_SELECT:
			var summary_data:Dictionary = GAME_UTIL.get_ring_summary(current_location)	

			# get status effects
			for cf in [{"config": ring_config_data, "container": RingLabelContainer}]:
				var list:Array = []	
				for buff in cf.config.buffs:
					list.push_back({
						"title": buff.data.name,
						"duration": buff.duration,
						"hint_description": buff.data.description,
						"type": BASE.TYPE.BUFF
					})
				
				for debuff in cf.config.debuffs:
					list.push_back({
						"title": debuff.data.name,
						"duration": debuff.duration,
						"hint_description": debuff.data.description,
						"type": BASE.TYPE.DEBUFF	
					})
				
				update_status_container(list, cf.container)

			CurrenyTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.MONEY] 
			MaterialTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.MATERIAL] 
			ScienceTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.SCIENCE] 
			CoreTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.CORE]
						
			for node in [LocationFloor, LocationWing, LocationRoom, MoraleTag, SafetyTag, ReadinessTag, EnergyTag, StaffTag, TechTag, SecTag, DClassTag]:
				if node in [LocationFloor, LocationWing]:
					node.show() 
				else:
					node.hide()
		# -----------------------
		CAMERA.TYPE.ROOM_SELECT:
			var summary_data:Dictionary = GAME_UTIL.get_room_summary(current_location)	
		
			
			# get status effects
			for cf in [
				{"config": ring_config_data, "container": RingLabelContainer},
				{"config": ring_config_data, "container": RoomLabelContainer}
			]:
				var list:Array = []	
				for buff in cf.config.buffs:
					list.push_back({
						"title": buff.data.name,
						"duration": buff.duration,
						"hint_description": buff.data.description,
						"type": BASE.TYPE.BUFF
					})
				
				for debuff in cf.config.debuffs:
					list.push_back({
						"title": debuff.data.name,
						"duration": debuff.duration,
						"hint_description": debuff.data.description,
						"type": BASE.TYPE.DEBUFF	
					})
				
				update_status_container(list, cf.container)			
			
			
			#currency diff
			CurrenyTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.MONEY] 
			MaterialTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.MATERIAL] 
			ScienceTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.SCIENCE] 
			CoreTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.CORE]

			# update vibes
			MoraleTag.val = summary_data.metric_diff[RESOURCE.METRICS.MORALE]
			SafetyTag.val = summary_data.metric_diff[RESOURCE.METRICS.SAFETY]
			ReadinessTag.val = summary_data.metric_diff[RESOURCE.METRICS.READINESS]
			#update_vibes(summary_data.metric_diff[RESOURCE.METRICS.MORALE], summary_data.metric_diff[RESOURCE.METRICS.SAFETY], summary_data.metric_diff[RESOURCE.METRICS.READINESS])

			EnergyTag.val = str(-summary_data.energy_diff)			
			StaffTag.val = str(summary_data.personnel_diff[RESOURCE.PERSONNEL.STAFF])
			TechTag.val = str(summary_data.personnel_diff[RESOURCE.PERSONNEL.TECHNICIANS])
			SecTag.val = str(summary_data.personnel_diff[RESOURCE.PERSONNEL.SECURITY])	
			DClassTag.val = str(summary_data.personnel_diff[RESOURCE.PERSONNEL.DCLASS])	

			for node in [LocationFloor, LocationWing, LocationRoom, MoraleTag, SafetyTag, ReadinessTag, EnergyTag, StaffTag, TechTag, SecTag, DClassTag]:
				node.show()

# -----------------------------------------------
