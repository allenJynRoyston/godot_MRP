extends SubscribeWrapper

enum REF {
	EVAL_SCP, 
	
	# site director
	TRIGGER_ONSITE_NUKE,
	
	# hire
	HIRE_RESEARCHERS, HIRE_SECURITY, HIRE_ADMIN, HIRE_DCLASS,	
	
	# personell
	CLONE_RESEARCHER, PROMOTE_RESEARCHER, ADD_TRAIT, REMOVE_TRAIT,
	
	# set
	SET_WARNING_MODE, SET_DANGER_MODE, 
	
	# upgrade/unlocks
	UPGRADE_FACILITY,
	UNLOCK_FACILITIES,
	
	# events
	HAPPY_HOUR, UNHAPPY_HOUR,
	
	# resource gain
	MONEY_HACK, SCIENCE_HACK, 
	
	# scp containment 
	CONVERT_TO_SCIENCE, CONVERT_TO_MONEY
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
var UNLOCK_FACILITIES:Dictionary = {
	"name": "UNLOCK FACILITIES", 
	"description": "Unlock new facilities and make them available for your site.",
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		return await GAME_UTIL.open_store(),
}

var UPGRADE_FACILITY:Dictionary = {
	"name": "UPGRADE FACILITY", 
	"description": "Upgrade a facility and unlock additional properties.",
	"cooldown_duration":  3, 
	"effect": func() -> bool:
		return await GAME_UTIL.upgrade_facility(),	
}

# ---------------------------------
var PROMOTE_RESEARCHER:Dictionary = {
	"name": "PROMOTE RESEARCHER",
	"description": "Promote a researcher.",
	"cooldown_duration":  0, 
	"effect": func() -> bool:
		return await GAME_UTIL.promote_researcher(),
}

var CLONE_RESEARCHER:Dictionary = {
	"name": "CLONE RESEARCHER",
	"description": "Clone a researcher.",
	"cooldown_duration":  0, 
	"effect": func() -> bool:
		return await GAME_UTIL.clone_researcher(),
}

var HIRE_RESEARCHERS:Dictionary = {
	"name": "HIRE RESEARCHERS",
	"description": "Hire 5 researcher (if room is available).",
	"cooldown_duration":  7, 
	"effect": func() -> bool:
		var costs := [{"amount": -(5 * 50), "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]	
		var confirm:bool = await GAME_UTIL.create_modal("Hire researchers?", "You have room for X reseearchers", "", costs )
		
		if confirm:
			for item in RESEARCHER_UTIL.generate_new_researcher_hires(5, RESEARCHER.SPECIALIZATION.RESEARCHER):
				hired_lead_researchers_arr.push_back(item)
			SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
			
		return confirm
}

var HIRE_SECURITY:Dictionary = {
	"name": "HIRE SECURITY",
	"description": "Hire 5 SECURITY (if room is available).",
	"cooldown_duration":  7, 
	"effect": func() -> bool:
		var costs := [{"amount": -(5 * 50), "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]	
		var confirm:bool = await GAME_UTIL.create_modal("Hire SECURITY?", "You have room for X reseearchers", "", costs )
		
		if confirm:
			for item in RESEARCHER_UTIL.generate_new_researcher_hires(5, RESEARCHER.SPECIALIZATION.SECURITY):
				hired_lead_researchers_arr.push_back(item)
			SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
			
		return confirm
}

var HIRE_ADMIN:Dictionary = {
	"name": "HIRE ADMIN",
	"description": "Hire 5 ADMIN (if room is available).",
	"cooldown_duration":  7, 
	"effect": func() -> bool:
		var costs := [{"amount": -(5 * 50), "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]	
		var confirm:bool = await GAME_UTIL.create_modal("Hire ADMIN?", "You have room for X reseearchers", "", costs )
		
		if confirm:
			for item in RESEARCHER_UTIL.generate_new_researcher_hires(5, RESEARCHER.SPECIALIZATION.ADMIN):
				hired_lead_researchers_arr.push_back(item)
			SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
			
		return confirm
}

var HIRE_DCLASS:Dictionary = {
	"name": "'HIRE' DCLASS",
	"description": "Hire 5 DCLASS (if room is available).",
	"cooldown_duration":  7, 
	"effect": func() -> bool:
		var costs := [{"amount": -(5 * 20), "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]	
		var confirm:bool = await GAME_UTIL.create_modal("Hire DCLASS?", "You have room for X reseearchers", "res://Media/images/dclass.jpg", costs )
		
		if confirm:
			for item in RESEARCHER_UTIL.generate_new_researcher_hires(5, RESEARCHER.SPECIALIZATION.DCLASS):
				hired_lead_researchers_arr.push_back(item)
			SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
			
		return confirm
}

var ADD_TRAIT:Dictionary = {
	"name": "ADD TRAIT",
	"description": "Allows a researcher to gain a new trait.",
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}

var REMOVE_TRAIT:Dictionary = {
	"name": "REMOVE TRAIT",
	"description": "Allows a researcher to remove an existing trait.",
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

var MONEY_HACK:Dictionary = {
	"name": "MONEY HACK", 
	"description": "Gain +25% of your current MONEY.",
	"science_cost": 50,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}

var SCIENCE_HACK:Dictionary = {
	"name": "SCIENCE HACK", 
	"description": "Gain +25% of your current SCIENCE.",
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}

var CONVERT_MONEY_TO_SCIENCE:Dictionary = {
	"name": "CONVERT TO SCIENCE", 
	"description": "Convert MONEY into SCIENCE.",
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		await U.set_timeout(0.5)
		return true,
}

var CONVERT_SCIENCE_TO_MONEY:Dictionary = {
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
			ability = UNLOCK_FACILITIES
		REF.UPGRADE_FACILITY:
			ability = UPGRADE_FACILITY
		# -----------------------------
		
		# -----------------------------
		REF.HIRE_RESEARCHERS:
			ability = HIRE_RESEARCHERS
		REF.HIRE_SECURITY:
			ability = HIRE_SECURITY
		REF.HIRE_ADMIN:
			ability = HIRE_ADMIN
		REF.HIRE_DCLASS:
			ability = HIRE_DCLASS
		# -----------------------------
		
		# -----------------------------
		REF.PROMOTE_RESEARCHER:
			ability = PROMOTE_RESEARCHER
		REF.CLONE_RESEARCHER:
			ability = CLONE_RESEARCHER
		REF.ADD_TRAIT:
			ability = ADD_TRAIT
		REF.REMOVE_TRAIT:
			ability = REMOVE_TRAIT
		# -----------------------------
		
		# -----------------------------
		REF.HAPPY_HOUR:
			ability = HAPPY_HOUR
		REF.UNHAPPY_HOUR:
			ability = UNHAPPY_HOUR
		# -----------------------------

		# -----------------------------
		REF.MONEY_HACK:
			ability = MONEY_HACK
		REF.SCIENCE_HACK:
			ability = SCIENCE_HACK
		REF.CONVERT_TO_SCIENCE:
			ability = CONVERT_MONEY_TO_SCIENCE
		REF.CONVERT_TO_MONEY:
			ability = CONVERT_SCIENCE_TO_MONEY
		# -----------------------------	

	
	ability.lvl_required = lvl_required
	ability.ref = ref
	return ability
	
