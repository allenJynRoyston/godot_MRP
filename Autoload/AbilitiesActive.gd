extends SubscribeWrapper

enum REF {
	EVAL_SCP, 
	
	# site director
	TRIGGER_ONSITE_NUKE, CANCEL_NUCLEAR_DETONATION,
	
	# hire
	HIRE_RESEARCHERS, HIRE_SECURITY, HIRE_ADMIN, HIRE_DCLASS,	
	TRAIN_MTF,
	
	# personell
	CLONE_RESEARCHER, PROMOTE_RESEARCHER, ADD_TRAIT, REMOVE_TRAIT,
	
	# set
	SET_NORMAL_MODE, SET_CAUTION_MODE, SET_WARNING_MODE, SET_DANGER_MODE, 
	
	# upgrade/unlocks
	UPGRADE_FACILITY,
	UNLOCK_FACILITIES,
	
	# events
	HAPPY_HOUR, UNHAPPY_HOUR,
	
	# resource gain
	INSTANT_MONEY_LVL_1,
	INSTANT_SCIENCE_LVL_1,
	INSTANT_MATERIAL_LVL_1,
	INSTANT_CORE_LVL_1,
	
	# scp containment 
	CONVERT_MONEY_INTO_SCIENCE,
	CONVERT_MONEY_INTO_MATERIAL,
	CONVERT_MONEY_INTO_CORE,
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
	"description": "Triggers the onsite nuclear device, destroying the site upon detonation.  WARNING: this action cannot be canceled (unless you have a NUCLEAR FAILSAFE facility.)",
	"science_cost": 0,
	"cooldown_duration": 5, 
	"effect": func() -> bool:
		return await GAME_UTIL.set_onsite_nuke(),
}

var CANCEL_NUCLEAR_DETONATION:Dictionary = {
	"name": "CANCEL_NUCLEAR_DETONATION",
	"description": "Cancels the onsite nuclear detonation",
	"science_cost": 0,
	"cooldown_duration": 5, 
	"effect": func() -> bool:
		return await GAME_UTIL.cancel_onsite_nuke(),
}

var SET_NORMAL_MODE:Dictionary = {
	"name": "SET WARNING NORMAL",
	"description": "Set the emergency level to NORMAL.",
	"science_cost": 0,
	"cooldown_duration": 5, 
	"effect": func() -> bool:
		return await GAME_UTIL.set_emergency_mode_to_warning(),
}

var SET_CAUTION_MODE:Dictionary = {
	"name": "SET CAUTION MODE",
	"description": "Set the emergency level to CAUTION.",
	"science_cost": 0,
	"cooldown_duration": 5, 
	"effect": func() -> bool:
		return await GAME_UTIL.set_emergency_mode_to_caution(),
}

var SET_WARNING_MODE:Dictionary = {
	"name": "SET WARNING MODE",
	"description": "Set the emergency level to WARNING.",
	"science_cost": 0,
	"cooldown_duration": 5, 
	"effect": func() -> bool:
		return await GAME_UTIL.set_emergency_mode_to_warning(),
}

