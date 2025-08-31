extends Node

enum REF {
	# ---
	ENABLE_ADMIN_SUBDIVISON,
	
	# --- DIRECTORS OFFICE
	PREDICTIVE_TIMELINE,
	OBJECTIVE_ASSIST,
	
	UPGRADE_ABL_LVL,
	ADDITIONAL_STORE_UNLOCKS,

	FIREARM_TRAINING,
	HEAVY_WEAPONS_TRAINING,
	
	TECH_SUPPORT,
	
	GENERATE_RESEARCH_FROM_SCP,
	GENERATE_MONEY_FROM_SCP,
	
	MEMETIC_SHILEDING,
	
	# ------------------- GENERATE
	MTF_A,
	MTF_B,
	MTF_C,
	MTF_D,
	MTF_E,
	MTF_F,
	
	# ------------------- GENERATE
	GENERATE_MONEY_LVL_1,
	GENERATE_MONEY_LVL_2,
	GENERATE_MONEY_LVL_3,
	
	GENERATE_SCIENCE_LVL_1,
	GENERATE_MATERIAL_LVL_1,
	GENERATE_CORE_LVL_1	
}

# ---------------------------------
var ENABLE_ADMIN_SUBDIVISON:Dictionary = {
	"name": "ENABLE_ADMIN_SUBDIVISON",
	"description": "Can build an Admin Subdivion.",
	"energy_cost": 1,
	"conditionals": [CONDITIONALS.TYPE.ENABLE_TIMELINE]
}

var PREDICTIVE_TIMELINE:Dictionary = {
	"name": "PREDICTIVE TIMELINE",
	"description": "Show a most likely timeline of events.",
	"energy_cost": 1,
	"conditionals": [CONDITIONALS.TYPE.ENABLE_TIMELINE]
}

var OBJECTIVE_ASSIST:Dictionary = {
	"name": "OBJECTIVES ASSIST",
	"description": "Objectives are always visible on the main screen.",
	"energy_cost": 1,
	"conditionals": [CONDITIONALS.TYPE.ENABLE_OBJECTIVES]
}


var UPGRADE_ABL_LVL:Dictionary = {
	"name": "LVL +1",
	"description": "Increases the ability level of ALL rooms in a wing.",
	"energy_cost": 4,
	#"wing": func(new_room_config:Dictionary, use_location:Dictionary) -> Dictionary:
		#new_room_config.floor[use_location.floor].ring[use_location.ring].abl_lvl += 1
		#return new_room_config,
}

var ADDITIONAL_STORE_UNLOCKS:Dictionary = {
	"name": "ADDITIONAL STORE UNLOCKS",
	"description": "Additional facilities can be unlocked in the store.",
	"energy_cost": 4,
	#"floor_effect": func(floor_config_data:Dictionary) -> void:
		#if floor_config_data.room_unlock_val < 1:
			#floor_config_data.room_unlock_val = 1
		
}

# ---------------------------------
var SUPPLY_SECURITY:Dictionary = {
	"name": "EMPLOY SECURITY",
	"description": "Makes SECURITY personnel available for the entire wing.",
	"energy_cost": 1,
	"personnel": [
		RESOURCE.PERSONNEL.SECURITY
	]
}

# ---------------------------------
var FIREARM_TRAINING:Dictionary = {
	"name": "FIREARM TRAINING",
	"description": "Increases SAFETY rating by 1.",
	"energy_cost": 2,
	"metrics": {
		RESOURCE.METRICS.SAFETY: 1
	}
}

# ---------------------------------
var HEAVY_WEAPONS_TRAINING:Dictionary = {
	"name": "HEAVY WEAPONS TRAINING",
	"description": "Increases READINESS rating by 1.",
	"energy_cost": 3,
	"metrics": {
		RESOURCE.METRICS.READINESS: 1
	}
}

# ---------------------------------
var TECH_SUPPORT:Dictionary = {
	"name": "TECH SUPPORT",
	"description": "Increases READINESS rating by 1.",
	"energy_cost": 2,
	"metrics": {
		RESOURCE.METRICS.READINESS: 1
	}	
}


# ---------------------------------
var MEMETIC_SHIELDING:Dictionary = {
	"name": "MEMETIC SHIELDING",
	"description": "Increases READINESS rating by 1.",
	"energy_cost": 3,
	"metrics":{
		RESOURCE.METRICS.READINESS: 1
	}
}

# ---------------------------------
var GENERATE_RESEARCH_FROM_SCP:Dictionary = {
	"name": "GENERATE RESEARCH",
	"description": "Research into contained object generates research.",
	"energy_cost": 4,
	"scp_required": true,
	"currencies":{
		RESOURCE.CURRENCY.SCIENCE: 1
	}
}

