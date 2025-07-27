@tool
extends PanelContainer

@onready var Splash:Control = $Splash
@onready var BtnControls:Control = $BtnControls
@onready var FadeOut:ColorRect = $ColorRect2
@onready var RiskLabel:Label = $CenterContainer/VBoxContainer/HBoxContainer/RiskLabel

var time:float = 0.0
var speed:float = 5.0  

signal on_complete

# --------------------------------
func _ready() -> void:
	modulate = Color(1, 1, 1, 1 if Engine.is_editor_hint() else 0)
	FadeOut.modulate = Color(1, 1, 1, 0)
	BtnControls.reveal(false)
	BtnControls.onAction = func() -> void:
		end()
		

func start() -> void:
	await Splash.activate()
	Splash.start(true, 0.5, 0.3)
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.7, 0.5)
	await U.set_timeout(1.0)
	BtnControls.reveal(true)
	
func end() -> void:
	Splash.end()	
	BtnControls.reveal(false)
	await U.tween_node_property(RiskLabel, 'modulate', Color(1, 0, 0, 1), 1.0)
	#await U.set_timeout(0.3)
	#await U.tween_node_property(FadeOut, "modulate", Color(1, 1, 1, 1), 0.7)
	#await U.set_timeout(1.0)
	on_complete.emit()
	queue_free()	
# --------------------------------
