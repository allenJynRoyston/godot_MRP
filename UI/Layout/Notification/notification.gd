extends PanelContainer

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_data_update()

func on_data_update() -> void:
	if data.is_empty():
		hide()
		return
	
	show()
