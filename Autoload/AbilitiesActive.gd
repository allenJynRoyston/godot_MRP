extends Node

enum REF {
	TRIGGER_ONSITE_NUKE,
	HIRE_RESEARCHER, PROMOTE_RESEARCHER, ADD_TRAIT, REMOVE_TRAIT,
	
	
	
	UNLOCK_FACILITIES,
	
	MONEY_HACK, SCIENCE_HACK, CONVERT_TO_SCIENCE, CONVERT_TO_MONEY
}

# ---------------------------------
var trigger_onsite_nuke:Dictionary = {
	"name": "TRIGGER ONSITE NUKE",
	"description": "Triggers the onsite nuclear device, destroying the site upon detonation.  WARNING:  this action cannot be undone and will result in a game over.",
	"science_cost": 0,
	"cooldown_duration":  99, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
		#return await GAME_UTIL.trigger_nuke(),
}

# ---------------------------------
var unlock_facilities:Dictionary = {
	"name": "UNLOCK FACILITIES", 
	"description": "Unlock new facilities and make them available for your site.",
	"science_cost": 0,
	"cooldown_duration":  0, 
	"effect": func() -> bool:
		return await GBL.find_node(REFS.GAMEPLAY_LOOP).open_store(),
}

# ---------------------------------
var promote_researchers:Dictionary = {
	"name": "PROMOTE RESEARCHER",
	"description": "Promote a researcher.",
	"science_cost": 50,
	"cooldown_duration":  5, 
	"effect": func() -> bool:
		return await GBL.find_node(REFS.GAMEPLAY_LOOP).promote_researchers(),
}

var hire_researcher:Dictionary = {
	"name": "HIRE RESEARCHER",
	"description": "Hire a researcher.",
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		return await GBL.find_node(REFS.GAMEPLAY_LOOP).hire_researcher(3),
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
		# -----------------------------=
		REF.TRIGGER_ONSITE_NUKE:
			ability = trigger_onsite_nuke
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
		REF.ADD_TRAIT:
			ability = add_trait
		REF.REMOVE_TRAIT:
			ability = remove_trait
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
	
