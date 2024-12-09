extends HBoxContainer

@onready var TitleLabel:Label = $Label
@onready var ValLabel:Label = $ValLabel

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_data_update()


func on_data_update() -> void:
	if is_node_ready():
		TitleLabel.text = data.title + ": "
		ValLabel.text = str(data.val)
