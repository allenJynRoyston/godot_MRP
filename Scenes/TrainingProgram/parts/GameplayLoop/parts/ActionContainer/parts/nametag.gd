@tool
extends Control

@onready var ContentPanel:PanelContainer = $ContentControl/ContentPanel
@onready var ContentMargin:MarginContainer = $ContentControl/ContentPanel/MarginContainer
@onready var ConstructionIcon:Control = $ContentControl/ContentPanel/MarginContainer/HBoxContainer/ConstructionIcon
@onready var StatusIcon:Control = $ContentControl/ContentPanel/MarginContainer/HBoxContainer/StatusIcon
@onready var NameLabel:Label = $ContentControl/ContentPanel/MarginContainer/HBoxContainer/MarginContainer/NameLabel
@onready var LevelPanel:PanelContainer = $ContentControl/ContentPanel/MarginContainer/HBoxContainer/LevelPanel
@onready var LevelLabel:Label = $ContentControl/ContentPanel/MarginContainer/HBoxContainer/LevelPanel/MarginContainer/HBoxContainer/MarginContainer/LevelLabel
@onready var DownArrowIcon:Control = $ArrowControl/DownArrowIcon

@onready var name_label_settings:LabelSettings = NameLabel.get("label_settings").duplicate()
@onready var contentpanel_stylebox:StyleBoxFlat = ContentPanel.get("theme_override_styles/panel").duplicate()

@export var index:int = -1 : 
	set(val):
		index = val
		on_index_update()
		
@export var alignment:U.ALIGN = U.ALIGN.CENTER : 
	set(val):
		alignment = val
		on_alignment_update()
		
const VibeItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/HeaderControl/parts/VibeItem/VibeItem.tscn")
const EcoItemPreload:PackedScene = preload("res://UI/EconItem/EconItem.tscn")

var room_config:Dictionary = {}
var current_location:Dictionary = {}

var max_modulate_val:int = 1
var name_str:String
var shifted_val:int = 10
var offset_y:int = 0
var offset_x:int = 0
var focus_on_current:bool = false : 
	set(val):
		focus_on_current = val
		on_focus_on_current_update()
var show_empty:bool = false : 
	set(val):
		show_empty = val
		on_show_empty_update()

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
	ContentPanel.set("theme_override_styles/panel", contentpanel_stylebox)
	NameLabel.set("label_settings", name_label_settings)
	update_node()
# --------------------------------------------

# --------------------------------------------
func change_camera_view(viewpoint:CAMERA.VIEWPOINT) -> void:
	match viewpoint:
		# ---------------
		CAMERA.VIEWPOINT.OVERHEAD:
			focus_on_current = false
			show_empty = true
			offset_y = -20
			if index in [0, 1, 3]:
				alignment = U.ALIGN.LEFT
			if index in [2, 4, 6]:
				alignment = U.ALIGN.CENTER
			if index in [5, 7, 8]:
				alignment = U.ALIGN.RIGHT
		# ---------------
		CAMERA.VIEWPOINT.DISTANCE:
			offset_y = -20
			focus_on_current = true
			show_empty = false
		# ---------------
		_:
			offset_y = -10
			focus_on_current = false
			show_empty = false
			alignment = U.ALIGN.CENTER

func on_show_empty_update() -> void:
	U.debounce(str(self.name, "_update_node"), func():update_node())

func on_focus_on_current_update() -> void:
	U.debounce(str(self.name, "_update_node"), func():update_node())

func on_index_update() -> void:
	if Engine.is_editor_hint() and index < 0:
		NameLabel.text = "Nametag"
	U.debounce(str(self.name, "_update_node"), func():update_node())

func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	U.debounce(str(self.name, "_update_node"), func():update_node())

