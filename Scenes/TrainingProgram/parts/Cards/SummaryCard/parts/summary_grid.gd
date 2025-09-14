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
		
var dir:DIR = DIR.OUTWARD 
var dir_dict:Dictionary = {"top": false, "bottom": true, "left": false, "right": true}
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
	var department_color:Color = Color.ORANGE
	var utility_color:Color = Color.WHITE
	var arrow_color:Color =  Color.WHITE if !is_department else Color.WHITE 
	dir = DIR.INWARD if is_department else DIR.OUTWARD
	
	for item in [R0, R1, R2, R3, R4, R5, R6, R7, R8]:
		item.color = Color.DARK_CYAN.darkened(0.5)
		item.get_child(0).get_child(0).icon = SVGS.TYPE.NONE
	
	var department_rooms:Array = ROOM_UTIL.get_departments().map(func(x): return x.location.room)
	for n in department_rooms:
		var node:Control = get_color_node(n)
		node.color = department_color.darkened(0.5)
		
	var utility_rooms:Array = ROOM_UTIL.get_utilities().map(func(x): return x.location.room)
	for n in utility_rooms:
		var node:Control = get_color_node(n)
		node.color = utility_color.darkened(0.5)

	if is_department:		
		var current_node:Control = get_color_node(room_id)
		current_node.color = department_color
		#for n in ROOM_UTIL.find_neighbors(room_id):
			#var node:Control = get_color_node(n)
			#var n_config:Dictionary = GAME_UTIL.get_room_level_config( {"floor": GAME_UTIL.current_location.floor, "ring": GAME_UTIL.current_location.ring, "room": n} )
			#if !n_config.utility_props.is_empty():
				#node.color = utility_color
				#node.get_child(0).get_child(0).icon = SVGS.TYPE.NONE
				#node.get_child(0).get_child(0).icon_color = Color.BLACK
			#else:
				#node.get_child(0).get_child(0).icon = SVGS.TYPE.NONE
	
	elif is_utility:
		var current_node:Control = get_color_node(room_id)
		current_node.color = utility_color		
		#for n in ROOM_UTIL.find_neighbors_range_1(room_id):
			#var n_config:Dictionary = GAME_UTIL.get_room_level_config( {"floor": GAME_UTIL.current_location.floor, "ring": GAME_UTIL.current_location.ring, "room": n} )
			#var node:Control = get_color_node(n)
			#if !n_config.department_props.is_empty():
				#node.get_child(0).get_child(0).show()
				#node.get_child(0).get_child(0).icon = SVGS.TYPE.NONE
				#node.get_child(0).get_child(0).icon_color = Color.WHITE
	
	else:
		var current_node:Control = get_color_node(room_id)
		current_node.color = Color.DARK_CYAN
	
