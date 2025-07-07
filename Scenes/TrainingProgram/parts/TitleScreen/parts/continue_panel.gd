extends Control

@onready var DetailName:Label = $ContinueDetails/MarginContainer/VBoxContainer/DetailName
@onready var DetailDay:Label = $ContinueDetails/MarginContainer/VBoxContainer/DetailDay
@onready var DetailDate:Label = $ContinueDetails/MarginContainer/VBoxContainer/DetailDate

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

func _ready() -> void:
	modulate = Color(1, 1, 1, 1 if Engine.is_editor_hint() else 0)
	on_data_update()
	
func on_data_update() -> void:
	if !is_node_ready():return
	modulate = Color(1, 1, 1, 0 if data.is_empty() else 1) 
	
	if !data.is_empty():
		var modification_date:Dictionary = data.metadata.modification_date
		var progress_data:Dictionary = data.progress_data

		DetailDay.text = "DAY %s" % progress_data.day
		DetailDate.text = "%s/%s/%s" % [modification_date.month, modification_date.day, modification_date.year]
		
