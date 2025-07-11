extends Node

enum TYPE {
	# -------------
	GAME_OVER,
	# -------------
	
	# ------------
	SCP_ON_CONTAINMENT,
	SCP_BREACH_EVENT_1,
	SCP_BREACH_EVENT_2,
	SCP_CONTAINED_EVENT,
	SCP_NO_STAFF_EVENT,
	SCP_CONTAINMENT_AWARD_EVENT,
	# ------------
	
	# ------------
	
	OBJECTIVE_REWARD,
	# ------------

	# -------------
	HIRE_RESEARCHER,
	CLONE_RESEARCHER,
	PROMOTE_RESEARCHER,
	DISMISS_RESEARCHER, 	
	# -------------
	
	# -------------
	HAPPY_HOUR, 
	UNHAPPY_HOUR
	# -------------
}

enum CONSEQUENCE {
	END,
	
	CHANGE_STATUS_TO_KIA, 
	CHANGE_STATUS_TO_INSANE,
	
	HP_HEAL, HP_HURT,
	SP_HEAL, SP_HURT,
	
	MOOD_CHANGED_TO_STABLE,
	MOOD_CHANGED_TO_FRIGHTENED,
	MOOD_CHANGED_TO_DEPRESSED,
	MOOD_CHANGED_TO_RELUCTANT,

}

const CONSEQUENCE_STR:Dictionary = {
	# ----------------------
	CONSEQUENCE.HP_HEAL: "is healed!",
	CONSEQUENCE.SP_HEAL: "is healed!",
	CONSEQUENCE.HP_HURT: "is hurt!",
	CONSEQUENCE.SP_HURT: "is slipping into madness!",	
	# ----------------------
	CONSEQUENCE.CHANGE_STATUS_TO_KIA: "has been KILLED!",
	CONSEQUENCE.CHANGE_STATUS_TO_INSANE: "has gone INSANE!",	
	# ----------------------
	CONSEQUENCE.MOOD_CHANGED_TO_STABLE: "is now feeling STABLE.",
	CONSEQUENCE.MOOD_CHANGED_TO_FRIGHTENED: "is now feeling FRIGHTENED!",
	CONSEQUENCE.MOOD_CHANGED_TO_DEPRESSED: "is now feeling DEPRESSED!",
	CONSEQUENCE.MOOD_CHANGED_TO_RELUCTANT: "is now feeling RELUCTANT!"
	# ----------------------
}

func get_consequence_str(ref:CONSEQUENCE) -> String:
	return EVT.CONSEQUENCE_STR[ref]
