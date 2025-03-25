extends PanelContainer

const line_color: Color = Color(0, 1, 0, 1) # Green
const line_width: float = 2.0

var center_point:Vector2
var draw_list:Array = [] 
var render:bool = false

# --------------------------------------------------------------------------------------------------	
func _init() -> void:
	GBL.subscribe_to_process(self)
	GBL.subscribe_to_fullscreen(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)
	GBL.unsubscribe_to_fullscreen(self)
	
func _ready() -> void:
	GBL.register_node(REFS.LINE_DRAW, self)
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
const offset:Vector2 = Vector2(0, 0)

func add(_center_point:Vector2, draw_ability:bool = false, draw_passive:bool = false, draw_resource:bool = false, draw_energy:bool = false, draw_funding:bool = false) -> void:
	draw_list = []
	center_point = _center_point


	draw_list.push_back( generate_stepwise_path(center_point + offset + Vector2(0, -10), GBL.node_location_dict["ResourcesPanel"] + Vector2(70, 15), 1) )
	draw_list.push_back( generate_stepwise_path(center_point + offset + Vector2(0, -5), GBL.node_location_dict["EnergyPanel"] + Vector2(20, 15), 1) )
	draw_list.push_back( generate_stepwise_path(center_point + offset + Vector2(0, 5), GBL.node_location_dict["ResearchPanel"] + Vector2(20, 15), 1) )
	draw_list.push_back( generate_stepwise_path(center_point + offset + Vector2(0, 10), GBL.node_location_dict["FundsPanel"] + Vector2(20, 15), 1) )
	#
	draw_list.push_back( generate_stepwise_path(center_point + offset + Vector2(0, -5), GBL.node_location_dict["AbilityBtn"] + Vector2(23, -53), 1) )
	draw_list.push_back( generate_stepwise_path(center_point + offset + Vector2(0, 5), GBL.node_location_dict["PassiveBtn"] + Vector2(23, -53), 1) )
	
	draw_list.push_back( generate_stepwise_path(center_point + offset + Vector2(0, -10), GBL.node_location_dict["RoomMiniCard"] + Vector2(180, -22), 1, false) )
	draw_list.push_back( generate_stepwise_path(center_point + offset + Vector2(-5, -10), GBL.node_location_dict["ScpMiniCard"] + Vector2(180, 15), 1, false) )	
	
	
	
	render = true
	queue_redraw()
# --------------------------------------------------------------------------------------------------	



# --------------------------------------------------------------------------------------------------	
func clear() -> void:
	draw_list = []
	render = false
	queue_redraw()	
# --------------------------------------------------------------------------------------------------		
	

# --------------------------------------------------------------------------------------------------
func generate_stepwise_path(start_point: Vector2, end_point: Vector2, steps: int, horz_pref: bool = true) -> Array:
	var points = [start_point]  # Start with the initial point
	var dx = (end_point.x - start_point.x) / float(steps)  # Horizontal step size
	var dy = (end_point.y - start_point.y) / float(steps)  # Vertical step size

	for i in range(steps):
		var last_point = points[-1]

		# Compute next steps
		var next_horiz = Vector2(last_point.x + dx, last_point.y)
		var next_vert = Vector2(last_point.x, last_point.y + dy)

		# Append points based on preference
		if horz_pref:
			points.append(next_horiz)  # Move horizontally first
			points.append(Vector2(next_horiz.x, next_horiz.y + dy))  # Then vertically
		else:
			points.append(next_vert)  # Move vertically first
			points.append(Vector2(next_vert.x + dx, next_vert.y))  # Then horizontally

	return points

# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------	
const rect_size:Vector2 = Vector2(30, 30)
func _draw() -> void:
	if render:
		draw_rect(Rect2(center_point + offset - (rect_size/2), rect_size), line_color)  # Red color for the square
		
	for points in draw_list:
		draw_polyline(points, line_color, line_width)
# --------------------------------------------------------------------------------------------------	
