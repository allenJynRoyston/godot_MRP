extends PanelContainer
enum DIR {INWARD, OUTWARD}

# -----------------------
@onready var R0:ColorRect = $MarginContainer/HBoxContainer/VBoxContainer/R0
@onready var R1:ColorRect = $MarginContainer/HBoxContainer/VBoxContainer/R1
@onready var R2:ColorRect = $MarginContainer/HBoxContainer/VBoxContainer2/R2
# -----------------------
@onready var R3:ColorRect = $MarginContainer/HBoxContainer/VBoxContainer/R3
@onready var R4:ColorRect = $MarginContainer/HBoxContainer/VBoxContainer2/R4
@onready var R5:ColorRect = $MarginContainer/HBoxContainer/VBoxContainer3/R5
# -----------------------
@onready var R6:ColorRect = $MarginContainer/HBoxContainer/VBoxContainer2/R6
@onready var R7:ColorRect = $MarginContainer/HBoxContainer/VBoxContainer3/R7
@onready var R8:ColorRect = $MarginContainer/HBoxContainer/VBoxContainer3/R8
# -----------------------

@export var room_id:int = -1: 
	set(val):
		room_id = val
		U.debounce( str(self, "_update_node"), update_node )
		
var preview_mode:bool = false

func _ready() -> void:
	update_node()

func get_color_node(id:int) -> ColorRect:
		match id:
			0:
				return R0
			1:
				return R1
			2:
				return R2
			3:
				return R3
			4:
				return R4
			5:
				return R5
			6:
				return R6
			7:
				return R7
			8:
				return R8
			_:
				return R4

func update_node() -> void:
	if !is_node_ready() or GAME_UTIL.current_location.is_empty():return
	var room_level_config:Dictionary = GAME_UTIL.get_room_level_config({"floor": GAME_UTIL.current_location.floor, "ring": GAME_UTIL.current_location.ring, "room": room_id})
	var is_department:bool = !room_level_config.department_props.is_empty()
	var is_utility:bool = !room_level_config.utility_props.is_empty()
	var is_scp_empty:bool = ROOM_UTIL.is_scp_empty()
	var can_contain:bool = ROOM_UTIL.room_can_contain()
	var containment_color:Color = Color.PURPLE
	var department_color:Color = Color.ORANGE
	var utility_color:Color = Color.WHITE
	var empty_color:Color = Color.DARK_CYAN

	#----------------------------------------------
	for node in [R0, R1, R2, R3, R4, R5, R6, R7, R8]:
		node.color = empty_color.darkened(0.5)
		node.get_child(0).get_child(0).icon = SVGS.TYPE.NONE
		node.get_child(0).get_child(0).icon_color = Color.BLACK
		node.get_child(0).get_child(0).hide()
	
	#----------------------------------------------
	var department_rooms:Array = ROOM_UTIL.get_departments().map(func(x): return x.location.room)
	for n in department_rooms:
		var node:Control = get_color_node(n)				
		var _can_contain:bool = ROOM_UTIL.room_can_contain({"floor": GAME_UTIL.current_location.floor, "ring": GAME_UTIL.current_location.ring, "room": n})		
		var _is_scp_empty:bool = ROOM_UTIL.is_scp_empty({"floor": GAME_UTIL.current_location.floor, "ring": GAME_UTIL.current_location.ring, "room": n})
		node.color = containment_color.darkened(0.5) if _can_contain else department_color.darkened(0.5)
		
		if _can_contain:
			node.get_child(0).get_child(0).icon = SVGS.TYPE.CONTAIN if !_is_scp_empty else SVGS.TYPE.SETTINGS
			node.get_child(0).get_child(0).icon_color = Color.WHITE
			node.get_child(0).get_child(0).show()
		
	#----------------------------------------------
	var utility_rooms:Array = ROOM_UTIL.get_utilities().map(func(x): return x.location.room)
	for n in utility_rooms:
		var current_node:Control = get_color_node(n)
		var util_dict:Dictionary = GAME_UTIL.get_room_level_config({"floor": GAME_UTIL.current_location.floor, "ring": GAME_UTIL.current_location.ring, "room": n})
		current_node.color = utility_color.darkened(0.5)
		current_node.get_child(0).get_child(0).show()
		
		if util_dict.utility_props.has("level"):
			current_node.get_child(0).get_child(0).icon = SVGS.TYPE.PLUS
		if util_dict.utility_props.has("energy"):
			current_node.get_child(0).get_child(0).icon = SVGS.TYPE.ENERGY
		if util_dict.utility_props.has("currency"):
			var _data:Dictionary = RESOURCE_UTIL.return_currency(util_dict.utility_props.currency)
			current_node.get_child(0).get_child(0).icon = _data.icon
		if util_dict.utility_props.has("metric"):
			var _data:Dictionary = RESOURCE_UTIL.return_metric(util_dict.utility_props.metric)
			current_node.get_child(0).get_child(0).icon = _data.icon			

	#----------------------------------------------
	if is_department:		
		var current_node:Control = get_color_node(room_id)
		current_node.color = containment_color if can_contain else department_color 
	elif is_utility:
		var current_node:Control = get_color_node(room_id)
		current_node.color = utility_color		
	else:
		var current_node:Control = get_color_node(room_id)
		current_node.color = empty_color
	
