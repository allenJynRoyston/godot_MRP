extends Node

enum TYPE {
	ENABLE_TIMELINE,
	ENABLE_OBJECTIVES,
	
	DISABLE_MONEY_COLLECTION,
	DISABLE_SCIENCE_COLLECTION,
	DISABLE_MATERIAL_COLLECTION,
	DISABLE_CORE_COLLECTION,
	
	INFLUENCE_RANGE_IS_TWO,
	SET_MORALE_TO_ZERO,
	SET_READINESS_TO_ZERO,
	SET_SAFETY_TO_ZERO,
}

func return_data(ref:TYPE) -> Dictionary:
	match ref:
		## --- UI Toggles
		TYPE.ENABLE_TIMELINE:
			return {
				"description": "Enables the timeline interface."
			}
		TYPE.ENABLE_OBJECTIVES:
			return {
				"description": "Enables the objectives interface."
			}
		_:
			return {
				"description": "Condition not found."
			}
