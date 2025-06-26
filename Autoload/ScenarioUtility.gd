@tool
extends SubscribeWrapper
#
#enum TYPE {
	#TUTORIAL, SCENARIO, STORY
#}
#
#enum REF {
	#STORY, 
	#TUTORIAL_1, TUTORIAL_2, TUTORIAL_3,
	#
	#SCENARIO_1
#}

#
#var reference_list:Dictionary = {
	## -----------------------------------
	#REF.STORY: {
		#"type": TYPE.STORY,
		#"day_limit": 180,
		## -----------------
		#
		## -----------------
		#"reward": [],
		## -----------------
		#
		## -----------------
		#"objectives": [
			#{
				#"title": "CONTAIN ALL ANAMOLOUS OBJECTS.", 
				#"is_completed":func() -> bool:
					#return false,
			#},
			#{
				#"title": "SURVIVE AS LONG AS POSSIBLE...", 
				#"is_completed":func() -> bool:
					#return false,
			#}
		#],
		## -----------------
	#},
	## -----------------------------------
			#
	## -----------------------------------
	#REF.TUTORIAL_1: {
		## -----------------
		#"type": TYPE.TUTORIAL,
		#"title": "TUTORIAL 1",
		#"description": "Learn the basics of base building.",
		#"containment":{
			## STARTING SCP (or tutorial scp)
			#"initial": [SCP.REF.INSTRUCTION_MANUAL],  
			#"include": [],
			#"exclude": [],
		#},
		#"start_conditions": {
			#"starting_event": null,
			#"resources": {
				#RESOURCE.CURRENCY.MONEY: 200,
				#RESOURCE.CURRENCY.SCIENCE: 0,
				#RESOURCE.CURRENCY.MATERIAL: 0,
				#RESOURCE.CURRENCY.CORE: 1
			#},
			#"allowed_rooms": [
				##ROOM.TYPE.DIRECTORS_OFFICE,
				##ROOM.TYPE.HQ
			#]
		#},
		## rewards gained after winning
		#"day_limit": 7,		
		## -----------------
		#
		## -----------------
		## objectives and their respective checks
		#"objectives": [
			#{
				#"title": "Build an HQ.", 
				#"is_completed":func() -> bool:
					#return ROOM_UTIL.owns_and_is_active(0),
			#},
			#{
				#"title": "Build a DIRECTORS OFFICE.", 
				#"is_completed":func() -> bool:
					#return ROOM_UTIL.owns_and_is_active(0),
			#},
			#{
				#"title": "RESIST THE URGE TO TRIGGER THE ONSITE NUCLEAR DEVICE.", 
				#"is_completed":func() -> bool:
					#return false,
			#}			
		#],
		## -----------------
	#},
	## -----------------------------------		
	#
	## -----------------------------------
	#REF.TUTORIAL_2: {
		## -----------------
		#"type": TYPE.TUTORIAL,
		#"title": "TUTORIAL 2",
		#"description": "Learn the basics of abilities.",		
		#"containment":{
			## STARTING SCP (or tutorial scp)
			#"initial": [SCP.REF.INSTRUCTION_MANUAL],  
			#"include": [],
			#"exclude": [],
		#},
		#"start_conditions": {
			#"starting_event": null,
			#"allowed_rooms": [
				##ROOM.TYPE.HR_DEPARTMENT
			#]
		#},
		## rewards gained after winning
		## limit to scenario
		#"day_limit": 5,		
		## -----------------
		#
		#
		## -----------------
		## objectives and their respective checks
		#"objectives": [
			#{
				#"title": "Build a CONTAINMENT CELL.", 
				#"is_completed":func() -> bool:
					#return ROOM_UTIL.owns_and_is_active(0),
			#},
			#{
				#"title": "Hire a lead researcher.", 
				#"is_completed":func() -> bool:
					#return ROOM_UTIL.owns_and_is_active(0),
			#}
		#],
		## -----------------
	#},
	## -----------------------------------			
	#
	## -----------------------------------
	#REF.TUTORIAL_3: {
		## -----------------
		#"type": TYPE.TUTORIAL,
		#"title": "TUTORIAL 3",
		#"description": "Learn the basics of hiring and staffing.",		
		#"containment":{
			## STARTING SCP (or tutorial scp)
			#"initial": [SCP.REF.INSTRUCTION_MANUAL],  
			#"include": [],
			#"exclude": [],
		#},
		#"start_conditions": {
			#"starting_event": null,
			#"allowed_rooms": [
				##ROOM.TYPE.HR_DEPARTMENT
			#]
		#},
		## rewards gained after winning
		## limit to scenario
		#"day_limit": 5,		
		## -----------------
		#
		## -----------------
		## objectives and their respective checks
		#"objectives": [
			#{
				#"title": "Build a CONTAINMENT CELL.", 
				#"is_completed":func() -> bool:
					#return ROOM_UTIL.owns_and_is_active(0),
			#},
			#{
				#"title": "Hire a lead researcher.", 
				#"is_completed":func() -> bool:
					#return ROOM_UTIL.owns_and_is_active(0),
			#}
		#],
		## -----------------
	#},
	## -----------------------------------				
	#
	## -----------------------------------
	#REF.SCENARIO_1: {
		## -----------------
		#"type": TYPE.SCENARIO,
		#"title": "SCENARIO 1",
		#"description": "Make money; spend money.",		
		#"containment":{
			## STARTING SCP (or tutorial scp)
			#"initial": [SCP.REF.INSTRUCTION_MANUAL],  
			#"include": [],
			#"exclude": [],
		#},
		#"start_conditions": {
			#"starting_event": null,
			#"allowed_rooms": [
				##ROOM.TYPE.HR_DEPARTMENT
			#]
		#},
		## rewards gained after winning
		## limit to scenario
		#"day_limit": 5,		
		## -----------------
		#
		## -----------------
		## objectives and their respective checks
		#"objectives": [
			#{
				#"title": "Build a CONTAINMENT CELL.", 
				#"is_completed":func() -> bool:
					#return ROOM_UTIL.owns_and_is_active(0),
			#},
			#{
				#"title": "Hire a lead researcher.", 
				#"is_completed":func() -> bool:
					#return ROOM_UTIL.owns_and_is_active(0),
			#}
		#],
		## -----------------
	#}
	## -----------------------------------					
