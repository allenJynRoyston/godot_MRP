extends Control
class_name ControlPanel

@onready var RootPanel:Control

var data:Dictionary = {} : 
	set(val):		
		var previous_state = data.duplicate()
		data = val
		on_data_update(previous_state)

var is_active:bool = false : 
	set(val):
		if is_active != val:
			is_active = val
			if(!val):
				on_inactive()
			else:
				on_active()
			on_is_active_updated()
			

# -----------------------------------
func _ready() -> void:
	on_is_active_updated()
# -----------------------------------

# -----------------------------------
func on_data_update(_previous_state:Dictionary) -> void:pass
func on_inactive() -> void:	pass
func on_active() -> void: pass
# -----------------------------------	

# -----------------------------------
func on_is_active_updated() -> void:
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = "5531b8" if is_active else "3a3a3a"
	if RootPanel != null:
		RootPanel.add_theme_stylebox_override("panel", new_stylebox)
# -----------------------------------
			
