extends SubscribeWrapper

@onready var Empty:VBoxContainer = $VBoxContainer/Empty
@onready var Stats:VBoxContainer = $VBoxContainer/Stats
@onready var Income:VBoxContainer = $VBoxContainer/Income

@onready var StatusLabel:Label = $VBoxContainer/Stats/Content/MarginContainer/VBoxContainer2/Status/StatusLabel
@onready var DamageLabel:Label = $VBoxContainer/Stats/Content/MarginContainer/VBoxContainer2/Damage/DamageLabel
@onready var EffectLabel:Label = $VBoxContainer/Stats/Content/MarginContainer/VBoxContainer2/Effect/EffectLabel

@onready var ProductionList:VBoxContainer = $VBoxContainer/Income/Content/MarginContainer/VBoxContainer/Production/ProductionList
@onready var VibeList:VBoxContainer = $VBoxContainer/Income/Content/MarginContainer/VBoxContainer/Vibes/VibeList

@onready var Detected:Control = $Detected
@onready var DetectedPanel:PanelContainer = $Detected/DetectedPanel
@onready var DetectedHeader:PanelContainer = $Detected/DetectedPanel/VBoxContainer/Header

@onready var detected_header_stylebox:StyleBoxFlat = DetectedHeader.get("theme_override_styles/panel").duplicate()
@onready var new_label_settings:LabelSettings = StatusLabel.get("label_settings").duplicate()
@onready var status_label_setting:LabelSettings = StatusLabel.get("label_settings").duplicate()
@onready var damage_label_setting:LabelSettings = DamageLabel.get("label_settings").duplicate()

var modulate_tween:Tween
var position_tween:Tween
var is_active:bool = false
var has_event:bool = false

# ------------------------------------------
func _init() -> void:
	super._init()
	GBL.subscribe_to_control_input(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unsubscribe_to_control_input(self)	

func _ready() -> void:
	Empty.hide()
	Stats.hide()
	Income.hide()
		
	DetectedPanel.modulate.a = 0
	DetectedHeader.set("theme_override_styles/panel", detected_header_stylebox)
	StatusLabel.set("label_settings", status_label_setting)
	DamageLabel.set("label_settings", damage_label_setting)
	
func start() -> void:
	is_active = true
	update_node()
	
func end() -> void:
	Empty.hide()
	Stats.hide()
	Income.hide()
		
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
	
func update_node() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty() or !is_active:return
	
	var room_pos:Vector2 = GBL.find_node(REFS.WING_RENDER).get_room_position(current_location.room) * GBL.game_resolution 
	var room_level_config:Dictionary = GAME_UTIL.get_room_level_config()
	var room_base_states:Dictionary = GAME_UTIL.get_room_base_state()		
	var is_room_empty:bool = ROOM_UTIL.is_room_empty()
	var is_activated:bool = ROOM_UTIL.is_room_activated()
	var is_under_construction:bool = ROOM_UTIL.is_under_construction()	
	var metric_list:Dictionary = ROOM_UTIL.get_room_metric_list() 	
	var currency_list:Dictionary = ROOM_UTIL.get_room_currency_list() 
	var effect:Dictionary = ROOM_UTIL.get_room_effect()
	var energy_used:int = room_level_config.energy_used	
	var damage_val:int = room_level_config.damage_val
	
	# set flag
	has_event = !room_base_states.events_pending.is_empty()
	
	# is activated
	StatusLabel.text = "Anamolly detected!" if has_event else "Under construction" if is_under_construction else ("Active" if is_activated else "Inactive")
	status_label_setting.font_color = COLORS.disabled_color if (is_under_construction or has_event) else (COLORS.primary_black if is_activated else COLORS.disabled_color)
	status_label_setting.outline_color = status_label_setting.font_color
	status_label_setting.outline_color.a = 0.2
	
	# damage
	DamageLabel.text = "No damage"  
	
	# effect
	EffectLabel.text = "No effect" if effect.is_empty() else effect.description
	
	# production list	
	for listnode in [VibeList, ProductionList]:
		for node in listnode.get_children():
			node.free()

	# currencies
	for ref in currency_list:
		var item:Dictionary = currency_list[ref] 
		var amount:int = item.amount 
		var bonus_amount:int = item.bonus_amount
		var total_amount:int = amount + bonus_amount
		if total_amount != 0:
			var new_label:Label = Label.new()
			var resource_data:Dictionary = RESOURCE_UTIL.return_currency(ref)
			new_label.set("label_settings", new_label_settings)			
			new_label.text = "%s%s %s" % ["-" if amount < 0 else "+", amount, resource_data.name]
			if bonus_amount != 0:
				new_label.text += "(+%s BONUS)" % [bonus_amount]
			new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			ProductionList.add_child(new_label)
	
	# metric 
	for ref in metric_list:
		var item:Dictionary = metric_list[ref] 
		var amount:int = item.amount 
		var bonus_amount:int = item.bonus_amount
		var total_amount:int = amount + bonus_amount
		if total_amount != 0:
			var new_label:Label = Label.new()
			var resource_data:Dictionary = RESOURCE_UTIL.return_metric(ref)
			new_label.set("label_settings", new_label_settings)			
			new_label.text = "%s%s %s" % ["-" if amount < 0 else "+", amount, resource_data.name]
			if bonus_amount != 0:
				new_label.text += "(+%s BONUS)" % [bonus_amount]
			new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			VibeList.add_child(new_label)			
	

	# is empty production list
	if ProductionList.get_child_count() == 0:
		var new_label:Label = Label.new()
		new_label.set("label_settings", new_label_settings)
		new_label.text = "Awaiting construction" if is_under_construction else "None"
		new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		ProductionList.add_child(new_label)
	
	# is empty vibe list
	if VibeList.get_child_count() == 0:
		var new_label:Label = Label.new()
		new_label.set("label_settings", new_label_settings)
		new_label.text = "Awaiting construction" if is_under_construction else "None"
		new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		VibeList.add_child(new_label)
		
	# animate 
	for tween in [modulate_tween, position_tween]:
		if tween != null and tween.is_running():
			tween.stop()
			
	DetectedPanel.modulate.a = 0
	DetectedPanel.global_position = room_pos - Vector2(0, 120 if !is_room_empty else 80)
	
	# show correct content
	Empty.show() if is_room_empty else Empty.hide()
	Stats.show() if !is_room_empty else Stats.hide()	
	Income.hide() if (VibeList.get_child_count() == 0 and ProductionList.get_child_count() == 0) else Income.show()
		
	
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
