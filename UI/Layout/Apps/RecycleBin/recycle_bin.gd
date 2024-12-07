extends AppWrapper

@onready var VList:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VList
@onready var EmailComponent = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/EmailComponent


# ------------------------------------------------------------------------------
func _ready() -> void:
	WindowUI = $WindowUI
	super._ready()	
	
	var layout_node:Control = GBL.find_node(REFS.OS_LAYOUT)
	var in_bin:Array = app_props.in_bin
	
	var in_bin_list:Array = app_props.app_data.filter(func(item): return item.ref in in_bin)
	in_bin_list = in_bin_list.map(func(item):
		return {
			"get_details": func():
				return {
					"title": item.title,
					"icon": item.icon,
					"ref": item.ref,
					"bin_node": self,
				},
			"onClick": func(data:Dictionary):
				layout_node.onBinRestore(data),
			"render_if": func():
				return true,
		}
	)
	
	var recycle_bin_list:Array[Dictionary] = [
		{
			"section": "Contents",
			"opened": true,
			"items": in_bin_list
		},
	]

	VList.data = recycle_bin_list

# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_bin() -> void:
	print("here")
# ------------------------------------------------------------------------------	
