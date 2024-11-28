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
	"resources": {
		# cost to build 
		"build_cost": {
			RESOURCE.MONEY: 50,
		},
		# adds to capacity total
		"capacity": {
			RESOURCE.MTF: 6
		},
		# cost to maintaince per month (lose resources)
		"net":{
			RESOURCE.MONEY: -10,
			RESOURCE.ENERGY: -1
		},
	}
}

const DORMITORY:Dictionary = {
	"name": "DORMITORY",
	"resources": {
		"build_cost": {
			RESOURCE.MONEY: 50,
		},
		"capacity": {
			RESOURCE.STAFF: 10,
		},
		"net":{
			RESOURCE.MONEY: -3,
			RESOURCE.ENERGY: -1
		}
	}
}

const D_CLASS_PRISON:Dictionary = {
	"name": "D_CLASS_PRISON",
	"resources": {
		"build_cost": {
			RESOURCE.MONEY: 50,
		},
		"capacity": {
			RESOURCE.DCLASS: 10,
		},
		"net":{
			RESOURCE.MONEY: -5,
			RESOURCE.ENERGY: -2
		}
	}
}

const CAFETERIA:Dictionary = {
	"name": "CAFETERIA",
	"resources": {
		"build_cost": {
	
		},
		"capacity": {
			
		},
		"net":{

		}
	}
}

const SOLAR_PANELS:Dictionary = {
	"name": "SOLAR_PANELS",
	"resources": {
		"build_cost": {
			
		},
		"capacity": {
			RESOURCE.ENERGY: 5,
		},
		"net":{
			RESOURCE.ENERGY: 5
		}
	}
}

const STORAGE:Dictionary = {
	"name": "STORAGE",
	"resources": {
		"build_cost": {
	
		},
		"capacity": {

		},
		"maintaince_cost":{

		}
	}
}


const reference_data:Dictionary = {
	BUILDING_TYPE.NONE: NONE,
	BUILDING_TYPE.CAFETERIA: CAFETERIA,
	BUILDING_TYPE.BARRICKS: BARRICKS,
	BUILDING_TYPE.DORMITORY: DORMITORY,
	BUILDING_TYPE.SOLAR_PANELS: SOLAR_PANELS,
	BUILDING_TYPE.D_CLASS_PRISON: D_CLASS_PRISON
}

func get_type_arr() -> Array[Array]:
	return [
		[BUILDING_TYPE.DORMITORY, BUILDING_TYPE.BARRICKS, BUILDING_TYPE.D_CLASS_PRISON],
		[BUILDING_TYPE.CAFETERIA, BUILDING_TYPE.SOLAR_PANELS]
	]

func return_type_name(type:TYPE) -> String:
	return reference_data[type].name

func return_build_cost(type:TYPE) -> Dictionary:
	return reference_data[type].resources.build_cost

func return_resources(type:TYPE) -> Dictionary:
	return reference_data[type].resources
