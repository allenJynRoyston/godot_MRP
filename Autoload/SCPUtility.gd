extends SubscribeWrapper

const prefered_greeting:String = "Sir"
const dlc_folder:String = "res://_DLC/"

var reference_data:Dictionary = {}
var reference_list:Array = []

enum ITEM_CLASS {SAFE, EUCLID, KETER}

var SCP_TEMPLATE:Dictionary = {
	# -----------------------------------
	"nickname": "NICKNAME",								# whatever the nickname of it will be
	"description": func(scp_details:Dictionary) -> String:
		return "%s" % scp_details.name,
	"abstract":  func(scp_details:Dictionary) -> String:
		return "%s" % scp_details.name,
	"img_src": "res://Media/images/redacted.png",			# image reference
	# -----------------------------------
	
	# -----------------------------------
	"containment_requirements": [
		#SCP.CONTAINMENT_TYPES.PHYSICAL
	],
	"days_until_contained": 10,
	"breach_chance": 0,
	# -----------------------------------
	
	# ------------------------------------------
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.CORE: 0
	},
		
	"metrics": {
		RESOURCE.METRICS.MORALE: 0,
		RESOURCE.METRICS.SAFETY: 0,
		RESOURCE.METRICS.READINESS: 0,
	},	
	# ------------------------------------------
	
	# ------------------------------------------
	"effect": {},
	#{
		#"description": "Effect description",
		#"effect": func(_new_room_config:Dictionary, _item:Dictionary) -> Dictionary:
			#return _new_room_config,
		#"after_effect": func(_new_room_config:Dictionary, _item:Dictionary) -> Dictionary:
			#return _new_room_config,
	#},	
	# ------------------------------------------

	# ------------------------------------------
	"event": {
		# ----------------------------
		EVT.TYPE.SCP_ON_CONTAINMENT: [
			{
				"story": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"INITIAL CONTAINMENT",
					],

				"choices": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "MORALE OPTION",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.MORALE, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"MORALE SUCCESS"
									] if is_success else [
										"MORALE FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "SAFETY OPTION",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.SAFETY, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"SAFETY SUCCESS"
									] if is_success else [
										"SAFETY FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "READINESS OPTION",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.READINESS, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"READINESS SUCCESS"
									] if is_success else [
										"READINESS FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "ALT OPTION.",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"ALT SUCCESS"
									] if is_success else [
										"ALT FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------					
					],
				
			},
			{
				"story": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"END EVENT",
					],
			}
		],
		# ----------------------------
		
		# ----------------------------
		EVT.TYPE.SCP_BREACH_EVENT_1: [
			{
				"story": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"EVENT BREACH",
					],

				"choices": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "MORALE OPTION",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.MORALE, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"MORALE SUCCESS"
									] if is_success else [
										"MORALE FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "SAFETY OPTION",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.SAFETY, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"SAFETY SUCCESS"
									] if is_success else [
										"SAFETY FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "READINESS OPTION",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.READINESS, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"READINESS SUCCESS"
									] if is_success else [
										"READINESS FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "ALT OPTION.",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"ALT SUCCESS"
									] if is_success else [
										"ALT FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------					
					],
				
			},
			{
				"story": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"END EVENT",
					],
			}			
		],
		# ----------------------------
		
		# ----------------------------
		EVT.TYPE.SCP_CONTAINED_EVENT: [
			{
				"story": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"CONTAINED EVENT STORY",
					],

				"choices": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "MORALE OPTION",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.MORALE, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"MORALE SUCCESS"
									] if is_success else [
										"MORALE FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "SAFETY OPTION",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.SAFETY, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"SAFETY SUCCESS"
									] if is_success else [
										"SAFETY FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "READINESS OPTION",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.READINESS, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"READINESS SUCCESS"
									] if is_success else [
										"READINESS FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "ALT OPTION.",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"ALT SUCCESS"
									] if is_success else [
										"ALT FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------					
					],
				
			},
			{
				"story": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"END EVENT",
					],
			}			
		],
		# ----------------------------		
		
		# ----------------------------
		EVT.TYPE.SCP_NO_STAFF_EVENT: [
			{
				"story": func(props:Dictionary) -> Array:
					var _scp_details:Dictionary = props.scp_details
					return [
						"NO STAFF EVENT",
					],

				"choices": func(props:Dictionary) -> Array:
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "MORALE OPTION",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.MORALE, {}, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"MORALE SUCCESS"
									] if is_success else [
										"MORALE FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "SAFETY OPTION",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.SAFETY, {}, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"SAFETY SUCCESS"
									] if is_success else [
										"SAFETY FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "READINESS OPTION",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.READINESS, {}, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"READINESS SUCCESS"
									] if is_success else [
										"READINESS FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "ALT OPTION.",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"ALT SUCCESS"
									] if is_success else [
										"ALT FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------					
					],
				
			},
			{
				"story": func(props:Dictionary) -> Array:
					var _scp_details:Dictionary = props.scp_details
					return [
						"END EVENT",
					],
			}			
		],
		# ----------------------------				
	}
	# ------------------------------------------
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
var spec_count:int = 0
var trait_count:int = 0
func fill_template(data:Dictionary, ref:int) -> void:
	var template_copy:Dictionary = SCP_TEMPLATE.duplicate(true)		
	# assign "name"
	
	# replace any matching keys
	for key in data:
		var value = data[key]
		if key in template_copy:
			template_copy[key] = value

	template_copy.name = "SCP-T-0%s" % [str(0,ref + 1) if ref + 1 < 10 else ref + 1]


	reference_list.push_back(ref)
	reference_data[ref] = template_copy#
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func get_paginated_list(start_at:int, limit:int) -> Dictionary:
	var list:Array = reference_list.map(func(x): return return_data(x))

	# Slice the list based on start_at and limit
	var sliced_list:Array = list.slice(start_at, start_at + limit)

	return {
		"list": sliced_list,
		"size": list.size(),
		"has_more": limit < list.size()
	}
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func return_data(ref:int) -> Dictionary:
	reference_data[ref].ref = ref
	return reference_data[ref]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_unavailable_rooms(ref:int) -> Array: 
	return SHARED_UTIL.return_unavailable_rooms(return_data(ref))
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
func get_breach_event_chance(ref:int, use_location:Dictionary, base_percentage:int = 80) -> int:
	var scp_data:Dictionary = SCP_UTIL.return_data(ref)	
	var room_data:Dictionary = ROOM_UTIL.return_data_via_location(use_location)
	
	var requirements:Array = scp_data.containment_requirements
	var containment_properties:Array = room_data.containment_properties
	var requirement_count:int = 0
	for requirement in requirements:
		if requirement in containment_properties:
			requirement_count += 1
	
	var percentage:float = (requirement_count * 1.0) / (scp_data.containment_requirements.size() * 1.0)
	var chance_rate:int = roundi(base_percentage * percentage)

	return 100 - chance_rate
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------	
#func check_for_events(ref:int, event_type:SCP.EVENT_TYPE, props:Dictionary) -> Array:
	#var scp_details:Dictionary = return_data(ref)
	#var event_instructions:Array = []
	#
	#if "events" in scp_details and event_type in scp_details.events:
		#event_instructions = scp_details.events[event_type].call(scp_details, props)
		#if !event_instructions.is_empty():
			#return [{"event_instructions": event_instructions}]
	#
	#return []
