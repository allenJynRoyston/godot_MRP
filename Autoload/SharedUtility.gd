extends Node

# ------------------------------------------------------------------------------
func return_placement_instructions(item_data:Dictionary) -> Array:
	var list:Array = []
	
	if "floor_blacklist" in item_data.placement_restrictions:
		var title:String = "Can NOT be built on %s " % ["the " if item_data.placement_restrictions.floor_blacklist.size() == 1 else "floors"] 
		for index in item_data.placement_restrictions.floor_blacklist.size():
			var key:int = item_data.placement_restrictions.floor_blacklist[index]
			var last_in_list:bool = index == item_data.placement_restrictions.floor_blacklist.size() - 1
			var key_str:String = ""
			match key:
				ROOM.PLACEMENT.SURFACE:
					key_str = "SURFACE"
				ROOM.PLACEMENT.B1:
					key_str = "B1"
				ROOM.PLACEMENT.B2:
					key_str = "B2"	
				ROOM.PLACEMENT.B3:
					key_str = "B3"
				ROOM.PLACEMENT.B4:
					key_str = "B4"
				ROOM.PLACEMENT.B5:
					key_str = "B5"
			title += "%s" % [str("[", key_str, "]", '.') if last_in_list else str("[", key_str, "] ")]
		list.push_back({
			"title": title, "is_checked": func(current_location:Dictionary) -> bool:
				return current_location.floor not in item_data.placement_restrictions.floor_blacklist
		})	
		
	if "ring_blacklist" in item_data.placement_restrictions:
		var title:String = "Can NOT be built in %s " % ["the " if item_data.placement_restrictions.ring_blacklist.size() == 1 else "rings"] 
		for index in item_data.placement_restrictions.ring_blacklist.size():
			var key:int = item_data.placement_restrictions.ring_blacklist[index]
			var last_in_list:bool = index == item_data.placement_restrictions.ring_blacklist.size() - 1
			var key_str:String = ""
			match key:
				ROOM.PLACEMENT.RING_A:
					key_str = "RING A"
				ROOM.PLACEMENT.RING_B:
					key_str = "RING B"
				ROOM.PLACEMENT.RING_A:
					key_str = "RING C"	
			title += "%s" % [str("[", key_str, "]", '.') if last_in_list else str("[", key_str, "] ")]
		list.push_back({
			"title": title, "is_checked": func(current_location:Dictionary) -> bool:
				return current_location.floor not in item_data.placement_restrictions.ring_blacklist
		})			
	
	if "floor" in item_data.placement_restrictions:
		var title:String = "Can be built on %s " % ["the " if item_data.placement_restrictions.floor.size() == 1 else "floors"] 
		for index in item_data.placement_restrictions.floor.size():
			var key:int = item_data.placement_restrictions.floor[index]
			var last_in_list:bool = index == item_data.placement_restrictions.floor.size() - 1
			var key_str:String = ""
			match key:
				ROOM.PLACEMENT.SURFACE:
					key_str = "SURFACE"
				ROOM.PLACEMENT.B1:
					key_str = "B1"
				ROOM.PLACEMENT.B2:
					key_str = "B2"	
				ROOM.PLACEMENT.B3:
					key_str = "B3"
				ROOM.PLACEMENT.B4:
					key_str = "B4"
				ROOM.PLACEMENT.B5:
					key_str = "B5"
			title += "%s" % [str("[", key_str, "]", '.') if last_in_list else str("[", key_str, "] ")]
		list.push_back({
			"title": title, "is_checked": func(current_location:Dictionary) -> bool:
				return current_location.floor in item_data.placement_restrictions.floor
		})
		
	if "ring" in item_data.placement_restrictions:
		var title:String = "Can be built in %s " % ["ring" if item_data.placement_restrictions.ring.size() == 1 else "rings"] 
		for index in item_data.placement_restrictions.ring.size():
			var key:int = item_data.placement_restrictions.ring[index]
			var last_in_list:bool = index == item_data.placement_restrictions.ring.size() - 1
			var key_str:String = ""
			match key:
				ROOM.PLACEMENT.RING_A:
					key_str = "RING A"
				ROOM.PLACEMENT.RING_B:
					key_str = "RING B"
				ROOM.PLACEMENT.RING_C:
					key_str = "RING C"	
			title += "%s" % [str("[", key_str, "]", '.') if last_in_list else str("[", key_str, "] ")]
		list.push_back({
			"title": title, "is_checked": func(current_location:Dictionary) -> bool:
				return current_location.ring in item_data.placement_restrictions.ring
		})		
		
	if "room" in item_data.placement_restrictions:
		var title:String = "Can be built in %s " % ["room" if item_data.placement_restrictions.room.size() == 1 else "rooms"] 
		for index in item_data.placement_restrictions.room.size():
			var key:int = item_data.placement_restrictions.room[index]
			var last_in_list:bool = index == item_data.placement_restrictions.room.size() - 1
			var key_str:String = ""
			match key:
				ROOM.PLACEMENT.R1:
					key_str = "ROOM 1"
				ROOM.PLACEMENT.R2:
					key_str = "ROOM 2"
				ROOM.PLACEMENT.R3:
					key_str = "ROOM 3"
				ROOM.PLACEMENT.R4:
					key_str = "ROOM 4"
				ROOM.PLACEMENT.R5:
					key_str = "ROOM 5"
			title += "%s" % [str("[", key_str, "]", '.') if last_in_list else str("[", key_str, "] ")]
		list.push_back({
			"title": title, "is_checked": func(current_location:Dictionary) -> bool:
				return current_location.room in item_data.placement_restrictions.room
		})	
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_unavailable_placement(item_data:Dictionary, room_config:Dictionary) -> Array: 
	var unavailable_list:Array = []
	
	for floor_index in room_config.floor.size():
		for ring_index in room_config.floor[floor_index].ring.size():
			for room_index in room_config.floor[floor_index].ring[ring_index].room.size():
				var designation:String = "%s%s%s" % [floor_index, ring_index, room_index]
				var config_data:Dictionary = room_config.floor[floor_index].ring[ring_index].room[room_index]	
				var placement_restrictions:Dictionary = item_data.placement_restrictions
				
				# if building already exists or has something being constructed
				if !config_data.room_data.is_empty() or !config_data.build_data.is_empty():
					if designation not in unavailable_list:
						unavailable_list.push_back(designation)
				
				# check for blacklists
				if "floor_blacklist" in item_data.placement_restrictions:
					if floor_index in item_data.placement_restrictions.floor_blacklist:
						if designation not in unavailable_list:
							unavailable_list.push_back(designation)
				if "ring_blacklist" in item_data.placement_restrictions:
					if ring_index in item_data.placement_restrictions.ring_blacklist:
						if designation not in unavailable_list:
							unavailable_list.push_back(designation)
				if "room_blacklist" in item_data.placement_restrictions:
					if room_index in item_data.placement_restrictions.room_blacklist:
						if designation not in unavailable_list:
							unavailable_list.push_back(designation)				
							
				# check for individual f/r/ro			
				if "floor" in item_data.placement_restrictions:
					if floor_index not in item_data.placement_restrictions.floor:
						if designation not in unavailable_list:
							unavailable_list.push_back(designation)
				if "ring" in item_data.placement_restrictions:
					if ring_index not in item_data.placement_restrictions.ring:
						if designation not in unavailable_list:
							unavailable_list.push_back(designation)
				if "room" in item_data.placement_restrictions:
					if room_index not in item_data.placement_restrictions.room:
						if designation not in unavailable_list:
							unavailable_list.push_back(designation)
	
	
	return unavailable_list
# ------------------------------------------------------------------------------	