func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if current_location.is_empty():return
	
	if focus_on_current:
		U.debounce(str(self.name, "_update_node"), func():update_node())
	
	if previous_ring != current_location.ring or previous_floor != current_location.floor:
		previous_ring = current_location.ring 
		previous_floor = current_location.floor
		U.debounce(str(self.name, "_update_node"), func():update_node())

func on_alignment_update() -> void:
	if !is_node_ready():return
	ContentPanel.size = Vector2(1, 1)
	await U.tick()
	match alignment:
		U.ALIGN.CENTER:
			U.tween_node_property(ContentPanel, "position:x", -(ContentPanel.size.x/2) + 10, 0.3, 0, Tween.TRANS_SINE)
			U.tween_range(offset_x, 10, 0.3, func(new_val) -> void:
				offset_x = new_val	
			)
		U.ALIGN.LEFT:
			U.tween_node_property(ContentPanel, "position:x", -ContentPanel.size.x + 30, 0.3, 0, Tween.TRANS_SINE)
			U.tween_range(offset_x, -10, 0.3, func(new_val) -> void:
				offset_x = new_val	
			)
		U.ALIGN.RIGHT:
			U.tween_node_property(ContentPanel, "position:x", 0, 0.3, 0, Tween.TRANS_SINE)
			U.tween_range(offset_x, 30, 0.3, func(new_val) -> void:
				offset_x = new_val	
			)

func reveal(state:bool) -> void:
	max_modulate_val = 1 if state else 0
	update_node()

func set_fade(state:bool) -> void:
	U.tween_range(modulate.a, max_modulate_val if state else 0, 0.1, func(new_val) -> void:
		modulate.a = new_val
		DownArrowIcon.icon_color.a = new_val
	)
# --------------------------------------------

