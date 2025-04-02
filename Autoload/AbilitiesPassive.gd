extends Node

enum REF {
	UPGRADE_ABL_LVL,
	
	SUPPLY_SECURITY,
	SUPPLY_STAFF,
	SUPPLY_TECHNICIANS,
	SUPPLY_DCLASS,
	
	MEMETIC_SHILEDING
}

# ---------------------------------
var upgrade_abl_level:Dictionary = {
	"name": "ABL LVL +1",
	"lvl_required": 0,
	"energy_cost": 4,
	"conditional": func(gpc:Dictionary) -> Dictionary:
		gpc[CONDITIONALS.TYPE.ENABLE_UPGRADES] = 1
		return gpc,
}

# ---------------------------------
var supply_security:Dictionary = {
	"name": "SUPPLY SECURITY",
	"energy_cost": 1,
	"provides": [
		RESOURCE.TYPE.SECURITY
	]
}

# ---------------------------------
var supply_staff:Dictionary = {
	"name": "SUPPLY STAFF",
	"energy_cost": 1,
	"provides": [
		RESOURCE.TYPE.STAFF
	]
}

# ---------------------------------
var supply_technicians:Dictionary = {
	"name": "SUPPLY TECHNICIANS",
	"energy_cost": 1,
	"provides": [
		RESOURCE.TYPE.TECHNICIANS
	]
}

# ---------------------------------
var supply_dclass:Dictionary = {
	"name": "SUPPLY DCLASS",
	"energy_cost": 1,
	"provides": [
		RESOURCE.TYPE.DCLASS
	]
}


# ---------------------------------
var memetic_shielding:Dictionary = {
	"name": "MEMETIC SHIELDING",
	"energy_cost": 3,
	"effect": func() -> Dictionary:
		return {
			"metrics":{
				RESOURCE.BASE_METRICS.READINESS: 1
			}
		},
}


# ---------------------------------
func get_ability(ref:REF, lvl_required:int = 0) -> Dictionary:
	var ability:Dictionary = {}
	match ref:
		REF.UPGRADE_ABL_LVL:
			ability = upgrade_abl_level
		REF.SUPPLY_SECURITY:
			ability = supply_security
		REF.SUPPLY_STAFF:
			ability = supply_staff
		REF.SUPPLY_TECHNICIANS:
			ability = supply_technicians
		REF.SUPPLY_DCLASS:
			ability = supply_dclass
		REF.MEMETIC_SHILEDING:
			ability = memetic_shielding
	
	ability.ref = ref
	ability.lvl_required = lvl_required
	return ability
	
