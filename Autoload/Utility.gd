extends Node

# ------------------------------------------------------------------------------
func set_timeout(duration:float = 0.5) -> void:
	await get_tree().create_timer(duration * 1.0).timeout
	await get_tree().process_frame
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
# takes 
func calculate_resource_properties(resource_data:Dictionary, built_data:Dictionary, containment_data:Dictionary) -> Dictionary:
	var resources_copy:Dictionary = resource_data.duplicate(true)
	
	var diff = {
		RESOURCE.MONEY: {
			"net": 0,
			"capacity": 999,
			"utilized": 0
		},
		RESOURCE.ENERGY: {
			"net": 0,
			"capacity": 0,
			"utilized": 0
		},
		RESOURCE.STAFF: {
			"net": 0,
			"capacity": 0,
			"utilized": 0
		},
		RESOURCE.MTF: {
			"net": 0,
			"capacity": 0,
			"utilized": 0
		},
		RESOURCE.DCLASS: {
			"net": 0,
			"capacity": 0,
			"utilized": 0
		}
	}
	
	# calculate reward based off built rooms
	for key in built_data:
		var built_list:Array = built_data[key]
		for item in built_list:
			var building:Dictionary = B.return_resources(item.type)
			for prop in ["net", "capacity"]:
				if prop in building:
					var dict:Dictionary = building[prop]
					for resource_key in dict:
						diff[resource_key][prop] += dict[resource_key]
						
	# calculate reward for SCP's contained
	for item in containment_data.active:
		if item.status.is_contained: 
			var scp_data = C.get_reference_data(item.item)
			if "containment_reward" in scp_data:
				var arr:Array = scp_data.containment_reward
				for reward in arr:
					var resource_key = reward[0]
					var amount = reward[1]
					diff[resource_key].net += amount
			if "required_resources" in scp_data:
				var arr:Array = scp_data.required_resources
				for requirement in arr:				
					var resource_key = requirement[0]
					var amount = requirement[1]
					diff[resource_key].utilized += amount					

	# add diff to resource_copy
	for type in [RESOURCE.MONEY, RESOURCE.ENERGY, RESOURCE.STAFF, RESOURCE.MTF, RESOURCE.DCLASS]:
		resources_copy[type].net = diff[type].net
		resources_copy[type].capacity = diff[type].capacity
		resources_copy[type].utilized = diff[type].utilized
		
	return resources_copy
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_building_costs(resource_data:Dictionary, purchase_list:Array) -> Dictionary:
	var resources_copy:Dictionary = resource_data.duplicate(true)

	var diff = {
		RESOURCE.MONEY: 0,
		RESOURCE.ENERGY: 0,
		RESOURCE.STAFF: 0,
		RESOURCE.MTF: 0,
		RESOURCE.DCLASS: 0
	}
	
	var new_totals = {
		RESOURCE.MONEY: 0,
		RESOURCE.ENERGY: 0,
		RESOURCE.STAFF: 0,
		RESOURCE.MTF: 0,
		RESOURCE.DCLASS: 0,
	}
		
	for item in purchase_list:
		var building:Dictionary = B.return_resources(item.type)
		if "build_cost" in building:
			var dict:Dictionary = building.build_cost
			for resource_key in dict:
				diff[resource_key] += dict[resource_key]	
				
	for resource_key in diff:
		var val = diff[resource_key]
		resources_copy[resource_key].total -= val
	
	var can_afford:bool = true
	for resource_key in resources_copy:
		new_totals[resource_key] = resources_copy[resource_key].total

		if can_afford and resources_copy[resource_key].total < 0:
			can_afford = false
	
	return {
		"can_afford": can_afford,
		"new_totals": new_totals
	}
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func calculate_end_of_phase(resource_data:Dictionary, built_data:Dictionary) -> Dictionary:
	var resources_copy = resource_data.duplicate(true)

	var diff = {
		RESOURCE.MONEY: 0,
		RESOURCE.ENERGY: 0,
		RESOURCE.STAFF: 0,
		RESOURCE.MTF: 0,
		RESOURCE.DCLASS: 0
	}
	
	for key in built_data:
		var built_list:Array = built_data[key]
		for item in built_list:
			var building:Dictionary = B.return_resources(item.type)
			if "net" in building:
				var dict:Dictionary = building.net
				for resource_key in dict:
					diff[resource_key] += dict[resource_key]	
	
	for resource_key in diff:
		var val = diff[resource_key]
		resources_copy[resource_key].total += val
	
	return resources_copy
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calc_purchases(base_data:Dictionary, resource_data:Dictionary, containment_data:Dictionary, results:Dictionary) -> Dictionary:
	var resources_copy = resource_data.duplicate(true)
	var base_data_copy = base_data.duplicate(true)
	
	for item in results.purchased:
		base_data_copy.built[item.on_floor].push_back({"type": item.type, "props": {}})
	base_data_copy.purchase_list = []
	
	## first, subtract building costs
	resources_copy = merge_resource_totals(resources_copy, results.new_totals)
		
	## then calculate new cost properties
	resources_copy = calculate_resource_properties(resources_copy, base_data_copy.built, containment_data)	

	return {"base_data": base_data_copy, "resources": resources_copy}
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func merge_resource_totals(resource_data:Dictionary, new_totals:Dictionary) -> Dictionary:
	var resources_copy = resource_data.duplicate(true)
	
	for resource_key in resources_copy:
		if resource_key in new_totals:
			resources_copy[resource_key].total = new_totals[resource_key]

	return resources_copy
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func adjust_resources(resource_data:Dictionary, arr:Array) -> Dictionary:
	var resources_copy = resource_data.duplicate(true)
	
	for item in arr:
		var key = item[0]
		var amount = item[1]
		
		if key in resources_copy:
			resources_copy[key].total += amount
			if "capacity" in resources_copy[key]:
				if resources_copy[key].total > resources_copy[key].capacity:
					resources_copy[key].total = resources_copy[key].capacity
				if resources_copy[key].total < 0:
					resources_copy[key].total = 0
					
	return resources_copy
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func containment_data_move_available_to_active(containment_data:Dictionary, resource_data:Dictionary, selected:Array) -> Dictionary:
	var resource_copy:Dictionary = resource_data.duplicate(true)
	var containment_data_copy:Dictionary = containment_data.duplicate(true)
	
	var remove_from_available := []
	for n in selected:
		var i:Dictionary = containment_data_copy.available[n]
		remove_from_available.push_back(i.item)
		# adjust resources
		var required_resources = C.get_reference_data(i.item).required_resources
		for item in required_resources:
			var key:int = item[0]
			var amount:int = item[1]
			resource_copy[key].utilized += amount			
			
		# add new active item
		var move_to_active := {
			"item": i.item,
			"status": {
				"is_contained": 'pending',
				"days_in_containment": 0,
			},
			"placement": {
				"on_floor": 0
			},
			"assigned": {
				"staff": 0,
				"dclass": 0
			}
		}
		containment_data_copy.active.push_back(move_to_active)
	
	# then remove from available list
	containment_data_copy.available = containment_data_copy.available.filter(func(i):
		return i.item not in remove_from_available
	)

	return {
		"resource_data": resource_copy, 
		"containment_data": containment_data_copy
	}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func inc_containment(containment_data:Dictionary) -> Dictionary:
	var containment_data_copy = containment_data.duplicate(true)
	
	# checks for expired 
	containment_data_copy.available = containment_data_copy.available.map(func(item): 
		item.expires_in -= 1
		return item
	)
	
	# filter out expired
	var availables_expired = containment_data_copy.available.filter(func(item): 
		return item.expires_in < 0	
	)
	
	# removes from list
	containment_data_copy.available = containment_data_copy.available.filter(func(item): 
		return item.expires_in >= 0
	)	
	
	# check active list and adds day to their containment
	containment_data_copy.active = containment_data_copy.active.map(func(item): 
		item.status.days_in_containment += 1
		return item
	)

	return {
		"containment_data": containment_data_copy,
		"availables_expired": availables_expired
	}
# ------------------------------------------------------------------------------
