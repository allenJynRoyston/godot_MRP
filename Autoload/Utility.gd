@tool
extends UtilityWrapper

enum DIR {UP, DOWN, LEFT, RIGHT}

var debounce_timers := {}

# ------------------------------------------------------------------------------
func debounce(key: String, callback: Callable, delay: float = 0.02):
	# If there's an existing timer, cancel it
	if key in debounce_timers and debounce_timers[key]:
		debounce_timers[key].timeout.disconnect(debounce_timers[key].get_meta("callback"))

	# Create a new timer
	var timer = get_tree().create_timer(delay)
	timer.set_meta("callback", callback)

	# Connect the timeout signal to execute the callback
	timer.timeout.connect(callback)

	# Store the timer in the dictionary
	debounce_timers[key] = timer
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func generate_rand(min: int, max: int) -> int:
	return randi() % (max - min + 1) + min
# ------------------------------------------------------------------------------
	
# ------------------------------------------------------------------------------
func generate_uid() -> String:
	return str(Time.get_unix_time_from_system()).substr(0, 6) + str(randi())
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
func min_max(val:int, min:int, max:int, cycle_back:bool = false) -> int:
	var new_val:int = val
	if val > max:
		if cycle_back:
			new_val = min
		else:
			new_val = max
	if val < min:
		if cycle_back:
			new_val = max
		else:
			new_val = min
	return new_val
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func array_find_uniques(arr:Array) -> Array:
	var unique_array:Array = []

	for element in arr:
		if element not in unique_array:
			unique_array.append(element)
	
	return unique_array
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func array_has_overlap(arr_one:Array, arr_two:Array) -> bool:
	for n in arr_one:
		if n in arr_two:
			return true
	return false
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func location_to_designation(location:Dictionary) -> String:
	return "%s%s%s" % [location.floor, location.ring, location.room]
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
func dictionaries_equal(dict1: Dictionary, dict2: Dictionary) -> bool:
	return JSON.stringify(dict1) == JSON.stringify(dict2)
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------		
# THIS DOESN'T WORK YET
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
	
# --------------------------------------------------------------------------------------------------		
func tween_node_property(node:Node, prop:String, new_val, duration:float = 0.3, delay:float = 0, trans:int = Tween.TRANS_QUAD) -> void:
	var tween:Tween = create_tween()
	tween.tween_property(node, prop, new_val, duration).set_trans(trans).set_delay(delay)
	await tween.finished
# --------------------------------------------------------------------------------------------------		

# -----------------------------------------------
func tween_range(start_at:float, end_at:float, duration:float, callback:Callable = func(_val):pass) -> Tween:
	var tween:Tween = create_tween()
	#tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_method(callback, start_at, end_at, duration)
	return tween
# -----------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func dict_deep_copy(value):
	var new_dict:Dictionary = {}
	for key in value:
		var assign:Callable = func():
			return value[key]
		new_dict[key] = assign.call()
		
	#if value is Dictionary:
		#var new_dict:Dictionary = {}
		#for key in value.keys():
			#new_dict[key] = dict_deep_copy(value[key])  # Recursively copy values
		#return new_dict
	#elif value is Array:
		#var new_array = []
		#for item in value:
			#new_array.append(dict_deep_copy(item))  # Recursively copy items
		#return new_array
	#elif value is Object and value.duplicate != null:
		#return value.duplicate(true)  # Duplicate resources like textures/materials
	#else:
		#return value
		
	return new_dict
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func room_up() -> void:
	var room_index:int = U.location_lookup(current_location.room, U.DIR.UP)
	if room_index == -1:
		if current_location.floor - 1 >= 0:
			var next_val:int = clampi(current_location.floor - 1, 0, room_config.floor.size() - 1)
			current_location.floor = next_val
			current_location.room = 4
	else:
		current_location.room = room_index
	SUBSCRIBE.current_location = current_location

func room_down() -> void:
	var room_index:int = U.location_lookup(current_location.room, U.DIR.DOWN)
	if room_index == -1:
		if current_location.floor + 1 < room_config.floor.size() - 1:
			var next_val:int = clampi(current_location.floor + 1, 0, room_config.floor.size() - 1)
			current_location.floor = next_val
			current_location.room = 4	
	else:
		current_location.room = room_index
	SUBSCRIBE.current_location = current_location

func room_right() -> void:
	var room_index:int = U.location_lookup(current_location.room, U.DIR.RIGHT)
	if room_index == -1:
		if current_location.ring < room_config.floor[current_location.floor].ring.size() - 1:
			var next_val:int = clampi(current_location.ring + 1, 0, room_config.floor[current_location.floor].ring.size() - 1)
			current_location.ring = next_val
			current_location.room = 4	
	else:
		current_location.room = room_index	
	SUBSCRIBE.current_location = current_location

func room_left() -> void:
	var room_index:int = U.location_lookup(current_location.room, U.DIR.LEFT)
	if room_index == -1:
		if current_location.ring > 0:
			var next_val:int = clampi(current_location.ring - 1, 0, room_config.floor[current_location.floor].ring.size() - 1)
			current_location.ring = next_val
			current_location.room = 4
	else:
		current_location.room = room_index	
	SUBSCRIBE.current_location = current_location
# --------------------------------------------------------------------------------------------------		

# -----------------------------------------------------------------------------------------------
func location_lookup(val:int, dir:DIR) -> int:
	match val:
		0:
			match dir:
				DIR.UP: return -1
				DIR.DOWN: return 4
				DIR.LEFT: return 1
				DIR.RIGHT: return 2
		1:
			match dir:
				DIR.UP: return 0
				DIR.DOWN: return 6
				DIR.LEFT: return 3
				DIR.RIGHT: return 2
		2:
			match dir:
				DIR.UP: return 0
				DIR.DOWN: return 7
				DIR.LEFT: return 1
				DIR.RIGHT: return 5	
		3:
			match dir:
				DIR.UP: return 1
				DIR.DOWN: return 6
				DIR.LEFT: return -1
				DIR.RIGHT: return 4
		4:
			match dir:
				DIR.UP: return 0
				DIR.DOWN: return 8
				DIR.LEFT: return 3
				DIR.RIGHT: return 5
		5:
			match dir:
				DIR.UP: return 2
				DIR.DOWN: return 7
				DIR.LEFT: return 4
				DIR.RIGHT: return -1
		6:
			match dir:
				DIR.UP: return 1
				DIR.DOWN: return 8
				DIR.LEFT: return 3
				DIR.RIGHT: return 7
		7:
			match dir:
				DIR.UP: return 2
				DIR.DOWN: return 8
				DIR.LEFT: return 6
				DIR.RIGHT: return 5
		8:
			match dir:
				DIR.UP: return 4
				DIR.DOWN: return -1
				DIR.LEFT: return 6
				DIR.RIGHT: return 7
	
	return val
# -----------------------------------------------------------------------------------------------
