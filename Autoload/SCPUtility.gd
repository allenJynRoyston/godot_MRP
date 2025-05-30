extends SubscribeWrapper

const prefered_greeting:String = "Sir"
const dlc_folder:String = "res://_DLC/"

var reference_data:Dictionary = {}
var reference_list:Array = []

enum ITEM_CLASS {SAFE, EUCLID, KETER}

var SCP_TEMPLATE:Dictionary = {
	# -----------------------------------
	"name": "",											# assigned when generated
	"nickname": "NICKNAME",								# whatever the nickname of it will be
	"description": "Description",						# description of what it is
	"img_src": "res://Media/images/redacted.png",		# image reference
	# -----------------------------------
	
	# -----------------------------------	
	"item_class": ITEM_CLASS.SAFE,  					# assigned when generated, could be SAFE/EUCLID/KETER, 
														# acts as multipler for rewards
	"pairs_with": {										# asssigned when generated
		"specilization": null,							# must be a specilization (ENGINEER, BIOLOGIST, etc).  Can only be one.  DOUBLES rewards if researcher has assigned spec.
		"trait": null,									# must be a trait (HAPPY, SAD, etc).  Can only be one.  1.5x reward if researcher has assigned trait.
	},													
	"breach_events_at": [],								# assigned when generated, based off item_class
	# -----------------------------------	
	
	# ------------------------------------------
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 0,
		RESOURCE.CURRENCY.SCIENCE: 0,
		RESOURCE.CURRENCY.MATERIAL: 0,
		RESOURCE.CURRENCY.CORE: 0
	},
	# ------------------------------------------
	
	# ------------------------------------------
	"metrics": {
		RESOURCE.METRICS.MORALE: 0,
		RESOURCE.METRICS.SAFETY: 0,
		RESOURCE.METRICS.READINESS: 0,
	},	
	# ------------------------------------------
	
	## -----------------------------------
	#"scenario_data":{
		## STARTING SCP (or tutorial scp)
		#"contain_order": [0],  
		## rewards gained after winning
		#"reward": [],
		## objectives and their respective checks
		#"objectives": [
			#{
				#"title": "Build a HQ", 
				#"is_completed":func() -> bool:
					#return ROOM_UTIL.owns_and_is_active(ROOM.TYPE.HQ),
			#},
		#],
		## limit to scenario
		#"day_limit": 3,
	#},
	## -----------------------------------	

	# -----------------------------------
	"effects": {
		"description": "Makes all personnel resources available for the wing.", 
		"personnel": {
			RESOURCE.PERSONNEL.TECHNICIANS: true,
			RESOURCE.PERSONNEL.STAFF: true,
			RESOURCE.PERSONNEL.SECURITY: true,
			RESOURCE.PERSONNEL.DCLASS: true
		},
		#"before": func(new_room_config:Dictionary, location:Dictionary) -> Dictionary:
			#var ring_config_data:Dictionary = new_room_config.floor[location.floor].ring[location.ring]
			#ring_config_data.personnel = {
				#RESOURCE.PERSONNEL.TECHNICIANS: true,
				#RESOURCE.PERSONNEL.STAFF: true,
				#RESOURCE.PERSONNEL.SECURITY: true,
				#RESOURCE.PERSONNEL.DCLASS: true
			#}
			#return new_room_config,
	},
	# -----------------------------------

	# -----------------------------------
	"events": {
		# -------------------------
		SCP.EVENT_TYPE.AFTER_CONTAINMENT: func(scp_details:Dictionary, props:Dictionary) -> Array:
			var passes_metric_check:bool = true #SCP_UTIL.passes_metric_check(scp_details.ref, props.use_location)
			var dict:Dictionary = {
				"title": "PASSED METRIC CHECK.",
				"change": {
					OPTION.CURRENCY: {
						RESOURCE.CURRENCY.MONEY: -100,
					}
				} 
			} if passes_metric_check else {
				"title": "FAILED METRIC CHECK.",
				"change": {}
			}
			
			return [
					# --------------------
					func() -> Dictionary:
						return {
							"header": "CONTAINMENT EVENT",
							"img_src": scp_details.img_src,
							"text": [
								"I pass the metric test" if passes_metric_check else "I did NOT pass the metrics test."
							],
							"options": [
								build_option(),
								build_option(dict),
							]
						},
					# --------------------
					
					# --------------------
					func() -> Dictionary:
						print(getSelectedOption())
						return {
							"text": [
								"You last selected index [%s]." % [getSelectedIndex()],
								"The value was [%s]." % [getSelectedVal()]
							],
						},
					# --------------------
			],
		# -------------------------
		
		# -------------------------
		SCP.EVENT_TYPE.WARNING: func(scp_details:Dictionary, props:Dictionary) -> Array:
			var passes_metric_check:bool = SCP_UTIL.passes_metric_check(scp_details.ref, props.use_location)
			print("props.event_count: ", props.event_count)
			
			
			match props.event_count:
				0:
					# --------------------
					return [
							# --------------------
							func() -> Dictionary:
								return {
									"header": "WARNING 1",
									"img_src": scp_details.img_src,
									"text": [
										"The door begins to hum at an alarming frequency."
									]
								},
							# --------------------
					]
					# --------------------
				1:
					# --------------------
					return [
							# --------------------
							func() -> Dictionary:
								return {
									"header": "WARNING 2",
									"img_src": scp_details.img_src,
									"text": [
										"The door begins to hum at an alarming frequency."
									]
								},
							# --------------------
					]
					# --------------------
			# --------------------
			return [
					# --------------------
					func() -> Dictionary:
						return {
							"header": "WARNING 3",
							"img_src": scp_details.img_src,
							"text": [
								"The door begins to hum at an alarming frequency."
							]
						},
					# --------------------
			],
			# --------------------
		# -------------------------
		
		# -------------------------
		SCP.EVENT_TYPE.BREACH_EVENT: func(scp_details:Dictionary, props:Dictionary) -> Array:
			var passes_metric_check:bool = SCP_UTIL.passes_metric_check(scp_details.ref, props.use_location)
			print("passes_metric_check: ", passes_metric_check)
						
			match props.event_count:
				# --------------------
				0:
					return [
							# --------------------
							func() -> Dictionary:
								return {
									"header": "BREACH EVENT",
									"img_src": scp_details.img_src,
									"text": [
										"The door flings open and a swarm of shadows seep out."
									]
								},
							# --------------------
					]
				# --------------------
				1:
					return [
							# --------------------
							func() -> Dictionary:
								return {
									"header": "BREACH EVENT",
									"img_src": scp_details.img_src,
									"text": [
										"The door flings open and a swarm of shadows seep out."
									]
								},
							# --------------------
					]
				# --------------------
			
			# --------------------
			return [
					# --------------------
					func() -> Dictionary:
						return {
							"header": "BREACH EVENT",
							"img_src": scp_details.img_src,
							"text": [
								"The door flings open and a swarm of shadows seep out."
							]
						},
					# --------------------
			],
			# --------------------
		# -------------------------	
		},
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
var spec_count:int = 0
var trait_count:int = 0
func fill_template(data:Dictionary, ref:int) -> void:
	var template_copy:Dictionary = SCP_TEMPLATE.duplicate(true)		
	# assign "name"
	template_copy.name = "SCP-X-%s" % [str(0,ref + 1) if ref + 1 < 10 else ref + 1]
	
	# replace any matching keys
	for key in data:
		var value = data[key]
		if key in template_copy:
			template_copy[key] = value
			
	# generate the following properties
	if ref % 2 == 0:
		template_copy.item_class = ITEM_CLASS.SAFE 
		template_copy.breach_events_at = [ref * 1, ref * 2, ref * 3]
	else:
		template_copy.item_class = ITEM_CLASS.EUCLID
		template_copy.breach_events_at = [ref * 1, ref * 2, ref * 3]

	if ref % 3 == 0:
		template_copy.item_class = ITEM_CLASS.KETER
		template_copy.breach_events_at = [ref * 1, ref * 2, ref * 3]
	
	# now assign it a deterministic spec/trait
	template_copy.pairs_with = {
		"specilization": [], 		# spec_count,# must be a specilization (ENGINEER, BIOLOGIST, etc).  Can only be one.  DOUBLES rewards if researcher has assigned spec.
		"trait": []					#trait_count,		
	}
	
	# deterministically determine which item gets rewarded what
	var amount:int = 0
	match template_copy.item_class:
		ITEM_CLASS.SAFE:
			amount = 1
		ITEM_CLASS.EUCLID:
			amount = 2
		ITEM_CLASS.KETER:
			amount = 3 
	
	var matched:bool = false
	if ref % 2 == 0:
		template_copy.currencies[RESOURCE.CURRENCY.MONEY] = 10
		matched = true
	else:
		template_copy.currencies[RESOURCE.CURRENCY.MATERIAL] = 10
		matched = true
		
	if ref % 3 == 0 and !matched:
		template_copy.currencies[RESOURCE.CURRENCY.SCIENCE] = 10
		matched = true

	template_copy.metrics = {
		RESOURCE.METRICS.MORALE: -1,
		RESOURCE.METRICS.SAFETY: -2,
		RESOURCE.METRICS.READINESS: -3,
	}

	reference_list.push_back(ref)
	reference_data[ref] = template_copy
	
	spec_count += 1
	if spec_count > RESEARCHER.SPECIALIZATION.size() - 1:
		spec_count = 0
	
	trait_count += 1
	if trait_count > RESEARCHER.TRAITS.size() - 1:
		trait_count = 0
	
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
func check_for_pairing(ref:int, researchers:Array) -> Dictionary:
	var scp_details:Dictionary = return_data(ref)
	var match_spec:bool = false
	var match_trait:bool = false
	
	for researcher in researchers:
		if !match_spec and (scp_details.pairs_with.specilization in researcher.specializations):
			match_spec = true
		if !match_trait and (scp_details.pairs_with.trait in researcher.traits):
			match_trait = true
	
	return {
		"match_spec": match_spec,
		"match_trait": match_trait,
		
	}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_ongoing_containment_rewards(ref:int) -> Array:
	var scp_details:Dictionary = return_data(ref)
	var list:Array = []

	for key in scp_details.containment_reward:	
		var amount:int = scp_details.containment_reward[key]
		list.push_back({"amount": amount, "resource": RESOURCE_UTIL.return_currency(key)})		
					
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
#func calculate_refunded_utilizied(utilized_data:Dictionary, resources_data:Dictionary) -> Dictionary:
	#var resource_data_copy:Dictionary = resources_data.duplicate(true)
	#for key in utilized_data:
		#resource_data_copy[key].utilized -= utilized_data[key]
		#resource_data_copy[key].amount += utilized_data[key]
		#if resource_data_copy[key].amount > resources_data[key].capacity:
			#resource_data_copy[key].amount = resources_data[key].capacity
	#
	#return resource_data_copy
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
