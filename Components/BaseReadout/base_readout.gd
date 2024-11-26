extends PanelContainer

@onready var RootPanel = $"."
@onready var LevelLabel = $MarginContainer/VBoxContainer/LevelLabel
@onready var ListContainer = $MarginContainer/VBoxContainer/ListContainer

var is_active:bool = false : 
	set(val):
		if is_active != val:
			is_active = val
			update_panel()
		
var on_floor:int = -1 : 
	set(val):
		on_floor = val
		LevelLabel.text = "On level: %s" % [on_floor]
		update_list()
		
var data:Dictionary = {} : 
	set(val):
		data = val
		update_list()

# -----------------------------------
func _ready() -> void:
	update_panel()
# -----------------------------------

# -----------------------------------
func update_list() -> void:
	if (data.is_empty() or on_floor == -1) or (on_floor not in data): 
		return
	
	for child in ListContainer.get_children():
		child.queue_free()
	
	for item in data[on_floor]:
		var newLabel = Label.new()
		newLabel.text = item
		ListContainer.add_child(newLabel)
# -----------------------------------

# -----------------------------------
func update_panel() -> void:
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = "5531b8" if is_active else "3a3a3a"
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)
# -----------------------------------
