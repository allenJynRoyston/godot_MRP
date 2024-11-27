extends Node

enum TYPE { 
	NONE, 
	BARRICKS, DORMITORY, SOLAR_PANELS, CAFETERIA, STORAGE, D_CLASS_PRISON
}

const NONE:Dictionary = {
	"name": 'NONE'
}

const BARRICKS:Dictionary = {
	"name": "BARRICKS",
	"build_cost": {
		"money": 3,
	},
	"resources": {
		"capacity": {
			"mtf": 10,
		},
		"cost":{
			"money": 3,
		}
	}
}

const DORMITORY:Dictionary = {
	"name": "DORMITORY",
	"build_cost": {
		"money": 3,
	},	
	"resources": {
		"capacity": {
			"staff": 10,
		},
		"cost":{
			"money": 3,
		}
	}
}

const CAFETERIA:Dictionary = {
	"name": "CAFETERIA",
	"build_cost": {
		"money": 3,
	},	
	"resources": {
		"gain": {
			
		},
		"cost":{
			"staff": 3,
			"money": 3,
		}
	}
}

const SOLAR_PANELS:Dictionary = {
	"name": "SOLAR_PANELS",
	"build_cost": {
		"money": 3,
	},	
	"resources": {
		"gain": {
			"energy": 2
		},
		"cost":{
			"money": 2,
		}
	}
}

const STORAGE:Dictionary = {
	"name": "STORAGE",
	"build_cost": {
		"money": 3,
	},	
	"resources": {
		"capacity": {
			"staff": 10,
		},
		"cost":{
			"money": 1,
		}
	}
}

const D_CLASS_PRISON:Dictionary = {
	"name": "D_CLASS_PRISON",
	"build_cost": {
		"money": 3,
	},	
	"resources": {
		"capacity": {
			"dclass": 10,
		},
		"cost":{
			"money": 2,
		}
	}
}

const reference_data:Dictionary = {
	TYPE.NONE: NONE,
	TYPE.CAFETERIA: CAFETERIA,
	TYPE.BARRICKS: BARRICKS,
	TYPE.DORMITORY: DORMITORY,
	TYPE.SOLAR_PANELS: SOLAR_PANELS,
	TYPE.D_CLASS_PRISON: D_CLASS_PRISON
}

func get_type_arr() -> Array[Array]:
	return [
		[TYPE.NONE, TYPE.DORMITORY, TYPE.BARRICKS, TYPE.CAFETERIA],
		[TYPE.SOLAR_PANELS, TYPE.D_CLASS_PRISON]
	]

func return_type_name(type:TYPE) -> String:
	return reference_data[type].name

func return_build_cost(type:TYPE) -> Dictionary:
	return reference_data[type].build_cost

func return_resources(type:TYPE) -> Dictionary:
	return reference_data[type].resources