# ------------------------------------------------------------------------------	



# -----------------------------------------------------------
func get_render_from_metrics(ref:int, staff_details:Dictionary, vibes:Dictionary, threshold_amount:int = 0) -> Dictionary:
	var available_amount:int = vibes[ref]
	var is_threshold_met:bool = available_amount >= threshold_amount
	var property:String
	var lockout:bool = false 
	var current_amount:int = 0
	var hint_description:String = "%s must be at least %s (Currently at %s)." % [property, threshold_amount, available_amount]
	
	match ref:
		RESOURCE.METRICS.MORALE:
			property = "MORALE"
			current_amount = vibes[RESOURCE.METRICS.MORALE]
			if !staff_details.is_empty() and  staff_details.mood.ref == RESEARCHER.MOODS.DEPRESSED:
				lockout = true
				hint_description = "Unavailable due to current mood."
		RESOURCE.METRICS.SAFETY:
			property = "SAFETY"
			current_amount = vibes[RESOURCE.METRICS.SAFETY]
			if !staff_details.is_empty() and staff_details.mood.ref == RESEARCHER.MOODS.FRIGHTENED:
				lockout = true
				hint_description = "Unavailable due to current mood."			
		RESOURCE.METRICS.READINESS:
			property = "READINESS"
			current_amount = vibes[RESOURCE.METRICS.READINESS]
			if !staff_details.is_empty() and staff_details.mood.ref == RESEARCHER.MOODS.RELUCTANT:
				lockout = true
				hint_description = "Unavailable due to current mood."
	
	return {
		"lockout": lockout,
		"property": property,
		"current_amount": current_amount,
		"is_available": is_threshold_met,
		"hint_description": hint_description
	}
	
