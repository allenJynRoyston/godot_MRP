extends SubscribeWrapper

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
func return_unavailable_rooms(item_data:Dictionary) -> Array: 
	var unavailable_list:Array = []

	for floor_index in room_config.floor.size():
		for ring_index in room_config.floor[floor_index].ring.size():
			for room_index in room_config.floor[floor_index].ring[ring_index].room.size():
				var designation:String = "%s%s%s" % [floor_index, ring_index, room_index]
				var config_data:Dictionary = room_config.floor[floor_index].ring[ring_index].room[room_index]	
				var scp_data:Dictionary = config_data.scp_data
				
				# ------------------------------------------
				if !scp_data.is_empty():
					if designation not in unavailable_list:
						unavailable_list.push_back(designation)
				# ------------------------------------------
				
				# ------------------------------------------
				if "placement_restrictions" in item_data:
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
				# ------------------------------------------
					
				## ------------------------------------------
				#if "containment_requirements" in item_data:
					#var containment_requirements:Array = item_data.containment_requirements
					#
					## checks if any other items are being contained or will be contained in a location
					#if !scp_data.is_empty():
						#for item in scp_data.available_list:
							#if item.transfer_status.state:
								#var location:Dictionary = item.transfer_status.location
								#if location.floor == floor_index and location.ring == ring_index and location.room == room_index:
									#unavailable_list.push_back(designation)
						#
						#for item in scp_data.contained_list:
							#var location:Dictionary = item.location
							#if location.floor == floor_index and location.ring == ring_index and location.room == room_index:
								#unavailable_list.push_back(designation)
							#if item.transfer_status.state:
								#location = item.transfer_status.location
								#if location.floor == floor_index and location.ring == ring_index and location.room == room_index:
									#unavailable_list.push_back(designation)
								#
					##if !config_data.room_data.is_empty():
						##if config_data.room_data.ref not in containment_requirements:
							##unavailable_list.push_back(designation)
					##else:
						##unavailable_list.push_back(designation)
				# ------------------------------------------
	
	return unavailable_list
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func return_resource_list(details:Dictionary, dict_property:String) -> Array:
	var list:Array = []
	if dict_property in details and "resources" in details[dict_property] :
		if "personnel" in details[dict_property].resources:
			var amount_dict:Dictionary = details[dict_property].resources.personnel.call()
			for key in amount_dict:	
				var amount:int = amount_dict[key]
				list.push_back({"type": "amount", "amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
						
		if "amount" in details[dict_property].resources:
			var amount_dict:Dictionary = details[dict_property].resources.amount.call()
			for key in amount_dict:	
				var amount:int = amount_dict[key]
				list.push_back({"type": "amount", "amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
				
		if "capacity" in details[dict_property].resources:
			var capacity_dict:Dictionary = details[dict_property].resources.capacity.call()
			for key in capacity_dict:	
				var amount:int = capacity_dict[key]
				list.push_back({"type": "capacity", "amount": amount, "resource": RESOURCE_UTIL.return_data(key)})	
				
		if "metrics" in details[dict_property].resources:
			var metrics_dict:Dictionary = details[dict_property].resources.metrics.call()
			for key in metrics_dict:	
				var amount:int = metrics_dict[key]
				list.push_back({"type": "metrics", "amount": amount, "resource": RESOURCE_UTIL.return_metric_data(key)})
				
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_tier_dict(tier_data:Dictionary) -> Dictionary:
	var list:Array = []
	for ref in tier_data:
		list.push_back({
			"ref": ref, 
			"details": tier_data[ref] 
		})
	return {"list": list}		
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_tier_paginated(reference_data:Dictionary, filter:Callable, start_at:int, limit:int) -> Dictionary:
	var list:Array = []
	
	for ref in reference_data:
		list.push_back({
			"ref": ref, 
			"details": reference_data[ref] 
		})

	# filter for tier
	list = filter.call(list)
	
	var paginated_array:Array = U.paginate_array(list, start_at, limit)

	return {
		"list": paginated_array, 
		"size": list.size(), 
		"has_more": list.size() > (paginated_array.size() + start_at)
	}	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_resources(details:Dictionary, dict_property:String, resources_data:Dictionary, refund:bool = false) -> Dictionary:	
	var resource_data_copy:Dictionary = resources_data.duplicate(true)
	
	if dict_property in details and "resources" in details[dict_property]:
		#if "capacity" in details[dict_property].resources:
			#var capacity_dict:Dictionary = details[dict_property].resources.capacity.call()
			#for key in capacity_dict:
				#var amount:int = capacity_dict[key]
				#if refund:
					#resource_data_copy[key].capacity -= amount
					#if resource_data_copy[key].capacity < 0:
						#resource_data_copy[key].capacity = 0
				#else:
					#resource_data_copy[key].capacity += amount
					#if resource_data_copy[key].capacity > 999:
						#resource_data_copy[key].capacity = 999
				
		if "amount" in details[dict_property].resources:
			var amount_dict:Dictionary = details[dict_property].resources.amount.call()
			for key in amount_dict:
				var amount:int = amount_dict[key]
				
				if refund:
					resource_data_copy[key].amount -= amount
					if resource_data_copy[key].amount < 0:
						resource_data_copy[key].amount = 0
				else:
					resource_data_copy[key].amount += amount
					if resource_data_copy[key].amount > resource_data_copy[key].capacity:
						resource_data_copy[key].amount = resource_data_copy[key].capacity	
		
		#if "amount" in details[dict_property].resources:
						
	return resource_data_copy
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_wing_effects_list(details:Dictionary, room_extract:Dictionary, property_name:String) -> Array:
	var list:Array = []
	if "wing_effect" in details:
		var wing_effects:Dictionary =  details.wing_effect.call(room_extract)
		for key in wing_effects:
			var amount:int = wing_effects[key]
			var resource_data:Dictionary = RESOURCE_UTIL.return_metric_data(key)
			
			match key:
				RESOURCE.BASE_METRICS.MORALE:
					list.push_back({"resource_data": resource_data, "property": "metrics", "amount": amount})
				RESOURCE.BASE_METRICS.READINESS:
					list.push_back({"resource_data": resource_data, "property": "metrics", "amount": amount})
				RESOURCE.BASE_METRICS.SAFETY:
					list.push_back({"resource_data": resource_data, "property": "metrics", "amount": amount})	
						
	#if property_name in details and "resources" in details[property_name]:
		#for property in ["capacity", "amount"]:
			#if property in details[property_name].resources:
				#var dict:Dictionary = details[property_name].resources[property].call()
				#for key in dict:
					#var amount:int = dict[key]
					#var resource_data:Dictionary = RESOURCE_UTIL.return_data(key)
					#list.push_back({"resource_data": resource_data, "property": property, "amount": amount})

									
	return list
# ------------------------------------------------------------------------------
