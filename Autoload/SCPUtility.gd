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
	"quote":  func(scp_details:Dictionary) -> String:
		return "%s" % scp_details.name,
	"img_src": "res://Media/images/redacted.png",			# image reference
	# -----------------------------------

	# -----------------------------------
	"containment_requirements": [
		#SCP.CONTAINMENT_TYPES.PHYSICAL
	],
	# -----------------------------------	
	
	# -----------------------------------
	"influence": {
		"description": "FACILITIES built here will be influence BY an SCP."
	},

	"effect": {
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

# -----------------------------------------------------------
func is_scp_in_containment(scp_details:Dictionary) -> bool:
	return scp_details.ref in scp_data
# -----------------------------------------------------------	

# -----------------------------------------------------------	
func force_move_location(old_location:Dictionary, new_location:Dictionary) -> void:
	for ref in scp_data:
		if scp_data[ref].location == old_location:
			scp_data[ref].location = new_location
	SUBSCRIBE.scp_data = scp_data
# -----------------------------------------------------------	
