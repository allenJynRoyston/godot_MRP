extends PanelContainer

@onready var TitleHeader:Control = $MarginContainer/VBoxContainer/TitleHeader
@onready var EnterBtn:BtnBase = $MarginContainer/VBoxContainer/KeyBtn
@onready var FadeOut:ColorRect = $ColorRect2

var time:float = 0.0
var speed:float = 5.0  

signal on_complete

# --------------------------------
func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	FadeOut.modulate = Color(1, 1, 1, 0)
	EnterBtn.modulate = Color(1, 1, 1, 0)
	EnterBtn.onClick = func() -> void:
		end()

func start() -> void:
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.7, 0.5)
	await U.set_timeout(2.0)
	U.tween_node_property(EnterBtn, "modulate", Color(1, 1, 1, 1), 0.3)
	
func end() -> void:
	EnterBtn.is_disabled = true
	await U.tween_node_property(FadeOut, "modulate", Color(1, 1, 1, 1), 0.7)
	await U.set_timeout(1.0)
	on_complete.emit()
	queue_free()	
# --------------------------------

# --------------------------------		
func _process(delta: float) -> void:
	time += delta
	var value := (sin(time * speed) + 1.2) / 2.0  # Oscillates smoothly between 0 and 1
	TitleHeader.modulate = Color(1, 0, 0, value)
# --------------------------------
