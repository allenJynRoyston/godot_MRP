extends Node

enum REF {
	# ADD RESOURCE TO ALL
	ADD_MONEY_TO_ALL_IN_RING,
	ADD_SCIENCE_TO_ALL_IN_RING,
	ADD_MATERIAL_TO_ALL_IN_RING,
	ADD_CORE_TO_ALL_IN_RING,
	
	# ADD RESOURCE TO ALL
	REMOVE_MONEY_FROM_ALL_IN_RING,
	REMOVE_SCIENCE_FROM_ALL_IN_RING,
	REMOVE_MATERIAL_FROM_ALL_IN_RING,
	REMOVE_CORE_TO_FROM_IN_RING,	
	
	# MTF
	MTF_A,
	MTF_B,
	MTF_C,
	MTF_D,
	MTF_E,
	MTF_F,
	

	

}

# --------------------------------- SUBDIVISIONS
#var PREDICTIVE_TIMELINE:Dictionary = {
	#"name": "PREDICTIVE TIMELINE",
	#"description": "Show a most likely timeline of events.",
	#"energy_cost": 1,
	#"conditionals": [CONDITIONALS.TYPE.ENABLE_TIMELINE]
#}
#
#var OBJECTIVE_ASSIST:Dictionary = {
	#"name": "OBJECTIVES ASSIST",
	#"description": "Objectives are always visible on the main screen.",
	#"energy_cost": 1,
	#"conditionals": [CONDITIONALS.TYPE.ENABLE_OBJECTIVES]
#}


#var UPGRADE_ABL_LVL:Dictionary = {
	#"name": "LVL +1",
	#"description": "Increases the ability level of ALL rooms in a wing.",
	#"energy_cost": 4,
	##"wing": func(new_room_config:Dictionary, use_location:Dictionary) -> Dictionary:
		##new_room_config.floor[use_location.floor].ring[use_location.ring].abl_lvl += 1
		##return new_room_config,
#}
#
#var ADDITIONAL_STORE_UNLOCKS:Dictionary = {
	#"name": "ADDITIONAL STORE UNLOCKS",
	#"description": "Additional facilities can be unlocked in the store.",
	#"energy_cost": 4,
	##"floor_effect": func(floor_config_data:Dictionary) -> void:
		##if floor_config_data.room_unlock_val < 1:
			##floor_config_data.room_unlock_val = 1
		#
#}

# ---------------------------------
#var SUPPLY_SECURITY:Dictionary = {
	#"name": "EMPLOY SECURITY",
	#"description": "Makes SECURITY personnel available for the entire wing.",
	#"energy_cost": 1,
	#"personnel": [
		#RESOURCE.PERSONNEL.SECURITY
	#]
#}

## ---------------------------------
#var FIREARM_TRAINING:Dictionary = {
	#"name": "FIREARM TRAINING",
	#"description": "Increases SAFETY rating by 1.",
	#"energy_cost": 2,
	#"metrics": {
		#RESOURCE.METRICS.SAFETY: 1
	#}
#}
#
## ---------------------------------
#var HEAVY_WEAPONS_TRAINING:Dictionary = {
	#"name": "HEAVY WEAPONS TRAINING",
	#"description": "Increases READINESS rating by 1.",
	#"energy_cost": 3,
	#"metrics": {
		#RESOURCE.METRICS.READINESS: 1
	#}
#}
#
## ---------------------------------
#var TECH_SUPPORT:Dictionary = {
	#"name": "TECH SUPPORT",
	#"description": "Increases READINESS rating by 1.",
	#"energy_cost": 2,
	#"metrics": {
		#RESOURCE.METRICS.READINESS: 1
	#}	
#}
#
#
## ---------------------------------
#var MEMETIC_SHIELDING:Dictionary = {
	#"name": "MEMETIC SHIELDING",
	#"description": "Increases READINESS rating by 1.",
	#"energy_cost": 3,
	#"metrics":{
		#RESOURCE.METRICS.READINESS: 1
	#}
#}
#
## ---------------------------------
#var GENERATE_RESEARCH_FROM_SCP:Dictionary = {
	#"name": "GENERATE RESEARCH",
	#"description": "Research into contained object generates research.",
	#"energy_cost": 4,
	#"scp_required": true,
	#"currencies":{
		#RESOURCE.CURRENCY.SCIENCE: 1
	#}
