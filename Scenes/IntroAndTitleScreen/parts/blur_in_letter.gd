extends PanelContainer

@onready var LetterLabel:Label = $SubViewport/Label

@export var text:String = "" : 
	set(val):
		text = val
		on_text_update()

var default_pos:int

func _ready() -> void:
	default_pos = LetterLabel.position.y
	modulate = Color(1, 1, 1, 0)
	on_text_update()

func start() -> void:
	LetterLabel.position.y = default_pos
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.1)
	U.tween_range(1.0, 0.0, 0.4, func(val:float) -> void:
		var label_settings:LabelSettings = LetterLabel.label_settings.duplicate()
		label_settings.outline_color = Color(val, val, val, 1)
		LetterLabel.label_settings = label_settings
	) 			
	await U.set_timeout(0.05)
	
func end() -> void:
	U.tween_range(0.0, 1.0, 0.3, func(val:float) -> void:
		var label_settings:LabelSettings = LetterLabel.label_settings.duplicate()
		label_settings.outline_color = Color(val, val, val, 1)
		LetterLabel.label_settings = label_settings
	) 
	await U.set_timeout(0.05)
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 0), 0.3)

	U.tween_node_property(LetterLabel, "position:y", LetterLabel.position.y - 5, 0.3)	

	

func on_text_update() -> void:
	if !is_node_ready():return
	LetterLabel.text = text
