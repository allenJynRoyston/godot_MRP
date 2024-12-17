@tool
extends Node

var MONEY:Dictionary = {
	"id": RESOURCE.TYPE.MONEY,
	"name": "MONEY",
	"icon": SVGS.TYPE.MONEY
}

var ENERGY:Dictionary = {
	"id": RESOURCE.TYPE.ENERGY,
	"name": "ENERGY",
	"icon": SVGS.TYPE.ENERGY
}

var LEAD_RESEARCHERS:Dictionary = {
	"id": RESOURCE.TYPE.LEAD_RESEARCHERS,
	"name": "LEAD RESEARCHER",
	"icon": SVGS.TYPE.DRS
}

var STAFF:Dictionary = {
	"id": RESOURCE.TYPE.STAFF,
	"name": "STAFF",
	"icon": SVGS.TYPE.STAFF
}

var SECURITY:Dictionary = {
	"id": RESOURCE.TYPE.SECURITY,
	"name": "SECURITY",
	"icon": SVGS.TYPE.SECURITY
}

var DCLASS:Dictionary = {
	"id": RESOURCE.TYPE.DCLASS,
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
	return reference_data[key]
# ------------------------------------------------------------------------------
