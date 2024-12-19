extends Node

var specialization_data:Dictionary = { 
	RESEARCHER.SPECALIZATION.ENGINEERING: {
		"name": "Engineering", 
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func() -> void:
			return,
	}
}

var trait_data:Dictionary = {
	RESEARCHER.TRAIT.MOTIVATED: {
		"name": "Motivated", 
		"icon": SVGS.TYPE.ENERGY,
		"get_effect": func() -> void:
			return,
	},
}

# ------------------------------------------------------------------------------
func return_trait_data(key:RESEARCHER.TRAIT) -> Dictionary:
	return trait_data[key]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_specialization_data(key:RESEARCHER.SPECALIZATION) -> Dictionary:
	return specialization_data[key]
# ------------------------------------------------------------------------------
