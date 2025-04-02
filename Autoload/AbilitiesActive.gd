extends Node

enum REF {
	CONTAIN_SCP,
	HIRE_RESEARCHER, PROMOTE_RESEARCHER,
	
	UNLOCK_FACILITIES
}

# ---------------------------------
var contain_scp:Dictionary = {
	"name": "CONTAIN SCP",
	"lvl_required": 0,
	"science_cost": 1,
	"cooldown_duration":  14, 
	"effect": func() -> bool:
		return await GAME_UTIL.contain_scp(),
}

# ---------------------------------
var hire_researcher:Dictionary = {
	"name": "HIRE RESEARCHER",
	"lvl_required": 0,
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		return await GAME_UTIL.recruit_new_researcher(2),
}

# ---------------------------------
var promote_researchers:Dictionary = {
	"name": "PROMOTE RESEARCHER",
	"lvl_required": 0,
	"science_cost": 50,
	"cooldown_duration":  5, 
	"effect": func() -> bool:
		return await GAME_UTIL.promote_researchers(),
}

# ---------------------------------
var unlock_facilities:Dictionary = {
	"name": "UNLOCK FACILITIES", 
	"lvl_required": 0,
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		return await GAME_UTIL.open_store(),
}

# ---------------------------------
func get_ability(ref:REF) -> Dictionary:
	var ability:Dictionary = {}
	match ref:
		REF.CONTAIN_SCP:
			ability = contain_scp
		# -----------------------------
		REF.HIRE_RESEARCHER:
			ability = hire_researcher
		REF.PROMOTE_RESEARCHER:
			ability = promote_researchers
		# -----------------------------
		REF.UNLOCK_FACILITIES:
			ability =  unlock_facilities
	
	ability.ref = ref
	return ability
	
