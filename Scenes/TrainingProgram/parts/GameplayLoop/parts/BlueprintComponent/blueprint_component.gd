extends SubscribeWrapper

@onready var NoBonusLabel:Label = $VBoxContainer/Income/Content/MarginContainer/NoBonusLabel
@onready var CurrencyList:HBoxContainer = $VBoxContainer/Income/Content/MarginContainer/VBoxContainer/CurrencyList
@onready var MetricList:HBoxContainer = $VBoxContainer/Income/Content/MarginContainer/VBoxContainer/MetricList
@onready var EffectList:VBoxContainer = $VBoxContainer/Income/Content/MarginContainer/VBoxContainer/EffectList

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
# ------------------------------------------

# ------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	U.debounce(str(self, "_update_node"), update_node)

func on_purchased_facility_arr_update(new_val:Array) -> void:
	purchased_facility_arr = new_val
	U.debounce(str(self, "_update_node"), update_node)
	
func update_node() -> void:
	if !is_node_ready() or current_location.is_empty() or !is_active:return
	var room_level_config:Dictionary = GAME_UTIL.get_room_level_config(current_location)
	var all_influenced_rooms:Dictionary = ROOM_UTIL.find_all_influenced_rooms(true)
	
	for list in [MetricList, CurrencyList, EffectList]:
		for node in list.get_children():
			node.queue_free()
	
	if current_location.room in all_influenced_rooms:
		NoBonusLabel.hide()
		return
	
	NoBonusLabel.show()

func show_warning() -> void:
	if !has_event:return
	#modulate_tween = create_tween()
	#position_tween = create_tween()
	#
	#custom_tween_node_property(modulate_tween, DetectedPanel, "modulate:a", 1, 0.3, 0, Tween.TRANS_SINE)
	#custom_tween_node_property(position_tween, DetectedPanel, "position:y", DetectedPanel.position.y + 5, 0.3, 0, Tween.TRANS_SINE)
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
