@tool
extends SubscribeWrapper

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
func generate_rand(min_val: int, max_val: int) -> int:
	return randi() % (max_val - min_val + 1) + min_val
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
func min_max(val:int, min_val:int, max_val:int, cycle_back:bool = false) -> int:
	var new_val:int = val
	if val > max_val:
		if cycle_back:
			new_val = min_val
		else:
			new_val = max_val
	if val < min_val:
		if cycle_back:
			new_val = max_val
		else:
			new_val = min_val
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
func tween_node_property(node:Node, prop:String, new_val, duration:float = 0.3, delay:float = 0, trans:int = Tween.TRANS_QUAD, ease:int = Tween.EASE_IN_OUT) -> void:
	if duration == 0:
		duration = 0.02
		
	var tween:Tween = create_tween()
	tween.tween_property(node, prop, new_val, duration).set_trans(trans).set_ease(ease).set_delay(delay)
	await tween.finished
# --------------------------------------------------------------------------------------------------		

# -----------------------------------------------
func tween_range(start_at:float, end_at:float, duration:float, callback:Callable = func(_val):pass) -> Tween:
	var tween:Tween = create_tween()
	#tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(callback, start_at, end_at, duration)
	return tween
# -----------------------------------------------	

# --------------------------------------------------------------------------------------------------
func inc_floor(wrap_around:bool = true) -> void:
	current_location.floor = U.min_max(current_location.floor - 1, 0, room_config.floor.size() - 1, wrap_around)
	SUBSCRIBE.current_location = current_location	
	
func dec_floor(wrap_around:bool = true) -> void:
	current_location.floor = U.min_max(current_location.floor + 1, 0, room_config.floor.size() - 1, wrap_around)
	SUBSCRIBE.current_location = current_location
	
func inc_ring(wrap_around:bool = true) -> void:
	current_location.ring = U.min_max(current_location.ring + 1, 0, 3, wrap_around)
	SUBSCRIBE.current_location = current_location	
	
func dec_ring(wrap_around:bool = true) -> void:
	current_location.ring = U.min_max(current_location.ring - 1, 0, 3, wrap_around)
	SUBSCRIBE.current_location = current_location		
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func room_up(allow_floor_change:bool = false, use_angle_table:bool = false) -> void:
	var room_index:int = location_lookup(current_location.room, U.DIR.UP, use_angle_table)
	if room_index == -1:	
		if current_location.floor - 1 >= 0 and allow_floor_change:
			var next_val:int = clampi(current_location.floor - 1, 0, room_config.floor.size() - 1)
			current_location.floor = next_val
			current_location.room =  4 if use_angle_table else U.location_lookup_opposite(current_location.room, U.DIR.UP)
	else:
		current_location.room = room_index
	SUBSCRIBE.current_location = current_location

func room_down(allow_floor_change:bool = false, use_angle_table:bool = false) -> void:
	var room_index:int = location_lookup(current_location.room, U.DIR.DOWN, use_angle_table)
	if room_index == -1:
		if current_location.floor + 1 < room_config.floor.size() - 1 and allow_floor_change:
			var next_val:int = clampi(current_location.floor + 1, 0, room_config.floor.size() - 1)
			current_location.floor = next_val
			current_location.room =  4 if use_angle_table else location_lookup_opposite(current_location.room, U.DIR.DOWN)
	else:
		current_location.room = room_index
	SUBSCRIBE.current_location = current_location

func room_right(allow_floor_change:bool = false, use_angle_table:bool = false) -> void:
	var room_index:int = location_lookup(current_location.room, U.DIR.RIGHT, use_angle_table)
	if room_index == -1:
		if current_location.ring < room_config.floor[current_location.floor].ring.size() - 1 and allow_floor_change:
			var next_val:int = clampi(current_location.ring + 1, 0, room_config.floor[current_location.floor].ring.size() - 1)
			current_location.ring = next_val
			current_location.room =  4 if use_angle_table else location_lookup_opposite(current_location.room, U.DIR.RIGHT)
	else:
		current_location.room = room_index	
	SUBSCRIBE.current_location = current_location

func room_left(allow_floor_change:bool = false, use_angle_table:bool = false) -> void:
	var room_index:int = location_lookup(current_location.room, U.DIR.LEFT, use_angle_table)
	if room_index == -1:
		if current_location.ring > 0 and allow_floor_change:
			var next_val:int = clampi(current_location.ring - 1, 0, room_config.floor[current_location.floor].ring.size() - 1)
			current_location.ring = next_val
			current_location.room =  4 if use_angle_table else location_lookup_opposite(current_location.room, U.DIR.LEFT)
	else:
		current_location.room = room_index	
	SUBSCRIBE.current_location = current_location
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func get_viewport_feed(viewport:SubViewport) -> ViewportTexture:
	return viewport.get_texture()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func get_viewport_texture(viewport:SubViewport) -> Texture2D:
	var viewport_capture:Image = viewport.get_texture().get_image()
	return ImageTexture.create_from_image(viewport_capture).duplicate()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func transition(TransitionRect:TextureRect, UseViewport:SubViewport, UseShader:ShaderMaterial) -> void:
	TransitionRect.show()
	TransitionRect.material = UseShader
	TransitionRect.texture = U.get_viewport_texture(UseViewport)
	await U.tween_range(0.0, 1.0, 0.3, func(val:float) -> void:
		TransitionRect.material.set_shader_parameter("sensitivity", val)
	).finished	
	TransitionRect.hide()
	TransitionRect.material = null
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func location_lookup_opposite(val:int, dir: DIR) -> int:
	match val:
		0:
			match dir:
				DIR.UP: return 3
				DIR.LEFT: return 5
		1:
			match dir:
				DIR.LEFT: return 7
		2:
			match dir:
				DIR.UP: return 7
		3:
			match dir:
				DIR.DOWN: return 0
				DIR.LEFT: return 8
		5:
			match dir:
				DIR.UP: return 8
				DIR.RIGHT: return 0
		6:
			match dir:
				DIR.DOWN: return 2
		7:
			match dir:				
				DIR.RIGHT: return 1
		8:
			match dir:
				DIR.DOWN: return 5
				DIR.RIGHT: return 3
		_:
			return -1
	return -1

	return -1
