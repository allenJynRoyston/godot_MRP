extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var NameLabel:Label = $MarginContainer/HBoxContainer/NameLabel
@onready var IsContained:Label = $MarginContainer/HBoxContainer/IsContained

var data:Dictionary = {} : 
	set(val):		
		data = val
		on_data_update()
		
var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()

# ------------------------------------
func _ready() -> void:
	on_data_update()
	on_is_active_update()
# ------------------------------------

# ------------------------------------
func on_data_update() -> void:
	if data.is_empty() or !is_node_ready():return
	var ref_data:Dictionary = C.get_reference_data(data.item)

	NameLabel.text = "%s (%s)" % [ref_data.name, data.status.days_in_containment]
	
	IsContained.text = "  🔒" if data.status.is_contained else " ⚠️"
# ------------------------------------

# ------------------------------------
func on_is_active_update() -> void:
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = "ec6781" if is_active else "3a3a3a"
	if RootPanel != null:
		RootPanel.add_theme_stylebox_override("panel", new_stylebox)
# ------------------------------------
