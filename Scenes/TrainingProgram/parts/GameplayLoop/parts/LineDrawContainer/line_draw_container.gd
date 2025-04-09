extends PanelContainer

@onready var Nametag:Control = $Control/Nametag
@onready var NamePanel:PanelContainer = $Control/NamePanel
@onready var NameLabel:Label = $Control/NamePanel/MarginContainer/NameLabel

const line_width: float = 2.0

var draw_list:Array = [] 
var draw_count:int = 0
var draw_inc:int = 1
var ani_count:float = 0
var nametag_lock:bool = false
var render:bool = false
var render_lines:bool = false
var get_start_vector:Callable
var previous_room_val:int

var draw_dict:Dictionary = {
	# HEADER
	"draw_to_money": false,	
	"draw_to_research": false,
	"draw_to_material": false,
	"draw_to_core": false,
	"draw_to_energy": false, 
	"draw_to_personnel": false,
	"draw_to_morale": false,
	"draw_to_safety": false,
	"draw_to_readiness": false,
	
	# FOOTER
	"draw_to_hotkeys": true,
	"draw_to_center_btn_list": true,	
	# LEFT SIDE
	"draw_to_room_mini_card": true,
	"draw_to_scp_mini_card": true,
	"draw_to_researcher_list": true,	
}

var current_location:Dictionary = {}

