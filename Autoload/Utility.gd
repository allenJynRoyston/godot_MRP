@tool
extends Node

# ------------------------------------------------------------------------------
func generate_uid() -> String:
	return str(Time.get_unix_time_from_system()) + "_" + str(randf())
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func set_timeout(duration:float = 0.5) -> void:
	await get_tree().create_timer(duration * 1.0).timeout
	await get_tree().process_frame
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func tick() -> void:	
	await get_tree().create_timer(0.02).timeout
	await get_tree().process_frame
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func convert_to_normalized_position(container_size:Vector2, pos:Vector2) -> Vector2:
	return Vector2((pos.x / container_size.x * 1.0), (pos.y / container_size.y * 1.0) )
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func convert_from_normalized_position(container_size:Vector2, normalized_pos:Vector2) -> Vector2:
	return Vector2(container_size.x * normalized_pos.x, container_size.y * normalized_pos.y )
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func paginate_array(array:Array, start_at: int, limit: int) -> Array:
	if start_at >= array.size():
		return []  # Return an empty array if start_at is beyond the array size
	
	var count := 0
	var _list := []
	for index in array.size():		
		if index >= start_at:
			_list.push_back(array[index])
		count += 1
		if count > (start_at + limit - 1):
			break
	
	return _list
# ------------------------------------------------------------------------------		
