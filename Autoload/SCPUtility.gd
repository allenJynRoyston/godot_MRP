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
	"breach_check_frequency": 3,
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
	"event": {
		EVT.TYPE.SCP_ON_CONTAINMENT: {
			"story": func(_staff_details:Dictionary, _scp_details:Dictionary) -> Array:
				return [
					"%s is selected for the story." % _staff_details.name,
					"The SCP looks poised to kill this researcher.  How do you respond?"
				],
			"choices": func(_staff_details:Dictionary, _scp_details:Dictionary) -> Dictionary:
				return {
					"standard": [
							{
								# uses money
								"show": true,
								"title": "Do nothing.",
								"success_rate": 100,
								"story": func(is_success:bool) -> Array: 
									return [
										"Do nothing success."
									] if is_success else [
										"Do nothing fails."
									],
								"effect": func(is_success:bool) -> void:
									pass,
							},						
							{
								# uses money
								"show": true,
								"title": "Option A",
								"success_from": RESOURCE.METRICS.MORALE,
								"story": func(is_success:bool) -> Array: 
									return [
										"Option A success."
									] if is_success else [
										"Option A fails."
									],
								"effect": func(is_success:bool) -> void:
									pass,
							},
							{
								"show": true,
								"title": "Option B",
								"success_from": RESOURCE.METRICS.SAFETY,
								"story": func(is_success:bool) -> Array: 
									return [
										"Option B success."
									] if is_success else [
										"Option B fails."
									],
								"effect": func(is_success:bool) -> void:
									pass,					
							},
							{
								"show": true,
								"title": "Option C",
								"success_from": RESOURCE.METRICS.READINESS,
								"story": func(is_success:bool) -> Array: 
									return [
										"Option C success."
									] if is_success else [
										"Option C fails."
									],
								"effect": func(is_success:bool) -> void:
									pass,
							}
					],
			},
		}
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

	template_copy.name = "SCP-T-%s" % [str(0,ref + 1) if ref + 1 < 10 else ref + 1]


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

# ---------------------------------------------	FOR EVENTS
enum OPTION {CURRENCY}

var option_selected:Dictionary = {"store": null}

func onSelected(item:Dictionary) -> void: 
	option_selected.store = item

func getSelectedOption() -> Dictionary:
	return option_selected.store.option

func getSelectedIndex() -> int:
	return option_selected.store.index

func getSelectedVal():
	return option_selected.store.option.val
	
func build_option(dict:Dictionary = {}) -> Dictionary:
	var title:String = dict.title if "title" in dict else ""
	var change:Dictionary = dict.change if "change" in dict else {}
	var description_list:Array = []
	var is_locked:bool = false
	var onSelectedChild:Callable = onSelected
	
	for type in change:
		match type:
			OPTION.CURRENCY:
				var arr:Array = []
				for key in change[type]:
					var details:Dictionary = RESOURCE_UTIL.return_currency(key)
					var amount:int = change[type][key]
					if amount != 0:
						var description:String = "WILL %s [%s] %s." % ["CONSUME" if amount < 0 else "GAIN", absi(amount), details.name]
						description_list.push_back({
							"text": description, 
							"font_color": Color.RED if amount < 0 else Color.GREEN
						})
						
						if amount > resources_data[key].amount and !is_locked:
							is_locked = true
							
						arr.push_back(func() -> void: 
							#resources_data[key].capacity
							resources_data[key].amount = U.min_max(resources_data[key].amount + amount, 0, 999999))
					
					onSelectedChild = func(item:Dictionary) -> void:
						option_selected.store = item
						for arr_item in arr:
							arr_item.call()
						SUBSCRIBE.resources_data = resources_data

	if title.is_empty():
		title = "DO NOTHING"
		description_list = []
	
	return 	{
		"include": true,
		"title": title,
		"description_list": description_list, 
		"locked": is_locked,
		"val": true,
		"onSelected": onSelectedChild
	}
	
# ---------------------------------------------
