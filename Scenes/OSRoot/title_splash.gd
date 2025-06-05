extends PanelContainer

@onready var TitleHeader:Control = $MarginContainer/VBoxContainer/TitleHeader

func _ready() -> void:
	modulate = Color(1, 1, 1, 0)

func start(duration:float = 100.0) -> void:
	await U.tick()
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.7, 0.5)
	await U.set_timeout(duration)
	queue_free()
	
var time := 0.0
var speed := 5.0  # Increase this value to flash faster

func _process(delta: float) -> void:
	time += delta
	var value := (sin(time * speed) + 1.2) / 2.0  # Oscillates smoothly between 0 and 1
	TitleHeader.modulate = Color(1, 0, 0, value)