# --------------------------------------------
func update_node() -> void:
	if !is_node_ready() or room_config.is_empty() or current_location.is_empty() or index == -1:return
	shifted_val = 10
	
	# get location
	var use_location:Dictionary = current_location.duplicate()
	use_location.room = index
	
	# hide/show currency icons
	var room_details:Dictionary = ROOM_UTIL.return_data_via_location(use_location)
	var is_room_empty:bool = ROOM_UTIL.is_room_empty(use_location)
	var is_under_construction:bool = ROOM_UTIL.is_under_construction(use_location)
	var is_activated:bool = ROOM_UTIL.is_room_activated(use_location)
	var is_department:bool = !is_room_empty and !room_details.department_properties.is_empty()
	var is_utility:bool = !is_room_empty and !room_details.utility_props.is_empty()
	
	# empty room
	if is_room_empty:
		LevelPanel.hide()
		ConstructionIcon.hide()
		StatusIcon.hide()
		StatusIcon.icon = SVGS.TYPE.NONE
		StatusIcon.icon_color = Color.BLACK
		# update name label
		name_label_settings.font_color = Color.BLACK
		name_str = "EMPTY" if show_empty else ""
		if show_empty and focus_on_current:
			if current_location.room == index:
				set_fade(true)
			else:
				set_fade(false)
		else:
			set_fade(false)
		on_alignment_update()
		return
	

	# is_department
	if is_department:
		var room_level_config:Dictionary = GAME_UTIL.get_room_level_config(use_location)
		# hide and update icons
		LevelPanel.show()
		ConstructionIcon.show() if is_under_construction else ConstructionIcon.hide()
		StatusIcon.show() if !is_under_construction else StatusIcon.hide()
		StatusIcon.icon = SVGS.TYPE.CONTAIN
		StatusIcon.icon_color = Color.BLACK if is_activated else Color.DARK_RED
		DownArrowIcon.icon_color = Color(1.0, 0.749, 0.2)
		
		# content 
		contentpanel_stylebox.bg_color = Color(1.0, 0.749, 0.2)
		LevelLabel.text = str(room_level_config.department_properties.level)
		ContentMargin.set("theme_override_constants/margin_left", 0)

		# update Name
		name_label_settings.font_size = 12 
		name_label_settings.font_color = Color.RED if is_under_construction or (!is_under_construction and !is_activated) else Color.BLACK		
		name_str = room_details.shortname.substr(0, 13)
		
	# is utility...
	if is_utility:
		# hide and update icons
		ConstructionIcon.hide()
		StatusIcon.hide()
		LevelPanel.hide()
		StatusIcon.icon_color = Color.BLACK
		DownArrowIcon.icon_color = Color.WHITE
		
		# content
		contentpanel_stylebox.bg_color = Color.WHITE
		
		# update name
		name_label_settings.font_size = 14 
		name_label_settings.font_color =  Color.BLACK
		ContentMargin.set("theme_override_constants/margin_left", 7)
		
		# update utility
		var utility_props:Dictionary = room_details.utility_props		
		if !utility_props.is_empty():
			# ---------------------------
			if utility_props.has("level"):
				StatusIcon.icon_size = Vector2(12, 12)
				StatusIcon.icon = SVGS.TYPE.PLUS
				StatusIcon.show()
				name_label_settings.font_color = Color.BLACK
				name_str = str(utility_props.level)
			# ---------------------------
			if utility_props.has("metric"):
				var metric_details:Dictionary = RESOURCE_UTIL.return_metric(utility_props.metric)
				StatusIcon.icon_size = Vector2(12, 12)
				StatusIcon.icon = SVGS.TYPE.PLUS
				StatusIcon.show()
				name_label_settings.font_color = Color.BLACK
				name_str = metric_details.name
			# ---------------------------
			if utility_props.has("currency"):
				var currency_details:Dictionary = RESOURCE_UTIL.return_currency(utility_props.currency)
				StatusIcon.icon_size = Vector2(12, 12)
				StatusIcon.icon = SVGS.TYPE.PLUS
				StatusIcon.show()
				name_str = currency_details.name
			# ---------------------------
			if utility_props.has("currency_blacklist"):
				var currency_details:Dictionary = RESOURCE_UTIL.return_currency(utility_props.currency_blacklist)
				StatusIcon.icon_size = Vector2(12, 12)
				StatusIcon.icon = SVGS.TYPE.MINUS
				StatusIcon.icon_color = Color.RED
				StatusIcon.show()
				name_label_settings.font_color = Color.RED
				name_str = currency_details.name				
			# ---------------------------
			if utility_props.has("metric_blacklist"):
				var currency_details:Dictionary = RESOURCE_UTIL.return_metric(utility_props.metric_blacklist)
				StatusIcon.icon_size = Vector2(12, 12)
				StatusIcon.icon = SVGS.TYPE.MINUS
				StatusIcon.icon_color = Color.RED
				StatusIcon.show()
				name_label_settings.font_color = Color.RED
				name_str = currency_details.name				
			# ---------------------------
			if utility_props.has("effects"):
				var effect_details:Dictionary = ROOM.return_effect(utility_props.effects)
				name_str = room_details.shortname
				name_label_settings.font_color = Color.BLACK
		
	
	# show only when focused on
	if focus_on_current:
		if focus_on_current and current_location.room == index:
			set_fade(true)
		else:
			set_fade(false)
	else:
		set_fade(true)

	on_alignment_update()
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

# -------------------------------------------- update location
func on_process_update(delta:float, _time_passed:float) -> void:
	if !is_node_ready() or !is_visible_in_tree() or index == -1:return
	var tag_pos:Vector2 = GBL.find_node(REFS.WING_RENDER).get_room_position(index) * GBL.game_resolution 
	self.global_position = tag_pos + Vector2(offset_x, offset_y)

func _physics_process(delta: float) -> void:
	if !is_node_ready() or !is_visible_in_tree() or index == -1:return
	if shifted_val > 0:
		shifted_val -= 1
		NameLabel.text = shift_string_backward(name_str, shifted_val)
		ContentPanel.size = Vector2(1, 1)
# --------------------------------------------
