extends Control

var start_point: Vector2 
var end_point: Vector2 
		
@export var line_color: Color = Color(1, 0, 0)  # Red color
@export var line_width: float = 2.0

var draw_data:Dictionary = {} 
var draw_keys:Array = [] : 
	set(val):
		draw_keys = val
		on_draw_keys_update()

func _draw() -> void:	
	for key in draw_data:
		for line_data in draw_data[key]:
			var sp:Vector2 = line_data.start_point
			var ep:Vector2 = line_data.end_point
			draw_line(sp, ep, line_color, line_width)

func update_line_data(line_data:Dictionary) -> void:
	if line_data.key not in draw_data:
		draw_data[line_data.key] = []
	draw_data[line_data.key] = line_data.lines
	
func on_draw_keys_update() -> void:	
	for key in draw_data:
		if key not in draw_keys:
			draw_data.erase(key)

func _process(delta:float) -> void:
	queue_redraw() 
