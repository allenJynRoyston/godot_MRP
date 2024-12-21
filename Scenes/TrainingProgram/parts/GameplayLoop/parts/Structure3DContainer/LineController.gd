extends Control

var start_point: Vector2 : 
	set(val):
		start_point = val
		redraw()
		
var end_point: Vector2 : 
	set(val):
		end_point = val
		redraw()
		
var line_color: Color = Color(1, 0, 0)  # Red color
var line_width: float = 2.0

func redraw():	
	if !is_node_ready():return
	# Ensure the points are inside the Control's local space
	draw_line(start_point, GBL.mouse_pos, line_color, line_width)


func _process(delta:float) -> void:
	queue_redraw() 
