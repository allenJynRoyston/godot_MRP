extends Node

enum REF {
	UPGRADE_ABL_LVL,
	
	SUPPLY_SECURITY,
	SUPPLY_STAFF,
	SUPPLY_TECHNICIANS,
	SUPPLY_DCLASS,
	
	FIREARM_TRAINING,
	HEAVY_WEAPONS_TRAINING,
	
	TECH_SUPPORT,
	
	
	MEMETIC_SHILEDING
}

# ---------------------------------
var upgrade_abl_level:Dictionary = {
	"name": "LVL +1",
	"lvl_required": 0,
	"energy_cost": 4,
	"wing": func(new_room_config:Dictionary, use_location:Dictionary) -> Dictionary:
		new_room_config.floor[use_location.floor].ring[use_location.ring].abl_lvl += 1
		#print("here!: ", new_room_config.floor[use_location.floor].ring[use_location.ring].abl_lvl)
		return new_room_config,
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
var firearm_training:Dictionary = {
	"name": "FIREARM TRAINING",
	"energy_cost": 2,
	"metrics": {
		RESOURCE.BASE_METRICS.SAFETY: 1
	}
}

# ---------------------------------
var heavy_weapons_training:Dictionary = {
	"name": "HEAVY WEAPONS TRAINING",
	"energy_cost": 3,
	"metrics": {
		RESOURCE.BASE_METRICS.READINESS: 1
	}
}

# ---------------------------------
var tech_support:Dictionary = {
	"name": "TECH SUPPORT",
	"energy_cost": 2,
	"metrics": {
		RESOURCE.BASE_METRICS.READINESS: 1
	}	
}


# ---------------------------------
var memetic_shielding:Dictionary = {
	"name": "MEMETIC SHIELDING",
	"energy_cost": 3,
	"metrics":{
		RESOURCE.BASE_METRICS.READINESS: 1
	}
}


# ---------------------------------
func get_ability(ref:REF, lvl_required:int = 0) -> Dictionary:
	var ability:Dictionary = {}
	match ref:
		# ------------------
		REF.UPGRADE_ABL_LVL:
			ability = upgrade_abl_level
		# ------------------	
		REF.SUPPLY_SECURITY:
			ability = supply_security
		REF.SUPPLY_STAFF:
			ability = supply_staff
		REF.SUPPLY_TECHNICIANS:
			ability = supply_technicians
		REF.SUPPLY_DCLASS:
			ability = supply_dclass
		# ------------------
		REF.FIREARM_TRAINING:
			ability = firearm_training
		REF.HEAVY_WEAPONS_TRAINING:
			ability = heavy_weapons_training
		# ------------------
		REF.TECH_SUPPORT:
			ability = tech_support
		# ------------------
		REF.MEMETIC_SHILEDING:
			ability = memetic_shielding
	
	ability.ref = ref
	ability.lvl_required = lvl_required
	return ability
	
