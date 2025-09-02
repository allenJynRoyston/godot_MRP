extends Node

enum TYPE {
	ADMIN_PERK_1,
	ADMIN_PERK_2,
	ADMIN_PERK_3,
	
	LOGISTIC_PERK_1, 
	LOGISTIC_PERK_2,
	LOGISTIC_PERK_3,
	
	SCIENCE_PERK_1,
	SCIENCE_PERK_2,
	SCIENCE_PERK_3,	
	
	# SUBDIVISONS
	ENABLE_ADMIN_SUBDIVISON,
	ENABLE_LOGISTIC_SUBDIVISON,
	
	# UI
	UI_ENABLE_ECONOMY,
	UI_ENABLE_VIBES,
	UI_ENABLE_PERSONNEL,
	UI_ENABLE_DANGERS,
	UI_ENABLE_MTF,
	UI_ENABLE_ENERGY,
			

	# ui
	ENABLE_TIMELINE,
	ENABLE_OBJECTIVES,
	
	# logistics
	ENABLE_RUSH_CONSTRUCTION,
	ENABLE_RECYCLE,
	
	# actoin bar
	SHOW_INFO_BTN,
	
	# currency buffs
	PLUS_MONEY_1,
	PLUS_SCIENCE_1,
	PLUS_MATERIAL_1,
	PLUS_CORE_1
}

func return_data(ref:TYPE) -> Dictionary:
	match ref:
		# --- Starting Perks
		TYPE.ADMIN_PERK_1:
			return {
				"description": "Provides +10 random resources each turn."
			}
		TYPE.ADMIN_PERK_2:
			return {
				"description": "All facilities start at level 1."
			}
		TYPE.ADMIN_PERK_3:
			return {
				"description": "Facilities are built instantly."
			}
			
		TYPE.LOGISTIC_PERK_1:
			return {
				"description": "PERK 1 DESCRIPTION."
			}			
		TYPE.LOGISTIC_PERK_2:
			return {
				"description": "PERK 2 DESCRIPTION."
			}
		TYPE.LOGISTIC_PERK_3:
			return {
				"description": "PERK 3 DESCRIPTION."
			}			
			
		# --- Starting Perks
		TYPE.SCIENCE_PERK_1:
			return {
				"description": "Containment Cells always produce RESEARCH."
			}
		TYPE.SCIENCE_PERK_2:
			return {
				"description": "R&D is cheaper."
			}
		TYPE.SCIENCE_PERK_3:
			return {
				"description": "R&D has shorter cooldown."
			}
		
		TYPE.ENABLE_ADMIN_SUBDIVISON:
			return {
				"description": "Can construct ADMINISTRATION subdivisons."
			}
		TYPE.ENABLE_LOGISTIC_SUBDIVISON:
			return {
				"description": "Can construct LOGISTIC subdivisons."
			}			
		
		# --- Header Display Toggles
		TYPE.UI_ENABLE_ECONOMY:
			return {
				"description": "Displays the Economy."
			}
		TYPE.UI_ENABLE_PERSONNEL:
			return {
				"description": "Displays Personnel data."
			}			
		TYPE.UI_ENABLE_VIBES:
			return {
				"description": "Displays the Vibes."
			}
		TYPE.UI_ENABLE_MTF:
			return {
				"description": "Displays Mobile Task Force status."
			}
		TYPE.UI_ENABLE_ENERGY:
			return {
				"description": "Displays power usage."
			}
		TYPE.UI_ENABLE_DANGERS:
			return {
				"description": "Displays danger levels."
			}
			
		# --- UI Toggles
		TYPE.ENABLE_TIMELINE:
			return {
				"description": "Enables the timeline interface."
			}
		TYPE.ENABLE_OBJECTIVES:
			return {
				"description": "Enables the objectives interface."
			}
		
			
		# --- Action Bar
		TYPE.ENABLE_RUSH_CONSTRUCTION:
			return {
				"description": "Enables facilities under construction to be RUSHED."
			}
		TYPE.ENABLE_RECYCLE:
			return {
				"description": "Facilities that are destroyed are recycled instead (half of cost is refunded)."
			}
			
		TYPE.SHOW_INFO_BTN:
			return {
				"description": "Displays the information button in the action bar."
			}
			
		# --- Currency Buffs
		TYPE.PLUS_MONEY_1:
			return {
				"description": "Any facility that makes at least one MONEY will now make an additional one."
			}
		TYPE.PLUS_SCIENCE_1:
			return {
				"description": "Any facility that makes at least one SCIENCE will now make an additional one."
			}
		TYPE.PLUS_MATERIAL_1:
			return {
				"description": "Any facility that makes at least one MATERIAL will now make an additional one."
			}
		TYPE.PLUS_CORE_1:
			return {
				"description": "Any facility that makes at least one CORE will now make an additional one."
			}
			
		# --- Default
		_:
			return {
				"description": "Condition not found."
			}
