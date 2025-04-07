extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var NameLabel:Label = $MarginContainer/HBoxContainer/NameLabel
@onready var CanBuild:Label = $MarginContainer/HBoxContainer/CanBuild

var data:Dictionary = {} : 
	set(val):		
		data = val
		on_data_update()
		
var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()

var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()

var resources:Dictionary : 
	set(val): 
		resources = val
		on_data_update()

# ------------------------------------
func _ready() -> void:
	on_data_update()
	on_is_active_update()
# ------------------------------------

# ------------------------------------
func on_data_update() -> void:
	if data.is_empty() or resources.is_empty() or !is_node_ready():return
	var ref_data:Dictionary = C.get_reference_data(data.item)
	
	NameLabel.text = "%s" % [ref_data.name]

	var has_enough_resources:bool = true
	for item in ref_data.required_resources:
		var key:int = item[0]
		var amount:int = item[1]		
		if resources[key].total  < amount:
			has_enough_resources = false
			break
	
	if !is_selected:
		CanBuild.text = "  ✅" if has_enough_resources else " ❌"
# ------------------------------------

# ------------------------------------
func on_is_selected_update() -> void:
	if !is_selected:
		on_data_update()
		return
		
	CanBuild.text = "  🛍️" 
# ------------------------------------	

# ------------------------------------
func on_is_active_update() -> void:
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = "ec6781" if is_active else "3a3a3a"
	if RootPanel != null:
		RootPanel.add_theme_stylebox_override("panel", new_stylebox)
# ------------------------------------
