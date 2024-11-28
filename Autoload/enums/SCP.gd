extends Node

enum ITEM { 
	NONE, 
	ONE, TWO
}

const NONE:Dictionary = {
	"name": 'NONE'
}

const ONE:Dictionary = {
	"name": 'ONE',
	"containment_reward": [
		[RESOURCE.MONEY, 35]
	],
	"required_resources": [ 
		[RESOURCE.STAFF, 5] 
	]
}

const TWO:Dictionary = {
	"name": 'TWO',
	"containment_reward": [
		[RESOURCE.MONEY, 50]
	],
	"required_resources": [ 
		[RESOURCE.STAFF, 10] 
	]	
}

const reference_data:Dictionary = {
	ITEM.NONE: NONE,
	ITEM.ONE: ONE,
	ITEM.TWO: TWO
}

# ------------------------------------------------------------------------------
func get_reference_data(item:ITEM) -> Dictionary:
	return reference_data[item]
# ------------------------------------------------------------------------------	