# --------------------------------------------------------------------------------------------------		

# -----------------------------------------------------------------------------------------------
func location_lookup(val: int, dir: DIR, use_angle_table:bool = false) -> int:
	match val:
		0:
			match dir:
				DIR.UP: return -1 if !use_angle_table else -1
				DIR.DOWN: return 1 if !use_angle_table else 4
				DIR.LEFT: return -1 if !use_angle_table else 1
				DIR.RIGHT: return 2 if !use_angle_table else 2
		1:
			match dir:
				DIR.UP: return 0 if !use_angle_table else 0
				DIR.DOWN: return 3 if !use_angle_table else 6
				DIR.LEFT: return -1 if !use_angle_table else 3
				DIR.RIGHT: return 4 if !use_angle_table else 2
		2:
			match dir:
				DIR.UP: return -1 if !use_angle_table else 0
				DIR.DOWN: return 4 if !use_angle_table else 7
				DIR.LEFT: return 0 if !use_angle_table else 1
				DIR.RIGHT: return 5 if !use_angle_table else 5
		3:
			match dir:
				DIR.UP: return 1 if !use_angle_table else 1
				DIR.DOWN: return -1 if !use_angle_table else 6
				DIR.LEFT: return -1 if !use_angle_table else -1
				DIR.RIGHT: return 6 if !use_angle_table else 4
		4:
			match dir:
				DIR.UP: return 2 if !use_angle_table else 0
				DIR.DOWN: return 6 if !use_angle_table else 8
				DIR.LEFT: return 1 if !use_angle_table else 3
				DIR.RIGHT: return 7 if !use_angle_table else 5
		5:
			match dir:
				DIR.UP: return -1 if !use_angle_table else 2
				DIR.DOWN: return 7 if !use_angle_table else 7
				DIR.LEFT: return 2 if !use_angle_table else 4
				DIR.RIGHT: return -1 if !use_angle_table else -1
		6:
			match dir:
				DIR.UP: return 4 if !use_angle_table else 1
				DIR.DOWN: return -1 if !use_angle_table else 8
				DIR.LEFT: return 3 if !use_angle_table else 3
				DIR.RIGHT: return 8 if !use_angle_table else 7
		7:
			match dir:
				DIR.UP: return 5 if !use_angle_table else 2
				DIR.DOWN: return 8 if !use_angle_table else 8
				DIR.LEFT: return 4 if !use_angle_table else 6 
				DIR.RIGHT: return -1 if !use_angle_table else 5
		8:
			match dir:
				DIR.UP: return 7 if !use_angle_table else 4
				DIR.DOWN: return -1 if !use_angle_table else -1
				DIR.LEFT: return 6 if !use_angle_table else 6
				DIR.RIGHT: return -1 if !use_angle_table else 7
	return val
# -----------------------------------------------------------------------------------------------



# ----------------------
func simulate_dyslexia(input_text: String) -> String:
	var words = input_text.split(" ")
	var distorted_words: Array[String] = []

	for word in words:
		var distorted_word = word

		# Scramble internal letters of the word (not first/last)
		if word.length() > 3 and randf() < 0.2:
			distorted_word = scramble_word(distorted_word)

		# Distort letters randomly
		var distorted_chars: Array[String] = []
		for ch in distorted_word:
			if randf() < 0.2:
				distorted_chars.append(distort_letter(ch))
			else:
				distorted_chars.append(ch)

		distorted_words.append("".join(distorted_chars))

	return " ".join(distorted_words)


func distort_letter(letter: String) -> String:
	var distortions := {
		"a": ["o", "e", "u"],
		"e": ["a", "o", "i"],
		"o": ["a", "e", "u"],
		"i": ["e", "o", "a"],
		"t": ["f", "l", "j"],
		"l": ["i", "t", "h"],
		"h": ["l", "u", "k"],
		"b": ["d", "p"],
		"d": ["b", "p"],
		"p": ["b", "d"]
	}
	letter = letter.to_lower()
	if distortions.has(letter):
		var options: Array = distortions[letter]
		return options[randi() % options.size()]
	return letter


func scramble_word(word: String) -> String:
	if word.length() <= 3:
		return word

	var first_char = word[0]
	var last_char = word[word.length() - 1]
	var middle_chars: Array[String] = []

	# Get middle characters as array
	for i in range(1, word.length() - 1):
		middle_chars.append(word[i])

	# Shuffle middle characters
	middle_chars.shuffle()

	return first_char + "".join(middle_chars) + last_char
# ----------------------

# ---------------------------------------------
func generate_flicker_pattern(count:int = 10) -> Array:
	var flickers := []
	for i in count:
		if randi() % 2 == 0:
			flickers.append(randf_range(0.02, 0.05))  # fast blink
		else:
			flickers.append(randf_range(0.05, 0.1))   # slightly slower
	return flickers
# ---------------------------------------------
