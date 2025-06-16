extends PanelContainer

@onready var VList:PanelContainer = $HBoxContainer/ScrollContainer2/PanelContainer/MarginContainer/VList
@onready var DetailsListContainer:VBoxContainer = $HBoxContainer/ScrollContainer/ModContentContainer/MarginContainer/VBoxContainer/VBoxContainer/DetailsListContainer

@onready var DescriptionContainer:PanelContainer = $HBoxContainer/ScrollContainer/ModContentContainer/MarginContainer/VBoxContainer/VBoxContainer/DescriptionContainer
@onready var DetailTitle:Label = $HBoxContainer/ScrollContainer/ModContentContainer/MarginContainer/VBoxContainer/VBoxContainer/DescriptionContainer/MarginContainer/VBoxContainer/DetailTitle
@onready var DetailDescription:Label = $HBoxContainer/ScrollContainer/ModContentContainer/MarginContainer/VBoxContainer/VBoxContainer/DescriptionContainer/MarginContainer/VBoxContainer/DetailDescription
@onready var SaveBtn:PanelContainer = $HBoxContainer/ScrollContainer/ModContentContainer/MarginContainer/VBoxContainer/VBoxContainer/SaveContainer/MarginContainer/HBoxContainer/SaveBtn

const ModComponentDetailPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Apps/ModApp/parts/ModComponentDetail.tscn")

var not_new:Array = [] : 
	set(val):
		not_new = val
		on_not_new_update()

var mods_data:Array = [] : 
	set(val):
		var new_mods_data = val.map(func(data):
			for item in data.items:
				item.is_new = check_if_new
				item.onClick = func(data:Dictionary) -> void:
					mark_as_old.call(data)
					on_click.call(data)
			return data
		)
		mods_data = val 
		on_mods_data_update()

var on_marked:Callable = func(data:Array):pass

var on_data_changed:Callable = func(new_state:Array):pass
var on_click:Callable = func(data:Dictionary):pass

# ------------------------------------------------------------
func _ready() -> void:
	on_mods_data_update()
	
	VList.on_list_focus_change = func(state:bool) -> void:
		DescriptionContainer.show() if state else DescriptionContainer.hide()
	
	VList.on_item_focus_change = func(state:bool, data:Dictionary) -> void:
		if state:
			var details:Dictionary = data.get_details.call()
			DetailTitle.text = details.title
			DetailDescription.text = details.description
			
	VList.on_data_changed = func(new_state) -> void:		
		on_data_changed.call(new_state)	
		
	SaveBtn.onClick = on_save_data
# ------------------------------------------------------------

# ------------------------------------------------------------
func on_save_data() -> void:
	var save_arr:Array = mods_data.map(func(i): return {
		"ref": i.ref,
		"selected": i.selected,
	})
	GBL.find_node(REFS.OS_LAYOUT).update_mod_settings(save_arr)
# ------------------------------------------------------------
	

# ------------------------------------------------------------
func on_not_new_update() -> void:	
	on_marked.call(not_new)
# ------------------------------------------------------------
	
# ------------------------------------------------------------
func on_mods_data_update() -> void:
	if is_node_ready():
		VList.data = mods_data
		game_settings_update()
# ------------------------------------------------------------

# ------------------------------------------------------------
func mark_as_old(data:Dictionary) -> void:
	var id_str:String = str(data.parent_index, data.index)
	if id_str not in not_new:
		not_new.push_back(id_str)
		not_new = not_new
		VList.data = mods_data
# ------------------------------------------------------------

# ------------------------------------------------------------
func check_if_new(data:Dictionary) -> bool:
	var id_str:String = str(data.parent_index, data.index)
	return id_str not in not_new
# ------------------------------------------------------------
	
# ------------------------------------------------------------
func game_settings_update() -> void:
	if is_node_ready():
		for child in DetailsListContainer.get_children():
			child.queue_free()
	
		for mod in mods_data:
			var section:String = mod.section
			var selected:Array = mod.selected
			
			var selected_as_string:String = ""
			for n in mod.items.size():
				if n in selected:
					var item_detail:Dictionary = mod.items[n].get_details.call()
					selected_as_string = selected_as_string + item_detail.title
			
			var new_node:Control = ModComponentDetailPreload.instantiate()
			new_node.data = {
				"title": section,
				"val": selected_as_string
			}
			DetailsListContainer.add_child(new_node)
# ------------------------------------------------------------
