extends PanelContainer

@onready var TitleHeader:Control = $MarginContainer/VBoxContainer/TitleHeader
@onready var EnterBtn:BtnBase = $MarginContainer/VBoxContainer/KeyBtn

signal on_complete

func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	EnterBtn.modulate = Color(1, 1, 1, 0)
	EnterBtn.onClick = func() -> void:
		on_complete.emit()
		queue_free()

func start() -> void:
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.7, 0.5)
	await U.set_timeout(2.0)
	U.tween_node_property(EnterBtn, "modulate", Color(1, 1, 1, 1), 0.3)
	
	
	
var time := 0.0
var speed := 5.0  # Increase this value to flash faster

func _process(delta: float) -> void:
	time += delta
	var value := (sin(time * speed) + 1.2) / 2.0  # Oscillates smoothly between 0 and 1
	TitleHeader.modulate = Color(1, 0, 0, value)