var GENERATE_MONEY_FROM_SCP:Dictionary = {
	"name": "GENERATE MONEY",
	"description": "Research into contained object generates money.",
	"energy_cost": 4,
	"scp_required": true,
	"currencies":{
		RESOURCE.CURRENCY.MONEY: 1
	}
}
# ---------------------------------

# -------------------------------------------------------------------------------------------------- MTF
var MTF_A:Dictionary = {
	"name": "MTF ALPHA",
	"description": "MTF ALPHA.",
	"energy_cost": 1,
	"mtf_ref": MTF.TEAM.ALPHA
}

var MTF_B:Dictionary = {
	"name": "MTF BRAVO",
	"description": "MTF BRAVO.",
	"energy_cost": 1,
	"mtf_ref": MTF.TEAM.BRAVO
}

var MTF_C:Dictionary = {
	"name": "MTF CHARLIE",
	"description": "MTF CHARLIE.",
	"energy_cost": 1,
	"mtf_ref": MTF.TEAM.CHARLIE
}

var MTF_D:Dictionary = {
	"name": "MTF DELTA",
	"description": "MTF DELTA.",
	"energy_cost": 1,
	"mtf_ref": MTF.TEAM.DELTA
}

var MTF_E:Dictionary = {
	"name": "MTF ECHO",
	"description": "MTF ECHO.",
	"energy_cost": 1,
	"mtf_ref": MTF.TEAM.ECHO
}

var MTF_F:Dictionary = {
	"name": "MTF FOXTROT",
	"description": "MTF FOXTROT.",
	"energy_cost": 1,
	"mtf_ref": MTF.TEAM.FOXTROT
}


# -------------------------------------------------------------------------------------------------- GENERATE RESOURCES
var GENERATE_MONEY_LVL_1:Dictionary = {
	"name": "GENERATE MONEY",
	"description": "Room generates additional MONEY.",
	"energy_cost": 1,
	"currencies":{
		RESOURCE.CURRENCY.MONEY: 1
	}
}

var GENERATE_MONEY_LVL_2:Dictionary = {
	"name": "GENERATE MONEY",
	"description": "Room generates additional MONEY.",
	"energy_cost": 2,
	"currencies":{
		RESOURCE.CURRENCY.MONEY: 2
	}
}


var GENERATE_MONEY_LVL_3:Dictionary = {
	"name": "GENERATE MONEY",
	"description": "Room generates additional MONEY.",
	"energy_cost": 3,
	"currencies":{
		RESOURCE.CURRENCY.MONEY: 3
	}
}


var GENERATE_SCIENCE_LVL_1:Dictionary = {
	"name": "GENERATE SCIENCE",
	"description": "Room generates SCIENCE.",
	"energy_cost": 2,
	"currencies":{
		RESOURCE.CURRENCY.SCIENCE: 1
	}
}

var GENERATE_MATERIAL_LVL_1:Dictionary = {
	"name": "GENERATE MATERIAL",
	"description": "Room generates MATERIAL.",
	"energy_cost": 2,
	"currencies":{
		RESOURCE.CURRENCY.MATERIAL: 1
	}
}

var GENERATE_CORE_LVL_1:Dictionary = {
	"name": "GENERATE CORE",
	"description": "Room generates CORE.",
	"energy_cost": 3,
	"currencies":{
		RESOURCE.CURRENCY.CORE: 1
	}
}


# ---------------------------------
func get_ability(ref:REF, lvl_required:int = 0) -> Dictionary:
	var ability:Dictionary = {}
	match ref:
		# ------------------
		REF.ENABLE_ADMIN_SUBDIVISON:
			ability = ENABLE_ADMIN_SUBDIVISON
			
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
			

		# ------------------ MTF
		REF.MTF_A:
			ability = MTF_A
		REF.MTF_B:
			ability = MTF_B
		REF.MTF_C:
			ability = MTF_C
		REF.MTF_D:
			ability = MTF_D		
		REF.MTF_E:
			ability = MTF_E	
		REF.MTF_F:
			ability = MTF_F	
			
		# ------------------ GENERATE
		REF.GENERATE_MONEY_LVL_1:
			ability = GENERATE_MONEY_LVL_1
		REF.GENERATE_MONEY_LVL_2:
			ability = GENERATE_MONEY_LVL_2
		REF.GENERATE_MONEY_LVL_3:
			ability = GENERATE_MONEY_LVL_3
						
		REF.GENERATE_SCIENCE_LVL_1:
			ability = GENERATE_SCIENCE_LVL_1
		REF.GENERATE_MATERIAL_LVL_1:
			ability = GENERATE_MATERIAL_LVL_1			
		REF.GENERATE_CORE_LVL_1:
			ability = GENERATE_CORE_LVL_1
			
			
	ability.ref = ref
	ability.lvl_required = lvl_required
	return ability
	
