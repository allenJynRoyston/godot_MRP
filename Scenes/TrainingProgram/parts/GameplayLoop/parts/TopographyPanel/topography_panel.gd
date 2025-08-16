extends SubscribeWrapper

@onready var Tabs:HBoxContainer = $VBoxContainer/HBoxContainer/Tabs
@onready var BackIcon:Control = $VBoxContainer/HBoxContainer/BackIcon
@onready var NextIcon:Control = $VBoxContainer/HBoxContainer/NextIcon
@onready var ContentList:VBoxContainer = $VBoxContainer/MarginContainer/ContentList

@onready var Warnings:Control = $Warnings
@onready var TempWarning:Control = $Warnings/TempWarning
@onready var PowerWarning:Control = $Warnings/PowerWarning
@onready var RealityWarning:Control = $Warnings/RealityWarning
@onready var PollutionWarning:Control = $Warnings/PollutionWarning

@onready var warning_string_label_settings:LabelSettings = $Warnings/PollutionWarning/PanelContainer/VBoxContainer/Status/MarginContainer/HBoxContainer/Title.label_settings.duplicate()
@onready var panel_stylebox_copy:StyleBoxFlat = $Warnings/PollutionWarning/PanelContainer/VBoxContainer/Header.get("theme_override_styles/panel").duplicate()

var control_pos:Dictionary = {}
var modulate_tween:Tween
var position_tween:Tween
var flashing_nodes:Array
var attach_check_arr:Array

func _ready() -> void:	
	for index in ContentList.get_child_count():
		var ContentNode:Control = ContentList.get_child(index)
		ContentNode.index = index
	self.modulate.a = 0
		
func start() -> void:
	on_current_location_update()
	self.modulate.a = 1

func end() -> void:
	for tween in [modulate_tween, position_tween]:
		if tween != null and tween.is_running():
			tween.stop()
	modulate_tween = create_tween()
	position_tween = create_tween()
	
	await custom_tween_node_property(modulate_tween, Warnings, "modulate:a", 0, 0.3, 0, Tween.TRANS_SINE)
	self.modulate.a = 0

