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

var reference_data:Dictionary = {
	RESOURCE.TYPE.MONEY: MONEY,
	RESOURCE.TYPE.ENERGY: ENERGY,
	RESOURCE.TYPE.LEAD_RESEARCHERS: LEAD_RESEARCHERS,
	RESOURCE.TYPE.STAFF: STAFF,
	RESOURCE.TYPE.SECURITY: SECURITY,
	RESOURCE.TYPE.DCLASS: DCLASS
}

# ------------------------------------------------------------------------------
func return_data(key:int) -> Dictionary:
	reference_data[key].ref = key
	return reference_data[key]
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
	
