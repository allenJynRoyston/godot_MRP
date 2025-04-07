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
	"icon": SVGS.TYPE.DOT
}

var MATERIAL:Dictionary = {
	"id": RESOURCE.CURRENCY.MATERIAL,
	"name": "MATERIAL",
	"icon": SVGS.TYPE.CONVERSATION
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
func return_morale_data(value:int) -> Dictionary:
	var dict:Dictionary = {}
	match value:
		-3: 
			dict = {
				"title": "-5 AP", 
				"amount": -5
			}
		-2: 
			dict = {
				"title": "-3 AP", 
				"amount": -3
			}
		-1: 
			dict = {
				"title": "-1 AP", 
				"amount": -1
			}
		0: 
			dict = {
				"title": "NO BONUS", 
				"amount": 0
			}			
		1: 
			dict = {
				"title": "+1 AP", 
				"amount": 1
			}						
		2: 
			dict = {
				"title": "+3 AP", 
				"amount": 3
			}
		3: 
			dict = {
				"title": "+5 AP", 
				"amount": 5
			}
		_:
			dict = {
				"title": "UNKNOWN",
				"amount": 5
			}						
	return dict
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_readiness_data(value:int) -> Dictionary:
	var dict:Dictionary = {}
	match value:
		-3: 
			dict = {
				"title": "OPTIONS DISABLED", 
			}
		-2: 
			dict = {
				"title": "2 OPTIONS HIDDEN",
			}
		-1: 
			dict = {
				"title": "1 OPTION HIDDEN",
			}
		0: 
			dict = {
				"title": "NO BONUS",
			}			
		1: 
			dict = {
				"title": "VISIBLE ODDS", 
			}						
		2: 
			dict = {
				"title": "VISIBLE OUTCOMES", 
			}
		3: 
			dict = {
				"title": "ALWAYS LUCKY", 
			}				
		_:
			dict = {
				"title": "UNKNOWN"
			}			
	return dict
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_safety_data(value:int) -> Dictionary:
	var dict:Dictionary = {}
	match value:
		-3: 
			dict = {
				"title": "CONTAINMENT BREACH", 
				"value": 0,
			}
		-2: 
			dict = {
				"title": "TIMELINE HIDDEN",
				"value": 0,
			}
		-1: 
			dict = {
				"title": "SHORTENED TIMELINE",
				"value": 0,
			}
		0: 
			dict = {
				"title": "NO BONUS",
				"value": 0,
			}			
		1: 
			dict = {
				"title": "1 DAY FORESIGHT", 
				"value": 1,
			}						
		2: 
			dict = {
				"title": "3 DAYS FORESIGHT", 
				"value": 3,
			}
		3: 
			dict = {
				"title": "5 DAYS FORESIGHT", 
				"value": 5,
			}
		_:
			dict = {
				"title": "UNKNOWN", 
				"value": 0,
			}
	return dict
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func subtract_costs(cost_array:Array) -> void:
	for item in cost_array:
		var amount:int = item.amount
		resources_data[item.resource.ref].amount = U.min_max(resources_data[item.resource.ref].amount - absi(amount), 0, resources_data[item.resource.ref].capacity)
	SUBSCRIBE.resources_data = resources_data
# ------------------------------------------------------------------------------
	
