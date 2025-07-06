extends Node

enum REF {
	# --- DIRECTORS OFFICE
	PREDICTIVE_TIMELINE,
	OBJECTIVE_ASSIST,
	
	UPGRADE_ABL_LVL,
	ADDITIONAL_STORE_UNLOCKS,
	
	SUPPLY_SECURITY,
	SUPPLY_STAFF,
	SUPPLY_TECHNICIANS,
	SUPPLY_DCLASS,
	
	FIREARM_TRAINING,
	HEAVY_WEAPONS_TRAINING,
	
	TECH_SUPPORT,
	
	GENERATE_RESEARCH_FROM_SCP,
	GENERATE_MONEY_FROM_SCP,
	
	MEMETIC_SHILEDING,
	
	GENERATE_MONEY,
	GENERATE_SCIENCE,
}

# ---------------------------------
var PREDICTIVE_TIMELINE:Dictionary = {
	"name": "PREDICTIVE TIMELINE",
	"description": "Show a most likely timeline of events.",
	"lvl_required": 0,
	"energy_cost": 1,
	"conditionals": [CONDITIONALS.TYPE.ENABLE_TIMELINE]
}

var OBJECTIVE_ASSIST:Dictionary = {
	"name": "OBJECTIVES ASSIST",
	"description": "Objectives are always visible on the main screen.",
	"lvl_required": 0,
	"energy_cost": 1,
	"conditionals": [CONDITIONALS.TYPE.ENABLE_OBJECTIVES]
}


var UPGRADE_ABL_LVL:Dictionary = {
	"name": "LVL +1",
	"description": "Increases the ability level of ALL rooms in a wing.",
	"lvl_required": 0,
	"energy_cost": 4,
	#"wing": func(new_room_config:Dictionary, use_location:Dictionary) -> Dictionary:
		#new_room_config.floor[use_location.floor].ring[use_location.ring].abl_lvl += 1
		#return new_room_config,
}

var ADDITIONAL_STORE_UNLOCKS:Dictionary = {
	"name": "ADDITIONAL STORE UNLOCKS",
	"description": "Additional facilities can be unlocked in the store.",
	"lvl_required": 0,
	"energy_cost": 4,
	"floor_effect": func(floor_config_data:Dictionary) -> void:
		if floor_config_data.room_unlock_val < 1:
			floor_config_data.room_unlock_val = 1
		
}

# ---------------------------------
var SUPPLY_SECURITY:Dictionary = {
	"name": "EMPLOY SECURITY",
	"description": "Makes SECURITY personnel available for the entire wing.",
	"lvl_required": 0,
	"energy_cost": 1,
	"personnel": [
		RESOURCE.PERSONNEL.SECURITY
	]
}

# ---------------------------------
var SUPPLY_STAFF:Dictionary = {
	"name": "EMPLOY STAFF",
	"description": "Makes STAFF personnel available for the entire wing.",
	"lvl_required": 0,
	"energy_cost": 1,
	"personnel": [
		RESOURCE.PERSONNEL.STAFF
	]
}

# ---------------------------------
var SUPPLY_TECHNICIANS:Dictionary = {
	"name": "EMPLOY TECHNICIANS",
	"description": "Makes TECHNICIANS personnel available for the entire wing.",
	"lvl_required": 0,
	"energy_cost": 1,
	"personnel": [
		RESOURCE.PERSONNEL.TECHNICIANS
	]
}

# ---------------------------------
var SUPPLY_DCLASS:Dictionary = {
	"name": "CONSCRIPT DCLASS",
	"description": "Makes DCLASS personnel available for the testing for the entire wing.",
	"lvl_required": 0,
	"energy_cost": 1,
	"personnel": [
		RESOURCE.PERSONNEL.DCLASS
	]
}

# ---------------------------------
var FIREARM_TRAINING:Dictionary = {
	"name": "FIREARM TRAINING",
	"description": "Increases SAFETY rating by 1.",
	"lvl_required": 0,
	"energy_cost": 2,
	"metrics": {
		RESOURCE.METRICS.SAFETY: 1
	}
}

