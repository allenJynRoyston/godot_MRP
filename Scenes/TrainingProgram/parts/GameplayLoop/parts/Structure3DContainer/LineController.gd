extends Control

var start_point: Vector2 
var end_point: Vector2 
		
@export var line_color: Color = Color(1, 0, 0)  # Red color
@export var line_width: float = 2.0

func _draw():	
	draw_line(start_point, end_point, line_color, line_width)

func update_line_vectors(sp:Vector2, ep:Vector2) -> void:
	start_point = sp
	end_point = ep

func redraw():	
	if !is_node_ready():return
	# Ensure the points are inside the Control's local space
	draw_line(start_point, GBL.mouse_pos, line_color, line_width)


func _process(delta:float) -> void:
	queue_redraw() 
