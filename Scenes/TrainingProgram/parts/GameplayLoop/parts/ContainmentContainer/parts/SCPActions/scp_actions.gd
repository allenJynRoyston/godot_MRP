extends PanelContainer

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

func _ready() -> void:
	on_data_update()

func on_data_update() -> void:
	if !is_node_ready():return
	if data.is_empty():
		pass
