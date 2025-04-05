extends Node

enum REF {
	TRIGGER_ONSITE_NUKE,
	CONTAIN_SCP,
	HIRE_RESEARCHER, PROMOTE_RESEARCHER,
	
	UNLOCK_FACILITIES
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
var hire_researcher:Dictionary = {
	"name": "HIRE RESEARCHER",
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		return await GAME_UTIL.recruit_new_researcher(2),
}

# ---------------------------------
var promote_researchers:Dictionary = {
	"name": "PROMOTE RESEARCHER",
	"science_cost": 50,
	"cooldown_duration":  5, 
	"effect": func() -> bool:
		return await GAME_UTIL.promote_researchers(),
}

# ---------------------------------
var unlock_facilities:Dictionary = {
	"name": "UNLOCK FACILITIES", 
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		return await GAME_UTIL.open_store(),
}

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
		REF.HIRE_RESEARCHER:
			ability = hire_researcher
		REF.PROMOTE_RESEARCHER:
			ability = promote_researchers
		# -----------------------------
		
		# -----------------------------
		REF.UNLOCK_FACILITIES:
			ability =  unlock_facilities
		# -----------------------------

	
	ability.lvl_required = lvl_required
	ability.ref = ref
	return ability
	
