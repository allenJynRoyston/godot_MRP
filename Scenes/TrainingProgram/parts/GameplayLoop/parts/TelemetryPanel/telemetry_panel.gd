extends SubscribeWrapper
enum TYPE {SECTOR_LEVEL, ROOM_LEVEL}

# roomLayer
@onready var RoomLayer:VBoxContainer = $VBoxContainer/RoomLayer
@onready var Stats:PanelContainer = $VBoxContainer/RoomLayer/Stats
@onready var Summary:PanelContainer = $VBoxContainer/RoomLayer/Summary
@onready var NameLabel:Label = $VBoxContainer/RoomLayer/Header/MarginContainer/HBoxContainer/NameLabel
@onready var StatusLabel:Label = $VBoxContainer/RoomLayer/Stats/MarginContainer/VBoxContainer2/Status/StatusLabel
@onready var DamageLabel:Label = $VBoxContainer/RoomLayer/Stats/MarginContainer/VBoxContainer2/Damage/DamageLabel
@onready var TempLabel:Label = $VBoxContainer/RoomLayer/Stats/MarginContainer/VBoxContainer2/Temp/TempLabel
@onready var PollutionLabel:Label = $VBoxContainer/RoomLayer/Stats/MarginContainer/VBoxContainer2/Pollution/PollutionLabel
@onready var SummaryLabel:RichTextLabel = $VBoxContainer/RoomLayer/Summary/MarginContainer/SummaryLabel

# sector
@onready var SectorLayer:VBoxContainer = $VBoxContainer/SectorLayer
@onready var Economy:PanelContainer = $VBoxContainer/SectorLayer/Stats/MarginContainer/VBoxContainer/Economy
@onready var Vibes:PanelContainer = $VBoxContainer/SectorLayer/Stats/MarginContainer/VBoxContainer/Vibes

@onready var Detected:Control = $Detected
@onready var DetectedPanel:PanelContainer = $Detected/DetectedPanel
@onready var DetectedHeader:PanelContainer = $Detected/DetectedPanel/VBoxContainer/Header

@onready var detected_header_stylebox:StyleBoxFlat = DetectedHeader.get("theme_override_styles/panel").duplicate()
@onready var stats_stylebox:StyleBoxFlat = Stats.get("theme_override_styles/panel").duplicate()
@onready var status_label_setting:LabelSettings = StatusLabel.get("label_settings").duplicate()
@onready var damage_label_setting:LabelSettings = DamageLabel.get("label_settings").duplicate()
@onready var temp_label_setting:LabelSettings = TempLabel.get("label_settings").duplicate()
@onready var pollution_label_setting:LabelSettings = PollutionLabel.get("label_settings").duplicate()


var modulate_tween:Tween
var position_tween:Tween
var is_active:bool = false
var has_event:bool = false
var type:TYPE = TYPE.ROOM_LEVEL

