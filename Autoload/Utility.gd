@tool
extends Node

# ------------------------------------------------------------------------------
func generate_rand(min: int, max: int) -> int:
	return randi() % (max - min + 1) + min
# ------------------------------------------------------------------------------
	
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

# ------------------------------------------------------------------------------		
func dict_has_diff(new_val:Dictionary, current:Dictionary, list_property:String, properties:Array) -> Dictionary:
	if list_property not in new_val:
		return {"error": true}
	
	var list:Array = new_val[list_property]
	var index_diff:Array = []
	for index in list.size():
		if list_property not in current:
			index_diff.push_back(index)
		else:
			if list_property not in current:
				index_diff.push_back(index)
			else:
				var new_item_val = list[index]
				var current_val = current[list_property][index]
				
				for prop in properties:
					if prop not in new_item_val:
						return {"error": true}
					else:
						if prop not in current_val:
							index_diff.push_back(index)
						else:
							current_val = current_val[prop]
							new_item_val = new_item_val[prop]
				
				if (current_val != new_item_val) and (index not in index_diff):
					index_diff.push_back(index)

		
	return {"error": false, "updated_index": index_diff}
# ------------------------------------------------------------------------------		
	
	
