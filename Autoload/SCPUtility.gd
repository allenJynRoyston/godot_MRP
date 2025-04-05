extends SubscribeWrapper

const prefered_greeting:String = "Sir"
const dlc_folder:String = "res://_DLC/"

var reference_data:Dictionary = {}
var reference_list:Array = []

var SCP_TEMPLATE:Dictionary = {
	# -----------------------------------
	"name": "SCP-X-TEMPLATE",
	"nickname": "NICKNAME",
	"img_src": "res://Media/images/redacted.png",
	"quote": "Lorem ipsum dolor sit amet consectetur adipiscing elit.",
	# -----------------------------------
	
	# -----------------------------------	
	"item_class": "SAFE",	
	"description": func(ref:ROOM.TYPE) -> Array:
		return [
			"Description line one",
			"Description line two"
		],
	# -----------------------------------

	# -----------------------------------
	"ongoing_containment": {
		RESOURCE.TYPE.MONEY: 25,
		RESOURCE.TYPE.SCIENCE: 25
	},
	# -----------------------------------

	# -----------------------------------
	"effects": {
		"metrics":{
			RESOURCE.BASE_METRICS.MORALE: 0,
			RESOURCE.BASE_METRICS.SAFETY: 0,
			RESOURCE.BASE_METRICS.READINESS: 0
		},
		"contained": {
			"description": "Contained description goes here.", 
			"effect": func(new_room_config:Dictionary, location:Dictionary) -> Dictionary:
				return new_room_config,
		},
		"uncontained": {
			"description": "Uncontained description goes here.", 
			"effect": func(new_room_config:Dictionary, location:Dictionary) -> Dictionary:
				return new_room_config,
		}
	},
	# -----------------------------------

	# -----------------------------------
	"breach_events_at": [10, 20, 30],
	# -----------------------------------

	# -----------------------------------
	"events": {
		SCP.EVENT_TYPE.AFTER_CONTAINMENT: func(_scp_details:Dictionary) -> Array:
			return [],
		SCP.EVENT_TYPE.WARNING: func(_scp_details:Dictionary) -> Array:
			return [],
	}
	# -----------------------------------
}

# ------------------------------------------------------------------------------
func _enter_tree() -> void:
	var dlc_dir:DirAccess = DirAccess.open(dlc_folder)
	var dlc_folders:Array = dlc_dir.get_directories()
	var ref_count:int = 0
	
	# goes through any folders in the _DLC folder
	for dfolder in dlc_folders:
		for folder_name in DirAccess.open(str(dlc_folder, dfolder)).get_directories():
			if folder_name == "SCP":
				for file_name in DirAccess.open(str(dlc_folder, dfolder, "/", folder_name)).get_files():
					if file_name.ends_with('.gd'):
						var file = FileAccess.open(str(dlc_folder, dfolder, "/", folder_name, "/", file_name), FileAccess.READ)
						if file:
							var script = load(str(dlc_folder, dfolder, "/", folder_name, "/", file_name))
							var instance:GDScript = GDScript.new()
							instance.source_code = script.source_code
							instance.reload()
							var ref_instance = instance.new()
							if "list" in ref_instance:
								for item in ref_instance.list:
									fill_template(item, ref_count)
									ref_count += 1
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------
func fill_template(data:Dictionary, ref:int) -> void:
	var template_copy:Dictionary = SCP_TEMPLATE.duplicate(true)		
	template_copy.name = "SCP-X-%s" % [str(0,ref + 1) if ref + 1 < 10 else ref + 1]
	for key in data:
		var value = data[key]
		if key in template_copy:
			template_copy[key] = value

	reference_list.push_back(ref)
	reference_data[ref] = template_copy
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func get_next_available_refs(just_added_scp:int) -> Array:
	var already_contained:Array = scp_data.contained_list.map(func(x): return x.ref)
	already_contained.push_back(just_added_scp)
	
	var filtered:Array = reference_list.filter(func(x): return x not in already_contained)
	filtered.shuffle()

	return filtered.slice(0, min(3, filtered.size()))
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func return_data(ref:int) -> Dictionary:
	reference_data[ref].ref = ref
	return reference_data[ref]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_ongoing_containment_rewards(ref:int) -> Array:
	var scp_details:Dictionary = return_data(ref)
	var list:Array = []

	for key in scp_details.ongoing_containment:	
		var amount:int = scp_details.ongoing_containment[key]
		list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_data(key)})
					
	return list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_unavailable_rooms(ref:int) -> Array: 
	return SHARED_UTIL.return_unavailable_rooms(return_data(ref))
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_ongoing_containment(ref:int, resources_data:Dictionary, refund:bool = false) -> Dictionary:
	return SHARED_UTIL.calculate_resources(return_data(ref), "ongoing_containment", resources_data, refund)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func calculate_refunded_utilizied(utilized_data:Dictionary, resources_data:Dictionary) -> Dictionary:
	var resource_data_copy:Dictionary = resources_data.duplicate(true)
	for key in utilized_data:
		resource_data_copy[key].utilized -= utilized_data[key]
		resource_data_copy[key].amount += utilized_data[key]
		if resource_data_copy[key].amount > resources_data[key].capacity:
			resource_data_copy[key].amount = resources_data[key].capacity
	
	return resource_data_copy
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func passes_metric_check(ref:int, use_location:Dictionary) -> bool:
	var scp_data:Dictionary = return_data(ref)
	var wing_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring]
	var current_metrics:Dictionary = wing_data.metrics
	
	var above_threshold:bool = true
	for metric_ref in scp_data.effects.metrics:
		var amount:int = scp_data.effects.metrics[metric_ref]
		var current_amount:int = current_metrics[metric_ref]
		if current_amount < amount:
			above_threshold = false
			break
		
	return above_threshold
