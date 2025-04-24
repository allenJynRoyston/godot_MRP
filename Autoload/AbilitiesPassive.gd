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
	"description": "Increases the ability level of ALL rooms in a wing.",
	"lvl_required": 0,
	"energy_cost": 4,
	"wing": func(new_room_config:Dictionary, use_location:Dictionary) -> Dictionary:
		new_room_config.floor[use_location.floor].ring[use_location.ring].abl_lvl += 1
		return new_room_config,
}

# ---------------------------------
var supply_security:Dictionary = {
	"name": "EMPLOY SECURITY",
	"description": "Makes SECURITY personnel available for the entire wing.",
	"energy_cost": 1,
	"provides": [
		RESOURCE.PERSONNEL.SECURITY
	]
}

# ---------------------------------
var supply_staff:Dictionary = {
	"name": "EMPLOY STAFF",
	"description": "Makes STAFF personnel available for the entire wing.",
	"energy_cost": 1,
	"provides": [
		RESOURCE.PERSONNEL.STAFF
	]
}

# ---------------------------------
var supply_technicians:Dictionary = {
	"name": "EMPLOY TECHNICIANS",
	"description": "Makes TECHNICIANS personnel available for the entire wing.",
	"energy_cost": 1,
	"provides": [
		RESOURCE.PERSONNEL.TECHNICIANS
	]
}

# ---------------------------------
var supply_dclass:Dictionary = {
	"name": "CONSCRIPT DCLASS",
	"description": "Makes DCLASS personnel available for the testing for the entire wing.",
	"energy_cost": 1,
	"provides": [
		RESOURCE.PERSONNEL.DCLASS
	]
}

# ---------------------------------
var firearm_training:Dictionary = {
	"name": "FIREARM TRAINING",
	"description": "Increases SAFETY rating by 1.",
	"energy_cost": 2,
	"metrics": {
		RESOURCE.METRICS.SAFETY: 1
	}
}

# ---------------------------------
var heavy_weapons_training:Dictionary = {
	"name": "HEAVY WEAPONS TRAINING",
	"description": "Increases READINESS rating by 1.",
	"energy_cost": 3,
	"metrics": {
		RESOURCE.METRICS.READINESS: 1
	}
}

# ---------------------------------
var tech_support:Dictionary = {
	"name": "TECH SUPPORT",
	"description": "Increases READINESS rating by 1.",
	"energy_cost": 2,
	"metrics": {
		RESOURCE.METRICS.READINESS: 1
	}	
}


# ---------------------------------
var memetic_shielding:Dictionary = {
	"name": "MEMETIC SHIELDING",
	"description": "Increases READINESS rating by 1.",
	"energy_cost": 3,
	"metrics":{
		RESOURCE.METRICS.READINESS: 1
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
	
