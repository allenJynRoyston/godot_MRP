extends PanelContainer
class_name AppWrapper 

var is_paused:bool = false
var in_fullscreen:bool = false
var taskbar_is_open:bool = false : 
	set(val):
		taskbar_is_open = val
		on_taskbar_is_open_update(taskbar_is_open)
		
var options:Dictionary = {}
var events:Dictionary = {}
var details:Dictionary = {}
		
# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_fullscreen(self)
	
func _exit_tree() -> void:
	GBL.unsubscribe_to_fullscreen(self)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func pause() -> void:
	pass
	
func unpause() -> void:
	pass
	
func on_taskbar_is_open_update(_state:bool) -> void:
	pass
	
func force_save_and_quit() -> void:
	pass

func on_fullscreen_update(state:bool) -> void:
	pass
# ------------------------------------------------------------------------------		