# ------------------------------------------------------------------------------
	

# ------------------------------------------------------------------------------	
func check_for_events(ref:int, event_type:SCP.EVENT_TYPE, props:Dictionary) -> Array:
	var scp_details:Dictionary = return_data(ref)
	var event_instructions:Array = []
	
	if "events" in scp_details and event_type in scp_details.events:
		event_instructions = scp_details.events[event_type].call(scp_details, props)
		if !event_instructions.is_empty():
			return [{"event_instructions": event_instructions}]
	
	return []
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func return_event_testing_template(_dict:Dictionary) -> Array:
	var scp_details:Dictionary = _dict.details
	var list_details:Dictionary = _dict.list_details
	var resources_data:Dictionary = _dict.resources_data
	var research_completed:Array = list_details.data.research_completed
	var researcher_details:Array = _dict.researcher_details		
	var option_selected:Dictionary = {"val": null}
	var onSelected = func(val) -> void:
		option_selected.val = val
	
	var img_src:String = researcher_details[0].img_src
	var portrait_title_name:String = "RESEARCHER %s" % [researcher_details[0].name]
	
	if researcher_details.size() == 2:
		portrait_title_name = "RESEARCHERS %s and %s" % [researcher_details[0].name, researcher_details[1].name]
		
	if researcher_details.size() > 2:
		portrait_title_name = "RESEARCH TEAM"	
		# TODO: replace with group of researchers pic
		img_src = researcher_details[0].img_src
	
	return [
		func() -> Dictionary:
			return {
				"header": "UPDATE ON %s" % [scp_details.name],
				"img_src": img_src,
				"portrait": {
					"title": portrait_title_name,
					"img_src": 	img_src,
				},
				"text": [
					"%s, these are %s proposals for %s." % [prefered_greeting, "my" if researcher_details.size() < 2 else "our", scp_details.name]
				],
				"options": build_event_options_list(_dict, option_selected, onSelected)
			},
		func() -> Dictionary:
			return {
				"text": [
					"I'll begin immediately." if option_selected.val != -1 else "Probably for the best."
				],
				"set_return_val": func() -> Dictionary:
					return option_selected,
			}		
	]
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func build_event_options_list(_dict:Dictionary, option_selected:Dictionary, onSelected:Callable) -> Array:
	var details:Dictionary = _dict.details
	var list_details:Dictionary = _dict.list_details
	var resources_data:Dictionary = _dict.resources_data
	var researcher_details:Array = _dict.researcher_details	
	var research_completed:Array = list_details.data.research_completed
	var testing_options:Dictionary = details.testing_options

	# first, check if all research options are exhasted
	var options:Array = []
	for testing_ref in testing_options:
		var option:Dictionary = testing_options[testing_ref]
		var completed:bool = testing_ref in research_completed
		var repeatable:bool = option.repeatable if "repeatable" in option else false
		
		# -----------
		# checks if prerequirites have been met
		var prerequisites:Dictionary = option.prerequisites.call()
		var required_traits:Array = prerequisites.traits if "traits" in prerequisites else []
		var required_specilization:Array = prerequisites.specializations if "specializations" in prerequisites else []
		var requires_trait:bool = required_traits.size() > 0
		var requires_specilization:bool = required_specilization.size() > 0
		var all_traits:Array = []
		var all_specilization:Array = []
		
		for researcher in researcher_details:
			for key in researcher.traits:
				if key not in all_traits:
					all_traits.push_back(key)
			for key in researcher.specializations:
				if key not in all_specilization:
					all_specilization.push_back(key)

		var useable_traits:Array = required_traits.filter(func(i): return all_traits.has(i)).map(func(i): return RESEARCHER_UTIL.return_trait_data(i))
		var useable_specilization:Array = required_specilization.filter(func(i): return all_specilization.has(i)).map(func(i): return RESEARCHER_UTIL.return_specialization_data(i))
		var is_missing_traits:bool = false if !requires_trait else required_traits.filter(func(i): return all_traits.has(i)).size() == 0
		var is_missing_specilization:bool = false if !requires_specilization else required_specilization.filter(func(i): return all_specilization.has(i)).size() == 0
		
		var trait_tag:String = "[%s] " % useable_traits[0].fullname if useable_traits.size() > 0 else ""
		var specilization_tag:String = "[%s] " % useable_specilization[0].fullname if useable_specilization.size() > 0 else ""
		var usable_tag_string:String = "%s %s%s" % ["" if !completed else "[REPEAT]", trait_tag, specilization_tag]
		# -----------
		
		# -----------
		var not_enough_resources:bool = false
		var required_resources_amount:Dictionary = option.requirements.resources.amount.call() if "amount" in option.requirements.resources else {}
		var required_resources_utilized:Dictionary = option.requirements.resources.utilized.call() if "utilized" in option.requirements.resources else {}
		var required_notes:Dictionary = {
			"header": "Resources required",
			"list": []
		}
		var utilized_notes:Dictionary = {
			"header": "Resources utilized",
			"list": []
		}		
		
		var missing_resources:Array = []
		
		for key in required_resources_amount:
			var amount:int = required_resources_amount[key]
			var resource_details:Dictionary = RESOURCE_UTIL.return_data(key)
			required_notes.list.push_back({
				"is_checked": resources_data[key].amount >= amount,
				"icon": resource_details.icon, 
				"text": "[%s] %s %s" % [resource_details.name, amount, "(You have %s)" % [resources_data[key].amount] if resources_data[key].amount < amount else ""]
			})
			
			if resources_data[key].amount < amount:
				missing_resources.push_back(key)
				
		for key in required_resources_utilized:
			var amount:int = required_resources_utilized[key]
			var resource_details:Dictionary = RESOURCE_UTIL.return_data(key)
			utilized_notes.list.push_back({
				"is_checked": resources_data[key].amount >= amount,
				"icon": resource_details.icon, 
				"text": "[%s] %s %s" % [resource_details.name, amount, "(You have %s)" % [resources_data[key].amount] if resources_data[key].amount < amount else ""]
			})
			
			if resources_data[key].amount < amount:
				missing_resources.push_back(key)				
			
		
		var locked:bool = is_missing_traits or is_missing_specilization or missing_resources.size() > 0
		
		
		var lock_str:String = "PREREQUISITES MISSING: "
		if is_missing_traits:
			for data in required_traits.map(func(i): return RESEARCHER_UTIL.return_trait_data(i)):
				lock_str += " [TRAIT - %s]" % [data.fullname]

		if is_missing_specilization:
			for data in required_specilization.map(func(i): return RESEARCHER_UTIL.return_specialization_data(i)):
				lock_str += " [SPECIALIZATION - %s]" % [data.fullname]
		
		if missing_resources.size() > 0 and (!is_missing_traits and !is_missing_specilization) :
			lock_str = "%s [NOT ENOUGH RESOURCES]" % [option.name]
	
		if !completed or (completed and repeatable):
			options.push_back({
				"completed": testing_ref in research_completed,
				"repeatable": repeatable,
				"locked": locked,
				"notes": [required_notes, utilized_notes],
				"title": "%s%s" % ["%s " % [usable_tag_string] if !usable_tag_string.is_empty() else "", option.name] if !locked else "%s" % [lock_str], 
				"description": "",
				"val": testing_ref,
				"onSelected": onSelected			
			})

	options.push_back({
		"completed": false,
		"title": "I've changed my mind.",
		"val": -1,
		"onSelected": onSelected			
	})
	
				
	return options
# ------------------------------------------------------------------------------