#}
#
#var GENERATE_MONEY_FROM_SCP:Dictionary = {
	#"name": "GENERATE MONEY",
	#"description": "Research into contained object generates money.",
	#"energy_cost": 4,
	#"scp_required": true,
	#"currencies":{
		#RESOURCE.CURRENCY.MONEY: 1
	#}
#}
# ---------------------------------



# ---------------------------------
func get_ability(ref:REF, lvl_required:int = 0) -> Dictionary:
	var ability:Dictionary = {}

	match ref:
		#region SUBDIVSION
		# SUBDIVISONS
		REF.ADD_MONEY_TO_ALL_IN_RING:
			ability = {
				"name": "ADD MONEY",
				"description": "All facilities use MONEY.",
				"energy_cost": 3,
				"props": {
					"currency": RESOURCE.CURRENCY.MONEY
				}
			}
		REF.ADD_SCIENCE_TO_ALL_IN_RING:
			ability = {
				"name": "ADD SCIENCE",
				"description": "All facilities use SCIENCE.",
				"energy_cost": 3,
				"props": {
					"currency": RESOURCE.CURRENCY.SCIENCE
				}
			}			
		REF.ADD_MATERIAL_TO_ALL_IN_RING:
			ability = {
				"name": "ADD MATERIAL",
				"description": "All facilities use MATERIAL.",
				"energy_cost": 3,
				"props": {
					"currency": RESOURCE.CURRENCY.MATERIAL
				}
			}
		REF.ADD_CORE_TO_ALL_IN_RING:
			ability = {
				"name": "ADD MATERIAL",
				"description": "All facilities use MONEY.",
				"energy_cost": 3,
				"props": {
					"currency": RESOURCE.CURRENCY.MONEY
				}
			}
		#endregion
		
		#region MTF
		# MTF
		REF.MTF_A:
			ability = {
				"name": "MTF ALPHA",
				"description": "MTF ALPHA.",
				"energy_cost": 1,
				"mtf_ref": MTF.TEAM.ALPHA
			}
		REF.MTF_B:
			ability = {
				"name": "MTF BRAVO",
				"description": "MTF BRAVO.",
				"energy_cost": 1,
				"mtf_ref": MTF.TEAM.BRAVO
			}
		REF.MTF_C:
			ability = {
				"name": "MTF CHARLIE",
				"description": "MTF CHARLIE.",
				"energy_cost": 1,
				"mtf_ref": MTF.TEAM.CHARLIE
			}
		REF.MTF_D:
			ability = {
				"name": "MTF DELTA",
				"description": "MTF DELTA.",
				"energy_cost": 1,
				"mtf_ref": MTF.TEAM.DELTA
			}
		REF.MTF_E:
			ability = {
				"name": "MTF ECHO",
				"description": "MTF ECHO.",
				"energy_cost": 1,
				"mtf_ref": MTF.TEAM.ECHO
			}
		REF.MTF_F:
			ability = {
				"name": "MTF FOXTROT",
				"description": "MTF FOXTROT.",
				"energy_cost": 1,
				"mtf_ref": MTF.TEAM.FOXTROT
			}
		#endregion
		
		##region ACCOUNTING
		## MONEY
		#REF.ACCOUNTING_LVL_1:
			#ability = {
				#"name": "ACCOUNTING_LVL_1",
				#"description": "Generates ADDITIONAL MONEY if next to other accounting departments.",
				#"energy_cost": 1,
				#"currencies": { RESOURCE.CURRENCY.MONEY: 1 }
			#}
		#REF.ACCOUNTING_LVL_2:
			#ability = {
				#"name": "ACCOUNTING_LVL_2",
				#"description": "Generates ADDITIONAL MONEY if next to other accounting departments.",
				#"energy_cost": 2,
				#"currencies": { RESOURCE.CURRENCY.MONEY: 5 }
			#}
		#REF.ACCOUNTING_LVL_3:
			#ability = {
				#"name": "ACCOUNTING_LVL_3",
				#"description": "Generates ADDITIONAL MONEY if next to other accounting departments.",
				#"energy_cost": 3,
				#"currencies": { RESOURCE.CURRENCY.MONEY: 10 }
			#}
		##endregion
		


	ability.ref = ref
	ability.lvl_required = lvl_required
	return ability