# ---------------------------------
var HEAVY_WEAPONS_TRAINING:Dictionary = {
	"name": "HEAVY WEAPONS TRAINING",
	"description": "Increases READINESS rating by 1.",
	"lvl_required": 0,
	"energy_cost": 3,
	"metrics": {
		RESOURCE.METRICS.READINESS: 1
	}
}

# ---------------------------------
var TECH_SUPPORT:Dictionary = {
	"name": "TECH SUPPORT",
	"description": "Increases READINESS rating by 1.",
	"lvl_required": 0,
	"energy_cost": 2,
	"metrics": {
		RESOURCE.METRICS.READINESS: 1
	}	
}


# ---------------------------------
var MEMETIC_SHIELDING:Dictionary = {
	"name": "MEMETIC SHIELDING",
	"description": "Increases READINESS rating by 1.",
	"lvl_required": 0,
	"energy_cost": 3,
	"metrics":{
		RESOURCE.METRICS.READINESS: 1
	}
}

# ---------------------------------
var GENERATE_RESEARCH_FROM_SCP:Dictionary = {
	"name": "GENERATE RESEARCH",
	"description": "Research into contained object generates research.",
	"lvl_required": 0,
	"energy_cost": 4,
	"scp_required": true,
	"currencies":{
		RESOURCE.CURRENCY.SCIENCE: 100
	}
}

var GENERATE_MONEY_FROM_SCP:Dictionary = {
	"name": "GENERATE MONEY",
	"description": "Research into contained object generates money.",
	"lvl_required": 0,
	"energy_cost": 4,
	"scp_required": true,
	"currencies":{
		RESOURCE.CURRENCY.MONEY: 100
	}
}
# ---------------------------------

# ---------------------------------
var GENERATE_MONEY:Dictionary = {
	"name": "GENERATE MONEY",
	"description": "Room generates money.",
	"lvl_required": 0,
	"energy_cost": 2,
	"currencies":{
		RESOURCE.CURRENCY.MONEY: 50
	}
}



# ---------------------------------
func get_ability(ref:REF, lvl_required:int = 0) -> Dictionary:
	var ability:Dictionary = {}
	match ref:
		# ------------------
		REF.PREDICTIVE_TIMELINE:
			ability = PREDICTIVE_TIMELINE
		REF.OBJECTIVE_ASSIST:	
			ability = OBJECTIVE_ASSIST
		
		# ------------------
		REF.UPGRADE_ABL_LVL:
			ability = UPGRADE_ABL_LVL
		REF.ADDITIONAL_STORE_UNLOCKS:
			ability = ADDITIONAL_STORE_UNLOCKS
		# ------------------	
		REF.SUPPLY_SECURITY:
			ability = SUPPLY_SECURITY
		REF.SUPPLY_STAFF:
			ability = SUPPLY_STAFF
		REF.SUPPLY_TECHNICIANS:
			ability = SUPPLY_TECHNICIANS
		REF.SUPPLY_DCLASS:
			ability = SUPPLY_DCLASS
		# ------------------
		REF.FIREARM_TRAINING:
			ability = FIREARM_TRAINING
		REF.HEAVY_WEAPONS_TRAINING:
			ability = HEAVY_WEAPONS_TRAINING
		# ------------------
		REF.TECH_SUPPORT:
			ability = TECH_SUPPORT
		# ------------------
		REF.MEMETIC_SHILEDING:
			ability = MEMETIC_SHIELDING
		# ------------------
		REF.GENERATE_RESEARCH_FROM_SCP:
			ability = GENERATE_RESEARCH_FROM_SCP
		REF.GENERATE_MONEY_FROM_SCP:
			ability = GENERATE_MONEY_FROM_SCP
		# ------------------
		REF.GENERATE_MONEY:
			ability = GENERATE_MONEY
	
	ability.ref = ref
	ability.lvl_required = lvl_required
	return ability
	
