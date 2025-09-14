extends Node

enum REF {
	# EFFECTS
	PROCUREMENT_PASSIVE_1,
	PROCUREMENT_PASSIVE_2,
	
	ADMIN_PASSIVE_1,
	ENGINEERING_PASSIVE_1,
	SECURITY_PASSIVE_1,
	SCIENCE_PASSIVE_1,
	LOGISTICS_PASSIVE_1,
	ANTIMEMETICS_PASSIVE_1,
	THEOLOGY_PASSIVE_1,
	TEMPORAL_PASSIVE_1,
	MISCOMMUNICATION_PASSIVE_1,
	PATAPHYSICS_PASSIVE_1,
	
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



# ---------------------------------
func get_ability(ref:REF, lvl_required:int = 0) -> Dictionary:
	var ability:Dictionary = {}
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	
	var passive_description_func:Callable = func(_ref:int, _use_location:Dictionary) -> String:
		var room_level_config:Dictionary = GAME_UTIL.get_room_level_config(_use_location)
		var description_string:String = ROOM.return_effect(_ref).description.call(room_level_config.department_props.operator if !room_level_config.department_props.is_empty() else ROOM.OPERATOR.ADD)
		# strip out bbbcode
		return regex.sub(description_string, "", true)	
	
	match ref:
		#region SUBDIVSION
		REF.PROCUREMENT_PASSIVE_1:
			ability = {
				"name": "SYNCHRONIZED",
				"description": passive_description_func,
				"energy_cost": 3,
				"apply_self": {
					"effects": ROOM.EFFECTS.PROCUREMENT_PASSIVE_1
				}
			}
		REF.PROCUREMENT_PASSIVE_2:
			ability = {
				"name": "STREAMLINED",
				"description": passive_description_func,
				"energy_cost": 5,
				"apply_all": {
					"effects": ROOM.EFFECTS.PROCUREMENT_PASSIVE_2
				}
			}
			
		REF.ENGINEERING_PASSIVE_1:
			ability = {
				"name": "ENERGY BOOST",
				"description": passive_description_func,
				"energy_cost": 3,
				"apply_self": {
					"effects": ROOM.EFFECTS.ENGINEERING_PASSIVE_1
				}
			}
		REF.LOGISTICS_PASSIVE_1:
			ability = {
				"name": "EFFICIENCY",
				"description": passive_description_func,
				"energy_cost": 3,
				"apply_self": {
					"effects": ROOM.EFFECTS.LOGISTICS_PASSIVE_1
				}
			}
		REF.SCIENCE_PASSIVE_1:
			ability = {
				"name": "SCIENCE!",
				"description": passive_description_func,
				"energy_cost": 3,
				"apply_self": {
					"effects": ROOM.EFFECTS.SCIENCE_PASSIVE_1
				}
			}			
		REF.ADMIN_PASSIVE_1:
			ability = {
				"name": "AGILE METHODOLOGY",
				"description": passive_description_func,
				"energy_cost": 3,
				"apply_self": {
					"effects": ROOM.EFFECTS.ADMIN_PASSIVE_1
				}
			}
		REF.SECURITY_PASSIVE_1:
			ability = {
				"name": "TWO OR LESS",
				"description": passive_description_func,
				"energy_cost": 3,
				"apply_self": {
					"effects": ROOM.EFFECTS.SECURITY_PASSIVE_1
				}
			}
		REF.TEMPORAL_PASSIVE_1:
			ability = {
				"name": "SHIFTING PRIORITIES",
				"description": passive_description_func,
				"energy_cost": 3,
				"apply_self": {
					"effects": ROOM.EFFECTS.TEMPORAL_PASSIVE_1
				}
			}
		REF.THEOLOGY_PASSIVE_1:
			ability = {
				"name": "MO MONEY MO PROBLEMS",
				"description": passive_description_func,
				"energy_cost": 3,
				"apply_self": {
					"effects": ROOM.EFFECTS.THEOLOGY_PASSIVE_1
				}
			}				
		REF.PATAPHYSICS_PASSIVE_1:
			ability = {
				"name": "THIS IS A MIROR YOU ARE A TYPO",
				"description": passive_description_func,
				"energy_cost": 3,
				"apply_all": {
					"effects": ROOM.EFFECTS.PATAPHYSICS_PASSIVE_1
				}
			}
		REF.ANTIMEMETICS_PASSIVE_1:
			ability = {
				"name": "TWO OR LESS",
				"description": passive_description_func,
				"energy_cost": 3,
				"apply_self": {
					"effects": ROOM.EFFECTS.ANTIMEMETICS_PASSIVE_1
				}
			}
		REF.MISCOMMUNICATION_PASSIVE_1:
			ability = {
				"name": "TWO WRONGS EQUAL A RIGHT",
				"description": passive_description_func,
				"energy_cost": 3,
				"apply_self": {
					"effects": ROOM.EFFECTS.MISCOMMUNICATION_PASSIVE_1
				}
			}			
			
