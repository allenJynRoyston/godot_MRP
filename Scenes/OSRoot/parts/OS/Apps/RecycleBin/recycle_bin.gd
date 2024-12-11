extends AppWrapper

@onready var VList:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VList
@onready var EmailComponent = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/EmailComponent

var in_bin_list:Array = [] :
	set(val):
		in_bin_list = app_props.app_data.filter(func(item): return item.ref in val)
		on_bin_list_update()


# ------------------------------------------------------------------------------
func _ready() -> void:
	WindowUI = $WindowUI
	super._ready()	
	
	in_bin_list = app_props.in_bin
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func on_bin_list_update() -> void:
	var layout_node:Control = GBL.find_node(REFS.OS_LAYOUT)

	var items:Array = in_bin_list.map(func(item):
		return {
			"get_details": func():
				return {
					"title": item.title,
					"icon": item.icon,
					"ref": item.ref,
					"bin_node": self,
				},
			"onClick": func(data:Dictionary):
				layout_node.on_bin_restore(data),
			"render_if": func(data:Dictionary):
				return true,
		}
	)
	
	var recycle_bin_list:Array[Dictionary] = [
		{
			"section": "Restore",
			"opened": true,
			"items": items
		},
	]

	VList.data = recycle_bin_list
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func update_bin(in_recycle_bin:Array) -> void:
	in_bin_list = in_recycle_bin
# ------------------------------------------------------------------------------	
