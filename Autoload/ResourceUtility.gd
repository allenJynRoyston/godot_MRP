@tool
extends Node

var MONEY:Dictionary = {
	"id": RESOURCE.TYPE.MONEY,
	"name": "MONEY",
	"icon": SVGS.TYPE.MONEY
}

var ENERGY:Dictionary = {
	"name": "ENERGY",
	"icon": SVGS.TYPE.ENERGY
}

var SCIENCE:Dictionary = {
	"name": "SCIENCE",
	"icon": SVGS.TYPE.RESEARCH
}

var LEAD_RESEARCHERS:Dictionary = {
	"name": "LEAD RESEARCHER",
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
	RESOURCE.TYPE.MONEY: MONEY,
	RESOURCE.TYPE.ENERGY: ENERGY,
	RESOURCE.TYPE.SCIENCE: SCIENCE,
	RESOURCE.TYPE.LEAD_RESEARCHERS: LEAD_RESEARCHERS,
	RESOURCE.TYPE.STAFF: STAFF,
	RESOURCE.TYPE.SECURITY: SECURITY,
	RESOURCE.TYPE.DCLASS: DCLASS,
}




var reference_data_base_metric:Dictionary = {
	RESOURCE.BASE_METRICS.MORALE: MORALE,
	RESOURCE.BASE_METRICS.SAFETY: SAFETY,
	RESOURCE.BASE_METRICS.READINESS: READINESS
}

# ------------------------------------------------------------------------------
func return_data(key:int) -> Dictionary:
	reference_data[key].ref = key
	return reference_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_metric_data(key:int) -> Dictionary:
	reference_data_base_metric[key].ref = key
	return reference_data_base_metric[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func check_if_have_enough(cost_arr:Array, resources_data:Dictionary) -> bool:
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
	
