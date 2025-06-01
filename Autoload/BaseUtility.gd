extends SubscribeWrapper

# ----------------------------------------
var MORALE_BOOST:Dictionary = {
	"ref": BASE.BUFF.MORALE_BOOST,
	"name": "MORALE BOOST",
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "A temporary boost to morale.",
	"metrics": {
		RESOURCE.METRICS.MORALE: 2
	}
}

var CONTRACTORS:Dictionary = {
	"ref": BASE.BUFF.CONTRACTORS,
	"name": "CONTRACTORS",
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "Temporary employees that are used to fill any staffing postion (excluding D-Class).",
	"personnel": [
		RESOURCE.PERSONNEL.TECHNICIANS,
		RESOURCE.PERSONNEL.STAFF,
		RESOURCE.PERSONNEL.SECURITY
	]
}

var buff_data:Dictionary = {
	BASE.BUFF.MORALE_BOOST: MORALE_BOOST,
	BASE.BUFF.CONTRACTORS: CONTRACTORS
}
# ----------------------------------------


# ----------------------------------------
var MORALE_DRAIN:Dictionary = {
	"ref": BASE.DEBUFF.MORALE_DRAIN,
	"name": "MORALE DRAIN",
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "A temporary debuff to morale.",
	"metrics": {
		RESOURCE.METRICS.MORALE: -5
	}
}

var debuff_data:Dictionary = {
	BASE.DEBUFF.MORALE_DRAIN: MORALE_DRAIN
}
# ----------------------------------------

# ------------------------------------------------------------------------------
func return_buff(ref:int) -> Dictionary:
	buff_data[ref].ref = ref
	return buff_data[ref]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_debuff(ref:int) -> Dictionary:
	debuff_data[ref].ref = ref
	return debuff_data[ref]
# ------------------------------------------------------------------------------
