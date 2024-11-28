extends Node

enum { MONEY, ENERGY, STAFF, DCLASS, MTF }

# ------------------------------------------------------------------------------
func calculate_properties(resources:Dictionary, built:Dictionary, containment_data:Dictionary) -> Dictionary:
	var resources_copy:Dictionary = resources.duplicate(true)
	
	var diff = {
		MONEY: {
			"net": 0,
			"capacity": 999,
			"utilized": 0
		},
		ENERGY: {
			"net": 0,
			"capacity": 0,
			"utilized": 0
		},
		STAFF: {
			"net": 0,
			"capacity": 0,
			"utilized": 0
		},
		MTF: {
			"net": 0,
			"capacity": 0,
			"utilized": 0
		},
		DCLASS: {
			"net": 0,
			"capacity": 0,
			"utilized": 0
		}
	}
	
	# calculate reward based off built rooms
	for key in built:
		var built_list:Array = built[key]
		for type in built_list:
			var building:Dictionary = Buildables.return_resources(type)
			for prop in ["net", "capacity"]:
				if prop in building:
					var dict:Dictionary = building[prop]
					for resource_key in dict:
						diff[resource_key][prop] += dict[resource_key]
						
	# calculate reward for SCP's contained
	for item in containment_data.active:
		if item.is_contained:
			var scp_data = SCP.get_reference_data(item.ref)
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
	for type in [MONEY, ENERGY, STAFF, MTF, DCLASS]:
		resources_copy[type].net = diff[type].net
		resources_copy[type].capacity = diff[type].capacity
		resources_copy[type].utilized = diff[type].utilized
		
	return resources_copy
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_building_costs(resources:Dictionary, purchase_list:Array) -> Dictionary:
	var resources_copy:Dictionary = resources.duplicate(true)

	var diff = {
		MONEY: 0,
		ENERGY: 0,
		STAFF: 0,
		MTF: 0,
		DCLASS: 0
	}
	
	var new_totals = {
		MONEY: 0,
		ENERGY: 0,
		STAFF: 0,
		MTF: 0,
		DCLASS: 0,
	}
		
	for item in purchase_list:
		var building:Dictionary = Buildables.return_resources(item.type)
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
func calculate_end_of_phase(resources:Dictionary, built:Dictionary) -> Dictionary:
	var resources_copy = resources.duplicate(true)

	var diff = {
		MONEY: 0,
		ENERGY: 0,
		STAFF: 0,
		MTF: 0,
		DCLASS: 0
	}
	
	for key in built:
		var built_list:Array = built[key]
		for type in built_list:
			var building:Dictionary = Buildables.return_resources(type)
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
func calc_purchases(base_data:Dictionary, resources:Dictionary, containment_data:Dictionary, results:Dictionary) -> Dictionary:
	var resources_copy = resources.duplicate(true)
	var base_data_copy = base_data.duplicate(true)
	
	for item in results.purchased:
		base_data_copy.built[item.on_floor].push_back(item.type)
	base_data_copy.purchase_list = []
	
	## first, subtract building costs
	resources_copy = RESOURCE.merge_new_total(resources_copy, results.new_totals)
		
	## then calculate new cost properties
	resources_copy = RESOURCE.calculate_properties(resources_copy, base_data_copy.built, containment_data)	

	return {"base_data": base_data_copy, "resources": resources_copy}
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func merge_new_total(resources:Dictionary, new_totals:Dictionary) -> Dictionary:
	var resources_copy = resources.duplicate(true)
	
	for resource_key in resources_copy:
		if resource_key in new_totals:
			resources_copy[resource_key].total = new_totals[resource_key]

	return resources_copy
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func adjust_resource(resources:Dictionary, arr:Array) -> Dictionary:
	var resources_copy = resources.duplicate(true)
	
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