var SET_DANGER_MODE:Dictionary = {
	"name": "SET DANGER MODE",
	"description": "Set the emergency level to DANGER.",
	"science_cost": 0,
	"cooldown_duration": 5, 
	"effect": func() -> bool:
		return await GAME_UTIL.set_emergency_mode_to_warning(),
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
		return false
		#return await GAME_UTIL.upgrade_facility(),	
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
		var costs := [{"amount": -5, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]	
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
		var costs := [{"amount": -5, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]	
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
		var costs := [{"amount": -5, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]	
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
		var costs := [{"amount": -5, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]	
		var confirm:bool = await GAME_UTIL.create_modal("Hire DCLASS?", "You have room for X reseearchers", "res://Media/images/dclass.jpg", costs )
		
		if confirm:
			for item in RESEARCHER_UTIL.generate_new_researcher_hires(5, RESEARCHER.SPECIALIZATION.DCLASS):
				hired_lead_researchers_arr.push_back(item)
			SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
			
		return confirm
}

var TRAIN_MTF:Dictionary = {
	"name": "TRAIN_MTF",
	"description": "Train an MTF squad.",
	"cooldown_duration":  7, 
	"effect": func() -> bool:
		var costs := [{"amount": 400, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]	
		var confirm:bool = await GAME_UTIL.create_modal("Train an MTF squad?", "", "", costs )
		
		if confirm:
			print("add an mtf squad")
			#for item in RESEARCHER_UTIL.generate_new_researcher_hires(5, RESEARCHER.SPECIALIZATION.DCLASS):
				#hired_lead_researchers_arr.push_back(item)
			#SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
			
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

# -------------------------------------------------------------------------------------------------- RESOURCE GAIN
var INSTANT_MONEY_LVL_1:Dictionary = {
	"name": "INSTANT_MONEY_LVL_1", 
	"description": "Gain +3 MONEY instantly.",
	"science_cost": 50,
	"cooldown_duration":  3, 
	"effect": func() -> bool:
		var costs := [{"amount": 3, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)}]	
		var confirm:bool = await GAME_UTIL.create_modal("Use this ability?", "", "", costs )
		
		return confirm,
}

var INSTANT_SCIENCE_LVL_1:Dictionary = {
	"name": "INSTANT_SCIENCE_LVL_1", 
	"description": "Gain +3 SCIENCE instantly.",
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		var costs := [{"amount": 3, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.SCIENCE)}]	
		var confirm:bool = await GAME_UTIL.create_modal("Use this ability?", "", "", costs )
		
		return confirm,
}

var INSTANT_MATERIAL_LVL_1:Dictionary = {
	"name": "SCIENCE HACK", 
	"description": "Gain +3 MATERIAL instantly.",
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		var costs := [{"amount": 3, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MATERIAL)}]	
		var confirm:bool = await GAME_UTIL.create_modal("Use this ability?", "", "", costs )
		
		return confirm,
}

var INSTANT_CORE_LVL_1:Dictionary = {
	"name": "INSTANT_CORE_LVL_1", 
	"description": "Gain +3 CORE instantly.",
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		var costs := [{"amount": 3, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.CORE)}]	
		var confirm:bool = await GAME_UTIL.create_modal("Use this ability?", "", "", costs )
		
		return confirm,
}


var CONVERT_MONEY_INTO_SCIENCE:Dictionary = {
	"name": "CONVERT_MONEY_INTO_SCIENCE", 
	"description": "Convert MONEY into SCIENCE.",
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		var costs := [
			{ "amount": -1, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY) },
			{ "amount": 1, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.SCIENCE) }
		]	
		var confirm:bool = await GAME_UTIL.create_modal("Use this ability?", "", "", costs )
		
		return confirm,
}

var CONVERT_MONEY_INTO_MATERIAL:Dictionary = {
	"name": "CONVERT_MONEY_INTO_MATERIAL", 
	"description": "Convert MONEY into MATERIAL",
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		var costs := [
			{ "amount": -1, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY) },
			{ "amount": 1, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MATERIAL) }
		]	
		var confirm:bool = await GAME_UTIL.create_modal("Use this ability?", "", "", costs )
		
		return confirm,
}

var CONVERT_MONEY_INTO_CORE:Dictionary = {
	"name": "CONVERT_MONEY_INTO_CORE", 
	"description": "Convert MONEY into CORE.",
	"science_cost": 0,
	"cooldown_duration":  1, 
	"effect": func() -> bool:
		var costs := [
			{ "amount": -1, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY) },
			{ "amount": 1, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.CORE) }
		]	
		var confirm:bool = await GAME_UTIL.create_modal("Use this ability?", "", "", costs )
		
		return confirm,
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
		REF.CANCEL_NUCLEAR_DETONATION:
			ability = CANCEL_NUCLEAR_DETONATION
		REF.SET_NORMAL_MODE:
			ability = SET_NORMAL_MODE
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
		REF.TRAIN_MTF:
			ability = TRAIN_MTF
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
		REF.INSTANT_MONEY_LVL_1:
			ability = INSTANT_MONEY_LVL_1
		REF.INSTANT_SCIENCE_LVL_1:
			ability = INSTANT_SCIENCE_LVL_1
		REF.INSTANT_MATERIAL_LVL_1:
			ability = INSTANT_MATERIAL_LVL_1
		REF.INSTANT_CORE_LVL_1:
			ability = INSTANT_CORE_LVL_1			
			
		REF.CONVERT_MONEY_INTO_SCIENCE:
			ability = CONVERT_MONEY_INTO_SCIENCE
		REF.CONVERT_MONEY_INTO_MATERIAL:
			ability = CONVERT_MONEY_INTO_MATERIAL
		REF.CONVERT_MONEY_INTO_CORE:
			ability = CONVERT_MONEY_INTO_CORE			
		# -----------------------------	

	
	ability.lvl_required = lvl_required
	ability.ref = ref
	return ability
	
