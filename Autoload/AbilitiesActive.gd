extends Node

enum REF {
	TRIGGER_ONSITE_NUKE,
	CONTAIN_SCP,
	HIRE_RESEARCHER, PROMOTE_RESEARCHER, ADD_TRAIT, REMOVE_TRAIT,
	
	
	
	UNLOCK_FACILITIES,
	
	MONEY_HACK, SCIENCE_HACK, CONVERT_TO_SCIENCE, CONVERT_TO_MONEY
}

# ---------------------------------
var trigger_onsite_nuke:Dictionary = {
	"name": "TRIGGER ONSITE NUKE",
	"science_cost": 0,
	"cooldown_duration":  99, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
		#return await GAME_UTIL.trigger_nuke(),
}

# ---------------------------------
var contain_scp:Dictionary = {
	"name": "CONTAIN SCP",
	"science_cost": 1,
	"cooldown_duration":  14, 
	"effect": func() -> bool:
		return await GAME_UTIL.contain_scp(),
}

# ---------------------------------
var promote_researchers:Dictionary = {
	"name": "PROMOTE RESEARCHER",
	"science_cost": 50,
	"cooldown_duration":  5, 
	"effect": func() -> bool:
		return await GAME_UTIL.promote_researchers(),
}

var hire_researcher:Dictionary = {
	"name": "HIRE RESEARCHER",
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		return await GAME_UTIL.recruit_new_researcher(2),
}

var add_trait:Dictionary = {
	"name": "ADD TRAIT",		
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}

var remove_trait:Dictionary = {
	"name": "REMOVE TRAIT",
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}

# ---------------------------------
var unlock_facilities:Dictionary = {
	"name": "UNLOCK FACILITIES", 
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		return await GAME_UTIL.open_store(),
}

# --------------------------------- TODO
var money_hack:Dictionary = {
	"name": "MONEY HACK", 
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}

var science_hack:Dictionary = {
	"name": "SCIENCE HACK", 
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}

var convert_money_to_science:Dictionary = {
	"name": "CONVERT TO SCIENCE", 
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}

var convert_science_to_money:Dictionary = {
	"name": "CONVERT TO MONEY", 
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
		REF.CONTAIN_SCP:
			ability = contain_scp
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
	