func get_render_from_currencies(ref:int, threshold_amount:int, staff_details:Dictionary, ) -> Dictionary:
	var available_amount:int = resources_data[ref].amount
	var is_threshold_met:bool = available_amount >= threshold_amount
	var has_resourceful_trait:bool = false
	var property:String
	var show:bool = staff_details.trait.ref == RESEARCHER.TRAITS.RESOURCEFUL
	
	match ref:
		RESOURCE.CURRENCY.MONEY:
			property = "MONEY"
		RESOURCE.CURRENCY.MATERIAL:
			property = "MATERIAL"
		RESOURCE.CURRENCY.SCIENCE:
			property = "SCIENCE"
		RESOURCE.CURRENCY.CORE:
			property = "CORE"
		
	return {
		"show": show,
		"property": property,
		"is_available": is_threshold_met and has_resourceful_trait,
		"cost": {"currency": ref, "amount": threshold_amount, "text": "Expend %s %s?" % [threshold_amount, property]},
		"hint_description": "%s must have at least %s (You currently have %s)." % [property, threshold_amount, available_amount]
	}

func get_success_rate(ref:int, vibes:Dictionary, baseline:int = 10, factor_of:int = 20) -> int:
	var success_rate:int = baseline + (vibes[ref] * factor_of)
	return U.min_max(success_rate, 0, 100)
	
	
func staff_is_killed(scp_details:Dictionary, staff_details:Dictionary) -> Dictionary:
	return {
		"staff": { 
			"action": 'kia',
			"scp_details": scp_details,
			"staff_details": staff_details
		}
	}
# -----------------------------------------------------------

# -----------------------------------------------------------
func get_containment_type_str(types_arr:Array) -> String:
	var str:String = ""
	for i in types_arr.size():
		var ref = types_arr[i]
		str += SCP.return_type_data(ref).name
		if i < types_arr.size() - 1:
			str += ", "
	return str
# -----------------------------------------------------------


# ---------------------------------------------	FOR EVENTS
#enum OPTION {CURRENCY}
#
#var option_selected:Dictionary = {"store": null}
#
#func onSelected(item:Dictionary) -> void: 
	#option_selected.store = item
#
#func getSelectedOption() -> Dictionary:
	#return option_selected.store.option
#
#func getSelectedIndex() -> int:
	#return option_selected.store.index
#
#func getSelectedVal():
	#return option_selected.store.option.val
	#
#func build_option(dict:Dictionary = {}) -> Dictionary:
	#var title:String = dict.title if "title" in dict else ""
	#var change:Dictionary = dict.change if "change" in dict else {}
	#var description_list:Array = []
	#var is_locked:bool = false
	#var onSelectedChild:Callable = onSelected
	#
	#for type in change:
		#match type:
			#OPTION.CURRENCY:
				#var arr:Array = []
				#for key in change[type]:
					#var details:Dictionary = RESOURCE_UTIL.return_currency(key)
					#var amount:int = change[type][key]
					#if amount != 0:
						#var description:String = "WILL %s [%s] %s." % ["CONSUME" if amount < 0 else "GAIN", absi(amount), details.name]
						#description_list.push_back({
							#"text": description, 
							#"font_color": Color.RED if amount < 0 else Color.GREEN
						#})
						#
						#if amount > resources_data[key].amount and !is_locked:
							#is_locked = true
							#
						#arr.push_back(func() -> void: 
							##resources_data[key].capacity
							#resources_data[key].amount = U.min_max(resources_data[key].amount + amount, 0, 999999))
					#
					#onSelectedChild = func(item:Dictionary) -> void:
						#option_selected.store = item
						#for arr_item in arr:
							#arr_item.call()
						#SUBSCRIBE.resources_data = resources_data
#
	#if title.is_empty():
		#title = "DO NOTHING"
		#description_list = []
	#
	#return 	{
		#"include": true,
		#"title": title,
		#"description_list": description_list, 
		#"locked": is_locked,
		#"val": true,
		#"onSelected": onSelectedChild
	#}
	#
## ---------------------------------------------
