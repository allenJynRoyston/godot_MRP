@tool
extends SubscribeWrapper

var MONEY:Dictionary = {
	"id": RESOURCE.CURRENCY.MONEY,
	"name": "MONEY",
	"icon": SVGS.TYPE.MONEY
}

var SCIENCE:Dictionary = {
	"id": RESOURCE.CURRENCY.SCIENCE,
	"name": "SCIENCE",
	"icon": SVGS.TYPE.RESEARCH
}

var CORE:Dictionary = {
	"id": RESOURCE.CURRENCY.CORE,
	"name": "CORE",
	"icon": SVGS.TYPE.GLOBAL
}

var MATERIAL:Dictionary = {
	"id": RESOURCE.CURRENCY.MATERIAL,
	"name": "MATERIAL",
	"icon": SVGS.TYPE.TARGET
}

var ENERGY:Dictionary = {
	"name": "ENERGY",
	"icon": SVGS.TYPE.ENERGY
}

var TECHNICIANS:Dictionary = {
	"name": "TECHNICIANS",
	"icon": SVGS.TYPE.DRS
}

var STAFF:Dictionary = {
	"name": "STAFF",
	"icon": SVGS.TYPE.STAFF
}

var SECURITY:Dictionary = {
	"name": "SECURITY",
	"icon": SVGS.TYPE.SECURITY
}

var DCLASS:Dictionary = {
	"name": "D CLASS",
	"icon": SVGS.TYPE.D_CLASS
}

var MORALE:Dictionary = {
	"name": "MORALE",
	"icon": SVGS.TYPE.STAFF
}

var SAFETY:Dictionary = {
	"name": "SAFETY",
	"icon": SVGS.TYPE.STAFF
}

var READINESS:Dictionary = {
	"name": "READINESS",
	"icon": SVGS.TYPE.STAFF
}

var reference_data:Dictionary = {
	RESOURCE.CURRENCY.MONEY: MONEY,
	RESOURCE.CURRENCY.SCIENCE: SCIENCE,
	RESOURCE.CURRENCY.MATERIAL: MATERIAL,
	RESOURCE.CURRENCY.CORE: CORE,
}

var reference_personnel:Dictionary = {
	RESOURCE.PERSONNEL.TECHNICIANS: TECHNICIANS,
	RESOURCE.PERSONNEL.STAFF: STAFF,
	RESOURCE.PERSONNEL.SECURITY: SECURITY,
	RESOURCE.PERSONNEL.DCLASS: DCLASS,
}

var reference_metric:Dictionary = {
	RESOURCE.METRICS.MORALE: MORALE,
	RESOURCE.METRICS.SAFETY: SAFETY,
	RESOURCE.METRICS.READINESS: READINESS
}

# ------------------------------------------------------------------------------
func return_currency(key:int) -> Dictionary:
	reference_data[key].ref = key
	return reference_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_personnel(key:int) -> Dictionary:
	reference_personnel[key].ref = key
	return reference_personnel[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_metric(key:int) -> Dictionary:
	reference_metric[key].ref = key
	return reference_metric[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_random_resource() -> RESOURCE.CURRENCY:
	var options = [
		{ "type": RESOURCE.CURRENCY.MONEY, "weight": 30 }, 		# 30% chance
		{ "type": RESOURCE.CURRENCY.SCIENCE, "weight": 30 },	# 30% chance
		{ "type": RESOURCE.CURRENCY.MATERIAL, "weight": 30 },	# 15% chance
		{ "type": RESOURCE.CURRENCY.CORE, "weight": 10 }      	# 10% chance
	]
	
	# Sum weights
	var total_weight = 0
	for o in options:
		total_weight += o.weight
	
	# Pick a random number in that range
	var roll = randi_range(1, total_weight)
	
	# Walk the list until the roll fits
	var cumulative = 0
	for o in options:
		cumulative += o.weight
		if roll <= cumulative:
			return o.type
	
	# Fallback (shouldn’t happen)
	return RESOURCE.CURRENCY.MONEY

func return_extra_diff() -> Dictionary:
	var dict:Dictionary = {}
	
	for key in resources_data:
		dict[key] = 0
	
	# adds a random resource if this perk is sele
	for n in range(0, 5):
		dict[get_random_resource()] += 1

	return dict	

func return_diff() -> Dictionary:
	var dict:Dictionary = {}
	
	for key in resources_data:
		dict[key] = resources_data[key].diff
	
	return dict	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func check_if_have_enough(cost_arr:Array) -> bool:
	var has_enough:bool = true
	for item in cost_arr:
		match item.type:
			"amount":
				var current_amount:int = resources_data[item.resource.ref].amount 
				var compare_amount:int = absi(item.amount)
				if current_amount - compare_amount < 0:
					has_enough = false
					break
	return has_enough
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func make_update_to_currency_amount(ref:RESOURCE.CURRENCY, amount:int) -> void:
	resources_data[ref].amount = U.min_max(resources_data[ref].amount + amount, 0, resources_data[ref].capacity) 
	SUBSCRIBE.resources_data = resources_data	
# ------------------------------------------------------------------------------

## ------------------------------------------------------------------------------
#func subtract_costs(cost_array:Array) -> void:
	#for item in cost_array:
		#var amount:int = item.amount
		#resources_data[item.resource.ref].amount = U.min_max(resources_data[item.resource.ref].amount - absi(amount), 0, resources_data[item.resource.ref].capacity)
	#SUBSCRIBE.resources_data = resources_data
## ------------------------------------------------------------------------------
	#
