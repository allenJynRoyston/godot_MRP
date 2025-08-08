extends SubscribeWrapper

enum TEAM {ALPHA, BRAVO, CHARLIE, DELTA, ECHO, FOXTROT}

var ALPHA:Dictionary = {
	"name": "ALPHA",
	"description": "Description"
}

var BRAVO:Dictionary = {
	"name": "BRAVO",
	"description": "Description"
}

var CHARLIE:Dictionary = {
	"name": "CHARLIE",
	"description": "Description"
}

var DELTA:Dictionary = {
	"name": "DELTA",
	"description": "Description"
}

var ECHO:Dictionary = {
	"name": "ECHO",
	"description": "Description"
}

var FOXTROT:Dictionary = {
	"name": "FOXTROT",
	"description": "Description"
}

var reference_data:Dictionary = {
	TEAM.ALPHA: ALPHA,
	TEAM.BRAVO: BRAVO,
	TEAM.CHARLIE: CHARLIE,
	TEAM.DELTA: DELTA,
	TEAM.ECHO: ECHO,
}

# ------------------------------------------------------------------------------
func return_data(ref:MTF.TEAM) -> Dictionary:
	reference_data[ref].ref = ref
	return reference_data[ref]
# ------------------------------------------------------------------------------