# --------------------------------------------------------------------------------------------------		
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty(): return
	U.debounce(str(self, "_update_node"), update_node)
	U.debounce(str(self, "_show_warnings"), show_warnings, 0.3)
	
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val	
	if !is_node_ready() or current_location.is_empty(): return
	for index in Tabs.get_child_count():
		var panel_node:Control = Tabs.get_child(index)
		panel_node.show()
		panel_node.is_selected = current_location.ring == index
		
	# stop tween and restart animation
	for tween in [modulate_tween, position_tween]:
		if tween != null and tween.is_running():
			tween.stop()
	Warnings.modulate.a = 0
	Warnings.position.y -= 5

	U.debounce(str(self, "_update_node"), update_node)
	U.debounce(str(self, "_show_warnings"), show_warnings, 0.3)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func show_warnings() -> void:
	Warnings.show()
	
	modulate_tween = create_tween()
	position_tween = create_tween()
	
	custom_tween_node_property(modulate_tween, Warnings, "modulate:a", 1, 0.3, 0, Tween.TRANS_SINE)
	custom_tween_node_property(position_tween, Warnings, "position:y", Warnings.position.y + 5, 0.3, 0, Tween.TRANS_SINE)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func update_warning_node(ParentNode:Control, icon:SVGS.TYPE, str:String) -> void:
	var LabelNode:Label = ParentNode.get_node("PanelContainer/VBoxContainer/Status/MarginContainer/HBoxContainer/Title")
	var IconNode:Control = ParentNode.get_node("PanelContainer/VBoxContainer/Status/MarginContainer/HBoxContainer/SVGIcon")
	var HeaderNode:Control = ParentNode.get_node("PanelContainer/VBoxContainer/Header")
	
	var color:Color = Color.RED if icon == SVGS.TYPE.DANGER else Color.BLACK
	var warning_string_label_settings_duplicate:LabelSettings = warning_string_label_settings.duplicate()
	
	IconNode.icon = icon
	IconNode.icon_color = color
	LabelNode.text = str
	
	if icon == SVGS.TYPE.DANGER:
		flashing_nodes.push_back(HeaderNode)
	else:
		var new_panel_stylebox_copy:StyleBoxFlat = panel_stylebox_copy.duplicate()
		new_panel_stylebox_copy.bg_color = Color.BLACK
		HeaderNode.set("theme_override_styles/panel", new_panel_stylebox_copy)
	
	if LabelNode not in attach_check_arr:
		attach_check_arr.push_back(LabelNode)
		LabelNode.label_settings = warning_string_label_settings_duplicate	
		warning_string_label_settings_duplicate.font_color = color
		warning_string_label_settings_duplicate.outline_color = color
		warning_string_label_settings_duplicate.outline_color.a = 0.2
		
		HeaderNode.set("theme_override_styles/panel", panel_stylebox_copy)
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------		
func update_node() -> void:
	if !is_node_ready() or room_config.is_empty() or current_location.is_empty(): return
	var ring_level_config:Dictionary = U.get_ring_level_config(current_location)
	var monitor:Dictionary = ring_level_config.monitor

	TempWarning.show() if absi(monitor.temp) >= 2 else TempWarning.hide()
	PollutionWarning.show() if monitor.pollution >= 2 else PollutionWarning.hide()
	RealityWarning.show() if monitor.reality >= 2 else RealityWarning.hide()
	PowerWarning.show() if ring_level_config.energy.used > ring_level_config.energy.available or ring_level_config.energy.available == 0 else PowerWarning.hide()
	
	# reset any flashing nodes
	flashing_nodes = []
	
	# power update
	var power_warning_icon:SVGS.TYPE = SVGS.TYPE.WARNING if ring_level_config.energy.used > ring_level_config.energy.available else SVGS.TYPE.DANGER
	var power_warning_str:String = "INSUFFICIENT" if ring_level_config.energy.used > ring_level_config.energy.available else "NO POWER"
	update_warning_node(PowerWarning, power_warning_icon, power_warning_str)
	
	# warnings
	update_warning_node(TempWarning, SVGS.TYPE.DANGER if absi(monitor.temp) == 3 else SVGS.TYPE.CAUTION if absi(monitor.temp) == 2 else SVGS.TYPE.NONE, "DANGER!" if absi(monitor.temp) == 3 else "CAUTION")	
	update_warning_node(PollutionWarning, SVGS.TYPE.DANGER if absi(monitor.pollution) == 3 else SVGS.TYPE.CAUTION if absi(monitor.pollution) == 2 else SVGS.TYPE.NONE, "DANGER!" if absi(monitor.pollution) == 3 else "CAUTION")	
	update_warning_node(RealityWarning, SVGS.TYPE.DANGER if absi(monitor.reality) == 3 else SVGS.TYPE.CAUTION if absi(monitor.reality) == 2 else SVGS.TYPE.NONE, "DANGER!" if absi(monitor.reality) == 3 else "CAUTION")	
	

	# assign room data
	for index in ContentList.get_child_count():
		var ContentNode:Control = ContentList.get_child(index)
		var room_level_config:Dictionary = U.get_room_level_config({"floor": current_location.floor, "ring": current_location.ring, "room": index}) 
		ContentNode.room_level_config = room_level_config
# --------------------------------------------------------------------------------------------------		
	
# --------------------------------------------------------------------------------------------------		
func custom_tween_node_property(tween:Tween, node:Node, prop:String, new_val, duration:float = 0.3, delay:float = 0, trans:int = Tween.TRANS_QUAD, ease:int = Tween.EASE_IN_OUT) -> void:
	tween.tween_property(node, prop, new_val, duration).set_trans(trans).set_ease(ease).set_delay(delay)
	await tween.finished
# --------------------------------------------------------------------------------------------------		


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
	var new_color:Color = Color.BLACK.lerp(Color.RED, t)

	for node in flashing_nodes:
		var new_panel_stylebox_copy:StyleBoxFlat = panel_stylebox_copy.duplicate()
		# ebdanode.color = new_color
		new_panel_stylebox_copy.bg_color = new_color
		node.set("theme_override_styles/panel", new_panel_stylebox_copy)