# ------------------------------------------
func _init() -> void:
	super._init()
	GBL.subscribe_to_control_input(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unsubscribe_to_control_input(self)	

func _ready() -> void:
	RoomLayer.hide()
	SectorLayer.hide()
		
	DetectedPanel.modulate.a = 0
	DetectedHeader.set("theme_override_styles/panel", detected_header_stylebox)
	Stats.set("theme_override_styles/panel", stats_stylebox)
	StatusLabel.set("label_settings", status_label_setting)
	TempLabel.set("label_settings", temp_label_setting)
	PollutionLabel.set("label_settings", pollution_label_setting)
	
func start() -> void:
	is_active = true
	update_node()
	
func end() -> void:
	RoomLayer.hide()
	SectorLayer.hide()
	DetectedPanel.modulate.a = 0
	is_active = false
# ------------------------------------------

# ------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val	
	U.debounce(str(self, "_update_node"), update_node)
	
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val	
	U.debounce(str(self, "_update_node"), update_node)

func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	U.debounce(str(self, "_update_node"), update_node)

func enable_room() -> void:
	type = TYPE.ROOM_LEVEL
	U.debounce(str(self, "_update_node"), update_node)

func enable_oversight() -> void:
	type = TYPE.SECTOR_LEVEL
	U.debounce(str(self, "_update_node"), update_node)

func update_node() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty() or !is_active:return
	# hide/show panels
	match type:
		TYPE.SECTOR_LEVEL:
			RoomLayer.hide()
			SectorLayer.show()
			update_sector_details()
		TYPE.ROOM_LEVEL:
			SectorLayer.hide()
			update_room_details()	

func update_sector_details() -> void:
	SectorLayer.show()
	var curreny_count:Dictionary = {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.CORE: 0
	}
	
	var metric_count:Dictionary = {
		RESOURCE.METRICS.MORALE: 0,
		RESOURCE.METRICS.SAFETY: 0,
		RESOURCE.METRICS.READINESS: 0,
	}
	
	for n in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
		var room_level_config:Dictionary = GAME_UTIL.get_room_level_config({"floor": current_location.floor, "ring": current_location.ring, "room": n})
		if room_level_config.is_activated and !room_level_config.department_props.is_empty():
			var department_props:Dictionary = room_level_config.department_props
			

			for ref in department_props.currency:
				curreny_count[ref] += (department_props.level + department_props.bonus)
			for ref in department_props.metric:
				metric_count[ref] += (department_props.level + department_props.bonus)
	
	#print( curreny_count[RESOURCE.CURRENCY.MONEY] )
	
	Economy.money_offset = curreny_count[RESOURCE.CURRENCY.MONEY]
	Economy.research_offset = curreny_count[RESOURCE.CURRENCY.SCIENCE]
	Economy.material_offset = curreny_count[RESOURCE.CURRENCY.MATERIAL]
	Economy.core_offset = curreny_count[RESOURCE.CURRENCY.CORE]
	
	Vibes.offset_morale = metric_count[RESOURCE.METRICS.MORALE]
	Vibes.offset_safety = metric_count[RESOURCE.METRICS.SAFETY]
	Vibes.offset_readiness =  metric_count[RESOURCE.METRICS.READINESS]

func update_room_details() -> void:
	var room_details:Dictionary = ROOM_UTIL.return_data_via_location(current_location)
	
	if room_details.is_empty():
		RoomLayer.hide()
		return
	RoomLayer.show()
	
	var scp_details:Dictionary = ROOM_UTIL.return_scp_data_via_location(current_location)
	var room_level_config:Dictionary = GAME_UTIL.get_room_level_config(current_location)		
	var ring_level_config:Dictionary = GAME_UTIL.get_ring_level_config(current_location)
	var room_pos:Vector2 = GBL.find_node(REFS.WING_RENDER).get_room_position(current_location.room) * GBL.game_resolution 
	var room_base_states:Dictionary = GAME_UTIL.get_room_base_state()		
	var is_room_empty:bool = ROOM_UTIL.is_room_empty()
	var is_activated:bool = ROOM_UTIL.is_room_activated()
	var is_under_construction:bool = ROOM_UTIL.is_under_construction()	
	var energy_used:int = room_level_config.energy_used	
	var damage_val:int = room_level_config.damage_val
	
	# set flag
	has_event = !room_base_states.events_pending.is_empty()
	
	# name label
	NameLabel.text = room_details.shortname
	
	# is activated
	StatusLabel.text = "Anamolly detected!" if has_event else "Under construction" if is_under_construction else ("Active" if is_activated else "Inactive")
	status_label_setting.font_color = COLORS.disabled_color if (is_under_construction or has_event) else (COLORS.primary_black if is_activated else COLORS.disabled_color)
	status_label_setting.outline_color = status_label_setting.font_color
	status_label_setting.outline_color.a = 0.2
	
	# temp	
	var temp_in_range:bool = ring_level_config.monitor.temp in room_details.temp_required	
	TempLabel.text = "No issues" if temp_in_range else ("Too hot!" if ring_level_config.monitor.temp > 0 else "Too cold!")
	temp_label_setting.font_color = Color.BLACK if temp_in_range else (Color.RED if ring_level_config.monitor.temp > 0 else Color.BLUE)
	
	# pollution	
	PollutionLabel.text = "No pollution" if room_details.pollution == 0 else "Generates pollution"
	pollution_label_setting.font_color = Color.BLACK if room_details.pollution == 0 else Color.RED
	
	# damage
	DamageLabel.text = "No damage" if damage_val == 0 else "Damaged!"
	damage_label_setting.font_color = Color.BLACK if damage_val == 0 else Color.RED
	
	# reset text
	var final_effect_string:String = ""
	
	# -------------- UTILITY PROPS
	if !room_level_config.is_empty() and !room_level_config.utility_props.is_empty():
		final_effect_string += U.build_utility_props_string(room_level_config.utility_props)
	
	# -------------- DEPARTMENT PROPS
	if !room_level_config.is_empty() and !room_level_config.department_props.is_empty():
		final_effect_string += U.build_department_prop_string(room_level_config.department_props, room_level_config.department_props.level, "at end of turn")
		# get effects
		if !room_level_config.department_props.effects.is_empty():
			if !final_effect_string.is_empty():
				final_effect_string += "\n\n"
			final_effect_string += U.build_department_effect_string(room_level_config.department_props, current_location, false)

	# final string 
	SummaryLabel.text = final_effect_string
		
	# animate 
	for tween in [modulate_tween, position_tween]:
		if tween != null and tween.is_running():
			tween.stop()
	
	# hide/show detected
	DetectedPanel.modulate.a = 0
	DetectedPanel.global_position = room_pos - Vector2(0, 120 if !is_room_empty else 80)
	
	# show/hide summary
	if SummaryLabel.text.is_empty():
		Summary.hide()
		stats_stylebox.corner_radius_bottom_left = 5
		stats_stylebox.corner_radius_bottom_right = 5
	else:
		Summary.show()
		stats_stylebox.corner_radius_bottom_left = 0
		stats_stylebox.corner_radius_bottom_right = 0

	if has_event:		
		U.debounce(str(self, "_show_warning"), show_warning, 0.3)
	
		
func show_warning() -> void:
	if !has_event:return
	modulate_tween = create_tween()
	position_tween = create_tween()
	
	custom_tween_node_property(modulate_tween, DetectedPanel, "modulate:a", 1, 0.3, 0, Tween.TRANS_SINE)
	custom_tween_node_property(position_tween, DetectedPanel, "position:y", DetectedPanel.position.y + 5, 0.3, 0, Tween.TRANS_SINE)
# --------------------------------------------------------------------------------------------------		

# ------------------------------------------
func custom_tween_node_property(tween:Tween, node:Node, prop:String, new_val, duration:float = 0.3, delay:float = 0, trans:int = Tween.TRANS_QUAD, ease:int = Tween.EASE_IN_OUT) -> void:
	tween.tween_property(node, prop, new_val, duration).set_trans(trans).set_ease(ease).set_delay(delay)
	await tween.finished
# ------------------------------------------

# ------------------------------------------
var flash_timer := 0.0
var flash_interval := 0.5 # seconds between color swaps
var flash_on := false
func _process(delta: float) -> void:
	flash_timer += delta
	if flash_timer > flash_interval:
		flash_timer -= flash_interval

	# Get a value that goes 0 → 1 → 0 smoothly over time
	var t = sin((flash_timer / flash_interval) * PI)

	# Interpolate between black and red
	detected_header_stylebox.bg_color = Color.BLACK.lerp(Color.RED, t)
# ------------------------------------------
