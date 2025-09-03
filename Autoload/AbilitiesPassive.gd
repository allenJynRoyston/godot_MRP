extends Node

enum REF {
	# BRANCHES
	ENABLE_ADMIN_BRANCH,
	ENABLE_LOGISTIC_BRANCH,
	ENABLE_ENGINEERING_BRANCH,
	
	# UI
	#UI_ENABLE_ECONOMY,
	UI_ENABLE_VIBES,
	UI_ENABLE_PERSONNEL, 
	UI_ENABLE_DANGERS,
	
	# HR
	HR_ADMIN_BONUS,
	HR_RESEARCHER_BONUS,
	HR_SECURITY_BONUS,
	HR_DCLASS_BONUS,
	
	# IA
	IA_LEVEL_1,
	IA_LEVEL_2,
	IA_LEVEL_3,
	
	# ADDITIONAL MONEY
	#ACCOUNTING_LVL_1,
	#ACCOUNTING_LVL_2,
	#ACCOUNTING_LVL_3,
	
	# MTF
	MTF_A,
	MTF_B,
	MTF_C,
	MTF_D,
	MTF_E,
	MTF_F,
	

	
	# ADDITIONAL SCIENCE
	GENERATE_SCIENCE_LVL_1,
	GENERATE_MATERIAL_LVL_1,
	GENERATE_CORE_LVL_1	
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
		REF.ENABLE_ADMIN_BRANCH:
			ability = {
				"name": "ENABLE_ADMIN_SUBDIVISON",
				"description": "Can build an Admin Branch.",
				"energy_cost": 5,
				"conditionals": [CONDITIONALS.TYPE.ENABLE_ADMIN_BRANCH]
			}
			
		REF.ENABLE_LOGISTIC_BRANCH:
			ability = {
				"name": "ENABLE_LOGISTIC_SUBDIVISON",
				"description": "Can build an Logistics Branch.",
				"energy_cost": 5,
				"conditionals": [CONDITIONALS.TYPE.ENABLE_LOGISTIC_BRANCH]
			}
			
		REF.ENABLE_ENGINEERING_BRANCH:
			ability = {
				"name": "ENABLE_ENGINEERING_BRANCH",
				"description": "Can build an Engineering Branch.",
				"energy_cost": 5,
				"conditionals": [CONDITIONALS.TYPE.ENABLE_LOGISTIC_BRANCH]
			}
		#endregion
		
		#region UI
		# UI
		#REF.UI_ENABLE_ECONOMY: 
			#ability = {
				#"name": "UI_ENABLE_ECONOMY",
				#"description": "Enables the ECONOMY panel in the UI.",
				#"energy_cost": 1,
				#"conditionals": [CONDITIONALS.TYPE.UI_ENABLE_ECONOMY]
			#}
		REF.UI_ENABLE_VIBES:
			ability = {
				"name": "UI_ENABLE_VIBES",
				"description": "Enables the VIBES panel in the UI.",
				"energy_cost": 1,
				"conditionals": [CONDITIONALS.TYPE.UI_ENABLE_VIBES]
			}			
		REF.UI_ENABLE_PERSONNEL:
			ability = {
				"name": "UI_ENABLE_PERSONNEL",
				"description": "Enables the PERSONNEL panel in the UI.",
				"energy_cost": 1,
				"conditionals": [CONDITIONALS.TYPE.UI_ENABLE_PERSONNEL]
			}			
		REF.UI_ENABLE_DANGERS:
			ability = {
				"name": "UI_ENABLE_DANGERS",
				"description": "Enables the WARNING panel in the UI.",
				"energy_cost": 1,
				"conditionals": [CONDITIONALS.TYPE.UI_ENABLE_DANGERS]
			}			
		#endregion