#}
#
## ------------------------------------------------------------------------------	
#func get_scenario_data(ref:int) -> Dictionary:
	#var scenario_data_copy:Dictionary = reference_list[ref].duplicate(true)
	#if "start_conditions" not in scenario_data_copy:
		#scenario_data_copy.start_conditions = {}
	#
	## default resources for every scenario that does not define it
	#if "resources" not in scenario_data_copy.start_conditions:
		#scenario_data_copy.start_conditions.resources = {
			#RESOURCE.CURRENCY.MONEY: 100,
			#RESOURCE.CURRENCY.SCIENCE: 50,
			#RESOURCE.CURRENCY.MATERIAL: 25,
			#RESOURCE.CURRENCY.CORE: 1
		#}
	#
	#if "allowed_rooms" not in scenario_data_copy.start_conditions:
		#scenario_data_copy.start_conditions.allowed_rooms = []
	#
	#if "starting_event" not in scenario_data_copy.start_conditions:
		#scenario_data_copy.start_conditions.starting_event = null
	#
	#return scenario_data_copy
## ------------------------------------------------------------------------------	
#
## ------------------------------------------------------------------------------	
#func get_awarded_rooms(ref:int, return_details:bool = false) -> Array:
	#var scenario_data_copy:Dictionary = get_scenario_data(ref)
	#if !return_details:
		#var list:Array = []
		#for room_ref in scenario_data_copy.start_conditions.allowed_rooms:
			#list.push_back(ROOM_UTIL.type_ref_to_ref(room_ref))
		#return list 
	#else:
		#var details_list:Array = []
		#for room_ref in scenario_data_copy.start_conditions.allowed_rooms:
			#details_list.push_back(ROOM_UTIL.return_data(ROOM_UTIL.type_ref_to_ref(room_ref)))
		#return details_list	
## ------------------------------------------------------------------------------	
#
## ------------------------------------------------------------------------------	
#func get_list_of_scenarios() -> Array:
	#var scenarios:Array = []
	#for ref in reference_list:
		#if reference_list[ref].type == TYPE.SCENARIO:
			#var details:Dictionary = reference_list[ref]
			#scenarios.push_back({"ref": ref, "details": details})
	#return scenarios
## ------------------------------------------------------------------------------	
#
## ------------------------------------------------------------------------------	
#func get_list_of_tutorials() -> Array:
	#var scenarios:Array = []
	#for ref in reference_list:
		#if reference_list[ref].type == TYPE.TUTORIAL:
			#var details:Dictionary = reference_list[ref]
			#scenarios.push_back({"ref": ref, "details": details})
	#return scenarios
## ------------------------------------------------------------------------------	
