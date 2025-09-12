extends SubscribeWrapper

var SCP_DLC_0:Dictionary = {
	"nickname": "SCP_DLC_0",
	"img_src": "res://Media/scps/mirror_frame.png",	
	"description": func(_scp_details:Dictionary) -> String:	
		return "%s description." % _scp_details.name,
	"quote": func(_scp_details:Dictionary) -> String: 
		return "Add short quote...",
		
	"containment_requirements": [
		SCP.CONTAINMENT_TYPES.PHYSICAL,
	],

	"effect": {
		"description": "All adjacent rooms generate +1 RESEARCH.",
	},	
}


# -----------------------------------
var list:Array[Dictionary] = [
	SCP_DLC_0
]
# -----------------------------------
