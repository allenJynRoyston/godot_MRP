extends PanelContainer

@onready var ListContainer:VBoxContainer = $MarginContainer/PanelContainer/MarginContainer/ListContainer

const InstallerItemPreload:PackedScene = preload("res://Scenes/OSRoot/parts/OS/Installer/parts/InstallerItem.tscn")

# ----------------------------------------
func add_item(data:Dictionary = {}) -> void:
	var layout_node:Control = GBL.find_node(REFS.OS_LAYOUT)
	#if !is_node_ready() or (data.ref in layout_node.apps_installing) or (data.ref in layout_node.apps_installed): return
	layout_node.installing_app_start(data.ref)
	var new_node:Control = InstallerItemPreload.instantiate()
	new_node.duration = data.duration
	new_node.filename = data.filename
	new_node.ref = data.ref
	ListContainer.add_child(new_node)	
# ----------------------------------------
