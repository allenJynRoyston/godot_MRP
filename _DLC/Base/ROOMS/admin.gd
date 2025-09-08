extends Node


static func get_room_data(ref:ROOM.REF) -> Dictionary:
	var room_data:Dictionary = {}
	match ref:
		# ----------------------------------------------------------------------
		ROOM.REF.ADMIN_DEPARTMENT:
			room_data = {
				"categories": [ROOM.CATEGORY.DEPARTMENT],
				"name": "ADMINISTRATION DEPARTMENT",
				"shortname": "ADMIN DEPT", 	
				"description": "Central hub for ADMIN facilities.",
				"quote": "The heart of the Site beats in paperwork and protocols.",

				"requires_unlock": false, 	
				
				"required_staffing": [],
				"required_energy": 1,
				
				"department_properties": {
					"operator": ROOM.OPERATOR.ADD,
					"currency": [],
					"metric": [RESOURCE.METRICS.MORALE],
					"level": 1,
					"effects": [ROOM.EFFECTS.ADMIN_DEFAULT],
				},
				
				"passive_abilities": func() -> Array: 
					return [
						ABL_P.get_ability(ABL_P.REF.ADD_MONEY_TO_ALL_IN_RING, 0)
					],
								
				
				"influence": {
					"description": "FACILITIES built here will influence the ADMIN DEPT."
				},
			}


	
	room_data.link_categories = ROOM.CATEGORY.ADMIN
	room_data.img_src = "res://Media/rooms/admin_section.png"
	room_data.ref = ref
	return room_data