		#region SUBDIVSION
		# SUBDIVISONS
		REF.ADD_MONEY_TO_ALL_IN_RING:
			ability = {
				"name": "ADD MONEY",
				"description": func(_ref:int, _use_location:Dictionary) -> String:
					return "MONEY",
				"energy_cost": 3,
				"apply_all": {
					"currency": RESOURCE.CURRENCY.MONEY
				}
			}
		REF.ADD_SCIENCE_TO_ALL_IN_RING:
			ability = {
				"name": "ADD SCIENCE",
				"description": func(_ref:int, _use_location:Dictionary) -> String:
					return "SCIENCE",
				"energy_cost": 3,
				"apply_all": {
					"currency": RESOURCE.CURRENCY.SCIENCE
				}
			}			
		REF.ADD_MATERIAL_TO_ALL_IN_RING:
			ability = {
				"name": "ADD MATERIAL",
				"description": func(_ref:int, _use_location:Dictionary) -> String:
					return "MATERIAL",
				"energy_cost": 3,
				"apply_all": {
					"currency": RESOURCE.CURRENCY.MATERIAL
				}
			}
		REF.ADD_CORE_TO_ALL_IN_RING:
			ability = {
				"name": "ADD CORE",
				"description": func(_ref:int, _use_location:Dictionary) -> String:
					return "CORE",
				"energy_cost": 3,
				"apply_all": {
					"currency": RESOURCE.CURRENCY.MONEY
				}
			}
		#endregion
		
		#region MTF
		# MTF
		REF.MTF_A:
			ability = {
				"name": "MTF ALPHA",
				"description": func(_ref:int, _use_location:Dictionary) -> String:
					return "ALPHA",
				"energy_cost": 1,
				"mtf_ref": MTF.TEAM.ALPHA
			}
		REF.MTF_B:
			ability = {
				"name": "MTF BRAVO",
				"description": func(_ref:int, _use_location:Dictionary) -> String:
					return "BRAVO",
				"energy_cost": 1,
				"mtf_ref": MTF.TEAM.BRAVO
			}
		REF.MTF_C:
			ability = {
				"name": "MTF CHARLIE",
				"description": func(_ref:int, _use_location:Dictionary) -> String:
					return "CHARLIE",
				"energy_cost": 1,
				"mtf_ref": MTF.TEAM.CHARLIE
			}
		REF.MTF_D:
			ability = {
				"name": "MTF DELTA",
				"description": func(_ref:int, _use_location:Dictionary) -> String:
					return "DELTA",
				"energy_cost": 1,
				"mtf_ref": MTF.TEAM.DELTA
			}
		REF.MTF_E:
			ability = {
				"name": "MTF ECHO",
				"description": func(_ref:int, _use_location:Dictionary) -> String:
					return "ECHO",
				"energy_cost": 1,
				"mtf_ref": MTF.TEAM.ECHO
			}
		REF.MTF_F:
			ability = {
				"name": "MTF FOXTROT",
				"description": func(_ref:int, _use_location:Dictionary) -> String:
					return "FOXTROT",
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
