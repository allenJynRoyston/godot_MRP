extends SubscribeWrapper

@onready var NoBonusLabel:Label = $VBoxContainer/Income/PanelContainer/MarginContainer/Content/MarginContainer/NoBonusLabel
@onready var EffectTextLabel:RichTextLabel = $VBoxContainer/Income/PanelContainer/MarginContainer/Content/MarginContainer/EffectTextLabel

const font_1_black_preload:LabelSettings = preload("res://Fonts/font_1_black.tres")
const EconItemPreload:PackedScene = preload("res://UI/EconItem/EconItem.tscn")
const VibeItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/HeaderControl/parts/VibeItem/VibeItem.tscn")

var modulate_tween:Tween
var position_tween:Tween
var is_active:bool = false
var has_event:bool = false

var all_influenced_rooms:Dictionary

# ------------------------------------------
func _init() -> void:
	super._init()
	GBL.subscribe_to_control_input(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unsubscribe_to_control_input(self)	

func _ready() -> void:
	pass

func start() -> void:
	is_active = true
	update_node()
	
func end() -> void:
	is_active = false
# ------------------------------------------d

# ------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	U.debounce(str(self, "_update_node"), update_node)

func on_purchased_facility_arr_update(new_val:Array) -> void:
	purchased_facility_arr = new_val
	U.debounce(str(self, "_update_node"), update_node)
	
func show_warning() -> void:
	if !has_event:return
	#modulate_tween = create_tween()
	#position_tween = create_tween()
	#
	#custom_tween_node_property(modulate_tween, DetectedPanel, "modulate:a", 1, 0.3, 0, Tween.TRANS_SINE)
	#custom_tween_node_property(position_tween, DetectedPanel, "position:y", DetectedPanel.position.y + 5, 0.3, 0, Tween.TRANS_SINE)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func update_node() -> void:
	if !is_node_ready() or current_location.is_empty() or !is_active:return
	var room_level_config:Dictionary = GAME_UTIL.get_room_level_config(current_location)
	var adjacent_departments:Array = ROOM_UTIL.find_adjacent_rooms(current_location.room)
	var is_room_empty:bool = ROOM_UTIL.is_room_empty()
	var room_details:Dictionary = ROOM_UTIL.return_data_via_location()
	
	EffectTextLabel.text = ""
	
	if room_details.is_empty(): return
	
	# ---------------------------------------------------------
	if !room_level_config.department_props.is_empty():
		NoBonusLabel.hide()
		EffectTextLabel.text = "[color='black'][b]%s[/b][/color]" % [room_details.name]
	
	# ---------------------------------------------------------
	elif !is_room_empty and !room_details.utility_props.is_empty():
		var utility_props:Dictionary = room_details.utility_props
		var utility_string:String = ""
		var energy_string:String = ""

		if !utility_props.is_empty():
			if utility_props.has("level"):
				utility_string += "[color=blue][+%s LVL][/color]" % [utility_props.level]
			if utility_props.has("bonus"):
				utility_string += " [color=blue][+%s BONUS][/color]" % [utility_props.bonus]
			if utility_props.has("metric"):
				var details:Dictionary = RESOURCE_UTIL.return_metric(utility_props.metric)
				utility_string += " [color=blue][ADD %s MODIFIER][/color]" % [details.name]
			if utility_props.has("currency"):
				var details:Dictionary = RESOURCE_UTIL.return_currency(utility_props.currency)
				utility_string += " [color=blue][ADD %s MODIFIER][/color]" % [details.name]
			if utility_props.has("currency_blacklist"):
				var details:Dictionary = RESOURCE_UTIL.return_currency(utility_props.currency_blacklist)
				utility_string += " [color=red][REMOVED %s MODIFIER][/color]" % [details.name]
			if utility_props.has("metric_blacklist"):
				var details:Dictionary = RESOURCE_UTIL.return_currency(utility_props.metric_blacklist)
				utility_string += " [color=red][REMOVED %s MODIFIER][/color]" % [details.name]
			if utility_props.has("effects"):
				var details:Dictionary = ROOM.return_effect(utility_props.effects)
				utility_string += "[color=purple][%s][/color]" % details.description.call(ROOM.OPERATOR.ADD)
			# ------------------------------------
			if utility_props.has("energy"):
				energy_string += "[color=orange]+%s ENERGY[/color]" % [utility_props.energy]
					
			var room_names: Array = []

			for i in range(adjacent_departments.size()):
				var room = adjacent_departments[i]
				var adj_room_details: Dictionary = ROOM_UTIL.return_data_via_location({
					"floor": current_location.floor,
					"ring": current_location.ring,
					"room": room
				})
				if !adj_room_details.is_empty():
					NoBonusLabel.hide()
					room_names.append(adj_room_details.shortname)

			# After gathering all valid rooms, print once
			if energy_string != "":
				EffectTextLabel.text += "[color=black][b]%s[/b] added to sector.[/color]\n\n" % [energy_string]

			if utility_string != "" and room_names.size() > 0:
				var joined_names := ""
				if room_names.size() == 1:
					joined_names = room_names[0]
				elif room_names.size() == 2:
					joined_names = "%s and %s" % [room_names[0], room_names[1]]
				else:
					# "a, b, and c"
					joined_names = ", ".join(room_names.slice(0, room_names.size() - 1))
					joined_names += ", and %s" % room_names[-1]

				EffectTextLabel.text += "[color=black][b]%s[/b] applied to [b][color=teal]%s[/color][/b].[/color]" % [utility_string, joined_names]



	
	else:
		NoBonusLabel.show()
	#
	#if current_location.room in all_influenced_rooms:
		#NoBonusLabel.hide()
		#return
	
	#NoBonusLabel.show()
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

	## Get a value that goes 0 → 1 → 0 smoothly over time
	#var t = sin((flash_timer / flash_interval) * PI)
#
	## Interpolate between black and red
	#detected_header_stylebox.bg_color = Color.BLACK.lerp(Color.RED, t)
# ------------------------------------------
