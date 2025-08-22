extends Control

@onready var DownArrowIcon:Control = $Control/DownArrowIcon
@onready var ListIcon:Control = $MarginContainer/ListContainer

@export var show_resource_reason:bool = false : 
	set(val):
		show_resource_reason = val
		on_show_resource_reason_update()

@export var index:int = -1 : 
	set(val):
		index = val
		on_index_update()
		
@export var fade:bool = false : 
	set(val):
		fade = val
		on_fade_update()

@export var ignore_current_location:bool = false

const VibeItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/HeaderControl/parts/VibeItem/VibeItem.tscn")
const EcoItemPreload:PackedScene = preload("res://UI/EconItem/EconItem.tscn")
const fade_int:float = 5

var room_config:Dictionary = {}
var current_location:Dictionary = {}
var offset:Vector2
var name_str:String
var shifted_val:int = 5
var is_room_empty:bool 

var previous_ring:int
var previous_floor:int

# --------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	GBL.subscribe_to_process(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	GBL.unsubscribe_to_process(self)

func _ready() -> void:
	#on_fade_update()
	hide()
	await U.tick()
	on_index_update()
	on_show_resource_reason_update()
	
# --------------------------------------------

# --------------------------------------------
func on_show_resource_reason_update() -> void:
	if !is_node_ready():return
	pass
# --------------------------------------------

# --------------------------------------------	
func on_fade_update() -> void:
	if !is_node_ready():return
	
	if !fade:
		update_node()
	
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 0 if fade else 1), 0.1)
	U.tween_range(fade_int if fade else 0.0, fade_int if !fade else 0.0, 0.3, func(val:float) -> void:
		offset.x = val
	) 			
# --------------------------------------------

# --------------------------------------------
func on_index_update() -> void:
	await U.tick()
	U.debounce(str(self.name, "_nametag_update_node"), func():update_node())
# --------------------------------------------

# --------------------------------------------
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if current_location.is_empty():return
	
	if previous_ring != current_location.ring or previous_floor != current_location.floor:
		previous_ring = current_location.ring 
		previous_floor = current_location.floor

		U.debounce(str(self.name, "_nametag_update_node"), func():update_node())

func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	await U.tick()
	U.debounce(str(self.name, "_nametag_update_node"), func():update_node())

# --------------------------------------------

# --------------------------------------------
func shift_string_backward(text: String, shift: int = 5) -> String:
	var result:String = ""
	for char in text:
		if char == " ":
			result += " "  # Keep spaces unchanged
		else:
			result += char(char.unicode_at(0) - shift)  # Convert back to character
	return result
# --------------------------------------------

# --------------------------------------------
func update_node(shift_val:int = 10) -> void:
	if !is_node_ready() or room_config.is_empty() or current_location.is_empty() or index == -1:return
	shifted_val = shift_val
	
	# clear list
	for child in ListIcon.get_children():
		child.queue_free()
	
	# get location
	var use_location:Dictionary = current_location.duplicate()
	use_location.room = index
	
	# hide/show currency icons
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(use_location)
	is_room_empty = room_extract.room.is_empty()
	self.modulate = Color(1, 1, 1, 1 if !is_room_empty or !fade else 0)
	
	if is_room_empty:
		hide()
		return
	
	show()
	
	var room_details:Dictionary = ROOM_UTIL.return_data(room_extract.room.details.ref)
	var is_empty:bool = true
	
	for ref in room_details.currencies:
		var amount:int = room_details.currencies[ref]
		if amount != 0:
			var new_node:Control = EcoItemPreload.instantiate()
			var resource_details:Dictionary = RESOURCE_UTIL.return_currency(ref)
			new_node.amount = amount
			new_node.icon = resource_details.icon
			ListIcon.add_child(new_node)
			is_empty = false
			
	for ref in room_details.metrics:
		var amount:int = room_details.metrics[ref]
		if amount != 0:
			var new_node:Control = VibeItemPreload.instantiate()
			var resource_details:Dictionary = RESOURCE_UTIL.return_metric(ref)
			new_node.value = amount
			new_node.metric = ref
			new_node.invert_color = true
			new_node.big_numbers = true
			ListIcon.add_child(new_node)
			is_empty = false
				
	
	hide() if is_empty else show()
	
	await U.tick()
	self.size = Vector2(1, 1)	
		#if !room_extract.scp.is_empty():
			#for key in room_extract.scp.details.currencies: 
				#currencies_check[key] += room_extract.scp.details.currencies[key]
				
		#for key in currencies_check:
			#var amount:int = currencies_check[key]
			#match key:
				#RESOURCE.CURRENCY.MONEY:
					#MoneyIcon.hide() if amount <= 0 else MoneyIcon.show()
				#RESOURCE.CURRENCY.MATERIAL:
					#MatIcon.hide() if amount <= 0 else MatIcon.show()
				#RESOURCE.CURRENCY.SCIENCE:
					#ScienceIcon.hide() if amount <= 0 else ScienceIcon.show()
				#RESOURCE.CURRENCY.CORE:
					#CoreIcon.hide() if amount <= 0 else CoreIcon.show()
		
	#name_str = str(room_extract.room.details.shortname + " %s" % ["(INACTIVE)" if !room_extract.room.is_activated else ""])  if !is_room_empty else "EMPTY"
		#Icon.icon_color = Color.GREEN if room_extract.room.is_activated else COLORS.disabled_color

# --------------------------------------------

# -------------------------------------------- update location
func on_process_update(delta:float, _time_passed:float) -> void:
	if !is_node_ready() or !is_visible_in_tree() or index == -1:return
	var tag_pos:Vector2 = GBL.find_node(REFS.WING_RENDER).get_room_position(index) * GBL.game_resolution 
	self.global_position = tag_pos + Vector2(40, -20 if is_room_empty else -100) - Vector2(self.size.x/2, 0)
	DownArrowIcon.position.x = 3

#func _physics_process(delta: float) -> void:
	#if !is_node_ready() or !is_visible_in_tree() or index == -1:return
	#if shifted_val > 0:
		#shifted_val -= 1		
		#NameLabel.text = str(" ", shift_string_backward(name_str, shifted_val))
# --------------------------------------------
