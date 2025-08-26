extends Node

enum TYPE {
	STARTING_PERK_1,
	STARTING_PERK_2,
	STARTING_PERK_3,
	
	#header
	SHOW_ECONOMY_IN_HEADER,
	SHOW_VIBES_IN_HEADER,
	SHOW_MTF_IN_HEADER,
	SHOW_POWER_IN_HEADER,
	SHOW_DANGERS_IN_HEADER,
	# ui
	ENABLE_TIMELINE,
	ENABLE_OBJECTIVES,
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
		TYPE.STARTING_PERK_1:
			return {
				"description": "Provides a random resource each turn."
			}
		TYPE.STARTING_PERK_2:
			return {
				"description": "Researching new facilities is cheaper."
			}
		TYPE.STARTING_PERK_3:
			return {
				"description": "Constructing new facilities is cheaper."
			}
			
		# --- Header Display Toggles
		TYPE.SHOW_ECONOMY_IN_HEADER:
			return {
				"description": "Displays the Economy."
			}
		TYPE.SHOW_VIBES_IN_HEADER:
			return {
				"description": "Displays the Vibes."
			}
		TYPE.SHOW_MTF_IN_HEADER:
			return {
				"description": "Displays Mobile Task Force status."
			}
		TYPE.SHOW_POWER_IN_HEADER:
			return {
				"description": "Displays power usage."
			}
		TYPE.SHOW_DANGERS_IN_HEADER:
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