		#region HR
		REF.HR_ADMIN_BONUS:
			ability = {
				"name": "HR_ADMIN_BONUS",
				"description": "Generates extra MONEY for each ADMIN.",
				"energy_cost": 3,
				"effect": func(_new_room_config:Dictionary, _resources_data:Dictionary, _location:Dictionary) -> void:
					var counts:Dictionary = ROOM_UTIL.get_personnel_counts()
					_resources_data[RESOURCE.CURRENCY.MONEY].diff += counts[RESEARCHER.SPECIALIZATION.ADMIN]
			}						
		REF.HR_RESEARCHER_BONUS:
			ability = {
				"name": "HR_RESEARCHER_BONUS",
				"description": "Generates extra SCIENCE for each ADMIN staff assigned.",
				"energy_cost": 3,
				"effect": func(_new_room_config:Dictionary, _resources_data:Dictionary, _location:Dictionary) -> void:
					var counts:Dictionary = ROOM_UTIL.get_personnel_counts()
					_resources_data[RESOURCE.CURRENCY.SCIENCE].diff += counts[RESEARCHER.SPECIALIZATION.RESEARCHER]
			}						
		REF.HR_SECURITY_BONUS:
			ability = {
				"name": "HR_SECURITY_BONUS",
				"description": "Generates extra MATERIAL for each ADMIN staff assigned.",
				"energy_cost": 3,
				"effect": func(_new_room_config:Dictionary, _resources_data:Dictionary, _location:Dictionary) -> void:
					var counts:Dictionary = ROOM_UTIL.get_personnel_counts()
					_resources_data[RESOURCE.CURRENCY.MATERIAL].diff += counts[RESEARCHER.SPECIALIZATION.SECURITY]
			}						
		REF.HR_DCLASS_BONUS:
			ability = {
				"name": "HR_DCLASS_BONUS",
				"description": "Generates extra CORE for each DCLASS staff assigned.",
				"energy_cost": 3,
				"effect": func(_new_room_config:Dictionary, _resources_data:Dictionary, _location:Dictionary) -> void:
					var counts:Dictionary = ROOM_UTIL.get_personnel_counts()
					_resources_data[RESOURCE.CURRENCY.CORE].diff += counts[RESEARCHER.SPECIALIZATION.DCLASS]
			}						
		#endregion

		#region HR
		REF.IA_LEVEL_1:
			ability = {
				"name": "IA_LEVEL_1",
				"description": "Implements basic oversight, slightly increasing safety while mildly lowering morale.",
				"energy_cost": 1,
				"metrics":{
					RESOURCE.METRICS.SAFETY: 1,
					RESOURCE.METRICS.MORALE: -1,
				}
			}						
		REF.IA_LEVEL_2:
			ability = {
				"name": "IA_LEVEL_2",
				"description": "Enforces stricter monitoring, further boosting safety at the cost of staff satisfaction.",
				"energy_cost": 2,
				"metrics":{
					RESOURCE.METRICS.SAFETY: 1,
					RESOURCE.METRICS.MORALE: -1,
				}
			}						
		REF.IA_LEVEL_3:
			ability = {
				"name": "IA_LEVEL_3",
				"description": "Full-scale internal audits maximize site safety, but heavily strain staff morale.",
				"energy_cost": 3,
				"metrics":{
					RESOURCE.METRICS.SAFETY: 1,
					RESOURCE.METRICS.MORALE: -1,
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
		
		#region SCIENCE
		# SCIENCE
		REF.GENERATE_SCIENCE_LVL_1:
			ability = {
				"name": "GENERATE SCIENCE",
				"description": "Room generates SCIENCE.",
				"energy_cost": 2,
				"currencies": { RESOURCE.CURRENCY.SCIENCE: 1 }
			}
		REF.GENERATE_MATERIAL_LVL_1:
			ability = {
				"name": "GENERATE MATERIAL",
				"description": "Room generates MATERIAL.",
				"energy_cost": 2,
				"currencies": { RESOURCE.CURRENCY.MATERIAL: 1 }
			}
		REF.GENERATE_CORE_LVL_1:
			ability = {
				"name": "GENERATE CORE",
				"description": "Room generates CORE.",
				"energy_cost": 3,
				"currencies": { RESOURCE.CURRENCY.CORE: 1 }
			}
		#endregion

	ability.ref = ref
	ability.lvl_required = lvl_required
	return ability