# --------------------------------------------------------------------------------------------------	
func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	GBL.subscribe_to_process(self)
	GBL.subscribe_to_fullscreen(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	GBL.unsubscribe_to_process(self)
	GBL.unsubscribe_to_fullscreen(self)

func _ready() -> void:
	GBL.register_node(REFS.LINE_DRAW, self)
	NamePanel.hide()
	Nametag.hide()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func before_fullscreen_update() -> void:
	hide()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(_state:bool) -> void:
	await U.set_timeout(0.1)	

	queue_redraw()
	
	if render:
		show()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if current_location.is_empty():return
	if previous_room_val != current_location.room:
		previous_room_val = current_location.room
		nametag_lock = false
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------
func add(_get_start_vector:Callable, _draw_dict:Dictionary, delay:float = 0.3 ) -> void:
	get_start_vector = _get_start_vector
	draw_dict = _draw_dict
	draw_inc = 0
	ani_count = 0
	render_lines = false

	if "label" in draw_dict:
		NameLabel.text = draw_dict.label	
		NamePanel.size = Vector2(0, 0)
		nametag_lock = false
		NamePanel.show()
	else:
		NamePanel.hide()
	
	if "use_nametag" in draw_dict and draw_dict.use_nametag:
		Nametag.show()
	else:
		Nametag.hide()
	
	if delay > 0:
		await U.set_timeout(delay)
		
	render_lines = true
	render = true
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func clear() -> void:
	draw_list = []
	render = false
	render_lines = false
	NamePanel.hide()
	Nametag.hide()
	queue_redraw()	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func generate_stepwise_path(start_point: Vector2, end_point: Vector2, steps: int, horz_pref: bool = true) -> Array:
	var segments: Array = []  # Array to store dictionaries of start & end points
	var last_point: Vector2 = start_point
	var dx := (end_point.x - start_point.x) / float(steps)  # Horizontal step size
	var dy := (end_point.y - start_point.y) / float(steps)  # Vertical step size

	for i in range(steps):
		var next_horiz := Vector2(last_point.x + dx, last_point.y)
		var next_vert := Vector2(last_point.x, last_point.y + dy)
		var segment1: Dictionary
		var segment2: Dictionary

		if horz_pref:
			# Move horizontally
			segment1 = { "start": last_point , "end": next_horiz, "animate": "y", "is_juncture": true}  
			# Move vertically
			segment2 = { "start": next_horiz , "end": Vector2(next_horiz.x, next_horiz.y + dy), "animate": "y", "is_juncture": true}  
			last_point = segment2["end"]
		else:
			 # Move vertically
			segment1 = { "start": last_point , "end": next_vert, "animate": "x", "is_juncture": true  } 
			# Move horizontally
			segment2 = { "start": next_vert , "end": Vector2(next_vert.x + dx, next_vert.y), "animate": "x", "is_juncture": true  }  
			last_point = segment2["end"]

		segments.append(segment1)
		segments.append(segment2)

	return segments
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func generate_stepwise_segments(line_data: Array, segment_length: float = 5.0) -> Array:
	var segments: Array = []
	
	for line in line_data:
		var start_point = line["start"]
		var end_point = line["end"]
		
		# Calculate the direction and length of the line
		var direction = end_point - start_point
		var distance = direction.length()
		var steps = int(distance / segment_length)  # Number of steps based on the segment length
		
		# Normalize the direction
		direction = direction.normalized()
		
		# Generate the smaller segments
		for i in range(steps):
			# Calculate the start and end points of each segment
			var segment_start = start_point + direction * segment_length * i
			var segment_end = start_point + direction * segment_length * (i + 1)
			
			# Add this segment to the list
			segments.append({"start": segment_start, "end": segment_end, "animate": line.animate, "is_juncture": false})
		
		# Add the final segment (if any remainder distance)
		if steps * segment_length < distance:
			segments.append({"start": start_point + direction * segment_length * steps, "end": end_point, "animate": line.animate, "is_juncture": true})
	
	return segments
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------	
const rect_size:Vector2 = Vector2(15, 15)
const offset:Vector2 = Vector2(20, 48)

func _draw() -> void:
	if !render:return
	var line_color: Color = Color(0, 1, 0, 1) # Green
	var start_v2:Vector2 = get_start_vector.call()
	var leftside_pos:Vector2 = Vector2(275,  GBL.game_resolution.y/2)
	var rightside_pos:Vector2 = Vector2(GBL.game_resolution.x, 100)
	var header_pos:Vector2 = Vector2(start_v2.x + 20, 100)
	var footer_pos:Vector2 = Vector2(start_v2.x + 20, GBL.game_resolution.y - 175)

	if "label" in draw_dict:
		NamePanel.position = get_start_vector.call() - Vector2(20, 10)

	if !render_lines:return
	draw_list = []
	
	# ------------------------------------------------------
	if "use_nametag" in draw_dict and draw_dict.use_nametag:
		if !nametag_lock:
			nametag_lock = true
			Nametag.fade = false
			Nametag.index = previous_room_val			
		Nametag.position = get_start_vector.call() + Vector2(40, 60)
	# ------------------------------------------------------
	if "draw_to_research" in draw_dict and  draw_dict.draw_to_research:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, GBL.direct_ref["SciencePanel"].global_position + Vector2(20, 15), 1) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, start_v2 + offset, 1) ))
	if "draw_to_money" in draw_dict and draw_dict.draw_to_money:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, GBL.direct_ref["MoneyPanel"].global_position + Vector2(20, 15), 1) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, start_v2 + offset, 1) ))
	if "draw_to_material" in draw_dict and draw_dict.draw_to_material:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, GBL.direct_ref["MaterialPanel"].global_position + Vector2(20, 15), 1) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, start_v2 + offset, 1) ))
	if "draw_to_core" in draw_dict and draw_dict.draw_to_core:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, GBL.direct_ref["CorePanel"].global_position + Vector2(20, 15), 1) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, start_v2 + offset, 1) ))		
	# ------------------------------------------------------
	if "draw_to_energy" in draw_dict and draw_dict.draw_to_energy:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, GBL.direct_ref["EnergyPanel"].global_position + Vector2(20, 15), 1) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, start_v2 + offset, 1) ))
	if "draw_to_personnel" in draw_dict and draw_dict.draw_to_personnel:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, GBL.direct_ref["PersonnelPanel"].global_position + Vector2(70, 15), 1) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, start_v2 + offset, 1) ))
	# ------------------------------------------------------
	if "draw_to_morale" in draw_dict and draw_dict.draw_to_morale:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, GBL.direct_ref["MoralePanel"].global_position + Vector2(22, 15), 1) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, start_v2 + offset, 1) ))
	if "draw_to_safety" in draw_dict and draw_dict.draw_to_safety:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, GBL.direct_ref["SafetyPanel"].global_position + Vector2(22, 15), 1) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, start_v2 + offset, 1) ))		
	if "draw_to_readiness" in draw_dict and draw_dict.draw_to_readiness:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, GBL.direct_ref["ReadinessPanel"].global_position + Vector2(31, 15), 1) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(header_pos, start_v2 + offset, 1) ))
	# ------------------------------------------------------
	if "draw_to_hotkeys" in draw_dict and draw_dict.draw_to_hotkeys:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(footer_pos, GBL.direct_ref["HotkeyContainer"].global_position + Vector2(144, -55), 1) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(footer_pos, start_v2 + offset, 1) ))
	if "draw_to_center_btn_list" in draw_dict and draw_dict.draw_to_center_btn_list:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(footer_pos, GBL.direct_ref["CenterBtnList"].global_position + Vector2(60, -55), 1) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(footer_pos, start_v2 + offset, 1) ))		
	# ------------------------------------------------------
	if "draw_to_room_mini_card" in draw_dict and draw_dict.draw_to_room_mini_card:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(leftside_pos, GBL.direct_ref["RoomMiniCard"].global_position + Vector2(225, -30), 1, false) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(leftside_pos, start_v2 + offset, 1) ))
	if "draw_to_scp_mini_card" in draw_dict and draw_dict.draw_to_scp_mini_card:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(leftside_pos, GBL.direct_ref["ScpMiniCard"].global_position + Vector2(225, -30), 1, false) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(leftside_pos, start_v2 + offset, 1) ))
	if "draw_to_researcher_list" in draw_dict and draw_dict.draw_to_researcher_list:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(leftside_pos, GBL.direct_ref["ResearcherList"].global_position + Vector2(225, -30), 1, false) ))
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(leftside_pos, start_v2 + offset, 1) ))
	# ------------------------------------------------------
	if "draw_to_active_menu" in draw_dict and draw_dict.draw_to_active_menu:
		draw_list.push_back( generate_stepwise_segments( generate_stepwise_path(GBL.direct_ref["ActiveMenu"].global_position + Vector2(275, -20), start_v2 + offset, 1) ))
			
	for points in draw_list:	
		# Iterate backwards using the range function
		points.reverse()
		for index in points.size():
			if index < draw_count:
				var point:Dictionary = points[index]
				match point.animate:
					"x":
						draw_dashed_line(point.start, point.end, line_color, line_width)
					"y":
						draw_dashed_line(point.start, point.end, line_color, line_width)
				
	draw_rect(Rect2(start_v2 + offset - (rect_size/2), rect_size), line_color)
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------	
const MAX_DRAW:int = 500

func _physics_process(delta: float) -> void:
	if !render_lines:return
	# updates draw count every 300 ms so it builds it out in chunks
	if draw_count < MAX_DRAW:
		draw_count += draw_inc
		draw_inc += 1

func on_process_update(delta: float) -> void:	
	if !render:return
	queue_redraw() 
# --------------------------------------------------------------------------------------------------	
