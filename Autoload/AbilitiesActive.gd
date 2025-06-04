extends Node

enum REF {
	EVAL_SCP, 
	
	TRIGGER_ONSITE_NUKE,
	SET_WARNING_MODE, SET_DANGER_MODE, 
	
	CLONE_RESEARCHER, HIRE_RESEARCHER, PROMOTE_RESEARCHER, ADD_TRAIT, REMOVE_TRAIT,
	
	UNLOCK_FACILITIES,
	
	HAPPY_HOUR, UNHAPPY_HOUR,
	
	MONEY_HACK, SCIENCE_HACK, CONVERT_TO_SCIENCE, CONVERT_TO_MONEY
}

# ---------------------------------
var EVAL_SCP:Dictionary = {
	"name": "EVAL SCP",
	"description": "Reveal an SCP's anamolous effect.",
	"science_cost": 0,
	"cooldown_duration":  0, 
	"effect": func() -> bool:
		return await GAME_UTIL.eval_scp(),
}
# ---------------------------------

# ---------------------------------
var TRIGGER_ONSITE_NUKE:Dictionary = {
	"name": "TRIGGER ONSITE NUKE",
	"description": "Triggers the onsite nuclear device, destroying the site upon detonation.  WARNING:  this action cannot be undone and will result in a game over.",
	"science_cost": 0,
	"cooldown_duration": 5, 
	"effect": func() -> bool:
		return await GAME_UTIL.set_onsite_nuke(),
}

var SET_WARNING_MODE:Dictionary = {
	"name": "SET WARNING MODE",
	"description": "Setting the floor level to WARNING.",
	"science_cost": 0,
	"cooldown_duration": 5, 
	"effect": func() -> bool:
		return await GAME_UTIL.set_warning_mode(),
}

var SET_DANGER_MODE:Dictionary = {
	"name": "SET DANGER MODE",
	"description": "Setting the floor level to DANGER.",
	"science_cost": 0,
	"cooldown_duration": 5, 
	"effect": func() -> bool:
		return await GAME_UTIL.set_danger_mode(),
}

# ---------------------------------
var unlock_facilities:Dictionary = {
	"name": "UNLOCK FACILITIES", 
	"description": "Unlock new facilities and make them available for your site.",
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		return await GAME_UTIL.open_store(),
}

# ---------------------------------
var promote_researchers:Dictionary = {
	"name": "PROMOTE RESEARCHER",
	"description": "Promote a researcher.",
	"science_cost": 0,
	"cooldown_duration":  0, 
	"effect": func() -> bool:
		return await GAME_UTIL.promote_researcher(),
}

var clone_researcher:Dictionary = {
	"name": "CLONE RESEARCHER",
	"description": "Clone a researcher.",
	"science_cost": 50,
	"cooldown_duration":  0, 
	"effect": func() -> bool:
		return await GAME_UTIL.clone_researcher(),
}

var hire_researcher:Dictionary = {
	"name": "HIRE RESEARCHER",
	"description": "Hire a researcher.",
	"science_cost": 0,
	"cooldown_duration":  0, 
	"effect": func() -> bool:
		return await GAME_UTIL.hire_researcher(3)
}

var add_trait:Dictionary = {
	"name": "ADD TRAIT",
	"description": "Allows a researcher to gain a new trait.",
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}

var remove_trait:Dictionary = {
	"name": "REMOVE TRAIT",
	"description": "Allows a researcher to remove an existing trait.",
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}



# --------------------------------- TODO
var HAPPY_HOUR:Dictionary = {
	"name": "HAPPY HOUR", 
	"description": "Gain the HAPPY HOUR buff.",
	"science_cost": 50,
	"cooldown_duration":  7, 
	"effect": func() -> bool:
		await GAME_UTIL.trigger_event([EVENT_UTIL.run_event(
			EVT.TYPE.HAPPY_HOUR, 
				{
					"onSelection": func(selection:Dictionary) -> void:
						# add buff, debuff
						print("todo: ADD BUFF OR DEBUFF depending on option")
						print(selection),
				}
			)
		])
		
		GAME_UTIL.add_buff_to_floor_and_rings(BASE.BUFF.MORALE_BOOST, 3)
		return true,
}

# --------------------------------- TODO
var UNHAPPY_HOUR:Dictionary = {
	"name": "UNHAPPY HOUR", 
	"description": "Gain the HAPPY HOUR buff.",
	"science_cost": 50,
	"cooldown_duration":  7, 
	"effect": func() -> bool:
		await GAME_UTIL.trigger_event([EVENT_UTIL.run_event(
			EVT.TYPE.UNHAPPY_HOUR, 
				{
					"onSelection": func(selection:Dictionary) -> void:
						# add buff, debuff
						print("todo: ADD BUFF OR DEBUFF depending on option")
						print(selection),
				}
			)
		])
		
		GAME_UTIL.add_debuff_to_floor_and_rings(BASE.DEBUFF.MORALE_DRAIN, 3)
		return true,
}

var money_hack:Dictionary = {
	"name": "MONEY HACK", 
	"description": "Gain +25% of your current MONEY.",
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}

var science_hack:Dictionary = {
	"name": "SCIENCE HACK", 
	"description": "Gain +25% of your current SCIENCE.",
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}

var convert_money_to_science:Dictionary = {
	"name": "CONVERT TO SCIENCE", 
	"description": "Convert MONEY into SCIENCE.",
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}

var convert_science_to_money:Dictionary = {
	"name": "CONVERT TO MONEY", 
	"description": "Convert SCIENCE into MONEY.",
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}
# ---------------------------------


# ---------------------------------
func get_ability(ref:REF, lvl_required:int = 0) -> Dictionary:
	var ability:Dictionary = {}
	match ref:
		REF.EVAL_SCP:
			ability = EVAL_SCP
		# -----------------------------=
		REF.TRIGGER_ONSITE_NUKE:
			ability = TRIGGER_ONSITE_NUKE
		REF.SET_WARNING_MODE:
			ability = SET_WARNING_MODE
		REF.SET_DANGER_MODE:
			ability = SET_DANGER_MODE
		# -----------------------------
		
		# -----------------------------
		REF.UNLOCK_FACILITIES:
			ability =  unlock_facilities
		# -----------------------------
		
		# -----------------------------
		REF.HIRE_RESEARCHER:
			ability = hire_researcher
		REF.PROMOTE_RESEARCHER:
			ability = promote_researchers
		REF.CLONE_RESEARCHER:
			ability = clone_researcher
		REF.ADD_TRAIT:
			ability = add_trait
		REF.REMOVE_TRAIT:
			ability = remove_trait
		# -----------------------------
		
		# -----------------------------
		REF.HAPPY_HOUR:
			ability = HAPPY_HOUR
		REF.UNHAPPY_HOUR:
			ability = UNHAPPY_HOUR
		# -----------------------------

		# -----------------------------
		REF.MONEY_HACK:
			ability = money_hack
		REF.SCIENCE_HACK:
			ability = science_hack
		REF.CONVERT_TO_SCIENCE:
			ability = convert_money_to_science
		REF.CONVERT_TO_MONEY:
			ability = convert_science_to_money
		# -----------------------------	

	
	ability.lvl_required = lvl_required
	ability.ref = ref
	return ability
	
